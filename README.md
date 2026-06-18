# Johor HR Knowledge Hub

Johor HR Knowledge Hub is a high-fidelity interactive frontend prototype for a centralized HR policy and document management platform. The system allows users to search public HR documents, register and log in, manage profiles, upload and classify documents, use smart search, ask the HR chatbot, receive notifications, and manage saved documents.

This prototype is developed using **Vue.js with JavaScript** and **Vite**.

---

## 1. Project Features

The prototype includes the following main functions:

### Public Portal

* Search HR documents by keyword
* Filter documents by category
* View public document details
* Redirect restricted documents to login/register

### Login and Registration

* User login form
* User registration form
* Password reset form
* Administrator login form
* MFA display and interaction

### Profile and Security

* View user profile
* Edit profile information
* Change notification preference
* Enable or disable MFA
* Request account deactivation

### Document Management

* Upload HR document details
* Save document as draft
* Add uploaded documents to repository
* Review AI classification suggestions
* Approve classification
* Search document repository
* Preview documents
* Archive documents
* Upload new document version

### Smart Support

* Smart document search
* HR chatbot with typed questions
* Suggested chatbot questions
* FAQ section
* Recommended documents
* Save documents into personal collection

### Notifications and Saved Documents

* View notifications
* Mark notifications as read
* Enable or disable notification settings
* Change notification frequency
* View saved documents
* Add personal notes
* Remove saved documents

### Admin Workspace

* View users
* Suspend or reactivate user accounts
* View roles and permissions
* Create new role
* View system activity logs
* Filter logs


---

## 2. GitHub Index Table: Module to Frontend Script Mapping

This table helps lecturers, teammates and reviewers quickly locate the frontend implementation for each functional module in this repository. Because this prototype is built mainly in one Vue file, most module interfaces are implemented in `src/App.vue`, while reusable UI elements are stored in `src/components/`.

## Subsystem 1: User and Access Management
**Developer:** Lee May Yan

