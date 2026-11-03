# SOURCE.md — Data Source Proposals

**Team:** Yoav Keidar, Hili Netz
**Ranking:** 1. Tech Hiring Pulse (preferred) · 2. SaaS Reliability Observatory

---

## 1. Tech Hiring Pulse (preferred)

We will track the job postings of a fixed set of about 20–30 technology companies that publish their openings on Greenhouse job boards (for example, Stripe and Figma). By sampling the boards regularly, we can see which roles are advertised, what experience they require and how long each posting stays open, and compare trends across companies, functions and locations, with particular attention to early-career roles.

| Item | Details |
|---|---|
| **Data content** | For every open posting, the board list gives: job ID, title, location, first-published time, last-update time and posting URL. The single-posting endpoint adds the department, office and full description (which includes the experience requirements); we fetch it once, when a posting first appears. |
| **URL** | Board list: `https://boards-api.greenhouse.io/v1/boards/{board_token}/jobs` (e.g. `https://boards-api.greenhouse.io/v1/boards/stripe/jobs`)<br>Single posting: `https://boards-api.greenhouse.io/v1/boards/{board_token}/jobs/{job_id}` |
| **Update frequency** | Event-driven: companies add, edit and remove postings continuously, mostly on business days. Closed postings disappear from the board, so past states cannot be downloaded later. We plan to sample twice a day (UTC). |
| **Expected sample size** | Board list: Stripe 461 KB (461,214 bytes; 33.2 KB gzipped), 739 postings; Figma 91 KB (91,189 bytes; 7.6 KB gzipped), 144 postings. Single posting with description: 7.6–11.6 KB (2.8–4.3 KB gzipped), four postings measured. Measured on our course VM, 2026-11-03 16:37 UTC. One run over ~25 boards is about 2.3 MB if the boards are Figma-sized and 11.5 MB if they are Stripe-sized (0.19–0.83 MB gzipped). We will measure each selected board. |
| **Storage over the semester** | Assumptions: at most 90 days of collection, two runs a day, and about twice as many distinct postings over the semester as are open at the start, each description fetched once. Board lists: 0.4–2.1 GB raw (34–149 MB gzipped). Descriptions: 69–352 MB raw (26–131 MB gzipped). Total: 0.5–2.4 GB raw, which may exceed the course limit of 500 MB, but 60–280 MB gzipped. We will store each run as one gzipped file (`raw/YYYY-mm-dd/HHMM.json.gz`), which the course rules allow. If the boards we select project above 250 MB gzipped, we will sample once a day. |
| **Limitations** | Covers only companies that use Greenhouse. The board list has no department or description, so these need one more request per posting. A posting's closing time is known only to within one sampling interval (12 hours). A company may close a posting and repost the same role under a new ID. |
| **API key / password** | No. Greenhouse documents its Job Board GET endpoints as public, with no authentication. |

**Sample** — one posting from `https://boards-api.greenhouse.io/v1/boards/stripe/jobs`, retrieved 2026-11-03 16:37 UTC, HTTP 200:

```json
{
  "absolute_url": "https://stripe.com/jobs/search?gh_jid=8172508",
  "data_compliance": [
    {
      "type": "gdpr",
      "requires_consent": false,
      "requires_processing_consent": false,
      "requires_retention_consent": false,
      "retention_period": null,
      "demographic_data_consent_applies": false
    }
  ],
  "education": "education_required",
  "internal_job_id": 3537062,
  "location": {
    "name": "Dublin"
  },
  "metadata": null,
  "id": 8172508,
  "updated_at": "2026-10-29T10:42:09-04:00",
  "requisition_id": "See Opening ID",
  "title": "Abuse Investigator",
  "company_name": "Stripe",
  "first_published": "2026-09-03T13:32:53-04:00",
  "language": "en",
  "application_deadline": null
}
```

---

## 2. SaaS Reliability Observatory

We will track the public status pages of a fixed set of about 15–20 SaaS providers whose pages run on Atlassian Statuspage (for example, GitHub, Confluence and New Relic). By sampling the reported status of each provider and its components, we can measure how often incidents happen, how long they last and how providers differ in reliability.

