---
date: 2026-02-17
tags:
  - schema
  - design
  - booking
  - v3
  - simplified
---

# Bizing Booking System: Schema Design v3.0

> Simplified, production-ready schema focusing on core features with extensibility hooks

---

## Design Philosophy

**v3.0 Principles:**
1. **Simplicity First** — Start minimal, add complexity only when needed
2. **Extensibility** — Leave hooks for future features without over-engineering
3. **Family/Group Support** — Household accounts for clients AND providers (companies)
4. **Product + Service** — Simple product integration for upsells
5. **No Over-Engineering** — AI, hybrid modes, real-time, theming deferred

---

## Core Entity Model

```
Organization
├── Locations[]
│   └── Bookables[] (Provider/Asset/Venue)
│       └── Individual Calendars
├── ServiceTemplates[] (Blueprints)
│   ├── RequiredBookables[]
│   ├── Pricing Rules
│   └── Cancellation Policy
├── Products[] (Simple catalog)
└── Bookings[]
    ├── Participants[]
    ├── AssignedBookables[]
    └── ProductItems[]

Household (for families/groups)
├── Members[] with permissions
└── Shared payment methods

User
├── Profile
├── Memberships (can belong to multiple orgs)
└── Household memberships
```

---

## 1. Organization & Hierarchy (Simplified)

```typescript
interface Organization {
  id: UUID
  slug: string
  name: string
  type: 'individual' | 'small_business' | 'enterprise'
  
  // Feature flags (simplified)
  features: {
    waitlistEnabled: boolean
    recurringBookings: boolean
    multiDayBookings: boolean
    paymentProcessing: boolean
    productsEnabled: boolean
  }
  
  // Config (can be overridden at location level)
  defaultConfig: {
    timezone: string
    currency: string
    cancellationPolicy: CancellationPolicy
  }
  
  // Note: Multi-brand/franchise deferred to v4
  // parentOrgId?: UUID  // For future hierarchy
  // brandId?: UUID      // For future white-label
  
  createdAt: Timestamp
  updatedAt: Timestamp
  deletedAt?: Timestamp  // Soft delete
}

interface Location {
  id: UUID
  organizationId: UUID
  // parentLocationId?: UUID  // Defer: For chains/franchises
  
  name: string
  type: 'physical' | 'virtual' | 'mobile'
  
  address?: {
    street: string
    city: string
    state: string
    zip: string
    country: string
    coordinates?: { lat: number; lng: number }
  }
  
  timezone: string
  
  // Operating hours (can be overridden by bookable)
  operatingHours: {
    [day: string]: { start: string; end: string }[]  // "monday": [{"09:00", "17:00"}]
  }
  
  // Config override (inherits from org if null)
  configOverride?: Partial<Organization['defaultConfig']>
  
  // For mobile services
  serviceArea?: {
    type: 'radius'
    radius: number  // miles
    center: { lat: number; lng: number }
  }
  
  status: 'active' | 'inactive'
  isSoftDeleted: boolean
}
```

---

## 2. User Management (Better-Auth + Households)

