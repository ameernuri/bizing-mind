---
date: 2026-02-17
tags:
  - research
  - use-cases
  - booking
  - comprehensive
  - v1.1
---

# Comprehensive Booking Use Cases v1.1

> Exhaustive catalog of booking scenarios to inform schema design. Unnumbered for easy editing and insertion.

---

## Simple Individual Scheduling

- **Solo Consultant Classic:** Independent professional offers fixed-duration sessions. Client books online, sees available slots, pays by card, receives confirmation with video link. 24-hour cancellation policy with automatic refund. Calendar syncs with Google/Outlook.

- **Variable Duration Freelancer:** Consultant lets clients choose session length from 30 minutes to 3 hours. Priced hourly. System shows availability in variable chunks. Buffer time automatically calculated based on duration.

- **Approval-Required Professional:** High-demand consultant requires manual approval for each booking. Client requests time slot, consultant reviews within 24 hours, approves or suggests alternative. Only confirmed bookings charge card.

---

## Service Businesses with Staff

- **Hair Salon with Commission:** Multiple stylists each have their own calendar. Owner sets commission split (e.g., 60% to stylist, 40% to salon). System tracks earnings per stylist, calculates commission automatically, generates pay stubs.

- **Stylist with Favorability Ranking:** Salon has 5 stylists. Top-rated stylist (4.9 stars, 200 reviews) gets premium booking slots. New stylist (3.2 stars, 10 reviews) only gets overflow. Admin can manually boost veteran stylists during busy seasons.

- **Buffer Time Intelligence:** Color appointments automatically get 15-minute cleanup buffer. Cuts get 5 minutes. System learns that Stylist Maria needs extra 10 minutes after color corrections, adjusts her buffers individually.

- **Walk-In Queue Management:** Salon accepts walk-ins. Digital queue shows estimated wait time. VIP members skip 3 positions in queue. Text notification when 2 people ahead. Can book future appointment while waiting.

---

## Healthcare & Regulated Services

- **Medical Clinic with Room Pairing:** Each doctor paired with specific exam room containing their equipment. Booking only shows slots where both doctor AND their room are free. If room breaks, all that doctor's appointments pause.

- **Conditional Booking with Prerequisites:** Patient must complete consultation before booking procedure. System checks medical records - if consultation not done, booking blocked. If clearance expired, renewal required first.

- **HIPAA-Compliant Notes:** Each booking has clinical notes (private, HIPAA-protected), billing notes (visible to admin), and patient-facing notes (what to bring, how to prepare). AI agent adds observation notes only doctors can see.

- **Multi-Step Treatment Chain:** Dental implant requires: consultation → imaging → surgery → follow-up 1 → follow-up 2. Each step auto-books next at checkout. If surgery cancelled, downstream appointments hold. Complete audit trail of every change.

- **Provider Cancellation Penalty:** Doctor cancels within 48 hours, loses 20% of that appointment's fee. After 3 late cancellations in month, favorability score drops. After 5, temporarily removed from booking system.

---

## Group Classes & Capacity Management

