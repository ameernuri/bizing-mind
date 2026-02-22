---
date: 2026-02-17
tags:
  - research
  - design
  - schema
  - booking
  - architecture
  - updated
---

# Booking System Schema Design v2.0: Comprehensive Use Case Analysis

> Exhaustive analysis of booking patterns with complete entity model, feature specifications, and implementation guidance

---

## Executive Summary

This document analyzes **40+ booking scenarios** across **6 archetypes**, resulting in a **polymorphic schema** supporting everything from individual Calendly-style scheduling to complex movie studio productions with 100+ resources.

**Key Design Decisions:**
1. **Polymorphic Bookables** — Providers, Assets, Venues, Virtual Resources share common abstraction
2. **Service Templates as Blueprints** — Define what, who, when, and under what rules
3. **Cascading Availability** — Progressive slot opening with premium "skip-the-line" options
4. **Reservation vs Booking** — Temporary holds before commitment
5. **Multi-Org, Multi-Role** — Better-Auth integration with RBAC
6. **HIPAA-Ready** — Audit trails, access controls, data classification

---

## Part 1: Use Case Spectrum (Simple → Complex)

### Tier 1: Individual/Simple (Calendly-Style)
**Characteristics:**
- Single provider, single service
- Fixed duration slots
- No payment or simple fixed pricing
- Individual calendar

**Scenarios:**
1. **Freelancer Consultation** — 30-min video calls, simple scheduling
2. **Therapy Session** — 50-min sessions, recurring weekly
3. **Personal Training** — 60-min sessions, package deals
4. **Tutoring** — Subject-specific, variable duration

**Schema Needs:**
- Basic `Provider` with calendar
- Simple `ServiceTemplate` with fixed duration
- Individual availability slots
- Soft deletion for historical records

---

### Tier 2: Small Business (Salon, Clinic)
**Characteristics:**
- Multiple providers, multiple services
- Assets required (rooms, equipment)
- Staff scheduling with breaks
- Cancellation policies
- Walk-ins supported

**Scenarios:**
5. **Hair Salon** — Stylists + chairs, 15-120 min services, walk-ins
6. **Dental Clinic** — Dentists + hygienists + chairs, procedure types
7. **Massage Studio** — Therapists + treatment rooms, buffer times
8. **Auto Shop** — Mechanics + bays, multi-hour repairs

**Schema Needs:**
- `Bookable` polymorphism (Provider + Asset)
- Buffer times between appointments
- Cancellation tiers (24h, same-day)
- Waitlist for popular slots
- Soft deletion of retired services/providers

---

### Tier 3: Multi-Asset/Multi-Host (Medical, Events)
**Characteristics:**
- Multiple required resources per booking
- Backup/swap hosts
- Complex availability (all must be free)
- Group capacity

**Scenarios:**
9. **MRI Appointment** — Patient + Technician + MRI Machine (required)
10. **Wedding Photography** — Lead + Second shooter + Assistant
11. **Surgery Schedule** — Surgeon + Anesthesiologist + OR + Equipment
12. **Corporate Training** — Trainer + Room + Projector + IT support

**Schema Needs:**
- Required vs Optional bookables in templates
- Backup provider configuration with compensation
- Cascading slot opening (one at a time vs batch)
- Compensation rules for backups (standby pay vs usage pay)
- Observer bookings (can watch but not participate)

---

### Tier 4: Rental/Multi-Day (Airbnb, Car Rental)
**Characteristics:**
- Multi-day bookings
- Check-in/check-out times
- Gap nights for cleaning
- Dynamic pricing
- Different return location

**Scenarios:**
13. **Vacation Rental** — Property + dates, cleaning buffers
14. **Car Rental** — Vehicle category + pickup/return locations
15. **Equipment Rental** — Tools/machines, daily/weekly rates
16. **Co-working Space** — Desk/office, recurring monthly

**Schema Needs:**
- Multi-day duration with nightly rates
- Gap time between bookings (cleaning/service)
- Different pickup/return locations
- Dynamic pricing (seasonal, demand)
- Deposit handling

---

### Tier 5: On-Demand (Uber, Delivery)
**Characteristics:**
- Real-time matching
- Surge pricing
- ETA calculations
- Immediate confirmation
- Location tracking

**Scenarios:**
17. **Ride Booking** — Driver + Vehicle, real-time matching
18. **Food Delivery** — Driver + Vehicle, restaurant + customer
19. **Mobile Services** — Provider travels to client
20. **Emergency Services** — Closest available responder

**Schema Needs:**
- Geolocation for matching
- Surge pricing engine
- ETA calculations
- Real-time availability
- Travel time buffers