```typescript
interface User {
  // Better-Auth core
  id: UUID
  email: string
  emailVerified: boolean
  name: string
  phone?: string
  image?: string
  
  // Household memberships (customer side)
  householdMemberships: HouseholdMember[]
  
  // Organization memberships (provider/staff side)
  orgMemberships: OrgMembership[]
  
  // Preferences
  preferences: {
    timezone: string
    locale: string
    notifications: {
      email: boolean
      sms: boolean
    }
  }
  
  createdAt: Timestamp
  updatedAt: Timestamp
}

// ORGANIZATION MEMBERSHIPS (Provider/Staff side)
interface OrgMembership {
  id: UUID
  userId: UUID
  organizationId: UUID
  
  // Role
  role: 'owner' | 'admin' | 'manager' | 'staff' | 'provider'
  
  // Scope
  locationIds?: UUID[]  // null = all locations
  
  // Provider link (if user is also a bookable provider)
  // Note: A provider can be an individual OR a company (household)
  providerId?: UUID
  
  status: 'active' | 'inactive'
  joinedAt: Timestamp
}

// HOUSEHOLD (Family/Group - Customer side)
interface Household {
  id: UUID
  name: string                    // "Smith Family" or "ABC Corp"
  type: 'family' | 'company' | 'group'  // Company = provider household
  
  // Members
  members: HouseholdMember[]
  
  // Primary contact
  primaryContactId: UUID
  
  // Shared resources
  sharedPaymentMethods: PaymentMethod[]
  
  // For company-type households (providers)
  companyInfo?: {
    taxId?: string
    industry?: string
    website?: string
  }
  
  createdAt: Timestamp
}

interface HouseholdMember {
  id: UUID
  householdId: UUID
  userId: UUID
  
  role: 'primary' | 'adult' | 'minor' | 'dependent'
  
  // Permissions
  permissions: {
    canBookForOthers: boolean      // Can book for other household members
    canViewOthersBookings: boolean
    canModifyOthersBookings: boolean
    approvalRequiredFor?: 'all' | 'expensive_only' | 'none'
  }
  
  // For dependents
  managedBy: UUID[]               // Who manages this member
  
  relationship?: 'spouse' | 'child' | 'parent' | 'sibling' | 'guardian' | 'dependent' | 'employee'
  
  // For minors/dependents
  dateOfBirth?: Date
  
  joinedAt: Timestamp
}

// ROLE PERMISSIONS (Simplified RBAC)
const RolePermissions = {
  owner: ['*'],  // All permissions
  admin: ['org:manage', 'billing:manage', 'user:manage', 'settings:manage'],
  manager: ['booking:manage_location', 'provider:manage_location', 'report:view_location'],
  staff: ['booking:view_location', 'booking:create_walkin', 'client:view'],
  provider: ['booking:view_assigned', 'availability:manage_own']
}
```

**Key Design Decision:**
- **Households work for BOTH sides:**
  - Customer side: Family bookings (parent books for child)
  - Provider side: Company as provider (ABC Plumbing Corp has multiple technicians)

---

## 3. Bookable Abstraction (Polymorphic)

```typescript
// BASE BOOKABLE
interface Bookable {
  id: UUID
  organizationId: UUID
  locationId: UUID
  
  type: 'provider' | 'asset' | 'venue' | 'company_provider'
  
  // Identity
  name: string
  description?: string
  slug: string
  
  // Classification
  categoryId?: UUID
  tags: string[]
  
  // Each bookable has its OWN calendar
  calendarId: UUID
  
  // Status
  status: 'active' | 'inactive' | 'maintenance' | 'retired'
  isSoftDeleted: boolean
  deletedAt?: Timestamp
  deletionReason?: string
  
  createdAt: Timestamp
  updatedAt: Timestamp
}

// PROVIDER (Individual)
interface Provider extends Bookable {
  type: 'provider'
  
  // Link to user (optional - can have providers without user accounts)
  userId?: UUID
  email: string
  phone?: string
  
  // Profile
  bio?: string
  specialties: string[]
  languages: string[]
  
  // Work preferences
  canWorkAtLocations: UUID[]      // Multi-location providers
  travelRadius?: number            // For mobile services
  maxDailyBookings?: number
  minRestBetweenBookings: number   // minutes
  
  // Qualifications
  certifications: Certification[]
  
  // Payment (for timesheets)
  paymentProfile: {
    hourlyRate?: number
    commissionSplit?: number      // 0.7 = 70% to provider
  }
  
  // Performance
  rating?: number
  reviewCount: number
}

// COMPANY PROVIDER (NEW in v3)
// A company that acts as a provider (e.g., "ABC Plumbing Corp")
interface CompanyProvider extends Bookable {
  type: 'company_provider'
  
  // Link to household (company-type household)
  householdId: UUID
  
  // Contact
  email: string
  phone: string
  website?: string
  
  // The actual technicians/employees are household members
  // They can be assigned to bookings individually
  availableTechnicians: UUID[]    // User IDs of household members who can service
  
  // Company-level settings
  dispatchMethod: 'auto_assign' | 'manual' | 'customer_choice'
  
  // Service area
  serviceRadius: number
  
  // Business hours (company-wide, individual techs can override)
  businessHours: OperatingHours
}

// ASSET
interface Asset extends Bookable {
  type: 'asset'
  
  assetType: 'vehicle' | 'equipment' | 'tool' | 'instrument'
  
  // Identification
  serialNumber?: string
  inventoryNumber?: string
  
  // Specs
  specifications: Record<string, any>
  
  // Maintenance (simplified - full asset mgmt deferred)
  maintenanceSchedule?: {
    everyHours?: number
    everyDays?: number
  }
  lastServicedAt?: Timestamp
  nextServiceDue?: Timestamp
  
  // Note: Full asset management (condition, usage tracking) deferred
}

// VENUE
interface Venue extends Bookable {
  type: 'venue'
  
  capacity: {
    min?: number
    max: number
  }
  
  squareFootage?: number
  amenities: string[]
  
  // Simultaneous bookings
  allowSimultaneousBookings: boolean
  maxSimultaneousBookings?: number
  
  // Setup/teardown
  defaultSetupTime: number        // minutes
  defaultTeardownTime: number     // minutes
}

// CERTIFICATION
interface Certification {
  id: UUID
  type: string                    // "cosmetology", "cpr", etc.
  issuedBy: string
  issuedAt: Timestamp
  expiresAt?: Timestamp
  documentUrl?: string
  isVerified: boolean
}
```

