---
date: 2026-02-20
tags:
  - research
  - use-cases
  - booking
  - scenarios
  - comprehensive
  - v3
---

# Comprehensive Booking Use Cases v3.0: Expanded Catalog (Natural Language)

> Exhaustive human-language descriptions of booking scenarios in the same style as v2. This version keeps the original catalog, fixes inconsistent logic, and adds missing production-grade scenarios.

---

## Configuration Principle (Simple to Complex)

### Simple setup must stay simple
For common SMB use cases, owners should be able to launch with a short setup flow:
- Select service type
- Set weekly hours
- Set base price and duration
- Add cancellation/deposit policy
- Publish booking link

No advanced rule builder should be required for this path.

### Complex setup must still be possible
For advanced businesses, the platform must support layered rules without forcing them onto simple users:
- Per-service availability
- Multi-resource constraints
- Manual peak/holiday pricing overrides
- Approval workflows and eligibility rules
- Multi-location and multi-organization logic

The same core model should power both paths.

---

## Part 1: Universal / Table Stakes (Must Work in v1.0)

### UC-1: The Solo Consultant (Fixed Duration)
**Who:** Independent professional (therapist, coach, consultant)
**What:** Offers 1-on-1 sessions with fixed time slots
**Needs:**
- Simple online booking page
- Fixed-duration appointments (e.g., 50 minutes)
- Basic availability (M-F 9-5)
- Email confirmations
- Calendar sync (Google/Outlook)
- Payment collection (Stripe)
- Simple cancellation (24-hour notice)
- Booking notes ("allergic to lavender")

**Scenario:** Sarah is a career coach. Clients visit her booking page, see available 50-minute slots, pick a time, enter credit card, receive Zoom link. Cancel more than 24 hours ahead = automatic refund. Sarah sees all bookings in Google Calendar. She adds private note: "This client is switching careers from finance to tech."

---

### UC-2: The Solo Consultant (Variable Duration)
**Who:** Consultant who lets clients choose session length
**What:** Flexible appointment duration chosen by client
**Needs:**
- Variable duration selection (30 minutes to 4 hours)
- Hourly pricing that scales with duration
- Availability shown in variable chunks
- Automatic buffer calculation based on selected duration
- Booking summary: "2.5 hours @ $100/hr = $250"

**Scenario:** Mark is a business consultant. Clients select anywhere from 1-hour quick consults to 4-hour deep dives. System shows his availability in flexible blocks. Client books 2.5 hours. System automatically adds 15-minute buffer after. If client needs to extend mid-session, provider can modify booking and charge additional time.

---

### UC-3: The Hair Salon with Commission Tracking
**Who:** Small service business with multiple staff and commission splits
**What:** Various services with different durations, commission tracking per provider
**Needs:**
- Multiple service types (15 min to 3 hours)
- Multiple providers (stylists) with individual calendars
- Commission configuration per provider (60% to stylist, 40% to salon)
- Automatic commission calculation per booking
- Pay stub generation with earnings breakdown
- Buffer time between appointments (cleanup)
- Walk-in support (queue management)
- Service add-ons (deep conditioning)
- Deposit for expensive services (color)

**Scenario:** Maria runs a salon with 4 stylists. Each stylist has their own commission rate - veterans get 70%, juniors get 50%. Customer books color with Stylist A (senior, 70% commission, $200 service = $140 to stylist). System tracks this automatically. Walk-ins join digital queue with estimated wait times. At month end, system generates pay stubs showing: base services, add-ons, tips, total commission owed.

---

### UC-4: The Salon with Provider Favorability/Ranking
**Who:** Salon using performance-based slot allocation
**What:** Top-rated providers get priority booking slots, new providers get overflow
**Needs:**
- Provider ranking system (rating + review count + tenure)
- Favorability score calculation
- Slot allocation based on favorability
- Manual admin override for seasonality
- Veteran status tracking
- Performance analytics (booking rate, cancellation rate)

**Scenario:** Salon has 5 stylists. Stylist A: 4.9 stars, 200 reviews, 5 years = favorability score 95. Stylist E: 3.8 stars, 15 reviews, 2 months = score 45. Prime slots (Saturday 10am-2pm) only shown for Stylists A-C. New stylist E only gets Tuesday-Thursday slots until score improves. Manager can temporarily boost a stylist's favorability during busy seasons.

---

### UC-5: The Medical Clinic with Room Pairing
**Who:** Healthcare provider with specific room requirements
**What:** Appointments requiring specific rooms/equipment, provider-room pairing
**Needs:**
- Provider + room pairing (Dr. Smith needs Exam Room 2 with her equipment)
- Room-specific availability (if Room 2 breaks, Dr. Smith's appointments pause)
- Different appointment types (annual physical vs sick visit)
- Insurance verification before booking
- Patient forms completed online
- Reminder calls/texts (reduce no-shows)
- Waitlist for cancellations
- HIPAA-compliant everything
- Multi-type notes (clinical, billing, patient-facing)

**Scenario:** Family practice has 3 doctors and 5 exam rooms. Dr. Jones is always paired with Room 3 (contains her specialized equipment). If Room 3's examination table breaks, system automatically blocks all Dr. Jones' appointments until room repaired. Annual physicals = 30 minutes + 15 min buffer for notes. Sick visits = 15 minutes. Patient cancels? Waitlist notified in priority order (established patients first).

---

### UC-6: The Medical Clinic with Approval Workflow
**Who:** Specialist requiring manual review before confirmation
**What:** Complex appointments that need provider approval
**Needs:**
- Request-based booking (not immediate confirmation)
- Provider approval workflow (accept, decline, or suggest alternative)
- Approval deadline (respond within 24 hours)
- Hold card but don't charge until approved
- Patient notification of approval/decline
- Reason field for decline

**Scenario:** Patient requests appointment with renowned cardiologist. Submits request with symptoms and referral info. Cardiologist reviews within 24 hours - can accept, decline ("not taking new patients"), or suggest alternative time. Only charged upon approval. If no response in 24 hours, patient gets "Still reviewing, will update soon" notification.

---

### UC-7: The Fitness Class Studio
**Who:** Gym or boutique fitness with group classes
**What:** Group classes with capacity limits, equipment assignment
**Needs:**
- Class capacity (max 30 people)
- Minimum to run (cancel if under 5)
- Instructor assignment
- Room assignment
- Equipment per participant (bike #1, bike #2)
- Membership vs drop-in pricing
- Late cancellation fees
- Waitlist
- Cancellation tracking (3 strikes = penalty)

**Scenario:** Spin City offers 6 classes daily. Each bike is numbered; members have favorites. Classes need 5 people to run or cancelled 2 hours before with full refund. Member Sarah loves bike #12. If bike #12 taken, system offers #11 or #13 as alternatives. If class full, join waitlist. If Sarah cancels within 8 hours, charged $10. After 3 late cancellations in a month, booking privileges suspended for 2 weeks.

---

### UC-8: The Tutoring Center with Packages
**Who:** Education service with session packages
**What:** Recurring sessions with package deals
**Needs:**
- Weekly recurring bookings (Tuesdays 4pm)
- Subject matching (algebra tutor, not English)
- Parent booking for child
- Progress notes per session
- Package deals (buy 10 sessions, get 1 free)
- Package tracking (sessions remaining: 7 of 10)
- Substitute tutor if regular is sick
- Expiration dates on packages (use within 6 months)

**Scenario:** Johnsons buy "20 Math Sessions" package for $1800 (10% discount). Every Tuesday 4pm with Ms. Rodriguez. System shows: "Sessions remaining: 17 of 20. Expires: Aug 15, 2026." If Ms. Rodriguez sick, system assigns substitute Mr. Chen (also math-certified) and notifies family. After each session, tutor adds notes: "Covered quadratic equations, struggled with factoring, review next week."

---

### UC-9: The Front Desk Receptionist Calendar
**Who:** Receptionist managing multiple providers
**What:** Central view of all provider calendars with different permissions
**Needs:**
- Central calendar view showing all providers
- Overlay or side-by-side display
- Different permissions than providers (can book, can block, can't see patient details)
- Walk-in booking capability
- Override availability ("emergency slot")
- Real-time updates
- Patient privacy (sees "blocked" not patient names)

**Scenario:** Medical receptionist sees 4 doctors' calendars overlaid. Can see Dr. A has opening at 2pm, Dr. B is full. Walk-in patient arrives - receptionist checks "who's available in next 30 minutes?" and books them. Can see Dr. C's slot says "blocked" but not "John Smith - physical." Can add emergency appointment overriding normal availability for urgent cases.

---

## Part 2: Common / Expected Features (Should Have)

### UC-10: The Multi-Location Chain
**Who:** Business with multiple branches
**What:** Same services offered at different locations
**Needs:**
- Location selection by customer
- Different hours per location
- Some providers work multiple locations
- Transfer bookings between locations
- Location-specific pricing (downtown premium)
- Central management view
- Location-specific availability

**Scenario:** Clean Teeth Dental has 5 offices. Patients can book at any location. Dr. Williams works Mondays downtown, Wednesdays suburban. Prices 10% higher downtown (rent premium). If downtown X-ray machine breaks, appointments auto-transfer to nearest location with capacity and patient gets text: "Your appointment moved to our Midtown location (same time)."

---

### UC-11: The Multi-Provider Appointment with Commission Split
**Who:** Services requiring multiple people with different pay rates
**What:** One booking, multiple staff, automatic commission calculation
**Needs:**
- Primary + assistant assignment
- All must be available for slot to show
- Different pay rates per role (lead: $150, assistant: $75)
- Automatic commission calculation per person
- Backup if primary unavailable
- Role-based compensation rules

**Scenario:** Wedding photography package: lead photographer ($300), second shooter ($150), assistant ($75). Total: $525 package. Customer pays $525. System automatically splits: lead gets $300, second gets $150, assistant gets $75 on their pay stubs. If lead gets sick 2 days before, backup lead activated and gets full $300 rate.

---

### UC-12: The Equipment-Required Service with Auto-Maintenance
**Who:** Services needing specific equipment with automated maintenance
**What:** Provider + equipment must both be free, automatic maintenance scheduling
**Needs:**
- Equipment calendar (MRI machine, massage table)
- Equipment maintenance blocks
- Auto-maintenance trigger ("after 40 hours use, schedule cleaning")
- Different equipment for different services
- Usage tracking per equipment
- Equipment failure cascade handling

**Scenario:** MRI clinic has 2 machines. Machine A auto-schedules maintenance every 100 scans or 40 hours of use. At 35 hours, system creates "maintenance block" in calendar. If Machine A breaks unexpectedly, all its appointments for next 7 days get reassigned to Machine B or patients notified to reschedule.

---

### UC-13: The Multi-Day Rental with Gap Management
**Who:** Equipment or property rental
**What:** Bookings spanning multiple days with cleaning gaps
**Needs:**
- Check-in/check-out times
- Gap days/hours for cleaning/service
- Different daily vs weekly rates
- Damage deposit hold
- Late return fees
- Different return location (one-way rental)
- Gap time calculation and enforcement

**Scenario:** Beach House Rentals: Check-in 4pm, check-out 11am. Cleaner needs 5 hours between guests. If Guest A checks out 11am, Guest B can't check in until 4pm (5-hour gap). System enforces this - no booking possible that violates gap. Weekly rate 20% off. $500 damage deposit held, released 48 hours after checkout if no issues reported.

---

### UC-14: The Corporate Training with Attendance Tracking
**Who:** B2B training provider
**What:** Multi-session programs for companies with attendance
**Needs:**
- Multi-session packages (5 weekly sessions)
- Attendance tracking per session
- Certificate upon completion (80% attendance required)
- Company pays (invoicing, not immediate charge)
- Substitute employees (anyone from company can attend)
- Minimum attendance to run class
- Makeup session options

**Scenario:** TechCorp buys "Leadership 101" for 12 employees. 5 Tuesday afternoons. Attendance tracked each week: Sarah attended 4/5, John attended 5/5. Sarah completes course (80% threshold met). John gets "Perfect Attendance" note on certificate. If fewer than 8 show up, class rescheduled. If employee misses session 3, can make up at another company's session next week.

---

### UC-15: The Mobile Service with Route Optimization
**Who:** Provider travels to customer
**What:** Location-based scheduling with optimized routes
**Needs:**
- Service area definition (zip codes or radius)
- Travel time between appointments
- Optimized route planning (minimize drive time)
- Customer location saved
- "I'm on my way" notifications
- ETA updates
- Unpaid drive time tracking (for timesheets)

**Scenario:** Mike's Mobile Dog Grooming serves 20-mile radius. System optimizes daily route: 9am Smiths, 10:15am Johnsons (12 min drive), 11:30am Parkers. Drive time tracked but unpaid - only grooming time paid at $40/hr. Customer gets "Mike is 10 minutes away" text when he's approaching. If traffic delays, ETA updates automatically.

---

## Part 3: Advanced Features (Occasional)

### UC-16: The Package Deal with Expiration
**Who:** Any service business
**What:** Pre-paid bundles that are flexible across services, with expiration and transfer rules
**Needs:**
- Buy 5 get 1 free structure
- Track remaining sessions
- Expiration dates (use within 6 months)
- Transferable to friend
- Partial refund for unused sessions (prorated)
- Package sharing within household

**Scenario:** Yoga studio sells a "10-class flex pass" for $150 (vs $20 drop-in). Sarah buys one, attends 6 classes, then moves away. She transfers the remaining 4 classes to her friend (transfer fee: $5). Pass expires 6 months from purchase. If she requests a refund instead, the system calculates unused value minus consumed discount and transfer/cancellation policy, then shows the exact amount before confirmation.

---

### UC-17: The Dynamic/Surge Pricing
**Who:** High-demand limited supply
**What:** Price changes based on demand
**Needs:**
- Surge pricing algorithm (Uber model)
- Last-minute discounts to fill empty slots
- Early bird pricing
- Waitlist with priority bidding
- Fill-rate based pricing (20% full = $20, 80% full = $30)

**Scenario:** Celebrity stylist has 4 slots per week. Base price $200. If 10+ people want same slot, price surges to $400. If slot still empty 2 hours before, price drops to $150 to fill it. VIP clients ($50/month membership) see prices 24 hours before general public, avoiding surge.

---

### UC-18: The Seat Selection Venue
**Who:** Venues with specific seating
**What:** Customer picks exact seat/spot
**Needs:**
- Visual seat map
- Different pricing per seat (front row premium)
- Group seating (keep seats together)
- Accessibility seating
- Hold seats while paying (10-minute reservation)
- Seat preferences (aisle vs middle)

**Scenario:** Theater sells tickets online. Seat map shows: Orchestra $75, Mezzanine $50, Balcony $35. Row A (front) $95. Wheelchair accessible seats are clearly marked. Customer selects 4 seats together, and the seats are held for 10 minutes during checkout. If payment fails, seats are released automatically. For group bookings, the system recommends adjacent seats first, but can allow split seating when the customer explicitly accepts it.

---

### UC-19: The Waitlist with Auto-Offer and Pricing
**Who:** High-demand services
**What:** Priority waitlist that can auto-offer a released slot with a response timer
**Needs:**
- Waitlist queue with position
- Pay to join waitlist ($5 fee)
- Automatic offer when slot opens
- Time to accept (2 hours)
- Auto-confirm if customer opted into "instant accept"
- Fee policy if offer is declined after acceptance
- Priority tiers (members first)
- Refund if never gets spot

**Scenario:** Popular restaurant is fully booked, with 50 people on the waitlist for Saturday 7pm. Joining costs $5. When a cancellation happens, the first person in line receives an offer and has 2 hours to accept. If they enabled "instant accept," the system confirms automatically and charges according to policy. If they decline or time out, the offer moves to the next person. If they never receive a slot by the waitlist cutoff, the $5 waitlist fee is refunded.

---

### UC-20: The First-Confirm-First-Booked Waitlist
**Who:** Fair competition for limited slots
**What:** Multiple people notified simultaneously, first to claim gets it
**Needs:**
- Broadcast notification to all waitlisters
- Race condition handling (first tap wins)
- Real-time status updates ("Claimed by someone else")
- Auto-refresh showing new availability
- Equal opportunity (no priority tiers)

**Scenario:** 10 people on waitlist for sold-out yoga class. Spot opens. All 10 get simultaneous notification: "Spot available! Tap to claim." Three people tap within 2 seconds. First tap (Sarah) gets booking confirmation. Other two see "Sorry, claimed by another user" with option to join waitlist for next opening.

---

### UC-21: The Recurring Subscription with Pause
**Who:** Ongoing services
**What:** Same time every week/month indefinitely with flexibility
**Needs:**
- Weekly recurring (every Tuesday 2pm)
- Skip individual occurrences
- Reschedule single instance
- Automatic payment (subscription)
- Pause subscription (keep slot reserved)
- Credit rollover for unused time

**Scenario:** House cleaner every other Friday 9am. $120/month subscription. Homeowner can skip specific dates (vacation) without losing subscription. Can move one cleaning to Thursday for that week only. Pauses for 2 months (maternity leave) - subscription on hold, same time slot reserved for return. Unused hours from previous month rollover as credit.

---

### UC-22: The Tour/Experience with Minimum Viable
**Who:** Guided experiences
**What:** Fixed-start group events with minimums
**Needs:**
- Minimum to run (need 4 people)
- Maximum capacity (12 people)
- Multiple time slots per day
- Different languages
- Weather-dependent (with cancellation policy)
- Guide assignment

**Scenario:** Walking tour company offers "Historic Downtown" at 10am and 2pm daily. Tours need at least 4 people or cancelled (full refund). Max 12 per guide. Spanish and English options. If severe weather forecast, guests can reschedule or get refund. If only 3 book by T-2 hours, tour cancelled with apologies and rebooking offers.

---

## Part 4: Enterprise & Complex

### UC-23: The Franchise Chain with Royalty
**Who:** Franchisor with franchisee locations
**What:** Brand consistency with local control, royalty tracking
**Needs:**
- Franchisee operates independently
- Brand standards enforced
- Royalty tracking per booking (6% to franchisor)
- Corporate visibility across all locations
- Transfer customers between franchisees
- Marketing fund contributions
- Centralized reporting

**Scenario:** SuperCuts has 500 franchise locations. Each owner manages staff and bookings. Corporate requires all use same booking system, same service names, same pricing tiers. Every $100 haircut: $94 to franchisee, $6 royalty to corporate. Corporate marketing team runs "$10 off all cuts" promo across all locations with one click. Franchisees can't opt out.

---

### UC-24: The Multi-Step Medical Procedure
**Who:** Complex healthcare with prerequisites
**What:** Multi-step process over days with dependencies
**Needs:**
- Pre-appointment requirements (fast 12 hours before)
- Multiple appointments linked (consult → procedure → follow-up)
- Different providers each step
- Insurance pre-authorization
- Care instructions between appointments
- Prerequisite checking (can't book surgery without consultation)

**Scenario:** Colonoscopy requires: 1) Consultation with doctor, 2) Pre-procedure prep kit pickup, 3) Procedure day, 4) Follow-up call. System books all 4 at once with appropriate gaps. Patient gets reminder 1 week before to start special diet. Can't book procedure without completed consultation showing in records. Prep kit must be picked up 3 days before procedure.

---

### UC-25: The Multi-Resource Event
**Who:** Event planners, weddings, productions
**What:** One event requiring multiple coordinated resources
**Needs:**
- Venue + catering + AV + staff all in one booking
- All must be available same time
- Quote/proposal before booking
- Partial deposits (venue now, catering later)
- Contingency planning (backup venues)
- Resource dependencies

**Scenario:** Wedding needs ceremony space, reception hall, caterer, DJ, photographer, florist. Couple gets package quote: $15,000. They pay 25% deposit ($3,750) to hold date. 6 months before: pay caterer deposit. 1 month before: final headcount and payment. If outdoor ceremony selected, indoor backup automatically reserved at no extra charge until day-before weather decision.

---

### UC-26: The Union Production with Complex Rules
**Who:** Film/TV/stage production
**What:** Complex scheduling with union rules
**Needs:**
- Cast + crew + equipment + locations
- Union-mandated break times
- Overtime calculations (time-and-a-half after 8 hours)
- Child actor restrictions (school hours, tutor, max 6 hours)
- Location permits with time windows
- Weather contingencies
- Call sheet generation

**Scenario:** Movie shoot needs lead actor, stunt double, director, camera crew, street location (permitted 6am-6pm only). Union rules: meal break every 6 hours, 1 hour minimum. Past 8 hours = overtime rates. Child actor (10 years old): max 6 hours on set, must have 3 hours tutoring, done by 4pm. System builds schedule backwards from 4pm, ensures all constraints met, generates call sheets.

---

### UC-27: The Equipment Sharing Pool
**Who:** Organizations sharing expensive equipment
**What:** Multiple departments booking same resources
**Needs:**
- Priority levels (emergency surgery vs training)
- Equipment checkout/check-in
- Usage tracking (hours/miles)
- Maintenance scheduling
- Cost allocation per department
- GPS tracking for vehicles
- Overbooking prevention

**Scenario:** Hospital system shares 3 MRI machines across 5 locations. Priority: Emergency (stroke) > Urgent (suspected tumor) > Scheduled (routine screening). Real-time availability shows all machines. At 8pm, emergency scan can bump tomorrow's routine appointment (patient notified, rescheduled). Each scan logs machine hours. After 1000 hours, automatic maintenance block. Usage costs billed to each department monthly.

---

### UC-28: The Airline-Style Overbooking
**Who:** High no-show industries
**What:** Intentionally book more than capacity
**Needs:**
- Historical no-show rates by service/time
- Overbooking algorithm (book 105% of capacity)
- Volunteer incentives (discount for taking later slot)
- Compensation for bumped customers
- Real-time capacity adjustment
- No-show prediction

**Scenario:** Dentist knows 15% of patients no-show. Books 17 appointments for 16 chairs. If everyone shows, offers $50 credit to volunteer to reschedule. System learns: Monday mornings 5% no-shows, Friday afternoons 25%. Adjusts overbooking accordingly. Predicts Sarah has 30% no-show probability based on history - her appointment counts as 0.7 toward capacity, allowing slight overbooking.

---

### UC-29: The Conditional/Rule-Based Booking
**Who:** Regulated industries
**What:** Can only book if conditions met
**Needs:**
- Prerequisites (must have had consultation first)
- Age restrictions (21+ for certain services)
- Certification requirements (must be certified diver)
- Medical clearances
- Background checks
- Expiration tracking (certifications expire)

**Scenario:** Skydiving company requires: 1) Tandem jump first, 2) Ground school completed, 3) Medical clearance from doctor (good for 1 year), 4) Age 18+. System checks all before allowing solo jump booking. Diver got medical clearance 13 months ago - expired! Booking blocked until renewal submitted. After tandem jump completed yesterday, system unlocks ground school booking.

---

## Part 5: Edge Cases & Special Scenarios

### UC-30: The Standing Reservation
**Who:** VIP or recurring customers
**What:** Same slot reserved indefinitely until cancelled
**Needs:**
- Permanent hold (every Friday 2pm)
- Pay monthly regardless of attendance
- Easy cancellation of single occurrence
- Priority rebooking if cancelled
- Pause without losing slot

**Scenario:** CEO has standing weekly massage every Friday 2pm. Charged $400/month whether they come or not. Can cancel one Friday for business travel, but slot held for next week. If they need to reschedule within same week, gets priority over other requests. Can pause for vacation month without losing preferred time permanently.

---

### UC-31: The Floating Appointment
**Who:** Flexible timing
**What:** Book without specific time, get assigned later
**Needs:**
- "Any time Tuesday" or "This week" booking
- Provider assigns specific slot based on optimization
- Customer approval or auto-accept
- Time window selection (morning, afternoon, evening)
- Reassignment if needed

**Scenario:** Patient needs MRI "sometime this week." Selects "Tuesday-Thursday, morning preferred." Books floating appointment. System optimizes: assigns Wednesday 10:30am based on technician availability and machine schedule. Patient gets text: "Assigned Wednesday 10:30am. Reply YES to confirm or call to reschedule." No response in 2 hours = automatic confirmation.

---

### UC-32: The Reverse Auction Marketplace
**Who:** Service marketplace
**What:** Customers post needs, providers bid
**Needs:**
- Customer posts requirements with budget/timeline
- Providers submit bids (price + availability)
- Provider portfolios/reviews visible
- Customer reviews and selects winner
- Booking created from winning bid
- Rating both directions
- Marketplace fee (5% to platform)

**Scenario:** Homeowner posts: "Need roof repair, 2000 sq ft asphalt shingles, by next Friday, budget $2000-$3000." Three roofers bid: ABC Roofing $2500 (Thursday), Top Roof $2300 (Friday), Quick Fix $2800 (tomorrow). Homeowner reviews portfolios, sees ABC has 4.8 stars and 50 reviews, picks them. Booking created at $2500. Bizing takes 5% fee ($125). Both parties rate each other after completion.

---

### UC-33: The Cascading Appointment
**Who:** Sequential dependent services
**What:** One booking triggers downstream bookings
**Needs:**
- Initial booking creates follow-ups automatically
- Linked appointments (color → tone → cut)
- Different providers per step
- Time between steps (processing time)
- Skip/cancel affects downstream
- Package pricing for full sequence

**Scenario:** Hair transformation package: Bleach (2 hours) → Wait 30 min → Tone (1 hour) → Wait 20 min → Cut (30 min). Customer books "Full Platinum Transformation" - one price, one booking. System schedules 4.5-hour block, knows it's 3 services with gaps. If bleach step cancelled day before, downstream tone and cut auto-cancelled with customer notification and rebooking offer.