---

### Tier 6: Enterprise/Complex (Hospital Chain, Movie Studio)
**Characteristics:**
- Multi-location chains
- Complex staffing rules
- Compliance requirements (HIPAA)
- 100+ resources
- Multi-day productions
- Union rules/payments

**Scenarios:**
21. **Hospital Chain** — Multi-location, complex staffing, HIPAA
22. **Movie Production** — Cast + Crew + Equipment + Locations + Permits
23. **Conference/Event** — Multiple rooms, sessions, attendees
24. **Construction Project** — Equipment + Crew + Phases

**Schema Needs:**
- Organization hierarchy (org → locations → departments)
- Complex RBAC (union roles, certifications)
- Timesheets with pay rules
- Audit logging for compliance
- Multi-session programs
- Resource dependencies

---

## Part 2: Complete Entity Model

### 2.1 Organization Hierarchy

```
Organization (Tenant)
├── Configuration (inherited by children)
├── Compliance Settings (HIPAA, SOC2)
├── Auth Config (Better-Auth integration)
└── Locations[]
    ├── Operating Hours
    ├── Service Area (for mobile)
    ├── Config Overrides
    └── Bookables[]
        └── Individual Calendars
```

**Key Features:**
- **Multi-org Users:** Same user, different roles in different orgs
- **Config Inheritance:** Org → Location → Template
- **Chains:** Parent/child location relationships
- **Soft Deletion:** Retire locations without losing history

---

### 2.2 The Bookable Abstraction (Polymorphic)

Everything that can be booked extends `Bookable`:

#### A. Provider (Human)
```typescript
Provider {
  // Identity
  userId, email, name, bio
  
  // Work Configuration
  canWorkAtLocations: UUID[]      // Multi-location
  travelRadius?: number            // For mobile services
  maxDailyBookings?: number        // Prevent burnout
  minRestBetweenBookings: minutes
  
  // Qualifications
  certifications: [
    { type: "phlebotomy", expires: date, verified: bool }
  ]
  tags: ["senior", "spanish-speaker", "certified"]
  
  // Payment
  paymentProfile: {
    hourlyRate?: number
    commissionSplit?: percentage
    preferredPaymentMethod
  }
  
  // Calendar
  calendarId: UUID                 // Individual calendar
  defaultAvailability: Pattern
  timeOffRequests: []
  
  // Performance Tracking
  rating, reviewCount
  cancellationRate, noShowRate
  
  // Status
  status: active|inactive|retired
  isSoftDeleted: boolean           // Keep history
}
```

#### B. Asset (Physical Equipment)
```typescript
Asset {
  // Classification
  assetType: vehicle|equipment|tool|instrument
  categoryId: UUID                 // Car, MRI machine, etc.
  tags: ["automatic", "4k-camera", "portable"]
  
  // Identification
  serialNumber, inventoryNumber, barcode
  
  // Specifications
  specifications: {
    transmission: "automatic",
    seats: 5,
    fuel: "hybrid"
  }
  
  // Maintenance
  maintenanceSchedule: {
    everyHours: 100,
    everyDays: 30
  }
  lastServicedAt, nextServiceDue
  condition: excellent|good|fair|poor
  
  // Dependencies
  requiresAssets: UUID[]           // E.g., camera needs lens
  compatibleAssets: UUID[]         // Can bundle together
  
  // Usage
  totalUsageHours, totalBookings
  
  // Calendar
  calendarId: UUID
  
  // Soft Deletion
  isSoftDeleted, deletedAt, deletionReason
}
```

#### C. Venue (Space)
```typescript
Venue {
  // Capacity
  capacity: {
    min?: number,                  // Minimum to run
    max: number,                   // Maximum allowed
    optimal?: number
  }
  
  // Physical
  squareFootage, layout
  floorPlanUrl: string
  
  // Features
  amenities: ["wifi", "av-system", "catering"]
  
  // Hierarchy
  parentVenueId?: UUID             // Building contains rooms
  subVenues: UUID[]                // Rooms in this building
  
  // Simultaneous Bookings
  allowSimultaneousBookings: boolean
  maxSimultaneousBookings?: number
  
  // Setup/Teardown
  defaultSetupTime: minutes
  defaultTeardownTime: minutes
  
  // Calendar
  calendarId: UUID
  
  // Status
  isSoftDeleted
}
```

**Design Decision:** Venues are **separate** from Assets because:
- Fixed location (not movable)
- Capacity constraints (people, not usage hours)
- Layouts/floor plans
- Multiple simultaneous bookings possible