| Item | Details |
|---|---|
| **Data content** | From the summary: overall status, the status of each component (operational, degraded performance, partial outage or major outage) and open incidents with their impact level and timestamps. From the incident list: recent incidents with their creation and resolution times. |
| **URL** | Current status: `https://{status-page}/api/v2/summary.json` (e.g. `https://www.githubstatus.com/api/v2/summary.json`)<br>Recent incidents: `https://{status-page}/api/v2/incidents.json` |
| **Update frequency** | Event-driven: the status changes whenever a provider posts an update. Incidents are frequent enough to study: GitHub alone reported 2–10 incidents with degraded performance per month in its availability reports from August 2025 to September 2026. The API exposes only the current component status and the last 50 incidents, so a fine-grained history exists only if we record it. We plan to download `summary.json` every 30 minutes and `incidents.json` once a week (UTC). The last 50 incidents went back 73 days on GitHub and more than a year on Confluence and New Relic, so for these providers a weekly download misses none; we will check this for each selected provider. |
| **Expected sample size** | `summary.json`, with no open incidents: GitHub 4.3 KB (4,310 bytes; 1.1 KB gzipped; 12 components), Confluence 5.5 KB (1.2 KB gzipped; 16 components), New Relic 38.5 KB (4.7 KB gzipped; 115 components). `incidents.json`: 274–574 KB (34–59 KB gzipped). Measured on our course VM, 2026-11-03 16:37 UTC. One run over ~20 providers is about 86 KB if all pages are GitHub-sized and 322 KB at the average of the three pages (22–47 KB gzipped). The summary grows while incidents are open, because it then includes their updates. |
| **Storage over the semester** | Assumptions: at most 90 days of collection, 48 runs a day and one `incidents.json` download per provider per week. Total: 0.5–1.5 GB raw, which may exceed the course limit of 500 MB, but 110–215 MB gzipped. Sampling every 15 minutes would raise the gzipped upper estimate to about 420 MB, too close to the limit, so we sample every 30 minutes. We will store each run as one gzipped file (`raw/YYYY-mm-dd/HHMM.json.gz`), which the course rules allow. |
| **Limitations** | The data shows what providers choose to report, not independently measured availability. Providers define their components differently, which limits direct comparison. A component's status change is known only to within one sampling interval (30 minutes). |
| **API key / password** | No. Statuspage documents these endpoints as public, with no authentication. |

**Sample** — excerpt (page, overall status, first two components, open incidents — none at retrieval time) from `https://www.githubstatus.com/api/v2/summary.json`, retrieved 2026-11-03 16:37 UTC, HTTP 200:

```json
{
  "page": {
    "id": "kctbh9vrtdwd",
    "name": "GitHub",
    "url": "https://www.githubstatus.com",
    "time_zone": "Etc/UTC",
    "updated_at": "2026-11-03T15:59:27.076Z"
  },
  "status": {
    "indicator": "none",
    "description": "All Systems Operational"
  },
  "components": [
    {
      "id": "8l4ygp009s5s",
      "name": "Git Operations",
      "status": "operational",
      "created_at": "2017-01-31T20:05:05.370Z",
      "updated_at": "2026-10-07T15:49:53.270Z",
      "position": 1,
      "description": "Performance of git clones, pulls, pushes, and associated operations",
      "showcase": true,
      "start_date": null,
      "group_id": null,
      "page_id": "kctbh9vrtdwd",
      "group": false,
      "only_show_if_degraded": false
    },
    {
      "id": "4230lsnqdsld",
      "name": "Webhooks",
      "status": "operational",
      "created_at": "2019-11-13T18:00:24.256Z",
      "updated_at": "2026-10-30T18:32:39.707Z",
      "position": 2,
      "description": "Real time HTTP callbacks of user-generated and system events",
      "showcase": true,
      "start_date": null,
      "group_id": null,
      "page_id": "kctbh9vrtdwd",
      "group": false,
      "only_show_if_degraded": false
    }
  ],
  "incidents": []
}
```