---

## 4. Calendar & Availability

```typescript
interface Calendar {
  id: UUID
  organizationId: UUID
  bookableId: UUID                // Each bookable has own calendar
  
  name: string
  timezone: string
  
  // Default availability pattern
  defaultPattern: {
    weeklySchedule: {
      [day: string]: TimeRange[]
    }
    slotDuration: number          // minutes
    slotInterval: number          // minutes between starts
    preBuffer: number             // minutes before
    postBuffer: number            // minutes after
    
    // Booking windows
    minAdvanceBooking: number     // hours
    maxAdvanceBooking: number     // days
  }
  
  // Cascading (simplified)
  cascading: {
    enabled: boolean
    strategy: 'sequential' | 'batch'
    initialOpenSlots: number
    premiumMultiplier?: number    // For "skip the line"
  }
  
  // Overrides (holidays, special hours)
  overrides: DateOverride[]
  
  status: 'active' | 'inactive'
}

interface TimeRange {
  start: string                   // "HH:MM"
  end: string
}

interface DateOverride {
  date: string                    // YYYY-MM-DD
  type: 'closed' | 'modified_hours' | 'special_pricing'
  hours?: TimeRange[]
  pricingMultiplier?: number
  reason?: string
}

// AVAILABILITY SLOT
interface AvailabilitySlot {
  id: UUID
  calendarId: UUID
  
  startTime: Timestamp
  endTime: Timestamp
  timezone: string
  
  status: 'available' | 'reserved' | 'booked' | 'blocked'
  
  reservationId?: UUID
  bookingId?: UUID
  
  isPremiumSlot: boolean          // Open outside of cascade
  
  createdAt: Timestamp
}

// BLOCKED TIME (vacation, maintenance)
interface BlockedTime {
  id: UUID
  calendarId: UUID
  
  startTime: Timestamp
  endTime: Timestamp
  
  type: 'time_off' | 'maintenance' | 'unavailable'
  reason?: string
  
  allowOverride: boolean          // Can booking override this?
}
```

---

## 5. Service Template (The Blueprint)

```typescript
interface ServiceTemplate {
  id: UUID
  organizationId: UUID
  locationId?: UUID               // Location-specific template
  
  // Identity
  name: string
  description?: string
  slug: string
  categoryId?: UUID
  tags: string[]
  
  // Type
  type: 'appointment' | 'class' | 'rental' | 'multi_day'
  
  // Duration
  duration: {
    type: 'fixed' | 'variable' | 'multi_day'
    fixedMinutes?: number
    minMinutes?: number
    maxMinutes?: number
    intervalMinutes?: number
    minNights?: number           // For multi-day
    maxNights?: number
    preBuffer: number
    postBuffer: number
  }
  
  // Required bookables
  requiredBookables: BookableRequirement[]
  
  // Optional bookables
  optionalBookables?: BookableRequirement[]
  
  // Capacity
  capacity: {
    type: 'individual' | 'group'
    group?: {
      minParticipants: number
      maxParticipants: number
      autoCancelIfUnderMin: boolean
      enableWaitlist: boolean
    }
  }
  
  // Pricing
  pricing: {
    basePrice: number
    currency: string
    
    // Variable duration pricing
    hourlyRate?: number
    
    // Dynamic pricing (simplified rules, not ML)
    timeMultipliers?: TimeMultiplier[]
    holidayMultiplier?: number
  }
  
  // Cancellation
  cancellation: {
    allowClientCancellation: boolean
    refundTiers: RefundTier[]
    providerCompensation: CompensationRule[]
    noShowPolicy: NoShowPolicy
  }
  
  // Deposit
  deposit?: {
    required: boolean
    amount: number
    percentage?: number
    refundable: boolean
  }
  
  // Products bundled with service
  includedProducts?: IncludedProduct[]
  
  // Reservation settings
  reservation: {
    enabled: boolean
    holdDurationMinutes: number
    requireDeposit: boolean
  }
  
  // Status
  status: 'draft' | 'active' | 'paused' | 'archived'
  isSoftDeleted: boolean
  
  createdAt: Timestamp
  updatedAt: Timestamp
}

interface BookableRequirement {
  bookableType: 'provider' | 'asset' | 'venue' | 'company_provider'
  
  // Either specific or by criteria
  specificBookableId?: UUID
  criteria?: {
    categoryIds?: UUID[]
    tags?: string[]
    minRating?: number
  }
  
  count: number
  role: 'primary' | 'assistant' | 'technician'
  
  allowSubstitution: boolean
}

interface TimeMultiplier {
  timeRange: { start: string; end: string }
  daysOfWeek: string[]
  multiplier: number
}

interface RefundTier {
  minHoursBefore: number
  refundPercent: number
  offerStoreCredit: boolean
}

interface CompensationRule {
  when: 'client_cancels' | 'org_cancels'
  noticeHours: number
  compensationPercent: number
}

interface NoShowPolicy {
  gracePeriodMinutes: number
  chargePercent: number
  providerCompensationPercent: number
}

interface IncludedProduct {
  productId: UUID
  quantity: number
  timing: 'before' | 'during' | 'after'
}
```

