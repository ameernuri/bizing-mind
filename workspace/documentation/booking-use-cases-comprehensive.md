---
date: 2026-02-17
tags:
  - research
  - use-cases
  - booking
  - scenarios
  - comprehensive
---

# Comprehensive Booking Use Cases: From Simple to Complex

> Human-language descriptions of booking scenarios across all complexity levels. This document informs schema design by describing what needs to be supported.

---

## How to Read This Document

This catalog describes **booking scenarios** in plain language. Each section represents a category of use case, from the simplest (individual scheduling) to the most complex (enterprise resource orchestration).

**Purpose:** Understand the full spectrum of needs before designing technical solutions.

---

## Part 1: Universal / Table Stakes (Must Work in v1.0)

### UC-1: The Solo Consultant
**Who:** Independent professional (therapist, coach, consultant)
**What:** Offers 1-on-1 sessions
**Needs:**
- Simple online booking page
- Fixed-duration appointments (e.g., 50 minutes)
- Basic availability (M-F 9-5)
- Email confirmations
- Calendar sync (Google/Outlook)
- Payment collection (Stripe)
- Simple cancellation (24-hour notice)

**Scenario:** Sarah is a career coach. Clients visit her booking page, see her available slots, pick a time, enter their credit card, and receive a Zoom link. If they cancel more than 24 hours ahead, automatic refund. Sarah sees all bookings in her Google Calendar.

---

### UC-2: The Hair Salon
**Who:** Small service business with multiple staff
**What:** Various services (cut, color, styling) with different durations
**Needs:**
- Multiple service types (15 min to 3 hours)
- Multiple providers (stylists)
- Each provider has own schedule
- Buffer time between appointments (cleanup)
- Walk-in support (queue management)
- Service add-ons (deep conditioning, scalp treatment)
- Deposit for expensive services (color)

**Scenario:** Maria runs a salon with 4 stylists. Customers book online choosing their preferred stylist and service. The system automatically adds 15 minutes after color appointments for cleanup. Walk-ins can join a digital queue and see estimated wait times. Regulars can book their "usual" with one click.

---

### UC-3: The Medical Clinic
**Who:** Healthcare provider
**What:** Appointments requiring specific rooms/equipment
**Needs:**
- Provider + room pairing (Dr. Smith needs Exam Room 2)
- Different appointment types (annual physical vs sick visit)
- Insurance verification before booking
- Patient forms completed online
- Reminder calls/texts (reduce no-shows)
- Waitlist for cancellations
- HIPAA-compliant everything

**Scenario:** A family practice has 3 doctors and 5 exam rooms. When booking, the system ensures Dr. Jones is paired with Room 3 (where her equipment lives). Annual physicals are 30 minutes, sick visits 15. If someone cancels, the waitlist gets notified in order. All patient data is encrypted.

---

