---
title: "Niche: Privacy-First Analytics"
category: business research
date: 2026-01-07
tags: [analytics, privacy, saas, plausible, fathom, self-serve, hipaa, competitor-research]
status: researched
---

# Privacy-First Analytics

## Why This Niche?

Applies Telegram patterns:
- **Anti-incumbent positioning**: Google Analytics is the enemy (illegal in parts of EU)
- **Trust as moat**: Privacy-first = credibility
- **Self-serve**: Add script → see data in 60 seconds

---

## Market Opportunity

- 86% of US population concerned about data privacy
- 40% don't trust companies with their data
- Google Analytics illegal in Austria, France, Italy (GDPR violations)
- Cookie consent fatigue driving cookieless solutions

---

## Competitor Deep Dive (Updated 2026-01-07)

### Plausible Analytics - Market Leader

**Current Status (2024-2025):**
- **$3.1M ARR** in 2024 (up from $2.1M in 2023)
- **$300K+ MRR**
- 8 employees, 1,540 customers
- 73 billion pageviews tracked
- Bootstrapped, no VC funding (actively rejects offers)

**Growth trajectory:**
- $4.8K (2020) → $276K (2021) → $1.2M (2022) → $2.1M (2023) → $3.1M (2024)

**Key strengths:**
- Open-source (builds trust)
- Google Search Console integration (unique)
- Self-hosted option identical to cloud
- 45x smaller script than GA

### Full Competitor Comparison

| Tool | Revenue | Team | Pricing | Unique Angle |
|------|---------|------|---------|--------------|
| **Plausible** | $3.1M ARR | 8 | $9-14/mo | Open-source, GSC integration |
| **Fathom** | Profitable | Small | Mid-tier | Uptime monitoring built-in |
| **Simple Analytics** | ~$65K ARR | Small | Most expensive | AI chat feature, custom domain |
| **Umami** | Free/Cloud $20/mo | Small | Self-host free | Best self-hosted, city-level geo |

---

## User Complaints & Feature Gaps

### Plausible Complaints
- Dashboard locked when exceeding pageview limits (billing friction)
- No heatmaps or scroll depth
- Can't track returning visitors (privacy trade-off)
- Documentation outdated in places
- No path/flow tracking
- Can't exclude own IP easily

### Fathom Complaints
- Too minimalistic, limited features
- No user flow tracking
- Limited event tracking & goals
- UI less intuitive
- Can't migrate GA events
- No heatmaps

