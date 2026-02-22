---
date: 2026-02-17
tags:
  - research
  - schema
  - analysis
  - paradigm-shift
  - v2
---

# Feature Space Analysis: Schema Breaking Points & Paradigm Shifts

> Analysis of ~165 features from feature space catalog against current schema design

---

## Executive Summary

After analyzing the feature space catalog (~165 features), I've identified **10 paradigm shifts** that would break or significantly strain the current schema design.

**Critical Finding:** Current schema supports ~70% of feature space well, but ~30% requires architectural changes.

---

## Feature Space Overview (from research/feature-space.md)

| Priority      | Count | Examples                                         |     |
| ------------- | ----- | ------------------------------------------------ | --- |
| ⭐⭐⭐ Universal | ~30   | Service definition, slots, 1:1 booking, payments |     |
| ⭐⭐ Common     | ~50   | Multiple durations, buffer time, group bookings  |     |
| ⭐ Occasional  | ~40   | Packages, waitlists, payment plans               |     |
| ○ Rare        | ~20   | Video consultation, chatbots                     |     |
| 🔒 Enterprise | ~25   | Multi-brand, HIPAA, franchise                    |     |

---

## Current Schema Strengths (✅ Well Supported)

The current design handles excellently:
- ✅ Core booking flow (1:1 appointments)
- ✅ Multi-location support
- ✅ Provider/asset/venue booking
- ✅ Buffer times
- ✅ Cancellation policies
- ✅ Recurring bookings
- ✅ Dynamic pricing
- ✅ Waitlists
- ✅ Service templates
- ✅ Basic user management

---

## Paradigm Shifts Required

### 1. Hierarchical Multi-Tenancy 🔥 HIGH IMPACT

**Features:** Multi-brand, franchise support, white-label, custom domains

**Current:**
```
Organization → Locations
```

**Required:**
```
Enterprise
├── Brand A (white-label)
│   ├── Custom domain
│   ├── Theming
│   └── Franchisees[]
│       ├── Location 1
│       └── Location 2
└── Brand B
```

**Schema Changes:**
```typescript
interface Brand {
  id: UUID
  enterpriseId: UUID
  theming: { logoUrl, colors, customCss }
  customDomain: string
}

interface Organization {
  id: UUID
  brandId?: UUID           // NEW
  parentOrgId?: UUID       // NEW: Franchisee hierarchy
  type: 'independent' | 'franchisee'
}
```

---

### 2. Hybrid/Simultaneous Modes 🔥 HIGH IMPACT

**Features:** Hybrid appointments, virtual waiting rooms, video consultation

**Current:**
```
Bookable.type: provider | asset | venue | virtual_resource
// Each booking has ONE type
```

**Required:** Delivery Modes instead of types

```typescript
interface DeliveryMode {
  type: 'in_person' | 'virtual' | 'phone' | 'hybrid'
  
  hybridComponents?: {
    primary: 'in_person' | 'virtual'
    secondary: 'in_person' | 'virtual' | 'phone'
    simultaneous: boolean
  }
}

interface Booking {
  deliveryMode: DeliveryMode
  virtualWaitingRoom?: {
    enabled: boolean
    queuePosition: number
  }
}
```

---

### 3. AI/ML Integration Layer 🔥 HIGH IMPACT

**Features:** Smart scheduling, no-show prediction, pricing optimization, route optimization

**Current:** Rule-based pricing only

**Required:** Intelligence layer

```typescript
interface MLModel {
  id: UUID
  type: 'no_show' | 'pricing' | 'scheduling'
  version: string
  metrics: { accuracy, precision, recall }
}

interface Prediction {
  type: 'no_show' | 'optimal_price' | 'demand'
  probability?: number
  modelVersion: string
}

interface ServiceTemplate {
  aiFeatures: {
    noShowPrediction: { enabled, modelId, actionThreshold }
    dynamicPricing: { enabled, modelId, strategy }
    smartScheduling: { enabled, suggestOptimalTimes }
  }
}
```

---

### 4. Channel Abstraction 🔥 MEDIUM-HIGH IMPACT

**Features:** Telegram bot, Facebook Messenger, Instagram DM, embeddable widgets, WhatsApp

**Current:** Single API/web entry point

**Required:**

```typescript
interface Channel {
  id: UUID
  type: 'web' | 'widget' | 'telegram' | 'facebook' | 'instagram' | 'whatsapp' | 'phone_ivr'
  capabilities: {
    supportsPayments: boolean
    supportsFileUpload: boolean
    supportsRealTime: boolean
  }
}

interface Booking {
  channelId: UUID                    // Origin channel
  channelData: {                    // Channel-specific data
    instagramUserId?: string
    telegramChatId?: string
    callerPhoneNumber?: string
  }
}
```

---

### 5. Post-Booking Workflow Engine 🔥 MEDIUM IMPACT

**Features:** Service retake/revision policies, follow-up sequences, review collection

**Current:** Booking ends at 'completed'

**Required:**

```typescript
interface PostBookingWorkflow {
  id: UUID
  serviceTemplateId: UUID
  triggers: { on: 'booking_completed', delay: { days: 7 } }
  steps: WorkflowStep[]
}

interface WorkflowStep {
  type: 'send_email' | 'request_review' | 'schedule_follow_up'
  config: { templateId, recipient, incentive }
}

interface RetakePolicy {
  eligibility: { withinDays: 30, requiresReason: boolean }
  terms: { freeRetake: boolean, maxRetakes: 2 }
}
```

---

### 6. Family/Multi-User Accounts 🔥 MEDIUM IMPACT

