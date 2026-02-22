---
date: 2026-02-16
tags:
  - spec
  - schema
  - api
  - booking
  - architecture
  - technical-design
---

# Bizing Booking System: Technical Specification v1.0

> Comprehensive technical specification for the booking platform schema, API, and business logic

---

## 1. Executive Summary

### 1.1 Purpose

This specification defines the complete technical architecture for Bizing's booking platform, supporting use cases from individual scheduling (Calendly-style) to complex resource orchestration (movie studio productions).

### 1.2 Design Principles

1. **Polymorphic Bookables** — Everything that can be booked (people, assets, venues, virtual resources) shares a common abstraction
2. **Service Templates as Blueprints** — Templates define what gets booked, with whom, for how long, and under what rules
3. **Cascading Availability** — Slots open progressively to optimize booking density
4. **Configurable Workflows** — Hooks at every lifecycle stage for custom business logic
5. **Multi-Tenancy with Hierarchy** — Organizations, locations, branches with inherited configurations
6. **Payment-Aware** — Native support for pricing rules, compensation, invoicing
7. **Compliance-Ready** — Audit trails, access controls, privacy features for HIPAA/SOC 2

### 1.3 Use Case Spectrum

```
Simple (Calendly-style)          →          Complex (Movie Studio)
├─ Individual consultant                 ├─ Multi-day productions
├─ 1:1 meetings                          ├─ 100+ resources
├─ Single calendar                       ├─ Hierarchical teams
└─ Basic scheduling                      ├─ Union rules/payments
                                          ├─ Equipment dependencies
                                          └─ Location scouting

Mid-Complexity (Airbnb/Uber)             Enterprise (Hospital Chain)
├─ Multi-day stays                       ├─ Multi-location
├─ Asset + host pairing                  ├─ Complex staffing rules
├─ Dynamic pricing                       ├─ Compliance requirements
└─ Instant confirmation                  └─ Insurance/liability
```

---

## 2. Core Entity Model

### 2.1 Entity Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CORE ENTITIES                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Organization                                                        │
│    └── Locations[]                                                   │
│         └── Calendars[]                                              │
│              └── AvailabilitySlots[]                                 │
│                                                                      │
│  ServiceTemplate (The Blueprint)                                     │
│    ├── RequiredBookables[]                                           │
│    ├── OptionalBookables[]                                           │
│    ├── PricingRules[]                                                │
│    ├── CancellationPolicies[]                                        │
│    └── WorkflowHooks[]                                               │
│                                                                      │
│  Bookable (Polymorphic)                                              │
│    ├── Provider (Human)                                              │
│    ├── Asset (Physical)                                              │
│    ├── Venue (Space)                                                 │
│    └── VirtualResource (Digital)                                     │
│                                                                      │
│  Booking (The Instance)                                              │
│    ├── Participants[]                                                │
│    ├── AssignedBookables[]                                           │
│    ├── PaymentTransactions[]                                         │
│    └── LifecycleState                                                │
│                                                                      │
│  Reservation (Temporary Hold)                                        │
│    └── AutoExpiry                                                    │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Organization & Hierarchy

```typescript
// Organization: Top-level tenant
interface Organization {
  id: UUID;
  slug: string;                    // URL-friendly identifier
  name: string;
  type: 'individual' | 'small_business' | 'enterprise' | 'franchise';
  
  // Configuration inheritance
  defaultConfig: OrgConfiguration;
  
  // Feature flags
  features: {
    cascadingSlots: boolean;
    waitlistEnabled: boolean;
    recurringBookings: boolean;
    multiDayBookings: boolean;
    paymentProcessing: boolean;
    timesheets: boolean;
    virtualServices: boolean;
  };
  
  // Compliance settings
  compliance: {
    hipaaEnabled: boolean;         // Strict audit logging, encryption
    soc2Enabled: boolean;          // Extended retention, access reviews
    gdprEnabled: boolean;          // Data portability, right to deletion
  };
  
  // Auth integration (Better-Auth)
  authConfig: {
    allowMagicLinks: boolean;
    requireMfa: boolean;
    ssoProvider?: string;          // SAML/OIDC provider
    sessionDuration: number;       // minutes
  };
  
  createdAt: Timestamp;
  updatedAt: Timestamp;
  deletedAt?: Timestamp;           // Soft deletion
}

// Location: Physical or virtual place of business
interface Location {
  id: UUID;
  organizationId: UUID;
  parentLocationId?: UUID;         // For chains/hierarchies
  
  name: string;
  type: 'physical' | 'virtual' | 'mobile';
  
  // Physical locations
  address?: {
    street: string;
    city: string;
    state: string;
    zip: string;
    country: string;
    coordinates?: { lat: number; lng: number };
  };
  
  // Configuration override
  // Inherits from org, can override
  config: Partial<OrgConfiguration>;
  
  // Operating hours (can be overridden by bookable)
  operatingHours: OperatingHours;
  
  timezone: string;                // IANA timezone
  locale: string;                  // en-US, etc.
  
  // For mobile services
  serviceArea?: {
    type: 'radius' | 'polygon';
    radius?: number;               // miles/km
    coordinates?: { lat: number; lng: number }[];
  };
  
  // Relationships
  bookables: Bookable[];           // Available at this location
  calendars: Calendar[];           // Location-specific calendars
}
```

### 2.3 Bookable Abstraction (Polymorphic)

Everything that can be booked extends Bookable:

```typescript
// Base Bookable interface
interface Bookable {
  id: UUID;
  organizationId: UUID;
  locationId: UUID;                // Primary location
  
  type: 'provider' | 'asset' | 'venue' | 'virtual_resource';
  
  // Identity
  name: string;
  description?: string;
  slug: string;
  
  // Categorization
  categoryId?: UUID;               // Hair stylist, MRI machine, etc.
  tags: string[];                  // ['certified', 'senior', 'manual-transmission']
  
  // Media
  images: Image[];
  
  // Configuration
  settings: BookableSettings;
  
  // Calendar (each bookable has own availability)
  calendarId: UUID;
  
  // Relationships
  // Which service templates can use this bookable?
  compatibleServiceTemplates: UUID[];
  
  // Dependencies
  requiresBookables?: UUID[];      // E.g., car requires parking spot
  
  // Status
  status: 'active' | 'inactive' | 'maintenance' | 'retired';
  isSoftDeleted: boolean;
  deletedAt?: Timestamp;
  deletedBy?: UUID;
  deletionReason?: string;
  
  // Audit
  createdAt: Timestamp;
  updatedAt: Timestamp;
  createdBy: UUID;
  updatedBy: UUID;
}

// Provider: Human who delivers services
interface Provider extends Bookable {
  type: 'provider';
  
  // Identity
  userId?: UUID;                   // Link to auth user (Better-Auth)
  email: string;
  phone?: string;
  
  // Profile
  bio?: string;
  specialties: string[];           // ['coloring', 'mens-cuts']
  languages: string[];
  
  // Certifications & Compliance
  certifications: Certification[];
  backgroundCheck?: {
    status: 'pending' | 'passed' | 'failed' | 'expired';
    completedAt?: Timestamp;
    expiresAt?: Timestamp;
  };
  
  // Payment & Compensation
  paymentProfile: ProviderPaymentProfile;
  
  // Working preferences
  maxDailyBookings?: number;       // Prevent burnout
  minRestBetweenBookings?: number; // minutes
  maxAdvanceBooking?: number;      // days (how far ahead)
  minAdvanceBooking?: number;      // hours (how little notice)
  
  // Locations
  canWorkAtLocations: UUID[];      // Multi-location providers
  travelRadius?: number;           // miles (for mobile services)
  
  // Schedule preferences
  defaultAvailability: AvailabilityPattern;
  timeOffRequests: TimeOffRequest[];
  
  // Performance
  rating?: number;
  reviewCount: number;
  cancellationRate: number;
  noShowRate: number;
}

interface Certification {
  id: UUID;
  type: string;                    // 'cosmetology', 'cpr', 'phlebotomy'
  issuedBy: string;
  issuedAt: Timestamp;
  expiresAt: Timestamp;
  documentUrl?: string;
  verificationStatus: 'pending' | 'verified' | 'expired';
}

// Asset: Physical equipment, vehicles, tools
interface Asset extends Bookable {
  type: 'asset';
  
  // Classification
  assetType: 'vehicle' | 'equipment' | 'tool' | 'instrument' | 'other';
  
  // Identification
  serialNumber?: string;
  inventoryNumber?: string;
  barcode?: string;
  
  // Specifications
  specifications: Record<string, any>;
  // Examples:
  // { transmission: 'automatic', fuel: 'hybrid', seats: 5 }
  // { resolution: '4k', lens: '50mm', sensor: 'full-frame' }
  
  // Physical
  dimensions?: {
    length?: number;
    width?: number;
    height?: number;
    weight?: number;
    unit: 'imperial' | 'metric';
  };
  
  // Maintenance
  maintenanceSchedule: MaintenanceSchedule;
  lastServicedAt?: Timestamp;
  nextServiceDue?: Timestamp;
  condition: 'excellent' | 'good' | 'fair' | 'poor' | 'out_of_service';
  
  // Usage tracking
  totalUsageHours: number;
  totalBookings: number;
  
  // Dependencies
  requiresAssets?: UUID[];         // E.g., camera requires lens, battery
  compatibleAssets?: UUID[];       // Can be bundled
}

// Venue: Physical space (room, building, area)
interface Venue extends Bookable {
  type: 'venue';
  
  // QUESTION: Should Venue be separate from Asset?
  // ANSWER: Yes, because venues have unique characteristics:
  // - Fixed location (not movable like assets)
  // - Capacity constraints (people, not usage hours)
  // - Layout/floor plans
  // - Multiple simultaneous bookings possible (rooms within venue)
  
  // Capacity
  capacity: {
    min?: number;                  // Minimum to book (e.g., 10 for class)
    max: number;                   // Maximum allowed
    optimal?: number;              // Ideal number
  };
  
  // Space details
  squareFootage?: number;
  layout?: 'theater' | 'classroom' | 'banquet' | 'conference' | 'open' | 'custom';
  floorPlanUrl?: string;           // Image of layout
  
  // Amenities
  amenities: string[];             // ['wifi', 'av_system', 'catering', 'parking']
  
  // Sub-venues (rooms within a building)
  parentVenueId?: UUID;
  subVenues?: UUID[];
  
  // Availability
  // Venues can have multiple simultaneous bookings if spaces allow
  allowSimultaneousBookings: boolean;
  maxSimultaneousBookings?: number;
  
  // Setup/Teardown
  defaultSetupTime: number;        // minutes before booking
  defaultTeardownTime: number;     // minutes after booking
}

// Virtual Resource: Digital assets (Zoom rooms, software licenses)
interface VirtualResource extends Bookable {
  type: 'virtual_resource';
  
  resourceType: 'video_conference' | 'software_license' | 'streaming_slot' | 'other';
  
  // Provider-specific config
  provider: 'zoom' | 'google_meet' | 'teams' | 'custom' | 'license_server';
  
  // Connection details
  connectionInfo: {
    joinUrl?: string;              // Generated per-booking
    meetingId?: string;
    passcode?: string;
    dialInNumbers?: string[];
    streamingKey?: string;
  };
  
  // For license-based
  licensePool?: {
    totalLicenses: number;
    concurrentLimit: number;
  };
  
  // Auto-provisioning
  autoProvision: boolean;          // Create meeting automatically
  autoDeleteAfter: number;         // minutes after booking ends
  
  // Recording
  allowRecording: boolean;
  autoRecord: boolean;
  recordingRetentionDays: number;
}
```

### 2.4 Calendar & Availability System

```typescript
// Calendar: Container for availability
interface Calendar {
  id: UUID;
  organizationId: UUID;
  locationId?: UUID;               // Optional: location-level calendar
  bookableId?: UUID;               // Optional: bookable-specific calendar
  
  name: string;
  type: 'organization' | 'location' | 'bookable' | 'service_template';
  
  // Timezone
  timezone: string;
  
  // Default availability pattern
  // Used to generate slots
  defaultPattern: AvailabilityPattern;
  
  // Override specific dates
  overrides: DateOverride[];
  
  // Cascading configuration
  cascadingConfig?: CascadingConfig;
}

// Availability Pattern: Recurring schedule
interface AvailabilityPattern {
  // Weekly schedule
  weeklySchedule: {
    [day: string]: TimeRange[];    // monday: [{start: '09:00', end: '17:00'}]
  };
  
  // Slot generation
  slotDuration: number;            // minutes (e.g., 30, 60)
  slotInterval: number;            // minutes between slot starts (e.g., 15 for 9:00, 9:15, 9:30)
  
  // Buffer times (automatically added)
  preBuffer: number;               // minutes before each slot
  postBuffer: number;              // minutes after each slot
  
  // Constraints
  minAdvanceBooking: number;       // hours (e.g., 24 = book 1 day ahead)
  maxAdvanceBooking: number;       // days (e.g., 90 = book 3 months ahead)
  
  // Limits
  maxSlotsPerDay?: number;
  maxBookingsPerDay?: number;
}

interface TimeRange {
  start: string;                   // "HH:MM" in 24h format
  end: string;
  type: 'available' | 'preferred' | 'premium';
}

// Cascading Configuration
interface CascadingConfig {
  enabled: boolean;
  
  // Strategy
  strategy: 'sequential' | 'batch' | 'dynamic';
  
  // Sequential: Open one slot at a time
  // - When slot 1 is booked, open slot 2
  // - When slot 2 is booked, open slot 3
  
  // Batch: Open N slots at a time
  // - Always have N upcoming slots open
  
  // Dynamic: ML-based optimization
  // - Open slots based on demand patterns
  
  // Sequential settings
  sequential?: {
    initialOpenSlots: number;      // Start with N slots open
    advanceWindow: number;         // Open next slot X days in advance
  };
  
  // Batch settings
  batch?: {
    batchSize: number;             // Always keep N slots open
    lookAheadDays: number;         // Look ahead X days for batch
  };
  
  // Premium pricing for non-cascading (skip the line)
  premiumBooking: {
    enabled: boolean;
    premiumSlots: number;          // How many slots to open ahead
    pricingMultiplier: number;     // e.g., 1.5x for premium access
  };
}

// Availability Slot: A bookable time window
interface AvailabilitySlot {
  id: UUID;
  calendarId: UUID;
  
  // Time
  startTime: Timestamp;
  endTime: Timestamp;
  timezone: string;
  
  // Status
  status: 'available' | 'reserved' | 'booked' | 'blocked' | 'maintenance';
  
  // If reserved/booked
  reservationId?: UUID;
  bookingId?: UUID;
  
  // For recurring slot series
  recurrenceId?: UUID;
  
  // Metadata
  isCascadingOpen: boolean;        // Opened by cascading logic?
  isPremiumSlot: boolean;          // Available at premium price?
  
  // Constraints for this specific slot
  constraints?: {
    minNotice?: number;            // Override pattern
    maxNotice?: number;
    requiresConfirmation?: boolean;
  };
  
  // Audit
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

// Date Override: Special days (holidays, events)
interface DateOverride {
  id: UUID;
  calendarId: UUID;
  
  date: string;                    // YYYY-MM-DD
  type: 'closed' | 'modified_hours' | 'special_hours' | 'holiday_pricing';
  
  // If modified/special hours
  hours?: TimeRange[];
  
  // Pricing modifier
  pricingMultiplier?: number;      // 1.5 for holidays
  
  // Reason
  reason?: string;                 // "Christmas", "Staff training"
  
  // Recurring yearly?
  isRecurring: boolean;
}

// Blocked Time: Unavailability (vacation, maintenance)
interface BlockedTime {
  id: UUID;
  calendarId: UUID;
  bookableId?: UUID;               // If bookable-specific
  
  startTime: Timestamp;
  endTime: Timestamp;
  
  type: 'time_off' | 'maintenance' | 'meeting' | 'unavailable' | 'travel';
  
  reason?: string;
  
  // For providers
  isPaidTimeOff?: boolean;
  
  // Can bookings override this?
  allowOverride: boolean;
  overrideRequiresApproval: boolean;
}
```

