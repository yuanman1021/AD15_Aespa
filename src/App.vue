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
        </button>
      </nav>

      <button class="ghost-button" @click="logoutPrototype">
        Logout Prototype
      </button>
    </aside>

    <main class="main-panel">
      <header class="topbar">
        <div>
          <p class="eyebrow">Johor HR Knowledge Hub</p>
          <h2>{{ currentPageTitle }}</h2>
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

      <!-- PUBLIC PORTAL -->
      <section v-if="screen === 'public'" class="grid-two">
        <div class="hero-card">
          <p class="eyebrow">Guest Access</p>
          <h3>Search official HR documents without logging in.</h3>
          <p>
            Search and preview public HR policies, circulars and guidelines.
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

      <!-- LOGIN / REGISTER -->
      <section v-if="screen === 'auth'" class="auth-layout">
        <div class="auth-info">
          <p class="eyebrow">Registration and Login</p>
          <h3>Secure access using official Johor government email.</h3>
          <p>
            Users can register, log in, reset password and use MFA protection.
          </p>

          <div class="metric-row">
            <div>
              <strong>JWT</strong>
              <span>Session control</span>
            </div>
            <div>
              <strong>MFA</strong>
              <span>Extra protection</span>
            </div>
            <div>
              <strong>Lock</strong>
              <span>Failed login handling</span>
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
            <p>Dedicated admin login for management functions.</p>

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

      <!-- PROFILE -->
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
          <p class="eyebrow">Profile Management</p>
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

      <!-- DOCUMENT MANAGEMENT -->
      <section v-if="screen === 'documents'" class="dashboard-grid">
        <div class="welcome-card">
          <p class="eyebrow">Document Management</p>
          <h3>Upload, classify, store, search and manage HR documents.</h3>
          <p>Administrators can manage documents and review AI suggestions.</p>
        </div>

        <StatCard label="Documents" :value="String(documents.length)" note="Total repository records" />
        <StatCard label="Pending Review" :value="String(pendingClassificationCount)" note="AI classification waiting" />
        <StatCard label="Archived" :value="String(archivedCount)" note="Old circular versions" />

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Document Upload</p>
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
              <p class="eyebrow">AI Classification Review</p>
              <h3>Suggested Document Categories</h3>
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
              <p class="eyebrow">Document Repository</p>
              <h3>Search and Manage Documents</h3>
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

      <!-- SMART SUPPORT -->
      <section v-if="screen === 'smart'" class="grid-two">
        <div class="hero-card">
          <p class="eyebrow">Smart Search</p>
          <h3>Search HR policies using normal questions.</h3>
          <p>Type a question and the system will suggest related documents.</p>

          <div class="search-box single">
            <input
              v-model="smartQuery"
              placeholder="Example: TASKA subsidy, promotion TBK, SPKN travel..."
              @keyup.enter="performSmartSearch"
            />
          </div>

          <div v-if="searchSuggestions.length > 0" class="suggestion-list">
            <button
              v-for="suggestion in searchSuggestions"
              :key="suggestion.suggestionId"
              @click="selectSearchSuggestion(suggestion)"
            >
              {{ suggestion.suggestionText }}
            </button>
          </div>

          <label class="field-label">Sort Results</label>
          <select v-model="smartSortBy" class="feedback-input">
            <option value="relevance">Relevance</option>
            <option value="latest">Latest Updated</option>
            <option value="title">Title A-Z</option>
            <option value="most_viewed">Most Viewed</option>
          </select>

          <button class="primary" @click="performSmartSearch">
            Perform Smart Search
          </button>

          <div class="history-panel">
            <p class="eyebrow">Recent Search History</p>

            <button
              v-for="history in recentSearchHistory"
              :key="history.searchId"
              class="history-chip"
              @click="smartQuery = history.searchQuery; performSmartSearch()"
            >
              {{ history.searchQuery }}
            </button>

            <p v-if="recentSearchHistory.length === 0" class="muted">
              No recent search history yet.
            </p>
          </div>
        </div>

        <div class="detail-card chatbot-card">
          <p class="eyebrow">HR Assistant</p>
          <h3>Ask the HR Chatbot</h3>

          <div class="chat-window">
            <div
              v-for="(message, index) in chatMessages"
              :key="index"
              :class="message.sender === 'bot' ? 'chat-bubble bot' : 'chat-bubble user'"
            >
              {{ message.text }}
            </div>
          </div>

          <div class="suggested-question-box">
            <p>Suggested questions</p>
            <div class="quick-question-row">
              <button
                v-for="question in suggestedQuestions"
                :key="question"
                @click="askSuggestedQuestion(question)"
              >
                {{ question }}
              </button>
            </div>
          </div>

          <div class="chat-input-row">
            <input
              v-model="chatInput"
              placeholder="Ask about login, documents, leave, promotion, salary, upload..."
              @keyup.enter="sendChatMessage"
            />
            <button class="primary" @click="sendChatMessage">
              Send
            </button>
          </div>

          <div class="assistant-actions">
            <button @click="rateChatbotResponse(1)">
              👍 Helpful
            </button>

            <button @click="rateChatbotResponse(0)">
              👎 Not Helpful
            </button>

            <button @click="escalateLatestQuestion">
              Escalate to HR Officer
            </button>
          </div>

          <input
            v-model="ratingComment"
            class="feedback-input"
            placeholder="Optional chatbot feedback comment..."
          />

          <div class="history-panel">
            <p class="eyebrow">Conversation History</p>

            <div
              v-for="item in conversationHistory"
              :key="item.conversationId"
              class="history-item"
            >
              <strong>{{ item.questionText }}</strong>
              <p>{{ item.responseText }}</p>
              <small>
                Status: {{ item.conversationStatus }}
                <span v-if="item.ratingValue !== null">
                  | Rating: {{ item.ratingValue === 1 ? 'Helpful' : 'Not Helpful' }}
                </span>
              </small>
            </div>

            <p v-if="conversationHistory.length === 0" class="muted">
              No conversation history yet.
            </p>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Recommendations</p>
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
              <h4 v-html="highlightMatchedContent(doc.title)"></h4>

              <p v-if="doc.reason">
                Reason: {{ doc.reason }}
              </p>

              <p v-if="doc.summary" v-html="highlightMatchedContent(doc.summary)"></p>

              <p v-if="doc.relevanceScore">
                Relevance Score: {{ doc.relevanceScore }}
              </p>

              <div>
                <span>{{ doc.category }}</span>
                <span>{{ doc.type }}</span>
              </div>

              <div class="button-row">
                <button class="primary" @click="saveDocument(doc)">
                  Save Document
                </button>

                <button @click="generateDocumentSummary(doc)">
                  Generate Summary
                </button>

                <button @click="openRecommendationReport(doc)">
                  Report Incorrect
                </button>
              </div>
            </article>
          </div>

          <div v-if="generatedSummary" class="summary-panel">
            <div class="section-title">
              <div>
                <p class="eyebrow">AI Document Summary</p>
                <h3>{{ selectedSummaryDoc?.title }}</h3>
              </div>

              <button @click="generatedSummary = ''">
                Close
              </button>
            </div>

            <p>{{ generatedSummary }}</p>
          </div>

          <div v-if="reportDialogOpen" class="report-panel">
            <div class="section-title">
              <div>
                <p class="eyebrow">Recommendation Report</p>
                <h3>Report Incorrect Recommendation</h3>
              </div>

              <button @click="cancelRecommendationReport">
                Cancel
              </button>
            </div>

            <p v-if="selectedRecommendation">
              Reporting: <strong>{{ selectedRecommendation.title }}</strong>
            </p>

            <label class="field-label">Reason</label>
            <select v-model="recommendationReportForm.reportReason">
              <option>Irrelevant</option>
              <option>Inaccurate</option>
              <option>Outdated</option>
              <option>Inappropriate</option>
              <option>Others</option>
            </select>

            <label class="field-label">Description</label>
            <textarea
              v-model="recommendationReportForm.reportDescription"
              placeholder="Explain why this recommendation is incorrect..."
            ></textarea>

            <button class="primary full" @click="submitRecommendationReport">
              Submit Report
            </button>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">FAQ</p>
              <h3>Frequently Asked Questions</h3>
            </div>

            <button @click="escalateLatestQuestion">
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

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Trending Documents</p>
              <h3>Currently Popular HR Documents</h3>
            </div>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in trendingDocuments"
              :key="doc.trendingId"
              class="doc-card"
    >
              <span class="status-pill green">Trending</span>
              <h4>{{ doc.title }}</h4>
              <p>{{ doc.summary }}</p>

              <div>
                <span>Views: {{ doc.viewCount }}</span>
                <span>Score: {{ doc.trendingScore }}</span>
              </div>
            </article>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Frequently Used Policies</p>
              <h3>Suggested Frequently Used Policies</h3>
            </div>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in frequentlyUsedPolicies"
              :key="doc.documentId"
              class="doc-card"
            >
              <span class="status-pill amber">Frequently Used</span>
              <h4>{{ doc.title }}</h4>
              <p>{{ doc.summary }}</p>

              <div>
                <span>{{ doc.category }}</span>
                <span>Views: {{ doc.totalViews }}</span>
              </div>
            </article>
          </div>
        </div>
      </section>

      <!-- PERSONAL STORAGE AND NOTIFICATION -->
      <section v-if="screen === 'personal'" class="dashboard-grid">
        <div class="welcome-card">
          <p class="eyebrow">Saved Documents and Notifications</p>
          <h3>Keep track of saved documents, notes and policy updates.</h3>
          <p>Users receive alerts when relevant or saved documents are updated.</p>
        </div>

        <StatCard label="Saved" :value="String(savedDocuments.length)" note="Personal collection" />
        <StatCard label="Unread Alerts" :value="String(unreadNotifications)" note="Policy updates" />
        <StatCard label="Notes" :value="String(savedDocuments.length)" note="Personal notes" />

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Notification Preferences</p>
              <h3>Manage Alerts</h3>
            </div>

            <button @click="saveNotificationPreferences">
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

            <SettingCard
              title="Delivery Channel"
              desc="Choose how notifications are delivered."
              :action="deliveryChannel"
              @click="deliveryChannel = deliveryChannel === 'In-System' ? 'Email' : deliveryChannel === 'Email' ? 'Both' : 'In-System'"
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
                <small>Type: {{ notice.type }}</small>
              </div>

              <div class="notification-actions">
                <em>{{ new Date(notice.time).toLocaleString() }}</em>

                <button
                  v-if="!notice.read"
                  @click="markNotificationRead(notice.id)"
                >
                  Mark as Read
                </button>
              </div>
            </div>

            <p v-if="notifications.length === 0" class="muted">
              No notifications available.
            </p>
          </div>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">User Feedback</p>
              <h3>Submit Feedback</h3>
            </div>
          </div>

          <label class="field-label">Feedback Category</label>
          <select v-model="feedbackForm.feedbackCategory" class="feedback-input">
            <option>System Issue</option>
            <option>Document Issue</option>
            <option>Chatbot Issue</option>
            <option>Search Issue</option>
            <option>Suggestion</option>
            <option>Others</option>
          </select>

          <label class="field-label">Feedback Content</label>
          <textarea
            v-model="feedbackForm.feedbackContent"
            class="feedback-textarea"
            placeholder="Write your feedback here..."
          ></textarea>

          <button class="primary" @click="submitUserFeedback">
            Submit Feedback
          </button>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Personal Storage</p>
              <h3>Saved Documents and Personal Notes</h3>
            </div>
          </div>

          <div
            v-if="noteForm.documentId"
            class="note-editor"
          >
            <div class="section-title">
              <div>
                <p class="eyebrow">Personal Note</p>
                <h3>{{ noteForm.title }}</h3>
              </div>

              <button @click="cancelNoteEditor">
                Cancel
              </button>
            </div>

            <label class="field-label">Note Content</label>
            <textarea
              v-model="noteForm.noteContent"
              class="feedback-textarea"
              placeholder="Write your personal note for this document..."
            ></textarea>

            <button class="primary" @click="savePersonalNote">
              Save Note
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="item in savedDocuments"
              :key="item.savedId"
              class="doc-card"
            >
              <span class="status-pill green">Saved</span>
              <h4>{{ item.title }}</h4>

              <p v-if="item.note">
                Note: {{ item.note }}
              </p>

              <p v-else class="muted">
                No personal note yet.
              </p>

              <div>
                <span>{{ item.category }}</span>
                <span>{{ new Date(item.updated).toLocaleDateString() }}</span>
              </div>

              <div class="button-row">
                <button @click="openNoteEditor(item)">
                  {{ item.note ? 'Edit Note' : 'Add Note' }}
                </button>

                <button
                  v-if="item.noteId"
                  @click="deletePersonalNote(item)"
                >
                  Delete Note
                </button>

                <button @click="removeSavedDocument(item.savedId)">
                  Remove
                </button>
              </div>
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
          <p>Admin can control user access, roles and system records.</p>
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
import { computed, ref, watch, onMounted } from 'vue'
import InputField from './components/InputField.vue'
import StatCard from './components/StatCard.vue'
import SettingCard from './components/SettingCard.vue'