---

### UC-34: The Multi-Timezone Coordination
**Who:** Global teams, telehealth across borders
**What:** Find times working across timezones
**Needs:**
- All parties see times in their timezone
- System finds overlap (9am NY = 6am LA = 11pm Tokyo)
- Rotate inconvenient times fairly
- DST handling with stored timezone snapshots
- Visual timezone converter
- Suggest alternatives

**Scenario:** Global team meeting needs London, New York, and Sydney participants. System shows: "Proposed: Tuesday 9am ET / 2pm GMT / 11pm AEDT." Sydney participant says that is too late. System suggests: "Wednesday 7am ET / 12pm GMT / 9pm AEDT." It stores each participant's timezone at booking time so reminders and history remain accurate when daylight saving changes later.

---

### UC-35: The Disaster Recovery Mass Reschedule
**Who:** Critical services
**What:** Continue operating when primary fails
**Needs:**
- Automatic failover to backup location
- Mass customer notification
- Provider reassignment
- Emergency contact override
- Post-disaster rescheduling en masse
- Priority triage (urgent vs routine)

**Scenario:** Fire closes Downtown Medical Clinic. System automatically: 1) Identifies all patients with appointments next 48 hours (247 appointments), 2) Sends batch text: "Downtown closed due to emergency. Reply 1 for Uptown location, 2 for reschedule, 3 for cancel," 3) Processes 200 responses automatically (180 choose Uptown, 30 reschedule, 10 cancel), 4) Prioritizes urgent appointments for same-day Uptown slots, 5) Updates all calendars in real-time.

---

## Part 6: New Concepts (v3.0 Refinements)

### UC-36: The Company as Provider
**Who:** Businesses that provide services (not individuals)
**What:** "ABC Plumbing Corp" not "John the Plumber"
**Needs:**
- Company profile with multiple technicians
- Dispatch assignment (who goes where)
- Company handles scheduling, not individual
- Unified company reviews (not per-technician)
- Technician swap without customer knowing
- Company-level availability, technician-level assignment

**Scenario:** Customer books "ABC Plumbing" for Tuesday 2pm. ABC's dispatcher sees 3 technicians available, assigns Technician Mike based on location/skill. Customer gets notification "ABC Plumbing arriving Tuesday 2pm." Day of, Mike sick, dispatcher reassigns to Technician Sarah. Customer never knows - just sees "ABC Plumbing" arrival. Leaves review for "ABC Plumbing" overall, not individual tech.

---

### UC-37: The Household/Family Account
**Who:** Families or groups sharing bookings
**What:** One account, multiple people, permissions
**Needs:**
- Parent books for child
- Spouse sees/modifies partner's bookings
- Separate profiles per family member
- Family package pricing (shared pool)
- Permissions (teen can book but parent gets notified)
- Household member management
- Delegated authority

**Scenario:** Smith family account: Mom, Dad, Teen (16), Child (10). Mom books pediatrician for Child. Dad can see it and reschedule if needed. Teen books tennis lessons - Mom gets notification "Jamie booked tennis lesson Friday 4pm." Family has "10 swim lessons" package shared across all members - anyone can use. Mom has full authority, Teen has limited, Child has none.

---

### UC-38: The Product + Service Bundle
**Who:** Businesses selling services with physical goods
**What:** Haircut + shampoo, massage + oil, training + materials
**Needs:**
- Service with product add-on
- Product pickup timing (now or at appointment)
- Inventory tracking
- Shipping if not pickup
- Product-only purchases
- Digital products (download links)
- Bundle pricing (cheaper together)

**Scenario:** Salon offers "Luxury Hair Package" - cut/color ($150) plus take-home shampoo/conditioner ($40 value). Customer chooses: "Give products at appointment" or "Ship to me." If shipping, added to order with $8 shipping, tracking number provided. Inventory decrements when order placed (not when picked up). Digital option: "Hair Care Guide" PDF download included.

---

### UC-39: The Program with Attendance Tracking
**Who:** Multi-session courses, certifications
**What:** Cohort-based program with milestones, attendance, and graduation outcomes
**Needs:**
- Enroll once, attend multiple sessions
- Track attendance per session (present/absent)
- Makeup sessions for missed classes
- Completion certificate (80% attendance required)
- Payment plans (monthly for 3-month program)
- Progress dashboard
- Prerequisites checking

**Scenario:** "Yoga Teacher Training" runs Saturdays 9am-5pm for 12 weeks as one named cohort. Sarah enrolls and pays in 3 monthly installments ($400/month). She attends 11 of 12 sessions, completes the required practicum, and crosses the graduation threshold. System marks her as "Complete" and sends a certificate. If she misses Session 8, she can make it up in a designated makeup cohort and keep the same graduation timeline.

---

### UC-40: The Cascading Availability (Controlled Access)
**Who:** High-demand providers managing demand
**What:** Open slots progressively, not all at once
**Needs:**
- Only show next 3 available slots initially
- When one books, open next slot
- Premium pricing for "skip the line" (see 10 slots)
- Loyalty gets earlier access (30 days vs 7 days)
- Prevent scalping
- Reward regular customers

**Scenario:** Celebrity therapist books 30 days out. Regular patients see only next 3 available slots (oldest first). When one books, next month's slot becomes visible. VIP patients ($100/year membership) see 10 slots ahead. Patient wants specific date not shown yet - can pay $50 "priority access" to unlock it. Regulars who've had 10+ sessions get 14-day view instead of 7-day.

---

### UC-41: The Filler Booking Discount
**Who:** Avoiding empty slots
**What:** Offer discounts to fill last-minute openings
**Needs:**
- Detect empty slots within 24-48 hours
- Calculate discount percentage
- Target past customers who might book
- SMS/email blast: "50% off tomorrow 2pm - first to book!"
- Time-limited offers (expires in 2 hours)
- Revenue protection (better 50% than 0%)

**Scenario:** Photographer has empty slot tomorrow 2pm (normally $300). System detects at risk, sends to 20 past clients: "Flash Sale: $150 for tomorrow 2pm portrait session. First to book gets it!" Slot fills in 8 minutes. If no takers after 2 hours, discount increases to 60% off and resent to wider list.

---

### UC-42: The Host Cancellation Penalty
**Who:** Penalizing provider cancellations
**What:** Financial and reputation consequences for late cancellations
**Needs:**
- Cancellation window tracking (within 48 hours = penalty)
- Financial penalty (lose 20% of fee)
- Favorability score impact
- Points system affecting future slot allocation
- Strike system (3 strikes = suspension)
- Emergency exceptions

**Scenario:** Doctor cancels appointment within 48 hours. Loses $40 of $200 fee (20% penalty). Favorability score drops from 85 to 78. After 3 late cancellations in a month, temporarily removed from booking system for 2 weeks. After 5 in a quarter, required meeting with administrator. Legitimate emergency (hospital called in) can be appealed.

---

### UC-43: The Dynamic Duration with Price Adjustment
**Who:** Services where time is unpredictable
**What:** Estimate-based booking with final price adjustment
**Needs:**
- Estimated time range (2-3 hours)
- Initial booking at minimum time
- Time tracking during service
- Automatic extension if running long
- Overtime pricing (higher rate for extra time)
- Refund if finished early
- Customer notification of price changes

**Scenario:** Handyman job estimated 2-3 hours. Customer books 2 hours at $80/hour = $160. Job takes 3.5 hours. System charges additional 1.5 hours at $100/hour (overtime rate) = $150 extra. Total: $310. If finished in 1.5 hours, customer refunded 0.5 hours ($40). Customer gets real-time updates: "Job running longer than estimated, additional charges may apply."

---

### UC-44: The Overtime Prediction and Avoidance
**Who:** Preventing employee overtime
**What:** Alert before overtime threshold hit
**Needs:**
- Track scheduled hours per employee
- Predict if upcoming bookings will exceed threshold (8 hours)
- Alert dispatcher/manager
- Suggest alternatives (assign to different employee)
- Overtime cost calculation
- Weekly/monthly overtime tracking

**Scenario:** Plumber has 3 jobs scheduled: 9am-11am (2hr), 12pm-3pm (3hr), 4pm-6pm (2hr) = 7 hours. Dispatcher adds 4th job 7pm-9pm (2hr). System alerts: "This will put Mike at 9 hours (1 hour overtime). Suggest: Assign 7pm job to Sarah to avoid overtime costs." Manager can override or reassign.

---

### UC-45: The Service-Specific Availability
**Who:** Same person, different availability per service
**What:** Provider available for some services but not others at certain times
**Needs:**
- Calendar per service type per provider
- Granular availability (consultations mornings, procedures afternoons)
- Service category restrictions
- Override capability
- Patient communication ("Dr. Smith only does consultations on Mondays")

**Scenario:** Dr. Smith is available Monday mornings for 30-minute consultations but NOT for 2-hour procedures (needs full day blocked). Same person, different availability. Patient looking for procedure sees Dr. Smith only Tuesday-Friday. Patient looking for consultation sees Dr. Smith Monday-Friday. System tracks separately.

---

### UC-46: The Available by Default vs Unavailable by Default
**Who:** Different staffing models
**What:** Configurable default state for availability
**Needs:**
- Staff-level configuration
- Available by default (typical 9-5 workers)
- Unavailable by default (on-call specialists)
- Mark specific slots as available (for on-call)
- Toggle between modes
- Bulk availability setting

**Scenario:** Most clinic staff (receptionists, nurses) are "available by default" during business hours - they show as bookable unless marked off. On-call specialists (cardiologists for emergencies) are "unavailable by default" - they don't show as bookable unless they specifically mark "available for emergency consult Tuesday 2pm-4pm."

---

### UC-47: The Use-It-Anytime Membership
**Who:** Facilities with open access
**What:** Pay for time allowance, use anytime during open hours
**Needs:**
- Time-based membership (10 hours/week)
- Entry/exit tracking
- Real-time usage display ("You've used 7 of 10 hours")
- Block entry if allowance exceeded
- Upgrade offers at entry
- Rollover unused hours (or not)
- Peak vs off-peak hours

**Scenario:** Gym membership: $50/month for 10 hours/week access. Member scans card to enter, scans to exit. System tracks time. After 7 hours used, gets text: "3 hours remaining this week." Tries to enter after 10 hours - door denies entry with screen: "Weekly limit reached. Upgrade to unlimited for $20?" Unused hours don't roll over (use it or lose it).

---

### UC-48: The Auction-Based Booking
**Who:** High-demand exclusive access
**What:** Competitive bidding for limited slots
**Needs:**
- Open bidding period (7 days)
- Minimum bid
- Anonymous bidding (don't see others' bids)
- Automatic bid extension if bid in final hour (prevent sniping)
- Winner notification
- Loser notification with next available dates
- Payment collection from winner

**Scenario:** 3 slots available for celebrity chef's private dinner. Bidding open 7 days. Minimum $500. Sarah bids $750, John bids $800, Maria bids $950. With 10 minutes left, Sarah increases to $1000. Auction extends 10 minutes. John bids $1100. No more bids. John wins, charged $1100. Sarah and Maria get "You lost this auction, next available dates: March 15, April 2."

---

### UC-49: The AI Agent Notes
**Who:** System-generated insights about bookings/customers
**What:** Three types of notes with different visibility
**Needs:**
- Public notes (visible to all): "Allergic to lavender"
- Private notes (provider only): "Difficult customer, be extra patient"
- AI agent notes (system insights): "Tends to book last minute, send reminder 24h early"
- Note permissions and visibility rules
- AI learning from patterns
- Note categories and searchability

**Scenario:** Customer books massage. Public note (they added): "Prefer lighter pressure." Provider private note: "Gift certificate user, mention expiration." AI agent note (system learned): "This customer has cancelled 2 of last 10 bookings, send extra reminder." Different notes visible to different people.

---