### UC-4: The Fitness Class Studio
**Who:** Gym or boutique fitness
**What:** Group classes with capacity limits
**Needs:**
- Class capacity (max 30 people)
- Minimum to run (cancel if under 5)
- Instructor assignment
- Room assignment
- Equipment per participant (bike #1, bike #2)
- Membership vs drop-in pricing
- Late cancellation fees
- Waitlist

**Scenario:** Spin City offers 6 classes daily. Each bike is numbered; members have favorites. Classes need 5 people to run or they're cancelled 2 hours before. Members book through the app. If full, they join waitlist and get notified if someone cancels. No-shows get charged a $10 fee after 3 strikes.

---

### UC-5: The Tutoring Center
**Who:** Education service
**What:** Recurring sessions with same student/tutor
**Needs:**
- Weekly recurring bookings (Tuesdays 4pm)
- Subject matching (algebra tutor, not English)
- Parent booking for child
- Progress notes per session
- Package deals (buy 10 sessions, get 1 free)
- Substitute tutor if regular is sick

**Scenario:** The Johnsons book their son Jake for weekly math tutoring. Every Tuesday at 4pm with Ms. Rodriguez. They bought a 10-session package. If Ms. Rodriguez is sick, the center assigns Mr. Chen (also math-certified) and notifies the family. After each session, notes are added about what was covered.

---

## Part 2: Common / Expected Features (Should Have)

### UC-6: The Multi-Location Chain
**Who:** Business with multiple branches
**What:** Same services offered at different locations
**Needs:**
- Location selection by customer
- Different hours per location
- Some providers work multiple locations
- Transfer bookings between locations
- Location-specific pricing (downtown premium)
- Central management view

**Scenario:** Clean Teeth Dental has 5 offices. Patients can book at any location. Dr. Williams works Mondays downtown, Wednesdays suburban. Prices are 10% higher downtown. If the downtown X-ray machine breaks, appointments get transferred to nearest location with capacity.

---

### UC-7: The Multi-Provider Appointment
**Who:** Services requiring multiple people
**What:** One booking, multiple staff assigned
**Needs:**
- Primary + assistant assignment
- All must be available for slot to show
- Different pay rates per role
- Backup if primary unavailable

**Scenario:** A wedding photography package includes lead photographer, second shooter, and assistant. All three must be available. The couple pays a package price, but internally the lead gets 60%, second shooter 30%, assistant 10%. If lead gets sick 2 days before, backup photographer gets activated.

---

### UC-8: The Equipment-Required Service
**Who:** Services needing specific tools/machines
**What:** Provider + equipment must both be free
**Needs:**
- Equipment calendar (MRI machine, massage table)
- Equipment maintenance blocks
- Different equipment for different services
- Usage tracking per equipment

**Scenario:** An MRI clinic has 2 machines. Each booking needs a technician AND a machine. Machine A is newer (faster scans), Machine B is older. The system shows only slots where both technician and preferred machine are free. Every 100 scans, Machine A gets 4-hour maintenance.

---

### UC-9: The Multi-Day Rental
**Who:** Equipment or property rental
**What:** Bookings spanning multiple days
**Needs:**
- Check-in/check-out times
- Gap days for cleaning/service
- Different daily vs weekly rates
- Damage deposit hold
- Late return fees
- Different return location (one-way rental)

**Scenario:** Beach House Rentals offers vacation homes. Minimum 3-night stay. Check-in 4pm, check-out 11am. The cleaner needs 5 hours between guests. Weekly rate is 20% off. A $500 damage deposit is held and released 48 hours after checkout if no issues.

---

### UC-10: The Corporate Training
**Who:** B2B training provider
**What:** Multi-session programs for companies
**Needs:**
- Multi-session packages (5 weekly sessions)
- Attendance tracking
- Certificate upon completion
- Company pays (invoicing, not immediate charge)
- Substitute employees (anyone from company can attend)
- Minimum attendance to run

**Scenario:** TechCorp buys a "Leadership 101" course for 12 employees. 5 Tuesday afternoons. If fewer than 8 show up, session is rescheduled. Each employee gets a certificate after completing 4 of 5 sessions. TechCorp gets invoiced monthly, not per-session.

---

### UC-11: The Mobile Service
**Who:** Provider travels to customer (plumber, mobile groomer)
**What:** Location-based scheduling with travel time
**Needs:**
- Service area definition (zip codes or radius)
- Travel time between appointments
- Optimized route planning
- Customer location saved
- "I'm on my way" notifications
- ETA updates

**Scenario:** Mike's Mobile Dog Grooming serves a 20-mile radius. The system optimizes his daily route: 9am at the Smiths, 10:30am at the Johnsons (15 min drive), 12pm at the Parkers. Each customer gets "Mike is 10 minutes away" text. Drive time between appointments is unpaid.

---

## Part 3: Occasional / Differentiators

### UC-12: The Package Deal
**Who:** Any service business
**What:** Pre-paid bundles of services
**Needs:**
- Buy 5 massages, get 1 free
- Track remaining sessions
- Expiration dates (use within 6 months)
- Transferable (gift to friend)
- Partial refund for unused sessions

**Scenario:** A yoga studio sells "10-class passes" for $150 (vs $20 drop-in). Sarah buys one, attends 6 classes, then moves away. She transfers her remaining 4 classes to her friend. The pass expires 6 months from purchase. No refunds after 3 months.

---

### UC-13: The Auction/Dynamic Pricing
**Who:** High-demand limited supply
**What:** Price changes based on demand
**Needs:**
- Surge pricing (Uber model)
- Last-minute discounts (fill empty slots)
- Early bird pricing
- Waitlist with priority bidding

**Scenario:** A celebrity stylist has 4 slots per week. Base price $200. If demand is high (10+ people want same slot), price surges to $400. If slot is still empty 2 hours before, price drops to $150 to fill it. VIP clients get first access before dynamic pricing kicks in.

---

### UC-14: The Seat Selection
**Who:** Venues with specific seating
**What:** Customer picks exact seat/spot
**Needs:**
- Visual seat map
- Different pricing per seat (front row premium)
- Group seating (keep seats together)
- Accessibility seating
- Hold seats while paying (reservation)

**Scenario:** A theater sells tickets online. Customers see a seat map: Orchestra $75, Mezzanine $50, Balcony $35. Wheelchair accessible seats marked. When someone selects seats, they're held for 10 minutes while they pay. Groups of 4+ need adjacent seats.

---

### UC-15: The Waitlist with Auto-Book
**Who:** High-demand services
**What:** Automatically book when slot opens
**Needs:**
- Waitlist queue with position
- Automatic booking when cancellation occurs
- Time to accept (2 hours to confirm)
- Priority tiers (members first)

**Scenario:** A popular restaurant takes reservations 30 days out. They're fully booked, but 50 people are on the waitlist for Saturday 7pm. When someone cancels, #1 on the list gets automatically booked and has 2 hours to confirm. VIP members are above regular members on the list.

---

### UC-16: The Recurring Subscription
**Who:** Ongoing services
**What:** Same time every week/month indefinitely
**Needs:**
- Weekly recurring (every Tuesday 2pm)
- Skip individual occurrences
- Reschedule single instance
- Automatic payment (subscription)
- Pause subscription

**Scenario:** A house cleaner comes every other Friday at 9am. The homeowner can skip specific dates (vacation) or move one cleaning to Thursday. Payment is automatic monthly. They can pause for a month and resume without losing their preferred time slot.

---

### UC-17: The Tour/Experience
**Who:** Guided experiences
**What:** Fixed-start group events
**Needs:**
- Minimum to run (need 4 people)
- Maximum capacity (12 people)
- Multiple time slots per day
- Different languages
- Weather-dependent (with cancellation policy)

**Scenario:** A walking tour company offers "Historic Downtown" at 10am and 2pm daily. Tours need at least 4 people or they're cancelled (full refund). Max 12 per guide. Spanish and English options. If weather is severe, guests can reschedule or get refund.

---

## Part 4: Complex / Enterprise

### UC-18: The Franchise Chain
**Who:** Franchisor with franchisee locations
**What:** Brand consistency with local flexibility
**Needs:**
- Franchisee operates independently
- Brand standards enforced
- Royalty tracking per booking
- Corporate can see all locations
- Transfer customers between franchisees
- Marketing fund contributions

**Scenario:** SuperCuts has 500 franchise locations. Each owner manages their own staff and bookings. Corporate requires all use the same booking system, same service names, same pricing tiers. 6% of each booking goes to franchisor as royalty. Corporate marketing team can run promos across all locations.

---

### UC-19: The Medical Procedure with Prep
**Who:** Complex healthcare
**What:** Multi-step process over days
**Needs:**
- Pre-appointment requirements (fast 12 hours before)
- Multiple appointments linked (consult → procedure → follow-up)
- Different providers each step
- Insurance pre-authorization
- Care instructions between appointments

**Scenario:** A colonoscopy requires: 1) Consultation with doctor, 2) Pre-procedure prep kit pickup, 3) Procedure day, 4) Follow-up call. Each step books separately but linked. Patient gets reminder 1 week before to start special diet. Prep kit must be picked up 3 days before procedure.

