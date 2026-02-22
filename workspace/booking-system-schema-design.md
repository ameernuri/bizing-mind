---
date: 2026-02-16
tags:
  - research
  - design
  - schema
  - booking
  - architecture
---

# Booking System Schema Design: Use Cases & Entity Analysis

> Comprehensive analysis of booking patterns, entities, and scenarios for Bizing's core architecture

---

## Executive Summary

This document explores the complete domain of booking systems to inform Bizing's schema design. After analyzing dozens of booking patterns across industries, we identify **5 core booking archetypes** with **31 distinct scenarios**, requiring **12 primary entities** with **38+ attributes**.

**Key Insight:** The "bookable" abstraction is correct—but must be polymorphic to handle hosts, assets, venues, and virtual resources uniformly.

---

## Part 1: Booking Archetypes

### Archetype A: Simple Appointment (1:1:1)
**Pattern:** One booker → one slot → one provider

**Scenarios:**

1. **Medical Consultation**
   - Booker: Patient
   - Slot: 30-minute appointment
   - Provider: Doctor
   - Variants: Initial visit, follow-up, procedure
   - Importance: Base case for healthcare bookings

2. **Personal Training Session**
   - Booker: Client
   - Slot: 60-minute session
   - Provider: Personal trainer
   - Variants: Assessment, workout, nutrition review
   - Importance: Fitness industry standard

3. **Therapy Session**
   - Booker: Client
   - Slot: 50-minute hour
   - Provider: Therapist
   - Variants: Individual, couples, group
   - Importance: Mental health compliance requirements

4. **Tutoring Session**
   - Booker: Student/parent
   - Slot: 60-90 minute session
   - Provider: Tutor
   - Variants: Subject-specific, test prep, homework help
   - Importance: Education sector

5. **Legal Consultation**
   - Booker: Client
   - Slot: 30-60 minute consultation
   - Provider: Attorney
   - Variants: Free consultation, paid advice, case review
   - Importance: Professional services

6. **Beauty Service**
   - Booker: Client
   - Slot: Varies by service (15-120 min)
   - Provider: Stylist/esthetician
   - Variants: Haircut, facial, massage, nails
   - Importance: High-volume, variant-heavy

---

### Archetype B: Multi-Host Booking (1:N:1)
**Pattern:** One booker → multiple hosts → one slot

**Scenarios:**

7. **Panel Interview**
   - Booker: Candidate
   - Hosts: 3-5 interviewers (hiring manager, team lead, peer)
   - Slot: 60-minute interview
   - Constraints: All hosts must be available
   - Importance: Enterprise recruiting

8. **Medical Procedure with Assistants**
   - Booker: Patient
   - Hosts: Surgeon (required) + anesthesiologist + nurses
   - Slot: 2-hour surgery
   - Constraints: Lead host required, assistants swappable
   - Importance: Healthcare critical

9. **Wedding Photography Team**
   - Booker: Couple
   - Hosts: Lead photographer + second shooter + assistant
   - Slot: 8-hour wedding day
   - Constraints: Lead required, others backup-capable
   - Importance: Event services

10. **Corporate Training Session**
    - Booker: HR/Manager
    - Hosts: Trainer + co-trainer + IT support
    - Slot: Full-day workshop
    - Constraints: Trainer required, others optional
    - Importance: Enterprise L&D

11. **Group Fitness Class**
    - Booker: Individual participant
    - Hosts: Lead instructor + assistant
    - Slot: 45-minute class
    - Constraints: Multiple bookers per slot (see Archetype E)
    - Importance: Fitness industry

---

### Archetype C: Asset-Required Booking (1:1:1+Asset)
**Pattern:** Booker + host + required asset/venue

**Scenarios:**