### UC-50: The Complete Audit Trail
**Who:** Compliance and accountability
**What:** Every change tracked immutably
**Needs:**
- Log every create, read, update, delete
- Capture: who, what, when, before value, after value, reason
- Immutable storage (can't be deleted)
- Policy-based retention (configured per industry and tenant)
- Searchable by user, date, field, booking
- Export capability
- Anomaly detection

**Scenario:** Booking originally set for Tuesday 2pm is moved to Wednesday 3pm by the receptionist at patient request. Audit log captures actor, action, before/after values, timestamp, reason, and source IP. Records cannot be edited or removed by normal users. Retention follows the tenant's compliance profile, and admins can search by booking ID, user, date, or field change.

---

### UC-51: The Multi-Level Organization Booking
**Who:** Organization hiring another organization
**What:** Wedding planner on Bizing books caterer also on Bizing
**Needs:**
- Cross-organization booking
- Both orgs' calendars affected
- Internal visibility per org (planner sees full details, caterer sees relevant details)
- Payment between organizations
- Commission or finder fee
- Shared timeline but private internal notes

**Scenario:** Wedding planning company "Forever After" on Bizing platform books caterer "Gourmet Events" also on Bizing. Forever After's calendar shows "Smith-Jones Wedding." Gourmet Events' calendar shows "Catering for Smith-Jones (booked by Forever After)." Forever After sees full wedding timeline. Gourmet Events sees only their catering slot and setup time. Payment flows: Customer → Forever After → Gourmet Events (minus 10% commission).

---

### UC-52: The Hybrid Virtual + In-Person
**Who:** Services that can be delivered either way
**What:** Consultation starts virtual, continues in person
**Needs:**
- Mode selection per booking (virtual, in-person, hybrid)
- Sequential modes (virtual then in-person)
- Different pricing per mode (virtual cheaper)
- Virtual waiting room
- Seamless handoff between modes
- Same booking, multiple connection methods

**Scenario:** Therapy session: First 30 minutes virtual (video call), then client comes to office for in-person 30 minutes. One booking, two modes. Zoom link sent first, then office address. If virtual portion runs long, in-person start time adjusts automatically. Virtual portion billed at $100, in-person at $150 (premium for office space).

---

### UC-53: The Virtual Waiting Room
**Who:** Telehealth and virtual services
**What:** Queue management for virtual appointments
**Needs:**
- Check-in for virtual appointments
- Virtual queue position
- Estimated wait time
- Provider sees queue and starts next session
- Waiting room announcement capability
- Virtual "reception area"

**Scenario:** Telehealth appointment scheduled for 2pm. Patient checks in online at 1:55pm, enters virtual waiting room. Sees: "You are #2 in line. Dr. Smith is finishing with patient #1. Estimated wait: 8 minutes." Can see educational content while waiting. Doctor sees queue, clicks "Start next session," patient automatically connected.

---

### UC-54: The Anonymous/Sensitive Booking
**Who:** Services requiring privacy
**What:** Booking without revealing identity until arrival
**Needs:**
- Anonymous booking option
- Code/alias instead of name
- Verification at arrival (ID check)
- Provider doesn't see name until in-person
- Privacy protection for domestic violence survivors, celebrities
- Secure messaging without identity reveal

**Scenario:** Domestic violence shelter offers counseling. Survivor books online using code "Bluebird-472" instead of real name. Counselor sees only code on schedule. At arrival, survivor provides code and ID for verification. Real name revealed only in private session. All records use code, not real name.

---

### UC-55: The Referral Unlock Reward
**Who:** Incentivizing customer referrals
**What:** Unlock benefits by referring friends
**Needs:**
- Referral tracking (unique codes/links)
- Count successful referrals (friend booked and completed)
- Tiered rewards (3 referrals = VIP status)
- Automatic status upgrade
- Benefits: early booking, discounts, free add-ons

**Scenario:** Salon customer gets referral code. Shares with 3 friends. All 3 book and complete appointments. System detects: "3 successful referrals!" Customer automatically upgraded to "VIP" status. Benefits unlocked: can book 14 days out instead of 7, 10% discount on all services, free deep conditioning add-on. Gets congratulatory email: "You're a VIP! Enjoy your new benefits."

---

### UC-56: The Booking Transfer
**Who:** Passing appointment to someone else
**What:** Original booker can't attend, transfers to friend
**Needs:**
- Transfer link generation
- Recipient acceptance
- Liability/attendee change
- Original booker credit as thank you
- Transfer deadline (can't transfer within 24 hours)
- Transfer history

**Scenario:** Sarah books $200 cooking class but gets sick. Generates transfer link, sends to friend Emma. Emma clicks link, sees class details, accepts transfer. Booking now in Emma's name. Sarah gets $20 store credit as thank you. If Emma cancels, cancellation policy applies to Emma (not Sarah). Transfer not allowed within 24 hours of class (too late to refill).

---

### UC-57: The Impulse Booking Cooldown
**Who:** Preventing regret cancellations
**What:** Short review period before capture for high-ticket services
**Needs:**
- Booking hold period (1 hour)
- No charge during hold
- Cancel penalty-free during hold
- Reminder before hold expires
- Automatic confirmation if not cancelled
- Reduce rapid cancel/rebook churn

**Scenario:** Customer books a $500 premium photoshoot late at night. System places the booking on a 1-hour hold and sends: "Your booking is reserved. Confirm now or cancel within 1 hour at no charge." If the customer takes no action, it auto-confirms and captures payment according to policy. This reduces impulsive cancellations and repeated slot churn.

---

### UC-58: The Seasonal Availability Flip
**Who:** Seasonal businesses
**What:** Completely unavailable certain times of year
**Needs:**
- Seasonal availability blocks
- "Returns [date]" messaging (not "no availability")
- Automatic reopening on schedule
- Pre-booking for next season
- Waitlist for seasonal opening

**Scenario:** Ski instructor available December 1 - March 31. April 1 - November 30: completely unavailable (not just booked up, but professionally inactive). Calendar shows "Returns December 1" with countdown. Loyal customers can pre-book December slots starting November 1. Waitlist opens October 1 for priority access.

---

### UC-59: The Simultaneous Multi-Location
**Who:** Events needing multiple locations at once
**What:** One booking, multiple venues simultaneously
**Needs:**
- Multiple location selection
- All must be available same time
- If any unavailable, whole booking blocked
- Location-specific details
- Travel time between locations (if applicable)

**Scenario:** Corporate conference call needs meeting rooms in New York, London, and Singapore booked simultaneously for video conference. One booking, 3 locations. If London room unavailable, entire booking blocked - can't have 2/3 locations. System shows: "Available in NY and Singapore, need different time for London."

---

### UC-60: The Mandatory Follow-Up Lock
**Who:** Services requiring post-care
**What:** Follow-up appointment required, can't be cancelled independently
**Needs:**
- Auto-created follow-up appointment
- Linked to original (parent-child relationship)
- Original cancellation → follow-up auto-cancels
- Follow-up can be rescheduled but not cancelled without doctor approval
- Reminder escalation

**Scenario:** Surgery booking auto-creates 2-week follow-up. If surgery cancelled, follow-up auto-cancels. If surgery completed, follow-up is mandatory. Patient tries to cancel follow-up - gets message: "This follow-up is medically required. Call office to discuss." System tracks who didn't show for follow-up, flags for care coordinator.

---

## Summary: What These Use Cases Demand

### Must Support in Core Schema:
- Variable and fixed duration
- A "quick setup" path for basic bookings (no complex UI required)
- An "advanced mode" for layered rules and enterprise workflows
- Multiple bookable types (person, equipment, space, company)
- Households with permissions (customers AND providers)
- Products alongside services
- Packages with tracking
- Memberships with allowances
- Service-specific availability
- Commission calculations
- Favorability/ranking systems
- Complete audit trails
- Multi-org booking
- Marketplace listings
- Public/private/AI notes
- Cancellation penalties
- Dynamic pricing
- Waitlists with payment
- Prerequisites and unlocking
- Approval workflows
- Auto-booking triggers
- Overtime tracking
- Hybrid virtual/in-person
- AI-generated insights
- Tenant-specific compliance policies
- Idempotent booking actions under retries
- Manual pricing overrides by day, hour, and date range
- Call-related fee types (booking fee, phone consult fee, after-hours fee)

### Can Defer to Later:
- Complex AI/ML predictions
- Real-time video collaboration features
- White-label theming
- Multi-brand hierarchy
- Advanced marketplace auctions and bidding mechanics

---

## Part 7: New v3.0 Additions (Missing but Critical)

### UC-61: The Insurance Eligibility Re-Check
**Who:** Medical and wellness providers accepting insurance
**What:** Coverage can change between booking date and appointment date
**Needs:**
- Eligibility check at booking
- Automatic re-check before service (e.g., 72 hours prior)
- Pre-authorization tracking with expiration
- Alternate payment path if coverage fails
- Patient notification and action steps

**Scenario:** Patient books an MRI 3 weeks in advance. Insurance is valid at booking time, so request is accepted. Two days before the appointment, eligibility re-check fails because plan changed. System notifies patient and staff, opens a self-pay option, and asks patient to upload updated insurance details before appointment time.

---

### UC-62: The Split-Tender Payment
**Who:** Businesses with gift cards, wallets, and cards
**What:** One booking paid using multiple payment sources
**Needs:**
- Payment priority rules (gift card first, then wallet, then card)
- Partial authorization and capture
- Refund routing back to original sources
- Clear receipt breakdown
- Failure handling if one source declines

**Scenario:** Customer books a $180 service. They apply a $50 gift card, $30 wallet credit, and charge the remaining $100 to a credit card. Receipt shows all three components clearly. If a $40 partial refund is issued later, system applies refund according to configured policy and records each refund leg for reconciliation.

---

### UC-63: The Chargeback/Dispute Lifecycle
**Who:** Businesses processing card-not-present payments
**What:** Customer disputes payment after service
**Needs:**
- Dispute status tracking
- Evidence package assembly (timestamp, signed policy, attendance logs)
- Financial reserve/hold visibility
- Staff workflows for response deadlines
- Outcome tracking (won/lost/partial)

**Scenario:** Customer disputes a no-show fee on a missed consultation. System compiles proof: reminder delivery logs, cancellation policy acceptance at checkout, and check-in record showing absence. Staff submits evidence before processor deadline. Booking remains operationally closed while dispute state is tracked separately in finance.

---

### UC-64: The Fraud-Risk Manual Review
**Who:** High-demand or high-fraud businesses
**What:** Suspicious bookings should be reviewed before confirmation
**Needs:**
- Risk score on booking creation
- Rule-based holds (velocity, mismatched location, repeated card failures)
- Manual approve/decline queue
- Customer messaging during review
- Auto-release if risk clears

**Scenario:** New account attempts 8 high-value bookings in 10 minutes with 3 different cards. System flags the activity and places bookings into review instead of instant confirmation. Reviewer checks signals, approves one legitimate booking, declines the rest, and sends clear messaging so legitimate customers can retry safely.

---

### UC-65: The Idempotent API Retry
**Who:** Integrators and marketplaces using API/webhooks
**What:** Network retries should not create duplicate bookings
**Needs:**
- Idempotency key support
- Deterministic response replay for duplicate requests
- Safe webhook retry handling
- Duplicate prevention in payment capture
- Audit events for replayed requests

**Scenario:** Partner app times out during booking creation and retries the same request twice. Because the same idempotency key is provided, system returns the original booking instead of creating duplicates. Payment captures only once, and logs show replay detection for audit purposes.

---

### UC-66: The Offline Front Desk Mode
**Who:** Clinics and retail counters with intermittent internet
**What:** Continue check-ins and basic scheduling during outages
**Needs:**
- Local temporary queue/check-in storage
- Offline booking holds with conflict warnings
- Sync and reconciliation on reconnect
- Staff prompts for conflict resolution
- Offline action audit trail

**Scenario:** Internet drops at a busy clinic for 45 minutes. Front desk continues checking in patients locally and creates temporary holds for walk-ins. When connection returns, system syncs events, detects one time collision, and asks staff to confirm which patient keeps the slot while offering alternatives to the other.

---

### UC-67: The External Channel Sync
**Who:** Businesses listing inventory on third-party marketplaces
**What:** Availability and bookings must stay in sync across channels
**Needs:**
- Channel mapping per service/resource
- Real-time or near-real-time inventory updates
- External reservation references
- Retry queue for failed syncs
- Oversell protection policy

**Scenario:** A tour operator sells seats on direct site and two marketplace partners. A seat sold on Partner A immediately reduces capacity everywhere else. If Partner B sync call fails, system retries and temporarily tightens local availability to prevent overselling until channel consistency is restored.

---

### UC-68: The Data Residency Tenant Boundary
**Who:** Multi-tenant platforms serving regulated or regional customers
**What:** Tenant data must stay isolated and in approved regions
**Needs:**
- Tenant-level region assignment
- Strict cross-tenant isolation
- Region-aware backups and exports
- Access logs showing data location
- Admin controls for legal hold exceptions

**Scenario:** EU healthcare tenant requires all patient booking data to remain in EU region. US tenant runs separately in US region. Platform admin can view operational metrics across tenants but cannot access tenant private booking records without explicit scoped authorization and audit logging.

---

### UC-69: The Legal Blackout Window
**Who:** Industries with statutory booking constraints
**What:** Certain services need minimum notice or blackout windows
**Needs:**
- Rule engine for minimum lead times
- Date/time blackout periods
- Public explanation message when blocked
- Admin override for emergencies (with reason)
- Jurisdiction-specific configuration

**Scenario:** A notary service in one jurisdiction requires at least 24 hours notice for certain document types and blocks bookings on public holidays. Customer tries to book same-day on a restricted service and sees a clear message with nearest valid time options. Staff can override only if legal emergency criteria are met.

---

### UC-70: The Deletion vs Retention Conflict
**Who:** Regulated businesses handling privacy requests
**What:** User deletion requests may conflict with required financial/compliance retention
**Needs:**
- Request intake and verification
- Selective redaction/anonymization workflow
- Retention hold tracking for non-deletable records
- User-facing completion report
- Policy-driven timelines

**Scenario:** Customer requests deletion of account and booking history. System anonymizes profile and removes non-required personal fields, but retains legally required invoice and audit records under retention hold. Customer receives a completion report explaining what was deleted, anonymized, and retained with policy reasons.

---

## Part 8: Additional v3.0 Scenarios (Pricing, Fees, UX Coverage)

### UC-71: The Phone/Call Booking Fee
**Who:** Businesses that still take bookings by phone
**What:** Charge a call-handling fee for manual phone bookings, optionally waived
**Needs:**
- Optional phone booking fee (flat or percentage)
- Waive fee for members/VIP/customers with accessibility needs
- Separate line item on receipt
- Staff override with reason
- Different fee rules by service type

**Scenario:** A salon accepts online and phone bookings. Online bookings have no extra fee. Phone bookings add a $5 call-handling fee because staff manually process the request. VIP members and customers flagged for accessibility support are auto-waived. Front desk can also waive manually, but must choose a reason that is logged in audit history.

---

### UC-72: The Paid Discovery Call
**Who:** Consultants, legal, financial, coaching, and clinics
**What:** Short paid call before a full appointment
**Needs:**
- Bookable call service (15-30 minutes)
- Dedicated call price
- Option to credit call fee toward a full booking
- Auto-generated call link or phone instructions
- No-show and late-cancel policy for calls

**Scenario:** A business consultant offers a 20-minute paid discovery call for $40. Customer books the call and receives a meeting link. After the call, if they book a 2-hour strategy session within 7 days, the $40 call fee is automatically credited. If they no-show the call, standard no-show policy applies.

---

### UC-73: The Manual Day-and-Hour Pricing Grid
**Who:** Businesses with predictable peak periods
**What:** Prices vary by day and time using manual rules (not algorithmic surge)
**Needs:**
- Manual pricing table by weekday + time block
- Rule priority (specific rule beats default price)
- Effective date range
- Preview mode ("what will Tuesday 6pm cost?")
- Change history with who/when/why

**Scenario:** Barbershop sets weekday daytime cuts at $35, weekday evenings at $45, and Saturday slots at $55. Owner configures these values in a pricing grid once. Booking page shows the exact price per selected slot before checkout. No dynamic algorithm is involved; all changes are intentionally set by staff.

---

### UC-74: The Holiday and Special-Date Pricing Override
**Who:** Businesses with holiday demand spikes
**What:** Specific dates have fixed override pricing
**Needs:**
- Date-specific price overrides (single date or range)
- Recurring annual holiday templates
- Override reason label ("New Year's premium")
- Conflict resolution when multiple rules apply
- Customer-facing explanation text

**Scenario:** Massage studio charges $90 normally, but sets Valentine's week to $120 and Mother's Day weekend to $140. These are configured as explicit date overrides months in advance. If a weekend rule and holiday rule overlap, holiday rule takes priority. Customers see "Holiday pricing applies for this date" before payment.

---

### UC-75: The After-Hours and Emergency Callout Fee
**Who:** Home services, healthcare on-call, urgent support teams
**What:** Additional fee for same-day urgent or after-hours jobs
**Needs:**
- Time-window definitions for after-hours (e.g., 8pm-7am)
- Emergency same-day surcharge
- Separate fee line item
- Fee waivers for service contracts/plans
- Clear pre-confirmation disclosure

**Scenario:** Plumbing company charges standard daytime rate for routine jobs. For after-hours calls or emergency same-day dispatch, system adds a $75 callout fee. Customers on annual maintenance plans get this fee waived. The surcharge appears as a distinct line item during booking so there are no surprises.

---

### UC-76: The One-Page Quick Setup vs Advanced Builder
**Who:** Platform admins and small business owners
**What:** Two ways to configure the same booking engine
**Needs:**
- Quick setup wizard (service, hours, price, booking link)
- Advanced builder hidden behind explicit opt-in
- Safe defaults that produce a working booking page immediately
- Migration from quick setup to advanced without data loss
- "Complexity score" indicator so admins know when settings become advanced

**Scenario:** A solo therapist signs up and uses quick setup in under 10 minutes: sets service duration, business hours, and price, then publishes booking link. Three months later, they need different prices for evenings and holidays plus a paid intake call. They switch to advanced builder, add those rules, and keep all existing bookings and customer history intact.

---

### UC-77: The On-Site Visit Fee (Charged on Arrival)
**Who:** Plumbers, electricians, locksmiths, appliance repair, and field technicians
**What:** A guaranteed trip/diagnostic fee is charged once the provider arrives, even if no repair is performed
**Needs:**
- Clear "visit fee" policy shown before booking confirmation
- Trigger condition: provider arrival/check-in on site
- Fee charged even if customer declines service after arrival
- Optional crediting of visit fee toward completed repair invoice
- Waiver/discount rules (membership, repeat-customer goodwill, provider fault)
- Dispute workflow with photo/GPS/time evidence

**Scenario:** Customer books a plumber for a leak. The booking terms state a $95 on-site visit fee. Plumber arrives, checks in via app with timestamp and GPS, then customer says they already fixed it and no longer need service. System still charges the $95 visit fee because arrival occurred. If customer proceeds with repair, the $95 is credited toward the final invoice. If there is a dispute, staff can review arrival proof and apply a waiver if policy conditions are met.

---

### UC-78: The Walk-In Queue with Estimates (Barber Shop)
**Who:** Service businesses with walk-in customers and uncertain service times
**What:** Fixed-price services with estimated (not guaranteed) durations, managed as a queue
**Needs:**
- Queue-based system (not fixed-time appointments)
- Service time estimates (15-45 min ranges, not exact)
- Fixed pricing regardless of actual time taken
- Real-time queue position display
- Estimated wait time calculation based on queue
- Check-in system for walk-ins
- Service completion tracking (actual time vs estimate)
- Provider assignment based on queue and availability
- Price transparency upfront (no surprises based on time)

**Scenario:** Neighborhood barber shop accepts walk-ins. Customer arrives, checks in digitally: "Service: Haircut ($35), Estimated: 25 min." System shows: "3 people ahead of you, estimated wait: 45 minutes." Customer gets text when 2nd in line. Barber A is faster (avg 20 min), Barber B is slower (avg 35 min) but more detailed. Prices same regardless of which barber or how long it takes. Actual service takes 32 minutes - customer still pays $35. Queue estimates improve over time based on historical data per service and per provider.

---

### UC-79: The Government Service Queue (DMV/Office)
**Who:** Government offices, permitting counters, administrative services
**What:** Fixed-fee services with variable processing times, walk-in queue management
**Needs:**
- Ticket-based queue system (take a number)
- Service categories with different estimated times
- Fixed fees set by regulation (no dynamic pricing)
- Wait time estimates by service type
- Multi-counter support (Window 1, Window 2, etc.)
- Appointment option for complex cases (separate from walk-in queue)
- Priority handling (elderly, disabled, urgent cases)
- Service complexity detection (simple renewal vs complex case)
- Overflow handling (come back tomorrow if closing soon)

**Scenario:** DMV office offers: License renewal (est. 10 min, $35), New license (est. 25 min, $75), Title transfer (est. 40 min, $55). Customer walks in, kiosk asks service type, prints ticket: "C-47, New License, Est. wait: 55 min." System knows 2 of 4 counters handle new licenses, tracks their current customers' progress. Counter 2 finishes early, calls "C-47 to Window 2." Customer's actual processing takes 35 min due to missing document - they must return tomorrow, but fee was already fixed at $75 regardless of outcome.

---

### UC-80: The Fixed-Price Variable-Time Service (Car Wash)
**Who:** Car washes, detailing services, quick-lube shops
**What:** Service packages with fixed prices but duration varies by vehicle condition
**Needs:**
- Fixed-price service tiers (Basic $15, Deluxe $35, Premium $65)
- Variable time based on vehicle size and dirtiness
- Queue position with range estimates ("25-40 min")
- Vehicle type input (sedan vs SUV vs truck)
- Express lane for simple cases
- Add-on services that extend time but not base price confusion
- Throughput tracking (cars per hour)
- Re-queue capability if quality check fails

**Scenario:** Car wash has three packages. Customer selects Deluxe ($35) for their muddy SUV. System estimates 30-45 minutes based on: package type + vehicle size + current queue. Basic sedans ahead in line will take 10-15 min each. After 42 minutes, wash completes but quality check spots missed spots - car goes back through part of line (no extra charge). Final price remains $35 even though service took 55 minutes total. Customer who arrived later in a clean compact gets Basic wash and is done in 8 minutes - also pays fixed price.

---

### UC-81: The Host-Dependent and Complexity-Based Duration
**Who:** Services where provider skill and case complexity drastically affect time
**What:** Same service, different actual durations based on who performs it and what they encounter
**Needs:**
- Provider-specific time estimates (experienced vs trainee)
- Complexity assessment (simple, standard, complex)
- Fixed pricing despite variable effort
- Host assignment based on case complexity
- Time tracking per provider per service type
- Learning system (improve estimates based on actuals)
- Escalation path (junior hits complex case, senior takes over)
- Customer communication about potential extended time

**Scenario:** Dental cleaning service: Fixed price $120. Junior hygienist averages 45 min, senior averages 30 min. Patient with heavy tartar buildup flagged as "likely complex" - system assigns senior hygienist and estimates 35-45 min. Mid-procedure, senior discovers unexpected issue requiring 20 extra minutes. Price remains $120. System logs: "Senior hygienist, complex cleaning, actual: 52 min" to improve future estimates. Different patient with light buildup gets junior, done in 38 min, same $120 price.

---

## Summary Update: Queue-Based Patterns (UC-78 through UC-81)

These four use cases introduce a distinct booking pattern: **fixed price, variable time, queue management** rather than fixed-time slot booking.

Key requirements this adds:
- Queue position tracking (not calendar slots)
- Estimated wait times with ranges (not exact appointment times)
- Time estimation per service + per provider learning
- Walk-in check-in flow alongside (or instead of) appointment booking
- Fixed pricing guarantee regardless of actual duration
- Service complexity detection affecting queue assignment
- Historical actual-time tracking to improve estimates

## Part 9: Transportation & Vehicle Services

### UC-82: The Scheduled Shuttle Service (Airport/Route-Based)
**Who:** Airport shuttles, corporate commuter shuttles, intercity buses
**What:** Fixed-route transportation with scheduled departure times and capacity limits
**Needs:**
- Route definition with stops (Airport → Hotel Zone → Downtown)
- Scheduled departure times (not on-demand)
- Per-route capacity limits (14 passengers per van)
- Stop-by-stop availability (seats may be available from Airport but not Hotel Zone)
- Luggage quantity and size tracking
- Real-time vehicle tracking for passengers
- Waitlist when route is full
- Group bookings (family of 4 wants to sit together)
- Dynamic routing for traffic/road closures

**Scenario:** Airport shuttle runs every 30 minutes from 5am to midnight. Route: Airport Terminal 3 → Terminal 1 → Business District → Convention Center → Hotels. Customer books 2pm departure from Terminal 1. System shows: "8 seats available from Terminal 1, 12 seats available from Airport." Passenger has 3 large suitcases - system notes "requires luggage space" and reserves back row. Real-time tracking shows van running 10 min late due to traffic. 14-seat capacity reached at Terminal 1, but someone cancels - waitlisted passenger gets notified and books.

---

### UC-83: The On-Demand Shuttle (Zone-Based Pickup)
**Who:** Corporate campus shuttles, hotel area shuttles, university transport
**What:** Request-based pickup within defined zones, not fixed schedule
**Needs:**
- Zone-based service area (map-defined)
- Request-triggered routing (nearest available vehicle)
- Estimated pickup time (5-12 minutes)
- Real-time ETA updates
- Multiple passenger pooling (shared ride)
- Capacity tracking (standing room vs seated only)
- Priority levels (executive vs standard)
- Recurring ride requests (daily commute pickup)

**Scenario:** Tech campus has 5 shuttles circulating between buildings. Employee requests pickup from Building C to Building H. System assigns nearest shuttle (2 min away) with 3 seats available. ETA: 4 minutes. Another employee requests same route - pooled, ETA updates to 6 minutes for both. Shuttle arrives, both board. Driver confirms passenger count. Different employee has "executive" status - their requests get priority assignment even if farther from a shuttle.

---

### UC-84: The Limo/Black Car Service (Scheduled by Time)
**Who:** Executive car services, luxury transportation, special occasion limos
**What:** Premium vehicle booking with specific pickup time and duration
**Needs:**
- Vehicle type selection (sedan, SUV, stretch limo, party bus)
- Exact pickup time reservation (not a window)
- Duration-based pricing (minimum 3 hours for limo)
- Special occasion packages (wedding, prom, bachelor party)
- Stops/multiple destinations allowed
- Chauffeur assignment and tracking
- Vehicle amenity selection (champagne, decorations)
- Late night/early morning surcharges
- Gratuity auto-calculation and distribution

**Scenario:** Wedding party books 6-hour stretch limo package for $800. Pickup: 2pm at bride's house. Destinations: hair salon (3pm-4:30pm), photo location (5pm-6pm), ceremony (6:30pm), reception (7pm). System calculates route time between stops, adds buffer. Champagne and decorations included. Driver assigned 48 hours before, vehicle prepped day-of. Gratuity auto-calculated at 20% ($160) distributed to chauffeur after completion.

---

### UC-85: The Limo Service (Point-to-Point Transfer)
**Who:** Airport transfers, corporate client pickup, event transportation
**What:** One-way or round-trip fixed-route premium transport
**Needs:**
- Origin and destination addresses
- Flight tracking integration (airport pickups)
- "Meet and greet" service option
- Luggage capacity per vehicle type
- Waiting time policy (15 min included, then hourly)
- Child seat availability
- Accessibility vehicle option
- Multi-passenger pricing (same car, multiple people)
- Real-time driver location sharing

**Scenario:** Executive books airport transfer from JFK to Manhattan office. Enters flight number AA1234. System tracks flight - arrival delayed 45 minutes. Driver automatically adjusts pickup time, monitors actual landing. Meet-and-greet: driver waits at baggage claim with name sign. First 15 min waiting included. If executive delayed at customs (25 min), additional $25 charge applies. Driver has child seat available (requested in booking). Real-time location shared with executive's assistant.

---

### UC-86: The Charter Bus/Group Transportation
**Who:** Event planners, schools, corporate outings, wedding parties
**What:** Large group vehicle booking for specific date and itinerary
**Needs:**
- Group size input (determines bus size: 25, 35, 55 passenger)
- Multi-stop itinerary builder
- Driver rest/break time regulations
- Parking and toll calculations
- Overnight driver accommodation (for multi-day)
- Quote request before booking (not instant book)
- Deposit structure (50% to hold, 50% before trip)
- Cancellation tiers (90 days out = full refund, 30 days = 50%)
- Damage/cleaning deposit hold

**Scenario:** Company plans team-building trip for 45 employees. Requests quote: pickup 8am from office, 2-hour drive to mountain resort, return 6pm. System quotes: 55-passenger coach, $1,200 + $150 driver gratuity + $45 tolls. Quote valid 7 days. Company accepts, pays $600 deposit. One week before, pays remaining $795. Day of trip, driver follows itinerary, mandatory 30-min break at 10:30am per DOT regulations. Minor cleaning required post-trip (food spill), $75 cleaning fee deducted from $200 damage deposit, $125 returned.

---

## Part 10: Rental & Equipment Services

### UC-87: The Tool Rental (Home Depot Style)
**Who:** Hardware stores, equipment rental companies, DIY centers
**What:** Physical items rented by hour, day, or week with deposit and return requirements
**Needs:**
- Rental duration options (4-hour, daily, weekly rates)
- Inventory availability by location
- Equipment condition documentation (photos at pickup)
- Damage protection/waiver options
- Security deposit hold (released on return)
- Late return fees (hourly after due time)
- Cleaning fee if returned dirty
- Fuel/charge level requirements (return full/charged)
- Extension requests (if no one waiting)
- Accessory add-ons (drill bits, safety gear)

**Scenario:** Homeowner rents pressure washer for 24 hours at $75/day. $200 security deposit held on card. Pickup: Saturday 9am, due back Sunday 9am. Photos document pre-existing scratches. Damage waiver declined. Returns Sunday 11am (2 hours late) - $20 late fee applies. Gas tank half-empty - $15 refueling fee. Minor cleaning needed - $10 cleaning fee. Total: $75 + $20 + $15 + $10 = $120. Security deposit released. If equipment damaged during rental, repair cost deducted from deposit with photo evidence.

---

### UC-88: The Party/Event Equipment Rental
**Who:** Party supply companies, event rental services, wedding suppliers
**What:** Tables, chairs, tents, linens, dishware rented for events with setup/breakdown
**Needs:**
- Delivery and pickup scheduling (not customer pickup)
- Setup and breakdown service option
- Event date vs rental period (rent Friday-Monday for Saturday event)
- Quantity-based availability (need 20 tables, have 18 available)
- Package deals (wedding package: tent + tables + chairs + linens)
- Weather contingency (tent sidewalls if rain forecast)
- Damage waiver for linens/dishware
- Last-minute availability (48-hour window)
- Venue coordination (delivery window restrictions)

**Scenario:** Wedding planner books for Saturday event: 150 chairs, 20 tables, tent, linens, dishware. Rental period: Friday delivery/setup to Sunday breakdown/pickup. Venue restricts delivery to 10am-2pm Friday. Setup service adds $300. Weather shows 60% rain - adds tent sidewalls ($150). Package pricing saves $200 vs individual items. Damage waiver for dishware ($75) covers accidental breakage. One week before, couple wants 10 more chairs - only 8 available, suggests 2 benches as alternative.

---

### UC-89: The Vehicle Rental (Car/Truck/Van)
**Who:** Traditional rental companies, peer-to-peer car sharing, moving truck rentals
**What:** Self-drive vehicle rental by day or week
**Needs:**
- Vehicle category selection (compact, SUV, truck, van)
- Pickup and return location (different locations allowed)
- Mileage limits and overage charges
- Insurance options (decline, basic, premium)
- Driver verification (license, age requirements)
- Fuel policy (return full or prepay)
- Additional driver authorization
- Child seat/GPS add-ons
- Late return grace period (29 minutes free)
- One-way rental pricing (drop at different location)

**Scenario:** Customer rents moving truck for 3 days at $120/day + $0.79/mile. Pickup at downtown location, return at suburban location (one-way). Insurance selected: premium ($35/day) with $0 deductible. Driver uploads license photo for verification. Prepaid fuel option declined - will return full. Day 2 realizes need extends to 4th day - calls to extend, rate remains same if available. Returns 45 minutes late - charged additional 1 day because past grace period. 312 miles driven = $246.24 mileage. Total: ($120 × 4) + ($35 × 4) + $246.24 = $866.24.

---

### UC-90: The Peer-to-Peer Equipment Rental (Fat Llama Style)
**Who:** Individuals renting personal equipment to others, camera gear, drones, tools
**What:** Owner-listed items with availability calendar and pickup coordination
**Needs:**
- Owner-managed availability calendar
- Item condition photos and description
- Security deposit and verification level
- Handoff method (pickup, delivery, locker)
- Rental request approval (owner can decline)
- Late return mediation
- Damage claim process with evidence
- Owner rating and reliability score
- Insurance/integration with platform policy

**Scenario:** Photographer lists professional camera kit for rent at $85/day. Sets availability: weekends only, not available Dec 24-25. Renter requests Dec 10-12 (3 days). Owner approves after viewing renter's verification (ID + 5 positive past rentals). Handoff: owner meets at coffee shop for exchange, photos condition. Renter returns Dec 12 evening. Minor scuff discovered on lens body - owner submits claim with before/after photos. Platform mediates, determines normal wear vs damage, reimburses owner $50 from deposit. Renter and owner rate each other.

---

## Part 11: Virtual & Remote Services

### UC-91: The Virtual Consultation Service
**Who:** Telehealth, online therapy, virtual legal consults, remote coaching
**What:** Scheduled video/audio sessions with pre-session requirements
**Needs:**
- Video platform integration (Zoom, Teams, custom)
- Pre-session intake forms/questionnaires
- File upload for review (medical records, documents)
- Technology check (test camera/mic beforehand)
- Waiting room with queue position
- Session timer with warnings (5 min remaining)
- Recording option (with consent)
- Post-session follow-up tasks
- No-show policy (charge if tech issues vs true no-show)

**Scenario:** Patient books 30-min telehealth appointment. Receives link 24 hours before. System prompts to upload photos of rash and complete symptom questionnaire 2 hours before. Patient joins waiting room 5 min early, sees "Doctor will see you soon." Doctor running 10 min late - waiting room shows updated ETA. Session starts, 25-min timer visible. Doctor shares screen, reviews uploaded photos. With 5 min left, both see warning. Doctor assigns prescription delivery task post-session. Patient had camera issues - tech support resolved in 3 min, not charged as no-show.

---

### UC-92: The Async Virtual Service (Review & Response)
**Who:** Proofreading, design review, code review, legal document review
**What:** Not real-time - customer submits work, provider reviews and responds by deadline
**Needs:**
- File submission with format requirements
- Turnaround time selection (24hr, 3-day, 1-week pricing tiers)
- Word/page count pricing
- Provider availability calendar (when can they deliver)
- Progress status updates (received, in review, complete)
- Deliverable return (annotated document, video feedback)
- Revision rounds included or add-on
- Rush delivery option (12-hour for extra fee)
- Quality dispute and revision request

**Scenario:** Student submits 15-page essay for proofreading. Selects 3-day turnaround at $5/page = $75. System confirms provider available to deliver by Friday 5pm. File uploaded, word count verified. Provider receives notification, starts work. Status updates: "In review" within 6 hours. Completed Friday 3pm - annotated document with track changes returned. Student reviews, requests one revision round (included) for unclear section. Provider responds within 24 hours with additional notes. If student needed it faster, 24-hour option was $8/page ($120).

---

### UC-93: The Live Virtual Class/Workshop
**Who:** Online education, fitness classes, cooking workshops, art instruction
**What:** Scheduled group session with live instructor, interactive elements
**Needs:**
- Class capacity limits (max 20 for interaction)
- Minimum to run (cancel if under 5)
- Waitlist with auto-promote
- Pre-class materials (ingredient list, supply checklist)
- Recording access for limited time post-class
- Breakout room capability (pair/group work)
- Participation tracking (attended, completed)
- Multi-session series (Week 1, Week 2, Week 3)
- Skill level filtering (beginner, intermediate, advanced)

**Scenario:** Cooking school offers "French Pastry Basics" live class, max 12 students, $45. Registration open until 2 hours before. Only 4 sign up by T-2hr - class cancelled, refunds issued. Next week's class: 15 sign up, 3 on waitlist. Ingredient list sent 48 hours before (butter, flour, eggs, etc.). Class starts, instructor demonstrates, students cook along. Breakout rooms for 10 min to share results. Recording available for 7 days post-class. Attendance tracked for "complete 5 classes, get 6th free" loyalty program.

---

### UC-94: The Virtual Office/Meeting Room
**Who:** Coworking spaces, virtual office providers, conference room booking
**What:** Book virtual meeting rooms or temporary virtual office presence
**Needs:**
- Virtual room capacity and features (breakout rooms, whiteboard, recording)
- Time zone handling for global teams
- Recurring meeting room (every Monday 10am)
- Persistent room (same link all month)
- Room customization (branding, waiting room settings)
- Technical support availability during booking
- Usage analytics (attendance, duration)
- Integration with calendar systems
- Security options (password, waiting room, registration)

**Scenario:** Startup books virtual board room for monthly investor meetings. Persistent room with company branding, password protected. 12-person capacity, breakout rooms enabled, recording to cloud. Same link every month for consistency. Admin can customize waiting room message. Usage reports show: average 8 attendees, 90-min meetings, 2 no-shows last quarter. Time zone smart scheduling: shows "10am EST / 7am PST / 4pm CET" to all invitees.

---

### UC-95: The Virtual Fitness Class Subscription
**Who:** Boutique fitness studios, yoga instructors, personal trainers online
**What:** Live classes with subscription or drop-in pricing, personal training credits
**Needs:**
- Class schedule with multiple daily options
- Drop-in vs membership pricing ($20 vs $150/month unlimited)
- Equipment requirements (mat, weights, bands)
- Difficulty level indication
- Camera on/off policy
- Playlist/music integration
- Calorie/effort tracking integration
- Personal training booking add-on
- Freeze membership option

**Scenario:** Yoga studio offers: $18 drop-in or $139/month unlimited live classes. Member sees weekly schedule: 6am Sunrise Flow, 12pm Lunch Express, 6pm Power Yoga, 8pm Restorative. Equipment notes: "Bring mat, optional blocks." Camera-optional - instructor sees attendee count but not faces unless enabled. Member attends 12 classes/month - effective $11.58/class. Can book 1-on-1 private session for $85/hour. Goes on vacation for 2 weeks, freezes membership (no charge, holds spot).

---

## Part 12: Physical & Virtual Classrooms

### UC-96: The Classroom/Lab Booking (University/Corporate)
**Who:** Universities, training centers, corporate campuses
**What:** Bookable rooms with specific equipment and capacity for classes or events
**Needs:**
- Room capacity and layout (theater, classroom, lab stations)
- Equipment requirements (projector, whiteboard, lab equipment)
- Recurring semester booking (MWF 10am-11:30am)
- Priority booking windows (registrar books first, then faculty, then students)
- Conflict detection with academic calendar
- Setup/breakdown time buffers
- Catering integration for long sessions
- Accessibility features (hearing loop, wheelchair access)
- After-hours access request

**Scenario:** Professor requests Room 302 for Spring semester: Monday/Wednesday 2pm-3:30pm. System checks: room has 40 seats, projector, lab stations (matches course needs). Registrar priority window open, request approved. Academic calendar shows Spring Break March 10-14 - automatically excluded. 15-min buffer before/after for setup. One session needs extended to 5pm - separate approval for after-hours building access. Catering ordered for final session celebration. Room shows as booked in campus system, students see location.

---

### UC-97: The Training Room (Corporate)
**Who:** Corporate L&D departments, external training providers
**What:** Professional development space with specific training technology
**Needs:**
- Room features (video conferencing, recording, flip charts)
- Capacity with different layouts (u-shape, classroom, boardroom)
- Catering/lunch options
- Multi-day booking with overnight storage
- External trainer access (badging, parking)
- AV technical support booking
- Material printing/distribution services
- Evaluation form distribution post-training
- CPE/CEU credit tracking for attendees

**Scenario:** Company books Training Room A for 3-day leadership workshop. 20 participants, u-shape layout. Day 1: 9am-5pm with lunch. AV support booked for 8:30am setup. External facilitator needs visitor badge and parking pass. Materials printed and placed at seats. Recording for absentees. Day 3 evaluation forms auto-sent post-session. Attendees receive completion certificates with CPE credits. Room reconfigured to classroom layout for next day's different workshop.

---

### UC-98: The Virtual Classroom (K-12/Higher Ed)
**Who:** Online schools, universities with remote programs
**What:** Scheduled online learning sessions with student management
**Needs:**
- Enrollment-based roster (registered students auto-admitted)
- Attendance tracking and participation scoring
- Breakout room assignment (random or predetermined groups)
- Assignment submission during/after class
- Gradebook integration
- Office hours booking (1-on-1 slots)
- Recording auto-posted to learning management system
- Accessibility compliance (captions, screen reader)
- Parent/guardian observer access (K-12)

**Scenario:** Online high school algebra class meets Tuesday/Thursday 10am. 28 students enrolled, roster syncs from SIS. Students auto-admitted from waiting room. Teacher takes attendance via participation check. Random breakout rooms of 4 for problem-solving. One group struggles - teacher joins to help. Assignment due end of class submitted via integrated form. Recording posted to LMS within 1 hour. Parent portal shows attendance and participation score. Student books office hours for Friday 2pm for extra help.

---

### UC-99: The Virtual Workshop Room (Interactive)
**Who:** Workshop facilitators, design sprints, collaborative training
**What:** Highly interactive virtual space with collaborative tools
**Needs:**
- Collaborative whiteboards (Miro, FigJam integration)
- Multiple screen sharing simultaneously
- Polls and quizzes in-session
- Digital "sticky notes" and voting
- Small group rooms with shared workspaces
- Workshop timer visible to all
- Output export (boards, notes, decisions)
- Participant engagement scoring
- Template loading (sprint templates, workshop frameworks)

**Scenario:** Design sprint facilitator books virtual workshop room for 5-day sprint. 8 participants. Day 1: loads "Design Sprint Template" with pre-set whiteboard, timers, sticky note colors. Participants use digital sticky notes for ideation. Voting via dot-voting feature. Breakout rooms for pairs to sketch. All work persists on shared board. End of week: export all boards to PDF for client. Engagement report shows: 95% camera-on time, all participated in voting, 2 participants dominated speaking time (feedback for facilitator).

---

### UC-100: The Exam/Proctored Session
**Who:** Certification bodies, universities, professional licensing
**What:** High-stakes assessment with identity verification and anti-cheating measures
**Needs:**
- Identity verification (ID upload, facial recognition)
- Secure browser lockdown
- Live proctor monitoring or AI proctoring
- Room scan requirement (360 camera view)
- Scheduled start time with check-in window
- Accommodations management (extra time, breaks)
- Technical issue protocol (lost connection)
- Results delivery timeline
- Appeal/retake scheduling

**Scenario:** Professional certification exam scheduled for Saturday 9am. Candidate checks in 15 min early: ID verification, facial match, room scan showing clear desk. Secure browser launches, blocks other applications. 3-hour exam with one 10-min break (proctor monitors exit and return). AI proctoring flags if candidate looks away too long. Connection lost at 2 hours - candidate rejoins, proctor verifies identity again, time paused during outage. Results available in 5 business days. Candidate fails by 2 points, appeals, schedules retake in 30 days.

---

### UC-101: The Hybrid Classroom (In-Person + Remote)
**Who:** Universities, corporate training with distributed teams
**What:** Simultaneous in-person and virtual attendance with equal participation
**Needs:**
- In-person capacity + unlimited (or capped) virtual
- Classroom camera/mic setup for remote visibility
- Remote participant visibility on classroom screen
- Hybrid participation parity (remote can ask questions, vote)
- Recording for asynchronous viewers
- Switch modality (in-person to remote if sick)
- Equipment check for classroom tech
- Teaching assistant monitoring remote chat

**Scenario:** Graduate seminar: 15 in-person seats + 10 virtual slots. Professor in classroom with camera showing professor and whiteboard. Remote students on 55" screen visible to class. Hand-raising works both ways. Polls include all participants. One in-person student feels ill Wednesday morning - switches to virtual, seat opens for waitlist. Recording available for students in other time zones. TA monitors chat for remote questions professor might miss. Breakout groups: 3 in-person pairs + 2 virtual pairs.

---

### UC-102: The Pop-Up/Temporarily Bookable Space
**Who:** Community centers, churches, vacant retail, outdoor spaces
**What:** Space not normally bookable but available for specific dates/events
**Needs:**
- Limited date availability (only specific weekends)
- Event type restrictions (no alcohol, noise curfew)
- Insurance requirement verification
- Setup/teardown time included or added
- Power/catering/water access notes
- Permit assistance (if required)
- Weather contingency (outdoor spaces)
- Damage/cleaning bond

**Scenario:** Community center gym available for rent Saturdays 2pm-10pm only. Event planner books for charity gala. Insurance certificate required 2 weeks before. Setup starts 2pm, event 6pm-10pm, cleanup by midnight included. Kitchen access available, no alcohol per policy. 200-person capacity. $500 damage deposit held. Outdoor portion has tent weather backup option. One month before, center cancels due to unexpected maintenance - full refund including deposit.

---

## Part 13: Additional Service Patterns

### UC-103: The Subscription Box with Appointment
**Who:** Meal kits, wine clubs, beauty boxes with scheduled consultations
**What:** Physical product subscription plus periodic virtual/in-person consultations
**Needs:**
- Subscription management (pause, skip, frequency)
- Consultation booking included (monthly check-in)
- Preference learning affecting box contents
- Consultation prep (review past boxes, feedback)
- Expert matching (nutritionist, stylist)
- Box delivery coordination with consultation
- Progress tracking over time
- Upgrade/downgrade tiers

**Scenario:** Meal kit subscriber gets monthly 30-min nutritionist consultation included. System schedules based on subscriber preference (Tuesday evenings). Nutritionist reviews past month's meal choices, weight goals, feedback. Adjusts next box contents. Subscriber can book extra consultations à la carte ($40). Skipped consultation doesn't roll over - use it or lose it. After 3 months, subscriber upgrades to weekly box + bi-weekly consultations.

---

### UC-104: The Membership with Included Services
**Who:** Gyms, spas, coworking spaces with monthly credits
**What:** Fixed monthly fee includes bookable services or credits
**Needs:**
- Monthly credit allowance (4 massage credits/month)
- Credit rollover or expire (use or lose)
- Guest privileges (bring friend once/month)
- Peak vs off-peak booking windows
- Upgrade for additional credits
- Credit usage tracking
- Freeze membership (keep credits, pause billing)
- Priority booking (members book before public)

**Scenario:** Spa membership: $199/month includes 4 service credits (any 60-min service), 10% off additional services. Credits expire month-end (no rollover). Member books monthly facial using credit. Tries to book 5th service - charged member rate with 10% discount. Can freeze for up to 3 months (travel) - credits on hold, no new credits accrue. Members get 7-day advance booking vs 3-day for non-members. Guest pass once/month lets friend use member's credit.

---

### UC-105: The Field Service with Parts Ordering
**Who:** Appliance repair, HVAC, garage door services
**What:** Diagnosis visit plus follow-up with parts installation
**Needs:**
- Initial diagnostic appointment
- Parts ordering with ETA
- Follow-up appointment scheduling
- Multi-visit coordination
- Parts deposit if special order
- Warranty tracking on parts and labor
- Service contract integration (parts covered)
- Temporary equipment loan during repair

**Scenario:** Refrigerator not cooling. Technician visit 1 ($95 diagnostic): determines compressor failure. Part costs $280, 3-day shipping. Customer pays $95 + $280 parts deposit. Part arrives, system auto-schedules installation visit. Visit 2: installation (1 hour), labor $150. Total: $525. Part under 1-year warranty, labor under 90-day warranty. Service contract customer: diagnostic free, part covered, pays only labor ($150). Loaner mini-fridge offered during repair.

---

### UC-106: The Curated Experience/Itinerary
**Who:** Travel planners, concierge services, day-trip organizers
**What:** Multi-stop experience with timing coordination
**Needs:**
- Itinerary builder with time estimates
- Multi-vendor coordination (restaurant + activity + transport)
- Backup options if one vendor cancels
- Real-time itinerary updates
- Group coordination (split payments)
- Dietary/restriction tracking across stops
- Weather-dependent alternatives
- Local guide assignment
- Post-experience photo sharing

**Scenario:** Food tour of Little Italy: 4 stops, 3 hours. Stop 1: appetizer at Bistro (2:00pm), Stop 2: pasta making class (2:45pm), Stop 3: gelato tasting (4:00pm), Stop 4: espresso at Cafe (4:30pm). System coordinates timing between venues. Group of 6 friends book, one pays, others pay share via split. Guide assigned. Itinerary updates: Bistro running 15 min late, all stops adjust. Dietary restrictions noted: 1 vegetarian, 1 gluten-free - all venues notified. Rains during tour - backup indoor route activated. Photos shared to group album post-tour.

---

## Summary: Part 9-13 Additions

This expansion adds **25 new use cases** (UC-82 through UC-106) covering:

**Transportation & Vehicle Services (UC-82-86):**
- Shuttle services (scheduled routes and on-demand zones)
- Limo/black car (scheduled and point-to-point)
- Charter bus/group transportation

**Rental & Equipment Services (UC-87-90):**
- Tool/equipment rental with deposits
- Party/event equipment rental
- Vehicle rental with mileage
- Peer-to-peer equipment rental

**Virtual & Remote Services (UC-91-95):**
- Virtual consultations
- Async virtual services
- Live virtual classes/workshops
- Virtual meeting rooms
- Virtual fitness subscriptions

**Physical & Virtual Classrooms (UC-96-102):**
- University classroom/lab booking
- Corporate training rooms
- Virtual K-12/higher ed classrooms
- Interactive workshop rooms
- Proctored exams
- Hybrid classrooms
- Pop-up/temporary spaces

**Additional Service Patterns (UC-103-106):**
- Subscription boxes with consultations
- Membership with included credits
- Field service with parts ordering
- Curated multi-stop experiences

---

## Part 14: Platform-Specific Patterns from Competitive Research

Based on analysis of Calendly, Acuity Scheduling, SimplyBook.me, Square Appointments, and Mindbody.

### UC-107: The One-Off Ad-Hoc Meeting
**Who:** Professionals who occasionally need to schedule without creating a permanent event type
**What:** Quick booking link for a single meeting without saving the configuration
**Needs:**
- Temporary booking page that expires after meeting
- No permanent event type clutter
- Suggest times based on integrated calendar availability
- Copy link to share via any channel
- Auto-deletes 24 hours after scheduled meeting
- No need to name or categorize the meeting type

**Scenario:** Consultant gets unexpected call from prospect. Needs to schedule follow-up call tomorrow but doesn't want to create permanent "Prospect Call" event type. Opens app, selects "One-off meeting," chooses 30-min duration. System generates temporary link: biz.ing/abc123-expires-24h. Sends to prospect, they book 10am tomorrow. Link automatically expires after meeting completes.

---

### UC-108: The Substitution Finder (Auto-Replacement)
**Who:** Fitness studios, salons, clinics with regular providers who get sick
**What:** Automatically find and assign replacement when scheduled provider can't work
**Needs:**
- Staff availability database with skills/certifications
- Automatic notification to qualified substitutes when cancellation occurs
- Acceptance workflow (sub can accept/decline)
- Client notification with new provider details
- Substitution history tracking
- Fair distribution algorithm (don't always ask the same person)
- Emergency override (manager can force assignment)

**Scenario:** Yoga studio's 6pm Vinyasa instructor calls in sick at 3pm. System checks: which instructors are certified in Vinyasa and available 5:30-7:30pm? Finds 3 qualified. Sends push notification to all 3: "Vinyasa class needs coverage tonight - $25 bonus pay." Sarah accepts within 5 minutes. System automatically: updates class roster, sends text to all 12 registered students "Instructor change: Sarah will be teaching tonight's 6pm Vinyasa," updates instructor payroll for bonus. Manager sees substitution log for fairness tracking.

---

### UC-109: The Reserve with Google Integration
**Who:** Local service businesses wanting visibility in Google Search/Maps
**What:** Customers book directly from Google Business Profile without visiting business website
**Needs:**
- Google Business Profile connection and verification
- Real-time availability sync to Google
- Service menu displayed on Google
- Booking completion within Google interface
- Google handles initial booking data capture
- Sync back to main booking system
- Review collection through Google
- Insights on Google-driven bookings

**Scenario:** Hair salon has Google Business Profile. User searches "haircut near me," sees salon with 4.5★ and "Book" button. Clicks book, sees available times this week, selects Friday 3pm without leaving Google. Google collects name/phone, sends to salon's booking system. Salon sees booking tagged "Source: Google." Customer gets confirmation from both Google and salon. After appointment, Google requests review, boosting salon's local SEO ranking.

---

### UC-110: The QR Code Check-In/Booking
**Who:** Event venues, classes, workshops wanting touchless entry
**What:** Digital tickets via QR codes for scanning at entry
**Needs:**
- QR code generation for each booking
- Digital ticket sent to client email/app
- QR code scanning via phone camera or dedicated scanner
- Check-in tracking (who arrived, when)
- No-show identification
- Walk-up QR booking (scan to see availability and book on spot)
- Dynamic QR codes that update if details change
- Offline scanning capability

**Scenario:** Conference attendee receives email with QR code ticket. Arrives at venue, staff scans code with tablet - beep, green checkmark, "John Smith, VIP Pass, Day 2" displays. System marks John as checked in, updates attendance dashboard in real-time. Organizer sees 85% check-in rate vs registrations. At networking reception, QR code on table links to "Scan to book tomorrow's workshops" - attendees scan, see remaining spots, book instantly. No paper tickets, no lines.

---

### UC-111: The Strategic Availability Hiding ("Look Busy")
**Who:** Consultants, therapists, high-demand professionals managing perception
**What:** Automatically hide some availability to appear more in-demand or control workload
**Needs:**
- Algorithm that hides 20-40% of actual open slots
- Never hide slots within 48 hours (still fill urgent needs)
- Randomize which slots hidden to avoid patterns
- Override option for preferred clients (show them full availability)
- Seasonal adjustment (hide less during slow periods)
- Emergency "show all" toggle for when need to fill schedule
- Analytics on booking rate with vs without hiding

**Scenario:** Executive coach sets "Look Busy" feature at 30% hiding. Calendar shows 10 slots/week instead of actual 14. Prospects see limited availability, perceive high demand, book faster. Coach still has flexibility for preferred corporate client who sees full availability via private link. During December (slow season), coach reduces hiding to 10%. Analytics show 40% higher booking conversion with hiding enabled - scarcity perception drives action.

---

### UC-112: The Video Conferencing Auto-Generation
**Who:** Remote consultants, telehealth providers, virtual coaches
**What:** Automatic creation of unique video meeting links for each appointment
**Needs:**
- Zoom, Google Meet, Teams integration
- Automatic link generation at booking confirmation
- Unique link per meeting (security)
- Link added to calendar invite and email
- Waiting room enabled by default
- Alternative link if primary fails
- Recording option (if enabled)
- Auto-start settings (host must join first)

**Scenario:** Therapist has Telehealth session type configured with Zoom integration. Client books Wednesday 2pm. System automatically creates unique Zoom meeting room, generates link, includes in confirmation email: "Join Zoom Meeting: https://zoom.us/j/123456789". Link added to both therapist's and client's Google Calendar. Wednesday 2pm, therapist clicks link, starts session, admits client from waiting room. Session automatically recorded to cloud (with consent). Link expires after meeting, never reused.

---

### UC-113: The ClassPass Integration
**Who:** Fitness studios wanting additional client acquisition channel
**What:** ClassPass members can book studio classes through ClassPass app
**Needs:**
- ClassPass partner account setup
- Real-time availability sync to ClassPass
- Class credit pricing (lower than direct, but volume)
- ClassPass member validation
- Attendance tracking separate from direct bookings
- ClassPass payout reconciliation
- Capacity allocation (reserve X spots for ClassPass)
- No-show handling different from direct bookings

**Scenario:** Yoga studio allocates 5 of 20 spots per class to ClassPass. ClassPass member finds class in ClassPass app, books using ClassPass credits. Studio sees booking tagged "ClassPass - Sarah M." Attendance marked in both systems. ClassPass pays studio $12 (vs $25 direct price), but Sarah is new client who might convert to member. After 3 visits, studio offers Sarah "First month 50% off" to convert to direct member. ClassPass analytics show 15% conversion rate to direct membership.

---

### UC-114: The Social Media Booking (Instagram/Facebook)
**Who:** Businesses with strong social media presence
**What:** Customers book directly from Instagram bio link or Facebook page
**Needs:**
- Instagram Business account with booking integration
- "Book Now" button on Facebook page
- Mini booking interface within Instagram/Facebook
- Service selection and time picking without leaving app
- Mobile-optimized flow
- Instagram bio link integration
- Story stickers with booking links
- Facebook Messenger booking option
- Track bookings by source (Instagram vs Facebook vs website)

**Scenario:** Brow artist posts transformation reel on Instagram. Follower sees results, clicks "Book" button in bio. Mini-booking interface opens in Instagram browser, shows available microblading slots. Follower books Saturday 10am, pays $50 deposit, all without leaving Instagram. Artist sees booking tagged "Source: Instagram." After appointment, satisfied client shares results on Instagram story with booking link sticker, driving more bookings from followers. 40% of artist's bookings now come directly from Instagram.

---

### UC-115: The Gift Booking / Gift Voucher
**Who:** Salons, spas, clinics, tutors, and experience businesses
**What:** One person buys now, another person books later
**Needs:**
- Gift code/token generation at purchase
- Recipient redemption flow
- Partial value tracking across multiple bookings
- Expiration and extension policy
- Transfer/revoke controls
- Clear balance and history on each redemption

**Scenario:** Emma buys a $200 massage gift card for her sister. Sister redeems $120 for a 90-minute session and keeps $80 balance for later. If balance is not used before expiry, business can extend once based on policy. If gift was sent to wrong email, Emma can revoke and resend before first redemption.

---

### UC-116: The Waiver + Consent Gate
**Who:** Fitness, adventure, youth services, medical-adjacent businesses
**What:** Booking is blocked until required consent forms are signed
**Needs:**
- Versioned waiver templates
- Booking-time signature or pre-check-in signature
- Guardian signature for minors
- Hard block if required forms are missing
- Form version audit trail per booking
- Re-sign requirement when form version changes

**Scenario:** A climbing gym requires liability waiver before first class. Customer tries to book but must sign first. Teenager booking requires parent signature. If gym updates waiver language next month, returning customers must sign the new version before their next session.

---

### UC-117: The Group Booking with Split Payments
**Who:** Tours, classes, private events, shared bookings
**What:** One booking with multiple participants paying separately
**Needs:**
- Shared booking record with per-person payment status
- Payment links per participant
- Due-date reminders
- Auto-cancel/release rules for unpaid seats
- Organizer override for manual approvals
- Receipt and refund logic per payer

**Scenario:** Six friends reserve a private pottery session. Two pay immediately, three pay by link later, one misses deadline. System warns organizer and releases that unpaid seat unless organizer overrides. If event cancels, refunds route back to each original payer, not just the organizer.

---

### UC-118: The Enterprise PO / Net-Terms Booking
**Who:** B2B training, healthcare contracts, enterprise service providers
**What:** Booking confirmed against PO/invoice terms instead of immediate card capture
**Needs:**
- Purchase order number capture and validation
- Net terms (Net-15/30/45) and due-date tracking
- Credit-limit checks
- Approval workflow for high-value bookings
- Invoice generation and aging status
- Collections/escalation states

**Scenario:** A company books onsite training for 40 employees. They provide PO-88421 and Net-30 terms. Booking confirms without card charge. Finance receives invoice and payment is tracked against due date. If unpaid after due date, system flags overdue and starts collections workflow.

---

### UC-119: The SLA / Service-Guarantee Credit
**Who:** Home services, transportation, premium appointment businesses
**What:** Automatic compensation when service promises are missed
**Needs:**
- SLA definitions (arrival windows, max wait, completion windows)
- Trigger detection when SLA breached
- Auto-credit or coupon issuance rules
- Manual dispute override
- Reporting on breach rates and compensation cost

**Scenario:** Technician promised arrival between 2pm-3pm arrives at 3:40pm. SLA breach triggers automatic $25 credit to customer wallet. Manager can review and override only with reason. Monthly report shows late-arrival rate and total credits issued.

---

### UC-120: The Multi-Currency + Local Tax Checkout
**Who:** Cross-border service businesses
**What:** Customer sees and pays in local currency with correct tax treatment
**Needs:**
- Currency conversion at quote/checkout with rate snapshot
- Tax rules by service location and customer jurisdiction
- Invoice currency lock after confirmation
- Refund logic that handles FX differences
- Tax-exemption support where applicable

**Scenario:** US provider sells virtual consultation to EU customer. Customer sees price in EUR with VAT details before payment. Invoice is issued in EUR using locked conversion rate. Later partial refund uses policy-aware FX handling and records difference clearly in ledger.

---

### UC-121: The Damage/Incident Claim Lifecycle (Rental)
**Who:** Equipment, vehicle, and venue rental businesses
**What:** Post-use damage handling with evidence and financial outcomes
**Needs:**
- Pre-check and post-check condition reports
- Photo/video evidence attachments
- Claim status workflow (open, reviewing, approved, closed)
- Deposit hold/capture integration
- Customer response and dispute path
- Final settlement audit trail

**Scenario:** Camera rented Friday, returned with cracked lens Saturday. Staff uploads return photos, opens claim, and links it to deposit hold. Customer disputes, uploads pickup photos. Manager reviews both sides and approves partial charge based on policy. Claim closes with full timeline preserved.

---

### UC-122: The Escrow + Milestone Release (Marketplace)
**Who:** Multi-step services and high-ticket marketplace jobs
**What:** Funds are held and released as milestones are completed
**Needs:**
- Escrow account state per order
- Milestone definition and acceptance workflow
- Partial release percentages
- Freeze-on-dispute behavior
- Clear payout schedule to providers
- Reconciliation entries per release step

**Scenario:** Customer hires studio for a 3-phase project: concept, draft, final. Total $3,000 is funded to escrow. After concept approval, 30% releases. After draft approval, another 40% releases. Final 30% releases on final acceptance. If customer disputes phase 2, release is paused until resolved.

---

### UC-123: The Minor Protection + Guardian Approval
**Who:** Youth sports, tutoring centers, pediatric services
**What:** Minors can be participants but booking rights and approvals are guardian-controlled
**Needs:**
- Minor profile linked to guardian account
- Guardian approval requirements per service
- Allowed communication channels for minors
- Consent scope by activity type
- Emergency contact and pickup authorization controls

**Scenario:** A 15-year-old requests driving lesson booking from their account. System marks booking as pending guardian approval. Parent approves in app, receives all reminders, and only approved contacts can modify or cancel the lesson.

---

### UC-124: The Communication Consent + Quiet Hours
**Who:** Businesses sending reminders, promos, and operational notifications
**What:** Messaging must respect consent and local quiet-hour rules
**Needs:**
- Channel-level consent (SMS, email, WhatsApp, push)
- Transactional vs marketing message separation
- Quiet-hour enforcement by timezone
- Opt-out handling with audit trail
- Fallback channel policy when preferred channel is blocked

**Scenario:** Customer has SMS reminders enabled but marketing SMS disabled. System sends appointment reminder by SMS at 3pm local time. For a 10pm local update, quiet-hours rule blocks SMS and sends email instead. Consent changes are timestamped and auditable.

---

---

## Part 15: Forms, Data Collection & Compliance

### UC-125: The Intake Form (Pre-Appointment Data Collection)
**Who:** Medical clinics, therapy practices, consultancies, legal services, salons, fitness studios
**What:** Collect structured information from customers before their appointment to prepare the provider
**Needs:**
- Form builder with field types (text, textarea, date, dropdown, checkbox, radio, file upload, signature)
- Conditional logic (show follow-up questions based on answers)
- Form templates by service type (new patient vs returning, consultation vs procedure)
- Required vs optional fields
- Form completion deadline (must complete 24 hours before appointment)
- Booking block if form incomplete
- Provider review and flagging of responses
- HIPAA/GDPR compliance for sensitive data
- Pre-fill from previous submissions
- Multi-page forms with progress saving

**Scenario:** New patient books initial consultation with dermatologist. System sends intake form immediately after booking confirmation. Form includes: medical history, current medications, allergy list, skin concerns (with photo upload option), insurance info. Patient completes 80% but gets interrupted - progress saved, can return later. Required fields must be complete before appointment. System reminds 48 hours before: "Complete your intake form to keep your appointment." Provider reviews submission night before, sees photos of concerning mole, flags for extra time allocation. Form data flows directly into EHR system via integration.

---

### UC-126: The Release Form / Liability Waiver (Legal Protection)
**Who:** Adventure sports, fitness facilities, wellness services, photography, events involving minors
**What:** Legally binding document releasing liability or granting permissions, signed before participation
**Needs:**
- Legally vetted templates by industry
- Electronic signature capture (typed, drawn, or click-to-accept)
- Version control (which version was signed when)
- Guardian/minor signature workflows
- Witness signature option
- Photo/video release within same form
- Hard booking block until signed
- Re-sign requirement when terms update
- Audit trail with IP address and timestamp
- PDF generation for records
- Bulk waiver for recurring visits (annual waiver)

**Scenario:** Rock climbing gym requires liability waiver. Customer books intro class, receives waiver via email. Form includes: liability release, medical fitness attestation, photo/video release for social media, emergency contact. Customer reads, initials each section, provides electronic signature. Guardian must sign for minor climbers. Waiver stored with booking record, auto-expires after 1 year with renewal reminder. Six months later, gym updates waiver language - system notifies all active climbers to re-sign before next visit. Insurance audit requests proof of waiver for incident on March 15 - system retrieves exact signed version with metadata.

---

### UC-127: The Pre-Appointment Checklist (Task Completion Tracking)
**Who:** Medical procedures, travel preparation, event planning, home services, legal preparation
**What:** Step-by-step list of tasks customer must complete before appointment
**Needs:**
- Configurable checklist items per service
- Task types: upload document, watch video, purchase item, confirm understanding
- Progress percentage display
- Deadline tracking per task
- Auto-reminders for incomplete items
- Provider visibility of completion status
- Task dependencies (can't do step 3 until step 1 complete)
- Confirmation of each item with timestamp
- Booking cancellation if checklist not complete
- Post-completion certificate

**Scenario:** Patient scheduled for colonoscopy. Checklist auto-sent 2 weeks before: 1) Pick up prep kit from pharmacy, 2) Watch pre-procedure video (15 min), 3) Start low-fiber diet 3 days before, 4) Complete bowel prep day before, 5) Confirm fasting 8 hours prior, 6) Upload insurance card and ID, 7) Arrange ride home. Each task has deadline. Patient checks off "watched video" - timestamp recorded. Day before prep, automated reminder: "Don't forget to start your bowel prep at 6pm." Provider dashboard shows 85% completion - calls patient to ensure prep underway. No-show risk reduced from 15% to 3% with checklist system.

