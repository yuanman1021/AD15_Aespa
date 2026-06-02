<template>
  <div class="app-shell">
    <aside class="sidebar">
      <div class="brand">
        <div class="logo-mark">J</div>
        <div>
          <h1>Johor HR</h1>
          <p>Knowledge Hub</p>
        </div>
      </div>

      <div class="session-card">
        <span>Current access</span>
        <strong>{{ session }}</strong>
        <small>{{ sessionText }}</small>
      </div>

      <nav class="nav-list">
        <button
          v-for="item in navItems"
          :key="item.id"
          :class="{ active: screen === item.id }"
          @click="screen = item.id"
        >
          <span>{{ item.label }}</span>
          <em>{{ item.subsystem }}</em>
        </button>
      </nav>

      <button class="ghost-button" @click="logoutPrototype">
        Logout Prototype
      </button>
    </aside>

    <main class="main-panel">
      <header class="topbar">
        <div>
          <p class="eyebrow">Complete Prototype</p>
          <h2>Johor HR Knowledge Hub</h2>
        </div>

        <div class="top-actions">
          <button @click="fakeLogin('User')">Demo User Login</button>
          <button class="primary" @click="fakeLogin('Admin')">Demo Admin Login</button>
        </div>
      </header>

      <div v-if="toast" class="toast">
        <span>System message</span>
        <p>{{ toast }}</p>
        <button @click="toast = ''">×</button>
      </div>

      <!-- SUBSYSTEM 1: PUBLIC PORTAL -->
      <section v-if="screen === 'public'" class="grid-two">
        <div class="hero-card">
          <p class="eyebrow">Subsystem 1 · Guest Access Module</p>
          <h3>Search official HR documents without logging in.</h3>
          <p>
            Guests can search and browse public policies, circulars and guidelines.
            Restricted items ask users to register or log in.
          </p>

          <div class="search-box">
            <input
              v-model="query"
              placeholder="Search by title, reference number or category..."
            />

            <select v-model="category">
              <option v-for="item in categories" :key="item">
                {{ item }}
              </option>
            </select>
          </div>

          <div class="category-row">
            <button
              v-for="item in categories"
              :key="item"
              :class="category === item ? 'chip selected' : 'chip'"
              @click="category = item"
            >
              {{ item }}
            </button>
          </div>
        </div>

        <div class="detail-card">
          <div class="detail-header">
            <span :class="selectedDoc.access === 'Public' ? 'badge green' : 'badge amber'">
              {{ selectedDoc.access }}
            </span>
            <span>{{ selectedDoc.effectiveDate }}</span>
          </div>

          <h3>{{ selectedDoc.title }}</h3>
          <p>{{ selectedDoc.summary }}</p>

          <dl>
            <div>
              <dt>Reference</dt>
              <dd>{{ selectedDoc.referenceNo }}</dd>
            </div>
            <div>
              <dt>Category</dt>
              <dd>{{ selectedDoc.category }}</dd>
            </div>
            <div>
              <dt>Type</dt>
              <dd>{{ selectedDoc.type }}</dd>
            </div>
            <div>
              <dt>Status</dt>
              <dd>{{ selectedDoc.status }}</dd>
            </div>
          </dl>

          <button
            v-if="selectedDoc.access === 'Public'"
            class="primary full"
            @click="openDocumentDetails(selectedDoc)"
          >
            Open Public Details
          </button>

          <button v-else class="primary full" @click="screen = 'auth'">
            Register / Login to Access
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Search Results</p>
              <h3>{{ filteredDocs.length }} document(s) found</h3>
            </div>

            <button @click="screen = 'auth'; authMode = 'register'">
              Request Account Registration
            </button>
          </div>

          <div class="doc-grid">
            <button
              v-for="doc in filteredDocs"
              :key="doc.documentId"
              class="doc-card"
              @click="selectedDoc = doc"
            >
              <span :class="doc.access === 'Public' ? 'status-pill green' : 'status-pill amber'">
                {{ doc.access }}
              </span>

              <h4>{{ doc.title }}</h4>
              <p>{{ doc.referenceNo }}</p>

              <div>
                <span>{{ doc.category }}</span>
                <span>{{ doc.type }}</span>
              </div>
            </button>

            <div v-if="filteredDocs.length === 0" class="empty-state">
              No matching documents found. Try another keyword or category.
            </div>
          </div>
        </div>
      </section>

      <!-- SUBSYSTEM 1: LOGIN / REGISTER -->
      <section v-if="screen === 'auth'" class="auth-layout">
        <div class="auth-info">
          <p class="eyebrow">Subsystem 1 · Registration and Login Module</p>
          <h3>Secure access using official Johor government email.</h3>
          <p>
            This screen demonstrates registration, login, password reset,
            account lock and MFA flows using Vue and mock data.
          </p>

          <div class="metric-row">
            <div>
              <strong>JWT</strong>
              <span>Session control</span>
            </div>
            <div>
              <strong>MFA</strong>
              <span>Extra login protection</span>
            </div>
            <div>
              <strong>Lock</strong>
              <span>Failed attempt handling</span>
            </div>
          </div>
        </div>

        <div class="auth-card">
          <div class="tab-row">
            <button
              v-for="tab in authTabs"
              :key="tab.id"
              :class="{ selected: authMode === tab.id }"
              @click="authMode = tab.id"
            >
              {{ tab.label }}
            </button>
          </div>

          <div v-if="authMode === 'login'" class="form-panel">
            <h3>User Login Account</h3>
            <p>Access full document search and registered features.</p>

            <InputField
              v-model="loginForm.email"
              label="Government Email"
              placeholder="user@johor.gov.my"
            />

            <InputField
              v-model="loginForm.password"
              label="Password"
              placeholder="Enter password"
              type="password"
            />

            <InputField
              v-model="loginForm.mfa"
              label="MFA Code"
              placeholder="6-digit code if enabled"
            />

            <button class="primary full" @click="userLogin">
              Login as Registered User
            </button>

            <button class="link-button" @click="authMode = 'reset'">
              Forgot password?
            </button>
          </div>

          <div v-if="authMode === 'register'" class="form-panel">
            <h3>Register Account</h3>
            <p>Create account using required profile information.</p>

            <InputField
              v-model="registerForm.name"
              label="Full Name"
              placeholder="Enter full name"
            />

            <InputField
              v-model="registerForm.email"
              label="Government Email"
              placeholder="name@johor.gov.my"
            />

            <InputField
              v-model="registerForm.department"
              label="Department"
              placeholder="Human Resource Management Division"
            />

            <InputField
              v-model="registerForm.designation"
              label="Designation Level"
              placeholder="Officer / Assistant Officer"
            />

            <InputField
              v-model="registerForm.password"
              label="Password"
              placeholder="Minimum 8 characters"
              type="password"
            />

            <button class="primary full" @click="registerUser">
              Submit Registration
            </button>
          </div>

          <div v-if="authMode === 'reset'" class="form-panel">
            <h3>Reset Password</h3>
            <p>Password reset through verified government email.</p>

            <InputField
              v-model="resetForm.email"
              label="Registered Email"
              placeholder="user@johor.gov.my"
            />

            <button class="primary full" @click="sendResetLink">
              Send Reset Link
            </button>

            <InputField
              v-model="resetForm.code"
              label="Verification Code"
              placeholder="Enter code"
            />

            <InputField
              v-model="resetForm.newPassword"
              label="New Password"
              placeholder="Enter new password"
              type="password"
            />

            <button class="secondary full" @click="updatePassword">
              Update Password
            </button>
          </div>

          <div v-if="authMode === 'admin'" class="form-panel">
            <h3>Administrator Login Account</h3>
            <p>Dedicated admin login with shorter inactivity timeout.</p>

            <InputField
              v-model="adminLoginForm.email"
              label="Admin Email"
              placeholder="admin@johor.gov.my"
            />

            <InputField
              v-model="adminLoginForm.password"
              label="Password"
              placeholder="Enter admin password"
              type="password"
            />

            <InputField
              v-model="adminLoginForm.mfa"
              label="MFA Code"
              placeholder="6-digit code"
            />

            <button class="primary full" @click="adminLogin">
              Login as Administrator
            </button>
          </div>
        </div>
      </section>

      <!-- SUBSYSTEM 1: PROFILE -->
      <section v-if="screen === 'profile'" class="grid-two">
        <div class="profile-card">
          <div class="avatar">NA</div>
          <h3>{{ profileForm.name }}</h3>
          <p>{{ profileForm.email }}</p>
          <span class="status-pill green">Active Registered User</span>

          <dl>
            <div>
              <dt>Department</dt>
              <dd>{{ profileForm.department }}</dd>
            </div>
            <div>
              <dt>Designation</dt>
              <dd>{{ profileForm.designation }}</dd>
            </div>
            <div>
              <dt>Notification</dt>
              <dd>{{ notificationFrequency }}</dd>
            </div>
          </dl>
        </div>

        <div class="detail-card">
          <p class="eyebrow">Subsystem 1 · Profile Management</p>
          <h3>Manage User Profile</h3>

          <InputField
            v-model="profileForm.name"
            label="Full Name"
            placeholder="Nur Aina Rahman"
          />

          <InputField
            v-model="profileForm.email"
            label="Email"
            placeholder="aina@johor.gov.my"
          />

          <InputField
            v-model="profileForm.department"
            label="Department"
            placeholder="Human Resource Management Division"
          />

          <InputField
            v-model="profileForm.designation"
            label="Designation Level"
            placeholder="Assistant Officer"
          />

          <label class="input-group">
            <span>Notification Preference</span>
            <select v-model="notificationFrequency">
              <option>Instant</option>
              <option>Daily</option>
              <option>Weekly</option>
            </select>
          </label>

          <button class="primary full" @click="saveProfile">
            Save Profile
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>Account Security</h3>
            <span :class="mfaEnabled ? 'status-pill green' : 'status-pill amber'">
              {{ mfaEnabled ? 'MFA Enabled' : 'MFA Disabled' }}
            </span>
          </div>

          <div class="settings-grid">
            <SettingCard
              title="Change Password"
              desc="Update password while logged in."
              action="Change"
              @click="toast = 'Password change form opened.'"
            />

            <SettingCard
              title="Enable MFA"
              desc="Use verification code during login."
              :action="mfaEnabled ? 'Disable' : 'Enable'"
              @click="toggleMfa"
            />

            <SettingCard
              title="Deactivate Account"
              desc="Request own account deactivation."
              action="Request"
              danger
              @click="toast = 'Account deactivation request submitted.'"
            />
          </div>
        </div>
      </section>

      <!-- SUBSYSTEM 2: DOCUMENT MANAGEMENT -->
      <section v-if="screen === 'documents'" class="dashboard-grid">
        <div class="welcome-card">
          <p class="eyebrow">Subsystem 2 · Knowledge and Document Management</p>
          <h3>Upload, classify, store, search and manage HR documents.</h3>
          <p>
            This area covers document upload, metadata, AI classification review,
            repository, document versions and archive flow.
          </p>
        </div>

        <StatCard label="Documents" :value="String(documents.length)" note="Total repository records" />
        <StatCard label="Pending Review" :value="String(pendingClassificationCount)" note="AI classification waiting" />
        <StatCard label="Archived" :value="String(archivedCount)" note="Old circular versions" />

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Document Upload Module</p>
              <h3>Upload HR Document</h3>
            </div>

            <button @click="saveDocumentAsDraft">
              Save as Draft
            </button>
          </div>

          <div class="form-grid">
            <InputField
              v-model="uploadForm.title"
              label="Document Title"
              placeholder="Example: Cuti Sakit Pegawai Kerajaan Johor"
            />

            <InputField
              v-model="uploadForm.referenceNo"
              label="Official Reference Number"
              placeholder="JHR/CUTI/2026/01"
            />

            <InputField
              v-model="uploadForm.issuingAuthority"
              label="Issuing Authority"
              placeholder="Human Resource Management Division"
            />

            <InputField
              v-model="uploadForm.effectiveDate"
              label="Effective Date"
              placeholder="2026-01-12"
            />

            <label class="input-group">
              <span>Document Type</span>
              <select v-model="uploadForm.type">
                <option>Circular</option>
                <option>Guideline</option>
                <option>Policy</option>
                <option>Memo</option>
                <option>Administrative Decision</option>
              </select>
            </label>

            <label class="input-group">
              <span>Category</span>
              <select v-model="uploadForm.category">
                <option>Leave Policy</option>
                <option>Promotion</option>
                <option>Discipline</option>
                <option>Salary</option>
                <option>Loan</option>
              </select>
            </label>
          </div>

          <button class="primary" @click="uploadDocument">
            Upload and Extract Metadata
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Classification and Categorization Module</p>
              <h3>AI Classification Review</h3>
            </div>

            <button @click="refreshClassification">
              Refresh Suggestions
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="item in classificationQueue"
              :key="item.id"
              class="doc-card"
            >
              <span :class="item.status === 'Approved' ? 'status-pill green' : 'status-pill amber'">
                {{ item.status }}
              </span>

              <h4>{{ item.title }}</h4>
              <p>Suggested categories: {{ item.suggestions.join(', ') }}</p>

              <div>
                <span v-for="tag in item.tags" :key="tag">
                  {{ tag }}
                </span>
              </div>

              <button
                class="primary"
                :disabled="item.status === 'Approved'"
                @click="approveClassification(item)"
              >
                {{ item.status === 'Approved' ? 'Approved' : 'Approve' }}
              </button>
            </article>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Repository, Search and Version Management</p>
              <h3>Document Repository</h3>
            </div>

            <button @click="uploadNewVersion">
              Upload New Version
            </button>
          </div>

          <div class="toolbar-row">
            <input
              v-model="repoQuery"
              placeholder="Search title or reference number..."
            />

            <select v-model="repoType">
              <option>All Types</option>
              <option>Circular</option>
              <option>Guideline</option>
              <option>Policy</option>
              <option>Memo</option>
              <option>Administrative Decision</option>
            </select>
          </div>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>Document</th>
                  <th>Reference</th>
                  <th>Category</th>
                  <th>Access</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="doc in repositoryDocs" :key="doc.documentId">
                  <td>
                    <strong>{{ doc.title }}</strong>
                    <span>{{ doc.type }} · Version {{ doc.version }}</span>
                  </td>

                  <td>{{ doc.referenceNo }}</td>
                  <td>{{ doc.category }}</td>

                  <td>
                    <span :class="doc.access === 'Public' ? 'status-pill green' : 'status-pill amber'">
                      {{ doc.access }}
                    </span>
                  </td>

                  <td>
                    <span :class="doc.status === 'Archived' ? 'status-pill amber' : 'status-pill green'">
                      {{ doc.status }}
                    </span>
                  </td>

                  <td>
                    <button @click="previewRepositoryDoc(doc)">
                      Preview
                    </button>
                    <button @click="archiveDocument(doc)">
                      Archive
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      <!-- SUBSYSTEM 3: SMART SUPPORT -->
      <section v-if="screen === 'smart'" class="grid-two">
        <div class="hero-card">
          <p class="eyebrow">Subsystem 3 · Smart Search Module</p>
          <h3>Ask natural-language questions in Bahasa Malaysia or English.</h3>
          <p>
            The prototype ranks relevant documents, highlights matched meaning
            and stores recent search history.
          </p>

          <div class="search-box single">
            <input
              v-model="smartQuery"
              placeholder="Example: What leave policy applies for long medical leave?"
            />
          </div>

          <button class="primary" @click="performSmartSearch">
            Perform Semantic Search
          </button>
        </div>

        <div class="detail-card chatbot-card">
          <p class="eyebrow">FAQ and Knowledge Assistance Module</p>
          <h3>AI Chatbot Assistance</h3>

          <div class="chat-window">
            <div
              v-for="(message, index) in chatMessages"
              :key="index"
              :class="message.sender === 'bot' ? 'chat-bubble bot' : 'chat-bubble user'"
            >
              {{ message.text }}
            </div>
          </div>

          <InputField
            v-model="chatInput"
            label="Ask a question"
            placeholder="Type your question here..."
          />

          <button class="primary full" @click="sendChatMessage">
            Send Question
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Personalized Recommendation Module</p>
              <h3>Recommended Documents</h3>
            </div>

            <button @click="refreshRecommendations">
              Refresh
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in smartResults"
              :key="doc.documentId"
              class="doc-card"
            >
              <span class="status-pill green">Recommended</span>
              <h4>{{ doc.title }}</h4>
              <p>Reason: {{ doc.reason }}</p>

              <div>
                <span>{{ doc.category }}</span>
                <span>{{ doc.type }}</span>
              </div>

              <button class="primary" @click="saveDocument(doc)">
                Save Document
              </button>
            </article>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">FAQ Assistance</p>
              <h3>Frequently Asked Questions</h3>
            </div>

            <button @click="toast = 'Question escalated to HR officer.'">
              Escalate to HR Officer
            </button>
          </div>

          <div class="faq-list">
            <details v-for="faq in faqs" :key="faq.id" open>
              <summary>{{ faq.question }}</summary>
              <p>{{ faq.answer }}</p>
            </details>
          </div>
        </div>
      </section>

      <!-- SUBSYSTEM 3: PERSONAL STORAGE AND NOTIFICATION -->
      <section v-if="screen === 'personal'" class="dashboard-grid">
        <div class="welcome-card">
          <p class="eyebrow">Subsystem 3 · Saved Documents and Notifications</p>
          <h3>Keep track of saved documents, notes and policy updates.</h3>
          <p>
            Users receive system alerts and email notifications when relevant or saved documents are updated.
          </p>
        </div>

        <StatCard label="Saved" :value="String(savedDocuments.length)" note="Personal collection" />
        <StatCard label="Unread Alerts" :value="String(unreadNotifications)" note="Policy updates" />
        <StatCard label="Notes" :value="String(savedDocuments.length)" note="Personal notes" />

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Notification and Update Alert Module</p>
              <h3>Notification Preferences</h3>
            </div>

            <button @click="toast = 'Notification preferences updated.'">
              Save Preferences
            </button>
          </div>

          <div class="settings-grid">
            <SettingCard
              title="Policy Updates"
              desc="Notify when new relevant documents are published."
              :action="policyUpdateEnabled ? 'Enabled' : 'Disabled'"
              @click="policyUpdateEnabled = !policyUpdateEnabled"
            />

            <SettingCard
              title="Saved Document Updates"
              desc="Notify when bookmarked documents are replaced."
              :action="savedUpdateEnabled ? 'Enabled' : 'Disabled'"
              @click="savedUpdateEnabled = !savedUpdateEnabled"
            />

            <SettingCard
              title="Frequency"
              desc="Choose instant, daily or weekly notifications."
              :action="notificationFrequency"
              @click="cycleNotificationFrequency"
            />
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>Recent Notifications</h3>
            <button @click="markAllNotificationsRead">
              Mark All as Read
            </button>
          </div>

          <div class="log-list">
            <div
              v-for="notice in notifications"
              :key="notice.id"
              class="log-item"
            >
              <span :class="notice.read ? 'dot green-dot' : 'dot amber-dot'"></span>

              <div>
                <strong>{{ notice.title }}</strong>
                <p>{{ notice.message }}</p>
              </div>

              <em>{{ notice.time }}</em>
            </div>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>Saved Documents and Personal Notes</h3>
            <button @click="addSampleNote">
              Add Note
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="item in savedDocuments"
              :key="item.id"
              class="doc-card"
            >
              <span class="status-pill green">Saved</span>
              <h4>{{ item.title }}</h4>
              <p>Note: {{ item.note }}</p>

              <div>
                <span>{{ item.category }}</span>
                <span>{{ item.updated }}</span>
              </div>

              <button @click="removeSavedDocument(item.id)">
                Remove
              </button>
            </article>

            <div v-if="savedDocuments.length === 0" class="empty-state">
              No saved documents yet. Go to Smart Support and save one.
            </div>
          </div>
        </div>
      </section>

      <!-- ADMIN WORKSPACE -->
      <section v-if="screen === 'admin'" class="dashboard-grid">
        <div class="welcome-card admin-theme">
          <p class="eyebrow">Administrator Workspace</p>
          <h3>Manage users, permissions, documents, AI suggestions and audit logs.</h3>
          <p>
            Admin functions are separated from normal user access and protected by dedicated login.
          </p>
        </div>

        <StatCard label="Users" :value="String(users.length)" note="Registered accounts" />
        <StatCard label="Documents" :value="String(documents.length)" note="Repository records" />
        <StatCard label="Audit Events" :value="String(logs.length)" note="System activity logs" />

        <div class="wide-card">
          <div class="section-title">
            <h3>Role and Permission Control</h3>
            <button @click="createNewRole">
              Create Role
            </button>
          </div>

          <div class="role-grid">
            <article
              v-for="role in roles"
              :key="role.name"
              class="role-card"
            >
              <h4>{{ role.name }}</h4>
              <p>{{ role.description }}</p>

              <div>
                <span v-for="permission in role.permissions" :key="permission">
                  {{ permission }}
                </span>
              </div>
            </article>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>User Account Management</h3>
            <button @click="toast = 'User table exported for audit review.'">
              Export
            </button>
          </div>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>User</th>
                  <th>Department</th>
                  <th>Role</th>
                  <th>Status</th>
                  <th>Action</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in users" :key="user.id">
                  <td>
                    <strong>{{ user.name }}</strong>
                    <span>{{ user.email }}</span>
                  </td>

                  <td>{{ user.department }}</td>
                  <td>{{ user.role }}</td>

                  <td>
                    <span :class="user.status === 'Active' ? 'status-pill green' : 'status-pill red'">
                      {{ user.status }}
                    </span>
                  </td>

                  <td>
                    <button @click="toggleUserStatus(user)">
                      {{ user.status === 'Active' ? 'Suspend' : 'Reactivate' }}
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <h3>System Activity Logs</h3>
            <button @click="filterLogs">
              Filter Logs
            </button>
          </div>

          <div class="log-list">
            <div
              v-for="log in logs"
              :key="log.id"
              class="log-item"
            >
              <span :class="log.result === 'Success' ? 'dot green-dot' : 'dot amber-dot'"></span>

              <div>
                <strong>{{ log.action }}</strong>
                <p>{{ log.user }} · {{ log.module }}</p>
              </div>

              <em>{{ log.time }}</em>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import InputField from './components/InputField.vue'
