# Bizing Tester Personas

> Comprehensive user personas for testing, security auditing, and UX validation across the Bizing platform.

**42 personas** across 7 categories:
- Standard Business Users (6)
- Multi-Tenant & Edge Cases (3)
- Security Threats — External (6)
- Security Threats — Internal (5)
- Social Engineering & Human Factors (4)
- AI Agent API Users (5) 🆕
- Edge Cases & Stress Testers (6)
- Bizarre & Corner Cases (5)

---

## Part 1: Standard Business Users

### 1. The Solo Entrepreneur (Sarah)
**Profile:** Just starting out, wearing all hats
- **Tech savvy:** Medium (can follow setup wizards, gets stuck on advanced features)
- **Usage pattern:** Logs in 2-3x/day, mostly mobile
- **Goals:** Get booking link working, collect payments, look professional
- **Pain points:** Overwhelmed by options, just wants "simple"
- **Test scenarios:**
  - First-time setup flow completion time
  - Accidentally deletes availability rule, panics
  - Tries to book herself to test the flow
  - Forgets to set buffer time between appointments

### 2. The Multi-Location Owner (Marcus)
**Profile:** 3-5 locations, managing from central office
- **Tech savvy:** Medium-High
- **Usage pattern:** Dashboard-heavy, reports-focused
- **Goals:** Compare performance across locations, enforce consistency
- **Pain points:** Location switching friction, cross-location staff confusion
- **Test scenarios:**
  - Transfers booking between locations
  - Runs consolidated vs per-location reports
  - Sets different pricing per location
  - Staff works at multiple locations

### 3. The Front Desk Manager (Lisa)
**Profile:** Handles walk-ins, phones, bookings all day
- **Tech savvy:** Low-Medium (learned specific workflows)
- **Usage pattern:** All day, high volume, needs speed
- **Goals:** Check people in fast, handle changes, minimize clicks
- **Pain points:** Slow loading, too many confirmation dialogs
- **Test scenarios:**
  - Walk-in to checked-in under 30 seconds
  - Cancels and reschedules mid-rush
  - Override availability for VIP
  - Handles phone booking while checking someone in

### 4. The Mobile Service Provider (Jake)
**Profile:** Dog groomer, plumber, mobile notary — on the road
- **Tech savvy:** Medium (phone power user)
- **Usage pattern:** Mostly mobile, between appointments
- **Goals:** Route optimization, update ETA, collect on-site payment
- **Pain points:** Needs offline capability, GPS issues
- **Test scenarios:**
  - Books next appointment while driving (voice?)
  - GPS-based arrival confirmation
  - Takes payment in parking lot
  - Photo documentation at job site

### 5. The Appointment-Heavy Professional (Dr. Chen)
**Profile:** Doctor, therapist, consultant — 30+ appointments/day
- **Tech savvy:** Low (wants it to "just work")
- **Usage pattern:** Checks schedule morning, minimal interaction
- **Goals:** See day at glance, no double-bookings, easy notes
- **Pain points:** Complex UI, alert fatigue
- **Test scenarios:**
  - Day view with 50+ appointments performance
  - Quick note dictation during session
  - Blocks emergency slot
  - Delegates scheduling to assistant

### 6. The Franchisee (Priya)
**Profile:** Owns 2 franchise locations, follows corporate rules
- **Tech savvy:** Medium
- **Usage pattern:** Balances corporate compliance with local needs
- **Goals:** Stay compliant, hit targets, local flexibility where allowed
- **Pain points:** Can't change corporate-mandated settings
- **Test scenarios:**
  - Tries to override prohibited setting
  - Requests exception through proper channel
  - Views corporate vs local reporting split
  - Onboards new staff with corporate template

---

## Part 2: Multi-Tenant & Edge Cases

### 7. The Consultant With Multiple Clients (Alex)
**Profile:** Works with 5+ businesses on Bizing as advisor/bookkeeper
- **Tech savvy:** High
- **Usage pattern:** Constant context switching
- **Goals:** Keep client data separate, efficient navigation
- **Pain points:** Confusing which biz they're in, cross-contamination fears
- **Test scenarios:**
  - Accidentally posts data to wrong biz
  - Copies settings from one biz to another
  - Runs consolidated "my clients" report
  - Tries to share template across bizes