---

### UC-128: The Custom Fields (Flexible Data Capture)
**Who:** All businesses needing data beyond standard fields
**What:** Business-defined fields attached to bookings, customers, services, or providers
**Needs:**
- Field types: text, number, date, boolean, dropdown, multi-select, URL, color picker
- Field scopes: booking-level, customer profile, service configuration, provider profile
- Validation rules (regex, min/max, required)
- Conditional visibility (show only if X is true)
- Default values
- Search and filter by custom fields
- API access for integrations
- Reporting and grouping by custom field values
- Migration tools for field changes

**Scenario:** Dog grooming business creates custom fields: Pet name (text), Breed (dropdown), Weight (number), Aggressive behavior (boolean), Preferred groomer (dropdown), Coat condition (multi-select: matted/undercoat/shedding). These appear on booking form. Customer searches "Golden Retriever" to find previous grooming notes. Provider filters today's appointments by "Aggressive=true" to prepare safety measures. Marketing segments "Heavy shedders" for de-shedding promotion. API pushes breed data to pet food partner for targeted offers.

---

## Part 16: Communication Templates & Automation

### UC-129: The SMS Reminder System (Multi-Scenario)
**Who:** All appointment-based businesses reducing no-shows
**What:** Automated text messages triggered by various events and conditions
**Needs:**
- Trigger types: time-based (24h before), event-based (booking confirmed), condition-based (payment due)
- Two-way SMS (customer can reply to confirm/cancel/reschedule)
- Personalization variables (name, time, provider, location, custom fields)
- Quiet hours compliance (don't text at 3am)
- Character limits with auto-splitting
- Link shortening for booking links
- Opt-in/opt-out management
- Delivery status tracking
- Failed SMS fallback to email
- Template A/B testing

**Scenario Scenarios:**
- **Confirmation:** "Hi Sarah! Your massage with Mike is confirmed for Thu 2/20 at 3pm. Reply CANCEL to cancel or RESCHEDULE to change."
- **24h Reminder:** "Reminder: You have a dental cleaning tomorrow at 10am with Dr. Lee. Reply CONFIRM or call 555-0123."
- **2h Reminder:** "Your appointment is in 2 hours! See you at 123 Main St. Parking in back."
- **Payment Due:** "Hi John, your invoice of $85 is due tomorrow. Pay here: bz.ng/pay/abc123"
- **Package Low:** "You have 1 massage remaining in your package. Book your next session: bz.ng/book"
- **Re-engagement:** "We miss you! It's been 60 days since your last visit. Book now with code COMEBACK for 15% off."
- **Weather Alert:** "Due to snow, we're offering free rescheduling. Reply MOVE to find new time."
- **Waitlist Offer:** "A spot opened for tomorrow 2pm! Reply YES to claim (expires in 30 min)."

---

### UC-130: The Email Reminder System (Rich Communication)
**Who:** Businesses needing detailed, formatted communications
**What:** HTML and plain-text emails triggered by booking lifecycle events
**Needs:**
- Rich HTML templates with brand styling
- Responsive design for mobile
- Embedded calendar invites (.ics files)
- Attachment support (prep sheets, intake forms, maps)
- Multi-part MIME (HTML + plain text fallback)
- Preview and test send functionality
- Bounce handling and re-delivery
- Open and click tracking
- Conditional content blocks (show X if condition Y)
- Sequence builder (day 0, day 3, day 7, etc.)

**Scenario Scenarios:**
- **Welcome Series (Day 0):** Confirmation email with booking details, provider bio, what to expect, preparation checklist, location map, "Add to Calendar" button.
- **Preparation (Day -3):** Detailed prep instructions, forms link, FAQ, contact info, weather forecast for outdoor services.
- **Reminder (Day -1):** Short reminder with time, address, provider name, "I'm running late" button.
- **Day-of:** Brief morning-of email with link to virtual waiting room or check-in instructions.
- **Follow-up (Day +1):** Thank you, care instructions, review request, rebooking offer.
- **Win-back (Day +60):** "We haven't seen you" with special offer, one-click rebooking.
- **Birthday:** Annual birthday email with free add-on or discount.
- **Membership Renewal:** "Your membership expires in 30 days" with renewal benefits.

---

### UC-131: The Letter/Postal Mail Templates
**Who:** Legal services, medical practices, luxury services, senior care, government agencies
**What:** Physical mail generation triggered by system events
**Needs:**
- Letter template editor with merge fields
- Print-to-mail service integration (Lob, Inkit)
- Certified mail and return receipt options
- Batch processing for statements
- Address validation
- Postage class selection
- Mail tracking and delivery confirmation
- Cost tracking per mailing
- Digital copy archival
- HIPAA-compliant handling for medical letters

**Scenario Scenarios:**
- **Appointment Reminder:** Physical postcard sent 1 week before appointment for elderly patients without email.
- **Legal Notice:** Certified letter with return receipt for court date notification.
- **Welcome Packet:** New client packet with service agreement, intake forms, and branded materials.
- **Payment Reminder:** Formal invoice letter after 30 days overdue, escalating to collection warning.
- **Insurance Denial:** Explanation of benefits denial with appeal instructions.
- **Annual Statement:** Year-end summary of services for tax purposes.
- **Cancellation Notice:** Formal notification of service termination with required legal language.
- **Holiday Card:** Personalized seasonal greeting with gift certificate to top customers.

---

### UC-132: The Marketing Sequence Builder (Drip Campaigns)
**Who:** Businesses nurturing leads and retaining customers
**What:** Automated multi-touch campaigns based on customer actions and segments
**Needs:**
- Visual sequence builder with delays and conditions
- Entry triggers: booking completed, no-show, membership expiring, form submitted
- Exit triggers: booking made, purchase completed, link clicked
- Branching logic (if opened email, do X; if not, do Y)
- Multi-channel (email, SMS, push notification)
- Segmentation (new customers, VIPs, inactive, by service type)
- Send-time optimization (send when customer usually opens)
- Performance analytics (open rate, click rate, conversion)
- A/B testing for subject lines and content
- Suppression lists (don't market to opted-out)

**Scenario Scenarios:**
- **New Customer Onboarding:** Day 0: Welcome email → Day 3: "Here's what to expect" → Day 7: "How was your first visit?" → Day 14: Tips for maximizing membership → Day 30: Referral request with incentive.
- **Abandoned Booking Recovery:** Cart abandonment detected → Immediate: "Forgot something?" with booking link → 24h later: "Still interested? Here's 10% off" → 72h later: "Last chance - expires tomorrow."
- **Win-Back Campaign:** 60 days since last visit → "We miss you" with survey → 7 days later: 20% discount → 7 days later: Free add-on offer → Final: "Tell us why you left."
- **Upsell Sequence:** After basic service → "Upgrade to premium next time" → Social proof testimonials → "Members get 30% off upgrades" → Limited-time upgrade offer.
- **Referral Nurture:** After positive review → "Thanks! Share with friends" → Shareable link with tracking → Reminder with progress update ("3 friends clicked your link") → Reward unlocked notification.

---

## Part 17: Surveys, Feedback & Integrations

### UC-133: The Post-Appointment Survey
**Who:** All service businesses collecting feedback
**What:** Structured feedback collection after service completion
**Needs:**
- Multiple question types (NPS, rating, multiple choice, open text)
- Timing options (immediate, 1 hour, 24 hours, custom)
- Conditional questions based on responses
- Anonymous vs attributed options
- Photo/video upload for testimonials
- Incentive integration (complete survey for discount)
- Response routing (negative feedback to manager)
- Aggregate reporting and trends
- Individual response review
- Public review request after positive survey

**Scenario:** Massage client receives SMS 2 hours after appointment: "How was your massage with Sarah? Rate 1-5 stars." Customer rates 5 stars. Follow-up: "What did you like most?" with quick-select options. Another follow-up: "Would you recommend us?" (NPS). Positive responses trigger: "Thanks! Would you leave a Google review?" with direct link. Negative response (3 stars) triggers manager alert for immediate follow-up. Monthly report shows: NPS improved from 45 to 62, "Pressure" mentioned 23 times as positive, "Wait time" mentioned 8 times as negative - operational insights drive changes.

---

### UC-134: The Membership Subscription Model
**Who:** Gyms, spas, salons, tutoring centers, co-working spaces
**What:** Recurring payment for ongoing access or credits
**Needs:**
- Tiered membership levels (Basic, Premium, VIP)
- Monthly/annual billing with annual discount
- Included services or credits per period
- Member-only pricing and early access
- Freeze/suspend option (travel, medical)
- Upgrade/downgrade with proration
- Failed payment retry logic
- Cancellation with retention offers
- Member portal for self-service
- Family/household add-ons

**Scenario:** Yoga studio memberships: Basic ($79/mo = 4 classes), Unlimited ($149/mo), Elite ($199/mo = unlimited + 1 private session). Member selects Basic, auto-billed monthly. After 3 months, hits class limit consistently - system suggests: "Upgrade to Unlimited? You've spent $45 on drop-ins this month." Member upgrades mid-cycle, prorated charge applied. Member travels for summer - freezes membership for 2 months at $10/mo hold fee, same rate guaranteed on return. Annual option: pay $799 upfront (save $389). Cancellation attempt triggers offer: "Stay and get next month 50% off."

---

### UC-135: The External Integration Ecosystem
**Who:** Businesses connecting booking platform to their existing tools
**What:** Bidirectional data flow with third-party applications
**Needs:**
- Calendar sync (Google, Outlook, Apple) - two-way
- Video conferencing (Zoom, Teams, Google Meet) - auto-create
- Payment processors (Stripe, Square, PayPal) - native
- CRM sync (Salesforce, HubSpot, Zoho) - customer data
- Email marketing (Mailchimp, Klaviyo, SendGrid)
- Accounting (QuickBooks, Xero) - invoice sync
- SMS providers (Twilio, MessageBird)
- Review platforms (Google, Yelp, Trustpilot)
- Social media (Instagram, Facebook booking)
- Custom API for proprietary systems

**Scenario:** Medical practice integration stack: Booking → EHR (patient record created), → Insurance verification (real-time eligibility), → Google Calendar (provider schedule), → Twilio (SMS reminders), → Stripe (payment processing), → Mailchimp (monthly newsletter), → Google Reviews (post-appointment request). Custom API pushes booking data to practice management system. Single booking triggers 7 integrated actions across platforms. When appointment rescheduled, all systems update automatically. Staff doesn't need to log into 5 different systems.

---

### UC-136: The Webhook System (Real-Time Notifications)
**Who:** Developers and businesses building custom workflows
**What:** HTTP callbacks triggered by booking platform events
**Needs:**
- Event types: booking.created, booking.confirmed, booking.cancelled, payment.received, customer.created
- Custom payload configuration (JSON structure)
- Retry logic with exponential backoff
- Webhook signing for security verification
- Delivery status and logs
- Test endpoint functionality
- IP whitelisting
- Rate limiting protection
- Failed webhook queue with manual retry
- Conditional webhooks (only if condition met)

**Scenario Scenarios:**
- **Slack Notification:** `booking.created` → POST to Slack webhook → Team channel sees: "New booking! Sarah Johnson - Deep Tissue - Thu 3pm with Mike"
- **Custom CRM:** `customer.created` → POST to company CRM → Sales team sees new lead in Salesforce
- **Inventory Management:** `booking.confirmed` → POST to warehouse → Reserves equipment for rental
- **Zapier Integration:** `payment.received` → Zapier → Creates QuickBooks invoice automatically
- **Access Control:** `booking.confirmed` → POST to door system → Adds customer to building access list for appointment time
- **Failed Retry:** Webhook fails due to server outage → Retries at 1 min, 5 min, 15 min, 1 hour → Alert after 4 failures → Manual retry option in dashboard

---

## Part 18: Analytics, Growth & Incentives

### UC-137: The Analytics & Tracking Dashboard
**Who:** Business owners, managers, marketing teams
**What:** Comprehensive insights into booking performance and customer behavior
**Needs:**
- Booking volume trends (daily, weekly, monthly, YoY)
- Revenue tracking and forecasting
- Cancellation and no-show rates
- Provider performance comparison
- Customer acquisition sources (where bookings come from)
- Customer lifetime value (CLV)
- Popular services and time slots
- Fill rate by time slot
- Average booking lead time
- Demographics and segmentation
- Custom report builder
- Data export (CSV, PDF)
- Automated report scheduling

**Scenario:** Salon owner reviews monthly dashboard: Total bookings: 342 (+12% vs last month). Revenue: $18,450. No-show rate: 8% (down from 15% after SMS reminders). Top service: Balayage ($6,200 revenue). Busiest day: Saturday (40% of bookings). Top referrer: Instagram (28% of new customers). Dr. Smith has 95% completion rate, Dr. Lee has 82%. Peak booking time: Tuesday 6pm consistently underutilized - decision to offer "Tuesday Happy Hour" discount. CLV by source: Google Ads customers = $420 average, Instagram = $680. Data drives marketing budget reallocation.

---

### UC-138: The Referral Program System
**Who:** Growth-focused businesses leveraging word-of-mouth
**What:** Incentivized customer-to-customer acquisition
**Needs:**
- Unique referral codes/links per customer
- Tracking of shares, clicks, signups, and completions
- Dual-sided rewards (referrer and referee get reward)
- Tiered rewards (3 referrals = $10, 10 = $50, 25 = VIP status)
- Reward types: credit, discount, free service, cash
- Reward fulfillment automation
- Fraud detection (self-referral, fake accounts)
- Referral leaderboard/gamification
- Social sharing with pre-written messages
- Referral status tracking for customers

**Scenario:** Existing customer gets unique link: bz.ng/r/sarahm. Shares on Instagram story. 3 friends click, 1 books and completes massage. Sarah gets $25 account credit. Dashboard shows: "You've referred 1 friend. Refer 2 more for a free upgrade!" After 3 total referrals, Sarah gets free 90-minute massage. Friend who booked gets 20% first-visit discount. Business tracks: $45 customer acquisition cost via Google Ads vs $12 via referrals. Top referrer (Mom influencer) generated 23 bookings this month - identified for ambassador program. Fraud system flags suspicious self-referral pattern and blocks.

---

### UC-139: The Discount & Coupon System
**Who:** All businesses using promotions to drive bookings
**What:** Flexible pricing adjustments through codes and automatic rules
**Needs:**
- Discount types: percentage, fixed amount, free service
- Code-based (CUSTOMER20) or automatic (happy hour pricing)
- Usage limits (total redemptions, per customer)
- Date validity windows
- Service and provider restrictions
- Minimum purchase requirements
- Stackable vs exclusive rules
- First-time customer only
- Birthday/anniversary automatic discounts
- Bulk code generation for partners
- QR code generation for physical distribution
- Coupon performance tracking

**Scenario Scenarios:**
- **New Customer:** "WELCOME25" - 25% off first booking, one per customer, auto-applied to first booking
- **Flash Sale:** "FLASH50" - 50% off specific services, first 50 redemptions only, expires midnight
- **Happy Hour:** Automatic 20% off Tuesday 2-5pm slots, no code needed, shows in booking flow
- **Birthday:** Auto-issued "HBD-SARAH" on birthday month - 30% off any service, expires month-end
- **Referral Reward:** "THANKS-SARAH" given to referred friend - $20 off first visit
- **Partner Code:** Bulk generated codes for corporate partner employees - 15% off, unlimited use
- **Win-Back:** "COMEBACK" sent to inactive customers - 40% off, 30-day expiry
- **Membership Perk:** Members auto-get 10% off all bookings, stacks with other discounts up to 30% max
- **Bulk Purchase:** "5PACK" - Buy 5 get 1 free, automatically tracked
- **Seasonal:** "VALENTINE" - Couples massage 20% off, Feb 1-14 only

---

---

## Part 19: Field Operations, Construction & Workforce Management

### UC-140: The Construction Site Report with Photo Documentation
**Who:** General contractors, construction managers, field supervisors, safety inspectors
**What:** Digital daily reports from job sites with photo evidence, weather, and progress tracking
**Needs:**
- Mobile-first report creation (offline capable)
- Multiple photo uploads with timestamp and GPS coordinates
- Photo annotation (markups, arrows, text on images)
- Weather conditions auto-captured (temp, precipitation, wind)
- Crew count and subcontractor tracking
- Work completed summary by trade/area
- Material deliveries received
- Equipment on-site log
- Safety incidents or near-misses
- Delay reasons (weather, material shortage, permit issues)
- Digital signature from site supervisor
- Auto-sync when connection restored
- Report templates by project phase (foundation, framing, finishing)

**Scenario:** Site supervisor arrives at 6:30am commercial build. Opens mobile app, creates daily report. Takes 8 photos: foundation pour progress (annotates with measurements), rebar placement, safety concerns (crane positioned near power lines marked with arrow), material staging area. Weather auto-logged: 68°F, clear. Enters crew counts: Concrete team (6), Rebar crew (4), Crane operator (1). Notes: "Foundation 70% complete. Delayed 2 hours waiting for concrete truck. Safety meeting held 7am - all PPE compliant." Signs report digitally. Auto-emails to project manager, client, and archives to project folder. Photos stored with metadata for future disputes or insurance claims.

---

### UC-141: The Employee Timesheet with Clock-In/Clock-Out
**Who:** Hourly workers, shift-based businesses, field service teams, retail, hospitality
**What:** Accurate time tracking with GPS verification, breaks, and overtime calculation
**Needs:**
- Mobile clock-in/clock-out with GPS location capture
- Geofencing (must be within X feet of job site to clock in)
- Photo verification (optional selfie for attendance proof)
- Automatic break deduction or explicit break tracking
- Job code/task selection (which project/client)
- Shift notes (what was accomplished)
- Overtime calculation rules (after 8hrs daily, 40hrs weekly)
- Approval workflow (supervisor review and approval)
- Edit requests with reason (forgot to clock out)
- Multiple clock-ins per day (split shifts)
- Integration with payroll systems
- Time-off and PTO tracking
- Biometric integration (fingerprint, face scan for high-security)

**Scenario Scenarios:**
- **Landscaping Crew:** Workers clock in at 7am via mobile app - GPS confirms at Client Site A. Select job code "Lawn Maintenance - Oakwood Subdivision." Work until 12pm, clock out for lunch. Clock back in at 12:30pm, GPS now at Client Site B. Add note: "Completed mulching at Oakwood, started hedge trimming at Riverside." 10-hour day = 2 hours overtime auto-calculated. Supervisor approves timesheet Friday with one-click, data flows to Gusto payroll.
- **Retail Shift:** Employee clocks in via tablet at store - face recognition confirms identity. 15-min break auto-deducted. Clock out at end of shift. Manager gets alert if employee tries to clock in from parking lot (outside geofence).
- **Forgot Clock-Out:** Employee realizes next morning they forgot to clock out. Submits edit request: "Left at 5pm, forgot to clock out." Supervisor reviews GPS data showing they left site at 5:03pm, approves correction.

---

### UC-142: The Contractor/Subcontractor Timesheet & Invoice
**Who:** Independent contractors, freelancers, 1099 workers, trade subcontractors
**What:** Time and materials tracking with invoice generation for payment
**Needs:**
- Contractor-specific profiles (tax ID, insurance verification)
- Time tracking by project phase and deliverable
- Materials used tracking (with receipt photo upload)
- Mileage tracking for reimbursement
- Expense capture (meals, lodging for out-of-town work)
- Milestone-based billing (% complete invoicing)
- Retainage tracking (hold back 10% until completion)
- Invoice generation from approved timesheet
- Payment terms (Net-15, Net-30, upon completion)
- 1099 reporting integration
- License and certification expiration tracking
- Performance rating by contractor

**Scenario:** Electrical subcontractor works on commercial project for 2 weeks. Logs daily hours via app: Monday - 8hrs rough-in, Tuesday - 8hrs panel installation, etc. Uploads receipts for $240 in conduit and fittings (photo captured). Tracks 127 miles between job sites. At week end, generates invoice from timesheet: Labor (76hrs × $85) = $6,460, Materials = $240 + 15% markup = $276, Mileage (127 × $0.67) = $85.09. Total: $6,821.09. Submits for approval. GC approves, payment scheduled Net-15. Retainage of $682 held until final inspection passed. System tracks contractor's license expires in 60 days - sends renewal reminder.

---

### UC-143: The Policy Agreement & Handbook Acknowledgment
**Who:** HR departments, companies with distributed workforce, franchises
**What:** Digital distribution and signature collection for employee policies
**Needs:**
- Policy document upload (PDF) or built-in editor
- Version control and change tracking
- Acknowledgment required before shift booking/work assignment
- Separate policies for different roles (drivers, warehouse, office)
- Annual renewal requirement
- Quiz/assessment option (confirm they read it)
- Multi-language support
- Bulk distribution to employee groups
- Follow-up reminders for non-signers
- Audit trail with timestamp and IP
- Export for compliance audits
- Integration with onboarding workflows

**Scenario Scenarios:**
- **Safety Policy Update:** Company updates forklift safety policy. Uploads new version to system. All warehouse staff receive notification: "New safety policy requires acknowledgment by Friday." Staff must read and digitally sign before they can clock in for next shift. One employee hasn't signed by Thursday - supervisor gets alert, follows up. Friday 5pm - 100% compliance achieved. Audit log shows exactly who signed when.
- **Employee Handbook:** New hire onboarding - receives handbook via email, reviews on mobile, digitally signs acknowledgment. Can't proceed to schedule training shifts until signed. HR dashboard shows completion status for all new hires.
- **Franchise Policy:** Franchise corporate distributes updated brand standards policy. All 47 franchise locations must have employees acknowledge within 30 days. System tracks completion by location. Flagged: Location #23 only 60% compliant - franchise business coach reaches out.

---

### UC-144: The Client/Customer Signature Capture
**Who:** Field service, deliveries, installations, inspections, legal services
**What:** Collect customer signatures on-site for work completion, delivery confirmation, or agreements
**Needs:**
- Mobile signature capture (finger/stylus on screen)
- Signature on documents (work order, delivery receipt, contract)
- Photo documentation linked to signature (before/after work)
- Timestamp and GPS coordinates with signature
- Offline capability (sign now, sync later)
- Multiple signatures (client + witness, spouse + spouse)
- Email copy auto-sent to signatory
- Signature verification (compare to stored signature)
- Re-signature for change orders
- Signature required before payment processing

**Scenario Scenarios:**
- **Appliance Installation:** Technician installs new dishwasher. Takes "before" photo of old unit, "after" photo of new installation. Customer inspects work, satisfied. Signs completion form on technician's tablet: "Work completed satisfactorily." Timestamp: 2:47pm, Location: 123 Oak St. Email receipt sent to customer with photos attached. Payment auto-charged to card on file since signature confirms completion.
- **Delivery Confirmation:** Driver delivers furniture. Customer signs digital delivery receipt on driver's phone. Photo of item at doorstep if customer not home (contactless delivery with proof). Signature + photo stored for 90 days in case of dispute.
- **Contract Amendment:** Consultant on-site discovers additional scope. Creates change order on tablet, customer reviews additional $500 charge, signs amendment. Original contract + amendment stored together. Work proceeds.

---

### UC-145: The Host/Property Manager Signature Workflow
**Who:** Vacation rentals, property management, event venues, home services
**What:** Property owner or manager signs off on work, condition reports, or guest incidents
**Needs:**
- Property-specific signature requirements
- Pre-arrival and post-departure inspection signatures
- Damage report with photo evidence and host acknowledgment
- Maintenance approval workflows (owner must approve >$500 repairs)
- Guest incident reports (noise complaints, damage) with host signature
- Turnover checklist completion sign-off
- Pool/spa maintenance logs with service provider + host signatures
- Key exchange verification signatures
- Owner disbursement approval (monthly rental income statement)

**Scenario Scenarios:**
- **Vacation Rental Turnover:** Cleaner completes turnover checklist between guests: bed made, floors cleaned, supplies restocked, damage inspection. Takes photos of any damage (broken lamp). Host receives notification, reviews photos, signs off that damage existed before next guest or approves damage charge to previous guest. Signature required before next guest can check in.
- **Maintenance Approval:** Property manager gets HVAC repair quote for $850. Requires owner approval per management agreement. Sends digital work order to owner via app. Owner reviews, signs approval. Repair proceeds. Owner signature stored with work order for accounting.
- **Monthly Statement:** Property manager sends owner monthly statement: rental income - management fee - maintenance costs = net disbursement. Owner reviews, signs approval for disbursement. Funds transferred. Signed statement archived for tax records.

---

### UC-146: The Delivery Photo & Signature Capture
**Who:** Couriers, food delivery, package delivery, grocery delivery, pharmacy delivery
**What:** Proof of delivery with photo documentation and recipient signature
**Needs:**
- Photo capture at delivery point (doorstep, mailbox, handoff)
- Automatic photo quality check (clear, shows package, shows address)
- Recipient signature for high-value items
- "Safe place" drop-off with location photo
- Delivery instructions viewable ("leave behind planter")
- Failed delivery documentation (no one home, wrong address)
- GPS coordinates embedded in photo metadata
- Timestamp verification
- Customer notification with delivery photo
- Dispute resolution evidence storage

**Scenario Scenarios:**
- **Package Delivery:** Driver arrives at apartment building. Recipient not home. Takes photo of package at unit door (door #312 visible in frame). System verifies GPS matches address, timestamp recorded. Customer receives text: "Your package was delivered at 2:15pm. Photo: [link]." Photo stored 90 days.
- **High-Value Item:** $2,000 laptop delivery requires signature. Driver scans package, confirms recipient ID, captures signature on device. "Signature required" satisfied. Insurance requirement met.
- **Grocery Delivery:** Driver delivers to "side door per instructions." Photo shows bags at side door. Customer claims never received. Company pulls GPS-tagged photo showing correct address, correct location. Dispute resolved.
- **Failed Delivery:** Business closed. Driver takes photo of storefront showing "Closed" sign and hours. Notes attempted delivery time. Customer receives: "Delivery attempted at 4:30pm. Business closed. Will retry tomorrow."

---

### UC-147: The Multi-Party Sign-Off Workflow
**Who:** Complex projects requiring sequential approvals from multiple stakeholders
**What:** Document or checkpoint requiring signatures in order from multiple parties
**Needs:**
- Sequential signature routing (Party A → Party B → Party C)
- Parallel signature routing (Party A and B simultaneously, then C)
- Signature delegation (if A unavailable, A2 can sign)
- Approval deadlines and escalation
- Rejection with reason (sends back to previous party)
- Signature certificate with full chain of custody
- Reminder notifications for pending signatures
- Mobile and desktop signing
- Document lock after final signature (immutable)

**Scenario:** Commercial construction change order requires: 1) Subcontractor signature (acknowledges scope), 2) Project manager approval (confirms budget), 3) Client signature (approves additional $15,000), 4) Architect approval (confirms design compliance). System routes sequentially. Subcontractor signs Monday. PM approves Tuesday. Client receives Wednesday, has 48 hours to sign. Client rejects with note: "Reduce scope to stay under $12k." Goes back to subcontractor for revision. Process restarts. Final signed document locked and stored with audit trail showing each step and timestamp.