---

## 3. Service Template System

### 3.1 Service Template: The Blueprint

Service Templates define WHAT can be booked, with WHAT resources, under WHAT rules.

```typescript
interface ServiceTemplate {
  id: UUID;
  organizationId: UUID;
  locationId?: UUID;               // Location-specific template
  
  // Identity
  name: string;
  description?: string;
  slug: string;
  
  // Categorization
  categoryId?: UUID;
  tags: string[];
  
  // Service Type
  type: 'appointment' | 'class' | 'rental' | 'event' | 'multi_day' | 'virtual';
  
  // Duration
  duration: DurationConfig;
  
  // Bookables required
  bookables: {
    required: BookableRequirement[];    // Must have these
    optional: BookableRequirement[];    // Nice to have
    backups: BackupBookableConfig[];    // If primary unavailable
  };
  
  // Capacity
  capacity: CapacityConfig;
  
  // Pricing
  pricing: PricingConfig;
  
  // Scheduling
  scheduling: SchedulingConfig;
  
  // Cancellation
  cancellation: CancellationConfig;
  
  // Booking lifecycle
  lifecycle: LifecycleConfig;
  
  // Workflows
  workflows: WorkflowConfig;
  
  // Media
  images: Image[];
  
  // Status
  status: 'draft' | 'active' | 'paused' | 'archived';
  isSoftDeleted: boolean;
  deletedAt?: Timestamp;
  
  // Versioning
  version: number;
  previousVersionId?: UUID;
  
  // Audit
  createdAt: Timestamp;
  updatedAt: Timestamp;
  createdBy: UUID;
  updatedBy: UUID;
}

// Duration Configuration
interface DurationConfig {
  type: 'fixed' | 'variable' | 'range';
  
  // Fixed: Always this long (e.g., 60 min haircut)
  fixedMinutes?: number;
  
  // Variable: Booker chooses (e.g., 30-120 min consultation)
  minMinutes?: number;
  maxMinutes?: number;
  intervalMinutes?: number;        // Increment (e.g., 15 min steps)
  
  // Range: Provider chooses at booking time
  rangeMinutes?: {
    min: number;
    max: number;
    default: number;
  };
  
  // Multi-day (Airbnb-style)
  minNights?: number;
  maxNights?: number;
  defaultNights?: number;
  
  // Buffers automatically added
  preBufferMinutes: number;        // Setup time
  postBufferMinutes: number;       // Teardown/cleanup
  
  // Travel time (for mobile services)
  travelTimeMinutes?: number;
  travelTimeCalculation?: 'fixed' | 'distance_based';
}

// Bookable Requirements
interface BookableRequirement {
  id: UUID;
  
  // What type of bookable
  bookableType: 'provider' | 'asset' | 'venue' | 'virtual_resource';
  
  // Specific bookable OR criteria
  specificBookableId?: UUID;       // Must be this exact bookable
  
  // OR filter by criteria
  criteria?: {
    categoryIds?: UUID[];          // Any of these categories
    tags?: string[];               // Must have all these tags
    minRating?: number;
    certifications?: string[];     // Required certifications
  };
  
  // How many?
  count: number;
  
  // Role designation
  role: 'primary' | 'assistant' | 'supervisor' | 'technician' | 'any';
  
  // Can this be substituted?
  allowSubstitution: boolean;
  substitutionCriteria?: {
    requiresSameCategory: boolean;
    requiresSameTags: string[];
    minExperience?: number;
  };
  
  // Compensation for this role
  compensation?: CompensationRule;
}

// Backup Bookable Configuration
interface BackupBookableConfig {
  id: UUID;
  primaryRequirementId: UUID;      // Which requirement this backs up
  
  // Backup options (in priority order)
  backupBookableIds: UUID[];
  
  // Trigger conditions
  trigger: {
    when: 'primary_unavailable' | 'primary_cancelled' | 'primary_no_show';
    noticeHours: number;           // How much notice needed
  };
  
  // Compensation for backup
  compensation: {
    ifNotUsed: 'none' | 'partial' | 'full';      // Show up pay
    ifUsed: 'standard' | 'premium' | 'overtime'; // Actual work pay
    amounts: {
      standbyFee?: number;         // If they prepare but aren't needed
      usageFee?: number;           // If they actually cover
    };
  };
  
  // Auto-assignment
  autoAssign: boolean;
  autoAssignStrategy: 'round_robin' | 'least_recently_used' | 'availability';
  
  // Notification
  notifyBeforeHours: number;       // Give backup notice X hours before
  notifyChannel: 'email' | 'sms' | 'push' | 'all';
}

// Capacity Configuration
interface CapacityConfig {
  type: 'individual' | 'group' | 'unlimited';
  
  // Individual: 1 person (default for appointments)
  
  // Group: Multiple participants
  group?: {
    minParticipants: number;       // Minimum to run (e.g., 5 for class)
    maxParticipants: number;       // Maximum capacity (e.g., 30 for class)
    optimalParticipants?: number;  // Target size
    
    // Auto-cancel if under minimum
    autoCancelIfUnderMin: boolean;
    autoCancelNoticeHours: number; // Notify X hours before if cancelling
    
    // Waitlist
    enableWaitlist: boolean;
    maxWaitlistSize: number;
    waitlistAutoPromote: boolean;  // Auto-promote when spot opens
    waitlistHoldHours: number;     // How long to hold offered spot
  };
  
  // Per-participant bookables
  perParticipantBookables?: {
    // E.g., each participant gets a bike
    assetType?: string;
    autoAssign: boolean;
  };
}
```

### 3.2 Pricing Configuration

