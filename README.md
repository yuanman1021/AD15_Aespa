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

## 2. Technology Used

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

## 3. Project Structure

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

## 4. Setup Instructions

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

## 5. Important Note About Laragon

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

## 6. Required Files

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

## 7. main.js

The `src/main.js` file should contain:

```js
import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

createApp(App).mount('#app')
```

---

## 8. Component Files

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

## 9. How to Use the Prototype

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

Example questions:

* How do I reset my password?
* How do I register an account?
* Can guest users view restricted documents?
* How do I search for leave policy?
* How do I upload a HR document?
* How does AI classification work?
* How do notifications work?
* How do I save a document?

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

## 10. Data Storage

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

## 11. Common Errors and Fixes

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

## 12. Suggested Screenshots for Report

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

## 13. Future Enhancement

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

## 14. Developer

```text
Subsystem 1: User and Access Management
Developer: May Yan

Project: Johor HR Knowledge Hub
Group: Aespa
```