---

## 6. Product (Simple Catalog)

```typescript
interface Product {
  id: UUID
  organizationId: UUID
  locationId?: UUID               // Location-specific
  
  name: string
  description?: string
  sku: string
  
  type: 'physical' | 'digital'
  
  // Physical products
  physical?: {
    weight?: number
    dimensions?: { l: number; w: number; h: number }
    requiresShipping: boolean
  }
  
  // Inventory (simple)
  inventory?: {
    trackInventory: boolean
    quantityOnHand: number
    quantityReserved: number
    reorderPoint?: number
  }
  
  // Digital products
  digital?: {
    fileUrl: string
    downloadLimit: number
    downloadExpiryDays: number
  }
  
  // Pricing
  price: number
  costOfGoods?: number
  currency: string
  
  // Fulfillment
  fulfillment: {
    type: 'shipping' | 'pickup' | 'digital_delivery'
  }
  
  status: 'active' | 'inactive'
  isSoftDeleted: boolean
  
  createdAt: Timestamp
  updatedAt: Timestamp
}
```

---

## 7. Booking

```typescript
interface Booking {
  id: UUID
  organizationId: UUID
  locationId: UUID
  serviceTemplateId: UUID
  
  // Status
  status: 'reserved' | 'pending' | 'confirmed' | 'checked_in' | 'completed' | 'cancelled' | 'no_show'
  
  // Timing
  startTime: Timestamp
  endTime: Timestamp
  timezone: string
  durationMinutes: number
  
  // Booker (who made the booking)
  bookedById: UUID
  
  // Household context
  householdId?: UUID              // If booking for a household
  
  // Participants (who receives the service)
  participants: BookingParticipant[]
  
  // Assigned resources
  assignedBookables: AssignedBookable[]
  
  // Capacity (for group bookings)
  participantCount: number
  maxParticipants: number
  
  // Pricing snapshot
  pricingSnapshot: {
    basePrice: number
    durationMultiplier: number
    timeMultiplier: number
    total: number
    currency: string
  }
  
  // Products
  productItems: BookingProductItem[]
  
  // Payment
  paymentStatus: 'pending' | 'partial' | 'paid' | 'refunded'
  totalPaid: number
  refundAmount?: number
  
  // Cancellation
  cancelledAt?: Timestamp
  cancelledBy?: 'client' | 'provider' | 'system'
  cancellationReason?: string
  
  // Check-in
  checkedInAt?: Timestamp
  checkedInBy?: UUID
  
  // Completion
  completedAt?: Timestamp
  
  // Metadata
  source: 'web' | 'app' | 'walkin' | 'phone'
  isWalkIn: boolean
  
  // Note: Lifecycle hooks handled outside schema (webhooks)
  
  createdAt: Timestamp
  updatedAt: Timestamp
}

interface BookingParticipant {
  id: UUID
  bookingId: UUID
  
  // Can be user or guest
  userId?: UUID
  email?: string
  name: string
  phone?: string
  
  role: 'primary' | 'observer' | 'guest'
  isObserver: boolean             // Watching, not participating
  
  // Household relationship
  householdMemberId?: UUID
  
  status: 'confirmed' | 'cancelled' | 'no_show'
  checkedInAt?: Timestamp
}

interface AssignedBookable {
  id: UUID
  bookingId: UUID
  
  bookableId: UUID
  bookableType: 'provider' | 'asset' | 'venue' | 'company_provider'
  
  role: 'primary' | 'assistant' | 'backup'
  isBackup: boolean
  
  // For company providers: which technician
  assignedTechnicianId?: UUID     // User ID from company household
  
  confirmed: boolean
  confirmedAt?: Timestamp
  
  // Compensation (for timesheets)
  compensationAmount?: number
}

interface BookingProductItem {
  id: UUID
  bookingId: UUID
  productId: UUID
  
  quantity: number
  unitPrice: number
  totalPrice: number
  
  // Fulfillment
  fulfillmentType: 'shipping' | 'pickup' | 'digital' | 'bring_to_appointment'
  
  // Shipping (if applicable)
  shippingStatus?: 'pending' | 'shipped' | 'delivered'
  trackingNumber?: string
  
  // Digital (if applicable)
  downloadUrl?: string
  downloadCount: number
  
  // Appointment
  broughtToAppointment: boolean
}
```