```typescript
interface PricingConfig {
  // Base pricing model
  model: 'fixed' | 'hourly' | 'per_person' | 'tiered' | 'dynamic';
  
  // Fixed: Flat rate (e.g., $50 haircut)
  fixedPrice?: {
    amount: number;
    currency: string;
  };
  
  // Hourly: Rate per hour (e.g., $100/hr consulting)
  hourlyRate?: {
    rate: number;
    currency: string;
    minCharge?: number;            // Minimum billable (e.g., 1 hour)
    increment: number;             // Bill in X-minute increments
  };
  
  // Per person: Per participant (e.g., $25/person class)
  perPersonPrice?: {
    amount: number;
    currency: string;
    minCharge?: number;
    maxCharge?: number;
  };
  
  // Tiered: Price changes by quantity
  tieredPricing?: {
    tiers: {
      minQuantity: number;
      maxQuantity: number;
      pricePerUnit: number;
    }[];
  };
  
  // Dynamic: Time-based pricing
  dynamicPricing?: {
    basePrice: number;
    
    // Time of day multipliers
    timeMultipliers: {
      timeRange: { start: string; end: string }; // "HH:MM"
      daysOfWeek: string[];                      // ['monday', 'tuesday']
      multiplier: number;                        // 1.5 = 50% premium
    }[];
    
    // Holiday pricing
    holidayMultiplier: number;
    specificDates: {
      date: string;                              // YYYY-MM-DD
      multiplier: number;
      reason: string;
    }[];
    
    // Peak demand
    demandBased?: {
      enabled: boolean;
      surgeMultiplierMax: number;                // Cap surge at X
    };
    
    // Early bird / Last minute
    advanceBookingDiscount?: {
      daysInAdvance: number;
      discountPercent: number;
    };
    lastMinutePremium?: {
      hoursBefore: number;
      premiumPercent: number;
    };
  };
  
  // Deposits
  deposit?: {
    required: boolean;
    type: 'fixed' | 'percentage';
    amount?: number;
    percentage?: number;           // 0.5 = 50%
    refundable: boolean;
    refundDeadlineHours: number;
  };
  
  // Upsells
  upsells: UpsellConfig[];
  
  // Currency
  currency: string;                  // ISO 4217
  
  // Taxes
  taxConfiguration?: {
    taxRate: number;
    taxInclusive: boolean;
  };
}

interface UpsellConfig {
  id: UUID;
  name: string;
  description?: string;
  
  // Can be product or service add-on
  type: 'product' | 'service_addon' | 'insurance' | 'feature';
  
  price: {
    amount: number;
    currency: string;
  };
  
  // When to offer
  offerTiming: 'booking' | 'confirmation' | 'reminder' | 'check_in';
  
  // Constraints
  maxQuantity?: number;
  requiresOtherUpsell?: UUID[];      // Bundle requirements
  incompatibleWith?: UUID[];         // Mutually exclusive
  
  // Inventory (if product)
  inventory?: {
    trackInventory: boolean;
    quantityAvailable: number;
    lowStockThreshold: number;
  };
}
```

### 3.3 Cancellation & Lifecycle Configuration

```typescript
interface CancellationConfig {
  // Who can cancel
  allowClientCancellation: boolean;
  allowProviderCancellation: boolean;
  requireApprovalFor?: ('client' | 'provider')[];
  
  // Refund rules (multiple tiers)
  refundTiers: RefundTier[];
  
  // Provider compensation on cancellation
  providerCompensation: ProviderCancellationCompensation;
  
  // Rebooking
  allowReschedule: boolean;
  rescheduleDeadlineHours: number;
  rescheduleFee?: number;
  
  // No-show handling
  noShowPolicy: NoShowPolicy;
  
  // Late cancellation (different from standard)
  lateCancellation?: {
    windowHours: number;           // Within X hours is "late"
    refundPercent: number;         // Different refund %
    chargeFee: number;             // Additional fee
  };
}

interface RefundTier {
  // Time window (before booking start)
  minHoursBefore: number;          // e.g., 48
  maxHoursBefore: number;          // e.g., 999999 (infinity)
  
  // Refund amount
  refundPercent: number;           // 100 = full refund
  
  // Or fixed amount
  refundAmount?: number;
  
  // Store credit option
  offerStoreCredit: boolean;
  storeCreditBonus?: number;       // e.g., 10% extra if take credit
  
  // For last-minute rebooking
  discountOnRebook?: number;       // e.g., 20% off if rebook immediately
}

interface ProviderCancellationCompensation {
  // When client cancels
  whenClientCancels: {
    // Hours before booking
    tiers: {
      minHoursBefore: number;
      compensationPercent: number; // % of expected payment
    }[];
  };
  
  // When organization cancels (e.g., weather)
  whenOrganizationCancels: {
    fullCompensation: boolean;
    partialCompensationPercent?: number;
  };
}

interface NoShowPolicy {
  // Definition
  gracePeriodMinutes: number;      // How late = no-show
  
  // Client consequences
  clientCharge: {
    chargePercent: number;         // % of booking value
    maxAmount?: number;
  };
  
  // Provider compensation
  providerCompensationPercent: number;
  
  // Strikes system
  trackNoShows: boolean;
  maxNoShowsBeforeBan: number;
  banDurationDays: number;
  
  // Notification
  markNoShowAfterMinutes: number;
  autoMarkNoShow: boolean;
}

interface LifecycleConfig {
  // Booking states and transitions
  states: BookingState[];
  
  // Reservation (temporary hold) settings
  reservation: {
    enabled: boolean;
    holdDurationMinutes: number;   // How long to hold slot
    allowExtension: boolean;
    maxExtensions: number;
    extensionDurationMinutes: number;
    
    // Auto-cancel if not confirmed
    autoCancelOnExpiry: boolean;
    
    // Payment requirement
    requireDeposit: boolean;
    depositAmount?: number;
    
    // What happens when expires
    onExpiry: 'release_slot' | 'move_to_waitlist' | 'notify_admin';
  };
  
  // Confirmation requirements
  confirmation: {
    autoConfirm: boolean;          // Or require manual approval
    requirePayment: boolean;       // Must pay to confirm
    requireDeposit: boolean;
    sendConfirmationEmail: boolean;
    sendConfirmationSms: boolean;
    confirmationEmailTemplate?: string;
  };
  
  // Check-in
  checkIn: {
    enabled: boolean;
    openMinutesBefore: number;     // When check-in opens
    closeMinutesAfter: number;     // When check-in closes
    allowEarlyCheckIn: boolean;
    requireCheckIn: boolean;       // Must check in or marked no-show
    
    // Methods
    methods: ('qr_code' | 'manual' | 'geo' | 'self')[];
  };
  
  // Completion
  completion: {
    autoComplete: boolean;
    autoCompleteAfterMinutes: number;
    requireProviderConfirmation: boolean;
  };
  
  // Post-booking
  followUp: {
    sendReviewRequest: boolean;
    reviewRequestDelayHours: number;
    sendThankYouEmail: boolean;
  };
}

interface BookingState {
  name: string;                    // 'pending', 'confirmed', 'checked_in', etc.
  label: string;
  color: string;                   // For UI
  
  // Who can transition to this state
  allowedTransitionsFrom: string[];
  
  // Actions on enter/exit
  onEnter?: WorkflowAction[];
  onExit?: WorkflowAction[];
  
  // Is this a terminal state?
  isTerminal: boolean;
}
```

---

## 4. Booking Lifecycle & Workflows

### 4.1 Booking States

```
┌─────────────┐     Reserve      ┌─────────────┐     Pay/Confirm     ┌─────────────┐
│  AVAILABLE  │ ───────────────→ │  RESERVED   │ ─────────────────→  │   PENDING   │
│    SLOT     │                  │  (HOLD)     │                     │             │
└─────────────┘                  └─────────────┘                     └──────┬──────┘
       ↑                                                                    │
       │                                                                    │ Auto/Manual
       │                                                                    ▼
       │                                                            ┌─────────────┐
       │    Cancel/NoShow                                            │  CONFIRMED  │
       └───────────────────────────────────────────────────────────  │             │
                                                                    └──────┬──────┘
                                                                           │
                                                                           │ Check-in
                                                                           ▼
                                                                    ┌─────────────┐
                                                                    │  CHECKED_IN │
                                                                    │             │
                                                                    └──────┬──────┘
                                                                           │
                                                                           │ Complete
                                                                           ▼
                                                                    ┌─────────────┐
                                                                    │   COMPLETE  │
                                                                    │             │
                                                                    └──────┬──────┘
                                                                           │
                                                                           │ Review
                                                                           ▼
                                                                    ┌─────────────┐
                                                                    │   REVIEWED  │
                                                                    │             │
                                                                    └─────────────┘

ALTERNATE PATHS:

PENDING/CONFIRMED → CANCELLED (by client, provider, or system)
CONFIRMED → NO_SHOW (client doesn't arrive)
RESERVED → EXPIRED (hold time elapsed)
```

### 4.2 Workflow Hooks