import StatCard from './components/StatCard.vue'
import SettingCard from './components/SettingCard.vue'

function useLocalStorage(key, defaultValue) {
  let storedValue = null

  try {
    storedValue = localStorage.getItem(key)
  } catch (error) {
    storedValue = null
  }

  const data = ref(storedValue ? JSON.parse(storedValue) : defaultValue)

  watch(
    data,
    (newValue) => {
      localStorage.setItem(key, JSON.stringify(newValue))
    },
    { deep: true }
  )

  return data
}

const documents = useLocalStorage('jhr_documents', [
  {
    documentId: 1,
    referenceNo: 'JHR-CUTI-2026-01',
    title: 'Garis Panduan Cuti Sakit Pegawai Kerajaan Johor',
    category: 'Leave Policy',
    type: 'Guideline',
    status: 'Published',
    access: 'Public',
    effectiveDate: '12 Jan 2026',
    version: '1.0',
    reason: 'Matches your department and recent leave policy searches.',
    summary:
      'Official guideline explaining sick leave eligibility, supporting documents, approval flow, and department-level responsibilities.'
  },
  {
    documentId: 2,
    referenceNo: 'JHR-PANGKAT-2025-08',
    title: 'Circular for Promotion Review and Staff Evaluation',
    category: 'Promotion',
    type: 'Circular',
    status: 'Published',
    access: 'Registered',
    effectiveDate: '20 Dec 2025',
    version: '2.1',
    reason: 'Popular among officers with the same designation level.',
    summary:
      'Circular related to promotion review, evaluation schedule, staff performance evidence and decision recording procedures.'
  },
  {
    documentId: 3,
    referenceNo: 'JHR-TATATERTIB-2025-03',
    title: 'Administrative Decision on Staff Discipline Procedure',
    category: 'Discipline',
    type: 'Administrative Decision',
    status: 'Published',
    access: 'Restricted',
    effectiveDate: '03 Nov 2025',
    version: '1.3',
    reason: 'Related to HR compliance documents viewed recently.',
    summary:
      'Restricted administrative decision for internal officers only. Requires registered access and suitable permission level.'
  },
  {
    documentId: 4,
    referenceNo: 'JHR-GAJI-2025-11',
    title: 'Salary Adjustment and Allowance Guideline',
    category: 'Salary',
    type: 'Guideline',
    status: 'Published',
    access: 'Registered',
    effectiveDate: '18 Oct 2025',
    version: '1.0',
    reason: 'Recommended because your department viewed salary guidelines this week.',
    summary:
      'Guideline explaining salary adjustment request, allowance categories and supporting documents.'
  },
  {
    documentId: 5,
    referenceNo: 'JHR-PINJAMAN-2025-04',
    title: 'Staff Loan Application FAQ and Procedure',
    category: 'Loan',
    type: 'Policy',
    status: 'Published',
    access: 'Public',
    effectiveDate: '05 Sept 2025',
    version: '1.0',
    reason: 'Frequently asked by officers in similar departments.',
    summary:
      'Policy notes for staff loan eligibility, application procedure and supporting evidence.'
  }
])

