# Tech Hiring Pulse — SOURCE.md

**Team:** Yoav Keidar, Hili Netz

## 1. Data Source

For our project, we chose to follow job postings from technology companies.

We use the Greenhouse Job Board API, which lets us collect publicly available job openings from companies that use Greenhouse.

Our list currently includes 54 companies and 55 job boards. DoorDash has two separate boards in our list.

The API address is:

`https://boards-api.greenhouse.io/v1/boards/{board_token}/jobs`

We use `curl` to request the data and receive the results in JSON format. We do not need an API key or login.

We chose this source because job postings change over time. Companies can add new positions, update existing ones or remove them. By collecting the data on different days, we can compare these changes instead of looking only at the current situation.

## 2. Data Collection

We started collecting data on November 17, 2026.

For the first collection, we saved 55 API responses and 55 metadata files, for a total of 110 files. The files were compressed and stored under `raw/2026-11-17/`.

For the following days, we used a Bash script called `collect_snapshot.sh` to collect the boards and save each daily snapshot as one compressed JSONL file.

The snapshots from November 18, 19 and 20 were saved as:

- `raw/2026-11-18/0849.jsonl.gz`
- `raw/2026-11-19/0831.jsonl.gz`
- `raw/2026-11-20/0859.jsonl.gz`

The script goes through our board list and uses `curl` to request the job postings from each board.

We use UTC for the collection times and file names, as required by the course.

We keep the previous snapshots because we want to compare the data over time. We do not edit the files after they are saved.

## 3. Planned Dataset Schema

Later in the project, we will organize the collected information into one table.

Our current plan is to use one row for each job posting in each snapshot.

These are the fields we plan to include:

| Column | Type | Description |
|---|---|---|
| snapshot_utc | Text / DateTime | When we collected the data |
| ticker | Text | Company ticker or identifier |
| board_token | Text | Greenhouse board identifier |
| job_id | Text | Job posting ID |
| title | Text | Name of the position |
| location | Text | Location of the job |
| first_published | Text / DateTime | When the job was first published, if available |
| updated_at | Text / DateTime | Last update time, if available |
| job_url | Text | Link to the job posting |

This is our planned schema. We may need to make small changes when we start combining the raw files into a single dataset.

Some fields may be missing for certain job postings. We will keep those values missing rather than filling them with estimated information.

## 4. Why We Chose These Fields

We selected these fields because they can help us compare job postings between companies and over time.

The company identifier tells us which company published the position.

The job ID is especially important because it allows us to recognize the same posting in different snapshots. This way, we can see if a posting is new, still available or no longer listed.

The title and location can help us compare different types of jobs and the countries or cities where companies are recruiting.

Publication and update dates may help us understand when a position was published or changed, when that information is available.

We also keep the collection time because it tells us when we actually observed the posting.

## 5. Mapping the Raw Data

The Greenhouse API returns JSON data, so we will need to extract specific fields when building our dataset.

For example, the API returns a list of jobs inside the `jobs` field.

Our planned mapping is:

| Dataset Column | API Field |
|---|---|
| job_id | jobs[].id |
| title | jobs[].title |
| location | jobs[].location.name |
| first_published | jobs[].first_published |
| updated_at | jobs[].updated_at |
| job_url | jobs[].absolute_url |

The company identifier, board token and collection time come from our collection process rather than directly from the job posting.

The exact mapping will also depend on the structure of our saved snapshot files. We will check this before writing the normalization script.

We also need to distinguish between a board that has no open positions and a request that failed. These are not the same thing, and we do not want a technical error to affect our results.

## 6. Data Size and Limitations

One of the main limitations of this project is the 500 MB storage limit.

Before starting the full collection, we tested individual Greenhouse boards, including Stripe and Figma, to understand the size and structure of the responses.

The first full snapshot, collected on November 17, was approximately 12 MB.

Our later snapshots were also around 11 MB each. For example, the November 20 file was 11,051,928 bytes, or about 11.05 MB.

If future snapshots remain around this size, 30 snapshots would require approximately 332 MB, and 40 snapshots would require approximately 442 MB.

This means we need to be careful with how often we collect data. We will monitor the file sizes and may need to change the collection frequency or compression method to stay within the limit.

There are also limitations in the data itself.

Greenhouse shows job advertisements, not actual hiring results. If a company publishes ten positions, it does not mean that ten employees were hired.

A position can also appear in several snapshots, so we cannot count every appearance as a new job.

Another limitation is that not all technology companies use Greenhouse. Our dataset only represents the companies and boards that we selected.

Our goal is to use the snapshots to understand changes in advertised job openings over time, while keeping these limitations in mind.