```typescript
interface WorkflowConfig {
  // Global webhooks
  webhooks: WebhookConfig[];
  
  // Event-driven actions
  eventHandlers: EventHandler[];
  
  // Custom automation rules
  automationRules: AutomationRule[];
}

interface WebhookConfig {
  id: UUID;
  
  // Trigger events
  events: BookingEvent[];
  
  // Endpoint
  url: string;
  method: 'POST' | 'PUT' | 'PATCH';
  headers: Record<string, string>;
  
  // Retry logic
  retryConfig: {
    maxRetries: number;
    retryDelayMs: number;
    backoffMultiplier: number;
  };
  
  // Security
  secret: string;                  // For HMAC signature
  
  // Filtering
  filter?: {
    states?: string[];             // Only these states
    locations?: UUID[];            // Only these locations
    serviceTemplates?: UUID[];     // Only these services
  };
  
  enabled: boolean;
}

type BookingEvent =
  // Lifecycle events
  | 'booking.created'
  | 'booking.reserved'
  | 'booking.confirmed'
  | 'booking.cancelled'
  | 'booking.rescheduled'
  | 'booking.checked_in'
  | 'booking.completed'
  | 'booking.no_show'
  | 'booking.expired'
  
  // Participant events
  | 'participant.added'
  | 'participant.removed'
  | 'participant.cancelled'
  
  // Resource events
  | 'resource.assigned'
  | 'resource.replaced'
  | 'resource.cancelled'
  
  // Payment events
  | 'payment.received'
  | 'payment.failed'
  | 'payment.refunded'
  | 'deposit.hold_placed'
  | 'deposit.released'
  
  // Notification events
  | 'reminder.sent'
  | 'confirmation.sent'
  | 'review.requested'
  
  // Exception events
  | 'backup.activated'
  | 'waitlist.promoted'
  | 'conflict.detected';

interface EventHandler {
  id: UUID;
  
  trigger: {
    event: BookingEvent;
    conditions?: Condition[];      // Optional filters
  };
  
  actions: WorkflowAction[];
  
  // Timing
  executeImmediately: boolean;
  delayMinutes?: number;           // Or delay execution
  
  // Scope
  enabled: boolean;
  priority: number;                // Execution order
}

interface Condition {
  field: string;                   // 'booking.price', 'participant.count', etc.
  operator: 'equals' | 'not_equals' | 'greater_than' | 'less_than' | 'contains' | 'in';
  value: any;
}

interface WorkflowAction {
  type: 
    | 'send_email'
    | 'send_sms'
    | 'send_push'
    | 'call_webhook'
    | 'update_booking'
    | 'create_task'
    | 'notify_admin'
    | 'trigger_payment'
    | 'generate_invoice'
    | 'update_calendar'
    | 'send_to_integration'
    | 'wait';
  
  config: Record<string, any>;     // Action-specific config
}

// Example automation rules
const exampleRules: AutomationRule[] = [
  {
    id: 'reminder-24h',
    name: 'Send 24-hour reminder',
    trigger: {
      event: 'schedule',
      cron: '0 9 * * *',             // Every day at 9am
    },
    condition: {
      field: 'booking.startTime',
      operator: 'within_hours',
      value: 24,
    },
    action: {
      type: 'send_email',
      template: 'reminder-24h',
      to: '{{booking.participants}}',
    },
  },
  {
    id: 'backup-notify',
    name: 'Notify backup provider',
    trigger: {
      event: 'booking.created',
    },
    condition: {
      field: 'booking.hasBackupProvider',
      operator: 'equals',
      value: true,
    },
    action: {
      type: 'send_email',
      template: 'backup-standby',
      to: '{{booking.backupProvider.email}}',
      delay: { hours: 2 },           // Give primary 2 hours to confirm
    },
  },
  {
    id: 'cancel-underbooked',
    name: 'Auto-cancel underbooked class',
    trigger: {
      event: 'schedule',
      cron: '0 12 * * *',
    },
    condition: {
      field: 'booking.participantCount',
      operator: 'less_than',
      value: '{{booking.serviceTemplate.minParticipants}}',
    },
    action: {
      type: 'update_booking',
      set: { status: 'cancelled', reason: 'underbooked' },
      notify: 'all',
    },
  },
];
```

---

## 5. Multi-Session & Recurring Bookings

### 5.1 Multi-Session Programs

```typescript
interface ProgramTemplate {
  id: UUID;
  organizationId: UUID;
  
  name: string;
  description: string;
  
  // A program consists of multiple sessions
  sessions: ProgramSession[];
  
  // Enrollment
  enrollment: {
    type: 'full_program' | 'drop_in' | 'both';
    
    // Full program pricing
    fullProgramPrice?: number;
    
    // Drop-in pricing (per session)
    dropInPrice?: number;
    
    // Early bird discount
    earlyBirdDiscount?: {
      deadlineDaysBefore: number;
      discountPercent: number;
    };
    
    // Payment plans
    paymentPlan?: {
      enabled: boolean;
      installments: number;
      interval: 'weekly' | 'monthly';
    };
  };
  
  // Attendance requirements
  attendance: {
    minAttendanceRequired: number;   // Must attend X of Y sessions
    allowMissedSessions: boolean;
    makeUpSessionsAvailable: boolean;
  };
  
  // Completion
  completion: {
    certificateIssued: boolean;
    certificateTemplate?: string;
    requireFullAttendance: boolean;
  };
}

interface ProgramSession {
  id: UUID;
  sequenceNumber: number;          // Session 1, 2, 3...
  
  name: string;
  description?: string;
  
  // Timing (relative or absolute)
  timing: {
    type: 'relative' | 'absolute';
    
    // Relative: Days after program start
    daysAfterStart?: number;
    timeOfDay?: string;            // "HH:MM"
    
    // Absolute: Specific date/time
    dateTime?: Timestamp;
  };
  
  // Service template for this session
  serviceTemplateId: UUID;
  
  // Can this session be booked individually?
  allowDropIn: boolean;
  
  // Prerequisites
  requiresPreviousSessions: number; // Must have attended X prior sessions
}

interface ProgramEnrollment {
  id: UUID;
  programTemplateId: UUID;
  participantId: UUID;
  
  enrollmentType: 'full' | 'drop_in';
  
  // For full enrollment
  enrolledSessions: {
    sessionId: UUID;
    bookingId?: UUID;              // Created when scheduled
    status: 'scheduled' | 'completed' | 'missed' | 'cancelled';
  }[];
  
  // Attendance tracking
  attendance: {
    sessionId: UUID;
    attended: boolean;
    checkInTime?: Timestamp;
    notes?: string;
  }[];
  
  // Payment
  payment: {
    totalAmount: number;
    paymentPlan?: {
      installments: {
        dueDate: Timestamp;
        amount: number;
        paid: boolean;
      }[];
    };
  };
  
  // Completion
  completed: boolean;
  completionDate?: Timestamp;
  certificateIssued?: boolean;
}
```

### 5.2 Recurring Bookings