---

### UC-20: The Multi-Resource Event
**Who:** Event planners, productions
**What:** One event, many resources
**Needs:**
- Venue + catering + AV + staff
- All must be available same time
- Quote/proposal before booking
- Partial deposits (venue now, catering later)
- Contingency planning (backup venues)

**Scenario:** A wedding needs ceremony space, reception hall, caterer, DJ, photographer, florist. The couple gets a package quote. They pay 25% deposit to hold the date. 6 months before: pay caterer deposit. 1 month before: final headcount and payment. If outdoor ceremony, indoor backup automatically reserved.

---

### UC-21: The Union Production
**Who:** Film/TV/stage production
**What:** Complex scheduling with union rules
**Needs:**
- Cast + crew + equipment + locations
- Union-mandated break times
- Overtime calculations
- Child actor restrictions (school hours, tutor)
- Location permits with time windows
- Weather contingencies for outdoor shoots

**Scenario:** A movie shoot needs the lead actor, stunt double, director, camera crew, and a specific street location (permitted only 6am-6pm). Union rules require meal break every 6 hours. If shooting past 8 hours, overtime rates apply. Child actors can only work until 4pm and need 3 hours of tutoring.

---

### UC-22: The Equipment Sharing Pool
**Who:** Organizations sharing expensive equipment
**What:** Multiple departments booking same resources
**Needs:**
- Priority levels (emergency surgery vs training)
- Equipment checkout/check-in
- Usage tracking (hours/miles)
- Maintenance scheduling
- Cost allocation per department
- Mobile tracking (GPS for vehicles)