const users = useLocalStorage('jhr_users', [
  {
    id: 'USR001',
    name: 'Nur Aina Rahman',
    email: 'aina@johor.gov.my',
    department: 'Human Resource Management Division',
    role: 'Registered User',
    status: 'Active'
  },
  {
    id: 'USR002',
    name: 'Daniel Tan',
    email: 'daniel@johor.gov.my',
    department: 'Finance Department',
    role: 'Registered User',
    status: 'Suspended'
  },
  {
    id: 'ADM001',
    name: 'May Yan',
    email: 'admin@johor.gov.my',
    department: 'HRMD Admin Unit',
    role: 'Administrator',
    status: 'Active'
  }
])

const logs = useLocalStorage('jhr_logs', [
  {
    id: 'LOG-1001',
    user: 'Nur Aina Rahman',
    action: 'Login successful',
    module: 'User Login',
    time: 'Today, 09:14 AM',
    result: 'Success'
  },
  {
    id: 'LOG-1002',
    user: 'Daniel Tan',
    action: 'Failed login attempt',
    module: 'Authentication',
    time: 'Today, 08:58 AM',
    result: 'Warning'
  },
  {
    id: 'LOG-1003',
    user: 'May Yan',
    action: 'Updated role permission',
    module: 'Role Management',
    time: 'Yesterday, 04:42 PM',
    result: 'Success'
  }
])