```typescript
interface RecurringBookingRule {
  id: UUID;
  
  // Pattern
  pattern: RecurrencePattern;
  
  // Duration
  startDate: Date;
  endDate?: Date;                  // Or infinite
  maxOccurrences?: number;
  
  // Booking details
  serviceTemplateId: UUID;
  bookables: {
    // Fixed bookables (same every time)
    fixed?: UUID[];
    
    // Or flexible (any available)
    flexible?: boolean;
    flexibleCriteria?: BookableCriteria;
  };
  
  // Participant
  participantId: UUID;
  
  // Exceptions
  exceptions: {
    date: Date;
    action: 'skip' | 'reschedule' | 'cancel';
    newDate?: Date;
  }[];
  
  // Modification rules
  modification: {
    allowParticipantModify: boolean;
    allowParticipantCancel: boolean;
    modificationNoticeHours: number;
    
    // What happens if slot unavailable
    ifSlotUnavailable: 'skip' | 'reschedule' | 'notify' | 'book_alternative';
  };
  
  // Payment
  payment: {
    chargePerOccurrence: boolean;  // Or upfront for all
    autoCharge: boolean;
    
    // Upfront discount
    upfrontDiscountPercent?: number;
  };
}

type RecurrencePattern =
  | { type: 'daily'; interval: number }                    // Every N days
  | { type: 'weekly'; daysOfWeek: string[] }              // Mon, Wed, Fri
  | { type: 'monthly'; dayOfMonth: number }               // 15th of each month
  | { type: 'monthly_nth'; nth: number; dayOfWeek: string } // 2nd Tuesday
  | { type: 'custom'; cronExpression: string };           // Full cron
```

---

## 6. User Management & Roles (Better-Auth Integration)

### 6.1 User Model

```typescript
// Better-Auth integration
// Bizing extends Better-Auth user with organization/role info

interface User {
  // Better-Auth core fields
  id: UUID;
  email: string;
  emailVerified: boolean;
  
  name: string;
  image?: string;
  
  // Auth methods
  accounts: Account[];             // OAuth connections
  sessions: Session[];
  
  // Bizing extensions
  profile: UserProfile;
  
  // Organization memberships
  memberships: OrganizationMembership[];
  
  // Bookings
  bookings: Booking[];             // As participant
  providerBookings: Booking[];     // As provider (if applicable)
  
  // Preferences
  preferences: UserPreferences;
  
  // Audit
  createdAt: Timestamp;
  updatedAt: Timestamp;
  lastLoginAt?: Timestamp;
}

interface UserProfile {
  phone?: string;
  timezone: string;
  locale: string;
  
  // Notification preferences
  notifications: {
    email: boolean;
    sms: boolean;
    push: boolean;
    
    // Granular
    bookingConfirmations: boolean;
    reminders: boolean;
    marketing: boolean;
  };
  
  // Payment
  defaultPaymentMethod?: PaymentMethod;
}

interface OrganizationMembership {
  id: UUID;
  userId: UUID;
  organizationId: UUID;
  
  // Role in this organization
  role: OrganizationRole;
  
  // Location scope (if limited)
  locationIds?: UUID[];            // null = all locations
  
  // Provider link (if user is also a provider)
  providerId?: UUID;
  
  // Status
  status: 'active' | 'inactive' | 'suspended';
  joinedAt: Timestamp;
  invitedBy?: UUID;
}

type OrganizationRole = 
  // Client/Customer
  | 'client'                       // Can book services
  
  // Staff
  | 'staff'                        // Basic employee
  | 'provider'                     // Delivers services
  | 'location_manager'             // Manages location
  
  // Management
  | 'manager'                      // General manager
  | 'admin'                        // Organization admin
  | 'owner';                       // Organization owner

// Role permissions (RBAC)
const RolePermissions: Record<OrganizationRole, Permission[]> = {
  client: [
    'booking:create',
    'booking:view_own',
    'booking:cancel_own',
    'booking:reschedule_own',
  ],
  
  staff: [
    'booking:view_location',
    'booking:create_walkin',
    'booking:check_in',
    'client:view',
  ],
  
  provider: [
    'booking:view_assigned',
    'booking:update_assigned',
    'booking:check_in',
    'availability:manage_own',
    'timesheet:view_own',
  ],
  
  location_manager: [
    'booking:manage_location',
    'provider:manage_location',
    'asset:manage_location',
    'report:view_location',
    'schedule:manage_location',
  ],
  
  manager: [
    'booking:manage_org',
    'provider:manage_org',
    'service_template:manage',
    'report:view_org',
    'setting:view',
  ],
  
  admin: [
    'org:manage',
    'user:manage',
    'billing:manage',
    'integration:manage',
    'setting:manage',
    'audit:view',
  ],
  
  owner: [
    '*',                           // All permissions
  ],
};
```

### 6.2 Multi-Organization Users

```typescript
// User can belong to multiple organizations with different roles

// Example: Dr. Smith
const drSmithMemberships = [
  {
    organizationId: 'hospital-a',
    role: 'provider',
    providerId: 'dr-smith-provider-a',
    locationIds: ['location-1', 'location-2'],
  },
  {
    organizationId: 'clinic-b',
    role: 'provider',
    providerId: 'dr-smith-provider-b',
    locationIds: null,              // All locations
  },
  {
    organizationId: 'teaching-hospital',
    role: 'admin',
    providerId: null,               // Admin only
  },
];

// Switching context in UI
interface ActiveOrganizationContext {
  organizationId: UUID;
  role: OrganizationRole;
  permissions: Permission[];
  providerId?: UUID;
}
```

---

## 7. Advanced Features

### 7.1 Walk-Ins

```typescript
interface WalkInConfig {
  enabled: boolean;
  
  // How to handle
  mode: 'queue' | 'immediate' | 'scheduled';
  
  // Queue mode
  queue?: {
    maxQueueSize: number;
    estimatedWaitDisplay: boolean;
    priorityRules: PriorityRule[]; // Members first, etc.
  };
  
  // Immediate mode
  immediate?: {
    requireAvailableSlot: boolean;
    allowDoubleBooking: boolean;
    maxOverbookPercent: number;
  };
  
  // Scheduled (book for later today)
  scheduled?: {
    allowSameDayBooking: boolean;
    minNoticeMinutes: number;
  };
  
  // Payment
  payment: {
    requireUpfront: boolean;
    allowPayAfter: boolean;
  };
  
  // Registration
  registration: {
    requireAccount: boolean;
    allowGuest: boolean;
    collectMinimalInfo: boolean;
  };
}
```

### 7.2 Bundling & Packages

```typescript
interface ServicePackage {
  id: UUID;
  organizationId: UUID;
  
  name: string;
  description: string;
  
  // Included services
  items: PackageItem[];
  
  // Pricing
  pricing: {
    // Bundle discount
    totalPrice: number;
    
    // Or dynamic
    discountType: 'fixed_amount' | 'percentage' | 'free_item';
    discountValue: number;
    
    // Show savings
    originalTotal: number;
    savingsAmount: number;
  };
  
  // Usage
  usage: {
    // Fixed schedule
    fixedSchedule?: {
      allAtOnce: boolean;
      intervalDays?: number;       // e.g., every 30 days
    };
    
    // Flexible
    flexible?: {
      useWithinDays: number;       // Must use within X days
      allowAnyOrder: boolean;
    };
  };
  
  // Transferability
  allowTransfer: boolean;
  transferFee?: number;
  
  // Expiration
  expiresAfterDays?: number;
  
  // Gift options
  isGiftable: boolean;
  giftMessage?: string;
}

interface PackageItem {
  serviceTemplateId: UUID;
  quantity: number;
  
  // Restrictions
  allowedLocations?: UUID[];
  allowedProviders?: UUID[];
  excludedDates?: Date[];
  
  // Upgrade options
  upgradable: boolean;
  upgradeOptions?: UUID[];         // Can upgrade to these services
  upgradeFee?: number;
}
```

### 7.3 Airbnb/Uber Clone Considerations