### Common Gaps Across ALL Competitors
- **No heatmaps** (privacy-friendly version doesn't exist)
- **No session recordings**
- **Limited funnel analysis**
- **Basic reporting only**
- **No advanced segmentation**

---

## HIPAA/Healthcare Opportunity

### Current Landscape
- Google Analytics explicitly **does not support HIPAA** and won't sign BAAs
- 6 of top 10 US hospitals still using GA despite compliance risk
- HHS guidance on tracking technologies updated March 2024

### HIPAA-Compliant Options (All Enterprise-Priced)
- Piwik PRO (SOC-2 Type II certified)
- Freshpaint (healthcare-focused, expensive)
- PostHog (requires BAA, complex)
- Matomo (self-hosted only)

### GAP: No simple, affordable HIPAA-compliant analytics for small healthcare practices

---

## Platform-Specific Opportunity

| Platform | Status | Opportunity |
|----------|--------|-------------|
| **Framer** | Has built-in privacy analytics | Low (native solution exists) |
| **Webflow** | Still relies on GA4 + complex integrations | HIGH |
| **Shopify** | Analytics focuses on e-commerce events | Medium |
| **Ghost** | Basic built-in, users want more | Medium |

---

## Identified Opportunities (Ranked)

| Opportunity | Why | Competition | Difficulty | Potential |
|-------------|-----|-------------|------------|-----------|
| **HIPAA analytics for small practices** | Big players ignore SMB healthcare | Low | Medium-High | HIGH |
| **Webflow-native privacy analytics** | No good solution exists | Very Low | Low | Medium |
| **Privacy analytics + heatmaps** | Everyone requests, no one offers | None | High (technical) | HIGH |
| **Analytics + error tracking bundle** | Adjacent need, same audience | Medium | Medium | Medium |
| **White-label for agencies** | Agencies need client dashboards | Low | Low | Medium |

---

## Self-Serve Fit Analysis

| Criteria | Score | Notes |
|----------|-------|-------|
| Onboarding time | ⭐⭐⭐⭐⭐ | Copy script, paste, done (60 sec) |
| No sales needed | ⭐⭐⭐⭐⭐ | Developers find via SEO/HN/Reddit |
| Price point | ⭐⭐⭐⭐⭐ | $9-19/mo = no approval needed |
| Viral potential | ⭐⭐⭐ | Word of mouth, not built-in viral |
| Recurring revenue | ⭐⭐⭐⭐⭐ | Monthly SaaS, low churn |

---

## Technical Considerations

**Stack options:**
- Clickhouse for analytics data (what Plausible uses)
- PostgreSQL for smaller scale (what Umami uses)
- Edge functions for lightweight tracking
- Simple dashboard (React/Vue)

**MVP scope:**
- Pageviews, visitors, referrers, top pages
- One-line embed script
- Real-time dashboard
- GDPR-compliant by default

**Differentiation ideas:**
- Faster/lighter script than competitors
- Better UI/UX
- Specific platform integrations
- AI-powered insights ("your traffic dropped because...")
- Privacy-friendly heatmaps (technical challenge)

---

## Go-to-Market Ideas

1. **SEO**: "Plausible alternative", "[Platform] analytics", "GDPR analytics", "HIPAA analytics"
2. **Communities**: Indie Hackers, Hacker News, r/webdev
3. **Product Hunt**: Proven channel for this category
4. **Content**: "Why I switched from GA4" blog posts
5. **Webflow/platform communities**: If going platform-specific route

---

## Research Questions - Status

- [x] What's Plausible's current MRR? → **$300K+ MRR, $3.1M ARR**
- [x] What features do Plausible users complain about missing? → **Heatmaps, returning visitors, path tracking, IP exclusion**
- [x] Which platforms have most demand? → **Webflow highest opportunity (Framer has native)**
- [x] What compliance certifications matter most? → **HIPAA for healthcare, SOC2 for B2B**
- [ ] What's the CAC for this market? (SEO vs paid)
- [ ] Exact technical requirements for HIPAA compliance

---

## Sources

- [Plausible $3.1M Revenue - Latka](https://getlatka.com/companies/plausible-analytics)
- [Plausible $300K+ MRR - Startup Spells](https://startupspells.com/p/plausible-analytics-hacker-news-playbook)
- [Plausible Open Source SaaS Journey](https://plausible.io/blog/open-source-saas)
- [Plausible Reviews - Capterra](https://www.capterra.com/p/187430/Plausible-Insights/reviews/)
- [Fathom Reviews - G2](https://www.g2.com/products/fathom-analytics/reviews)
- [Privacy Analytics Comparison - Mida](https://www.mida.so/blog/simple-analytics-vs-plausible-vs-umami-vs-piwik-pro-vs-fathom-analytics)
- [HIPAA Analytics Tools - PostHog](https://posthog.com/blog/best-hipaa-compliant-analytics-tools)
- [HIPAA Analytics Platforms - Piwik PRO](https://piwik.pro/blog/hipaa-compliant-web-analytics-platforms/)
- [Umami Self-Hosting](https://umami.is/docs)
- [Indie Hackers - Plausible vs Fathom](https://www.indiehackers.com/post/fathom-analytics-vs-the-competition-23c5a99300)
- [Secureframe - Data Privacy Statistics](https://secureframe.com/blog/data-privacy-statistics)

---

## Next Steps

- [ ] Deep dive on HIPAA opportunity (market size, requirements, pricing)
- [ ] Validate Webflow-specific demand (search volume, forum posts)
- [ ] Research privacy-friendly heatmap technical feasibility
- [ ] Calculate unit economics for different sub-niches
- [ ] Sketch MVP feature set for chosen opportunity

---

## Session Log

**2026-01-07**: Initial research - identified niche, mapped existing players, outlined sub-niche ideas

**2026-01-07**: Competitor deep dive - researched Plausible ($3.1M ARR), Fathom, Simple Analytics, Umami. Identified user complaints (no heatmaps, no returning visitors, limited funnels). Discovered HIPAA gap for small healthcare. Ranked 5 opportunities.