---

## 8. Reservation (Temporary Hold)

```typescript
interface Reservation {
  id: UUID
  slotId: UUID
  serviceTemplateId: UUID
  userId: UUID                    // Who's holding
  
  status: 'active' | 'extended' | 'expired' | 'converted' | 'cancelled'
  
  createdAt: Timestamp
  expiresAt: Timestamp            // Auto-release after this
  
  extensionCount: number
  maxExtensions: number
  
  // Deposit (if required)
  depositAmount?: number
  depositPaid: boolean
  
  // Converted to booking
  convertedToBookingId?: UUID
  
  // Auto-cancel on expiry
  onExpiry: 'release_slot' | 'move_to_waitlist'
}
```

---

## 9. Waitlist

```typescript
interface WaitlistEntry {
  id: UUID
  serviceTemplateId: UUID
  userId: UUID
  householdId?: UUID
  
  // Preferred time range
  preferredDate: Date
  preferredTimeRange?: { start: string; end: string }
  
  position: number                // Current position in queue
  
  status: 'waiting' | 'offered' | 'accepted' | 'expired' | 'cancelled'
  
  // When slot offered
  offeredAt?: Timestamp
  offerExpiresAt?: Timestamp
  offeredSlotId?: UUID
  
  createdAt: Timestamp
}
```

---

## 10. Recurring Bookings

```typescript
interface RecurringBookingRule {
  id: UUID
  userId: UUID
  serviceTemplateId: UUID
  
  // Pattern
  pattern: {
    frequency: 'daily' | 'weekly' | 'monthly'
    interval: number               // Every N days/weeks/months
    daysOfWeek?: string[]          // For weekly: ['mon', 'wed', 'fri']
    dayOfMonth?: number            // For monthly: 15th
  }
  
  // Duration
  startDate: Date
  endDate?: Date
  maxOccurrences?: number
  
  // Exceptions
  exceptions: {
    date: Date
    action: 'skip' | 'reschedule'
    newDate?: Date
  }[]
  
  // Bookables (fixed or flexible)
  bookableIds?: UUID[]             // Fixed bookables
  flexibleBookableCriteria?: {     // Or criteria for flexible assignment
    tags: string[]
  }
  
  // Modification
  allowParticipantModify: boolean
  modificationNoticeHours: number
  
  createdAt: Timestamp
  status: 'active' | 'paused' | 'cancelled'
}
```

---

## 11. Programs (Multi-Session)

```typescript
interface ProgramTemplate {
  id: UUID
  organizationId: UUID
  
  name: string
  description?: string
  
  sessions: ProgramSession[]
  
  // Enrollment
  enrollmentType: 'full_only' | 'drop_in' | 'both'
  fullProgramPrice: number
  dropInPrice?: number
  
  // Attendance
  minAttendanceRequired?: number   // Must attend X of Y
  allowMissedSessions: boolean
  
  status: 'draft' | 'active' | 'archived'
}

interface ProgramSession {
  sequenceNumber: number
  name: string
  serviceTemplateId: UUID
  daysAfterStart: number          // Day 0, 7, 14, etc.
  allowDropIn: boolean
}

interface ProgramEnrollment {
  id: UUID
  programTemplateId: UUID
  participantId: UUID
  householdId?: UUID
  
  enrollmentType: 'full' | 'drop_in'
  
  sessions: {
    sessionNumber: number
    bookingId?: UUID
    status: 'scheduled' | 'completed' | 'missed' | 'cancelled'
  }[]
  
  paymentPlan?: {
    totalAmount: number
    installments: { dueDate: Date; amount: number; paid: boolean }[]
  }
  
  completed: boolean
}
```

