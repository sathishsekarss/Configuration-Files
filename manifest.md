# Application Manifest: Property Valuation Survey Parsing & Monitoring System

## System Overview
The **Property Valuation Survey Parsing & Monitoring System** is an AI-driven, agentic application designed to automate the parsing, validation, cross-checking, and staleness monitoring of commercial real estate appraisal documents. The platform provides a Human-in-the-Loop (HITL) interface for data validation and utilizes autonomous background agents for fraud prevention and portfolio registry tracking.

---

## Architectural Flow & Lifecycle Workflow

### 1. File Upload & Temporary Staging
* The user uploads an appraisal document (PDF ( preferred ), PNG, JPG, JPEG, XLSX, XLS, DOC, DOCX) via `POST /api/upload` and Only one file can be uploaded at time to prevent the system from stalling.
* The file is stored in a temporary staging directory (`temp/`) with an automated TTL (Time-To-Live) cleanup mechanism.
* An LLM-based extraction pipeline processes the staged file and returns structured appraisal JSON fields to the UI.

### 2. Human-in-the-Loop (HITL) Validation & Editing
* The UI displays the source document preview side-by-side with the extracted JSON fields.  ( Left side is the source document, and the right side is the extracted fields )
* The non-editable `filename` field is automatically bound to the request.
* The user can validate, edit, or correct any extracted survey values before committing.
* **Cancellation Option:**
  * If the user cancels or navigates away, `DELETE /api/cancel-upload` removes the file from `temp/`.
  * If idle for 10 minutes, an automated garbage collection routine purges expired files from `temp/`.

### 3. Agent Execution & Database Persistence
* **Agent 1: Fraud Prevention & Authenticity Verification (Pre-Commit)**
  * Triggered upon user clicking **Save Record** (prior to primary DB insertion).
  * Evaluates the extracted `comparable_sales_references` against historical report records and external reference documents to verify data consistency.
  * Generates an `authenticity_value` in percentage to verify how authentic the uploaded document is.
* **Database Commit & File Relocation:**
  * The validated appraisal record, metadata, and `authenticity_value` are saved to the `appraisals` SQLite database table.
  * The file is moved from `temp/` to the permanent storage folder `appraisal_documents/`.
* **Agent 2: Portfolio Staleness & Engagement Registry Agent (Post-Commit)**
  * Operates as a file-system event watcher on `appraisal_documents/` (using event-driven file notifications rather than continuous memory-intensive polling loops).
  * Upon detection of a newly committed file:
    1. Reads `valuation_date` from the committed record and checks if it exceeds the staleness threshold (e.g., > 365 days).
    2. Queries the `engagement_status_registry` DB/CSV for the report's `verified_status`.
    3. If the record is stale and status is `engagement_active`, it executes an autonomous tool call to update `verified_status` to `reappraisal_ordered`.
    4. Logs all execution details and state updates to the audit log.

---

## API Endpoints Specification

	Post - api/upload - to upload the appraisal file to the system
	GET - api/registry - to fetch the registry details
	GET - api/history - to fetch the previously uploaded details.
	Delete - api/cancel-upload - if the user opts to cancel the uploaed, on calling this api, the appraisal file will be deleted from the temp folder. Or after 10min time, the file will be automatically deleted.
	
	

## User Interface (UI) Architecture

The application UI is built using a lightweight, responsive, single-page navigation framework that delivers a seamless Human-in-the-Loop (HITL) review experience across three dedicated view modules:

### 1. Upload & Review Dashboard (`upload-view`)
* **Interactive Drag-and-Drop Staging Zone:**
  * Accepts PDF, DOC, DOCX, XLS, XLSX, and Image files (`PNG`, `JPG`, `JPEG`).
  * Features visual drag-over states and direct file selector integration.
  * Triggers the asynchronous upload API (`POST /api/upload`) to stage files in `temp/`.
* **Side-by-Side Verification Window:**
  * **Left Panel (Document Preview):** Renders a dynamic, embedded view of the source appraisal file (`iframe` for PDFs, native image elements for photos, and fallback metadata cards for office documents).
  * **Right Panel (Editable Extraction Form):** Populates extracted survey fields returned by the LLM agent:
    * `filename` (Read-only / Non-editable system field)
    * `report_id` (Text)
    * `property_description` (Multiline Text Area)
    * `appraised_value` (Formatted Currency Number)
    * `valuation_date` (ISO Date Picker)
    * `valuation_method` (Text)
    * `capitalization_rate` (Percentage Numeric)
    * `comparable_sales_references` (Comma-separated array input)