**Features:** Parent portals, booking for dependents, household accounts

**Current:** Single user = single booker

**Required:**

```typescript
interface Household {
  id: UUID
  name: string
  members: HouseholdMember[]
  sharedPaymentMethods: UUID[]
}

interface HouseholdMember {
  userId: UUID
  role: 'primary' | 'adult' | 'minor' | 'dependent' | 'caregiver'
  permissions: {
    canBookForOthers: boolean
    canViewOthersBookings: boolean
    approvalRequiredFor: string[]
  }
}

interface Booking {
  beneficiaryId: UUID               // Who service is FOR
  bookedOnBehalfOf: UUID?          // Who made booking
}
```

---

### 7. True Product + Service Hybrid 🔥 MEDIUM IMPACT

**Features:** Inventory management, shipping tracking, product fulfillment

**Current:** Upsells are simple add-ons

**Required:**

```typescript
interface Product {
  id: UUID
  type: 'physical' | 'digital' | 'subscription'
  inventory: {
    trackInventory: boolean
    quantityOnHand: number
    reorderPoint: number
  }
  fulfillment: {
    type: 'shipping' | 'pickup' | 'digital_delivery'
  }
}

interface Booking {
  productItems: [{
    productId: UUID
    quantity: number
    shippingStatus: 'pending' | 'shipped' | 'delivered'
    trackingNumber?: string
  }]
}
```

---

### 8. Real-Time Collaboration 🔥 MEDIUM IMPACT

**Features:** Virtual waiting rooms, live video, screen sharing, whiteboards

**Current:** Static booking data

**Required:**

```typescript
interface ActiveSession {
  id: UUID
  bookingId: UUID
  status: 'waiting' | 'in_progress' | 'completed'
  
  participants: [{
    userId: UUID
    status: 'joined' | 'disconnected'
    cameraOn: boolean
    screenSharing: boolean
  }]
  
  waitingRoom: {
    enabled: boolean
    queue: { userId: UUID }[]
  }
  
  features: {
    video: boolean
    screenShare: boolean
    whiteboard: boolean
    recording: boolean
  }
}
```

---

### 9. Advanced Resource Optimization 🔥 MEDIUM IMPACT

**Features:** Equipment maintenance tracking, vehicle fleet management, load balancing

**Current:** Simple asset maintenance

**Required:**

```typescript
interface Asset {
  maintenance: {
    scheduled: MaintenanceTask[]
    conditionBased: { enabled, sensors: string[] }
    predictive: { enabled, modelId }
  }
  
  utilizationTarget: {
    minUtilizationPercent: number
    maxUtilizationPercent: number
  }
}

interface ResourcePlan {
  id: UUID
  horizon: { startDate, endDate }
  resources: { assetId, availableHours }[]
  optimization: {
    objective: 'minimize_cost' | 'maximize_utilization'
    constraints: { maxOvertime }
  }
}
```

---

### 10. White-Label Theming 🔥 LOW-MEDIUM IMPACT

**Features:** Complete brand customization, custom domains, remove "Powered by Bizing"

**Current:** Single UI for all

**Required:**

```typescript
interface Brand {
  theming: {
    colors: { primary, secondary, accent }
    typography: { headingFont, bodyFont }
    logo: { lightModeUrl, darkModeUrl }
    customCss: string
  }
  
  domain: {
    customDomain: string
    sslType: 'managed' | 'bring_your_own'
  }
  
  content: {
    appName: string
    terminology: { booking: string, provider: string }
  }
  
  whiteLabel: {
    removePoweredBy: boolean
    customFooter?: string
  }
}
```

---

## Summary Table

| # | Paradigm Shift | Impact | Unlocks |
|---|----------------|--------|---------|
| 1 | Hierarchical Multi-Tenancy | HIGH | Multi-brand, franchise, white-label |
| 2 | Hybrid Delivery Modes | HIGH | Virtual+physical simultaneous |
| 3 | AI/ML Integration | HIGH | Smart scheduling, predictions |
| 4 | Channel Abstraction | MED-HIGH | All messaging bots, widgets |
| 5 | Post-Booking Workflows | MEDIUM | Retakes, follow-ups, reviews |
| 6 | Family/Multi-User | MEDIUM | Parent portals, dependents |
| 7 | Product+Service Hybrid | MEDIUM | Inventory, shipping, fulfillment |
| 8 | Real-Time Collaboration | MEDIUM | Video, waiting rooms, screenshare |
| 9 | Resource Optimization | MEDIUM | Predictive maintenance, planning |
| 10 | White-Label Theming | LOW-MED | Custom domains, full branding |

---

## Recommended Schema Evolution

### v1.0 (Current) — Core
✅ ~70% of feature space
- Core booking, payments, notifications
- Standard features (⭐⭐⭐ + ⭐⭐)

### v1.5 — Extended
+ #10 (White-label theming)
+ #5 (Post-booking workflows)
- Supports: White-label ready, retake policies

### v2.0 — Enterprise  
+ #1 (Multi-tenancy)
+ #6 (Family accounts)
+ #7 (Product hybrid)
- Supports: Franchise, households, inventory

### v2.5 — AI-Powered
+ #3 (AI/ML layer)
+ #9 (Resource optimization)
- Supports: Predictions, smart scheduling

### v3.0 — Omni-Channel
+ #2 (Hybrid modes)
+ #4 (Channel abstraction)
+ #8 (Real-time)
- Supports: All channels, video collaboration

---

*Analysis complete. See v2 schema design reference for implementation details.*