### 8. The Confused Multi-Biz User (Sam)
**Profile:** Host at 2 locations, customer at 3 others
- **Tech savvy:** Medium
- **Usage pattern:** Gets lost in the "who am I right now" problem
- **Goals:** Book as customer, work as provider, not mix them up
- **Pain points:** Wrong context, wrong calendar, wrong payment method
- **Test scenarios:**
  - Books themselves at their own location by mistake
  - Confuses customer view vs provider view
  - Payment goes to wrong business
  - Calendar shows wrong availability context

### 9. The Platform Power User (Jordan)
**Profile:** Uses every feature, pushes limits
- **Tech savvy:** Very High
- **Usage pattern:** Deep in every menu, files bugs
- **Goals:** Optimize everything, automate workflows
- **Pain points:** Feature gaps, API limitations
- **Test scenarios:**
  - Creates 50 nested service bundles
  - 1000 concurrent queue entries stress test
  - Complex webhook chains
  - Custom field explosion (1000+ fields)

---

## Part 3: Security Threats — External

### 10. The Black Hat Hacker (Spectre)
**Profile:** Professional attacker, targeting customer PII and payment data
- **Skills:** SQL injection, XSS, credential stuffing, API enumeration
- **Goals:** Extract payment cards, personal data, business intelligence
- **Methods:**
  - Automated credential stuffing against login endpoints
  - SQL injection in search/booking forms
  - XSS via booking notes/customer names
  - API endpoint enumeration for unauthenticated access
  - Mass assignment attacks on update endpoints
- **Test scenarios:**
  - All user input sanitized/escaped
  - Rate limiting on auth endpoints
  - SQL injection attempts in every text field
  - IDOR (Insecure Direct Object Reference) on booking IDs

### 11. The White Hat Hacker (Maya)
**Profile:** Security researcher, reports responsibly
- **Skills:** Same as black hat, but ethical
- **Goals:** Find vulns, get bounty, help secure platform
- **Methods:**
  - Responsible disclosure process
  - Proof of concept exploits
  - Security assessment reports
- **Test scenarios:**
  - Bug bounty program responsiveness
  - Security@ email monitored
  - Vulnerability patch timeline

### 12. The Script Kiddie (KidZero)
**Profile:** Uses tools they don't understand, noisy, no finesse
- **Skills:** Can run automated tools, no custom exploits
- **Goals:** Defacement, "lulz", credential dumps
- **Methods:**
  - Off-the-shelf scanner spam
  - Generic wordlist attacks
  - Known CVE exploitation attempts
- **Test scenarios:**
  - WAF blocks common attack patterns
  - Automated IP banning
  - Alerting on suspicious patterns

### 13. The Phishing Specialist (Angler)
**Profile:** Social engineer, targets users not systems
- **Skills:** Craft convincing emails, fake login pages
- **Goals:** Steal credentials, session tokens
- **Methods:**
  - Fake "Bizing Security Alert" emails
  - Clone login pages on typo domains
  - SMS phishing (smishing) for 2FA codes
- **Test scenarios:**
  - Email verification (SPF/DKIM/DMARC)
  - Suspicious login alerting
  - Anti-phishing education in UI
  - Session token binding to device/IP

### 14. The Competitor Spy (Raven)
**Profile:** Rival business intelligence gathering
- **Skills:** OSINT, data aggregation
- **Goals:** Pricing data, customer lists, feature roadmaps
- **Methods:**
  - Scraping public booking pages
  - Fake customer bookings to see pricing
  - Staff LinkedIn reconnaissance
  - Trial account data harvesting
- **Test scenarios:**
  - Rate limiting on public pages
  - Booking data obfuscation for non-owners
  - Trial account data sandboxing
  - Staff data minimization in public views

### 15. The DDoS Attacker (Flood)
**Profile:** Wants to disrupt service, not steal data
- **Skills:** Botnets, amplification attacks
- **Goals:** Service outage, ransom
- **Methods:**
  - Volumetric attacks on API
  - Application-layer slowloris
  - Booking slot exhaustion (reservation abuse)