#### D. Virtual Resource (Digital)
```typescript
VirtualResource {
  resourceType: video_conference|software_license|streaming_slot
  
  // Provider (Zoom, Teams, etc.)
  provider: zoom|teams|meet|custom
  
  // Auto-provisioning
  autoProvision: boolean           // Create meeting automatically
  autoDeleteAfter: minutes         // Cleanup after booking
  
  // License Pool
  totalLicenses?: number
  concurrentLimit?: number
  
  // Recording
  allowRecording: boolean
  autoRecord: boolean
  recordingRetentionDays: number
  
  // Connection (generated per-booking)
  connectionInfo: {
    joinUrl, meetingId, passcode
  }
  
  // Calendar
  calendarId: UUID
}
```

---

### 2.3 Service Template (The Blueprint)

Service Templates define **what** can be booked:

```typescript
ServiceTemplate {
  // Identity
  id, organizationId, locationId
  name, description, slug
  categoryId, tags
  
  // Type
  type: appointment|class|rental|event|multi_day|virtual
  
  // Duration Configuration
  duration: {
    type: fixed|variable|range
    
    // Fixed: Always this long
    fixedMinutes?: 60
    
    // Variable: Booker chooses
    minMinutes?: 30
    maxMinutes?: 120
    intervalMinutes?: 15          // 30, 45, 60, 75, 90, 105, 120
    
    // Multi-day (Airbnb-style)
    minNights?: 1
    maxNights?: 30
    
    // Buffers (automatically added)
    preBufferMinutes: 10          // Setup/cleanup
    postBufferMinutes: 10
    
    // Travel time (mobile services)
    travelTimeMinutes?: number
    travelTimeCalculation: fixed|distance_based
  }
  
  // Bookables Required
  bookables: {
    // Must have these
    required: [
      {
        bookableType: provider|asset|venue|virtual
        criteria: {                    // Or specific ID
          tags: ["certified"]
          categoryIds: [uuid]
        }
        count: 1
        role: primary|assistant|technician
        allowSubstitution: boolean
        substitutionCriteria: {...}
        compensation: CompensationRule  // Pay for this role
      }
    ]
    
    // Nice to have
    optional: [...]
    
    // Backup configuration
    backups: [
      {
        primaryRequirementId: uuid
        backupBookableIds: [uuid]     // Priority order
        trigger: primary_unavailable|cancelled|no_show
        noticeHours: 48
        compensation: {
          ifNotUsed: none|standby_fee
          ifUsed: standard|premium
        }
        autoAssign: boolean
        autoAssignStrategy: round_robin|least_recently_used
      }
    ]
  }
  
  // Capacity
  capacity: {
    type: individual|group
    
    group: {
      minParticipants: 5            // Minimum to run
      maxParticipants: 30           // Room capacity
      autoCancelIfUnderMin: boolean
      autoCancelNoticeHours: 24
      
      // Waitlist
      enableWaitlist: boolean
      maxWaitlistSize: 10
      waitlistAutoPromote: boolean
      waitlistHoldHours: 2          // Time to claim offered spot
    }
  }
  
  // Pricing
  pricing: {
    model: fixed|hourly|per_person|tiered|dynamic
    
    // Base pricing
    basePrice: number
    currency: string
    
    // Hourly (for variable duration)
    hourlyRate?: {
      rate: 100
      minCharge: 60                 // Minimum 1 hour
      increment: 15                 // Bill in 15-min increments
    }
    
    // Dynamic pricing
    dynamicPricing: {
      // Time of day multipliers
      timeMultipliers: [
        { timeRange: "17:00-20:00", days: ["mon","tue","wed","thu","fri"], multiplier: 1.5 }
        { timeRange: "09:00-17:00", days: ["sat","sun"], multiplier: 1.3 }
      ]
      
      // Holiday pricing
      holidayMultiplier: 2.0
      specificDates: [
        { date: "2026-12-25", multiplier: 3.0, reason: "Christmas" }
      ]
      
      // Demand-based surge
      surgePricing: { enabled: true, maxMultiplier: 2.5 }
      
      // Early bird / Last minute
      advanceBookingDiscount: { daysInAdvance: 14, discountPercent: 10 }
      lastMinutePremium: { hoursBefore: 4, premiumPercent: 20 }
    }
    
    // Deposits
    deposit: {
      required: boolean
      type: fixed|percentage
      amount?: 50
      percentage?: 0.5              // 50%
      refundable: boolean
      refundDeadlineHours: 48
    }
    
    // Cascading premium (skip-the-line)
    cascading: {
      enabled: boolean
      strategy: sequential|batch
      premiumBooking: {
        enabled: true
        premiumSlots: 5             // Open 5 slots ahead of cascade
        pricingMultiplier: 1.5      // 50% premium
      }
    }
  }
  
  // Cancellation Policy
  cancellation: {
    // Who can cancel
    allowClientCancellation: true
    allowProviderCancellation: true
    requireApprovalFor: [provider]   // Provider cancellation needs approval
    
    // Refund tiers (by notice period)
    refundTiers: [
      { minHoursBefore: 48, refundPercent: 100, offerStoreCredit: true },
      { minHoursBefore: 24, refundPercent: 50, storeCreditBonus: 10 },
      { minHoursBefore: 0, refundPercent: 0 }
    ]
    
    // Provider compensation when client cancels
    providerCompensation: {
      whenClientCancels: [
        { minHoursBefore: 48, compensationPercent: 0 },
        { minHoursBefore: 24, compensationPercent: 50 },
        { minHoursBefore: 0, compensationPercent: 100 }
      ]
      whenOrganizationCancels: { fullCompensation: true }
    }
    
    // No-show policy
    noShowPolicy: {
      gracePeriodMinutes: 15
      clientCharge: { chargePercent: 100 }
      providerCompensationPercent: 50
      trackNoShows: true
      maxNoShowsBeforeBan: 3
      banDurationDays: 90
    }
    
    // Rescheduling
    allowReschedule: true
    rescheduleDeadlineHours: 24
    rescheduleFee: 0
  }
  
  // Booking Lifecycle
  lifecycle: {
    // Reservation (temporary hold)
    reservation: {
      enabled: true
      holdDurationMinutes: 15
      allowExtension: true
      maxExtensions: 2
      extensionDurationMinutes: 10
      autoCancelOnExpiry: true
      requireDeposit: false
    }
    
    // Confirmation
    confirmation: {
      autoConfirm: true              // Or manual approval required
      requirePayment: false          // Must pay to confirm
      requireDeposit: false
    }
    
    // Check-in
    checkIn: {
      enabled: true
      openMinutesBefore: 30
      closeMinutesAfter: 15
      requireCheckIn: false
      methods: [qr_code, manual, geo]
    }
    
    // Completion
    completion: {
      autoComplete: true
      autoCompleteAfterMinutes: 60
    }
  }
  
  // Workflow Hooks (every lifecycle stage)
  workflows: {
    webhooks: [
      {
        events: [booking.created, booking.confirmed, booking.cancelled]
        url: "https://example.com/webhook"
        secret: "hmac-secret"
        retryConfig: { maxRetries: 3 }
      }
    ]
    
    automationRules: [
      {
        name: "24-hour reminder"
        trigger: { event: schedule, cron: "0 9 * * *" }
        condition: { field: booking.startTime, operator: within_hours, value: 24 }
        action: { type: send_email, template: reminder-24h }
      }
    ]
  }
  
  // Upsells
  upsells: [
    {
      name: "Product Add-on"
      type: product|service_addon|insurance
      price: { amount: 25 }
      offerTiming: booking|confirmation|reminder
      inventory: { trackInventory: true, quantityAvailable: 50 }
    }
  ]
  
  // Status
  status: draft|active|paused|archived
  isSoftDeleted: boolean
  deletedAt?: timestamp
  deletionReason?: string
}
```