| Module | Frontend Script |
|---|---|
| Guest Access Module | • [Public Portal Interface](src/App.vue#L55-L134)<br>• [Search Results Interface](src/App.vue#L135-L175)<br>• [Public Document Details Modal](src/App.vue#L176-L244) |
| User Registration and Login Module | • [User Login Interface](src/App.vue#L284-L317)<br>• [User Registration Interface](src/App.vue#L318-L356)<br>• [Password Reset Interface](src/App.vue#L395-L444)<br>• [MFA Verification Interface](src/App.vue#L303-L311) |
| Profile Management Module | • [User Profile Interface](src/App.vue#L446-L470)<br>• [Edit Profile Form](src/App.vue#L471-L512)<br>• [Notification Preference Settings](src/App.vue#L502-L512)<br>• [Account Deactivation Interface](src/App.vue#L545-L585)<br>• [Change Password Interface](src/App.vue#L588-L630) |
| Role and Permission Control Module | • [Role Management Interface](src/App.vue#L1933-L2007)<br>• [User Account Management Table](src/App.vue#L2009-L2059)<br>• [System Activity Logs Interface](src/App.vue#L2062-L2084) |
| Administrator Authentication Module | • [Administrator Login Interface](src/App.vue#L358-L391)<br>• [Administrator Workspace](src/App.vue#L1854-L1931) |

---

## Subsystem 2: Knowledge and Document Management
**Developer:** Lee Tung Ern

| Module | Frontend Script |
|---|---|
| Document Upload Module | • [Document Upload Interface](src/App.vue#L648-L777) |
| Document Classification and Categorization Module | • [AI Classification Review Interface](src/App.vue#L778-L890)<br>• [Classification Approval Interface](src/App.vue#L842-L887) |
| Document Storage Repository Module | • [Document Repository Table](src/App.vue#L891-L1004)<br>• [Document Audit Trail](src/App.vue#L1139-L1167) |
| Document Search and Filter Module | • [Repository Search Interface](src/App.vue#L891-L1004)<br>• [Repository Filter Controls](src/App.vue#L901-L942)<br>• [Repository Result Table](src/App.vue#L943-L1004) |
| Document Update and Archive Module | • [Archive Document Modal](src/App.vue#L1005-L1052)<br>• [Upload New Version Modal](src/App.vue#L1053-L1138) |

---

## Subsystem 3: Intelligent Recommendation and Support
**Developer:** Khoo Yuan Man

| Module | Frontend Script |
|---|---|
| Smart Search Module | • [Smart Search Interface](src/App.vue#L1170-L1232)<br>• [Smart Search Results Interface](src/App.vue#L1374-L1421) |
| FAQ and Knowledge Assistance Module | • [HR Chatbot Interface](src/App.vue#L1233-L1292)<br>• [Escalation Request Interface](src/App.vue#L1293-L1369)<br>• [FAQ Section](src/App.vue#L1531-L1549) |
| Personalized Recommendation Module | • [Recommended Documents Interface](src/App.vue#L1423-L1478)<br>• [AI Document Summary Panel](src/App.vue#L1479-L1491)<br>• [Recommendation Report Interface](src/App.vue#L1494-L1530) |
| Notification and Update Alert Module | • [Notification Preferences Interface](src/App.vue#L1616-L1657)<br>• [Smart Alerts Interface](src/App.vue#L1658-L1700)<br>• [Recent Notifications Panel](src/App.vue#L1701-L1743) |
| Saved Documents and Personal Storage Module | • [Saved Documents Overview](src/App.vue#L1601-L1614)<br>• [Personal Storage Interface](src/App.vue#L1775-L1853)<br>• [Personal Notes Interface](src/App.vue#L1784-L1802) |

## 3. Technology Used

| Component               | Technology                                       |
| ----------------------- | ------------------------------------------------ |
| Frontend Framework      | Vue.js                                           |
| Programming Language    | JavaScript                                       |
| Build Tool              | Vite                                             |
| Styling                 | CSS                                              |
| Backend                 | Node.js / Express.js                             |
| Database                | MySQL                                            |
| Local Storage           | Browser localStorage for selected prototype data |
| Development Environment | Laragon, VS Code, GitHub                         |

---

## 4. Project Structure

```text
johor-hr-hub/
├── backend/
│   ├── db.js
│   ├── server.js
│   ├── package.json
│   └── package-lock.json
├── database/
│   └── johor_hr_knowledge_hub.sql
├── index.html
├── package.json
├── package-lock.json
├── README.md
├── vite.config.js
├── public/
│   ├── favicon.svg
│   └── icons.svg
└── src/
    ├── main.js
    ├── App.vue
    ├── style.css
    └── components/
        ├── InputField.vue
        ├── StatCard.vue
        └── SettingCard.vue
```

---

## 5. Setup Instructions

### Step 1: Install Required Software

Make sure the following software is installed:

```text
Node.js
npm
Git
Laragon
MySQL
VS Code
```

Check Node.js and npm using:

```bash
node -v
npm -v
```

---

### Step 2: Clone the Repository

Open Laragon Terminal or Command Prompt and go to the Laragon `www` folder:

```bash
cd C:\laragon\www
```

Clone the repository:

```bash
git clone https://github.com/yuanman1021/AD15_Aespa.git
```

Open the project folder:

```bash
cd AD15_Aespa
```

---

### Step 3: Start Laragon and MySQL

Open Laragon and click:

```text
Start All
```

Make sure MySQL is running.

---

### Step 4: Import the Database

In the project folder, open terminal and enter MySQL:

```bash
mysql -u root
```

Create the database:

```sql
CREATE DATABASE johor_hr_knowledge_hub;
EXIT;
```

Import the SQL file:

```bash
mysql -u root johor_hr_knowledge_hub < database\johor_hr_knowledge_hub.sql
```

To check whether the database was imported successfully:

```bash
mysql -u root
```

Then run:

```sql
USE johor_hr_knowledge_hub;
SHOW TABLES;
EXIT;
```

---

### Step 5: Install and Run Backend

Open a terminal for the backend:

```bash
cd C:\laragon\www\AD15_Aespa\backend
npm install
npm run dev
```

The backend should run at:

```text
http://localhost:3000
```

Keep this terminal open.

---

### Step 6: Install and Run Frontend

Open another terminal for the frontend:

```bash
cd C:\laragon\www\AD15_Aespa
npm install
npm run dev
```

The frontend should run at:

```text
http://localhost:5173
```

Open the link in a browser.

---

## 6. Important Note About Laragon

Laragon is required for this prototype because the backend connects to a MySQL database.

The database connection is configured in:

```text
backend/db.js
```

Default database settings:

```text
Host: localhost
User: root
Password: empty
Database: johor_hr_knowledge_hub
```

Make sure Laragon MySQL is running before starting the backend server.

---

## 11. Data Storage

This prototype uses both MySQL and browser localStorage.

MySQL is used for backend-connected data such as:

```text
Documents
Recommendations
FAQs
Notifications
Chatbot conversations
Escalation requests
```

Browser localStorage is used for selected prototype interactions such as:

```text
Temporary UI data
Prototype logs
Saved browser state
Some user interface changes
```

To reset browser prototype data:

1. Open the system in the browser.
2. Press `F12`.
3. Go to the **Application** tab.
4. Open **Local Storage**.
5. Delete the related `jhr_` data items.
6. Refresh the page.

To reset database data, re-import:

```bash
mysql -u root johor_hr_knowledge_hub < database\johor_hr_knowledge_hub.sql
```


## 12. Developer

```text
Project: Johor HR Knowledge Hub
Group: Aespa

Subsystem 1: User and Access Management
Developer: Lee May Yan

Subsystem 2: Knowledge and Document Management
Developer: Lee Tung Ern

Subsystem 3: Intelligent Recommendation and Support
Developer: Khoo Yuan Man
```