---

### UC-148: The Safety Inspection & Compliance Checklist
**Who:** OSHA compliance, safety officers, equipment operators, facility managers
**What:** Mandatory safety inspections with checkpoint verification and sign-off
**Needs:**
- Inspection templates by equipment type (forklift, scaffold, crane, fire extinguisher)
- Checkpoint-by-checklist completion (tires, brakes, lights, horn)
- Photo evidence for each checkpoint
- Pass/fail determination per item
- Failed item triggers work order or equipment lockout
- Inspector signature and certification number
- Date of last inspection visible on equipment tag/QR code
- Upcoming inspection reminders
- Failed inspection alert to supervisor
- Inspection history by equipment serial number

**Scenario:** Warehouse forklift operator starts shift. Scans QR code on forklift #FL-042. Opens pre-shift inspection checklist: Tires (photo required) - passes, Brakes - passes, Lights - one headlight out (FAIL). System immediately locks out forklift from use, creates maintenance ticket, alerts supervisor. Operator cannot complete inspection/clock-in for equipment operation until resolved. Backup forklift FL-023 inspected and approved. QR code on FL-042 shows "FAILED INSPECTION - DO NOT USE" until maintenance clears.

---

### UC-149: The Quality Assurance & Punch List
**Who:** Construction closeout, renovation projects, manufacturing QA, software deployment
**What:** Final inspection list with deficiency tracking and sign-off
**Needs:**
- Punch list item creation with photo, location, description
- Assignment to responsible party (contractor, worker)
- Due dates for completion
- Completion photo evidence
- Inspector re-verification and sign-off
- Category tagging (cosmetic, functional, safety)
- Priority levels (blocking vs non-blocking)
- Progress dashboard (% complete)
- Final completion certificate
- Retainage release trigger upon 100% completion