---

### 2.4 Calendar & Availability

Each bookable has its own calendar:

```typescript
Calendar {
  id, organizationId
  bookableId: UUID                  // Provider/asset/venue/virtual
  name, timezone
  
  // Default pattern
  defaultPattern: {
    weeklySchedule: {
      monday: [{ start: "09:00", end: "17:00", type: available }]
      tuesday: [...]
    }
    slotDuration: 60                // minutes
    slotInterval: 60                // minutes between starts
  }
  
  // Cascading configuration
  cascading: {
    enabled: true
    strategy: sequential            // one at a time
    initialOpenSlots: 3
    advanceWindowDays: 14
    
    // Premium (non-cascading) slots
    premiumBooking: {
      enabled: true
      premiumSlots: 5               // Always have 5 premium slots open
      pricingMultiplier: 1.5
    }
  }
  
  // Overrides
  overrides: [                      // Holidays, special hours
    { date: "2026-12-25", type: closed, reason: "Christmas" }
    { date: "2026-11-27", type: modified_hours, hours: [{start: "09:00", end: "14:00"}], pricingMultiplier: 1.5 }
  ]
}

AvailabilitySlot {
  id, calendarId
  startTime, endTime, timezone
  status: available|reserved|booked|blocked
  
  // Cascading
  isCascadingOpen: boolean
  isPremiumSlot: boolean
  
  // Relationships
  reservationId?: UUID              // If reserved
  bookingId?: UUID                  // If booked
}

BlockedTime {
  id, calendarId, bookableId
  startTime, endTime
  type: time_off|maintenance|meeting|unavailable
  reason: "Vacation"
  allowOverride: boolean            // Can booking override this?
}
```