const roles = useLocalStorage('jhr_roles', [
  {
    name: 'Guest User',
    description: 'Can browse and search public HR documents only.',
    permissions: ['Search Public Documents', 'Browse Public Documents', 'View Public Details']
  },
  {
    name: 'Registered User',
    description:
      'Can access full document search, AI features, downloads, bookmarks and notifications.',
    permissions: ['Full Search', 'Download Documents', 'AI Chatbot', 'Recommendations', 'Bookmarks']
  },
  {
    name: 'Administrator',
    description:
      'Can manage users, roles, audit logs and document administration functions.',
    permissions: [
      'User Management',
      'Role Management',
      'Audit Trail',
      'Document Upload',
      'Version Management'
    ]
  }
])

const classificationQueue = useLocalStorage('jhr_classification_queue', [
  {
    id: 1,
    title: 'Cuti Rehat Khas Update 2026',
    status: 'Pending Review',
    suggestions: ['Leave Policy', 'Staff Benefits'],
    tags: ['HRMD', 'Leave', 'Circular']
  },
  {
    id: 2,
    title: 'Kenaikan Pangkat Pegawai Sokongan',
    status: 'Pending Review',
    suggestions: ['Promotion', 'Evaluation'],
    tags: ['Promotion', 'Performance', 'Department']
  },
  {
    id: 3,
    title: 'Tatatertib dan Amaran Pentadbiran',
    status: 'Needs Edit',
    suggestions: ['Discipline', 'Compliance'],
    tags: ['Discipline', 'Internal', 'Restricted']
  }
])

