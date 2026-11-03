# SOURCE.md — Data Source Proposals

**Team:** Yoav Keidar, Hili Netz
**Preference:** 1. Tech Hiring Pulse · 2. SaaS Reliability Observatory

All sizes below were measured on our course VM on 2026-11-03 at 16:37 UTC.

## 1. Tech Hiring Pulse (preferred)

We are interested in the tech job market, especially in opportunities for people at the start of their careers. We want to follow the job postings of about 20–30 tech companies that publish their openings on Greenhouse job boards (for example, Stripe and Figma), and see which roles are posted, what experience they ask for, and how the postings change over time.

- **Content:** For each open posting, the board list gives the job ID, title, location, first-published time, last-update time and URL. A second request per posting returns its department, office and full description, which is where the experience requirements are. We fetch that once, when a posting first appears.
- **URL:**
  - Board list: `https://boards-api.greenhouse.io/v1/boards/{board_token}/jobs` (e.g. `https://boards-api.greenhouse.io/v1/boards/stripe/jobs`)
  - One posting: `https://boards-api.greenhouse.io/v1/boards/{board_token}/jobs/{job_id}`
- **Update frequency:** Companies add, edit and remove postings whenever they need to; there is no fixed schedule. The board only shows postings that are open right now, so a posting that has closed can no longer be downloaded. We plan to sample twice a day (UTC).
- **Expected sample size:** Stripe's board list was 461 KB (33 KB gzipped, 739 postings) and Figma's was 91 KB (7.6 KB gzipped, 144 postings). One posting with its description was 7.6–11.6 KB. With ~25 boards, one run is about 2–12 MB, depending on how big the boards are. Over the semester (at most 90 days, two runs a day, and assuming about twice as many postings appear as are open today) this adds up to as much as 2.4 GB raw, but under 300 MB gzipped. We will therefore save each run as one gzipped file, to stay under the course limit of 500 MB.
- **API key / password:** No. The endpoints are public, and our requests worked without any key or login.

**Sample** — the first posting in Stripe's board list:

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

## 2. SaaS Reliability Observatory

We want to follow the public status pages of about 15–20 software services that use Atlassian Statuspage (for example, GitHub, Confluence and New Relic), and check how often they report problems, how long the problems last, and how the services compare.

- **Content:** The overall status, the status of each component (operational, degraded performance, partial outage or major outage) and any open incidents with their impact and times. The incident list also gives recent incidents with their start and resolution times.
- **URL:**
  - Current status: `https://{status-page}/api/v2/summary.json` (e.g. `https://www.githubstatus.com/api/v2/summary.json`)
  - Recent incidents: `https://{status-page}/api/v2/incidents.json`
- **Update frequency:** The status changes whenever a provider posts an update. The API only shows the current status and the last 50 incidents, so a detailed history exists only if we record it ourselves. Problems are frequent enough to study: GitHub's last 50 incidents covered only 73 days (2026-08-21 to 2026-11-03). We plan to download `summary.json` every 30 minutes and `incidents.json` once a week (UTC). For the three providers we checked, the last 50 incidents went back far more than a week, so a weekly download should not miss any.
- **Expected sample size:** With no open incidents, `summary.json` was 4.3 KB for GitHub, 5.5 KB for Confluence and 38.5 KB for New Relic (1.1–4.7 KB gzipped). `incidents.json` was 274–574 KB (34–59 KB gzipped). With ~20 providers, one run is about 86–322 KB (22–47 KB gzipped), and the summary gets bigger while incidents are open. Over the semester (at most 90 days) this adds up to as much as 1.5 GB raw, but about 215 MB gzipped, so we will save each run gzipped as well. We chose 30 minutes rather than 15, because 15 minutes would raise the gzipped estimate to about 420 MB, too close to the 500 MB limit.
- **API key / password:** No. The endpoints are public, and our requests worked without any key or login.

**Sample** — part of GitHub's `summary.json` (page, overall status, the first two components and open incidents; there were none at the time):

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