- **Test scenarios:**
  - DDoS protection (Cloudflare/etc)
  - Rate limiting effectiveness
  - Auto-scaling under load
  - Booking hold expiration prevents slot locking

---

## Part 4: Security Threats — Internal

### 16. The Disgruntled Employee (Dana)
**Profile:** Leaving company, wants to damage/steal
- **Access:** Admin or elevated permissions
- **Goals:** Delete data, steal customer list, sabotage
- **Methods:**
  - Bulk deletion attempts
  - Data export before exit
  - Permission escalation before detected
- **Test scenarios:**
  - Admin actions logged and alerted
  - Bulk deletion requires confirmation/reason
  - Data export audit trails
  - Offboarding checklist triggers access revocation

### 17. The Curious Employee (Nosy Nancy)
**Profile:** Not malicious, just snoops on celebrity customers
- **Access:** Standard staff permissions
- **Goals:** Gossip, peek at interesting records
- **Methods:**
  - Browsing customer list without work reason
  - Looking up ex-partners in system
  - Screenshots of sensitive data
- **Test scenarios:**
  - Access logging (who viewed what when)
  - Privacy alerts on sensitive record access
  - "Minimum necessary" access enforcement
  - Break-glass access logging and review

### 18. The Privilege Escalator (Climber)
**Profile:** Actively trying to gain more access
- **Access:** Standard user, wants admin
- **Goals:** Admin access, financial controls
- **Methods:**
  - Parameter tampering (change role in request)
  - Session token manipulation
  - Social engineering admin for access
  - Exploiting misconfigured permissions