**Scenario:** A hospital system has 3 MRI machines shared across 5 locations. The scheduling system shows real-time availability. Emergency scans can bump elective (with approval). Each scan logs machine hours. After 1000 hours, automatic maintenance block. Usage costs are billed to each department monthly.

---

### UC-23: The Airline-Style Overbooking
**Who:** High no-show industries
**What:** Intentionally book more than capacity
**Needs:**
- Historical no-show rates by service/time
- Overbooking algorithm (book 105% of capacity)
- Volunteer incentives (discount for taking later flight)
- Compensation for bumped customers
- Real-time capacity adjustment

**Scenario:** A dentist knows 15% of patients no-show. They book 17 appointments for 16 chairs. If everyone shows, they offer $50 credit to reschedule one person. The system learns: Monday mornings have 5% no-shows, Friday afternoons have 25%, so it adjusts overbooking accordingly.

---

### UC-24: The Conditional/Rule-Based Booking
**Who:** Regulated industries
**What:** Can only book if conditions met
**Needs:**
- Prerequisites (must have had consultation first)
- Age restrictions (21+ for certain services)
- Certification requirements (must be certified diver)
- Medical clearances
- Background checks

**Scenario:** A skydiving company requires: 1) Tandem jump first, 2) Ground school completed, 3) Medical clearance from doctor, 4) Age 18+. The booking system checks all prerequisites before allowing solo jump booking. Expired certifications block booking until renewed.

---

## Part 5: Edge Cases & Special Scenarios

### UC-25: The Standing Reservation
**Who:** VIP or recurring customers
**What:** Same slot reserved indefinitely until cancelled
**Needs:**
- Permanent hold (every Friday 2pm)
- Pay monthly regardless of attendance
- Easy cancellation of single occurrence
- Priority rebooking if cancelled

**Scenario:** A CEO has a standing weekly massage every Friday 2pm. She's billed monthly whether she comes or not. If she cancels one Friday, that slot becomes available to others, but she can reclaim it for next week. She gets priority if she wants to reschedule within the same week.

---

### UC-26: The Floating Appointment
**Who:** Flexible timing
**What:** Book without specific time, get assigned later
**Needs:**
- "Any time Tuesday" booking
- Provider assigns specific slot
- Customer approves or requests different
- Automatic assignment based on optimization

**Scenario:** A patient needs a COVID test "sometime this week." They book a floating slot. The clinic assigns them to Wednesday 10am based on capacity. Patient gets text: "Assigned Wednesday 10am. Reply YES to confirm or call to reschedule." If no response in 2 hours, automatic confirmation.

---

### UC-27: The Reverse Auction
**Who:** Service seekers post needs, providers bid
**What:** Customer posts job, providers compete
**Needs:**
- Customer posts requirements
- Providers submit bids (price + availability)
- Customer reviews and selects
- Booking created from winning bid
- Rating both directions

**Scenario:** Homeowner needs roof repair. Posts: "500 sq ft, asphalt shingles, need done by Friday." Three roofers bid: $2500 (can do Thursday), $2300 (Friday), $2800 (tomorrow). Homeowner picks Thursday option. System books it. Both parties rate each other after completion.

---

### UC-28: The Cascading Appointment
**Who:** Sequential dependent services
**What:** One booking triggers downstream bookings
**Needs:**
- Initial booking creates follow-ups automatically
- Linked appointments (color → cut → style)
- Different providers per step
- Time between steps (processing time)
- Skip/cancel affects downstream

**Scenario:** A hair transformation requires: Bleach (2 hours) → Wait 30 min → Tone (1 hour) → Wait 20 min → Cut (30 min). Customer books "Full Transformation Package." System books 6-hour block but knows it's 3 separate services with gaps. If bleach step is cancelled, downstream steps auto-cancel.

---

### UC-29: The Multi-Timezone Coordination
**Who:** Global teams, telehealth across borders
**What:** Find times that work across timezones
**Needs:**
- All parties see times in their timezone
- System finds overlap (9am NY = 6am LA = 11pm Tokyo)
- Rotate inconvenient times fairly
- DST handling

**Scenario:** A global team meeting needs participants from London, New York, and Sydney. The system shows: "Proposed time: Tuesday 9am ET / 2pm GMT / 11pm AEDT." Sydney participant says "too late." System suggests: "Wednesday 7am ET / 12pm GMT / 9pm AEDT" — earlier but still work-hours for London.

---

### UC-30: The Disaster Recovery
**Who:** Critical services
**What:** Continue operating when primary fails
**Needs:**
- Automatic failover to backup location
- Customer notification of change
- Provider reassignment
- Emergency contact override
- Post-disaster rescheduling en masse

