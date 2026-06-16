# Johor HR Knowledge Hub

Johor HR Knowledge Hub is a high-fidelity interactive frontend prototype for a centralized HR policy and document management platform. The system allows users to search public HR documents, register and log in, manage profiles, upload and classify documents, use smart search, ask the HR chatbot, receive notifications, and manage saved documents.

This prototype is developed using **Vue.js with JavaScript** and **Vite**. It uses mock data and localStorage, so it can run without Laragon, PHP, or MySQL.

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

| Subsystem / Developer | Module | Frontend Script |
| --- | --- | --- |
| Subsystem 1: User and Access Management / Lee May Yan | Guest Access Module | [`src/App.vue` public portal UI, search, browse and public document details](src/App.vue#L56-L171) |
| Subsystem 1: User and Access Management / Lee May Yan | User Registration and Login Module | [`src/App.vue` login, register, reset password and MFA UI](src/App.vue#L172-L356) |
| Subsystem 1: User and Access Management / Lee May Yan | Profile Management Module | [`src/App.vue` profile, preferences, MFA and deactivation UI](src/App.vue#L357-L458) |
| Subsystem 1: User and Access Management / Lee May Yan | Role and Permission Control Module | [`src/App.vue` admin users, roles, permissions and activity logs UI](src/App.vue#L1679-L1912) |
| Subsystem 1: User and Access Management / Lee May Yan | Administrator Authentication Module | [`src/App.vue` admin login tab and admin workspace access](src/App.vue#L172-L356) |
| Subsystem 2: Knowledge and Document Management / Lee Tung Ern | Document Upload Module | [`src/App.vue` upload HR document form and draft/upload actions](src/App.vue#L459-L605) |
| Subsystem 2: Knowledge and Document Management / Lee Tung Ern | Document Classification and Categorization Module | [`src/App.vue` AI classification review, approve, modify and reject UI](src/App.vue#L606-L718) |
| Subsystem 2: Knowledge and Document Management / Lee Tung Ern | Document Storage Repository Module | [`src/App.vue` repository table, document preview and audit trail UI](src/App.vue#L719-L829) |
| Subsystem 2: Knowledge and Document Management / Lee Tung Ern | Document Search and Filter Module | [`src/App.vue` repository search and filter controls](src/App.vue#L719-L829) |
| Subsystem 2: Knowledge and Document Management / Lee Tung Ern | Document Update and Archive Module | [`src/App.vue` archive modal and upload new version modal](src/App.vue#L830-L984) |
| Subsystem 3: Intelligent Recommendation and Support / Khoo Yuan Man | Personalized Recommendation Module | [`src/App.vue` recommended documents, refresh recommendation and report incorrect recommendation UI](src/App.vue#L1247-L1350) |
| Subsystem 3: Intelligent Recommendation and Support / Khoo Yuan Man | FAQ and Knowledge Assistance Module | [`src/App.vue` HR chatbot, suggested questions, FAQ, summary and escalation UI](src/App.vue#L1050-L1193) |
| Subsystem 3: Intelligent Recommendation and Support / Khoo Yuan Man | Notification and Update Alert Module | [`src/App.vue` notification preferences, smart alerts and recent notifications UI](src/App.vue#L1426-L1597) |
| Subsystem 3: Intelligent Recommendation and Support / Khoo Yuan Man | Smart Search Module | [`src/App.vue` semantic search, search suggestions, recent search history, result sorting and highlights](src/App.vue#L995-L1245) |
| Subsystem 3: Intelligent Recommendation and Support / Khoo Yuan Man | Saved Documents and Personal Storage Module | [`src/App.vue` saved documents and personal notes UI](src/App.vue#L1598-L1678) |
| Shared Components | Reusable Input Field | [`src/components/InputField.vue`](src/components/InputField.vue) |
| Shared Components | Reusable Statistic Card | [`src/components/StatCard.vue`](src/components/StatCard.vue) |
| Shared Components | Reusable Setting Card | [`src/components/SettingCard.vue`](src/components/SettingCard.vue) |
| Shared App Files | Vue App Entry and Styling | [`src/main.js`](src/main.js), [`src/style.css`](src/style.css), [`index.html`](index.html) |

---

## 3. Technology Used

| Component            | Technology        |
| -------------------- | ----------------- |
| Frontend Framework   | Vue.js            |
| Programming Language | JavaScript        |
| Build Tool           | Vite              |
| Styling              | CSS               |
| Data Storage         | localStorage      |
| Backend              | Not connected yet |
| Database             | Not connected yet |

---

## 4. Project Structure

```text
johor-hr-hub/
├── index.html
├── package.json
├── README.md
├── src/
│   ├── main.js
│   ├── App.vue
│   ├── style.css
│   └── components/
│       ├── InputField.vue
│       ├── StatCard.vue
│       └── SettingCard.vue
```

---

## 5. Setup Instructions

### Step 1: Install Node.js

Make sure Node.js is installed on your computer.

Check using:

```bash
node -v
npm -v
```

If both commands show version numbers, Node.js and npm are installed.

---

### Step 2: Open the Project Folder

Open the project folder in VS Code.

Example project location:

```text
C:\Users\leema\y2s2\adp 1\progress 2\AD15_Aespa\johor-hr-hub
```

Open terminal in VS Code.

---

### Step 3: Install Dependencies

Run this command inside the project folder:

```bash
npm install
```

This installs all required packages for the Vue project.

---

### Step 4: Start the Development Server

Run:

```bash
npm run dev
```

After running the command, Vite will show a local link, usually:

```text
http://localhost:5173/
```

Open the link in your browser.

---

## 6. Important Note About Laragon

Laragon is **not required** for this prototype.

This project only uses Vue frontend, so it can run using:

```bash
npm run dev
```

Laragon is only needed later if the system is connected to:

* PHP backend
* MySQL database
* phpMyAdmin

For the current UI prototype, do not start Laragon unless backend/database development is added later.

---

## 7. Required Files

Make sure these files exist:

```text
src/main.js
src/App.vue
src/style.css
src/components/InputField.vue
src/components/StatCard.vue
src/components/SettingCard.vue
```

---

## 8. main.js

The `src/main.js` file should contain:

```js
import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

createApp(App).mount('#app')
```

---

## 9. Component Files

### InputField.vue

This component is used for reusable input fields and supports `v-model`.

```vue
<template>
  <label class="input-group">
    <span>{{ label }}</span>
    <input
      :type="type"
      :placeholder="placeholder"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
    />
  </label>
</template>

<script setup>
defineProps({
  label: String,
  placeholder: String,
  modelValue: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'text'
  }
})

defineEmits(['update:modelValue'])
</script>
```

---

### StatCard.vue

This component displays dashboard statistics.

```vue
<template>
  <div class="stat-card">
    <span>{{ label }}</span>
    <strong>{{ value }}</strong>
    <p>{{ note }}</p>
  </div>
</template>

<script setup>
defineProps({
  label: String,
  value: String,
  note: String
})
</script>
```

---

### SettingCard.vue

This component displays clickable setting cards.

```vue
<template>
  <div class="setting-card">
    <div>
      <h4>{{ title }}</h4>
      <p>{{ desc }}</p>
    </div>

    <button :class="{ danger: danger }">
      {{ action }}
    </button>
  </div>
</template>

<script setup>
defineProps({
  title: String,
  desc: String,
  action: String,
  danger: {
    type: Boolean,
    default: false
  }
})
</script>
```

---

## 10. How to Use the Prototype

### Public Portal

1. Open the system.
2. Use the search bar to search documents.
3. Select a category filter.
4. Click a document card to view its details.
5. Click **Open Public Details** for public documents.
6. Restricted documents will redirect users to login/register.

---

### Login and Registration

1. Click **Login / Register** from the sidebar.
2. Choose one of the tabs:

   * User Login
   * Register
   * Reset Password
   * Admin Login
3. Fill in the form.
4. Click the related action button.

Example:

* Use **Demo User Login** to simulate registered user access.
* Use **Demo Admin Login** to simulate administrator access.

---

### Profile and Security

1. Click **Profile & Security**.
2. Edit user profile fields.
3. Change notification preference.
4. Click **Save Profile**.
5. Click the MFA card to enable or disable MFA.

---

### Document Management

1. Click **Document Management**.
2. Fill in the document upload form.
3. Click **Upload and Extract Metadata**.
4. The document will appear in the repository.
5. It will also appear in the AI classification review section.
6. Click **Approve** to approve a classification.
7. Use the repository search bar to filter documents.
8. Click **Archive** to archive a document.
9. Click **Upload New Version** to update the selected document version.

---

### Smart Support and Chatbot

1. Click **Smart Support**.
2. Use the smart search box to search using normal questions.
3. Use the HR chatbot by typing a question.
4. Press Enter or click **Send**.
5. Click suggested questions to automatically ask the chatbot.

---

### Notifications and Saved Documents

1. Click **Notifications & Saved**.
2. View unread notifications.
3. Click **Mark All as Read** to update notification status.
4. Click notification setting cards to toggle preferences.
5. View saved documents.
6. Click **Add Note** to update a saved document note.
7. Click **Remove** to remove a saved document.

---

### Admin Workspace

1. Click **Admin Workspace**.
2. View user account records.
3. Click **Suspend** or **Reactivate** to update user status.
4. Click **Create Role** to add a new role.
5. View system activity logs.
6. Click **Filter Logs** to show success logs only.

---

## 11. Data Storage

This prototype uses `localStorage`.

This means:

* Uploaded documents stay after refreshing the browser.
* Created users stay after refreshing the browser.
* Saved documents stay after refreshing the browser.
* Logs stay after refreshing the browser.

To reset the prototype data:

1. Open the browser.
2. Press `F12`.
3. Go to **Application** tab.
4. Open **Local Storage**.
5. Delete the `jhr_` data items.
6. Refresh the page.

Alternative method:

* Open the system in an incognito/private window.

---

## 12. Common Errors and Fixes

### Error: At least one template or script is required

This means one of the `.vue` files is empty.

Check these files:

```text
src/components/InputField.vue
src/components/StatCard.vue
src/components/SettingCard.vue
```

Make sure each file has a `<template>` and `<script setup>` section.

---

### Error: Failed to resolve component

Check the import paths in `App.vue`:

```js
import InputField from './components/InputField.vue'
import StatCard from './components/StatCard.vue'
import SettingCard from './components/SettingCard.vue'
```

Also make sure the filenames are exactly:

```text
InputField.vue
StatCard.vue
SettingCard.vue
```

---

### Error: localhost cannot open

Stop the server:

```text
Ctrl + C
```

Then run again:

```bash
npm run dev
```

Open the link shown in the terminal.

---

## 13. Suggested Screenshots for Report

The following screenshots can be used for the Progress 2 report:

1. Public Portal Page
2. Login and Registration Page
3. Profile and Security Page
4. Document Management Page
5. AI Classification Review Section
6. Document Repository Section
7. Smart Support Page
8. HR Chatbot with Suggested Questions
9. Notifications and Saved Documents Page
10. Admin Workspace Page

---

## 14. Future Enhancement

Future improvements may include:

* Connect Vue frontend to PHP backend
* Store real users in MySQL
* Store real documents in MySQL
* Add real login authentication
* Add real file upload for PDF documents
* Add real email verification
* Add real password reset email
* Add real AI chatbot integration
* Add real document recommendation algorithm
* Add role-based access control

---

## 15. Developer

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