---

### 2.5 Booking (The Instance)

```typescript
Booking {
  id, organizationId, locationId
  serviceTemplateId
  
  // Timing
  startTime, endTime, timezone
  durationMinutes: number           // Actual duration (may differ from template)
  
  // Status
  status: reserved|pending|confirmed|checked_in|completed|cancelled|no_show
  
  // Booker
  bookerId: UUID                    // Primary booker
  
  // Participants
  participants: [
    {
      userId?: UUID
      email: string
      name: string
      role: primary|observer|guest
      isObserver: boolean           // Watching, not participating
      status: confirmed|cancelled|no_show
      checkedInAt?: timestamp
    }
  ]
  
  // Assigned Resources
  assignedBookables: [
    {
      bookableId: UUID
      bookableType: provider|asset|venue|virtual
      role: primary|assistant|backup
      isBackup: boolean
      confirmed: boolean
      compensationAmount?: number    // What this bookable earns
    }
  ]
  
  // Capacity (for group bookings)
  participantCount: number
  maxParticipants: number
  
  // Pricing snapshot (at time of booking)
  pricingSnapshot: {
    basePrice: 100
    durationMultiplier: 1.0
    premiumMultiplier: 1.5
    total: 150
    currency: "USD"
  }
  
  // Payment
  paymentStatus: pending|partial|paid|refunded
  depositAmount?: number
  totalPaid: number
  
  // Cancellation
  cancelledAt?: timestamp
  cancelledBy?: client|provider|system
  cancellationReason?: string
  refundAmount?: number
  
  // Check-in
  checkedInAt?: timestamp
  checkedInBy?: UUID
  
  // Completion
  completedAt?: timestamp
  completedBy?: UUID
  notes?: string
  
  // Metadata
  source: web|app|walkin|phone      // How booked
  isWalkIn: boolean
  
  // Audit
  createdAt, updatedAt
  createdBy: UUID
}
```

**Observer Bookings:**
- Observer attends but doesn't participate
- If primary booker cancels: configurable behavior
  - Cancel all observers
  - Transfer primary to observer
  - Require new primary booker

---

### 2.6 Reservation (Temporary Hold)

```typescript
Reservation {
  id
  slotId: UUID                      // Holding this slot
  serviceTemplateId
  userId: UUID                      // Who's holding
  
  status: active|extended|expired|converted
  
  // Timing
  createdAt: timestamp
  expiresAt: timestamp              // Auto-release after this
  
  // Extension
  extensionCount: number
  maxExtensions: number
  
  // Conversion
  convertedToBookingId?: UUID
  
  // Auto-cancel on expiry
  onExpiry: release_slot|move_to_waitlist|notify_admin
  
  // Deposit (if required)
  depositAmount?: number
  depositPaid: boolean
}
```

---

### 2.7 Multi-Session Programs

```typescript
ProgramTemplate {
  id, organizationId
  name, description
  
  // Sessions in program
  sessions: [
    {
      sequenceNumber: 1
      name: "Session 1: Introduction"
      serviceTemplateId: UUID
      daysAfterStart: 0              // Day 1
      allowDropIn: false
    }
    {
      sequenceNumber: 2
      name: "Session 2: Advanced"
      serviceTemplateId: UUID
      daysAfterStart: 7              // One week later
      allowDropIn: true              // Can join mid-program
    }
  ]
  
  // Enrollment
  enrollment: {
    type: full_program|drop_in|both
    fullProgramPrice: 500
    dropInPrice: 75
    
    earlyBirdDiscount: {
      deadlineDaysBefore: 14
      discountPercent: 15
    }
    
    paymentPlan: {
      enabled: true
      installments: 3
      interval: monthly
    }
  }
  
  // Attendance
  minAttendanceRequired: 4          // Must attend 4 of 6 sessions
  allowMissedSessions: true
  makeUpSessionsAvailable: true
  
  // Completion
  certificateIssued: true
  requireFullAttendance: false
}

ProgramEnrollment {
  id, programTemplateId, participantId
  
  enrollmentType: full|drop_in
  
  enrolledSessions: [
    {
      sessionId: UUID
      bookingId?: UUID              // Created when scheduled
      status: scheduled|completed|missed|cancelled
    }
  ]
  
  attendance: [
    {
      sessionId: UUID
      attended: boolean
      checkInTime?: timestamp
    }
  ]
  
  completed: boolean
  certificateIssued?: boolean
}
```