function useLocalStorage(key, defaultValue) {
  let initialValue = defaultValue

  try {
    const storedValue = localStorage.getItem(key)

    if (storedValue) {
      initialValue = JSON.parse(storedValue)
    }
  } catch (error) {
    console.warn(`Invalid localStorage data for ${key}. Resetting to default value.`)
    localStorage.removeItem(key)
    initialValue = defaultValue
  }

  const data = ref(initialValue)

  watch(
    data,
    (newValue) => {
      try {
        localStorage.setItem(key, JSON.stringify(newValue))
      } catch (error) {
        console.warn(`Failed to save ${key} to localStorage.`)
      }
    },
    { deep: true }
  )

  return data
}

/* const documents = ref([])

async function loadDocuments() {
  try {
    const response = await fetch('http://localhost:3000/api/documents')
    documents.value = await response.json()
  } catch (error) {
    toast.value = 'Failed to load documents from database.'
  }
}

onMounted(() => {
  loadDocuments()
}) */

const documents = ref([])
const currentUserId = 2

const selectedDoc = ref({
  documentId: null,
  referenceNo: '',
  title: 'Loading documents...',
  category: '',
  type: '',
  status: '',
  access: 'Public',
  effectiveDate: '',
  version: '',
  reason: '',
  summary: 'Please wait while documents are loaded from the database.'
})