**Scenario:** New office build reaches substantial completion. Inspector walks through with tablet, creates 47 punch list items: "Paint touch-up - Conference Room A" (photo), "HVAC vent not blowing - Office 12" (photo + video), "Scratch on lobby floor" (photo). Items auto-assigned: painter gets touch-ups, HVAC contractor gets vent issue. Each contractor uploads completion photos. Inspector verifies each, signs off. Final 3 items resolved. Inspector signs final completion certificate. System releases 10% retainage ($45,000) to general contractor. Project status: Closed.

---

## Part 20: Extensibility + HIPAA-Grade Operations

### UC-150: The Plugin Install with Scoped Permissions
**Who:** Business admin installing third-party integrations/extensions
**What:** Install extension and grant only the minimum permissions needed
**Needs:**
- Extension capability manifest with explicit permission keys
- Grant permissions at biz, location, or scoped subject level
- Allow/deny controls per permission
- Required vs optional permission distinction
- Expiring temporary grants
- Permission decision audit trail
- Ability to suspend grants without uninstalling extension

**Scenario:** Clinic admin installs a reminder automation extension. It requests `read.calendar` and `send.sms`. Admin grants calendar read for Location A only and denies marketing send permissions. After a pilot, admin adds Location B grant for 30 days. Extension runs with these exact scoped grants. Security review can show when each grant was approved and by whom.

---

### UC-151: The Plugin Hook Execution with Retry + Dead Letter
**Who:** Platform operators and plugin developers
**What:** Reliable event-driven extension execution
**Needs:**
- Subscriptions to lifecycle events (booking created, payment succeeded, etc.)
- Delivery attempts with retry policy and backoff
- Idempotent delivery keys
- Processing state transitions (pending, processing, published, failed, dead-letter)
- Payload/response logging for debugging
- Correlation IDs for cross-system tracing
- Re-drive dead-letter events safely

**Scenario:** A booking event triggers two plugins: one sends WhatsApp reminders, another updates a BI warehouse. WhatsApp provider times out twice; delivery retries automatically and succeeds on third attempt. BI plugin endpoint keeps failing and lands in dead letter queue after max retries. Ops team replays after fixing credentials. Full delivery history is visible for incident review.

---

### UC-152: The Plugin Read Model / Projection Store
**Who:** Plugin developers building advanced automation/read models
**What:** Extension maintains durable scoped state from event streams
**Needs:**
- Extension-owned state documents with namespace + key
- Scoped state (biz-wide, location-specific, subject-specific)
- Optimistic revision/versioning
- Last processed event checkpoint
- Deterministic read model rebuild/replay support
- JSON payload flexibility without one-off tables per plugin

**Scenario:** A waitlist optimization plugin consumes queue and fulfillment events and builds its own demand projection state per location. It stores cursor checkpoint, demand score windows, and model metadata in scoped state documents. After an outage, plugin replays from last checkpoint and reconstructs its read model without data loss.

---

### UC-153: The HIPAA Minimum Necessary Access Control
**Who:** Healthcare providers, compliance officers, front desk and clinical staff
**What:** Ensure staff can only access PHI needed for their role/purpose
**Needs:**
- Access policy definition by scope/sensitivity/purpose of use
- Purpose-of-use tagging (treatment, payment, operations, etc.)
- Access decision logging (allowed/denied)
- Reason capture for denied attempts
- Policy linkage for every PHI access event
- Auditable trail for periodic compliance review

**Scenario:** Front desk user can view appointment schedule and insurance eligibility status but cannot open detailed clinical notes. Nurse can access treatment-related PHI for assigned patients. Any denied access attempts are logged with reason and surfaced in compliance review dashboards.

---

### UC-154: The Emergency Break-Glass Access
**Who:** Clinical staff in urgent/emergency scenarios
**What:** Temporarily bypass normal PHI restrictions with strict accountability
**Needs:**
- Emergency override flag on access events
- Mandatory justification text
- Post-access supervisor/compliance review workflow
- Review status tracking (pending, approved, rejected, escalated)
- Time-bounded emergency context and evidence trail
- Escalation alerts for suspicious override patterns

**Scenario:** Patient arrives unconscious at urgent care. Physician not normally assigned to patient triggers break-glass access to allergy and medication history, enters emergency justification, and receives immediate temporary access. Compliance team reviews event next day and marks as approved with case reference.

---

### UC-155: The Business Associate Agreement (BAA) Lifecycle
**Who:** Covered entities and vendors/subcontractors handling PHI
**What:** Track BAA status before PHI sharing is allowed
**Needs:**
- BAA records per vendor/extension/processor
- Effective/expiry windows
- Signed date and contract evidence references
- Status lifecycle (draft, active, suspended, terminated, expired)
- Breach-notice SLA fields
- Ability to block PHI-capable integrations without active BAA

**Scenario:** Clinic wants to enable a transcription plugin that processes encounter notes. System checks BAA status: draft, not active. PHI permissions remain denied until BAA is signed and marked active. Once active, plugin can process PHI under scoped permission rules.

---

### UC-156: The Accounting of Disclosures Report
**Who:** Compliance teams and patients requesting disclosure history
**What:** Track and produce disclosure records of PHI sharing
**Needs:**
- Disclosure event ledger (who disclosed, to whom, when, why)
- Recipient classification (provider, payer, BA, legal authority, etc.)
- Linkage to authorization and/or BAA when relevant
- Data class/scope references for what was disclosed
- Queryable timeline by patient and date window
- Exportable disclosure report for audits and patient requests

**Scenario:** Patient requests "who received my records in the last 12 months." Compliance officer runs disclosure report showing disclosures to lab partner, insurer, and public health authority with timestamps and legal basis, then provides response package within policy SLA.

---

### UC-157: The Security Incident + Breach Notification Workflow
**Who:** Security/compliance teams
**What:** Manage PHI-related incidents from detection through notification
**Needs:**
- Incident record with severity and status lifecycle
- Containment and resolution timestamps
- Affected record count estimate
- Notification tasks by recipient class (individuals, regulator, media, BA)
- Due dates and sent timestamps
- Evidence/audit trail of response actions

**Scenario:** Unauthorized export of sensitive patient data is detected. Incident opened as high severity, containment actions logged, and affected population estimated. Notification tasks are created with deadlines for individuals and regulator reporting. System tracks sent status and retains evidence package for audit.

---

## Part 21: Tenant-Configurable Vocabulary, Defaults & Taxonomy

### UC-158: The Biz-Configurable Status Vocabulary
**Who:** Multi-industry businesses that use different words for the same operational state
**What:** Replace hardcoded customer-facing status labels with biz-defined dictionaries
**Needs:**
- Biz-defined status sets (offers, queue entries, assignments, checklists, etc.)
- Per-value labels, descriptions, sort order, and active/inactive flags
- One default value per set
- Optional mapping to stable system code for deterministic workflows
- Location-specific variants where needed

**Scenario:** A clinic wants booking statuses shown as "Requested, Accepted, Seen, Closed" while a home-service company wants "New, Assigned, On Site, Completed." Both map to stable internal system states, so automation and reporting still work consistently while each business sees language that matches their operations.

---

### UC-159: The Quick-Start Industry Default Pack
**Who:** New businesses onboarding quickly
**What:** Start with prefilled configurable dictionaries, then customize later
**Needs:**
- Default config sets and values seeded by industry profile
- Safe editing of labels without breaking active workflows
- Add/remove options after launch
- Audit trail of who changed what and when
- Revert to default pack if needed

**Scenario:** A new salon selects "Beauty Services" onboarding profile. The system auto-creates sensible defaults for service status, queue states, checklist item types, and seat labels. Owner launches same day, then later renames "In Progress" to "With Stylist" without touching backend logic.

---

### UC-160: The Scoped Override Hierarchy
**Who:** Multi-location and multi-team organizations
**What:** Global defaults with scoped overrides at location or feature scope
**Needs:**
- Biz-wide default dictionary binding
- Location-level override binding
- Optional scope override for specific domains (e.g., one service product family)
- Deterministic resolution order (scope > location > biz default)
- Primary binding enforcement to avoid ambiguity

**Scenario:** Corporate defines global queue statuses for all branches, but Airport location needs a special state "Security Hold." Airport gets a local override while other branches continue using global defaults. Resolution stays deterministic because the scoped binding is primary for that location.

---

### UC-161: The Safe Status Retirement
**Who:** Live businesses evolving terminology without downtime
**What:** Deactivate old config values while preserving historical records
**Needs:**
- Soft-deactivate values instead of hard delete
- Optional replacement/default mapping for new records
- Historical rows keep original value reference
- Validation prevents future selection of inactive values
- Migration tools for optional bulk remap

**Scenario:** A provider retires status "Awaiting Callback" and replaces it with "Pending Contact." Existing records keep old status for history. New records default to the replacement. Dashboards can still include legacy rows without data corruption.

---

### UC-162: The Configurable Checklist Taxonomy
**Who:** Ops-heavy businesses with changing compliance tasks
**What:** Checklist types and states are configurable per biz, not fixed globally
**Needs:**
- Configurable item-type vocabulary per checklist family
- Configurable runtime item statuses and assignment statuses
- Defaults per checklist template binding
- Optional strict mode to reject out-of-dictionary states
- Consistent analytics using system-code mappings

**Scenario:** A construction business uses checklist item types "Safety, Quality, Handover," while a clinic uses "Intake, Consent, Verification." Both run on one checklist engine, but each sees domain-appropriate terminology, and reporting stays unified through mapped system codes.

---

### UC-163: The Custom Labeling for Execution Modes
**Who:** Businesses needing industry-friendly wording in UI/communications
**What:** Keep engine modes stable but let business-facing names be configurable
**Needs:**
- Optional config values for execution mode labels
- Mapping to canonical execution semantics
- Channel-safe display labels (web, SMS, invoices)
- Localized/help text per mode
- No workflow breakage when labels change

**Scenario:** One business calls a queue flow "Walk-In Line," another calls it "Express Lane." Both map to the same queue execution behavior. Staff and customers see familiar language while core scheduling and queue logic remain unchanged.

---

### UC-164: The Multi-Language Vocabulary Layer
**Who:** Bilingual/multilingual operations
**What:** Different labels per language for the same configured option value
**Needs:**
- Stable option code independent of language
- Language-specific labels/help text
- Fallback language behavior
- No duplication of business rules per language
- Consistent receipts/reports with locale-aware rendering

**Scenario:** A clinic serves English and Spanish customers. Internal code stays `checked_in`, but front desk sees "Checked In" and customer portal in Spanish shows "Registrado." Workflows and analytics remain one model, only labels vary by locale.

---

### UC-165: The Plugin-Defined Option Sets
**Who:** Third-party extension developers and advanced integrators
**What:** Plugins register and bind their own config sets to custom domains
**Needs:**
- Plugin-created config sets and values under tenant boundaries
- Binding support for custom target entity/field scopes
- Permission-scoped management (plugin cannot edit unrelated sets)
- Version-safe updates to plugin-managed dictionaries
- Clear install/uninstall lifecycle handling

**Scenario:** A demand-pricing plugin installs a set for "Demand Signal Buckets" with configurable labels and thresholds. It binds that set to its own module fields, letting each business tune categories without schema changes or custom table creation.

---

### UC-166: The Unified Reporting Across Custom Labels
**Who:** Owners and operators running multi-location analytics
**What:** Different local labels roll up to common business metrics
**Needs:**
- `system_code` mapping from custom values to canonical semantics
- Aggregation by canonical code for enterprise dashboards
- Drill-down to local label for location-level ops views
- Historical consistency when labels are renamed
- Cross-domain BI queries with consistent dimensions

**Scenario:** Location A uses "Closed - No Show" and Location B uses "Missed Visit." Both map to canonical `no_show`. Corporate dashboard shows one clean no-show metric, while each location still sees its preferred wording in local operations screens.

---

### UC-167: The Config-as-Data Promotion Workflow
**Who:** Teams running staging/production environments
**What:** Promote tested configuration dictionaries and bindings safely
**Needs:**
- Export/import of config sets/values/bindings
- Deterministic upsert by stable slug/code
- Validation before apply (missing defaults, conflicting primary bindings)
- Dry-run preview and diff
- Rollback snapshot support

**Scenario:** Ops team tests new queue-state vocabulary in staging and confirms automation behavior. They export the config pack, preview production diff, then apply during maintenance window. A rollback snapshot is retained in case labels or bindings need immediate restore.

---

---

## Part 22: Number-Based Queue Systems

### UC-168: The Take-A-Number Queue with Digital Display
**Who:** Delis, bakeries, DMV offices, clinics, retail counters, government agencies, pharmacies
**What:** Simple numbered ticket system where customers take a number and wait for their turn to be called
**Needs:**
- Ticket number generation (sequential, per-queue or global)
- Multi-counter/window support (A1-A99, B1-B99 for different service types)
- Digital display screen showing: current number being served, next numbers up, estimated wait time
- Customer-facing ticket with: their number, estimated wait, position in line, QR code for status tracking
- SMS/app notifications when number approaching ("You're 3 away")
- "Now Serving" audio announcement integration
- Estimated wait time calculation based on: average service time per counter, numbers ahead, current queue depth
- Service type routing (Counter A for simple tasks, Counter B for complex)
- Recall number if customer missed (hold for X minutes, then skip)
- Transfer number between queues (complex case needs different counter)
- Virtual queue option (take number remotely, arrive when close)
- Walk-away tolerance (bathroom, shopping) with position hold
- Analytics: average wait time, peak hours, service time by counter, abandoned numbers

**Scenario:** Customer walks into busy deli at lunch. Kiosk displays "Take a Number" - presses button, receives ticket #47. Display shows "Now Serving #42", wait estimate "15 minutes". Customer sits down, checks phone app showing live position: #45, #46, then them. SMS arrives: "You're 2 numbers away." Counter B opens additional register, display updates to show two active counters. "Now serving #43 at Counter A, #44 at Counter B." Customer's #47 called at Counter A in 12 minutes. If customer was at #44 and stepped out, counter holds for 2 minutes, calls again, then moves to #45. Missed number can rejoin at #48 (back of line) or get priority callback based on policy.

---

## Part 23: Hybrid Admission, ETA Gating, and Dynamic Holds

### UC-169: The Hybrid Queue + Online Booking for the Same Offer
**Who:** Busy barbershops, urgent-care clinics, repair counters, high-throughput service desks
**What:** Let one sellable offer accept both queue traffic and online slot bookings at the same time
**Needs:**
- One offer version that can expose multiple admission paths (queue + slot + request)
- Primary admission path for default UX routing, with secondary paths still active
- Path-level policies (e.g., queue visible at kiosk, slot visible online)
- Deterministic priority/order when multiple admission modes are enabled
- Channel-specific visibility toggles without cloning offer definitions
- Unified reporting so all admissions roll up under the same offer/sellable identity

**Scenario:** A barbershop sells one “Men’s Haircut” offer. Walk-ins join queue at the shop while online users book available slots. Operations can switch priority during peak hours (queue-first) and switch back later without creating duplicate offers. Revenue, wait time, and fulfillment data remain unified under one offer version.

---

### UC-170: The ETA-Protected Booking Window with Auto Capacity Holds
**Who:** Variable-duration services where current queue progress affects near-term availability
**What:** Block online booking before estimated queue completion, then open booking after ETA while preventing race-condition overbooking
**Needs:**
- Runtime availability gate primitive (signal -> action) scoped to calendars
- Queue ETA signal support to create temporary unavailability windows
- Capacity-hold primitive that reserves scarce capacity before final assignment
- Hold lifecycle (active, released, consumed, expired, cancelled)
- Hold target flexibility (calendar, capacity pool, resource, offer version, custom target)
- Source traceability for gates/holds (queue entry, plugin, external event, manual)
- Deterministic conflict prevention when queue and slot channels compete for same resource

**Scenario:** At 2:00 PM, queue predicts a barber will be busy until ~2:30 PM. System creates a gate marking 2:00-2:30 PM as unavailable for slot bookings. At 2:25 PM, ETA shifts to 2:40 PM, so gate updates. Once queue service starts and capacity is temporarily reserved, a hold prevents online checkout from stealing the same barber window. After completion/release, future slots open automatically.

---

## Part 24: Declarative Availability Dependencies

### UC-171: The Host Availability Depends on Front Desk Coverage
**Who:** Salons, clinics, studios, and service businesses with operational co-dependencies
**What:** A host/service can only be offered when one or more supporting roles are available too
**Needs:**
- First-class dependency rules scoped to the dependent calendar
- Ability to depend on multiple targets (all, any, or threshold modes)
- Hard-block vs soft-gate vs advisory enforcement
- Time offsets (support must be available before/after the main appointment)
- Generic target model (core calendars + plugin/custom subjects)
- Deterministic failure action (unavailable, capacity adjustment, pricing adjustment)
- Full traceability and auditability for why availability was blocked

**Scenario:** A stylist is individually available at 3:00 PM, but no front desk coverage exists for intake/check-in. The stylist calendar has a dependency rule requiring at least one front desk target to be available for the same window plus 10 minutes before start. Because dependency is not satisfied, the slot is blocked from customer booking. If backup front desk coverage appears, the slot automatically becomes available again without manual calendar edits.

---

## Part 25: Internal Staffing, Shift Board, and Payroll Traceability

### UC-172: The Open Shift Internal Job Board (First-Come, First-Serve)
**Who:** Salons, clinics, restaurants, retail stores, field teams
**What:** Business posts internal shift openings and eligible hosts/resources can claim them
**Needs:**
- First-class staffing demand row with start/end window and required count
- Fill mode set to FCFS claim
- Eligibility filters by resource type/capability/location/custom subject
- Deterministic winner logic for simultaneous claim attempts
- Demand status and assignment lifecycle visibility
- Fairness counters so same few people do not always win claims

**Scenario:** Manager posts "Front Desk 8:00am-12:00pm" as an open shift. Five eligible hosts see it in the staff app. The first valid claim is accepted automatically, demand status updates to assigned, and the winner is marked posted for that time window. Everyone else sees it closed instantly.

---

### UC-173: The Reverse-Bid Internal Shift Market
**Who:** Businesses with flexible staffing costs or contractor-style coverage
**What:** Business posts an opening and candidates bid terms (e.g., hourly rate) to win the assignment
**Needs:**
- Staffing demand with fill mode = auction
- Bid response mode with proposed hourly/total values
- Bid window open/close timestamps
- Deterministic award logic (lowest rate, weighted score, or policy-based)
- Winner and losers tracked with response statuses (won/lost)
- Optional cap/base rate policy enforcement

**Scenario:** Clinic posts same-day coverage gap "Reception 4:00pm-8:00pm." Three candidates submit bids: $32/hr, $28/hr, $30/hr. At close, policy chooses lowest valid bid, winner gets assignment, and losing bids are marked lost with full audit history.

---

