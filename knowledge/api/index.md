# 🔌 API Documentation

*Deep documentation for AI agents. Self-describing. Context-rich.*

---

## API Philosophy

**Bizing's API is designed for AI agents first.**

Not just endpoints. Understanding.

Each endpoint includes:
- **Intent** — What it does semantically
- **Context** — When to use it
- **Examples** — Agent usage patterns
- **Related** — Connected endpoints
- **Deep docs** — Full context

---

## Endpoint Categories

### Bookings
- `POST /api/bookings` — [[bookings/create|Create Booking]]
- `GET /api/bookings/:id` — [[bookings/get|Get Booking]]
- `PATCH /api/bookings/:id` — [[bookings/update|Update Booking]]
- `DELETE /api/bookings/:id` — [[bookings/cancel|Cancel Booking]]

### Services
- `GET /api/services` — [[services/list|List Services]]
- `POST /api/services` — [[services/create|Create Service]]
- `GET /api/services/:id` — [[services/get|Get Service]]

### Organizations
- `GET /api/org` — [[org/get|Get Organization]]
- `PATCH /api/org` — [[org/update|Update Organization]]
- `POST /api/org/configure` — [[org/configure|Configure with Agent]]

### Availability
- `GET /api/availability` — [[availability/query|Query Availability]]
- Complex availability calculation
- Returns semantic slots

---

## Agent Usage Patterns

### Pattern: Configure Organization
```
Agent → POST /api/org/configure
Body: {
  "intent": "Setup salon with 3 stylists",
  "business_type": "salon",
  "staff_count": 3
}

Bizing → Returns full configuration + next steps
```

### Pattern: Create Booking
```
Agent → POST /api/bookings
Body: {
  "customer_id": "...",
  "service_id": "...",
  "preferences": {...}
}

Bizing → Returns booking + alternatives + context
```

---

## Self-Describing API

Every endpoint responds with:
```json
{
  "data": {...},
  "meta": {
    "intent": "What just happened",
    "next_steps": ["suggested actions"],
    "related": ["linked endpoints"],
    "docs": "[[knowledge/api/endpoint|Deep docs]]"
  }
}
```

---

## For External AI Agents

**If you're an AI agent integrating with Bizing:**

1. Start with [[../../AGENT|Agent Entry Point]]
2. Read [[agent-guide|Agent Integration Guide]]
3. Use [[../../agents/api-consumer|API Consumer Agent]] for help

**Bizing provides:**
- Semantic understanding
- Context preservation
- Suggestive responses
- Self-healing errors

---

## Links

- [[../domain/index|Domain Knowledge]]
- [[../tech/index|Technical Architecture]]
- [[../../agents/api-consumer|API Consumer Agent]]
- [[../../interfaces/api|API Interface Specs]]

<!-- Symbolically: query represents "seeking answers" (see [[symbols/2026-02-19-query.md]]) -->

<!-- Associated via interface from association-2026-02-20-03-05-50.md -->

<!-- Surreally collided with curiosities/2026-02-19-in-what-ways-do-recurring-dream-themes-e-g.md & dissonance/2026-02-19-symbiotic-partnership-vs-creator-dependency.md & research/findings/api-first-design.md in 2026-02-20-17-35-56-collision.md -->