```typescript
// AIRBNB-STYLE RENTALS

interface RentalConfig {
  // Property details
  propertyType: 'entire_place' | 'private_room' | 'shared_room';
  
  // Availability
  availability: {
    minNights: number;
    maxNights: number;
    
    // Lead time
    minAdvanceBookingDays: number;
    maxAdvanceBookingMonths: number;
    
    // Check-in/out
    checkInTime: string;           // "15:00"
    checkOutTime: string;          // "11:00"
    
    // Gap nights
    minGapBetweenBookings: number; // Days for cleaning
  };
  
  // Pricing
  pricing: {
    baseNightlyRate: number;
    
    // Dynamic
    dynamicPricingEnabled: boolean;
    
    // Length discounts
    weeklyDiscount: number;        // % off for 7+ nights
    monthlyDiscount: number;       // % off for 30+ nights
    
    // Extra fees
    cleaningFee: number;
    serviceFee: number;
    securityDeposit: number;
    
    // Taxes
    taxRate: number;
  };
  
  // House rules
  houseRules: {
    maxGuests: number;
    allowPets: boolean;
    allowSmoking: boolean;
    allowParties: boolean;
    quietHours: { start: string; end: string };
    additionalRules: string[];
  };
  
  // Instant book vs request
  bookingMode: 'instant' | 'request';
  
  // Cancellation (strict, moderate, flexible)
  cancellationPolicy: 'flexible' | 'moderate' | 'strict' | 'super_strict';
}

// UBER-STYLE ON-DEMAND

interface OnDemandConfig {
  // Real-time availability
  realTimeTracking: boolean;
  
  // Pricing
  pricing: {
    baseFare: number;
    perMinuteRate: number;
    perMileRate: number;
    
    // Surge
    surgePricing: {
      enabled: boolean;
      maxMultiplier: number;
    };
    
    // Estimates
    showUpfrontPrice: boolean;
  };
  
  // Matching
  matching: {
    algorithm: 'closest' | 'rating' | 'eta' | 'balanced';
    maxMatchRadius: number;        // miles
    matchTimeoutSeconds: number;
  };
  
  // Trip lifecycle
  trip: {
    requireConfirmation: boolean;
    allowDestinationChange: boolean;
    supportMultipleStops: boolean;
    
    // Tracking
    shareTripStatus: boolean;
    liveTracking: boolean;
  };
}
```

### 7.4 Cinema, Car Rental, etc.

```typescript
// CINEMA/THEATER

interface CinemaConfig {
  venue: {
    screenCount: number;
    seatsPerScreen: number[];
    
    // Seating chart
    seatMap: {
      rows: number;
      seatsPerRow: number;
      aisles: number[];
      seatTypes: ('standard' | 'vip' | 'accessible' | 'companion')[];
    };
  };
  
  // Showings
  showings: {
    movieId: string;
    screenId: string;
    startTime: Timestamp;
    
    // Pricing by seat type
    pricing: {
      standard: number;
      vip: number;
      accessible: number;
    };
    
    // Availability
    seatsAvailable: number;
    seatsBooked: number[];         // Seat IDs
    seatsHeld: number[];           // In cart but not paid
    
    // Sale windows
    onSaleDate: Timestamp;
    saleEnds: Timestamp;
  };
  
  // Concessions upsell
  concessions: {
    combos: ComboOffer[];
    preorderEnabled: boolean;
    pickupTime: 'before' | 'intermission' | 'after';
  };
}

// CAR RENTAL

interface CarRentalConfig {
  fleet: {
    vehicle: Asset;                  // Car as asset
    
    // Availability
    availableFrom: Timestamp;
    availableUntil: Timestamp;
    
    // Pickup/return
    defaultPickupLocation: UUID;
    allowDifferentReturnLocation: boolean;
    differentReturnFee?: number;
    
    // Pricing
    dailyRate: number;
    weeklyRate: number;
    monthlyRate: number;
    
    // Add-ons
    addOns: {
      insurance: InsuranceOption[];
      gps: number;
      childSeat: number;
      additionalDriver: number;
    };
    
    // Requirements
    minDriverAge: number;
    maxDriverAge?: number;
    requiredLicenseType: string;
    creditCardRequired: boolean;
  };
  
  // Booking
  booking: {
    minRentalDays: number;
    maxRentalDays: number;
    
    // Extensions
    allowExtension: boolean;
    extensionNoticeHours: number;
    
    // Early return
    earlyReturnRefund: 'none' | 'partial' | 'prorated';
  };
}
```

### 7.5 Audit Logging & Compliance

```typescript
interface AuditLog {
  id: UUID;
  organizationId: UUID;
  
  // Who
  actorId: UUID;
  actorType: 'user' | 'system' | 'integration' | 'webhook';
  actorRole?: string;
  
  // What
  action: string;                  // 'booking.created', 'user.login', etc.
  resourceType: string;            // 'booking', 'user', 'payment'
  resourceId: UUID;
  
  // Details
  changes: {
    field: string;
    oldValue: any;
    newValue: any;
  }[];
  
  metadata: {
    reason?: string;
    ipAddress?: string;
    userAgent?: string;
    sessionId?: string;
    requestId?: string;
    correlationId?: string;
  };
  
  // When
  timestamp: Timestamp;
  timezone: string;
  
  // Compliance
  classification: 'general' | 'phi' | 'pii' | 'financial';
  retentionYears: number;
  
  // Integrity
  hash: string;                    // SHA-256 of log entry
  previousHash?: string;           // For blockchain-style chain
}

// Access logging for HIPAA/compliance
interface AccessLog {
  id: UUID;
  
  userId: UUID;
  userRole: string;
  
  resourceType: 'phi' | 'pii' | 'booking' | 'payment';
  resourceId: UUID;
  
  accessType: 'view' | 'create' | 'update' | 'delete' | 'export' | 'print';
  
  // Context
  purpose?: string;                // Why was this accessed?
  patientAuthorization?: boolean;  // For healthcare
  
  timestamp: Timestamp;
  
  // Anomaly detection
  isAfterHours: boolean;
  isUnusualLocation: boolean;
  isBulkAccess: boolean;
}
```

---

## 8. Database Schema Summary

### 8.1 Core Tables