### UC-174: The Replacement Flow as a Special Case of Staffing Demand
**Who:** Any operation handling absences and substitutions
**What:** Replace staff without separate one-off replacement schema
**Needs:**
- Demand type = replacement
- Optional link to source fulfillment assignment/unit
- Optional "from resource" pointer (person being replaced)
- Same response/assignment flow used by open shifts
- Same fairness and policy engine used by all staffing demand types

**Scenario:** Technician calls out sick. Manager creates a replacement demand linked to original assignment. Candidates are invited and one accepts. Assignment is created under the same staffing model used for open shifts and auctions, instead of a separate substitution-only flow.

---

### UC-175: The Internal Staffing to Timesheet to Payroll Trace
**Who:** Payroll admins, operations managers, finance teams
**What:** End-to-end traceability from posted shift to worked time to compensation ledger/pay run
**Needs:**
- Staffing assignment as the operational posting truth
- Time segment allocation rows linking clock events to staffing assignments
- Compensation ledger context fields that reference staffing assignment/time segment
- Pay run statements that can drill down to staffing and timesheet evidence
- Deterministic correction model (append/reverse, no history overwrite)

**Scenario:** Host wins an internal front desk shift. They clock in/out. Time segment is allocated to staffing assignment. Compensation ledger accrual references that assignment and segment. Payroll can answer exactly which shift, which clock records, and which ledger rows produced the final payout.

---

## Part 26: Operations Backbone, Unified Selectors, and Projection Observability

### UC-176: The Unified Operations Dispatch Board Across Fulfillment + Staffing
**Who:** Ops managers coordinating customer work and internal staffing from one screen
**What:** One board that lists mixed operational demand without forcing separate apps/tables
**Needs:**
- Canonical demand identity spanning fulfillment demand, staffing demand, and custom/plugin demand
- Canonical assignment identity spanning fulfillment assignments, staffing assignments, and custom/plugin assignments
- Source-type-aware drilldown while preserving one global queue
- Unified priority/status ordering for dispatch triage
- Ability to filter by location/resource/time window regardless of source domain

**Scenario:** A clinic operations lead opens one dispatch board and sees: patient fulfillment demand, open staffing replacement demand, and one plugin-defined transport escort demand. They sort by priority and due time, assign where needed, and only drill into source-specific details when necessary.

---

### UC-177: The Cross-Domain Assignment Timeline and Explainability View
**Who:** Support, operations, and compliance teams investigating “what happened” questions
**What:** One explainability timeline for assignments that may come from different source modules
**Needs:**
- Canonical operational assignment rows with source pointers
- Source status snapshot on canonical row for easy timeline reading
- Linked resource and window context for every assignment
- Ability to trace one assignment back to staffing/fulfillment source records deterministically
- Auditable history without relying on app-only reconstruction

**Scenario:** A dispute asks: “Who was assigned, from when to when, and from which workflow?” Support opens one timeline row and sees canonical assignment + source pointer to staffing assignment + linked fulfillment context. They answer in minutes with direct evidence.

---

### UC-178: The Staffing Demand with Canonical Auction Link
**Who:** Businesses using bidding for internal coverage while keeping staffing and auction systems consistent
**What:** Staffing demand in auction mode with explicit auction lifecycle linkage
**Needs:**
- Staffing demand supports `fill_mode=auction`
- Direct foreign-key link from staffing demand to auction row
- Deterministic shape rules (auction mode requires auction link)
- Winner/loser response outcomes reflected in staffing assignment lifecycle
- Full audit trail from posted demand -> bid set -> awarded assignment

**Scenario:** A same-day evening shift opens. Manager posts staffing demand in auction mode and links it to an auction window. Candidates bid. At close, winner is selected by policy, assignment is created, and both staffing and auction histories remain fully traceable.

---

### UC-179: The Resource-Type Selector for Offer Components
**Who:** Businesses that want broad matching by supply class, not just specific people/rooms/items
**What:** Offer component can select by resource class (host/company host/asset/venue)
**Needs:**
- Selector mode for `resource_type`
- Shape-invariant enforcement so only correct selector payload is present
- Matching engine path that can resolve “any host” style requirements cleanly
- Coexistence with specific-resource and capability selectors

**Scenario:** A driving school creates an offer component “Instructor” and sets selector to `resource_type=host`. Any eligible host can satisfy it, while other components remain constrained to specific assets/venues.

---

### UC-180: The Custom-Subject Selector for Extensible Supply Matching
**Who:** Plugin developers and advanced operators needing domain-specific matching without schema forks
**What:** Offer/service-product selectors can target custom subject namespaces
**Needs:**
- Selector mode for `custom_subject`
- Subject registry-backed referential integrity
- Tenant-safe filtering by subject type + subject id
- Compatibility with normal selector logic (`any`/`all` groups and priorities)

**Scenario:** A healthcare plugin models “on-call triage pool” as custom subjects. Offer selector targets that subject namespace directly. Matching works through the same core selector engine without adding healthcare-specific columns in offer tables.

---

### UC-181: The Projection Checkpoint Health Monitor
**Who:** Platform ops, SRE, analytics engineers, and plugin teams
**What:** First-class read-model health and lag visibility per projection scope
**Needs:**
- Projection checkpoints with scope (`biz`, `location`, `resource`, `sellable`, `custom_subject`)
- Health states (`healthy`, `lagging`, `degraded`, `failed`)
- Lag seconds + last applied timestamp
- Last lifecycle-event cursor for replay/recovery workflows
- Fast query path for “which projections are stale/broken right now?”

**Scenario:** Morning dashboard load is slow. Ops checks projection checkpoints and sees one `sellable`-scoped projection marked `lagging` with high lag seconds. They trigger replay from last event cursor and service recovers without touching transactional truth tables.

---

### UC-182: The Replay-Safe Projection Recovery Workflow
**Who:** Data/infra teams recovering after worker outage or bad deployment
**What:** Deterministic rebuild and recovery of read models from stored checkpoints
**Needs:**
- Revisioned projection checkpoint rows
- Event cursor pointer for restart-from-known-good state
- Status transitions during recovery (degraded -> healthy)
- Error summary capture for failed attempts
- Idempotent projection re-apply semantics

**Scenario:** A projection worker crashes after a deploy. Team restarts from checkpoint cursor, replays events, increments revision, and returns projection to healthy status. No destructive data repair needed.

---

### UC-183: The Unified Operational Daily Facts Dashboard
**Who:** Biz owners and operations leadership
**What:** Daily operations metrics across mixed demand/assignment domains from one fact model
**Needs:**
- Daily facts for open/filled demand counts and active/completed assignments
- Optional slicing by location and source type
- Fast historical trend querying without heavy cross-domain joins
- Support for both staffing and fulfillment-origin operational data

**Scenario:** Multi-location service business asks: “How many demands did we open and fill yesterday, and where are assignment bottlenecks?” Dashboard answers from one operational fact table, with slices by location and source type.

---

## Part 27: Cross-Biz User-Controlled Availability Sharing

### UC-184: The User Shares One Availability Contract with a Business (Internal + External)
**Who:** Hosts/providers who work with multiple businesses
**What:** A user grants one business permission to read their availability across both Bizing internal calendars and connected external calendars
**Needs:**
- One user->biz grant contract with status lifecycle (granted/revoked/expired)
- Shared access level model (`free_busy`, `masked_details`, `full_details`)
- Unified scope model for all sources vs selected sources
- User-owned calendar connections and event feeds
- User-owned internal calendar bindings that can be selected as share sources

**Scenario:** A massage therapist works with Biz A and Biz B. They give Biz B one grant that allows conflict checking using both their Google calendar and their internal Bizing host calendar from Biz A, so Biz B can schedule around true availability without owning those calendars.

---

### UC-185: The User Shares Different Source Sets with Different Businesses
**Who:** Multi-biz professionals with partial trust boundaries
**What:** User chooses exactly which calendar sources each business may use
**Needs:**
- Selected-source mode for grants
- Source rows that can point to external feeds and/or internal user calendar bindings from specific bizes
- Deduped source selections per grant
- Strong ownership checks so user can only share their own sources

**Scenario:** A stylist shares only “Work Google Calendar” with Biz A, but shares “Work Google + Internal Calendar from Biz C” with Biz B. Each business sees only the allowed source set for that specific grant.

---

### UC-186: The User Revokes or Time-Boxes Sharing and It Stops Deterministically
**Who:** Privacy-conscious users and compliance-focused operators
**What:** Sharing can be revoked immediately or set to expire automatically
**Needs:**
- Grant status transitions with `granted_at`, `revoked_at`, `expires_at`
- Status shape/timeline integrity checks
- Unique active grant guard per user->biz pair
- Full audit columns for who changed what and when

**Scenario:** A contractor stops working with a business and revokes their grant. That business immediately loses visibility into both external and internal shared availability, while historical grant records remain auditable.

---

### UC-187: The Same User Gives Different Detail Levels to Different Businesses
**Who:** Users balancing privacy with operational needs
**What:** One business can receive only free/busy while another can receive masked or full details
**Needs:**
- Per-grant access level policy
- Source-agnostic enforcement (works for internal and external sources)
- Query path that resolves access level during availability reads
- Ability to keep conflict detection enabled while restricting event details

**Scenario:** A doctor allows Biz A to see only free/busy blocks, but allows Biz B (their primary clinic) to see masked details for better coordination. Both policies are controlled by the user in separate grant contracts.

---

## Part 28: Cross-Biz Sharing Operations and Governance

### UC-188: The Biz-Specific Write-Back Permission for Busy Blocks
**Who:** Users sharing calendars with multiple businesses
**What:** User lets one business read-only while allowing another business to write back busy holds
**Needs:**
- Per-grant `allow_write_back_busy_blocks` policy
- Grant-level separation per user->biz pair
- Full audit trail for permission changes
- Compatibility with both external and internal source sharing contracts

**Scenario:** A therapist allows Biz A to only read availability, but allows Biz B to write back temporary busy holds after confirmed bookings. The behavior is controlled independently per grant.

---

### UC-189: The Cross-Biz Source Provenance View (Why Was I Marked Busy?)
**Who:** Hosts, schedulers, support staff
**What:** Explain exactly which source (external feed or internal binding from source biz) made a slot unavailable
**Needs:**
- Selected-source rows with `source_type`
- Internal source payload with `source_biz_id` + `calendar_binding_id`
- External source payload with `external_calendar_id`
- Query path from availability decision to grant source identity

**Scenario:** A slot is blocked for Biz D. Support inspects the grant and sees the blocking source came from an internal user calendar binding in Biz C, not from Google, and can explain the conflict confidently.

---

### UC-190: The Ownership-Safe Share Contract (No Sharing Someone Else’s Calendar)
**Who:** Security/compliance teams and users
**What:** Prevent users from attaching non-owned calendar sources to grants
**Needs:**
- FK that binds grant source `owner_user_id` to selected external calendar ownership
- FK that binds grant source `owner_user_id` to selected internal user calendar binding ownership
- Shape checks so source payload matches source type exactly
- Deterministic insert/update failures on invalid ownership attempts

**Scenario:** A user attempts to include another host’s internal calendar binding in their grant. The write is rejected by FK constraints, preventing accidental or malicious over-sharing.

---

### UC-191: The Grant Source Drift Handling (Source Removed/Disabled Midstream)
**Who:** Scheduling systems and operations teams
**What:** System continues to behave predictably when a previously shared source is disabled or no longer synced
**Needs:**
- Stable grant contract independent of source health
- Source-level selection rows that can be deactivated/replaced
- Sync-state/error visibility for external sources
- Policy-level fallback behavior in availability resolver

**Scenario:** A user disconnects one external feed. The grant remains active, other selected sources continue to apply, and scheduler behavior degrades predictably instead of fully failing.

---

## Part 29: Generic Policy Backbone and Consequence Ledger

### UC-192: The Configurable Labor Rulebook Template
**Who:** Unionized operations, regulated staffing teams, and enterprise HR/compliance admins
**What:** Define and version labor rulebooks as data, not hardcoded logic
**Needs:**
- Versioned policy templates with lifecycle and effective windows
- Rule rows with predicate type, severity, priority, and consequence policy
- Target bindings by biz/location/resource/service/offer/queue/subject
- Template/rule/binding coherence constraints for deterministic enforcement

**Scenario:** A unionized contractor defines “Max 10h/day” and “Mandatory 30m break after 5h” as rule rows in one labor template. The template is bound to a location and selected resources. New agreements are modeled as new versions, preserving historical behavior.

---

### UC-193: The Same Policy Engine for Labor, Safety, and Service Guarantees
**Who:** Multi-domain businesses that want one reusable policy core
**What:** Reuse one policy backbone across labor compliance, safety checklists, and service quality rules
**Needs:**
- Domain key classification for templates
- Generic predicate families (expression, threshold, schedule, event pattern, custom)
- Subject-based extensibility for plugin/domain-specific targets
- Consistent breach and consequence recording regardless of policy domain

**Scenario:** A business runs labor overtime rules, safety inspection timing rules, and service-quality follow-up rules through one policy model, while keeping each domain separately labeled and reportable.

---

### UC-194: The Immutable Policy Breach Evidence Ledger
**Who:** Compliance, legal, operations, and support teams
**What:** Track each breach as an auditable event with target, evidence, and lifecycle
**Needs:**
- Breach rows linked to template/rule/binding with coherence FKs
- Subject target identity for who/what breached
- Detection source (`auto_engine`, `manual_review`, etc.)
- Lifecycle timestamps (open/acknowledged/resolved/waived/dismissed)
- Evidence/context snapshots for forensic replay

**Scenario:** A staffing shift violates break policy. The breach event stores exact rule id, target subject, measured vs threshold values, and evidence snapshot. Later audits can reconstruct exactly why and when it was flagged.

---

### UC-195: The Generic Consequence Ledger with Financial Traceability
**Who:** Payroll, finance, compliance, and operations teams
**What:** Apply and track policy consequences with optional links to money/workflow artifacts
**Needs:**
- Consequence rows linked to breach records
- Typed consequence modes (warning, suspension, compensation/payment adjustments, queue review, workflow trigger, custom)
- Status lifecycle for planned/applied/failed/reverted/cancelled
- Optional links to compensation ledger, payment transaction, settlement entry, workflow instance, or review queue item
- Signed amount/currency support for monetary actions

**Scenario:** A repeated overtime violation triggers a compensation adjustment and manager review. One consequence row links to the breach, references the compensation ledger entry, and another row links to a review queue item for human follow-up.

---

### UC-196: The Waiver and Dismissal Trail for Policy Exceptions
**Who:** Managers, compliance officers, and auditors
**What:** Support controlled exceptions while preserving full traceability
**Needs:**
- Breach lifecycle states that include waived and dismissed outcomes
- Actor/time metadata for every lifecycle transition
- Consequence lifecycle that can be cancelled or reverted
- Audit-friendly status/timeline constraints preventing ambiguous states

**Scenario:** A breach is flagged during a regional emergency where labor exceptions are temporarily allowed. Compliance marks the breach as waived, consequences are cancelled, and the entire decision path remains visible for audit review.

---

## Part 30: Digital Product, Ticketing, and Creator Commerce Expansion

### UC-197: The Licensed Digital Product Sale with Key Issuance
**Who:** Software creators, template sellers, and premium digital content businesses
**What:** Sell a digital product and issue a verifiable license key per purchase
**Needs:**
- Product-level license type policy (personal/commercial/extended)
- Per-order license key issuance and status tracking
- Verification endpoint/workflow for checking key validity
- Revocation/suspension flow for abuse/refunds
- Full linkage between license, order, customer, and payment

**Scenario:** A creator sells a design plugin with “Commercial” license. After payment, customer receives a unique key and download access. Later, support validates key ownership and entitlement status before approving an update request.

---

### UC-198: The Secure Download Delivery with Expiry and Limits
**Who:** Digital sellers distributing files (PDF, ZIP, video packs, assets)
**What:** Deliver files with secure links, expiration windows, and download caps
**Needs:**
- Time-limited signed download links
- Max download attempts per entitlement/purchase
- Download event tracking (success/failure/device/IP metadata)
- Reissue flow for legitimate customer support cases
- Optional direct-download vs email-delivery policy

**Scenario:** Customer buys a video bundle and gets a link valid for 72 hours with 5 downloads max. After hitting limit, they contact support and receive a controlled reissue logged as a support action.

---

### UC-199: The Flexible Pricing Product (Free, Fixed, Name-Your-Price)
**Who:** Creators running lead magnets, donations, and premium paid products
**What:** Same catalog supports free products, fixed pricing, and minimum-threshold pay-what-you-want
**Needs:**
- Pricing mode flags per sellable
- Optional minimum amount for flexible pricing
- Currency-aware checkout handling
- Tax and invoice support across pricing modes
- Unified reporting across free and paid conversions

**Scenario:** Creator offers a free starter guide, a fixed-price pro pack, and a “pay what you want” workshop replay with $5 minimum. All are sold through one storefront and reported in one funnel view.

---

### UC-200: The Product Variant and Bundle Storefront
**Who:** Businesses selling multiple versions of digital/physical/composite products
**What:** Offer product variants and bundles with coherent inventory/entitlement behavior
**Needs:**
- Variant dimensions (Basic/Pro/Team, resolution, language pack, etc.)
- Bundle composition across product and service sellables
- Differential pricing and discount behavior by variant/bundle
- Line-level attribution for revenue and fulfillment traceability
- Compatibility with coupons, upsells, and cross-sells

**Scenario:** A photo creator sells “Preset Pack Basic” and “Preset Pack Pro” plus a bundle including presets + 1 coaching session. Checkout and analytics correctly attribute revenue by variant and bundle components.

---

### UC-201: The Customer Library and Access Center
**Who:** Customers who buy repeatedly across products, subscriptions, and bookings
**What:** One “My Library” that shows all owned downloads, licenses, subscriptions, and purchase history
**Needs:**
- Unified entitlement resolution across one-time and recurring purchases
- Access history and remaining limits visibility
- License status and renewal/upgrade cues
- Subscription status (active/paused/cancelled) visibility
- Self-service redownload within policy constraints

**Scenario:** Customer logs in and sees purchased ebooks, active monthly membership perks, and software licenses in one place with clear access state and renewal dates.

---

### UC-202: The Abandoned Checkout Recovery for Services and Products
**Who:** Businesses optimizing conversion from started-but-not-finished checkouts
**What:** Recover abandoned carts for both booking orders and product orders
**Needs:**
- Abandonment detection signals and timeout policy
- Recovery campaign triggers (email/SMS/push)
- Optional recovery incentives (coupon, limited-time hold)
- Attribution to source campaign and conversion outcome
- Guardrails against duplicate recovery spam

**Scenario:** Customer starts checkout for a service product and a digital add-on, then exits. System sends a reminder after 1 hour with optional 10% recovery code. Customer returns and completes purchase; conversion is tracked to that campaign.

---

### UC-203: The Affiliate Referral Commerce Loop
**Who:** Creator-led businesses and marketplaces using partner distribution
**What:** Affiliates get tracked links, commission rules, and payout visibility
**Needs:**
- Affiliate identity and scoped promotion permissions
- Attribution links and conversion tracking windows
- Commission rules by product/service/category
- Reversal/chargeback-aware commission adjustments
- Payout-ready affiliate ledger and statement exports

**Scenario:** An affiliate promotes a webinar product with unique link. Five sales convert, one later refunds. Commission ledger updates automatically and payout statement reflects net earned amount.

---

### UC-204: The Ticket Hold, Transfer, and Resale Governance Flow
**Who:** Event organizers running high-demand and transferable tickets
**What:** Manage temporary holds, attendee transfers, and controlled resale policies
**Needs:**
- Time-boxed hold reservations at checkout
- Ticket transfer workflow with identity handoff
- Optional resale policy and fee rules
- Anti-fraud constraints (max transfer count, lock windows)
- Full ticket ownership timeline audit

**Scenario:** A buyer holds two VIP tickets for 10 minutes, buys one, and later transfers it to a colleague. Organizer allows one transfer max and disables transfers 24 hours before event start.

---

### UC-205: The Multi-Session Event Agenda with Room Assignment
**Who:** Conferences, training events, and multi-track programs
**What:** One event includes many sessions, rooms, and speaker schedules
**Needs:**
- Event parent with session children
- Room assignment with conflict checks
- Speaker/presenter schedule links
- Session-level capacity controls
- Attendee itinerary generation and reminders

**Scenario:** A two-day conference has 30 sessions across 5 rooms. Organizers avoid room/speaker conflicts, attendees pick sessions, and each attendee receives a personalized agenda.

---

### UC-206: The Virtual Event Engagement Layer
**Who:** Hybrid/virtual event operators measuring participation quality
**What:** Track chat, Q&A, polls, and replay access as first-class event outcomes
**Needs:**
- Live engagement event capture primitives
- Q&A and poll response linkage to attendees/sessions
- Replay access entitlements post-event
- Engagement scoring for follow-up segmentation
- Exportable engagement analytics

**Scenario:** During a live webinar, attendees submit Q&A and answer polls. After event, replay is unlocked for 7 days. Marketing segments highly engaged attendees for advanced offer follow-up.

---

### UC-207: The Course Path with Prerequisite Gating
**Who:** Educators and training businesses delivering structured learning
**What:** Learners must complete required modules before accessing advanced ones
**Needs:**
- Course/module/lesson hierarchy
- Prerequisite dependency rules
- Progress checkpoints and completion criteria
- Unlock transitions and audit trail
- Compatibility with memberships and one-time purchase access

**Scenario:** Student cannot open “Advanced Module 3” until finishing Modules 1 and 2 and passing prerequisite quiz. Once completed, module unlocks automatically.

---

### UC-208: The Assessment and Assignment Lifecycle
**Who:** Course providers needing measurable learning outcomes
**What:** Support quizzes, pass/fail thresholds, retakes, and assignment submissions
**Needs:**
- Quiz definitions and question banks
- Attempt history and scoring records
- Pass thresholds and retake policy
- Assignment submission artifacts and grading states
- Outcome linkage to certification/completion status

**Scenario:** Student takes quiz, fails first attempt, retries, then passes and uploads final assignment. Instructor grades submission and course completion status updates accordingly.

---

### UC-209: The Membership Tier Content Gating Model
**Who:** Communities, academies, and creator memberships
**What:** Different membership tiers unlock different content/products/services
**Needs:**
- Tier definitions with entitlement mappings
- Upgrade/downgrade and prorated transition behavior
- Pause/cancel lifecycle and grace windows
- Tier-based perk visibility in storefront and booking flows
- Auditability of tier at time of access

**Scenario:** “Pro” members can access premium lessons and priority booking windows, while “Basic” members cannot. Customer upgrades mid-cycle and premium access unlocks immediately with prorated charge.

---

### UC-210: The Delivery Security Policy Pack for Digital Assets
**Who:** Sellers protecting high-value digital content
**What:** Enforce download protection policies without custom one-off code
**Needs:**
- Policy controls for IP restrictions, link abuse throttling, and watermarking
- Optional DRM/provider integration hooks
- Violation detection and consequence workflows
- Customer-safe fallback for false positives
- Compliance/audit logs for delivery security events

**Scenario:** A premium course PDF is stamped per buyer and download attempts from unusual geographies trigger risk checks. Legitimate customer can still recover access through audited support override.

---

### UC-211: The Followed Subject Alert Subscription
**Who:** Users or teams tracking critical updates from people, services, resources, or custom subjects
**What:** Subscribe to subject activity with delivery mode and channel preferences
**Needs:**
- Subject-level subscription records per subscriber identity
- Subscription type and lifecycle status
- Delivery mode (instant or digest) with channel preference
- Delivery throttling controls to reduce noise
- Tenant-safe linkage for subject-backed subscriptions

**Scenario:** A studio manager follows “High-Risk Incident” subjects and chooses digest email every 30 minutes. The manager sees fewer interruptions while still getting all important updates.

---

### UC-212: The Identity Notification Endpoints Registry
**Who:** Users and bizes that need reliable multi-channel notifications
**What:** Register and manage where notifications can be delivered
**Needs:**
- Channel-specific endpoint records (in-app, email, sms, push, webhook)
- Optional biz scoping for business-specific endpoints
- Default endpoint per channel and owner
- Endpoint lifecycle controls and metadata
- Ownership-safe constraints to prevent endpoint mixups

**Scenario:** A host enables in-app + SMS notifications, marks SMS as default for urgent alerts, and later disables SMS temporarily during travel without losing endpoint history.

---

### UC-213: The Subject Event Stream with Idempotent Writes
**Who:** Core app services, automations, and plugins producing auditable subject events
**What:** Persist immutable subject events with correlation keys for safe replay
**Needs:**
- Biz-scoped immutable event rows per subject
- Event type and priority with happened-at timestamp
- Actor identity linkage when available
- Request key and correlation key for dedupe and tracing
- Extensible event payload for domain-specific details

**Scenario:** A plugin emits “resource_maintenance_warning” twice due to network retry. Request key dedupe keeps one canonical event row, so downstream consumers do not double-handle it.

---

### UC-214: The Per-Subscriber Delivery State Timeline
**Who:** Notification engines and support teams debugging delivery outcomes
**What:** Track exactly how each event was delivered to each subscription
**Needs:**
- One delivery row per (event, subscription, channel)
- Delivery state lifecycle (pending, sent, delivered, failed, read, cancelled)
- Attempt counters and retry timestamps
- Failure reason capture and endpoint linkage
- Read-state tracking for in-app style notifications

**Scenario:** A notification fails on webhook channel, retries twice, then succeeds by email fallback policy. Support can inspect attempt counts, timestamps, and final state in one place.

---

