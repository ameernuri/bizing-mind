---
date: 2026-02-17
tags:
  - research
  - use-cases
  - booking
  - scenarios
  - comprehensive
  - v2
---

# Comprehensive Booking Use Cases v2.0: Expanded Catalog

> Exhaustive human-language descriptions of booking scenarios. Numbered for clarity, expanded for comprehensiveness. This document directly informs schema design.

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
- Variable duration selection (30 min to 3 hours)
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
**What:** Pre-paid bundles of services with expiration
**Needs:**
- Buy 5 get 1 free structure
- Track remaining sessions
- Expiration dates (use within 6 months)
- Transferable to friend
- Partial refund for unused sessions (prorated)
- Package sharing within household

**Scenario:** Yoga studio sells "10-class passes" for $150 (vs $20 drop-in). Sarah buys one, attends 6 classes, then moves away. She transfers remaining 4 classes to her friend (transfer fee: $5). Pass expires 6 months from purchase. If she requests refund after 3 months, gets 50% back (used 6/10 = 60%, refund 40% = $60).

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

**Scenario:** Theater sells tickets online. Seat map shows: Orchestra $75, Mezzanine $50, Balcony $35. Row A (front) $95. Wheelchair accessible marked. Customer selects 4 seats together. Held for 10 minutes during checkout. If payment fails, seats released. Groups of 4+ need adjacent seats - system won't allow booking 4 scattered seats.

---

### UC-19: The Waitlist with Auto-Book and Pricing
**Who:** High-demand services
**What:** Waitlist with automatic booking and payment
**Needs:**
- Waitlist queue with position
- Pay to join waitlist ($5 fee)
- Automatic booking when slot opens
- Time to accept (2 hours to confirm)
- Cancellation fee if decline after auto-book
- Priority tiers (members first)
- Refund if never gets spot

**Scenario:** Popular restaurant: fully booked, 50 on waitlist for Saturday 7pm. Join waitlist costs $5. When cancellation occurs, #1 on list auto-booked and charged full dinner price ($80) + $5 waitlist fee. Has 2 hours to confirm. Declines? Loses $5. Never gets spot after 24 hours? $5 refunded. VIP members (paid $100/year) above regular members on list.

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
- DST handling
- Visual timezone converter
- Suggest alternatives

**Scenario:** Global team meeting needs London (2pm), New York (9am), Sydney (11pm). System shows: "Proposed: Tuesday 9am ET / 2pm GMT / 11pm AEDT." Sydney participant says too late. System suggests: "Wednesday 7am ET / 12pm GMT / 9pm AEDT" - earlier but work-hours for London. Next meeting rotates so Sydney gets better time.

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

## Part 6: New Concepts (v2.0 Additions)

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
**What:** Enroll once, attend multiple, track progress
**Needs:**
- Enroll once, attend multiple sessions
- Track attendance per session (present/absent)
- Makeup sessions for missed classes
- Completion certificate (80% attendance required)
- Payment plans (monthly for 3-month program)
- Progress dashboard
- Prerequisites checking

**Scenario:** "Yoga Teacher Training" Saturdays 9am-5pm for 12 weeks. Sarah enrolls, pays in 3 monthly installments ($400/month). Attends 11 of 12 sessions. System marks "Complete" (92% attendance > 80% threshold). Gets PDF certificate via email. Missed Session 8 can be made up at another location's Session 8 next month. Dashboard shows: "Sessions completed: 11/12. Next: Session 12 (Graduation)."

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
- 7-year retention (HIPAA/SOC2)
- Searchable by user, date, field, booking
- Export capability
- Anomaly detection

**Scenario:** Booking originally for Tuesday 2pm. Receptionist changes to Wednesday 3pm. Audit log shows: "User: Receptionist Jane | Action: UPDATE | Field: start_time | From: 2026-03-15T14:00 | To: 2026-03-16T15:00 | Reason: Patient request | Timestamp: 2026-03-10T09:23:45Z | IP: 192.168.1.45" Can't be deleted. Searchable by booking ID or user. Admin sees Jane has made 45 changes today (normal) vs usual 20 (flag for review?).

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
**What:** Hold booking without charging to prevent emotional decisions
**Needs:**
- Booking hold period (1 hour)
- No charge during hold
- Cancel penalty-free during hold
- Reminder before hold expires
- Automatic confirmation if not cancelled
- Reduce buyer's remorse

**Scenario:** Emotional customer books $500 photoshoot during breakup (wants glamour shots). System holds booking for 1 hour without charging. Email arrives: "Your booking is on hold. You have 1 hour to cancel penalty-free if you change your mind." Customer has time to reconsider, cancels, no charge. Reduces regret cancellations from 15% to 5%.

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

### Can Defer to Later:
- Complex AI/ML predictions
- Real-time video collaboration features
- White-label theming
- Multi-brand hierarchy

---

*Comprehensive Booking Use Cases v2.0 — 60 scenarios covering simple to edge cases. Generated 2026-02-17.*