const notifications = useLocalStorage('jhr_notifications', [
  {
    id: 1,
    title: 'Saved document updated',
    message: 'Promotion Review Circular has a new version available.',
    time: '10 min ago',
    read: false
  },
  {
    id: 2,
    title: 'New relevant policy',
    message: 'A salary guideline was published for your department.',
    time: '1 hour ago',
    read: false
  },
  {
    id: 3,
    title: 'Weekly digest ready',
    message: 'You have 5 recommended HR documents this week.',
    time: 'Yesterday',
    read: true
  }
])

const savedDocuments = useLocalStorage('jhr_saved_documents', [
  {
    id: 1,
    title: 'Promotion Review and Staff Evaluation',
    category: 'Promotion',
    note: 'Check eligibility criteria before staff review.',
    updated: 'Updated'
  },
  {
    id: 2,
    title: 'Salary Adjustment and Allowance Guideline',
    category: 'Salary',
    note: 'Useful for finance department reference.',
    updated: 'Current'
  }
])

const faqs = [
  {
    id: 1,
    question: 'How do I search for a circular by reference number?',
    answer:
      'Enter the reference number in the search box or use the document repository search filter.'
  },
  {
    id: 2,
    question: 'Why can I not download a restricted document?',
    answer:
      'Restricted documents require registered access and suitable permissions set by the administrator.'
  },
  {
    id: 3,
    question: 'How are document recommendations generated?',
    answer:
      'They are based on your department, role, recent searches, viewed documents and related content.'
  }
]