```sql
-- Organizations & Hierarchy
organizations
├── id (PK)
├── slug (unique)
├── name
├── type
├── config (JSONB)
├── features (JSONB)
├── compliance (JSONB)
├── auth_config (JSONB)
├── created_at
└── deleted_at

locations
├── id (PK)
├── organization_id (FK)
├── parent_location_id (FK, self-ref)
├── name
├── type
├── address (JSONB)
├── timezone
├── config (JSONB)
└── operating_hours (JSONB)

-- Users & Auth (Better-Auth extended)
users
├── id (PK)
├── email (unique)
├── email_verified
├── name
├── image
├── profile (JSONB)
├── preferences (JSONB)
└── created_at

organization_memberships
├── id (PK)
├── user_id (FK)
├── organization_id (FK)
├── role
├── location_ids (UUID[])
├── provider_id (FK)
├── status
└── joined_at

-- Bookables (Polymorphic)
bookables
├── id (PK)
├── organization_id (FK)
├── location_id (FK)
├── type (provider|asset|venue|virtual)
├── name
├── slug
├── description
├── category_id (FK)
├── tags (text[])
├── images (JSONB)
├── settings (JSONB)
├── calendar_id (FK)
├── status
├── is_soft_deleted
├── deleted_at
├── deleted_by (FK)
└── created_at

providers (extends bookables)
├── bookable_id (PK, FK)
├── user_id (FK)
├── email
├── phone
├── bio
├── specialties (text[])
├── certifications (JSONB)
├── payment_profile (JSONB)
├── max_daily_bookings
├── can_work_at_locations (UUID[])
└── travel_radius

assets (extends bookables)
├── bookable_id (PK, FK)
├── asset_type
├── serial_number
├── specifications (JSONB)
├── maintenance_schedule (JSONB)
├── condition
└── total_usage_hours

venues (extends bookables)
├── bookable_id (PK, FK)
├── capacity (JSONB)
├── square_footage
├── layout
├── amenities (text[])
├── parent_venue_id (FK)
└── allow_simultaneous_bookings

-- Calendars & Availability
calendars
├── id (PK)
├── organization_id (FK)
├── location_id (FK)
├── bookable_id (FK)
├── name
├── type
├── timezone
├── default_pattern (JSONB)
└── cascading_config (JSONB)

availability_slots
├── id (PK)
├── calendar_id (FK)
├── start_time
├── end_time
├── timezone
├── status
├── reservation_id (FK)
├── booking_id (FK)
├── is_cascading_open
└── is_premium_slot

-- Service Templates
service_templates
├── id (PK)
├── organization_id (FK)
├── location_id (FK)
├── name
├── slug
├── type
├── duration_config (JSONB)
├── bookables_config (JSONB)
├── capacity_config (JSONB)
├── pricing_config (JSONB)
├── scheduling_config (JSONB)
├── cancellation_config (JSONB)
├── lifecycle_config (JSONB)
├── workflow_config (JSONB)
├── status
├── is_soft_deleted
└── version

-- Bookings
bookings
├── id (PK)
├── organization_id (FK)
├── location_id (FK)
├── service_template_id (FK)
├── status
├── start_time
├── end_time
├── timezone
├── booker_id (FK)
├── pricing_snapshot (JSONB)
├── payment_status
├── cancellation_reason
├── cancelled_at
├── checked_in_at
├── completed_at
├── metadata (JSONB)
└── created_at

booking_participants
├── id (PK)
├── booking_id (FK)
├── user_id (FK)
├── email
├── name
├── role (primary|observer|guest)
├── status
├── checked_in_at
└── is_observer

booking_bookables
├── id (PK)
├── booking_id (FK)
├── bookable_id (FK)
├── bookable_type
├── role
├── requirement_type
├── compensation_amount
├── is_backup
├── confirmed
└── notes

-- Payments
payment_transactions
├── id (PK)
├── booking_id (FK)
├── type (deposit|full|partial|refund|compensation)
├── amount
├── currency
├── status
├── provider (stripe|square|paypal)
├── provider_transaction_id
├── metadata (JSONB)
└── created_at

-- Reservations (temporary holds)
reservations
├── id (PK)
├── slot_id (FK)
├── service_template_id (FK)
├── user_id (FK)
├── status
├── expires_at
├── deposit_amount
└── created_at

-- Programs (multi-session)
program_templates
├── id (PK)
├── organization_id (FK)
├── name
├── sessions (JSONB)
├── enrollment_config (JSONB)
└── created_at

program_enrollments
├── id (PK)
├── program_template_id (FK)
├── participant_id (FK)
├── enrolled_sessions (JSONB)
├── attendance (JSONB)
└── payment_plan (JSONB)

-- Audit & Compliance
audit_logs
├── id (PK)
├── organization_id (FK)
├── actor_id
├── actor_type
├── action
├── resource_type
├── resource_id
├── changes (JSONB)
├── metadata (JSONB)
├── classification
├── timestamp
└── hash
```

---

## 9. API Design Overview

### 9.1 Key Endpoints

```typescript
// Organization Management
POST   /api/v1/organizations
GET    /api/v1/organizations/:id
PATCH  /api/v1/organizations/:id
DELETE /api/v1/organizations/:id

// Locations
GET    /api/v1/organizations/:orgId/locations
POST   /api/v1/organizations/:orgId/locations
GET    /api/v1/locations/:id
PATCH  /api/v1/locations/:id

// Bookables (Polymorphic)
GET    /api/v1/organizations/:orgId/bookables
POST   /api/v1/organizations/:orgId/bookables/providers
POST   /api/v1/organizations/:orgId/bookables/assets
POST   /api/v1/organizations/:orgId/bookables/venues
GET    /api/v1/bookables/:id
PATCH  /api/v1/bookables/:id
DELETE /api/v1/bookables/:id

// Availability
GET    /api/v1/calendars/:id/slots
POST   /api/v1/calendars/:id/blocks          // Block time
GET    /api/v1/bookables/:id/availability    // Query availability

// Service Templates
GET    /api/v1/organizations/:orgId/service-templates
POST   /api/v1/organizations/:orgId/service-templates
GET    /api/v1/service-templates/:id
PATCH  /api/v1/service-templates/:id
DELETE /api/v1/service-templates/:id

// Bookings
GET    /api/v1/organizations/:orgId/bookings
POST   /api/v1/bookings                       // Create booking
GET    /api/v1/bookings/:id
PATCH  /api/v1/bookings/:id                   // Reschedule, etc.
DELETE /api/v1/bookings/:id                   // Cancel
POST   /api/v1/bookings/:id/check-in
POST   /api/v1/bookings/:id/complete

// Reservations (temporary holds)
POST   /api/v1/reservations                   // Hold slot
PATCH  /api/v1/reservations/:id/confirm       // Convert to booking
DELETE /api/v1/reservations/:id               // Release hold

// Search & Discovery
GET    /api/v1/search/availability            // Find available slots
GET    /api/v1/search/bookables               // Search providers/assets
POST   /api/v1/search/query                   // Complex search

// Programs (multi-session)
GET    /api/v1/organizations/:orgId/programs
POST   /api/v1/programs/:id/enroll
GET    /api/v1/programs/enrollments/:id

// Waitlists
POST   /api/v1/bookings/:id/waitlist          // Join waitlist
GET    /api/v1/waitlists/:id/position
DELETE /api/v1/waitlists/:id                  // Leave waitlist

// Timesheets & Compensation
GET    /api/v1/providers/:id/timesheets
GET    /api/v1/providers/:id/compensation
POST   /api/v1/bookings/:id/compensation      // Record payment to provider

// Webhooks
GET    /api/v1/organizations/:orgId/webhooks
POST   /api/v1/organizations/:orgId/webhooks
DELETE /api/v1/webhooks/:id

// Audit
GET    /api/v1/organizations/:orgId/audit-logs
GET    /api/v1/bookings/:id/audit-trail
```

---

## 10. Implementation Phases

### Phase 1: Foundation (Weeks 1-4)
- Organization & location hierarchy
- Basic bookables (providers, assets)
- Simple service templates
- 1:1 booking flow
- Better-Auth integration

### Phase 2: Core Booking (Weeks 5-8)
- Calendar & availability system
- Cascading slots
- Multi-host support
- Asset pairing
- Cancellation & refunds

### Phase 3: Advanced Features (Weeks 9-12)
- Group bookings
- Waitlists
- Recurring bookings
- Multi-session programs
- Packages/bundles

### Phase 4: Business Logic (Weeks 13-16)
- Dynamic pricing
- Provider compensation
- Timesheets
- Payment processing
- Webhooks & integrations

### Phase 5: Enterprise (Weeks 17-20)
- Multi-location chains
- Advanced RBAC
- Audit logging
- Compliance features
- Performance optimization

---

## 11. Open Questions

1. **Venue vs Asset:** Should venues be separate or under assets? **Current decision:** Separate, because venues have unique properties (capacity, layout, multiple simultaneous bookings).

2. **Observer Bookings:** How handle when primary booker cancels but observers remain? **Current decision:** Configurable per template—either cancel all, transfer to observer, or require new primary.

3. **Multi-day Bookings:** Airbnb-style check-in/check-out or discrete slots? **Current decision:** Both supported via duration config (range vs discrete).

4. **Walk-ins:** Queue system or immediate slot assignment? **Current decision:** Configurable per location—queue, immediate, or scheduled.

---

*Technical Specification for Bizing Booking System. Version 1.0. Generated 2026-02-16.*

<!-- Surreally collided with insights/2026-02-17-autonomous-infrastructure-enables-true.md & HEARTBEAT.md & dissonance/2026-02-18-conflicting-instructions-on-when-to-load-memory.md & curiosities/2026-02-18-beyond-the-existing-business-model-curiosities.md in 2026-02-19-09-17-44-collision.md -->