- **Spin Studio with Bike Selection:** 30 bikes in studio. Members have favorites (Bike #12). System remembers preferences. Waitlist prioritizes members who couldn't get preferred bike last time.

- **Minimum Viable Class:** Yoga class needs 5 people to be worth instructor's time. At T-2 hours, if only 4 booked, class auto-cancels with full refund. Instructor can override with "I'll teach anyway" button.

- **Waitlist with Auto-Book and Pricing:** Class full. Join waitlist for $5 fee. If spot opens, auto-booked and charged. Cancel within 4 hours of auto-booking, lose $5. If no spot opens in 24 hours, $5 refunded.

- **First-Confirm-First-Booked Waitlist:** 10 people on waitlist for sold-out class. Spot opens. All 10 get notification simultaneously. First to tap "book" gets it. Others see "claimed by someone else."

- **Membership-Based Booking Only:** Exclusive gym requires active membership to book classes. Membership has weekly hour allowance (5 hours/week). System tracks usage, blocks booking if allowance exceeded. Upgrades offered at checkout.

---

## Rentals & Multi-Day Bookings

- **Airbnb-Style Property Rental:** Check-in 3pm, check-out 11am. Cleaner needs 4-hour gap. Weekly rate 20% off. Damage deposit held on card, released 48 hours after checkout. Different pricing for holidays.

- **Car Rental with Auto-Maintenance Trigger:** Car rented for 40 hours of driving time. System tracks mileage/hours. At 35 hours, schedules automatic detail cleaning before next rental. If maintenance due, car removed from availability.

- **Flexible Hourly Rental:** Client books "van for moving" and selects 3.5 hours. Priced at $30/hour. System finds 4-hour block, bills for 3.5 hours. If runs over, automatic extension charged at $45/hour overtime rate.

- **Auction-Based Booking:** High-demand property. 5 people want July 4th weekend. Submit bids over 3 days. Highest bidder wins. Losers get first dibs on backup dates at their bid price.

---

## Mobile & On-Demand Services

- **Mobile Groomer with Route Optimization:** Serves 20-mile radius. System optimizes daily route: 9am Smiths, 10:15am Johnsons (12 min drive), 11:30am Parkers. Tracks drive time unpaid. Alerts customer "10 minutes away."

- **Dynamic Duration with Price Adjustment:** Handyman job estimated 2-3 hours. Customer booked for 2 hours at $80/hour. Job takes 3.5 hours. Additional 1.5 hours charged at $100/hour (overtime rate). If finished in 1.5 hours, customer refunded 0.5 hours.

- **Overtime Prediction and Avoidance:** Plumber has 3 jobs scheduled. System predicts based on job types, will hit 9 hours (overtime threshold at 8). Alerts dispatcher: "Swap job 3 to Sarah to avoid overtime."

- **Front Desk Worker Calendar:** Receptionist manages 4 doctors' schedules in real-time. Sees all calendars overlaid. Can override, block times, add walk-ins. Different permissions than doctors - can't see patient names, just "blocked" or "available."

---

## Packages & Memberships

- **Package-Based Booking Only:** Massage studio sells "10-session package" for $800. Can only book if package has remaining sessions. No drop-ins. Package expires 6 months. Transferable to family member.

- **Use-It-Anytime Membership:** Gym membership: 10 hours/week access. Member books nothing specific - just shows up during open hours. System tracks entry/exit times, deducts from weekly allowance. Alerts at 8 hours used. Blocks entry if exceeded.

- **Unlock Booking with Prerequisites:** Advanced rock climbing class only bookable if completed Intro course and passed certification test. System checks completion records. If test expired (1 year), requires recertification.

- **Tiered Membership Access:** Basic members book classes 7 days in advance. Premium members book 14 days out. VIP members book 30 days out and get priority waitlist.

---

## Corporate & Enterprise

- **Franchise with Royalty Tracking:** 500-location franchise. Each booking automatically sends 6% royalty to franchisor. Franchisee sees net revenue. Corporate runs promotions across all locations with one click.

- **Multi-Org Booking (Wedding Planner Hiring Caterer):** Wedding planner on Bizing books caterer also on Bizing. Planner's calendar blocks "wedding event." Caterer's calendar shows "Booked by [Planner Name]." Both orgs' internal teams see relevant details. Payment flows between orgs.

- **Internal Team Booking:** Large company has Marketing, Sales, Product teams. Conference rooms bookable by anyone. But certain rooms only bookable by Marketing. Team-level permissions override individual permissions.

- **Service Marketplace Listing:** Caterer lists "Wedding Catering" service on Bizing marketplace. Sets availability, pricing, photos. Wedding planners browse, compare, book directly. Bizing handles payment, takes 5% fee.

---

## Advanced Scheduling Logic

- **Auto-Booking Trigger:** Fleet manager sets rule: "After 40 hours of drive time, auto-schedule oil change." System tracks vehicle usage, creates maintenance booking, assigns to available mechanic, notifies driver.

- **Service-Specific Availability:** Dr. Smith available Monday mornings for consultations but NOT for procedures (needs full day blocked for procedures). Same person, different availability per service type.

- **Available by Default vs Unavailable by Default:** Most staff available by default during business hours. On-call specialists unavailable by default - must mark specific slots as "available for emergency."

- **Cascading Slot Opening:** High-demand therapist only shows next 3 available slots. When one books, next slot opens. VIP patients pay $50/month to see 10 slots ahead. Regular patients see 3.

- **Filler Booking Discount:** Photographer has empty slot tomorrow. System texts past clients: "50% off tomorrow 2pm - first to book gets it." Slot fills in 10 minutes.

---

## Waitlists & Dynamic Pricing

- **Waitlist Pay-to-Join:** Conference sells out. Join waitlist for $25. If spot opens, auto-booked and charged full ticket price. Decline within 2 hours, lose $25. If never gets spot, $25 refunded after event.

- **Reverse Auction for Services:** Homeowner posts "Need roof repair, 2000 sq ft, by next Friday." Roofers submit bids with price and availability. Homeowner compares portfolios, picks winner. Booking created from bid.

- **Dynamic Pricing Based on Fill Rate:** Class at 20% capacity: $20. At 50% capacity: $25. At 80% capacity: $30. Price updates in real-time as people book.

---

## Notes & Communication

- **Multi-Type Booking Notes:** Customer adds "allergic to lavender" to massage booking. Stylist sees it. Private notes: "difficult customer, be extra nice." AI agent notes: "tends to book last minute, send reminder 24h early."

- **AI Agent Private Notes:** System observes client always cancels when booked Monday mornings. Adds AI note: "Avoid offering Mondays." Only visible to system and authorized admins, not providers.

- **Public vs Private Notes:** Customer note "bringing my mom" visible to provider. Internal note "payment issues in past" only visible to billing team. AI insight "high no-show risk" visible to dispatch.

---

## Audit & Compliance

- **Complete Change Audit:** Every modification tracked: "User X changed booking from 2pm to 3pm at 2026-02-17 10:23. Previous value: 2pm. New value: 3pm. Reason: customer request." Immutable log. 7-year retention.

- **Host Availability Change Tracking:** Doctor blocks Tuesday afternoons. System logs when, why ("personal"), and by whom. If pattern emerges (always blocking Tuesdays), admin can review.

- **Cancellation Pattern Detection:** System notices Provider Y cancels 30% of Friday afternoon appointments. Flags for manager review. No automatic penalty, but data available for performance review.

---

## Hybrid & Virtual Modes

- **Virtual-First with In-Person Option:** Therapy session defaults to Zoom. Client can upgrade to in-person (if provider has office space) for $30 surcharge. Same booking, mode switched.

- **Hybrid Appointment:** Consultation starts virtual (video call for 30 min), then client comes in-person for exam (30 min). One booking, two modes, sequential. Virtual link sent first, then office address.

- **Virtual Waiting Room:** Telehealth appointment. Patient checks in online, joins virtual waiting room. Sees "You are #2 in line. Estimated wait: 8 minutes." Doctor sees queue, starts next session.

- **Screen Sharing Consultation:** Financial advisor meeting includes document review. Booking includes screen sharing, recording (with consent), shared whiteboard for calculations.

---

## Edge Cases & Curveballs

- **Floating Appointment:** Patient needs MRI "sometime this week." No specific time selected. System assigns Wednesday 2pm based on optimization. Patient can accept or request different time.

- **Standing Reservation:** VIP has "every Friday 2pm" indefinitely. Billed monthly whether they come or not. Can skip individual weeks. If they skip 3 in a row, system asks "Pause subscription?"

- **Disaster Recovery Mass Reschedule:** Fire closes clinic. System identifies all patients with appointments next 48 hours. Sends batch text: "Downtown closed due to emergency. Reply 1 for Uptown location, 2 for reschedule, 3 for cancel." Processes 200 responses automatically.

- **Parent Booking for Minor with Teen Permissions:** Mom books dentist for 14-year-old. Kid can also book own tennis lessons. Mom gets notification for both. Different permission levels by service type (medical vs recreational).

- **Company as Provider with Hidden Swaps:** ABC Plumbing Corp booked. Dispatcher assigns Technician Mike. Day of, Mike sick, dispatcher swaps to Sarah. Customer just sees "ABC Plumbing arriving." Never knows about individual technician.

- **Equipment Failure Cascade:** MRI Machine A breaks. All its bookings for next 7 days need reassignment. System checks Machine B availability, patient preferences ("only want Machine A"), reschedules what it can, notifies rest to call for manual rescheduling.

- **Union Production with Child Actor:** Film shoot needs 10-year-old actor. Union rules: max 6 hours on set, 3 hours schooling, 1 hour break, must finish by 4pm. System builds schedule backwards from 4pm, ensures all constraints met.

- **Cross-Timezone Team Meeting:** Find time that works for London (2pm), New York (9am), Sydney (11pm). System suggests alternatives, rotates who gets inconvenient time, handles daylight saving transitions.

- **Auction with Sniping Protection:** Bid on rare collectible showing. Bids open 7 days. In final hour, any bid extends auction by 10 minutes. Prevents last-second sniping.

- **Subscription Pause with Credit Rollover:** Gym member pauses for 2 months. Unused hours from current month roll to credit. When reactivates, has 15 hours available instead of usual 10.

- **Prerequisite Chain with Expiration:** Scuba certification requires: classroom (good for 1 year) → pool training (good for 6 months) → open water (good for life). If pool training done 8 months ago, expired, must redo before open water.

- **Group Booking with Payment Split:** 4 friends book vacation rental. One person books, holds with deposit. System sends payment links to other 3. When all paid within 48 hours, booking confirmed. If not, deposit forfeited.

- **Anonymous Booking for Sensitive Services:** Therapy appointment booked without name attached. Client ID is code. Provider only sees code until client arrives and provides ID verification. For domestic violence survivors, celebrities.

- **Weather-Dependent with Auto-Reschedule:** Outdoor wedding venue. If rain forecast 24h before, auto-moves to indoor backup. If indoor full, offers refund. System checks weather API, makes decision, notifies all parties.

- **Referral Unlock:** Client gets 3 friends to book. Unlocks "VIP status" - earlier booking access, discounted rates, free add-ons. System tracks referrals, automatically upgrades status.

- **Booking Transfer:** Customer can't make appointment. Transfers to friend via link. Friend accepts, takes over booking, payment, liability. Original customer gets store credit as thank you.

- **No-Show Strike System:** First no-show: warning. Second: $10 fee. Third: 30-day booking ban. Fourth: account review. Resets after 12 months good behavior.

- **Resource Pool Optimization:** Hospital has 3 MRI machines, 5 technicians, 2 rooms. System optimizes daily: which tech with which machine in which room, minimizing setup time, maximizing throughput. 15% efficiency gain.

- **Impulse Booking with Cooldown:** Customer books expensive service in emotional moment. System holds booking for 1 hour without charging. "You have 1 hour to cancel penalty-free." Reduces regret cancellations.

- **Gift Booking:** Buy massage as gift. Recipient gets email: "John bought you a massage! Book your time here." They select time, not giver. Giver never sees recipient's calendar.

- **Corporate Bulk Booking with Individual Selection:** Company buys 100 training slots. Employees each claim one slot via unique code. Company sees overall utilization (67% claimed), employees see only their own booking.

- **Booking with Post-Task Review Required:** Renter books car. Must upload photos of condition within 1 hour of return. System blocks next booking for that user until photos uploaded. Ensures accountability.

- **Seasonal Availability Flip:** Ski instructor available December through March. April through November completely unavailable (not just busy, but professionally inactive). System shows "Returns December 1st" instead of "No availability."

- **Simultaneous Multi-Location Booking:** Conference call needs rooms in 3 cities booked at same time. One booking, 3 locations. If any location unavailable, whole booking blocked.

- **Booking with Mandatory Follow-Up:** Surgery booking auto-creates 2-week follow-up appointment. Can't be cancelled independently - if surgery cancelled, follow-up auto-cancels. If surgery completed, follow-up is mandatory (cancellation requires doctor approval).

---

## What These Use Cases Demand From Schema

### Must Support:
- Variable duration bookings (30 min to 4 hours)
- Multiple bookable types (person, equipment, space, company)
- Household/group accounts with permissions
- Products alongside services
- Packages with usage tracking
- Memberships with allowance tracking
- Service-specific availability (same person, different times per service)
- Commission calculations and splits
- Favorability/ranking systems
- Complete audit trails
- Multi-level org booking (org hiring org)
- Marketplace listings
- AI/private/public notes
- Cancellation penalties (financial and reputation)
- Dynamic pricing and auction mechanics
- Waitlists with payment
- Prerequisites and unlocking logic
- Approval workflows
- Auto-booking triggers
- Overtime tracking and prediction

### Can Defer:
- AI/ML predictions
- Real-time collaboration features
- White-label theming
- Complex multi-brand hierarchy

---

*Comprehensive Use Cases v1.1 — Unnumbered for easy editing. Generated 2026-02-17.*