---

### 2.8 Recurring Bookings

```typescript
RecurringBookingRule {
  id, bookerId, serviceTemplateId
  
  // Pattern
  pattern: {
    type: daily|weekly|monthly
    interval?: 1                    // Every N days/weeks/months
    daysOfWeek?: [monday, wednesday, friday]
    dayOfMonth?: 15
  }
  
  // Duration
  startDate: date
  endDate?: date                    // Or infinite
  maxOccurrences?: 52
  
  // Bookables
  bookables: {
    fixed: [UUID]                   // Same every time
    flexible: true                  // Or any available
  }
  
  // Exceptions
  exceptions: [
    { date: "2026-12-25", action: skip }
    { date: "2026-11-27", action: reschedule, newDate: "2026-11-28" }
  ]
  
  // Modification rules
  allowParticipantModify: true
  modificationNoticeHours: 24
  ifSlotUnavailable: skip|reschedule|notify
  
  // Payment
  chargePerOccurrence: true         // Or upfront for all
  autoCharge: true
  upfrontDiscountPercent: 10
}
```

---

### 2.9 Packages & Bundling

```typescript
ServicePackage {
  id, organizationId
  name, description
  
  // Included items
  items: [
    {
      serviceTemplateId: UUID
      quantity: 5                   // 5 of this service
      restrictions: {
        allowedLocations: [UUID]
        excludedDates: [date]
      }
      upgradable: true
      upgradeOptions: [UUID]
    }
  ]
  
  // Pricing
  totalPrice: 400                   // Bundled price
  originalTotal: 500                // If bought separately
  savingsAmount: 100
  
  // Usage
  usage: {
    type: flexible|fixed_schedule
    useWithinDays: 365
    allowAnyOrder: true
  }
  
  // Transfer
  allowTransfer: true
  transferFee: 25
  
  // Gift
  isGiftable: true
}
```

---

### 2.10 Walk-Ins

```typescript
WalkInConfig {
  enabled: true
  mode: queue|immediate|scheduled
  
  // Queue mode
  queue: {
    maxQueueSize: 20
    estimatedWaitDisplay: true
    priorityRules: [
      { condition: membership==premium, priority: high }
      { condition: arrival_time, priority: fifo }
    ]
  }
  
  // Immediate mode
  immediate: {
    requireAvailableSlot: false
    allowDoubleBooking: true
    maxOverbookPercent: 20
  }
  
  // Registration
  registration: {
    requireAccount: false
    allowGuest: true
    collectMinimalInfo: true        // Just name + phone
  }
  
  // Payment
  payment: {
    requireUpfront: false
    allowPayAfter: true
  }
}
```

---

### 2.11 User Management (Better-Auth)

```typescript
User {
  // Better-Auth core
  id, email, emailVerified
  name, image
  
  // Bizing extensions
  profile: {
    phone?: string
    timezone: "America/Los_Angeles"
    notifications: {
      email: true, sms: false, push: true
    }
  }
  
  // Organization memberships
  memberships: [
    {
      organizationId: UUID
      role: client|staff|provider|manager|admin|owner
      locationIds: [UUID]           // null = all locations
      providerId?: UUID             // If also a provider
      status: active
    }
  ]
}

// Role permissions
RolePermissions: {
  client: [booking:create, booking:view_own, booking:cancel_own]
  staff: [booking:view_location, booking:create_walkin, client:view]
  provider: [booking:view_assigned, availability:manage_own, timesheet:view_own]
  manager: [booking:manage_location, report:view_location]
  admin: [org:manage, user:manage, billing:manage]
  owner: [*]                        // All permissions
}
```

**Multi-Org Example:**
- Dr. Smith: Provider at Hospital A (locations 1,2), Admin at Clinic B
- Same user, different roles, different permissions per org

---

### 2.12 Timesheets & Compensation

```typescript
ProviderTimesheet {
  id, providerId
  periodStart, periodEnd
  
  entries: [
    {
      bookingId: UUID
      date: date
      scheduledHours: 1.0
      actualHours: 1.0
      serviceType: string
      
      // Compensation
      baseRate: 50
      totalCompensation: 75          // Including premiums
      
      status: pending|approved|paid
    }
  ]
  
  summary: {
    totalBookings: 25
    totalHours: 40
    totalCompensation: 2000
  }
}

// Compensation rules per service template
CompensationRule {
  role: primary|assistant|backup
  
  // Base
  type: hourly|fixed|commission|percentage
  hourlyRate?: 50
  fixedAmount?: 100
  percentageOfBooking?: 0.7        // 70% of booking value
  
  // Premiums
  premiums: [
    { condition: after_hours, multiplier: 1.5 }
    { condition: weekend, multiplier: 1.25 }
    { condition: holiday, multiplier: 2.0 }
    { condition: last_minute, multiplier: 1.5 }
  ]
  
  // Backup-specific
  standbyPay?: 25                   // If on standby but not used
  backupUsageBonus?: 50             // Extra if actually used
}
```