12. **Medical Imaging Appointment**
    - Booker: Patient
    - Host: Radiologist/technician
    - Asset: MRI machine, CT scanner, X-ray
    - Slot: 45-minute scan
    - Constraints: Asset REQUIRED (can't scan without machine)
    - Importance: Medical equipment scheduling

13. **Driving Lesson**
    - Booker: Student
    - Host: Driving instructor
    - Asset: Dual-control training vehicle
    - Slot: 1-hour lesson
    - Constraints: Specific asset type required
    - Importance: Driving schools

14. **Massage Therapy Room**
    - Booker: Client
    - Host: Massage therapist
    - Asset: Treatment room with table
    - Slot: 60-90 minutes
    - Constraints: Room REQUIRED, host swappable
    - Importance: Spa/wellness

15. **Language Lab Session**
    - Booker: Student
    - Host: Language instructor (optional remote)
    - Asset: Computer lab with software
    - Slot: 50-minute session
    - Constraints: Lab access required
    - Importance: Education

16. **Veterinary Procedure**
    - Booker: Pet owner
    - Host: Veterinarian
    - Asset: Surgical suite/equipment
    - Slot: Varies by procedure
    - Constraints: Equipment and room required
    - Importance: Veterinary services

17. **Music Recording Session**
    - Booker: Artist/band
    - Host: Audio engineer
    - Asset: Recording studio
    - Slot: 3-8 hour block
    - Constraints: Studio REQUIRED
    - Importance: Creative industries

---

### Archetype D: Venue-Only Booking (1:0:1)
**Pattern:** Booker → venue/asset (no human host)

**Scenarios:**

18. **Conference Room Reservation**
    - Booker: Employee
    - Host: None (self-service)
    - Asset: Meeting room with AV equipment
    - Slot: 1-hour meeting
    - Constraints: Capacity limits, equipment needs
    - Importance: Corporate facilities

19. **Sports Court Booking**
    - Booker: Team/individual
    - Host: None (self-service)
    - Asset: Tennis court, basketball court, etc.
    - Slot: 1-2 hour block
    - Constraints: Court type, lighting, indoor/outdoor
    - Importance: Recreation facilities

20. **Equipment Rental**
    - Booker: Renter
    - Host: None (or optional pickup clerk)
    - Asset: Camera, tools, party equipment
    - Slot: Daily/weekly rental
    - Constraints: Availability, return time
    - Importance: Rental businesses

21. **Co-working Space Desk**
    - Booker: Member
    - Host: None (community manager optional)
    - Asset: Desk, office, phone booth
    - Slot: Hourly or monthly
    - Constraints: Membership level, amenities
    - Importance: Co-working spaces

22. **Storage Unit Access**
    - Booker: Renter
    - Host: None (facility access)
    - Asset: Storage unit
    - Slot: Access hours window
    - Constraints: Security, access hours
    - Importance: Self-storage

---

### Archetype E: Group Booking (N:1:M)
**Pattern:** Multiple bookers → slot(s) → host(s) with capacity

**Scenarios:**

23. **Fitness Class (Spin/Yoga)**
    - Bookers: Up to 30 participants
    - Host: Instructor
    - Slot: 45-60 minute class
    - Constraints: Min 5 (or cancel), max 30 (room capacity)
    - Importance: Gym/group fitness

24. **Workshop/Seminar**
    - Bookers: 10-50 attendees
    - Host: Facilitator + assistant
    - Slot: Half-day or full-day
    - Constraints: Min to run, max by room
    - Importance: Training/events

25. **Medical Group Session**
    - Bookers: 6-12 patients
    - Host: Therapist/doctor
    - Slot: 90-minute group therapy
    - Constraints: Closed group (same people each week) or open
    - Importance: Healthcare efficiency

26. **Webinar/Online Class**
    - Bookers: 10-1000+ attendees
    - Host: Presenter + moderator
    - Slot: 60-minute session
    - Constraints: Virtual capacity (platform limits)
    - Importance: EdTech/online learning

27. **Tour Group**
    - Bookers: 8-20 tourists
    - Host: Tour guide
    - Slot: 3-hour walking tour
    - Constraints: Min to run, max by guide ratio
    - Importance: Tourism

28. **Cooking Class**
    - Bookers: 8-16 participants
    - Host: Chef + assistant
    - Slot: 2-3 hour class
    - Constraints: Station/equipment per person
    - Importance: Culinary education

29. **Study Group Room**
    - Bookers: 4-8 students
    - Host: None (peer-led) or optional tutor
    - Slot: 2-hour study session
    - Constraints: Room capacity
    - Importance: Education/libraries

30. **Meditation/Yoga Retreat**
    - Bookers: 10-30 participants
    - Host: Instructor
    - Slot: Full-day or weekend
    - Constraints: Accommodation + practice space
    - Importance: Wellness retreats

---

### Archetype F: Complex Composite (N:M:X)
**Pattern:** Multiple bookers + multiple hosts + multiple assets + locations

**Scenarios:**

31. **Wedding Venue Package**
    - Bookers: Couple + guests (200+)
    - Hosts: Coordinator + catering team + AV tech + photographer
    - Assets: Ceremony space + reception hall + tables + chairs + linens
    - Slots: Multi-day (setup + event + breakdown)
    - Constraints: Everything must align
    - Importance: Event planning

32. **Corporate Retreat**
    - Bookers: 50 employees
    - Hosts: Facilitators + speakers + activities staff
    - Assets: Conference rooms + breakout spaces + dining + lodging
    - Slots: 2-3 day event
    - Constraints: Accommodation + all sessions
    - Importance: Corporate events

33. **Medical Surgery Schedule**
    - Bookers: Multiple patients (scheduled sequentially)
    - Hosts: Surgical team rotating
    - Assets: OR suite + equipment + recovery beds
    - Slots: Full day of procedures
    - Constraints: Sterilization time between, team breaks
    - Importance: Hospital operations

34. **Film Production Day**
    - Bookers: Production company
    - Hosts: Director + crew (20+ roles)
    - Assets: Location + equipment + permits
    - Slots: 12-hour shoot day
    - Constraints: All elements must align
    - Importance: Film/TV production

---

## Part 2: Entity Naming Analysis

### Current Proposed Names vs. Alternatives

| Current Idea | Alternative | Rationale |
|--------------|-------------|-----------|
| **Block/Slot** | *TimeSlot, AvailabilityWindow* | "Block" suggests unavailability. "TimeSlot" clearer for bookable windows. |
| **Bookable** | *Resource, Reservable, BookableResource* | "Bookable" is good—adjective-as-noun. "Resource" more generic but requires disambiguation. |
| **Host** | *Provider, Practitioner, Staff* | "Host" implies hospitality. "Provider" better for services. "Practitioner" for professionals. |
| **Service** | *Offering, ProductService, BookableService* | "Service" is overloaded. "Offering" clearer. |
| **Asset** | *Equipment, ResourceItem, Tool* | "Asset" is accounting term. "Equipment" clearer for physical items. |
| **Booking** | *Reservation, Appointment, Order* | Depends on industry. "Booking" is generic winner. |

### Recommended Entity Names

```
┌─────────────────────────────────────────────────────────────┐
│                    BIZING BOOKING ENTITIES                  │
├─────────────────────────────────────────────────────────────┤
│ 1. Calendar         - The scheduling container              │
│ 2. Availability     - When something can be booked          │
│ 3. Bookable         - Abstract: anything that can be booked │
│    ├─ Provider      - Human who delivers service            │
│    ├─ Asset         - Physical equipment/venue              │
│    └─ Virtual       - Digital resources (Zoom, etc.)        │
│ 4. Offering         - Service or product being sold         │
│ 5. Booking          - The actual reservation                │
│ 6. Booker           - Person making the booking             │
│ 7. Organization     - Business offering bookings            │
│ 8. Location         - Physical or virtual place             │
│ 9. Capacity         - Limits on bookings                    │
│ 10. Buffer          - Time padding between bookings         │
│ 11. Requirement     - What's needed for booking             │
│ 12. Tag/Category    - Classification system                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Part 3: Detailed Use Case Scenarios

### Scenario Analysis: Medical Practice

**Context:** Multi-provider clinic with shared resources

**Requirements:**
- 5 doctors (providers)
- 3 nurses (support staff)
- 2 MRI machines (assets)
- 5 exam rooms (venues)
- 1 surgical suite (specialized venue)

**Booking Patterns:**
1. **Routine visit** → Patient + Doctor + Exam Room
2. **MRI scan** → Patient + Technician + MRI Machine
3. **Surgery** → Patient + Surgeon + Anesthesiologist + Surgical Suite
4. **Group therapy** → 8 Patients + Therapist + Group Room

**Schema Implications:**
- Providers have individual calendars
- Assets have their own availability
- Venues have capacity constraints
- Some bookings require ALL, some require ANY

---

### Scenario Analysis: Fitness Studio

**Context:** Boutique fitness with classes and privates

**Requirements:**
- 8 instructors (providers)
- 3 studios (venues, different capacities)
- 30 spin bikes (assets per studio)
- 20 yoga mats (assets)

**Booking Patterns:**
1. **Private training** → Client + Trainer + Studio
2. **Spin class** → 30 Clients + Instructor + Studio + Bikes
3. **Yoga class** → 20 Clients + Instructor + Studio + Mats
4. **Open gym** → Member + Venue (no instructor)

**Schema Implications:**
- Assets can be "seats" in a venue
- Capacity varies by venue
- Some bookings auto-assign assets (bike #1, #2...)

---

### Scenario Analysis: Driving School

**Context:** Multiple instructors sharing vehicle fleet

**Requirements:**
- 10 instructors
- 5 dual-control cars (training vehicles)
- 2 classroom spaces

**Booking Patterns:**
1. **Behind-the-wheel** → Student + Instructor + Specific Car
2. **Classroom session** → 15 Students + Instructor + Classroom
3. **Road test** → Student + Examiner + Test Vehicle

**Schema Implications:**
- Cars must match transmission type (manual/auto)
- Some students prefer specific cars
- Instructors certified for specific vehicles

---

### Scenario Analysis: Consulting Firm

**Context:** Professional services with team capabilities

**Requirements:**
- 20 consultants (providers with specializations)
- 5 conference rooms
- Video conferencing licenses (virtual assets)

**Booking Patterns:**
1. **1:1 consultation** → Client + Consultant + Zoom/Office
2. **Team workshop** → Client team + 3 Consultants + Large Room
3. **Strategy session** → Client + Partner + Junior + Room
4. **Discovery call** → Prospect + Sales + Zoom

**Schema Implications:**
- Provider expertise tags ("strategy", "operations")
- Team-based bookings require all providers
- Buffer time for prep/debrief

---

## Part 4: Advanced Features

### Feature: Swappable/Backup Hosts

**Scenario:** Wedding photographer has backup in case of emergency

**Implementation:**
- Primary: Photographer A
- Backup: Photographer B
- Trigger: If A cancels < 48hrs before, auto-offer to B
- Business rule: B gets paid only if activated

**Schema fields:**
```
booking:
  primary_provider_id: uuid
  backup_provider_ids: uuid[]
  backup_trigger: "cancel_48h" | "cancel_anytime"
```

---

### Feature: Buffer Time

**Scenarios:**
- Clean room between massage clients (15 min)
- Reset equipment between driving lessons (10 min)
- Travel time for mobile services (variable)

**Implementation:**
```
availability:
  pre_buffer_minutes: int  # Before booking
  post_buffer_minutes: int # After booking
  
booking:
  actual_start: timestamp  # When work starts
  buffer_start: timestamp  # Including pre-buffer
  actual_end: timestamp    # When work ends
  buffer_end: timestamp    # Including post-buffer
```

---

### Feature: Travel Time

**Scenario:** Mobile notary travels to client

**Implementation:**
```
location:
  type: "fixed" | "mobile"
  address: string
  travel_time_buffer: int # Minutes to add for travel
  
booking:
  provider_departure_time: timestamp
  provider_arrival_buffer: int
```

---

### Feature: Required vs. Optional Resources

**Scenario:** Surgery requires surgeon (required) but prefers specific nurse (optional)

**Implementation:**
```
booking_requirement:
  bookable_id: uuid
  requirement_type: "required" | "preferred" | "optional"
  substitution_allowed: boolean
  substitution_conditions: json
```

---

### Feature: Min/Max Bookings

**Scenarios:**
- Yoga class needs 5 people to run (min), max 25 (room capacity)
- Private lesson is exactly 1 (min=max=1)
- Group discount kicks in at 10 people

**Implementation:**
```
offering:
  min_participants: int      # 1 for private, 5 for class
  max_participants: int      # 1 for private, 30 for class
  auto_cancel_if_under: boolean
  waitlist_enabled: boolean
  waitlist_max: int
```

---

### Feature: Service Variants

**Scenario:** Hair salon offers "Cut", "Cut + Color", "Cut + Color + Style"

**Implementation:**
```
offering:
  base_service_id: uuid
  variants:
    - name: "Basic Cut"
      duration: 30
      price: 50
    - name: "Cut + Color"
      duration: 90
      price: 120
    - name: "Deluxe Package"
      duration: 120
      price: 180
```

---

### Feature: Asset Tags & Categories

**Scenario:** Car rental has sedans, SUVs, luxury; manual and automatic

**Implementation:**
```
asset:
  tags: ["sedan", "automatic", "gps", "hybrid"]
  category: "vehicle"
  subcategory: "sedan"
  
offering:
  required_asset_tags: ["sedan"]
  preferred_asset_tags: ["hybrid", "gps"]
  excluded_asset_tags: ["manual"]
```

---

### Feature: Host Tags & Certifications

**Scenario:** Medical practice needs certified phlebotomist

**Implementation:**
```
provider:
  tags: ["phlebotomist", "rn", "pediatric"]
  certifications:
    - type: "phlebotomy"
      issued: date
      expires: date
  
offering:
  required_provider_tags: ["phlebotomist"]
  required_certifications: ["phlebotomy"]
```

---

### Feature: Templates

**Scenario:** Chain of salons with standardized offerings

**Implementation:**
```
offering_template:
  name: "Signature Massage"
  default_duration: 60
  default_price: 80
  required_assets: ["massage_table", "private_room"]
  pre_buffer: 10
  post_buffer: 10
  
organization_offering:
  template_id: uuid
  overrides:
    price: 90  # This location charges more
    duration: 75  # Extended here
```

---

### Feature: Locations & Organizations

**Multi-location Business:**
```
organization:
  name: "FitLife Gyms"
  
location:
  organization_id: uuid
  name: "Downtown"
  timezone: "America/Los_Angeles"
  
provider:
  primary_location_id: uuid
  works_at_locations: uuid[]  # Can work multiple locations
```

---

## Part 5: Edge Cases & Considerations

### Timezone Handling
- Providers travel between timezones
- Virtual sessions across timezones
- Daylight saving transitions
- "Follow provider's timezone" vs "Follow location's timezone"

### Recurring Bookings
- Weekly therapy session
- Monthly maintenance
- Bi-weekly class
- Exception handling (skip holidays)

### Cancellation Policies
- Full refund > 48 hours
- 50% refund 24-48 hours
- No refund < 24 hours
- Provider cancellation → full refund + credit

### Waitlists
- Auto-promote when spot opens
- Notification timeout (2 hours to claim)
- Priority by signup time vs. membership tier

### No-Shows
- Mark as no-show after 15 min
- Charge no-show fee
- Track pattern (ban after 3 no-shows)

### Double-Booking Prevention
- Atomic availability check
- Optimistic locking
- Conflict resolution (which booking wins?)

### Resource Conflicts
- Provider double-booked across locations
- Asset double-booked
- Cascading cancellations

---

## Part 6: Draft Schema Design

### Core Entities

```
organization
├── id: uuid (pk)
├── name: string
├── slug: string (unique)
├── settings: json
└── locations: location[]

location
├── id: uuid (pk)
├── organization_id: uuid (fk)
├── name: string
├── timezone: string
├── address: json
└── calendars: calendar[]

calendar
├── id: uuid (pk)
├── location_id: uuid (fk)
├── name: string
├── timezone: string
└── availabilities: availability[]

availability
├── id: uuid (pk)
├── calendar_id: uuid (fk)
├── bookable_id: uuid (fk)  # Polymorphic
├── bookable_type: enum     # 'provider', 'asset', 'venue'
├── starts_at: timestamp
├── ends_at: timestamp
├── status: enum            # 'available', 'booked', 'blocked'
├── pre_buffer_minutes: int
├── post_buffer_minutes: int
└── booking: booking?

bookable (abstract)
├── id: uuid (pk)
├── type: enum              # 'provider', 'asset', 'venue', 'virtual'
├── organization_id: uuid (fk)
├── name: string
├── description: text
├── tags: string[]
└── settings: json

provider (extends bookable)
├── user_id: uuid?          # Optional link to user
├── email: string
├── phone: string
├── certifications: json[]
├── primary_location_id: uuid
├── works_at: location[]
└── specialties: string[]

asset (extends bookable)
├── category: string
├── location_id: uuid (fk)
├── specifications: json    # Flexible attributes
├── serial_number: string
└── maintenance_schedule: json

venue (extends bookable)
├── location_id: uuid (fk)
├── capacity: int
├── amenities: string[]
├── square_footage: int
└── floor_plan: json

offering
├── id: uuid (pk)
├── organization_id: uuid (fk)
├── template_id: uuid?      # Optional template
├── name: string
├── description: text
├── category_id: uuid (fk)
├── duration_minutes: int
├── price: decimal
├── currency: string
├── min_participants: int
├── max_participants: int
├── required_bookables: json  # {"provider": 1, "asset": ["table"]}
├── optional_bookables: json
├── buffers: json           # {"pre": 10, "post": 10}
└── variants: offering_variant[]

booking
├── id: uuid (pk)
├── organization_id: uuid (fk)
├── offering_id: uuid (fk)
├── status: enum            # 'pending', 'confirmed', 'completed', 'cancelled', 'no_show'
├── starts_at: timestamp
├── ends_at: timestamp
├── timezone: string
├── booker_id: uuid (fk)    # Polymorphic: user or guest
├── participants: booking_participant[]
├── assigned_bookables: booking_bookable[]
├── requirements: json      # Special needs, accommodations
├── buffers: json           # Actual buffers used
├── price: decimal
├── payment_status: enum
├── cancellation_policy: json
├── cancelled_at: timestamp?
├── cancelled_by: enum      # 'booker', 'provider', 'system'
└── notes: text

booking_participant
├── id: uuid (pk)
├── booking_id: uuid (fk)
├── user_id: uuid?          # Null for guest bookings
├── email: string
├── name: string
├── status: enum            # 'confirmed', 'cancelled', 'no_show'
└── checked_in_at: timestamp?

booking_bookable
├── id: uuid (pk)
├── booking_id: uuid (fk)
├── bookable_id: uuid (fk)
├── bookable_type: enum
├── role: enum              # 'primary', 'backup', 'assistant'
├── requirement_type: enum  # 'required', 'preferred', 'optional'
├── substitution_allowed: boolean
├── confirmed: boolean
└── notes: text

category
├── id: uuid (pk)
├── organization_id: uuid (fk)
├── name: string
├── type: enum              # 'offering', 'asset', 'provider'
├── parent_id: uuid?        # Hierarchical
└── sort_order: int

tag
├── id: uuid (pk)
├── organization_id: uuid (fk)
├── name: string
├── color: string
└── applies_to: enum[]      # ['provider', 'asset', 'offering']
```

---

## Part 7: Recommendations

### 1. Start Simple, Build Up

**Phase 1:** Simple appointments (1:1:1)
- Focus on provider + availability + booking
- Ignore assets, venues, groups initially

**Phase 2:** Add resources
- Introduce assets (required for booking)
- Add venues (rooms, locations)

**Phase 3:** Groups and complexity
- Multi-participant bookings
- Capacity management
- Waitlists

### 2. Polymorphic Design

The `bookable` abstraction is correct. Use single-table inheritance or table-per-type:

```
bookables (base table)
├── id, type, name, etc.

providers (extends bookables)
├── certifications, specialties

assets (extends bookables)
├── category, specifications

venues (extends bookables)
├── capacity, amenities
```

### 3. Availability-First Design

Availability is the core. Design around it:

```
Availability = When + What + Status
- When: starts_at, ends_at
- What: bookable_id (who/what is available)
- Status: available, booked, blocked
```

Booking "claims" an availability slot.

### 4. Flexible Requirements

Use JSON for requirements until patterns stabilize:

```
offering.requirements = {
  "provider": {"count": 1, "tags": ["certified"]},
  "asset": [{"type": "room", "min_capacity": 10}],
  "venue": {"required": false}
}
```

Then normalize to tables once patterns emerge.

### 5. Buffer as First-Class

Buffers affect availability. Don't treat as afterthought:

```
Actual booking: 10:00 - 11:00
With buffers (+15/+15): 9:45 - 11:15
Next availability starts: 11:15
```

---

## Summary

**31 scenarios** across **6 archetypes** inform a schema with **12 core entities**.

**Key insights:**
1. Polymorphic `bookable` handles providers, assets, venues uniformly
2. `availability` is the central abstraction
3. Requirements (required/preferred/optional) vary by offering
4. Buffers, travel time, and prep work are first-class concerns
5. Start with simple 1:1:1, expand to complex composites

**Next steps:**
1. Review use cases with stakeholders
2. Prioritize archetypes for MVP
3. Draft API contracts
4. Prototype availability engine
5. Test with real booking scenarios

---

*Design document for Bizing booking system schema. Generated 2026-02-16.*