* **Action Controls & Life-cycle Triggers:**
  * **Save Record Button:** Initiates Agent 1 (Pre-commit authenticity verification), persists validated survey data to SQLite via `POST /api/commit`, and moves the file to `appraisal_documents/`.
  * **Cancel Button:** Purges the staged file from `temp/` via `DELETE /api/cancel-upload` and resets the dashboard state.
* **Loading & State Feedback:** Full-screen translucent overlay with spinning indicators during active API extraction, agent verification, and commit operations.

### 2. Engagement Status Registry View (`registry-view`)
* **Portfolio Lifecycle Monitoring Table:** Displays real-time status tracking for all appraisal engagements synced with `engagement_status_registry`.
* **Status Badges & Visual Indicator Mapping:**
  * `engagement_active` (Green Badge): Active loan monitoring under staleness checks.
  * `reappraisal_ordered` (Amber Badge): Autonomous follow-up triggered; fresh appraisal pending.
  * `superseded` (Gray Badge): Outdated record replaced by a newer appraisal commit.
  * `loan_paid_off` (Blue Badge): Mortgage fulfilled; valuation monitoring terminated.
  * `property_disposed` (Red Badge): Property offloaded or foreclosed; record archived.
* **Real-time Search & Filtering:** Client-side filtering mechanism allowing users to search records by `report_id`, status code, or lifecycle stage.

### 3. History Log View (`history-view`)
* **Historical Audit Ledger:** A clean, tabular view rendering all successfully validated, parsed, and committed appraisal records fetched via `GET /api/history`.
* **Data Fields Displayed:** `Filename`, `Report ID`, `Property Description`, `Appraised Value ($)`, `Valuation Date`, `Valuation Method`, `Cap Rate (%)`, and `Comparable Sales References`.



## Database schema design:

	Database 1:  Appraisal

	fields:
		- report_id ( primary key/forign key ) - string
		- property_description - string
		- appraised_value - integer
		- valuation_date - date
		- valuation_method - string
		- capitalization_rate - integer
		- comparabble_sales_references - string[]
		- authenticity_value -integer
		- filename - string
		
	Database 2:  registry

	fields:
		- report_id ( primary_key ) - string
		- verified_status - string
		
		
	
### Fallback & Fault-Tolerance Mechanisms

To ensure system resilience and prevent application crashes during runtime, the application implements self-healing initializations and default fallback strategies across storage, database, and agent execution layers:

#### 1. Database Initialization Fallback
* **Automatic SQLite Provisioning:** During application startup (`init_sqlite_db()`), the system checks for the presence of the SQLite database file (`appraisal_system.db`).
* **Schema Recovery:** If the database file or required tables (`appraisals`, `engagement_status_registry`) do not exist, the application executes `CREATE TABLE IF NOT EXISTS` DDL statements to automatically initialize the database schema without throwing runtime connection errors.

#### 2. Agent 1 Authenticity Verification Fallback
* **Default Authenticity Score:** During the pre-commit cross-checking phase executed by Agent 1, if no matching historical records or comparable reference documents are found in the system, the authenticity score/flag defaults to `0` (or `UNVERIFIED_REFERENCES`).
* **Crash Prevention:** This prevents `NoneType` or `KeyError` exceptions when evaluating newly introduced or isolated properties, allowing the execution pipeline to safely proceed without interrupting user workflow.

#### 3. Directory Auto-Creation Strategy
* **Directory Provisioning:** On application startup or prior to file staging operations, the runtime checks for the existence of required workspace directories (`temp/` and `appraisal_documents/`).
* **Dynamic Recovery:** If either directory is missing, the application calls `os.makedirs(folder_path, exist_ok=True)` to dynamically recreate the missing folder paths prior to executing file save, upload, or relocation operations.


## Techn stacks used
	1.  Backend - Python flask framework
	2.  Front-end - HTML, CSS, Vanilla javascript.
	3.  Database - SQLLite


## Libraries used
	1. Pandas library to read the CSV file contents.
	2. OPENAI to connect the LLM models.
	3. JSON, BASE64.
	4. Pydantic