**Scenario:** A fire closes Downtown Medical Clinic. System automatically: 1) Notifies all patients with appointments in next 48 hours, 2) Offers transfer to Uptown location, 3) Reschedules with available providers, 4) Prioritizes urgent appointments. One-click "accept new time" for patients.

---

## Part 6: New Concepts from v2/v3 Analysis

### UC-31: The Company as Provider
**Who:** Businesses that provide services (not individuals)
**What:** "ABC Plumbing" not "John the Plumber"
**Needs:**
- Company profile with multiple technicians
- Dispatch assignment (who goes to which job)
- Company handles scheduling, not individual
- Unified company reviews (not per-technician)
- Technician swap without customer knowing

**Scenario:** Customer books "ABC Plumbing" for Tuesday 2pm. ABC's dispatcher assigns Technician Mike. Customer gets notification "ABC Plumbing arriving Tuesday 2pm." If Mike gets sick, dispatcher reassigns to Technician Sarah without customer involvement. Review is for "ABC Plumbing" overall.

---

### UC-32: The Household Booking
**Who:** Families or groups booking together
**What:** One account, multiple people
**Needs:**
- Parent books for child
- Spouse can see/modify partner's bookings
- Separate profiles per family member
- Family package pricing
- Permissions (teen can book, but parent gets notified)

**Scenario:** The Smith family account has Mom, Dad, and two kids. Mom books pediatrician for Kid #1. Dad can see it and reschedule if needed. Kid #2 (teen) can book tennis lessons but Mom gets notification. Family has "10 swim lessons" package shared across all members.

---

### UC-33: The Product + Service Bundle
**Who:** Businesses selling both services and physical goods
**What:** Haircut + shampoo product, massage + oil
**Needs:**
- Service with product add-on
- Product pickup timing (now or at appointment)
- Inventory tracking
- Shipping if not pickup
- Product-only purchases

**Scenario:** A salon offers "Luxury Hair Package" — cut/color plus take-home shampoo/conditioner. Customer chooses: "Give me products at appointment" or "Ship to me." If shipping, added to order with tracking. Inventory decrements when order placed, not when picked up.

---

### UC-34: The Program with Attendance
**Who:** Multi-session courses
**What:** 8-week fitness challenge, certification program
**Needs:**
- Enroll once, attend multiple sessions
- Track attendance per session
- Makeup sessions for missed classes
- Completion certificate
- Payment plan (pay monthly for 3-month program)

**Scenario:** "Yoga Teacher Training" runs Saturdays 9am-5pm for 12 weeks. Sarah enrolls and pays in 3 monthly installments. She attends 11 of 12 sessions. System marks her "complete" (90% attendance meets requirement). She gets PDF certificate. Missed session #8 can be made up at another location's session.

---

### UC-35: The Cascading Availability
**Who:** High-demand providers controlling access
**What:** Open slots progressively, not all at once
**Needs:**
- Only show next 3 available slots
- When one books, open next slot
- Premium pricing for "skip the line" (see more slots)
- Loyalty gets earlier access

**Scenario:** A celebrity chef opens reservations monthly. Regular customers see 3 slots. When one books, next month's slot opens. VIP members see 10 slots. If you want a specific date not shown, pay 50% premium to "unlock" it. This prevents scalping and rewards loyalty.

---

## Summary: Complexity Spectrum

| Tier | Use Cases | Key Characteristics |
|------|-----------|---------------------|
| **Simple** | UC-1 to UC-5 | Single provider, fixed time, basic payment |
| **Common** | UC-6 to UC-11 | Multi-location, multi-provider, equipment, travel |
| **Occasional** | UC-12 to UC-17 | Packages, dynamic pricing, seat maps, tours |
| **Enterprise** | UC-18 to UC-24 | Franchise, unions, overbooking, rules-based |
| **Edge Cases** | UC-25 to UC-35 | Standing, floating, reverse auction, households |

---

## What This Means for Schema Design

**Must Support:**
1. Multiple bookable types (person, equipment, space)
2. Multiple participants per booking
3. Household/family groupings
4. Products alongside services
5. Recurring and multi-session patterns
6. Waitlists and cascading availability
7. Complex pricing (time-based, dynamic)
8. Cancellation tiers
9. Soft deletion (retain history)

**Can Defer:**
1. AI/ML predictions
2. Real-time collaboration
3. Hybrid virtual/physical modes
4. Multi-brand hierarchy
5. Advanced asset management
6. White-label theming

---

*Comprehensive Use Case Catalog v3.0 — Informed by feature space research. Generated 2026-02-17.*