---

## 12. Packages

```typescript
interface ServicePackage {
  id: UUID
  organizationId: UUID
  
  name: string
  description?: string
  
  items: PackageItem[]
  
  totalPrice: number
  originalValue: number           // If bought separately
  
  // Usage
  useWithinDays: number
  allowAnyOrder: boolean
  
  // Transfer
  allowTransfer: boolean
  
  status: 'active' | 'inactive'
}

interface PackageItem {
  serviceTemplateId: UUID
  quantity: number
  restrictions?: {
    allowedLocations?: UUID[]
    excludedDates?: Date[]
  }
}

interface PackagePurchase {
  id: UUID
  packageId: UUID
  purchaserId: UUID
  householdId?: UUID
  
  totalPaid: number
  
  itemsRemaining: {
    serviceTemplateId: UUID
    quantityRemaining: number
  }[]
  
  expiresAt: Timestamp
}
```

---

## 13. Database Schema (SQL)

```sql
-- Organizations
CREATE TABLE organizations (
  id UUID PRIMARY KEY,
  slug VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  features JSONB NOT NULL DEFAULT '{}',
  default_config JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Locations
CREATE TABLE locations (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  address JSONB,
  timezone VARCHAR(50) NOT NULL,
  operating_hours JSONB NOT NULL DEFAULT '{}',
  config_override JSONB,
  service_area JSONB,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  is_soft_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Users (Better-Auth extended)
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  email_verified BOOLEAN NOT NULL DEFAULT FALSE,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  image TEXT,
  preferences JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Households
CREATE TABLE households (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL DEFAULT 'family',
  primary_contact_id UUID NOT NULL REFERENCES users(id),
  company_info JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Household Members
CREATE TABLE household_members (
  id UUID PRIMARY KEY,
  household_id UUID NOT NULL REFERENCES households(id),
  user_id UUID NOT NULL REFERENCES users(id),
  role VARCHAR(50) NOT NULL,
  permissions JSONB NOT NULL DEFAULT '{}',
  managed_by UUID[] DEFAULT '{}',
  relationship VARCHAR(50),
  date_of_birth DATE,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(household_id, user_id)
);

-- Org Memberships
CREATE TABLE org_memberships (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  organization_id UUID NOT NULL REFERENCES organizations(id),
  role VARCHAR(50) NOT NULL,
  location_ids UUID[] DEFAULT NULL,
  provider_id UUID,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, organization_id)
);

-- Bookables (polymorphic)
CREATE TABLE bookables (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  location_id UUID NOT NULL REFERENCES locations(id),
  type VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  slug VARCHAR(255) NOT NULL,
  category_id UUID,
  tags TEXT[] DEFAULT '{}',
  calendar_id UUID NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  is_soft_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  deleted_at TIMESTAMPTZ,
  deletion_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Providers
CREATE TABLE providers (
  bookable_id UUID PRIMARY KEY REFERENCES bookables(id),
  user_id UUID REFERENCES users(id),
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  bio TEXT,
  specialties TEXT[] DEFAULT '{}',
  languages TEXT[] DEFAULT '{}',
  can_work_at_locations UUID[] NOT NULL,
  travel_radius INTEGER,
  max_daily_bookings INTEGER,
  min_rest_between_bookings INTEGER NOT NULL DEFAULT 0,
  payment_profile JSONB DEFAULT '{}',
  rating DECIMAL(3,2),
  review_count INTEGER NOT NULL DEFAULT 0
);

-- Company Providers
CREATE TABLE company_providers (
  bookable_id UUID PRIMARY KEY REFERENCES bookables(id),
  household_id UUID NOT NULL REFERENCES households(id),
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  website TEXT,
  available_technicians UUID[] DEFAULT '{}',
  dispatch_method VARCHAR(50) NOT NULL DEFAULT 'manual',
  service_radius INTEGER NOT NULL,
  business_hours JSONB NOT NULL
);

-- Assets
CREATE TABLE assets (
  bookable_id UUID PRIMARY KEY REFERENCES bookables(id),
  asset_type VARCHAR(50) NOT NULL,
  serial_number VARCHAR(255),
  inventory_number VARCHAR(255),
  specifications JSONB DEFAULT '{}',
  maintenance_schedule JSONB,
  last_serviced_at TIMESTAMPTZ,
  next_service_due TIMESTAMPTZ
);

-- Venues
CREATE TABLE venues (
  bookable_id UUID PRIMARY KEY REFERENCES bookables(id),
  capacity_min INTEGER,
  capacity_max INTEGER NOT NULL,
  square_footage INTEGER,
  amenities TEXT[] DEFAULT '{}',
  allow_simultaneous_bookings BOOLEAN NOT NULL DEFAULT FALSE,
  max_simultaneous_bookings INTEGER,
  default_setup_time INTEGER NOT NULL DEFAULT 0,
  default_teardown_time INTEGER NOT NULL DEFAULT 0
);

-- Calendars
CREATE TABLE calendars (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  bookable_id UUID NOT NULL REFERENCES bookables(id),
  name VARCHAR(255) NOT NULL,
  timezone VARCHAR(50) NOT NULL,
  default_pattern JSONB NOT NULL,
  cascading JSONB DEFAULT '{}',
  status VARCHAR(50) NOT NULL DEFAULT 'active'
);

-- Availability Slots
CREATE TABLE availability_slots (
  id UUID PRIMARY KEY,
  calendar_id UUID NOT NULL REFERENCES calendars(id),
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  timezone VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'available',
  reservation_id UUID,
  booking_id UUID,
  is_premium_slot BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Service Templates
CREATE TABLE service_templates (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  location_id UUID REFERENCES locations(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  slug VARCHAR(255) NOT NULL,
  category_id UUID,
  tags TEXT[] DEFAULT '{}',
  type VARCHAR(50) NOT NULL,
  duration JSONB NOT NULL,
  required_bookables JSONB NOT NULL DEFAULT '[]',
  optional_bookables JSONB DEFAULT '[]',
  capacity JSONB NOT NULL,
  pricing JSONB NOT NULL,
  cancellation JSONB NOT NULL,
  deposit JSONB,
  included_products JSONB DEFAULT '[]',
  reservation JSONB NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'draft',
  is_soft_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Products
CREATE TABLE products (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  location_id UUID REFERENCES locations(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  sku VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  physical JSONB,
  inventory JSONB,
  digital JSONB,
  price DECIMAL(10,2) NOT NULL,
  cost_of_goods DECIMAL(10,2),
  currency VARCHAR(3) NOT NULL DEFAULT 'USD',
  fulfillment_type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  is_soft_deleted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Bookings
CREATE TABLE bookings (
  id UUID PRIMARY KEY,
  organization_id UUID NOT NULL REFERENCES organizations(id),
  location_id UUID NOT NULL REFERENCES locations(id),
  service_template_id UUID NOT NULL REFERENCES service_templates(id),
  status VARCHAR(50) NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  timezone VARCHAR(50) NOT NULL,
  duration_minutes INTEGER NOT NULL,
  booked_by_id UUID NOT NULL REFERENCES users(id),
  household_id UUID REFERENCES households(id),
  participant_count INTEGER NOT NULL DEFAULT 1,
  max_participants INTEGER,
  pricing_snapshot JSONB NOT NULL,
  payment_status VARCHAR(50) NOT NULL DEFAULT 'pending',
  total_paid DECIMAL(10,2) NOT NULL DEFAULT 0,
  refund_amount DECIMAL(10,2),
  cancelled_at TIMESTAMPTZ,
  cancelled_by VARCHAR(50),
  cancellation_reason TEXT,
  checked_in_at TIMESTAMPTZ,
  checked_in_by UUID REFERENCES users(id),
  completed_at TIMESTAMPTZ,
  source VARCHAR(50) NOT NULL DEFAULT 'web',
  is_walk_in BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Booking Participants
CREATE TABLE booking_participants (
  id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES bookings(id),
  user_id UUID REFERENCES users(id),
  email VARCHAR(255),
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  role VARCHAR(50) NOT NULL DEFAULT 'primary',
  is_observer BOOLEAN NOT NULL DEFAULT FALSE,
  household_member_id UUID,
  status VARCHAR(50) NOT NULL DEFAULT 'confirmed',
  checked_in_at TIMESTAMPTZ
);

-- Assigned Bookables
CREATE TABLE assigned_bookables (
  id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES bookings(id),
  bookable_id UUID NOT NULL,
  bookable_type VARCHAR(50) NOT NULL,
  role VARCHAR(50) NOT NULL,
  is_backup BOOLEAN NOT NULL DEFAULT FALSE,
  assigned_technician_id UUID REFERENCES users(id),
  confirmed BOOLEAN NOT NULL DEFAULT FALSE,
  confirmed_at TIMESTAMPTZ,
  compensation_amount DECIMAL(10,2)
);

-- Booking Product Items
CREATE TABLE booking_product_items (
  id UUID PRIMARY KEY,
  booking_id UUID NOT NULL REFERENCES bookings(id),
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  fulfillment_type VARCHAR(50) NOT NULL,
  shipping_status VARCHAR(50),
  tracking_number VARCHAR(255),
  download_url TEXT,
  download_count INTEGER NOT NULL DEFAULT 0,
  brought_to_appointment BOOLEAN NOT NULL DEFAULT FALSE
);

-- Reservations
CREATE TABLE reservations (
  id UUID PRIMARY KEY,
  slot_id UUID NOT NULL REFERENCES availability_slots(id),
  service_template_id UUID NOT NULL REFERENCES service_templates(id),
  user_id UUID NOT NULL REFERENCES users(id),
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL,
  extension_count INTEGER NOT NULL DEFAULT 0,
  max_extensions INTEGER NOT NULL DEFAULT 0,
  deposit_amount DECIMAL(10,2),
  deposit_paid BOOLEAN NOT NULL DEFAULT FALSE,
  converted_to_booking_id UUID REFERENCES bookings(id),
  on_expiry VARCHAR(50) NOT NULL DEFAULT 'release_slot'
);

-- Waitlist
CREATE TABLE waitlist_entries (
  id UUID PRIMARY KEY,
  service_template_id UUID NOT NULL REFERENCES service_templates(id),
  user_id UUID NOT NULL REFERENCES users(id),
  household_id UUID REFERENCES households(id),
  preferred_date DATE NOT NULL,
  preferred_time_range JSONB,
  position INTEGER NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'waiting',
  offered_at TIMESTAMPTZ,
  offer_expires_at TIMESTAMPTZ,
  offered_slot_id UUID REFERENCES availability_slots(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Recurring Booking Rules
CREATE TABLE recurring_booking_rules (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  service_template_id UUID NOT NULL REFERENCES service_templates(id),
  pattern JSONB NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  max_occurrences INTEGER,
  exceptions JSONB DEFAULT '[]',
  bookable_ids UUID[],
  flexible_bookable_criteria JSONB,
  allow_participant_modify BOOLEAN NOT NULL DEFAULT TRUE,
  modification_notice_hours INTEGER NOT NULL DEFAULT 24,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_bookings_org_status ON bookings(organization_id, status);
CREATE INDEX idx_bookings_start_time ON bookings(start_time);
CREATE INDEX idx_slots_calendar_status ON availability_slots(calendar_id, status);
CREATE INDEX idx_bookables_org_type ON bookables(organization_id, type);
```

---

## Summary of v3.0 Changes

### Added (New in v3):
1. **Household system** — For families AND company providers
2. **Company provider type** — Businesses as providers (ABC Plumbing Corp)
3. **Products** — Simple catalog for upsells
4. **Waitlist** — Auto-promote when slots open
5. **Recurring bookings** — Weekly, monthly patterns
6. **Programs** — Multi-session classes
7. **Packages** — Bundled services

### Simplified (from v2):
1. **Removed AI/ML layer** — Deferred
2. **Removed hybrid modes** — In-person OR virtual, not both
3. **Removed channel abstraction** — Web only for now
4. **Removed real-time collaboration** — No virtual waiting rooms yet
5. **Removed theming** — Single UI
6. **Simplified hierarchy** — Flat org structure (no brands/franchise yet)
7. **Simplified asset management** — Basic maintenance only

### Kept from v2:
1. Polymorphic bookables
2. Service templates as blueprints
3. Cascading availability
4. Cancellation tiers
5. Soft deletion
6. Multi-location
7. Buffer times
8. Dynamic pricing (rules-based, not ML)

---

*Schema Design v3.0 — Simplified, Production-Ready. Generated 2026-02-17.*