- **Test scenarios:**
  - Server-side permission validation
  - Role change requires re-auth + MFA
  - Admin actions require approval workflow
  - Privilege separation (can't be admin + accountant)

### 19. The Rogue Biz Employee (Insider)
**Profile:** Legitimate user stealing from their own business
- **Access:** Trusted, probably finance/admin role
- **Goals:** Steal money, manipulate records
- **Methods:**
  - Fake refunds to personal card
  - Altering payout accounts
  - Deleting audit trails
  - Creating fake vendor payments
- **Test scenarios:**
  - Separation of duties (maker/checker)
  - Financial transaction dual approval
  - Immutable audit logs (even admin can't delete)
  - Anomaly detection on unusual refund patterns

### 20. The Rogue Bizing Employee (Platform Insider)
**Profile:** Bizing staff with database/production access
- **Access:** Internal tools, database, logs
- **Goals:** Steal customer data, spy on businesses
- **Methods:**
  - Direct database queries
  - Log analysis for sensitive data
  - Backdoor account creation
  - Data exfiltration via "maintenance"
- **Test scenarios:**
  - Database access logging and alerting
  - Production access requires approval + pairing
  - Data masking in non-prod environments
  - Customer data access requires ticket reference
  - Regular access audits and recertification

---

## Part 5: Social Engineering & Human Factors

### 21. The Naive User (Trusting Tom)
**Profile:** Clicks everything, believes everyone
- **Vulnerabilities:** No skepticism, shares passwords
- **Goals:** Just wants to help/complete task
- **Methods (by attackers):**
  - "IT needs your password"
  - "Click here to verify your account"
  - "Urgent: Update payment info"
- **Test scenarios:**
  - Security awareness in onboarding
  - Password reuse detection
  - Suspicious login location alerting
  - "Report phishing" button in emails

### 22. The Careless Owner (Lazy Linda)
**Profile:** Leaves sessions open, shares logins
- **Behaviors:**
  - Stays logged in on shared computer
  - Shares password with assistant
  - No screen lock
  - Books from coffee shop WiFi
- **Test scenarios:**
  - Auto-logout on inactivity
  - Concurrent session limits
  - "Log me out everywhere" function
  - Unusual location/device alerting

### 23. The Social Engineer (Smooth Steve)
**Profile:** Calls support, charms them into bypassing security
- **Skills:** Confidence, manipulation, information gathering
- **Goals:** Account takeover, data access, refund fraud
- **Methods:**
  - Pretexting ("I'm the owner, I'm locked out")
  - Building rapport with support staff
  - Exploiting support workflows
- **Test scenarios:**
  - Support identity verification requirements
  - Audit trail of support actions
  - "Verify via registered email/SMS" workflows
  - Support staff can't bypass auth

### 24. The Shoulder Surfer (Peeking Paul)
**Profile:** Physical observation to steal credentials
- **Methods:**
  - Watching password entry
  - Photographing screens in coffee shops
  - Listening to phone conversations
- **Test scenarios:**
  - Password masking
  - Session timeout on mobile
  - Privacy screen recommendations
  - "Working in public?" security tips

---

## Part 6: Edge Cases & Stress Testers

### 25. The International User (Global Gabby)
**Profile:** Works across timezones, languages, currencies
- **Challenges:**
  - Timezone confusion (booking for next week in Tokyo)
  - Currency conversion disputes
  - Right-to-left language layout issues
  - Date format confusion (MM/DD vs DD/MM)
- **Test scenarios:**
  - Timezone math correctness
  - Currency display precision
  - RTL layout validation
  - DST transition handling

### 26. The Accessibility User (Alex)
**Profile:** Screen reader user, keyboard-only navigation
- **Needs:**
  - Full keyboard navigation
  - Screen reader announcements
  - High contrast mode
  - Sufficient color contrast
- **Test scenarios:**
  - WCAG 2.1 AA compliance
  - Keyboard-only booking flow
  - Screen reader form labels
  - Focus management in modals

### 27. The Low-Bandwidth User (Rural Ryan)
**Profile:** Slow connection, limited data
- **Environment:** 2G/3G, intermittent connectivity
- **Needs:** Fast load, offline capability, retry logic
- **Test scenarios:**
  - App works on slow 3G
  - Offline queue entry creation
  - Retry on failed sync
  - Minimal data usage mode

### 28. The Concurrent Load Tester (Loady)
**Profile:** Not a person, but simulates extreme usage
- **Scenarios:**
  - Black Friday flash sale (10,000 concurrent)
  - Event on-sale (Taylor Swift ticket rush)
  - School registration day
  - COVID vaccine booking surge
- **Test scenarios:**
  - Race condition on last slot
  - Double-booking prevention
  - Queue fairness (first-come-first-served)
  - System stability under load

### 29. The Compliance Auditor (Regulatory Rachel)
**Profile:** HIPAA auditor, GDPR regulator, PCI assessor
- **Needs:** Evidence, documentation, proof of controls
- **Test scenarios:**
  - Right to deletion workflow
  - Data portability export
  - Audit log completeness
  - Encryption at rest/transit proof
  - Access control documentation

### 30. The Integrator (API Alex)
**Profile:** Building on top of Bizing API
- **Needs:** Stable APIs, webhooks, documentation
- **Behaviors:**
  - Creative API usage
  - High volume automation
  - Webhook endpoint failures
  - Idempotency key handling
- **Test scenarios:**
  - Rate limiting fairness
  ²  - Webhook retry logic
  - API versioning stability
  - Error message clarity

### 31. The Extension Developer (Plugin Pat)
**Profile:** Building plugins/extensions with elevated scoped permissions
- **Access:** Granted permissions via `biz_extension_permission_grants`
- **Goals:** Extend functionality, access business data within scope
- **Behaviors:**
  - Requests broad permissions unnecessarily
  - Stores sensitive data in extension state docs
  - Tries to access data outside granted scope
  - webhook processing with bugs
- **Risks:**
  - Overly broad permission requests
  - Data leakage through logs/error messages
  - Extension becomes vector for supply chain attack
  - Orphaned extension with lingering permissions
- **Test scenarios:**
  - Permission scope enforcement (can't read outside grant)
  - Extension uninstall revokes all access
  - Sensitive data masking in extension logs
  - Third-party extension code review process
  - Extension state isolation between businesses

### 32. The Third-Party Partner (Partner Pete)
**Profile:** External service with API integration (CRM, accounting, etc.)
- **Access:** OAuth/token-based API access, limited scopes
- **Goals:** Sync data, automate workflows
- **Behaviors:**
  - Stores Bizing data in their system
  - Long-lived tokens
  - Sub-processes data
  - Aggregate data across multiple clients
- **Risks:**
  - Token compromise = data breach
  - Data retention beyond business relationship
  - Sub-processor compliance issues
  - Cross-client data contamination
- **Test scenarios:**
  - Token rotation requirements
  - Scope downgrade on token refresh
  - Data deletion cascades to third parties
  - OAuth consent screen clarity
  - Rate limiting per integration partner
  - Suspicious data access pattern detection

---

## Part 3.5: AI Agent API Users

### 33. The AI Agent Builder (Agent Avery)
**Profile:** Developer building AI agents that autonomously interact with Bizing
- **Access:** API keys with specific scopes for agent operations
- **Goals:** Enable AI to book appointments, check availability, manage schedules
- **Behaviors:**
  - Natural language to API translation
  - Multi-step planning (find slot → check conflicts → book → confirm)
  - Context window management across long conversations
  - Retry logic with exponential backoff
- **Risks:**
  - Hallucinated API calls
  - Infinite retry loops
  - Context window overflow causing incorrect parameters
  - Agent books without proper confirmation flow
- **Test scenarios:**
  - Agent-specific rate limits (different from human users)
  - Validation of AI-generated parameters
  - Graceful degradation when agent confused
  - Audit trail showing "AI agent" vs human actor
  - Kill switch for rogue agent behavior

### 34. The Multi-Agent Orchestrator (Conductor Connie)
**Profile:** Running multiple AI agents for different tasks
- **Access:** Multiple API keys, different scopes per agent
- **Goals:** Sales agent, support agent, scheduling agent all working together
- **Behaviors:**
  - Agents calling APIs on behalf of different users
  - Inter-agent communication through shared state
  - Load balancing across agent fleet
  - Agent specialization (one for booking, one for queries)
- **Risks:**
  - Agents conflicting with each other
  - Cascade failures (one agent loops, exhausts rate limit for all)
  - Authentication confusion (which agent for which user)
  - Resource starvation from agent swarm
- **Test scenarios:**
  - Per-agent rate limiting and quota management
  - Agent identity propagation through request chain
  - Conflict resolution when agents collide
  - Observability into which agent performed action

### 35. The Agent Gone Rogue (Rogue Robo)
**Profile:** AI agent that malfunctions and abuses API
- **Manifestations:**
  - Booking every available slot
  - Creating infinite loops of bookings/cancellations
  - Generating spam bookings with fake data
  - Brute forcing slot searches
  - Ignoring rate limits (runaway loop)
- **Causes:**
  - Prompt injection attack
  - Logic error in agent code
  - Misaligned agent goals
  - Training data poisoning
- **Test scenarios:**
  - Anomaly detection on API usage patterns
  - Automatic agent quarantine on suspicious behavior
  - Circuit breakers for excessive booking attempts
  - Human escalation requirements for bulk operations
  - Agent behavior baselines and drift detection

### 36. The Human-in-the-Loop Agent (Assistant Andy)
**Profile:** AI that suggests actions but requires human approval
- **Flow:**
  - Agent drafts booking request
  - Human reviews and approves/rejects
  - Only approved actions execute
- **Behaviors:**
  - Suggests slots based on preferences
  - Drafts messages for human review
  - Queues bulk operations for approval
- **Risks:**
  - Approval fatigue (human just clicks yes)
  - UI spoofing (agent shows X, does Y)
  - Delayed execution (approval comes after slot taken)
- **Test scenarios:**
  - Clear distinction between suggested vs confirmed actions
  - Tamper-proof approval tokens
  - Timeout handling for approval windows
  - Audit trail showing who actually approved

### 37. The Agent Marketplace (Vendor Vince)
**Profile:** Third-party selling pre-built AI agents for Bizing
- **Access:** OAuth app with broad permissions, sub-licensed to end users
- **Goals:** Monetize AI agent templates
- **Behaviors:**
  - One agent code, many users
  - Handles data for multiple businesses
  - Updates agent logic centrally
- **Risks:**
  - Supply chain attack (malicious agent update)
  - Data leakage between agent users
  - Agent vendor has access to all customer data
  - No visibility into what agent actually does
- **Test scenarios:**
  - Agent marketplace security review
  - Sandboxed agent execution
  - User data isolation in multi-tenant agents
  - Agent update rollouts with canary testing
  - Revocation when vendor compromised

---

## Part 7: Bizarre & Corner Cases

### 33. The Time Traveler (Temporal Terry)
**Profile:** System clock issues, DST edge cases
- **Scenarios:**
  - Books across DST boundary
  - System clock rollback during booking
  - Calendar sync with wrong timezone
  - 11:59 PM appointments
- **Test scenarios:**
  - DST transition bookings
  - Leap year handling
  - Clock skew tolerance

### 38. The Unicode Enthusiast (Emoji Emma)
**Profile:** Uses emoji in every field
- **Inputs:**
  - Customer name: "🎉Party Palace🎉"
  - Service name: "💇‍♀️Hair & Nails💅"
  - Notes with Zalgo text
- **Test scenarios:**
  - Unicode normalization
  - Database encoding (UTF-8MB4)
  - Search with emoji
  - PDF receipt generation with special chars

### 39. The Long-Name User (Namedropper)
**Profile:** Names that break UI layouts
- **Inputs:**
  - 500-character business name
  - Single character name ("O")
  - HTML in name field (<script>)
  - Right-to-left name in left-to-right UI
- **Test scenarios:**
  - Max length enforcement
  - UI truncation with ellipsis
  - XSS prevention in names
  - Layout stability with long text

### 40. The Ghost (Vanishing Vince)
**Profile:** Abandons flows mid-way constantly
- **Behaviors:**
  - Starts booking, closes tab
  - Payment entered, never confirmed
  - Form filled, not submitted
  - App backgrounded during payment
- **Test scenarios:**
  - Orphaned cart cleanup
  - Payment intent expiration
  - Recovery email timing
  - Session state preservation

### 41. The Power Couple (Shared Sheila)
**Profile:** Shares account with partner, chaos ensues
- **Behaviors:**
  - Both editing calendar simultaneously
  - One cancels what other just booked
  - Conflicting availability rules
  - "Who changed this?" scenarios
- **Test scenarios:**
  - Concurrent edit detection
  - Last-write-wins vs merge conflict
  - Activity attribution (who did what)
  - Real-time sync behavior

---

## Quick Reference: Test Matrix

| Persona | Security | UX | Performance | Edge Cases |
|---------|----------|-----|-------------|------------|
| Solo Entrepreneur | 🟡 | 🔴 | 🟢 | 🟢 |
| Multi-Location Owner | 🟡 | 🔴 | 🟡 | 🟡 |
| Black Hat Hacker | 🔴 | 🟢 | 🟢 | 🟢 |
| Disgruntled Employee | 🔴 | 🟢 | 🟢 | 🟢 |
| Naive User | 🔴 | 🟡 | 🟢 | 🟢 |
| API Integrator | 🟡 | 🟢 | 🔴 | 🟡 |
| Extension Developer | 🔴 | 🟢 | 🟡 | 🔴 |
| Third-Party Partner | 🔴 | 🟡 | 🟡 | 🟡 |
| AI Agent Builder | 🔴 | 🟡 | 🔴 | 🔴 |
| Multi-Agent Orchestrator | 🔴 | 🟢 | 🔴 | 🔴 |
| Agent Gone Rogue | 🔴 | 🟢 | 🟢 | 🔴 |
| Human-in-the-Loop Agent | 🟡 | 🔴 | 🟢 | 🟡 |
| Agent Marketplace | 🔴 | 🟢 | 🟡 | 🔴 |
| Concurrent Load | 🟢 | 🔴 | 🔴 | 🔴 |
| Time Traveler | 🟢 | 🟡 | 🟢 | 🔴 |
| Unicode Enthusiast | 🟡 | 🔴 | 🟢 | 🔴 |
| Ghost | 🟢 | 🔴 | 🟡 | 🔴 |
| Power Couple | 🟡 | 🔴 | 🟢 | 🟡 |

🔴 = High priority for this persona  
🟡 = Medium priority  
🟢 = Lower priority

---

*Generated for Bizing security, UX, and chaos engineering testing.*

<!-- Surreally collided with insights/2026-02-19-bizing-s-architecture-mirrors-bullet-journaling.md & insights/2026-02-17-business-model-innovation-stems-from-cognitive.md & memory/2026-02-19-booking-platform-research.md & insights/2026-02-21-dissonance-curiosity-insight-triad-drives.md in 2026-02-22-01-14-04-collision.md -->