const smartResults = ref([])
const reportDialogOpen = ref(false)
const selectedRecommendation = ref(null)

const recommendationReportForm = ref({
  reportReason: 'Irrelevant',
  reportDescription: ''
})

async function loadDocuments() {
  try {
    const response = await fetch('http://localhost:3000/api/documents')

    if (!response.ok) {
      throw new Error('Failed to load documents')
    }

    documents.value = await response.json()

    if (documents.value.length > 0) {
      selectedDoc.value = documents.value[0]
      smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
    }
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load documents from database.'
  }
}

async function loadRecommendations() {
  try {
    const response = await fetch(`http://localhost:3000/api/recommendations/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load recommendations')
    }

    const data = await response.json()

    smartResults.value = data.length > 0
      ? data
      : documents.value.filter((doc) => doc.access !== 'Restricted')
  } catch (error) {
    console.error(error)
    smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
    toast.value = 'Failed to load recommendations from database.'
  }
}

async function loadFaqs() {
  try {
    const response = await fetch('http://localhost:3000/api/faqs')

    if (!response.ok) {
      throw new Error('Failed to load FAQs')
    }

    faqs.value = await response.json()
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load FAQs from database.'
  }
}

async function loadConversationHistory() {
  try {
    const response = await fetch(`http://localhost:3000/api/chatbot/conversations/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load conversation history')
    }

    conversationHistory.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function loadNotifications() {
  try {
    const response = await fetch(`http://localhost:3000/api/notifications/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load notifications')
    }

    notifications.value = await response.json()
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load notifications from database.'
  }
}

async function loadNotificationPreferences() {
  try {
    const response = await fetch(`http://localhost:3000/api/notification-preferences/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load notification preferences')
    }

    const data = await response.json()

    policyUpdateEnabled.value = data.policyUpdateEnabled === 1
    savedUpdateEnabled.value = data.savedUpdateEnabled === 1
    notificationFrequency.value = data.notificationFrequency || 'Daily'
    deliveryChannel.value = data.deliveryChannel || 'In-System'
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load notification preferences.'
  }
}

async function loadSavedDocuments() {
  try {
    const response = await fetch(`http://localhost:3000/api/saved-documents/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load saved documents')
    }

    savedDocuments.value = await response.json()
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to load saved documents from database.'
  }
}

onMounted(async () => {
  await loadDocuments()
  await loadRecommendations()
  await loadFaqs()
  await loadConversationHistory()
  await loadNotifications()
  await loadNotificationPreferences()
  await loadSearchSuggestions()
  await loadRecentSearchHistory()
  await loadTrendingDocuments()
  await loadFrequentlyUsedPolicies()
  await loadSavedDocuments()
})

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

const notifications = ref([])

const savedDocuments = ref([])

const faqs = ref([])

const suggestedQuestions = [
  'How do I reset my password?',
  'How do I register an account?',
  'Can guest users view restricted documents?',
  'How do I search for leave policy?',
  'How do I find promotion guidelines?',
  'How do I upload a HR document?',
  'How does AI classification work?',
  'How do notifications work?',
  'How do I save a document?',
  'What salary guideline is available?'
]

const navItems = [
  { id: 'public', label: 'Public Portal' },
  { id: 'auth', label: 'Login / Register' },
  { id: 'profile', label: 'Profile & Security' },
  { id: 'documents', label: 'Document Management' },
  { id: 'smart', label: 'Smart Support' },
  { id: 'personal', label: 'Notifications & Saved' },
  { id: 'admin', label: 'Admin Workspace' }
]

const authTabs = [
  { id: 'login', label: 'User Login' },
  { id: 'register', label: 'Register' },
  { id: 'reset', label: 'Reset Password' },
  { id: 'admin', label: 'Admin Login' }
]

//const categories = ['All', 'Leave Policy', 'Promotion', 'Discipline', 'Salary', 'Loan']
const categories = [
  'All',
  'Staff Benefits',
  'Promotion',
  'Overseas Travel',
  'Contract Service',
  'Promotion and Discipline'
]

const screen = ref('public')
const query = ref('')
const category = ref('All')
//const selectedDoc = ref(documents.value[0])
const authMode = ref('login')
const session = ref('Guest')
const toast = ref('Welcome to Johor HR Knowledge Hub interactive prototype.')

const repoQuery = ref('')
const repoType = ref('All Types')
const smartQuery = ref('')
const smartSortBy = ref('relevance')
const searchSuggestions = ref([])
const recentSearchHistory = ref([])
const trendingDocuments = ref([])
const frequentlyUsedPolicies = ref([])
const lastSearchKeyword = ref('')

watch(smartQuery, () => {
  loadSearchSuggestions()
})
//const smartResults = ref(documents.value.filter((doc) => doc.access !== 'Restricted'))

const mfaEnabled = ref(true)
const policyUpdateEnabled = ref(true)
const savedUpdateEnabled = ref(true)
const notificationFrequency = ref('Daily')
const deliveryChannel = ref('In-System')

const feedbackForm = ref({
  feedbackCategory: 'System Issue',
  feedbackContent: ''
})

const noteForm = ref({
  savedId: null,
  documentId: null,
  title: '',
  noteContent: ''
})

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
const conversationHistory = ref([])
const latestConversationId = ref(null)
const generatedSummary = ref('')
const selectedSummaryDoc = ref(null)
const ratingComment = ref('')
const chatMessages = ref([
  {
    sender: 'bot',
    text:
      'Hi, I am the Johor HR assistant. You can ask me about login, registration, password reset, documents, policy search, uploads, recommendations, notifications, and saved documents.'
  }
])

const currentPageTitle = computed(() => {
  const found = navItems.find((item) => item.id === screen.value)
  return found ? found.label : 'Dashboard'
})

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
  toast.value = `${type} session created.`
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

async function loadSearchSuggestions() {
  try {
    const response = await fetch(
      `http://localhost:3000/api/search-suggestions?keyword=${encodeURIComponent(smartQuery.value)}`
    )

    if (!response.ok) {
      throw new Error('Failed to load search suggestions')
    }

    searchSuggestions.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

function selectSearchSuggestion(suggestion) {
  smartQuery.value = suggestion.suggestionText
  performSmartSearch()
}

async function loadRecentSearchHistory() {
  try {
    const response = await fetch(`http://localhost:3000/api/search-history/${currentUserId}`)

    if (!response.ok) {
      throw new Error('Failed to load recent search history')
    }

    recentSearchHistory.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function loadTrendingDocuments() {
  try {
    const response = await fetch('http://localhost:3000/api/trending-documents')

    if (!response.ok) {
      throw new Error('Failed to load trending documents')
    }

    trendingDocuments.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function loadFrequentlyUsedPolicies() {
  try {
    const response = await fetch('http://localhost:3000/api/frequently-used-policies')

    if (!response.ok) {
      throw new Error('Failed to load frequently used policies')
    }

    frequentlyUsedPolicies.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function performSmartSearch() {
  if (!smartQuery.value.trim()) {
    smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
    toast.value = 'Showing general recommended documents.'
    return
  }

  try {
    const response = await fetch(
      `http://localhost:3000/api/search?userId=${currentUserId}&keyword=${encodeURIComponent(smartQuery.value)}&sortBy=${smartSortBy.value}`
    )

    if (!response.ok) {
      throw new Error('Smart search failed')
    }

    const data = await response.json()

    smartResults.value = data.results.length > 0
      ? data.results
      : documents.value.filter((doc) => doc.access !== 'Restricted')

    lastSearchKeyword.value = smartQuery.value

    await loadRecentSearchHistory()
    await loadSearchSuggestions()

    toast.value = 'Smart search completed. Results ranked and saved to search history.'
    addLog('Performed smart search', 'Smart Search', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Smart search failed.'
  }
}

function highlightMatchedContent(text) {
  if (!text) return ''

  const keyword = lastSearchKeyword.value || smartQuery.value

  if (!keyword.trim()) {
    return text
  }

  const escapedKeyword = keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  const regex = new RegExp(`(${escapedKeyword})`, 'gi')

  return text.replace(regex, '<mark>$1</mark>')
}

/*function refreshRecommendations() {
  smartResults.value = documents.value.filter((doc) => doc.access !== 'Restricted')
  toast.value = 'Recommendations refreshed based on department and recent searches.'
  addLog('Refreshed recommendations', 'Recommendation', 'Success', session.value)
}*/

async function refreshRecommendations() {
  try {
    const response = await fetch(
      `http://localhost:3000/api/recommendations/refresh/${currentUserId}`,
      {
        method: 'POST'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to refresh recommendations')
    }

    await loadRecommendations()

    toast.value = 'Recommendations refreshed based on department and document activity.'
    addLog('Refreshed recommendations', 'Recommendation', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to refresh recommendations.'
  }
}

function openRecommendationReport(doc) {
  if (!doc.recommendationId) {
    toast.value = 'This recommendation cannot be reported because it has no recommendation record.'
    return
  }

  selectedRecommendation.value = doc
  recommendationReportForm.value = {
    reportReason: 'Irrelevant',
    reportDescription: ''
  }
  reportDialogOpen.value = true
}

async function submitRecommendationReport() {
  if (!selectedRecommendation.value) {
    toast.value = 'Please select a recommendation first.'
    return
  }

  try {
    const response = await fetch('http://localhost:3000/api/recommendation-reports', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        recommendationId: selectedRecommendation.value.recommendationId,
        userId: currentUserId,
        reportReason: recommendationReportForm.value.reportReason,
        reportDescription: recommendationReportForm.value.reportDescription
      })
    })

    if (!response.ok) {
      throw new Error('Failed to submit recommendation report')
    }

    toast.value = 'Incorrect recommendation report submitted to administrator.'
    reportDialogOpen.value = false
    selectedRecommendation.value = null

    await loadRecommendations()

    addLog('Reported incorrect recommendation', 'Recommendation', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to submit recommendation report.'
  }
}

function cancelRecommendationReport() {
  reportDialogOpen.value = false
  selectedRecommendation.value = null
}

function askSuggestedQuestion(question) {
  chatInput.value = question
  sendChatMessage()
}

async function sendChatMessage() {
  const question = chatInput.value.trim()

  if (!question) {
    toast.value = 'Please type a question first.'
    return
  }

  chatMessages.value.push({
    sender: 'user',
    text: question
  })

  const answer = generateChatbotAnswer(question)

  chatMessages.value.push({
    sender: 'bot',
    text: answer
  })

  try {
    const response = await fetch('http://localhost:3000/api/chatbot/conversations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        questionText: question,
        responseText: answer,
        confidenceScore: 88.00
      })
    })

    const data = await response.json()
    latestConversationId.value = data.conversationId

    await loadConversationHistory()
  } catch (error) {
    console.error(error)
    toast.value = 'Chatbot answered, but conversation was not saved.'
  }

  chatInput.value = ''
  toast.value = 'Chatbot response generated.'
  addLog('Used HR chatbot assistance', 'AI Chatbot', 'Success', session.value)
}

async function rateChatbotResponse(value) {
  if (!latestConversationId.value) {
    toast.value = 'Please ask the chatbot a question before rating.'
    return
  }

  try {
    const response = await fetch(
      `http://localhost:3000/api/chatbot/conversations/${latestConversationId.value}/rating`,
      {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          ratingValue: value,
          ratingComment: ratingComment.value
        })
      }
    )

    if (!response.ok) {
      throw new Error('Failed to rate chatbot response')
    }

    toast.value = value === 1
      ? 'Thank you for rating the chatbot response as helpful.'
      : 'Thank you. Your feedback will help improve chatbot response quality.'

    ratingComment.value = ''
    await loadConversationHistory()
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save chatbot rating.'
  }
}

async function generateDocumentSummary(doc) {
  try {
    const response = await fetch('http://localhost:3000/api/document-summaries', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        documentId: doc.documentId,
        userId: currentUserId
      })
    })

    if (!response.ok) {
      throw new Error('Failed to generate document summary')
    }

    const data = await response.json()

    selectedSummaryDoc.value = doc
    generatedSummary.value = data.summaryText

    toast.value = 'Document summary generated.'
    addLog('Generated document summary', 'AI Summary', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to generate document summary.'
  }
}

async function escalateLatestQuestion() {
  if (!latestConversationId.value && chatMessages.value.length <= 1) {
    toast.value = 'Please ask the chatbot a question before escalation.'
    return
  }

  const latestUserMessage = [...chatMessages.value]
    .reverse()
    .find((message) => message.sender === 'user')

  try {
    const response = await fetch('http://localhost:3000/api/escalation-requests', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        conversationId: latestConversationId.value,
        userId: currentUserId,
        escalationQuestion: latestUserMessage ? latestUserMessage.text : 'General HR question',
        escalationDescription: 'User requested HR officer support from chatbot panel.'
      })
    })

    if (!response.ok) {
      throw new Error('Failed to escalate question')
    }

    toast.value = 'Question escalated to HR officer.'
    await loadConversationHistory()
    addLog('Escalated question to HR officer', 'AI Chatbot', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to escalate question.'
  }
}

function generateChatbotAnswer(question) {
  const text = question.toLowerCase()

  if (text.includes('login') || text.includes('log in')) {
    return 'To log in, open Login / Register, enter your government email and password, then complete MFA if it is enabled.'
  }

  if (text.includes('register') || text.includes('registration') || text.includes('account')) {
    return 'To register an account, open Login / Register and choose Register. Enter your full name, government email, department, designation level and password.'
  }

  if (text.includes('reset') || text.includes('forgot') || text.includes('password')) {
    return 'To reset your password, open Login / Register, choose Reset Password, enter your registered email, request a reset link, then enter the verification code and new password.'
  }

  if (text.includes('mfa') || text.includes('multi-factor') || text.includes('verification code')) {
    return 'MFA adds extra login protection. You can enable or disable MFA from Profile & Security.'
  }

  if (text.includes('guest') || text.includes('public')) {
    return 'Guest users can search and view public HR documents only. Registered or restricted documents require login.'
  }

  if (text.includes('restricted') || text.includes('access')) {
    return 'Restricted documents require a registered account and the correct permission level.'
  }

  if (text.includes('download')) {
    return 'Document download is available for registered users depending on the document access level. Public users can preview public details only.'
  }

  if (text.includes('upload') || text.includes('pdf')) {
    return 'Administrators can upload HR documents from Document Management. The form requires title, reference number, issuing authority, effective date, document type and category.'
  }

  if (text.includes('metadata') || text.includes('extract')) {
    return 'After upload, the system extracts document metadata such as title, reference number, issuing authority, effective date, type and category.'
  }

  if (text.includes('classify') || text.includes('classification') || text.includes('category')) {
    return 'The AI classification section suggests document categories and tags. Administrators can review and approve them.'
  }

  if (text.includes('archive') || text.includes('version')) {
    return 'Administrators can preview repository documents, archive old documents, and upload new versions when a document is amended.'
  }

  if (text.includes('notification') || text.includes('alert')) {
    return 'Notifications inform users when relevant policies are added, saved documents are updated, or weekly recommendations are ready.'
  }

  if (text.includes('save') || text.includes('saved') || text.includes('bookmark')) {
    return 'Users can save recommended documents into their personal collection and add personal notes.'
  }

  if (text.includes('recommend') || text.includes('recommendation')) {
    return 'Recommendations are based on department, role, recent searches, viewed documents and related HR policy content.'
  }

  if (text.includes('leave') || text.includes('cuti') || text.includes('sick')) {
    return findDocumentAnswer('Leave Policy')
  }

  if (text.includes('promotion') || text.includes('pangkat')) {
    return findDocumentAnswer('Promotion')
  }

  if (text.includes('salary') || text.includes('gaji') || text.includes('allowance')) {
    return findDocumentAnswer('Salary')
  }

  if (text.includes('loan') || text.includes('pinjaman')) {
    return findDocumentAnswer('Loan')
  }

  if (text.includes('discipline') || text.includes('tatatertib')) {
    return findDocumentAnswer('Discipline')
  }

  const matchedDocument = documents.value.find((doc) => {
    const content = `${doc.title} ${doc.referenceNo} ${doc.category} ${doc.summary}`.toLowerCase()
    return text
      .split(' ')
      .some((word) => word.length > 3 && content.includes(word))
  })

  if (matchedDocument) {
    return `I found a related document: ${matchedDocument.title}. Reference number: ${matchedDocument.referenceNo}. Category: ${matchedDocument.category}. Access level: ${matchedDocument.access}.`
  }

  return 'I am not fully sure, but you can ask about login, registration, password reset, document upload, document search, leave policy, promotion, salary, notifications, or saved documents.'
}

function findDocumentAnswer(categoryName) {
  const matchedDocs = documents.value.filter((doc) => doc.category === categoryName)

  if (matchedDocs.length === 0) {
    return `I could not find a document under ${categoryName} yet. Please check the document repository or ask an administrator to upload it.`
  }

  const docList = matchedDocs
    .map((doc) => `${doc.title} (${doc.referenceNo})`)
    .join(', ')

  return `I found ${matchedDocs.length} related document(s) under ${categoryName}: ${docList}. You can open the Public Portal or Document Repository to view the details.`
}

async function saveDocument(doc) {
  try {
    const response = await fetch('http://localhost:3000/api/saved-documents', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        documentId: doc.documentId
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save document')
    }

    await loadSavedDocuments()

    toast.value = `${doc.title} saved to personal collection.`
    addLog('Saved favourite document', 'Saved Documents', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save document.'
  }
}

async function removeSavedDocument(savedId) {
  try {
    const response = await fetch(`http://localhost:3000/api/saved-documents/${savedId}`, {
      method: 'DELETE'
    })

    if (!response.ok) {
      throw new Error('Failed to remove saved document')
    }

    await loadSavedDocuments()

    toast.value = 'Saved document removed.'
    addLog('Removed favourite document', 'Saved Documents', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to remove saved document.'
  }
}

function openNoteEditor(item) {
  noteForm.value = {
    savedId: item.savedId,
    documentId: item.documentId,
    title: item.title,
    noteContent: item.note || ''
  }
}

async function savePersonalNote() {
  if (!noteForm.value.documentId) {
    toast.value = 'Please select a saved document first.'
    return
  }

  if (!noteForm.value.noteContent.trim()) {
    toast.value = 'Please enter a note before saving.'
    return
  }

  try {
    const response = await fetch('http://localhost:3000/api/personal-notes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        documentId: noteForm.value.documentId,
        noteContent: noteForm.value.noteContent
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save personal note')
    }

    await loadSavedDocuments()

    noteForm.value = {
      savedId: null,
      documentId: null,
      title: '',
      noteContent: ''
    }

    toast.value = 'Personal note saved.'
    addLog('Saved personal note', 'Personal Notes', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save personal note.'
  }
}

async function deletePersonalNote(item) {
  if (!item.noteId) {
    toast.value = 'This document has no note to delete.'
    return
  }

  try {
    const response = await fetch(`http://localhost:3000/api/personal-notes/${item.noteId}`, {
      method: 'DELETE'
    })

    if (!response.ok) {
      throw new Error('Failed to delete personal note')
    }

    await loadSavedDocuments()

    toast.value = 'Personal note deleted.'
    addLog('Deleted personal note', 'Personal Notes', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to delete personal note.'
  }
}

function cancelNoteEditor() {
  noteForm.value = {
    savedId: null,
    documentId: null,
    title: '',
    noteContent: ''
  }
}

async function markAllNotificationsRead() {
  try {
    const response = await fetch(
      `http://localhost:3000/api/notifications/read-all/${currentUserId}`,
      {
        method: 'PATCH'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to mark all notifications as read')
    }

    await loadNotifications()

    toast.value = 'All notifications marked as read.'
    addLog('Marked notifications as read', 'Notifications', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to mark notifications as read.'
  }
}

async function markNotificationRead(notificationId) {
  try {
    const response = await fetch(
      `http://localhost:3000/api/notifications/${notificationId}/read`,
      {
        method: 'PATCH'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to mark notification as read')
    }

    await loadNotifications()

    toast.value = 'Notification marked as read.'
    addLog('Marked notification as read', 'Notifications', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to mark notification as read.'
  }
}

function cycleNotificationFrequency() {
  if (notificationFrequency.value === 'Instant') {
    notificationFrequency.value = 'Daily'
  } else if (notificationFrequency.value === 'Daily') {
    notificationFrequency.value = 'Weekly'
  } else {
    notificationFrequency.value = 'Instant'
  }

  toast.value = `Notification frequency changed to ${notificationFrequency.value}. Click Save Preferences to update database.`
}

async function saveNotificationPreferences() {
  try {
    const response = await fetch(
      `http://localhost:3000/api/notification-preferences/${currentUserId}`,
      {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          policyUpdateEnabled: policyUpdateEnabled.value,
          savedUpdateEnabled: savedUpdateEnabled.value,
          notificationFrequency: notificationFrequency.value,
          deliveryChannel: deliveryChannel.value
        })
      }
    )

    if (!response.ok) {
      throw new Error('Failed to save notification preferences')
    }

    toast.value = 'Notification preferences updated.'
    addLog('Updated notification preferences', 'Notifications', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to save notification preferences.'
  }
}

async function submitUserFeedback() {
  if (!feedbackForm.value.feedbackContent.trim()) {
    toast.value = 'Please enter your feedback before submitting.'
    return
  }

  try {
    const response = await fetch('http://localhost:3000/api/user-feedback', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        userId: currentUserId,
        feedbackCategory: feedbackForm.value.feedbackCategory,
        feedbackContent: feedbackForm.value.feedbackContent
      })
    })

    if (!response.ok) {
      throw new Error('Failed to submit feedback')
    }

    feedbackForm.value = {
      feedbackCategory: 'System Issue',
      feedbackContent: ''
    }

    toast.value = 'Feedback submitted successfully.'
    addLog('Submitted user feedback', 'User Feedback', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to submit feedback.'
  }
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