const navItems = [
  { id: 'public', label: 'Public Portal', subsystem: 'S1' },
  { id: 'auth', label: 'Login / Register', subsystem: 'S1' },
  { id: 'profile', label: 'Profile & Security', subsystem: 'S1' },
  { id: 'documents', label: 'Document Management', subsystem: 'S2' },
  { id: 'smart', label: 'Smart Support', subsystem: 'S3' },
  { id: 'personal', label: 'Notifications & Saved', subsystem: 'S3' },
  { id: 'admin', label: 'Admin Workspace', subsystem: 'All' }
]

const authTabs = [
  { id: 'login', label: 'User Login' },
  { id: 'register', label: 'Register' },
  { id: 'reset', label: 'Reset Password' },
  { id: 'admin', label: 'Admin Login' }
]

const categories = ['All', 'Leave Policy', 'Promotion', 'Discipline', 'Salary', 'Loan']

const screen = ref('public')
const query = ref('')
const category = ref('All')
const selectedDoc = ref(documents.value[0])
const authMode = ref('login')
const session = ref('Guest')
const toast = ref('Welcome to Johor HR Knowledge Hub interactive prototype.')

const repoQuery = ref('')
const repoType = ref('All Types')
const smartQuery = ref('')
const smartResults = ref(documents.value.filter((doc) => doc.access !== 'Restricted'))

const mfaEnabled = ref(true)
const policyUpdateEnabled = ref(true)
const savedUpdateEnabled = ref(true)
const notificationFrequency = ref('Daily')

const loginForm = ref({
  email: '',
  password: '',
  mfa: ''
})

const registerForm = ref({
  name: '',
  email: '',
  department: '',
  designation: '',
  password: ''
})

const resetForm = ref({
  email: '',
  code: '',
  newPassword: ''
})

const adminLoginForm = ref({
  email: '',
  password: '',
  mfa: ''
})

const profileForm = ref({
  name: 'Nur Aina Rahman',
  email: 'aina@johor.gov.my',
  department: 'Human Resource Management Division',
  designation: 'Assistant Officer'
})

const uploadForm = ref({
  title: '',
  referenceNo: '',
  issuingAuthority: '',
  effectiveDate: '',
  type: 'Guideline',
  category: 'Leave Policy'
})

const chatInput = ref('')
const chatMessages = ref([
  {
    sender: 'bot',
    text: 'Hi, I can help you understand HR policies and find related documents.'
  }
])

const sessionText = computed(() => {
  if (session.value === 'Guest') return 'Public mode'
  if (session.value === 'Admin') return 'Administrator session'
  return 'Registered user session'
})

const filteredDocs = computed(() => {
  return documents.value.filter((doc) => {
    const searchText = `${doc.title} ${doc.referenceNo} ${doc.category}`.toLowerCase()
    const matchesQuery = searchText.includes(query.value.toLowerCase())
    const matchesCategory = category.value === 'All' || doc.category === category.value
    return matchesQuery && matchesCategory
  })
})

const repositoryDocs = computed(() => {
  return documents.value.filter((doc) => {
    const searchText = `${doc.title} ${doc.referenceNo}`.toLowerCase()
    const matchesQuery = searchText.includes(repoQuery.value.toLowerCase())
    const matchesType = repoType.value === 'All Types' || doc.type === repoType.value
    return matchesQuery && matchesType
  })
})

const pendingClassificationCount = computed(() => {
  return classificationQueue.value.filter((item) => item.status !== 'Approved').length
})

const archivedCount = computed(() => {
  return documents.value.filter((doc) => doc.status === 'Archived').length
})

const unreadNotifications = computed(() => {
  return notifications.value.filter((notice) => !notice.read).length
})

function addLog(action, module, result = 'Success', user = 'System') {
  logs.value.unshift({
    id: `LOG-${Date.now()}`,
    user,
    action,
    module,
    time: 'Just now',
    result
  })
}

function fakeLogin(type) {
  session.value = type
  screen.value = type === 'Admin' ? 'admin' : 'personal'
  toast.value = `${type} session created. This is a front-end prototype using mock data.`
  addLog(`${type} demo login`, 'Authentication', 'Success', type)
}

function userLogin() {
  if (!loginForm.value.email || !loginForm.value.password) {
    toast.value = 'Please enter email and password.'
    addLog('Failed login attempt', 'User Login', 'Warning', 'Unknown User')
    return
  }

  fakeLogin('User')
}

function adminLogin() {
  if (!adminLoginForm.value.email || !adminLoginForm.value.password) {
    toast.value = 'Please enter admin email and password.'
    addLog('Failed admin login attempt', 'Administrator Login', 'Warning', 'Unknown Admin')
    return
  }

  fakeLogin('Admin')
}