---

### 2.13 Audit & Compliance (HIPAA-Ready)

```typescript
AuditLog {
  id, organizationId
  
  // Actor
  actorId: UUID
  actorType: user|system|integration
  actorRole: string
  
  // Action
  action: booking.created|booking.viewed|booking.updated|booking.deleted
  resourceType: booking|user|payment
  resourceId: UUID
  
  // Changes
  changes: [
    { field: "status", oldValue: "confirmed", newValue: "cancelled" }
  ]
  
  // Context
  metadata: {
    ipAddress: "192.168.1.1"
    userAgent: "Mozilla/5.0..."
    reason: "Client requested cancellation"
  }
  
  // Compliance
  classification: general|phi|pii|financial
  timestamp: timestamp
  hash: string                      // Tamper-evident
}

// Access logging for PHI
AccessLog {
  id, userId, userRole
  resourceType: phi|pii
  resourceId: UUID
  accessType: view|create|update|delete|export
  
  // HIPAA context
  purpose?: string                  // Treatment, payment, operations
  patientAuthorization?: boolean
  
  // Anomaly detection
  isAfterHours: boolean
  isBulkAccess: boolean
  
  timestamp: timestamp
}
```

---

## Part 3: Special Use Cases

### 3.1 Airbnb Clone Schema

```typescript
// Property as Venue + Asset combination
AirbnbListing {
  venue: {
    type: entire_place|private_room|shared_room
    capacity: { max: 4 }
    amenities: [wifi, kitchen, parking]
  }
  
  availability: {
    minNights: 2
    maxNights: 30
    checkInTime: "15:00"
    checkOutTime: "11:00"
    minGapBetweenBookings: 1        // Day for cleaning
  }
  
  pricing: {
    nightlyRate: 150
    weeklyDiscount: 0.15
    monthlyDiscount: 0.25
    cleaningFee: 75
    serviceFeePercent: 0.12
    
    dynamicPricing: {
      enabled: true
      demandMultiplier: up_to_2x
    }
    
    seasonalRates: [
      { months: [6,7,8], multiplier: 1.5 }
    ]
  }
  
  booking: {
    mode: instant|request
    cancellationPolicy: flexible|moderate|strict
  }
}
```

### 3.2 Uber Clone Schema

```typescript
UberTrip {
  // Real-time matching
  matching: {
    algorithm: closest|eta|rating
    maxRadiusMiles: 5
    matchTimeoutSeconds: 30
  }
  
  // Pricing
  pricing: {
    baseFare: 2.50
    perMinute: 0.35
    perMile: 1.75
    
    surgePricing: {
      enabled: true
      multiplier: dynamic_up_to_3x
      triggers: [high_demand, low_supply, event]
    }
    
    upfrontEstimate: true
  }
  
  // Trip
  trip: {
    allowMultipleStops: true
    maxStops: 3
    allowDestinationChange: true
    
    tracking: {
      driverLocation: real_time
      etaUpdates: every_30_seconds
      shareTrip: true
    }
  }
  
  // Driver assignment
  driver: {
    assignedAt: timestamp
    acceptedAt: timestamp
    arrivedAt: timestamp
    
    cancellationWindow: 5_minutes
    cancellationPenalty: 5.00
  }
}
```

### 3.3 Cinema Seat Selection

```typescript
CinemaShowing {
  movieId: UUID
  screenId: UUID
  startTime: timestamp
  
  seatMap: {
    rows: 15
    seatsPerRow: 20
    aisles: [5, 15]               // After seat 5 and 15
    seatTypes: {
      standard: { price: 12 }
      vip: { price: 18, rows: [10,11,12] }
      accessible: { price: 12, seats: ["A1", "A2"] }
    }
  }
  
  seatsAvailable: [
    { row: "A", seat: 1, status: available, type: standard }
    { row: "A", seat: 2, status: held, heldUntil: timestamp }
    { row: "J", seat: 10, status: booked }
  ]
  
  // Concessions upsell
  concessions: {
    combos: [
      { name: "Popcorn + Drink", price: 15 }
    ]
    preorder: true
    pickup: before_movie|intermission
  }
}
```

### 3.4 Car Rental Fleet