### UC-215: The Biz-Safe Audience Fanout for Subject Events
**Who:** Multi-tenant operations that must notify many subscribers safely
**What:** Fan out subject events only to valid subscriptions/endpoints in the same tenant boundary
**Needs:**
- Tenant-safe foreign keys from delivery rows to events/subscriptions
- Subscriber-to-endpoint ownership checks
- Subscription status gates during fanout
- Event-to-delivery lineage for auditability
- Support for subject entities beyond built-in domain tables

**Scenario:** A cross-biz platform emits a subject event in Biz A. Delivery jobs can only target Biz A subscriptions and owner-linked endpoints, preventing accidental cross-tenant notification leaks.

---

### UC-216: The Notification Cadence and Noise-Control Policy
**Who:** Users who want high signal without alert fatigue
**What:** Control reminder cadence and minimum send interval per subscription
**Needs:**
- Delivery cadence fields on subscription
- Next-eligible-delivery timestamp to enforce cool-down
- Preferred channel override at subscription level
- Support for immediate vs digest modes
- Extensible metadata for future ranking/prioritization

**Scenario:** A provider follows many live queues but sets digest mode with 15-minute cooldown. They still see important shifts while avoiding dozens of single-event pings.

---

### UC-217: The Seat-Map Booking with Hold Timer
**Who:** Venues and classes where exact seats matter
**What:** Customers choose exact seats and get a short hold during checkout
**Needs:**
- Seat-map geometry per venue/resource
- Seat metadata (section/row/number/accessibility)
- Time-boxed seat holds while checkout is in progress
- Automatic hold expiry and seat release
- Final reservation linkage to order/fulfillment

**Scenario:** A customer selects seats B12 and B13 for a workshop. System holds both seats for 8 minutes while payment is completed. If checkout fails or expires, those seats return to available automatically.

---

### UC-218: The Queue Counter/Window Dispatch Board
**Who:** Front-desk operations (DMV, clinics, service counters)
**What:** Route queue tickets to specific counters/windows with staffing visibility
**Needs:**
- Counter/window entity scoped to location/queue
- Counter lifecycle (open, paused, closed)
- Assignment of staff/resources to counters by shift
- Ticket call history by counter
- Counter-level throughput analytics

**Scenario:** Queue ticket A104 is called to Window 3. Staff changeover happens at noon, and Window 3 is reassigned. Dashboard shows wait times and throughput by window for staffing decisions.

---

### UC-219: The Booking Transfer Contract
**Who:** Events and services that allow transfer under policy
**What:** Transfer a booking to another person with explicit acceptance workflow
**Needs:**
- Transfer contract record linked to source booking
- Policy fields (deadline, fee, max transfer count)
- Pending/accepted/rejected/expired lifecycle
- Identity handoff audit trail
- Optional transfer fee payment linkage

**Scenario:** A customer can’t attend and transfers their booking to a friend. Friend accepts within 24 hours, pays the transfer fee, and ownership changes with a full history trail.

---

### UC-220: The Referral Link Attribution Window
**Who:** Creators/partners driving sales via share links
**What:** Track referrals through signed links with deterministic attribution windows
**Needs:**
- Referral link entities tied to programs/owners
- Click/session attribution records
- Last-touch/first-touch policy fields
- Attribution expiry window support
- Conversion linkage to orders and rewards

**Scenario:** Creator shares one referral link on social media. Three users click, two buy within 7 days, one buys after expiry. Only in-window conversions generate reward grants.

---

### UC-221: The Session Interaction Artifact Trail
**Who:** Interactive classes/workshops requiring evidence and replayable context
**What:** Attach files/media/transcripts to interaction events
**Needs:**
- Artifact rows linked to session interaction events
- Typed artifact metadata (image/video/doc/transcript/whiteboard)
- Optional uploader identity and source channel
- Visibility controls and retention lifecycle
- Fast retrieval for session playback/review

**Scenario:** During a live workshop, host uploads a whiteboard snapshot and follow-up PDF. Both artifacts are linked to the corresponding interaction thread so participants can review context after class.

---

### UC-222: The Customer Library Read Model
**Who:** Customers and support teams needing one clear “what do I own?” view
**What:** Unified owned-access projection across memberships, tickets, licenses, and downloads
**Needs:**
- Projection row per holder + access artifact/sellable
- Computed availability/expiry status for portal queries
- Last-used and remaining-usage snapshots
- Deterministic rebuild from source ledgers/events
- Fast owner-centric index for API/UI

**Scenario:** Customer opens “My Library” and immediately sees active memberships, digital downloads, event passes, and remaining uses in one response without expensive cross-table joins at request time.

---

## Part 33: User-Owned Credential Wallet + Cross-Biz Qualification (UC-223 .. UC-230)

### UC-223: The Portable Credential Wallet (Upload Once, Reuse Everywhere)
**Who:** Independent professionals and gig workers across multiple businesses
**What:** Store certifications, licenses, IDs, background checks, and education records one time at user level
**Needs:**
- User-owned credential records not tied to one biz
- Multiple documents per credential (front/back/certificate/report)
- Structured, filterable facts (license class, issuing state, expiry date)
- Verification timeline (pending/verified/rejected/revoked)
- Privacy-first storage of sensitive identifiers (hashed where needed)

**Scenario:** Jamie uploads driver’s license, OSHA certificate, and background check once. Later, 5 different businesses can request access without Jamie re-uploading the same files over and over.

---

### UC-224: The Selective Sharing Contract (Different Biz, Different Access)
**Who:** Users sharing credentials with multiple bizes
**What:** Share full data with one biz, summary-only with another
**Needs:**
- Per-user-to-biz share grants
- Share scope controls (all credentials, selected credentials, selected types)
- Access levels (existence-only, summary, facts, documents, full)
- Separate preview/download permissions
- Revocation/expiry controls per biz grant

**Scenario:** Jamie gives Biz A full document access for compliance onboarding, but Biz B gets summary+facts only. Later, Jamie revokes Biz B and keeps Biz A active.

---

### UC-225: The Candidate Discovery Filter by Credential Facts
**Who:** Bizes searching for qualified candidates
**What:** Filter candidates by credential facts without seeing private documents first
**Needs:**
- Marketplace-safe credential visibility mode
- Filterable facts (for example: “has Class C license”, “background check verified”, “expires after 90 days”)
- Candidate-controlled discoverability toggles
- Ability to transition from discovery facts to explicit share request

**Scenario:** A delivery biz filters for candidates with verified driving credential, active background check, and no expiry in next 60 days. It sees matching candidates and then sends share requests.

---

### UC-226: The Opening-Linked Credential Request (Pre-Hire Qualification)
**Who:** Bizes posting openings/tasks for non-member workers
**What:** Request specific credentials tied to one opening before assignment
**Needs:**
- Credential request object linked to source opening/task subject
- Required vs optional request items
- Selector types (specific record, credential type, fact requirement)
- Due date and request lifecycle (open/fulfilled/declined/expired)
- Deterministic candidate-to-request integrity

**Scenario:** Biz posts “Weekend on-site technician” opening and requests: required background check + required state license + optional first-aid certification. Candidate shares only what is needed for this opening.

---

### UC-227: The Reverification and Expiry Gate for Assignment Eligibility
**Who:** Bizes avoiding expired or stale credentials
**What:** Auto-check validity windows and verification freshness before assignment
**Needs:**
- Credential expiry dates and reverification timestamps
- Verification records with expiry and confidence
- Requirement items with minimum remaining-validity days
- Status-driven eligibility checks for assignment pipelines

**Scenario:** Candidate is otherwise available, but required credential expires in 12 days while opening needs minimum 30-day validity. Candidate is flagged ineligible until renewed credential is uploaded and verified.

---

### UC-228: The Cross-Biz Verification Reuse with Local Policy Overrides
**Who:** Bizes that trust prior verification but can enforce stricter local rules
**What:** Reuse existing trusted verification and optionally request additional checks
**Needs:**
- Verification rows with verifier biz/provider metadata
- Required verification status at request-item level
- Optional biz-triggered verification request events
- Local policy controls without forcing hardcoded global rules

**Scenario:** Biz B accepts background checks verified by Biz A within last 30 days, but still requires a new local ID verification before first assignment.

---

### UC-229: The Sensitive Document Redaction and Controlled Disclosure
**Who:** Users and compliance teams handling sensitive identity docs
**What:** Allow preview/download policies without exposing unnecessary private data
**Needs:**
- Document sensitivity class and preview policy fields
- Grant-level document permission controls
- Event trail for previews/downloads
- Ability to keep credential facts discoverable while documents remain restricted

**Scenario:** A candidate allows “document preview only” for onboarding team. Team can verify document visually, but raw file download stays blocked unless candidate explicitly upgrades access.

---

### UC-230: The Immutable Credential Disclosure Timeline
**Who:** Compliance, support, and trust/safety teams
**What:** Explain exactly who requested, shared, viewed, or downloaded credential data
**Needs:**
- Immutable-style disclosure event rows
- Optional linkage to grant, request, record, and document
- Actor identity and timestamp traceability
- Fast owner and biz audit query paths

**Scenario:** During a dispute, support team opens timeline and sees: request created -> grant approved -> document previewed by recruiter -> grant revoked. No ambiguity about who accessed what.

---

## Part 34: Obvious Adjacent Scenarios We Hadn't Explicitly Listed Yet (UC-231 .. UC-241)

### Covered Today by Current Schema (Not Previously Explicit in UC Catalog)

### UC-231: The Delegated Admin with Approval Caps
**Who:** Enterprise operations leadership and regional managers
**What:** Delegate specific actions to local admins with explicit financial approval limits
**Needs:**
- Delegated action grants with scope (network/biz/location/subject)
- Per-user authority limits for approvals (refunds, discounts, payouts, exceptions)
- Effective windows and revocation/suspension lifecycle
- Full audit trail for who delegated what and when

**Scenario:** HQ delegates refund approval rights to a regional manager for one region only, capped at $2,000 per approval and $15,000 per day. Larger amounts automatically require escalation.

---

### UC-232: The Contract Pack Canary Rollout Across a Franchise Network
**Who:** Enterprise product/policy teams
**What:** Roll out a new commercial/policy pack in phases, track target-level success/failure, then expand safely
**Needs:**
- Versioned contract packs
- Scope-based binding (required/recommended/optional)
- Staged rollout runs with ordered targets
- Per-target execution results with failure diagnostics and replayability

**Scenario:** A franchise network rolls out a new cancellation policy pack to 10 pilot locations first. Two locations fail due to local conflict rules, eight succeed. Team fixes conflicts and reruns only failed targets before global rollout.

---

### UC-233: The Intercompany Settlement Window Close
**Who:** Finance teams in parent/child or cross-biz operating models
**What:** Close monthly intercompany windows with expected vs posted totals and traceable adjustments
**Needs:**
- Intercompany account lanes by pair/type/currency
- Entry ledger with source references (orders/payments)
- Settlement run windows with draft/running/completed lifecycle
- Difference tracking and exception handling

**Scenario:** Parent company settles monthly royalty and management-fee balances for 42 branches. A settlement run computes expected amount, posts final entries, and flags a branch mismatch for manual review.

---

### UC-234: The Enterprise SSO + SCIM Provisioning Lifecycle
**Who:** Enterprise IT and identity/security teams
**What:** Configure SSO once, sync users/groups automatically, and keep directory links auditable
**Needs:**
- Identity provider records (OIDC/SAML/SCIM metadata)
- SCIM sync run state and failure visibility
- External directory links to internal users/subjects
- Status controls for provisioning and deprovisioning flows

**Scenario:** A healthcare enterprise enables Azure AD SSO + SCIM sync. New hires automatically appear with mapped subject links, deactivated employees are suspended quickly, and every sync run has traceable status.

---

### UC-235: The Leave and PTO-Aware Scheduling Guard
**Who:** Businesses with shift workers and bookable hosts
**What:** Leave accrual and approved time off automatically affect assignment eligibility and availability
**Needs:**
- Leave policy and accrual definitions
- Per-user leave balances
- Leave request and approval lifecycle
- Leave event timeline tied to scheduling guard logic

**Scenario:** A host requests 3 sick days and gets approved. Their availability becomes unavailable for those dates, open assignments are rerouted, and payroll/time tracking sees the leave event trail.

---

### UC-236: The Access Security Signal and Auto-Lockdown
**Who:** Security and support teams for ticketing/licensing/content delivery
**What:** Detect suspicious access behavior and auto-restrict tokens/artifacts with reversible decisions
**Needs:**
- Access security signal capture (abuse/risk indicators)
- Decision lifecycle (allow/challenge/restrict/revoke)
- Linkage to access tokens/artifacts and delivery events
- Human override and audit trail

**Scenario:** A digital pass is used from multiple geographies in a short window. System flags anomaly, temporarily restricts token, and creates a support review path that can reinstate access if legitimate travel is confirmed.

---

### Not Covered Yet, But Should Be Easy to Add

### UC-237: The Cross-Sell Wishlist / Save-for-Later List
**Who:** Customers browsing services and products over multiple sessions
**What:** Save services/products to a personal list and convert later
**Needs:**
- Owner-scoped wishlist container
- Wishlist items linked to sellables
- Optional availability/price snapshot metadata
- Conversion attribution from wishlist to checkout

**Scenario:** A customer saves a massage package, a private class, and a supplement product. Two weeks later they return and purchase from the saved list, and marketing can attribute conversion to wishlist intent.

---

### UC-238: The Versioned Quote-to-Order Acceptance Flow
**Who:** B2B and high-ticket service sellers
**What:** Issue formal quotes with revision history, expiration, and explicit acceptance before order conversion
**Needs:**
- Quote header + quote line versioning
- Expiration and status lifecycle (draft/sent/accepted/expired/rejected)
- Acceptance actor/timestamp trail
- Deterministic conversion link from accepted quote to booking order

**Scenario:** A corporate training provider sends quote v1, updates to v2 after scope change, and client accepts v2 before expiry. System converts exactly accepted version to order, preserving legal/commercial trace.

---

### UC-239: The Installment Plan for High-Ticket Services
**Who:** Businesses selling expensive packages/procedures
**What:** Split one purchase into scheduled installments with missed-payment handling
**Needs:**
- Installment schedule rows per order/invoice
- Planned due dates and expected amounts
- Payment allocation against each installment
- Delinquency states and recovery triggers

**Scenario:** A customer buys a $1,200 certification bundle using 4 monthly installments. Two payments succeed, third is late, system sends reminder and applies policy before access suspension.

---

### UC-240: The Scheduled Gift Delivery (Date + Message + Recipient Channel)
**Who:** Customers gifting services/products for birthdays/holidays
**What:** Buy now, deliver later with recipient message and channel preference
**Needs:**
- Gift delivery schedule timestamp
- Recipient contact + channel (email/SMS/link)
- Message template/payload with edit window
- Delivery event timeline and retry visibility

**Scenario:** A customer buys a gift voucher in October but schedules delivery for December 24 with a custom message. Delivery is sent on schedule and retried automatically if first attempt fails.

---

### UC-241: The AR AutoPay Rule for Net-Term Accounts
**Who:** B2B buyers and finance teams
**What:** Let billing accounts enroll in auto-pay so approved invoices are collected automatically at due date
**Needs:**
- Billing-account-level auto-pay preferences
- Preferred payment method linkage
- Eligibility rules (invoice status/amount thresholds)
- Auto-charge execution + failure event trail

**Scenario:** A company with Net-30 invoices enables auto-pay for invoices under $10,000. On due date, eligible invoices are charged automatically; failures trigger fallback collections workflow and notification.

---

## Part 35: Demand-Driven Batch Commerce + Ads/Attribution Scenarios (UC-242 .. UC-247)

### UC-242: The Bakery Batch Prepay + Waitlist Model
**Who:** Bakeries and food businesses producing in limited daily batches
**What:** Customers prepay for specific batches; overflow demand goes to waitlist and auto-promotes when supply increases or cancellations happen
**Needs:**
- Batch-level capacity concept (for example “Sourdough 7am batch = 60 loaves”)
- Prepay checkout for each reservation
- Deterministic waitlist ordering per batch
- Promotion from waitlist when capacity opens
- Inventory/production linkage for committed vs waiting demand

**Scenario:** Bakery opens preorder for tomorrow’s 7am sourdough batch (60 loaves). First 60 prepay and confirm. Next 25 go to waitlist with position and ETA. At 5am, bakery confirms extra 10 loaves from production, and first 10 waitlisted customers are auto-promoted with payment confirmation and pickup instructions.

---

### UC-243: The Paid Ad Click-to-Order Attribution (Google/Meta IDs)
**Who:** Marketing and growth teams
**What:** Capture ad click identifiers and attribute conversions to ad campaigns with deterministic windows
**Needs:**
- Capture of ad query params (UTM, gclid, fbclid, campaign ids)
- Session-to-checkout linkage
- Click-to-order attribution decision with window logic
- Attribution model selection (first touch/last touch/custom)
- Audit trail for attribution decisions

**Scenario:** A customer clicks a Facebook ad, lands on the booking page, and purchases 2 days later. System attributes conversion to that click because it is within the configured 7-day window and records the exact campaign parameters used.

---

### UC-244: The Lead Ads to Queue/Booking Intake Flow
**Who:** Businesses running Meta/Google lead campaigns for services
**What:** Inbound ad leads become structured intake records and can be routed into queue, review, or booking flows
**Needs:**
- Inbound webhook ingestion for lead payloads
- External-to-internal entity link mapping
- Routing rules to queue/review/checkout based on lead quality or service type
- Retry-safe ingestion with idempotency and failure visibility
- Lead source provenance for follow-up teams

**Scenario:** A dental clinic runs “Free consultation” lead ads. Incoming leads are ingested, deduped, and routed to a review queue. Qualified leads are then converted to booking checkout sessions with source attribution preserved.

---

### UC-245: The Ad Audience Segment Export from Platform Behavior
**Who:** Marketing teams doing retargeting
**What:** Build retargeting audiences from internal behavior signals and sync them to ad platforms
**Needs:**
- Segment definition primitives (abandoned checkout, waitlist dropout, high-LTV, etc.)
- Membership materialization with refresh cadence
- Outbound sync states and delivery outcomes per channel account
- Consent/privacy-aware eligibility gating
- Audit trail of who was exported and when

**Scenario:** A studio builds “Abandoned checkout in last 7 days” segment and syncs it nightly to Meta. People who already purchased are excluded automatically. Sync results and failures are visible in one timeline.

---

### UC-246: The ROAS/CAC Dashboard with Spend + Conversion Join
**Who:** Finance + marketing leadership
**What:** Measure campaign profitability by joining ad spend with attributed bookings/orders
**Needs:**
- Imported ad spend facts by campaign/date/channel
- Join keys from attributed conversions to campaign entities
- Metrics for ROAS, CAC, and payback period
- Multi-touch attribution compatibility
- Reconciliation/versioning for spend corrections

**Scenario:** Team compares two campaigns: Campaign A drove $12k revenue on $3k spend (4.0x ROAS), Campaign B drove $9k on $5k spend (1.8x). Budget is shifted automatically to higher-efficiency campaigns.

---

### UC-247: The Offline Conversion Feedback to Ad Platforms
**Who:** Businesses with delayed or offline closes (phone sales, in-store pickup, manual approvals)
**What:** Push post-click conversion outcomes back to ad platforms after final booking/order completion
**Needs:**
- Conversion event records with source click lineage
- Outbound delivery queue with retries/dead-letter handling
- Status timeline per conversion push
- Idempotent dedupe for repeated sends
- Support for partial/adjusted conversion value updates

**Scenario:** A premium booking closes after manual approval 3 days post-lead. System sends offline conversion value back to Google Ads and Meta CAPI, improving optimization on actual closed revenue instead of just clicks.

---

## Part 36: Full CRM Support Scenarios (UC-248 .. UC-257)

### UC-248: The Unified Customer Profile (Contact 360)
**Who:** Sales, support, and front-desk teams
**What:** One canonical profile per customer showing identity, preferences, notes, communication consent, history, and relationships
**Needs:**
- Canonical person/account identity with tenant-safe relationships
- Timeline that includes bookings, payments, forms, and notes
- Preference and consent visibility per channel/purpose
- Household/company relationship context
- Custom fields for business-specific CRM attributes

**Scenario:** Support opens one customer record and sees booking history, last communication touchpoint, consent status, loyalty tier, household members, and private/internal notes without jumping across disconnected modules.

---

### UC-249: The Lead Capture and Qualification Lifecycle
**Who:** Growth and inbound sales teams
**What:** Capture leads from forms/channels, qualify them, and route to next action
**Needs:**
- Lead intake records with source attribution and timestamps
- Qualification status lifecycle and owner assignment
- Scoring fields and qualification notes
- Routing to queue/review/workflow based on score/policy
- Conversion link from lead to customer/order/opportunity

**Scenario:** A new lead arrives from paid ads. Team marks it “Qualified”, assigns owner, and converts it to a booked consultation while preserving source and qualification history.

---

### UC-250: The Opportunity Pipeline (Deals, Stages, and Probability)
**Who:** Sales teams selling high-ticket or multi-step services
**What:** Track opportunities through stages with expected value and close probability
**Needs:**
- Opportunity/deal entity linked to account/contact
- Configurable stage model with stage transition history
- Probability and expected value fields
- Owner assignment and activity SLA tracking
- Close-won/close-lost reason capture

**Scenario:** Sales manager sees pipeline by stage (New -> Qualified -> Proposal -> Negotiation -> Won/Lost), weighted forecast, and stalled deals requiring follow-up.

---

### UC-251: The CRM Task and Follow-Up Engine
**Who:** Sales reps, account managers, support teams
**What:** Create, assign, and complete CRM follow-up tasks tied to contacts/deals/bookings
**Needs:**
- Task records with assignee, due date, priority, and status
- Linkage to contact/deal/booking entities
- Reminder and escalation policy support
- Completion evidence/notes
- Team workload and SLA views

**Scenario:** After a missed appointment, system auto-creates “Call customer in 2 hours” task for account manager. If not completed, it escalates to supervisor queue.

---

### UC-252: The Omnichannel Conversation Inbox
**Who:** Support and sales teams handling customer communication
**What:** Unified conversation thread across email/SMS/chat/voice with outbound and inbound events
**Needs:**
- Conversation thread identity and participant model
- Inbound + outbound message event capture
- Channel-aware delivery/reply status
- Linkage to customer/contact/deal/booking context
- Assignment and internal collaboration notes

**Scenario:** Customer starts on Instagram DM, continues by SMS, and confirms by email. Agent sees one unified thread with full context and can respond from preferred channel.

---

### UC-253: The CRM SLA and Escalation Policy
**Who:** Customer success and operations leadership
**What:** Enforce response/resolution SLA for leads and customer issues with escalation paths
**Needs:**
- SLA policy definitions and target bindings
- Breach event detection and consequence workflow
- Queue/routing escalation model
- Per-owner/per-team compliance reporting
- Override/waiver audit trail

**Scenario:** “Respond to qualified lead within 30 minutes” policy breaches automatically create escalation task and notify on-call manager with full evidence trail.

---

### UC-254: The Proposal + E-Sign + Order Conversion Flow
**Who:** B2B and consultative sales teams
**What:** Send proposal, collect e-signature, and convert accepted proposal to executable order
**Needs:**
- Proposal/quote versioning with status and expiry
- Signature capture and signer role verification
- Acceptance event with actor and timestamp
- Deterministic conversion mapping to order/fulfillment entities
- Revision and rejection handling

**Scenario:** Client receives proposal v3, signs digitally, and system creates booking order + fulfillment plan from accepted version only.

---

### UC-255: The Account Hierarchy and Buying Center Model
**Who:** Enterprise sales and account management teams
**What:** Model parent/child accounts, multiple contacts, and role-based buying committees
**Needs:**
- Account hierarchy graph with relationship types
- Contact roles per account (decision maker, billing, operator)
- Multi-contact ownership on opportunities
- Access and visibility controls by account scope
- Roll-up analytics by parent account

**Scenario:** A parent company has 8 branches with different local contacts. Sales can manage one parent relationship while tracking local decision makers and branch-level pipeline separately.

---

### UC-256: The Churn Risk and Reactivation Playbooks
**Who:** Retention and lifecycle marketing teams
**What:** Detect churn risk, trigger reactivation campaigns, and measure save-rate
**Needs:**
- Health/risk scoring based on behavior and engagement signals
- Reactivation campaign enrollment rules
- Outcome tracking (saved/churned/reactivated)
- Channel-consent-aware outreach
- Experiment tracking for retention strategies

**Scenario:** Customers with 45 days inactivity and low engagement score enter reactivation journey. Some rebook, others churn; campaign variants are compared by save-rate.

---

### UC-257: The Contact Deduplication and Merge Audit Trail
**Who:** CRM admins and data quality teams
**What:** Detect duplicates, merge safely, and preserve lineage/audit trail
**Needs:**
- Duplicate-candidate detection records
- Merge decision workflow with survivor/merged ids
- Field-level conflict resolution snapshots
- Redirect map for historical references
- Full audit of who merged what and why

**Scenario:** Two profiles for same customer are detected (email match + phone fuzzy match). Admin merges them, preserves notes/history, and keeps an immutable merge record for traceability.

---

*Comprehensive Booking Use Cases v3.0 - 257 scenarios covering all major booking patterns from industry-leading platforms. Updated 2026-02-21.*

<!-- Symbolically: rollback represents "second chances" (see [[symbols/2026-02-21-rollback.md]]) -->