function registerUser() {
  if (!registerForm.value.name || !registerForm.value.email || !registerForm.value.password) {
    toast.value = 'Please complete name, email and password.'
    return
  }

  const newUser = {
    id: `USR${Date.now()}`,
    name: registerForm.value.name,
    email: registerForm.value.email,
    department: registerForm.value.department || 'Not assigned',
    role: 'Registered User',
    status: 'Active'
  }

  users.value.unshift(newUser)

  registerForm.value = {
    name: '',
    email: '',
    department: '',
    designation: '',
    password: ''
  }

  toast.value = 'Registration submitted successfully. New user is added to admin table.'
  addLog('Registered new account', 'Registration', 'Success', newUser.name)
}

function sendResetLink() {
  if (!resetForm.value.email) {
    toast.value = 'Please enter registered email first.'
    return
  }

  toast.value = 'Password reset link sent to verified government email.'
  addLog('Requested password reset link', 'Password Reset', 'Success', resetForm.value.email)
}

function updatePassword() {
  if (!resetForm.value.code || !resetForm.value.newPassword) {
    toast.value = 'Please enter verification code and new password.'
    return
  }

  toast.value = 'Password updated successfully.'
  addLog('Updated password', 'Password Reset', 'Success', resetForm.value.email)

  resetForm.value = {
    email: '',
    code: '',
    newPassword: ''
  }
}

function logoutPrototype() {
  session.value = 'Guest'
  screen.value = 'public'
  toast.value = 'Session ended. You are back to guest access.'
  addLog('User logged out', 'Logout', 'Success', 'Current User')
}

function openDocumentDetails(doc) {
  selectedDoc.value = doc
  toast.value = `Opened public document details for ${doc.referenceNo}.`
  addLog('Viewed public document details', 'Public Search', 'Success', session.value)
}

function saveProfile() {
  toast.value = 'Profile updated successfully.'
  addLog('Updated profile information', 'Profile Management', 'Success', profileForm.value.name)
}

function toggleMfa() {
  mfaEnabled.value = !mfaEnabled.value
  toast.value = mfaEnabled.value ? 'MFA has been enabled.' : 'MFA has been disabled.'
  addLog('Changed MFA setting', 'Account Security', 'Success', profileForm.value.name)
}

function uploadDocument() {
  if (!uploadForm.value.title || !uploadForm.value.referenceNo) {
    toast.value = 'Please enter document title and reference number.'
    return
  }

  const newDocument = {
    documentId: Date.now(),
    referenceNo: uploadForm.value.referenceNo,
    title: uploadForm.value.title,
    category: uploadForm.value.category,
    type: uploadForm.value.type || 'Guideline',
    status: 'Published',
    access: 'Registered',
    effectiveDate: uploadForm.value.effectiveDate || 'Not set',
    version: '1.0',
    reason: 'Newly uploaded document.',
    summary: `Uploaded by ${uploadForm.value.issuingAuthority || 'Administrator'}. Metadata has been extracted and is ready for review.`
  }

  documents.value.unshift(newDocument)
  selectedDoc.value = newDocument

  classificationQueue.value.unshift({
    id: Date.now(),
    title: uploadForm.value.title,
    status: 'Pending Review',
    suggestions: [uploadForm.value.category, 'HR Policy'],
    tags: ['New Upload', uploadForm.value.type || 'Guideline']
  })

  notifications.value.unshift({
    id: Date.now(),
    title: 'New document uploaded',
    message: `${uploadForm.value.title} was added to the repository.`,
    time: 'Just now',
    read: false
  })

  addLog('Uploaded HR document', 'Document Upload', 'Success', 'Administrator')
  resetUploadForm()

  toast.value = 'Document uploaded successfully and added to AI classification review.'
}

function saveDocumentAsDraft() {
  if (!uploadForm.value.title || !uploadForm.value.referenceNo) {
    toast.value = 'Please enter document title and reference number before saving draft.'
    return
  }

  const draftDocument = {
    documentId: Date.now(),
    referenceNo: uploadForm.value.referenceNo,
    title: uploadForm.value.title,
    category: uploadForm.value.category,
    type: uploadForm.value.type || 'Guideline',
    status: 'Draft',
    access: 'Registered',
    effectiveDate: uploadForm.value.effectiveDate || 'Not set',
    version: '1.0',
    reason: 'Draft document.',
    summary: `Draft saved by ${uploadForm.value.issuingAuthority || 'Administrator'}.`
  }

  documents.value.unshift(draftDocument)
  selectedDoc.value = draftDocument
  addLog('Saved document as draft', 'Document Upload', 'Success', 'Administrator')
  resetUploadForm()

  toast.value = 'Document saved as draft and added to repository.'
}

function resetUploadForm() {
  uploadForm.value = {
    title: '',
    referenceNo: '',
    issuingAuthority: '',
    effectiveDate: '',
    type: 'Guideline',
    category: 'Leave Policy'
  }
}

function approveClassification(item) {
  item.status = 'Approved'
  toast.value = `${item.title} classification approved.`
  addLog('Approved AI classification', 'Document Classification', 'Success', 'Administrator')
}

function refreshClassification() {
  toast.value = 'AI suggestions refreshed.'
  addLog('Refreshed AI classification suggestions', 'Document Classification', 'Success', 'Administrator')
}

function previewRepositoryDoc(doc) {
  selectedDoc.value = doc
  screen.value = 'public'
  toast.value = `Preview opened for ${doc.referenceNo}.`
  addLog('Previewed repository document', 'Document Repository', 'Success', session.value)
}

function archiveDocument(doc) {
  doc.status = 'Archived'
  toast.value = `${doc.referenceNo} has been archived.`
  addLog('Archived document', 'Document Archive', 'Success', 'Administrator')
}

function uploadNewVersion() {
  if (!selectedDoc.value) {
    toast.value = 'Please select a document first.'
    return
  }

  const currentVersion = Number(selectedDoc.value.version)
  const nextVersion = Number.isNaN(currentVersion) ? '2.0' : (currentVersion + 0.1).toFixed(1)

  selectedDoc.value.version = nextVersion
  selectedDoc.value.status = 'Published'

  notifications.value.unshift({
    id: Date.now(),
    title: 'Saved document updated',
    message: `${selectedDoc.value.title} has a new version ${nextVersion}.`,
    time: 'Just now',
    read: false
  })

  toast.value = `${selectedDoc.value.title} updated to version ${nextVersion}.`
  addLog('Uploaded new document version', 'Version Management', 'Success', 'Administrator')
}