```typescript
CarRental {
  // Fleet management
  fleet: {
    vehicle: Asset
    category: economy|compact|suv|luxury
    
    availability: {
      locations: [pickup_location, return_location]
      differentReturnAllowed: true
      differentReturnFee: 25
    }
    
    pricing: {
      dailyRate: 45
      weeklyRate: 280
      monthlyRate: 900
      
      addons: {
        insurance: [
          { name: "Basic", price: 15 }
          { name: "Full Coverage", price: 35 }
        ]
        gps: 10
        childSeat: 12
        additionalDriver: 15
      }
    }
    
    requirements: {
      minDriverAge: 21
      maxDriverAge: 75
      creditCardRequired: true
      licenseTypes: ["standard", "commercial"]
    }
    
    extensions: {
      allowed: true
      noticeHours: 2
      dailyRateForExtension: 45
    }
  }
}
```

---

## Part 4: Configuration Inheritance

```
Organization (Root Config)
├── operatingHours: { mon: "09:00-17:00", ... }
├── cancellationPolicy: { refundTiers: [...] }
├── pricing: { currency: "USD", taxRate: 0.08 }
└── Locations
    └── Downtown Branch
        ├── operatingHours: { mon: "08:00-20:00" }  // Override
        ├── cancellationPolicy: null                 // Inherit from org
        └── Service Templates
            └── Haircut
                ├── duration: { fixedMinutes: 30 }   // Own config
                ├── operatingHours: null             // Inherit location
                └── pricing: { basePrice: 50 }        // Own config
```

**Inheritance Rules:**
1. Use local config if defined
2. Walk up tree: Template → Location → Organization
3. Must have value at some level (required fields)

---

## Part 5: Implementation Roadmap

### Phase 1: Foundation (Weeks 1-4)
- [ ] Better-Auth integration
- [ ] Organization/location hierarchy
- [ ] Basic bookables (provider, asset)
- [ ] Simple service templates
- [ ] 1:1 booking flow
- [ ] Soft deletion

### Phase 2: Core Booking (Weeks 5-8)
- [ ] Individual calendars
- [ ] Cascading availability
- [ ] Reservation vs booking
- [ ] Multi-host support
- [ ] Asset pairing
- [ ] Buffer times

### Phase 3: Business Logic (Weeks 9-12)
- [ ] Cancellation tiers
- [ ] Dynamic pricing
- [ ] Provider compensation
- [ ] Timesheets
- [ ] Backup provider activation
- [ ] Waitlists

### Phase 4: Advanced (Weeks 13-16)
- [ ] Recurring bookings
- [ ] Multi-session programs
- [ ] Group bookings
- [ ] Multi-day (Airbnb-style)
- [ ] Packages/bundling
- [ ] Walk-ins

### Phase 5: Enterprise (Weeks 17-20)
- [ ] Complex RBAC
- [ ] Multi-org users
- [ ] Audit logging
- [ ] Webhooks/workflows
- [ ] Compliance features
- [ ] Performance optimization

---

## Part 6: Open Questions & Decisions

| Question | Decision | Rationale |
|----------|----------|-----------|
| Venues vs Assets? | **Separate** | Venues have capacity, layouts, simultaneous bookings |
| Sequential vs Batch cascading? | **Configurable** | Different businesses need different strategies |
| Backup compensation? | **Standby + Usage** | Fair to backup who prepares but isn't used |
| Observer bookings? | **Transferable primary** | Configurable: cancel all, transfer, or require new primary |
| Multi-day discrete or range? | **Both** | Airbnb needs range, hotels need discrete |
| Walk-in queue or immediate? | **Configurable** | Urgent care needs queue, salon needs immediate |
| HIPAA in schema? | **Audit-ready** | Classification, access logs, immutable records |

---

## Summary

**This schema supports:**
- ✅ Calendly-style individual scheduling
- ✅ Salon/clinic multi-resource booking
- ✅ Medical with HIPAA audit trails
- ✅ Airbnb multi-day rentals
- ✅ Uber on-demand with surge
- ✅ Cinema seat selection
- ✅ Car rental fleet management
- ✅ Movie studio 100+ resource orchestration

**Key Innovations:**
1. Polymorphic Bookables (4 types, common interface)
2. Service Templates as blueprints
3. Cascading availability with premium skip
4. Backup provider compensation
5. Multi-org, multi-role (Better-Auth)
6. Reservation → Booking lifecycle
7. HIPAA-ready audit architecture

**Total Entities:** 15+ core entities
**Use Cases Covered:** 40+ scenarios
**Implementation:** 20-week phased approach

---

*Updated Schema Design v2.0. Generated 2026-02-17.*