function performSmartSearch() {
  if (!smartQuery.value.trim()) {
    smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
    toast.value = 'Showing general recommended documents.'
    return
  }

  const keyword = smartQuery.value.toLowerCase()

  let results = documents.value.filter((doc) => {
    const searchText = `${doc.title} ${doc.category} ${doc.summary}`.toLowerCase()
    return searchText.includes(keyword)
  })

  if (keyword.includes('leave') || keyword.includes('cuti')) {
    results = documents.value.filter((doc) => doc.category === 'Leave Policy')
  } else if (keyword.includes('promotion') || keyword.includes('pangkat')) {
    results = documents.value.filter((doc) => doc.category === 'Promotion')
  } else if (keyword.includes('salary') || keyword.includes('gaji')) {
    results = documents.value.filter((doc) => doc.category === 'Salary')
  } else if (keyword.includes('loan') || keyword.includes('pinjaman')) {
    results = documents.value.filter((doc) => doc.category === 'Loan')
  }

  smartResults.value = results.length > 0 ? results : documents.value.filter((doc) => doc.access !== 'Restricted')
  toast.value = 'Semantic search completed. Results ranked by relevance.'
  addLog('Performed semantic search', 'Smart Search', 'Success', session.value)
}

function refreshRecommendations() {
  smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
  toast.value = 'Recommendations refreshed based on department and recent searches.'
  addLog('Refreshed recommendations', 'Recommendation', 'Success', session.value)
}

function sendChatMessage() {
  if (!chatInput.value.trim()) {
    toast.value = 'Please type a question first.'
    return
  }

  const userQuestion = chatInput.value

  chatMessages.value.push({
    sender: 'user',
    text: userQuestion
  })

  const question = userQuestion.toLowerCase()
  let answer =
    'I found related HR documents in the repository. You can check the recommended results below.'

  if (question.includes('leave') || question.includes('cuti')) {
    answer = 'For leave policy, you can refer to the sick leave guideline and staff leave circular.'
  } else if (question.includes('promotion') || question.includes('pangkat')) {
    answer =
      'For promotion matters, the system recommends the promotion review and staff evaluation circular.'
  } else if (question.includes('salary') || question.includes('gaji')) {
    answer =
      'For salary matters, the system recommends the salary adjustment and allowance guideline.'
  } else if (question.includes('loan') || question.includes('pinjaman')) {
    answer = 'For loan questions, the staff loan application FAQ and procedure document is recommended.'
  }

  chatMessages.value.push({
    sender: 'bot',
    text: answer
  })

  chatInput.value = ''
  toast.value = 'Chatbot response generated.'
  addLog('Used AI chatbot assistance', 'AI Chatbot', 'Success', session.value)
}

function saveDocument(doc) {
  const alreadySaved = savedDocuments.value.some((item) => item.title === doc.title)

  if (alreadySaved) {
    toast.value = 'This document is already saved.'
    return
  }

  savedDocuments.value.unshift({
    id: Date.now(),
    title: doc.title,
    category: doc.category,
    note: 'Saved for future reference.',
    updated: 'Current'
  })

  toast.value = `${doc.title} saved to personal collection.`
  addLog('Saved favourite document', 'Saved Documents', 'Success', session.value)
}

function removeSavedDocument(id) {
  savedDocuments.value = savedDocuments.value.filter((item) => item.id !== id)
  toast.value = 'Saved document removed.'
  addLog('Removed favourite document', 'Saved Documents', 'Success', session.value)
}

function addSampleNote() {
  if (savedDocuments.value.length === 0) {
    toast.value = 'Please save a document first before adding notes.'
    return
  }

  savedDocuments.value[0].note = 'Updated note: Review this document before department meeting.'
  toast.value = 'Personal note updated for the latest saved document.'
  addLog('Added personal note', 'Personal Notes', 'Success', session.value)
}

function markAllNotificationsRead() {
  notifications.value.forEach((notice) => {
    notice.read = true
  })

  toast.value = 'All notifications marked as read.'
  addLog('Marked notifications as read', 'Notifications', 'Success', session.value)
}

function cycleNotificationFrequency() {
  if (notificationFrequency.value === 'Instant') {
    notificationFrequency.value = 'Daily'
  } else if (notificationFrequency.value === 'Daily') {
    notificationFrequency.value = 'Weekly'
  } else {
    notificationFrequency.value = 'Instant'
  }

  toast.value = `Notification frequency changed to ${notificationFrequency.value}.`
}

function toggleUserStatus(user) {
  if (user.status === 'Active') {
    user.status = 'Suspended'
    toast.value = `${user.name} account suspended.`
    addLog('Suspended user account', 'User Management', 'Warning', 'Administrator')
  } else {
    user.status = 'Active'
    toast.value = `${user.name} account reactivated.`
    addLog('Reactivated user account', 'User Management', 'Success', 'Administrator')
  }
}

function createNewRole() {
  const roleExists = roles.value.some((role) => role.name === 'Document Reviewer')

  if (roleExists) {
    toast.value = 'Document Reviewer role already exists.'
    return
  }

  roles.value.push({
    name: 'Document Reviewer',
    description: 'Can review AI classification suggestions and approve document metadata.',
    permissions: ['Review Classification', 'Edit Metadata', 'Approve Category']
  })

  toast.value = 'New role Document Reviewer created.'
  addLog('Created new user role', 'Role Management', 'Success', 'Administrator')
}

function filterLogs() {
  logs.value = logs.value.filter((log) => log.result === 'Success')
  toast.value = 'Showing success logs only.'
}
</script>