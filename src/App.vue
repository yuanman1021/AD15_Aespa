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
          v-for="item in visibleNavItems"
          :key="item.id"
          :class="{ active: screen === item.id }"
          @click="screen = item.id"
        >
          <span>{{ item.label }}</span>
        </button>
      </nav>

      <button class="ghost-button" @click="logoutPrototype">
        Logout 
      </button>
    </aside>

    <main class="main-panel">
      <header class="topbar">
        <div>
          <p class="eyebrow">Johor HR Knowledge Hub</p>
          <h2>{{ currentPageTitle }}</h2>
        </div>

        <div class="top-actions">
         <button @click="screen = 'auth'; authMode = 'login'">User Login</button>
          <button class="primary" @click="screen = 'auth'; authMode = 'admin'">
            Admin Login
          </button>
        </div>
      </header>

      <div v-if="toast" :class="['toast', toastType]">
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

       

          <div
            v-if="session === 'Admin'"
              class="wide-card"
          >

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
       <div
    v-if="publicDetailsModalOpen"
    class="modal-overlay"
    @click.self="publicDetailsModalOpen = false"
  >
    <div class="modal-card public-detail-modal">
      <div class="section-title">
        <div>
          <p class="eyebrow">Public Document Details</p>
          <h3>{{ selectedDoc.title }}</h3>
        </div>

        <button @click="publicDetailsModalOpen = false">
          Close
        </button>
      </div>

      <div class="public-detail-header">
        <span class="status-pill green">{{ selectedDoc.access }}</span>
        <span class="status-pill">{{ selectedDoc.status }}</span>
              <span class="status-pill">Version {{ selectedDoc.version }}</span>
            </div>

            <dl>
              <div>
                <dt>Reference Number</dt>
                <dd>{{ selectedDoc.referenceNo }}</dd>
              </div>
              <div>
                <dt>Category</dt>
                <dd>{{ selectedDoc.category }}</dd>
              </div>
              <div>
                <dt>Document Type</dt>
                <dd>{{ selectedDoc.type }}</dd>
              </div>
              <div>
                <dt>Effective Date</dt>
                <dd>{{ selectedDoc.effectiveDate }}</dd>
              </div>
              <div>
                <dt>Issuing Department</dt>
                <dd>Johor Human Resource Management Division</dd>
              </div>
              <div>
                <dt>Document Purpose</dt>
                <dd>Provides official guidance for HR-related procedures.</dd>
              </div>
            </dl>

            <div class="public-summary-box">
              <h4>Document Summary</h4>
              <p>{{ selectedDoc.summary }}</p>
            </div>

            <div class="public-summary-box">
              <h4>Prototype Note</h4>
              <p>
                This page shows the public document information available to guest users.
                Additional actions such as download, bookmark, AI chatbot, recommendations
                and notification subscription require login.
              </p>
            </div>

            <div class="button-row">
              <button class="primary" @click="publicDetailsModalOpen = false">
                Back to Public Portal
              </button>

              <button @click="screen = 'auth'; authMode = 'register'; publicDetailsModalOpen = false">
                Request Account Registration
              </button>
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

            <button
              class="link-button"
              @click="resetAccountType = 'user'; resetModalOpen = true"
            >
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
            <button
              class="link-button"
              @click="resetAccountType = 'admin'; resetModalOpen = true"
            >
              Forgot password?
            </button>
          </div>
                </div>

        <div v-if="resetModalOpen" class="modal-overlay" @click.self="resetModalOpen = false">
          <div class="modal-card reset-form-card">
            <div class="section-title">
              <div>
                <p class="eyebrow">Account Recovery</p>
                <h3>
                  {{ resetAccountType === 'admin' ? 'Reset Admin Password' : 'Reset User Password' }}
                </h3>
              </div>

              <button @click="resetModalOpen = false">
                Cancel
              </button>
            </div>

            <p class="muted">
              {{
                resetAccountType === 'admin'
                  ? 'Enter your administrator email, verification code and new password.'
                  : 'Enter your registered government email, verification code and new password.'
              }}
            </p>

            <InputField
              v-model="resetForm.email"
              :label="resetAccountType === 'admin' ? 'Admin Email' : 'Registered Email'"
              :placeholder="resetAccountType === 'admin' ? 'admin@johor.gov.my' : 'user@johor.gov.my'"
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
              @click="changePasswordModalOpen = true"
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
              @click="deactivationModalOpen = true"
            />
          </div>
        </div>

        <div
          v-if="deactivationModalOpen"
          class="modal-overlay"
          @click.self="deactivationModalOpen = false"
        >
          <div class="modal-card deactivation-form-card">
            <div class="section-title">
              <div>
                <p class="eyebrow">Account Deactivation</p>
                <h3>Request Account Deactivation</h3>
              </div>

              <button @click="cancelDeactivationRequest">
                Cancel
              </button>
            </div>

            <p class="muted">
              Submit a request to deactivate your account. The request will be reviewed by an administrator before the account is deactivated.
            </p>

            <label class="input-group">
              <span>Reason for Deactivation</span>
              <textarea
                v-model="deactivationForm.reason"
                class="feedback-textarea"
                placeholder="Example: I no longer need access to the Johor HR Knowledge Hub."
              ></textarea>
            </label>

            <InputField
              v-model="deactivationForm.confirmText"
              label="Type DEACTIVATE to confirm"
              placeholder="DEACTIVATE"
            />

            <button class="primary full danger-button" @click="submitDeactivationRequest">
              Submit Deactivation Request
            </button>
          </div>
        </div>
      </section>

        <div
          v-if="changePasswordModalOpen"
          class="modal-overlay"
          @click.self="cancelChangePassword"
        >
          <div class="modal-card">
            <div class="section-title">
              <div>
                <p class="eyebrow">Account Security</p>
                <h3>Change Password</h3>
              </div>

              <button @click="cancelChangePassword">
                Cancel
              </button>
            </div>

            <InputField
              v-model="changePasswordForm.currentPassword"
              label="Current Password"
              placeholder="Enter current password"
              type="password"
            />

            <InputField
              v-model="changePasswordForm.newPassword"
              label="New Password"
              placeholder="Enter new password"
              type="password"
            />

            <InputField
              v-model="changePasswordForm.confirmPassword"
              label="Confirm New Password"
              placeholder="Re-enter new password"
              type="password"
            />

            <button class="primary full" @click="submitChangePassword">
              Update Password
            </button>
          </div>
        </div>

     <!-- =====================================================
           SUBSYSTEM 2 — KNOWLEDGE AND DOCUMENT MANAGEMENT
           ===================================================== -->
      <section v-if="screen === 'documents'" class="dashboard-grid">

        <!-- Welcome banner -->
        <div class="welcome-card">
  
          <p class="eyebrow">Document Management</p>
          <h3>Upload, classify, store, search and manage HR documents.</h3>
          <p>Administrators can upload official HR documents, review AI classification suggestions, manage the document repository and archive outdated circulars.</p>
        </div>

              <div
  v-if="session === 'Admin'"
  class="stats-grid"
>
        <StatCard label="Total Documents" :value="String(documents.length)" note="Repository records" />
        <StatCard label="Pending Review" :value="String(pendingClassificationCount)" note="AI classification queue" />
        <StatCard label="Archived" :value="String(archivedCount)" note="Old circular versions" />

        <StatCard
  label="Published"
  :value="String(documents.filter(d => d.status === 'Published').length)"
  note="Available documents"
/>

<StatCard
  label="Restricted"
  :value="String(documents.filter(d => d.access === 'Restricted').length)"
  note="Protected documents"
/>
</div>

        <!-- ─── MODULE 4.1 DOCUMENT UPLOAD ─── -->
        <div v-if="session === 'Admin'"
        class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Document Upload</p>
              <h3>Upload HR Document</h3>
            </div>
            <div style="display:flex;gap:10px;">
              <button
                class="primary"
                @click="uploadDocument"
                :disabled="session !== 'Admin'"
              >
                Upload & Submit for Review
              </button>

              <button
                 @click="saveDocumentAsDraft"
                :disabled="session !== 'Admin'"
                >
                Save as Draft
            </button>
            </div>
          </div>

          <!-- Row 1: core metadata -->
          <div class="form-grid">
            <InputField
              v-model="uploadForm.title"
              label="Document Title *"
              placeholder="Cuti Sakit Pegawai Kerajaan Johor"
            />
            <InputField
              v-model="uploadForm.referenceNo"
              label="Official Reference Number *"
              placeholder="JHR/CUTI/2026/01"
            />
            <InputField
              v-model="uploadForm.issuingAuthority"
              label="Issuing Authority *"
              placeholder="Human Resource Management Division"
            />
            <InputField
              v-model="uploadForm.effectiveDate"
              label="Effective Date *"
              placeholder="2026-01-12"
            />
            <InputField
              v-model="uploadForm.expiryDate"
              label="Expiry Date"
              placeholder="2028-01-12 (optional)"
            />
            <label class="input-group">
              <span>Department Tag</span>
              <select v-model="uploadForm.departmentTag">
                <option value="">— Select Department —</option>
                <option>Human Resource Management Division</option>
                <option>Finance Division</option>
                <option>Administration Division</option>
                <option>Legal Division</option>
                <option>Public Works Department</option>
                <option>Education Department</option>
                <option>Health Department</option>
              </select>
            </label>
          </div>

          <!-- Row 2: type / category / access / language -->
          <div class="form-grid">
            <label class="input-group">
              <span>Document Type *</span>
              <select v-model="uploadForm.type">
                <option>Circular</option>
                <option>Guideline</option>
                <option>Policy</option>
                <option>Memo</option>
                <option>Form</option>
                <option>Reference Document</option>
                <option>Administrative Decision</option>
              </select>
            </label>
            <label class="input-group">
              <span>Category *</span>
              <select v-model="uploadForm.category">
                <option>Leave Policy</option>
                <option>Promotion</option>
                <option>Discipline</option>
                <option>Salary</option>
                <option>Staff Benefits</option>
                <option>Overseas Travel</option>
                <option>Contract Service</option>
                <option>Promotion and Discipline</option>
              </select>
            </label>
            <label class="input-group">
              <span>Access Level *</span>
              <select v-model="uploadForm.access">
                <option>Public</option>
                <option>Registered</option>
                <option>Restricted</option>
              </select>
            </label>
            <label class="input-group">
              <span>Language *</span>
              <select v-model="uploadForm.language">
                <option value="BM">Bahasa Malaysia</option>
                <option value="EN">English</option>
                <option value="BOTH">Both (BM &amp; EN)</option>
              </select>
            </label>
          </div>

          <!-- File picker -->
          <label class="input-group" style="margin-bottom:16px;">
            <span>PDF File *</span>
            <div class="file-upload-box" @click="triggerFileInput" @dragover.prevent @drop.prevent="handleFileDrop">
              <input
                ref="fileInputRef"
                type="file"
                accept=".pdf"
                style="display:none;"
                @change="handleFileSelect"
              />
              <div v-if="!uploadForm.fileName" class="file-upload-placeholder">
                <strong>Click to choose PDF file</strong>
                <span>or drag and drop here · PDF only · Max 20MB</span>
              </div>
              <div v-else class="file-upload-selected">
                <span class="status-pill green">✓ File selected</span>
                <strong>{{ uploadForm.fileName }}</strong>
                <span>{{ uploadForm.fileSizeKb ? (uploadForm.fileSizeKb / 1024).toFixed(2) + ' MB' : '' }}</span>
                <button @click.stop="clearFile" style="color:var(--johor-red);">Remove</button>
              </div>
            </div>
          </label>

          <!-- Upload status message -->
          <div v-if="uploadStatus" :class="uploadStatus.type === 'success' ? 'upload-status success' : 'upload-status error'">
            {{ uploadStatus.message }}
          </div>
        </div>

        <!-- ─── MODULE 4.2 AI CLASSIFICATION REVIEW ─── -->
        <div v-if="session === 'Admin'"
        class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">AI Classification Review</p>
              <h3>Suggested Document Categories</h3>
            </div>
            <button @click="refreshClassification">Refresh Suggestions</button>
          </div>
          <p style="color:var(--muted);margin:0 0 18px;">Review and approve or modify the AI-suggested categories and department tags before each document is published.</p>

          <div v-if="classificationQueue.length === 0" class="empty-state">
            <p>No documents waiting for classification review.</p>
          </div>

          <div class="doc-grid" v-else>
            <article
              v-for="item in classificationQueue"
              :key="item.id"
              class="doc-card"
            >
              <span :class="{
                'status-pill green': item.status === 'Approved',
                'status-pill amber': item.status === 'Pending Review' || item.status === 'Needs Edit',
                'status-pill red': item.status === 'Rejected'
              }">{{ item.status }}</span>

              <h4>{{ item.title }}</h4>

              <!-- Confidence score bar -->
              <div style="display:flex;align-items:center;gap:8px;margin:0;">
                <span style="font-size:12px;color:var(--muted);font-weight:700;">AI Confidence</span>
                <div class="confidence-bar">
                  <div class="confidence-fill" :style="{ width: (item.confidence || 75) + '%' }"></div>
                </div>
                <span style="font-size:12px;font-weight:800;color:var(--johor-blue);">{{ item.confidence || 75 }}%</span>
              </div>

              <!-- Suggested categories -->
              <div>
                <span style="font-size:12px;color:var(--muted);font-weight:700;display:block;margin-bottom:6px;">Suggested Categories</span>
                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                  <span v-for="s in item.suggestions" :key="s">{{ s }}</span>
                </div>
              </div>

              <!-- Suggested department tags -->
              <div>
                <span style="font-size:12px;color:var(--muted);font-weight:700;display:block;margin-bottom:6px;">Department Tags</span>
                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                  <span v-for="tag in item.tags" :key="tag">{{ tag }}</span>
                </div>
              </div>

              <!-- Modify fields shown when editing -->
              <div v-if="item.editing" style="display:grid;gap:8px;margin-top:4px;">
                <label class="input-group" style="margin:0;">
                  <span>Modify Category</span>
                  <select v-model="item.modifiedCategory">
                    <option v-for="s in item.suggestions" :key="s" :value="s">{{ s }}</option>
                    <option>Leave Policy</option>
                    <option>Promotion</option>
                    <option>Discipline</option>
                    <option>Salary</option>
                    <option>Staff Benefits</option>
                    <option>Overseas Travel</option>
                    <option>Contract Service</option>
                  </select>
                </label>
                <label class="input-group" style="margin:0;">
                  <span>Modify Department Tag</span>
                  <select v-model="item.modifiedDepartmentTag">
                    <option>Human Resource Management Division</option>
                    <option>Finance Division</option>
                    <option>Administration Division</option>
                    <option>Legal Division</option>
                  </select>
                </label>
                <div style="display:flex;gap:8px;">
                  <button class="primary" style="flex:1;" @click="confirmModifyClassification(item)">Save Changes</button>
                  <button style="flex:1;" @click="item.editing = false">Cancel</button>
                </div>
              </div>

              <!-- Action buttons shown when not editing -->
              <div v-else style="display:flex;gap:8px;margin-top:4px;">
                <button
                  class="primary"
                  style="flex:1;"
                  :disabled="item.status === 'Approved'"
                  @click="approveClassification(item)"
                >
                  {{ item.status === 'Approved' ? '✓ Approved' : 'Approve' }}
                </button>
                <button
                  style="flex:1;"
                  :disabled="item.status === 'Approved'"
                  @click="startModifyClassification(item)"
                >
                  Modify
                </button>
                <button
                  class="secondary"
                  :disabled="item.status === 'Approved'"
                  @click="rejectClassification(item)"
                >
                  Reject
                </button>
              </div>
            </article>
          </div>
        </div>

        <!-- ─── MODULE 4.3 + 4.4 DOCUMENT REPOSITORY & SEARCH ─── -->
        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Repository &amp; Search</p>
              <h3>Search and Manage Documents</h3>
            </div>
            <button class="primary" @click="openNewVersionModal">Upload New Version</button>
          </div>

          <!-- 5-column filter toolbar -->
          <div class="repo-filters">
            <input
              v-model="repoQuery"
              placeholder="Search by title, reference number or category..."
            />
            <select v-model="repoType">
              <option value="">All Types</option>
              <option>Circular</option>
              <option>Guideline</option>
              <option>Policy</option>
              <option>Memo</option>
              <option>Form</option>
              <option>Reference Document</option>
              <option>Administrative Decision</option>
            </select>
            <select v-model="repoCategory">
              <option value="">All Categories</option>
              <option>Leave Policy</option>
              <option>Promotion</option>
              <option>Discipline</option>
              <option>Salary</option>
              <option>Staff Benefits</option>
              <option>Overseas Travel</option>
              <option>Contract Service</option>
              <option>Promotion and Discipline</option>
            </select>
            <select v-model="repoStatus">
              <option value="">All Statuses</option>
              <option>Published</option>
              <option>Draft</option>
              <option>Archived</option>
              <option>Pending Review</option>
            </select>
            <select v-model="repoAccess">
              <option value="">All Access Levels</option>
              <option>Public</option>
              <option>Registered</option>
              <option>Restricted</option>
            </select>
          </div>

          <!-- Result count -->
          <p style="color:var(--muted);font-size:13px;font-weight:700;margin:0 0 14px;">
            Showing {{ repositoryDocs.length }} result{{ repositoryDocs.length !== 1 ? 's' : '' }}
            <span v-if="repoQuery"> for "{{ repoQuery }}"</span>
          </p>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>Document</th>
                  <th>Reference No.</th>
                  <th>Category</th>
                  <th>Department</th>
                  <th>Access</th>
                  <th>Status</th>
                  <th>Effective Date</th>
                  <th>Views</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="repositoryDocs.length === 0">
                  <td colspan="9" style="text-align:center;color:var(--muted);padding:32px;">
                    No documents match your filters.
                  </td>
                </tr>
                <tr v-for="doc in repositoryDocs" :key="doc.documentId">
                  <td>
                    <strong>{{ doc.title }}</strong>
                    <span>{{ doc.type }} · v{{ doc.version }}</span>
                  </td>
                  <td>{{ doc.referenceNo }}</td>
                  <td>{{ doc.category }}</td>
                  <td>{{ doc.departmentTag || '—' }}</td>
                  <td>
                    <span :class="{
                      'status-pill green': doc.access === 'Public',
                      'status-pill amber': doc.access === 'Registered',
                      'status-pill red': doc.access === 'Restricted'
                    }">{{ doc.access }}</span>
                  </td>
                  <td>
                    <span :class="{
                      'status-pill green': doc.status === 'Published',
                      'status-pill amber': doc.status === 'Draft' || doc.status === 'Pending Review',
                      'status-pill red': doc.status === 'Archived'
                    }">{{ doc.status }}</span>
                  </td>
                  <td>{{ doc.effectiveDate || '—' }}</td>
                  <td>{{ doc.totalViews || 0 }}</td>
                  <td>

  <button
    class="secondary"
    @click="previewRepositoryDoc(doc)"
  >
    View Details
  </button>

  <button
    v-if="session === 'User' || session === 'Admin'"
    class="secondary"
    @click="downloadDocument(doc)"
  >
    Download
  </button>

  <button
    v-if="session === 'Admin'"
    class="secondary"
    @click="openVersionModal(doc)"
  >
    New Version
  </button>

  <button
    v-if="session === 'Admin'"
    class="secondary"
    @click="archiveDocument(doc)"
  >
    Archive
  </button>

</td>

                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- ─── MODULE 4.5 ARCHIVE MODAL ─── -->
        <div v-if="showArchiveModal" class="modal-overlay" @click.self="showArchiveModal = false">
          <div v-if="session === 'Admin'"
          class="modal-card">
            <div class="section-title" style="margin-bottom:16px;">
              <div>
                <p class="eyebrow">Archive Document </p>
                <h3>Archive: {{ archiveTarget?.referenceNo }}</h3>
              </div>
              <button @click="showArchiveModal = false">✕</button>
            </div>

            <p style="color:var(--muted);margin:0 0 18px;">
              Archiving removes this document from active circulation. Users with saved copies will be notified.
            </p>

            <label class="input-group">
              <span>Archive Reason *</span>
              <select v-model="archiveForm.reason">
                <option value="">— Select reason —</option>
                <option value="superseded">Superseded by newer circular</option>
                <option value="expired">Document has expired</option>
                <option value="withdrawn">Officially withdrawn</option>
                <option value="other">Other reason</option>
              </select>
            </label>

            <label class="input-group">
              <span>Successor Document Reference (if replaced)</span>
              <input v-model="archiveForm.successorReference" placeholder="e.g. JHR/CUTI/2026/02" />
            </label>

            <label class="input-group">
              <span>Additional Notes</span>
              <textarea
                v-model="archiveForm.reasonDetails"
                placeholder="Provide any additional explanation..."
                rows="3"
                style="width:100%;border:1px solid var(--line);border-radius:16px;padding:14px 16px;font:inherit;resize:vertical;"
              ></textarea>
            </label>

            <div style="display:flex;gap:10px;margin-top:8px;">
              <button class="secondary" style="flex:1;" @click="confirmArchive">Confirm Archive</button>
              <button style="flex:1;" @click="showArchiveModal = false">Cancel</button>
            </div>
          </div>
        </div>

        <!-- ─── MODULE 4.5 UPLOAD NEW VERSION MODAL ─── -->
        <div v-if="showVersionModal" class="modal-overlay" @click.self="showVersionModal = false">
          <div class="modal-card">
            <div class="section-title" style="margin-bottom:16px;">
              <div>
                <p class="eyebrow">Version Management</p>
                <h3>Upload New Version</h3>
              </div>
              <button @click="showVersionModal = false">✕</button>
            </div>

            <label class="input-group">
              <span>Document to Update *</span>
              <select v-model="versionForm.documentId">
                <option value="">— Select document —</option>
                <option
                  v-for="doc in documents.filter(d => d.status !== 'Archived')"
                  :key="doc.documentId"
                  :value="doc.documentId"
                >
                  {{ doc.referenceNo }} — {{ doc.title }}
                </option>
              </select>
            </label>

            <div v-if="versionForm.documentId" class="version-info-box">
              <span class="status-pill">
                Current: v{{ documents.find(d => d.documentId == versionForm.documentId)?.version || '1.0' }}
              </span>
              <span style="color:var(--muted);font-size:13px;">New version will be: v{{ nextVersionNumber }}</span>
            </div>

            <label class="input-group">
              <span>Update Type *</span>
              <select v-model="versionForm.updateType">
                <option value="">— Select type —</option>
                <option value="amendment">Amendment</option>
                <option value="replacement">Replacement</option>
                <option value="correction">Correction</option>
                <option value="withdrawal">Withdrawal</option>
              </select>
            </label>

            <label class="input-group">
              <span>Change Summary *</span>
              <textarea
                v-model="versionForm.changeSummary"
                placeholder="Describe what changed in this version..."
                rows="3"
                style="width:100%;border:1px solid var(--line);border-radius:16px;padding:14px 16px;font:inherit;resize:vertical;"
              ></textarea>
            </label>

            <label class="input-group">
              <span>New PDF File *</span>
              <div class="file-upload-box" @click="triggerVersionFileInput" @dragover.prevent @drop.prevent="handleVersionFileDrop">
                <input
                  ref="versionFileInputRef"
                  type="file"
                  accept=".pdf"
                  style="display:none;"
                  @change="handleVersionFileSelect"
                />
                <div v-if="!versionForm.fileName" class="file-upload-placeholder">
                  <strong>Click to choose PDF file</strong>
                  <span>PDF only · Max 20MB</span>
                </div>
                <div v-else class="file-upload-selected">
                  <span class="status-pill green">✓ File selected</span>
                  <strong>{{ versionForm.fileName }}</strong>
                </div>
              </div>
            </label>

            <label class="input-group">
              <span>New Effective Date (if changed)</span>
              <input v-model="versionForm.newEffectiveDate" type="date" />
            </label>

            <div style="display:flex;gap:10px;margin-top:8px;">
              <button class="primary" style="flex:1;" @click="confirmUploadNewVersion">Upload New Version</button>
              <button style="flex:1;" @click="showVersionModal = false">Cancel</button>
            </div>
          </div>
        </div>

        <div
  v-if="showPreviewModal"
  class="modal-overlay"
  @click.self="showPreviewModal = false"
>
  <div class="modal-card">
    <h3>{{ previewDoc.title }}</h3>

    <p>
      <strong>Reference Number:</strong>
      {{ previewDoc.referenceNo }}
    </p>

    <p>
      <strong>Category:</strong>
      {{ previewDoc.category }}
    </p>

    <p>
      <strong>Document Type:</strong>
      {{ previewDoc.type }}
    </p>

    <p>
      <strong>Access Level:</strong>
      {{ previewDoc.access }}
    </p>

    <p>
      <strong>Status:</strong>
      {{ previewDoc.status }}
    </p>

    <p>
      <strong>Effective Date:</strong>
      {{ previewDoc.effectiveDate }}
    </p>

    <p>
      <strong>Department:</strong>
      {{ previewDoc.departmentTag }}
    </p>

    <p>
      <strong>Summary:</strong>
      {{ previewDoc.summary }}
    </p>

    <button
      class="primary"
      @click="showPreviewModal = false"
    >
      Close
    </button>
  </div>
</div>

        <!-- ─── AUDIT LOG ─── -->
        <div
            v-if="session === 'Admin'"
            class="wide-card"
        >

          <div class="section-title">
            <div>
              <p class="eyebrow">Document Audit Trail</p>
              <h3>Recent Document Actions</h3>
            </div>
            <button @click="toast = 'Audit log exported.'">Export Log</button>
          </div>

          <div class="log-list">
            <div v-if="documentAuditLog.length === 0" class="empty-state">
              <p>No audit actions recorded yet. Actions will appear here after you upload, classify, archive or update documents.</p>
            </div>
            <div
              v-for="entry in documentAuditLog"
              :key="entry.id"
              class="log-item"
            >
              <div :class="entry.actionType === 'archive' ? 'dot amber-dot' : 'dot green-dot'"></div>
              <div>
                <strong>{{ entry.actionLabel }}</strong>
                <p>{{ entry.documentTitle }} · {{ entry.actionDetails }}</p>
              </div>
              <em>{{ entry.createdAt }}</em>
            </div>
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

            <button @click="openEscalationPanel">
              Escalate to HR Officer
            </button>
          </div>

          <input
            v-model="ratingComment"
            class="feedback-input"
            placeholder="Optional chatbot feedback comment..."
          />

          <div v-if="escalationPanelOpen" class="escalation-panel">
            <div class="section-title">
              <div>
                <p class="eyebrow">HR Officer Support</p>
                <h3>Escalate Question</h3>
              </div>

              <button @click="cancelEscalationPanel">
                Cancel
              </button>
            </div>

            <label class="field-label">Question</label>
            <input
              v-model="escalationForm.question"
              class="feedback-input"
              placeholder="Enter the question to escalate..."
            />

            <label class="field-label">Description</label>
            <textarea
              v-model="escalationForm.description"
              class="feedback-textarea"
              placeholder="Describe why this question needs HR officer support..."
            ></textarea>

            <button class="primary" @click="submitEscalationRequest">
              Submit to HR Officer
            </button>
          </div>

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

          <div class="history-panel">
            <p class="eyebrow">Escalation Requests</p>

            <div
              v-for="request in escalationRequests.filter((item) => item.userId === currentUserId)"
              :key="request.escalationId"
              class="history-item"
            >
              <strong>{{ request.escalationQuestion }}</strong>
              <p>{{ request.escalationDescription }}</p>
              <small>
                Status: {{ request.escalationStatus }}
                <span v-if="request.submittedAt">
                  | Submitted: {{ new Date(request.submittedAt).toLocaleString() }}
                </span>
              </small>
            </div>

            <p
              v-if="escalationRequests.filter((item) => item.userId === currentUserId).length === 0"
              class="muted"
            >
              No escalation request submitted yet.
            </p>
          </div>
        </div>

        <div v-if="hasSearched" class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Search Results</p>
              <h3>Smart Search Result Documents</h3>
            </div>

            <button @click="clearSearchResults">
              Clear
            </button>
          </div>

          <div class="doc-grid">
            <article
              v-for="doc in searchResults"
              :key="doc.documentId"
              class="doc-card"
            >
              <span class="status-pill amber">Search Result</span>

              <h4 v-html="highlightMatchedContent(doc.title)"></h4>

              <p
                v-if="doc.summary"
                v-html="highlightMatchedContent(doc.summary)"
              ></p>

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
              </div>
            </article>

            <div v-if="searchResults.length === 0" class="empty-state">
              No matching document found. Try searching TASKA, TBK, SPKN, COS, CFS, promotion, or contract.
            </div>
          </div>
        </div>

        <div
            v-if="session === 'Admin'"
            class="wide-card"
        >
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

            <button @click="openEscalationPanel">
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
            <div>
              <p class="eyebrow">Smart Alerts</p>
              <h3>Recommended Alerts Based on User Activity</h3>
            </div>

            <button @click="loadNotifications">
              Refresh Alerts
            </button>
          </div>

          <div
            v-for="alert in smartAlerts"
            :key="alert.id"
            class="smart-alert-item"
          >
            <span :class="alert.read ? 'dot green-dot' : 'dot amber-dot'"></span>

            <div>
              <strong>{{ alert.title }}</strong>
              <p>{{ alert.message }}</p>
              <small>
                Type: {{ alert.type }}
                <span v-if="alert.time">
                  | {{ new Date(alert.time).toLocaleString() }}
                </span>
              </small>
            </div>

            <button
              v-if="!alert.read"
              @click="markNotificationRead(alert.id)"
            >
              Mark as Read
            </button>
          </div>

          <p v-if="smartAlerts.length === 0" class="muted">
            No smart alerts available.
          </p>
        </div>

        <div class="wide-card">
          <div class="section-title">
            <div>
              <p class="eyebrow">Recent Notifications</p>
              <h3>Policy Updates and Alerts</h3>
            </div>
            <button @click="markAllNotificationsRead">
              Mark All as Read
            </button>
          </div>

          <div class="log-list">
            <div
              v-for="notice in policyNotifications"
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

            <p v-if="policyNotifications.length === 0" class="muted">
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
      <section v-if="screen === 'admin' && session === 'Admin'" class="dashboard-grid">
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
            <div>
              <p class="eyebrow">HR Escalation</p>
              <h3>Escalation Requests from Users</h3>
            </div>

            <button @click="loadEscalationRequests">
              Refresh
            </button>
          </div>

          <div class="table-card">
            <table>
              <thead>
                <tr>
                  <th>Question</th>
                  <th>User</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Submitted At</th>
                  <th>Action</th>
                </tr>
              </thead>

              <tbody>
                <tr
                  v-for="request in escalationRequests"
                  :key="request.escalationId"
                >
                  <td>{{ request.escalationQuestion }}</td>
                  <td>{{ request.userName || 'User' }}</td>
                  <td>{{ request.escalationDescription }}</td>
                  <td>
                    <span
                      :class="request.escalationStatus === 'Resolved'
                        ? 'status-pill green'
                        : 'status-pill amber'"
                    >
                      {{ request.escalationStatus }}
                    </span>
                  </td>
                  <td>{{ new Date(request.submittedAt).toLocaleString() }}</td>
                  <td>
                    <button
                      v-if="request.escalationStatus !== 'Resolved'"
                      @click="resolveEscalationRequest(request.escalationId)"
                    >
                      Mark Resolved
                    </button>

                    <span v-else class="muted">
                      Completed
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <p v-if="escalationRequests.length === 0" class="muted">
            No escalation requests submitted yet.
          </p>
        </div>

       <div class="wide-card">
        <div class="section-title">
          <h3>Role and Permission Control</h3>
          <button @click="openCreateRoleForm">
            Create Role
          </button>
        </div>

  <div class="role-grid">
    <article
      v-for="(role, index) in roles"
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

      <div class="button-row">
        <button @click="openEditRoleForm(role, index)">
          Edit Role
        </button>
      </div>
    </article>
  </div>
</div>

<div v-if="roleModalOpen" class="modal-overlay" @click.self="cancelRoleForm">
  <div class="modal-card">
    <div class="section-title">
      <div>
        <p class="eyebrow">Role Management</p>
        <h3>{{ editingRoleIndex === null ? 'Create New Role' : 'Edit Role' }}</h3>
      </div>

      <button @click="cancelRoleForm">
        Cancel
      </button>
    </div>

    <InputField
      v-model="roleForm.name"
      label="Role Name"
      placeholder="Example: Document Reviewer"
    />

    <label class="input-group">
      <span>Role Description</span>
      <textarea
        v-model="roleForm.description"
        class="feedback-textarea"
        placeholder="Describe what this role can do..."
      ></textarea>
    </label>

    <label class="input-group">
      <span>Permissions</span>
      <textarea
        v-model="roleForm.permissions"
        class="feedback-textarea"
        placeholder="Enter permissions separated by comma"
      ></textarea>
    </label>

    <button class="primary full" @click="saveRole">
      {{ editingRoleIndex === null ? 'Create Role' : 'Save Changes' }}
    </button>
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
                <th>Designation</th>
                <th>Role</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Updated At</th>
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
                  <td>{{ user.designation }}</td>
                  <td>{{ user.role }}</td>

                  <td>
                    <span :class="user.status === 'Active' ? 'status-pill green' : 'status-pill red'">
                      {{ user.status }}
                    </span>
                  </td>

                  <td>{{ user.created_at }}</td>
                  <td>{{ user.updated_at }}</td>

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

  function submitDeactivationRequest() {
    if (!deactivationForm.value.reason.trim()) {
     showToast('Please enter a reason for account deactivation.', 'info')
      return
    }

    if (deactivationForm.value.confirmText !== 'DEACTIVATE') {
      showToast('Please type DEACTIVATE to confirm the request.', 'info')
      return
    }

    showToast('Account deactivation request submitted for administrator review.', 'success')
    addLog('Submitted account deactivation request', 'Profile Management', 'Warning', session.value)
    cancelDeactivationRequest()
  }

  function cancelDeactivationRequest() {
    deactivationModalOpen.value = false

    deactivationForm.value = {
      reason: '',
      confirmText: ''
    }
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

const documents = ref([
  {
    documentId: 1,
    referenceNo: 'JHR/LP/2026/001',
    title: 'Employee Leave Policy 2026',
    category: 'Leave Policy',
    type: 'Policy',
    status: 'Published',
    access: 'Public',
    version: '1.0',
    effectiveDate: '2026-01-01',
    departmentTag: 'Human Resource Management Division',
    totalViews: 156,
    summary: 'Guidelines regarding annual leave and medical leave.'
  },
  {
    documentId: 2,
    referenceNo: 'JHR/PR/2026/003',
    title: 'Promotion Guidelines for Government Officers',
    category: 'Promotion',
    type: 'Guideline',
    status: 'Published',
    access: 'Registered',
    version: '2.0',
    effectiveDate: '2026-02-01',
    departmentTag: 'Administration Division',
    totalViews: 234,
    summary: 'Promotion eligibility and assessment procedures.'
  },
  {
    documentId: 3,
    referenceNo: 'JHR/DP/2025/008',
    title: 'Disciplinary Action Procedures',
    category: 'Discipline',
    type: 'Circular',
    status: 'Archived',
    access: 'Restricted',
    version: '1.2',
    effectiveDate: '2025-06-01',
    departmentTag: 'Legal Division',
    totalViews: 88,
    summary: 'Official disciplinary handling procedures.'
  }
])

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
const publicDetailsModalOpen = ref(false)

const smartResults = ref([]) // recommended documents only
const searchResults = ref([]) // smart search results only
const hasSearched = ref(false)

const reportDialogOpen = ref(false)
const selectedRecommendation = ref(null)

const showPreviewModal = ref(false)
const previewDoc = ref(null)

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

async function loadEscalationRequests() {
  try {
    const response = await fetch('http://localhost:3000/api/escalation-requests')

    if (!response.ok) {
      throw new Error('Failed to load escalation requests')
    }

    escalationRequests.value = await response.json()
  } catch (error) {
    console.error(error)
  }
}

async function resolveEscalationRequest(escalationId) {
  try {
    const response = await fetch(
      `http://localhost:3000/api/escalation-requests/${escalationId}/resolve`,
      {
        method: 'PATCH'
      }
    )

    if (!response.ok) {
      throw new Error('Failed to resolve escalation request')
    }

    await loadEscalationRequests()

    toast.value = 'Escalation request marked as resolved.'
    addLog('Resolved escalation request', 'Admin Workspace', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to resolve escalation request.'
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

function downloadDocument(doc) {
  addAuditEntry(
    'download',
    doc.title,
    'Document downloaded'
  )

  toast.value = `${doc.title} downloaded successfully`
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
  await loadEscalationRequests()
})

const users = useLocalStorage('jhr_users', [
  {
    id: 'USR001',
    name: 'Nur Aina Rahman',
    email: 'aina@johor.gov.my',
    department: 'Human Resource Management Division',
    designation: 'Assistant Officer',
    role: 'Registered User',
    status: 'Active',
    created_at: '2026-01-10 09:00 AM',
    updated_at: '2026-01-10 09:00 AM'
  },
  {
    id: 'USR002',
    name: 'Daniel Tan',
    email: 'daniel@johor.gov.my',
    department: 'Finance Department',
    designation: 'Officer',
    role: 'Registered User',
    status: 'Suspended',
    created_at: '2026-01-12 10:30 AM',
    updated_at: '2026-01-15 02:10 PM'
  },
  {
    id: 'USR003',
    name: 'Tung Ern',
    email: 'tungern@johor.gov.my',
    department: 'Knowledge and Document Management Unit',
    designation: 'Document Officer',
    role: 'Registered User',
    status: 'Active',
    created_at: '2026-01-05 10:00 AM',
    updated_at: '2026-01-05 10:00 AM'
  },
  {
    id: 'ADM001',
    name: 'May Yan',
    email: 'mayyan@johor.gov.my',
    department: 'User and Access Management Unit',
    designation: 'System Administrator',
    role: 'Administrator',
    status: 'Active',
    created_at: '2026-01-01 08:30 AM',
    updated_at: '2026-01-01 08:30 AM'
  },
  {
    id: 'ADM002',
    name: 'Yuan Man',
    email: 'yuanman@johor.gov.my',
    department: 'Intelligent Recommendation and Support Unit',
    designation: 'AI Support Administrator',
    role: 'Administrator',
    status: 'Active',
    created_at: '2026-01-14 11:20 AM',
    updated_at: '2026-01-14 11:20 AM'
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

const smartAlerts = computed(() => {
  return notifications.value.filter((notice) => notice.type === 'smart_alert')
})

const policyNotifications = computed(() => {
  return notifications.value.filter((notice) => notice.type !== 'smart_alert')
})

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
const roleModalOpen = ref(false)
const editingRoleIndex = ref(null)

const roleForm = ref({
  name: '',
  description: '',
  permissions: ''
})
//const selectedDoc = ref(documents.value[0])
const authMode = ref('login')
const resetModalOpen = ref(false)
const resetAccountType = ref('user')
const session = ref('Guest')
const toast = ref('Welcome to Johor HR Knowledge Hub interactive prototype.')
const toastType = ref('success')

function showToast(message, type = 'success') {
  toast.value = message
  toastType.value = type
}

const visibleNavItems = computed(() => {
  if (session.value === 'Admin') {
    return navItems
  }

  return navItems.filter((item) => item.id !== 'admin')
})

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
const deactivationModalOpen = ref(false)
const deactivationForm = ref({
  reason: '',
  confirmText: ''
})
const changePasswordModalOpen = ref(false)

const changePasswordForm = ref({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
})

function submitChangePassword() {
  if (
    !changePasswordForm.value.currentPassword ||
    !changePasswordForm.value.newPassword ||
    !changePasswordForm.value.confirmPassword
  ) {
    showToast('Please complete all password fields.', 'info')
    return
  }

  if (changePasswordForm.value.newPassword !== changePasswordForm.value.confirmPassword) {
    showToast('New password and confirm password do not match.', 'error')
    return
  }

  showToast('Password updated successfully.', 'success')
  addLog('Changed password', 'Profile Management', 'Success', session.value)
  cancelChangePassword()
}

function cancelChangePassword() {
  changePasswordModalOpen.value = false

  changePasswordForm.value = {
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  }
}

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
  expiryDate: '',
  departmentTag: '',
  type: 'Guideline',
  category: 'Leave Policy',
  access: 'Registered',
  language: 'BM',
  fileName: '',
  fileSizeKb: 0,
  fileObject: null
})

// ── Subsystem 2 new reactive state ──
const repoCategory = ref('')
const repoStatus = ref('')
const repoAccess = ref('')
const uploadStatus = ref(null)
const showArchiveModal = ref(false)
const archiveTarget = ref(null)
const archiveForm = ref({ reason: '', successorReference: '', reasonDetails: '' })
const showVersionModal = ref(false)
const versionForm = ref({
  documentId: '',
  changeSummary: '',
  updateType: '',
  newEffectiveDate: '',
  fileName: '',
  fileObject: null
})
const documentAuditLog = ref([
  {
    id: 1,
    actionType: 'upload',
    actionLabel: 'Document Uploaded',
    documentTitle: 'Employee Leave Policy 2026',
    actionDetails: 'Uploaded by Administrator',
    createdAt: '19 Jun 2026 10:00 AM'
  },
  {
    id: 2,
    actionType: 'classification',
    actionLabel: 'AI Classification Approved',
    documentTitle: 'Promotion Guidelines',
    actionDetails: 'Category approved as Promotion',
    createdAt: '19 Jun 2026 10:15 AM'
  },
  {
    id: 3,
    actionType: 'archive',
    actionLabel: 'Document Archived',
    documentTitle: 'Disciplinary Action Procedures',
    actionDetails: 'Superseded by newer circular',
    createdAt: '19 Jun 2026 10:30 AM'
  },
  {
    id: 4,
    actionType: 'version',
    actionLabel: 'New Version Uploaded',
    documentTitle: 'Promotion Guidelines',
    actionDetails: 'Version 2.0 uploaded',
    createdAt: '19 Jun 2026 11:00 AM'
  }
])

const fileInputRef = ref(null)
const versionFileInputRef = ref(null)


const chatInput = ref('')
const conversationHistory = ref([])
const latestConversationId = ref(null)
const generatedSummary = ref('')
const selectedSummaryDoc = ref(null)
const ratingComment = ref('')
const escalationPanelOpen = ref(false)
const escalationRequests = ref([])

const escalationForm = ref({
  question: '',
  description: ''
})

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
    const searchText = `${doc.title} ${doc.referenceNo} ${doc.category}`.toLowerCase()
    const matchesQuery = !repoQuery.value || searchText.includes(repoQuery.value.toLowerCase())
    const matchesType = !repoType.value || doc.type === repoType.value
    const matchesCategory = !repoCategory.value || doc.category === repoCategory.value
    const matchesStatus = !repoStatus.value || doc.status === repoStatus.value
    const matchesAccess = !repoAccess.value || doc.access === repoAccess.value
    return matchesQuery && matchesType && matchesCategory && matchesStatus && matchesAccess
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

function getCurrentDateTime() {
  return new Date().toLocaleString('en-MY', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

function normalizeUsers() {
  users.value = users.value.map((user) => {
    return {
      ...user,
      designation: user.designation || 'Not assigned',
      created_at: user.created_at || getCurrentDateTime(),
      updated_at: user.updated_at || getCurrentDateTime()
    }
  })

  const defaultUsers = [
    {
      id: 'USR003',
      name: 'Tung Ern',
      email: 'tungern@johor.gov.my',
      department: 'Knowledge and Document Management Unit',
      designation: 'Document Officer',
      role: 'Registered User',
      status: 'Active',
      created_at: '2026-01-05 10:00 AM',
      updated_at: '2026-01-05 10:00 AM'
    },
    {
      id: 'ADM002',
      name: 'Yuan Man',
      email: 'yuanman@johor.gov.my',
      department: 'Intelligent Recommendation and Support Unit',
      designation: 'AI Support Administrator',
      role: 'Administrator',
      status: 'Active',
      created_at: '2026-01-14 11:20 AM',
      updated_at: '2026-01-14 11:20 AM'
    }
  ]

  defaultUsers.forEach((defaultUser) => {
    const existingUser = users.value.find((user) => user.email === defaultUser.email)

    if (existingUser) {
      existingUser.id = defaultUser.id
      existingUser.name = defaultUser.name
      existingUser.department = defaultUser.department
      existingUser.designation = defaultUser.designation
      existingUser.role = defaultUser.role
      existingUser.status = defaultUser.status
      existingUser.created_at = existingUser.created_at || defaultUser.created_at
      existingUser.updated_at = getCurrentDateTime()
    } else {
      users.value.push(defaultUser)
    }
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
    showToast('Please enter email and password.', 'info')
    addLog('Failed login attempt', 'User Login', 'Warning', 'Unknown User')
    return
  }

  const loggedInUser = users.value.find(
  (user) =>
    user.email.toLowerCase() === loginForm.value.email.toLowerCase() &&
    user.role.toLowerCase().includes('registered')
  )

  if (!loggedInUser) {
    showToast('User account not found.', 'error')
    addLog('Failed login attempt - account not found', 'User Login', 'Warning', loginForm.value.email)
    return
  }

  if (loggedInUser.status !== 'Active') {
    showToast('This account is not active.', 'error')
    addLog('Failed login attempt - inactive account', 'User Login', 'Warning', loggedInUser.name)
    return
  }

  profileForm.value = {
    name: loggedInUser.name,
    email: loggedInUser.email,
    department: loggedInUser.department,
    designation: loggedInUser.designation
  }

  session.value = 'User'
  screen.value = 'profile'
  showToast(`${loggedInUser.name} logged in successfully.`, 'success')
  addLog('User login', 'Authentication', 'Success', loggedInUser.name)
}

function adminLogin() {
  if (!adminLoginForm.value.email || !adminLoginForm.value.password) {
    showToast('Please enter admin email and password.', 'info')
    return
  }

  const loggedInAdmin = users.value.find(
  (user) =>
    user.email.toLowerCase() === adminLoginForm.value.email.toLowerCase() &&
    user.role.toLowerCase().includes('administrator')
  )

  profileForm.value = {
    name: loggedInAdmin.name,
    email: loggedInAdmin.email,
    department: loggedInAdmin.department,
    designation: loggedInAdmin.designation
  }

  session.value = 'Admin'
  screen.value = 'admin'
  showToast(`${loggedInAdmin.name} logged in successfully as administrator.`, 'success')
  addLog('Admin login', 'Admin Authentication', 'Success', loggedInAdmin.name)
}

function registerUser() {
  if (!registerForm.value.name || !registerForm.value.email || !registerForm.value.password) {
    showToast('Please complete name, email and password.', 'info')
    return
  }

  const now = getCurrentDateTime()

  const newUser = {
    id: `USR${Date.now()}`,
    name: registerForm.value.name,
    email: registerForm.value.email,
    department: registerForm.value.department || 'Not assigned',
    designation: registerForm.value.designation || 'Not assigned',
    role: 'Registered User',
    status: 'Active',
    created_at: now,
    updated_at: now
  }
  users.value.unshift(newUser)

  registerForm.value = {
    name: '',
    email: '',
    department: '',
    designation: '',
    password: ''
  }

  showToast('Registration submitted successfully. New user is added to admin table.', 'success')
  addLog('Registered new account', 'Registration', 'Success', newUser.name)
}

function sendResetLink() {
  if (!resetForm.value.email) {
    showToast('Please enter registered email first.', 'info')
    return
  }

  showToast('Password reset link sent to verified government email.', 'success')
  addLog('Requested password reset link', 'Password Reset', 'Success', resetForm.value.email)
}

function updatePassword() {
  if (!resetForm.value.code || !resetForm.value.newPassword) {
    showToast('Please enter verification code and new password.', 'info')
    return
  }

  showToast('Password updated successfully.', 'success')
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
  showToast('Logged out successfully. You are now a guest.', 'success')
  addLog('User logged out', 'Logout', 'Success', 'Current User')
}

function openDocumentDetails(doc) {
  selectedDoc.value = doc
  publicDetailsModalOpen.value = true
  addLog('Viewed public document details', 'Public Search', 'Success', session.value)
}

function saveProfile() {
  const now = getCurrentDateTime()

  const currentUser = users.value.find((user) => user.email === profileForm.value.email)

  if (currentUser) {
    currentUser.name = profileForm.value.name
    currentUser.email = profileForm.value.email
    currentUser.department = profileForm.value.department
    currentUser.designation = profileForm.value.designation
    currentUser.updated_at = now
  }

  showToast('Profile updated successfully.', 'success')
  addLog('Updated profile information', 'Profile Management', 'Success', profileForm.value.name)
}

function toggleMfa() {
  mfaEnabled.value = !mfaEnabled.value
  showToast(mfaEnabled.value ? 'MFA has been enabled.' : 'MFA has been disabled.', 'success')
  addLog('Changed MFA setting', 'Account Security', 'Success', profileForm.value.name)
}

// ─── MODULE 4.1: DOCUMENT UPLOAD FUNCTIONS ───

function triggerFileInput() {
  fileInputRef.value?.click()
}

function handleFileSelect(event) {
  const file = event.target.files[0]
  if (!file) return
  if (file.type !== 'application/pdf') {
    uploadStatus.value = { type: 'error', message: 'Only PDF files are accepted.' }
    return
  }
  if (file.size > 20 * 1024 * 1024) {
    uploadStatus.value = { type: 'error', message: 'File size must not exceed 20MB.' }
    return
  }
  uploadForm.value.fileName = file.name
  uploadForm.value.fileSizeKb = Math.round(file.size / 1024)
  uploadForm.value.fileObject = file
  uploadStatus.value = null
}

function handleFileDrop(event) {
  const file = event.dataTransfer.files[0]
  if (!file) return
  handleFileSelect({ target: { files: [file] } })
}

function clearFile() {
  uploadForm.value.fileName = ''
  uploadForm.value.fileSizeKb = 0
  uploadForm.value.fileObject = null
  if (fileInputRef.value) fileInputRef.value.value = ''
}

function uploadDocument() {
  if (!uploadForm.value.title || !uploadForm.value.referenceNo) {
    toast.value = 'Please enter document title and reference number.'
    return
  }
  if (!uploadForm.value.issuingAuthority) {
    toast.value = 'Please enter the issuing authority.'
    return
  }
  if (!uploadForm.value.effectiveDate) {
    toast.value = 'Please enter the effective date.'
    return
  }
  if (!uploadForm.value.fileName) {
    toast.value = 'Please select a PDF file to upload.'
    return
  }

  const newDocument = {
    documentId: Date.now(),
    referenceNo: uploadForm.value.referenceNo,
    title: uploadForm.value.title,
    category: uploadForm.value.category,
    type: uploadForm.value.type || 'Guideline',
    status: 'Pending Review',
    access: uploadForm.value.access || 'Registered',
    language: uploadForm.value.language || 'BM',
    effectiveDate: uploadForm.value.effectiveDate,
    expiryDate: uploadForm.value.expiryDate || null,
    departmentTag: uploadForm.value.departmentTag || '',
    version: '1.0',
    fileName: uploadForm.value.fileName,
    fileSizeKb: uploadForm.value.fileSizeKb,
    totalViews: 0,
    totalDownloads: 0,
    summary: `Uploaded by ${uploadForm.value.issuingAuthority}. Pending AI classification review.`
  }

  documents.value.unshift(newDocument)
  selectedDoc.value = newDocument

  classificationQueue.value.unshift({
    id: Date.now(),
    title: uploadForm.value.title,
    status: 'Pending Review',
    suggestions: [uploadForm.value.category, 'HR Policy'],
    tags: [uploadForm.value.departmentTag || 'HRMD', uploadForm.value.type || 'Guideline'],
    confidence: Math.floor(Math.random() * 20) + 75,
    editing: false,
    modifiedCategory: '',
    modifiedDepartmentTag: ''
  })

  addAuditEntry('upload', newDocument.title, 'Document uploaded and sent for classification review')
  uploadStatus.value = { type: 'success', message: `"${newDocument.title}" uploaded and added to AI classification queue.` }
  resetUploadForm()
  toast.value = 'Document uploaded successfully.'
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
    access: uploadForm.value.access || 'Registered',
    language: uploadForm.value.language || 'BM',
    effectiveDate: uploadForm.value.effectiveDate || 'Not set',
    departmentTag: uploadForm.value.departmentTag || '',
    version: '1.0',
    fileName: uploadForm.value.fileName || '',
    totalViews: 0,
    totalDownloads: 0,
    summary: `Draft saved by ${uploadForm.value.issuingAuthority || 'Administrator'}.`
  }

  documents.value.unshift(draftDocument)
  selectedDoc.value = draftDocument
  addAuditEntry('draft', draftDocument.title, 'Document saved as draft')
  resetUploadForm()
  toast.value = 'Document saved as draft.'
}

function resetUploadForm() {
  uploadForm.value = {
    title: '',
    referenceNo: '',
    issuingAuthority: '',
    effectiveDate: '',
    expiryDate: '',
    departmentTag: '',
    type: 'Guideline',
    category: 'Leave Policy',
    access: 'Registered',
    language: 'BM',
    fileName: '',
    fileSizeKb: 0,
    fileObject: null
  }
  if (fileInputRef.value) fileInputRef.value.value = ''
  uploadStatus.value = null
}

// ─── MODULE 4.2: AI CLASSIFICATION FUNCTIONS ───

function approveClassification(item) {
  item.status = 'Approved'
  item.editing = false
  const doc = documents.value.find(d => d.title === item.title)
  if (doc && doc.status === 'Pending Review') doc.status = 'Published'
  addAuditEntry('classify', item.title, 'AI classification approved')
  toast.value = `Classification approved for "${item.title}".`
}

function startModifyClassification(item) {
  item.editing = true
  item.modifiedCategory = item.suggestions[0]
  item.modifiedDepartmentTag = item.tags[0]
}

function confirmModifyClassification(item) {
  if (item.modifiedCategory) {
    item.suggestions = [item.modifiedCategory, ...item.suggestions.filter(s => s !== item.modifiedCategory)]
  }
  if (item.modifiedDepartmentTag) {
    item.tags = [item.modifiedDepartmentTag, ...item.tags.filter(t => t !== item.modifiedDepartmentTag)]
  }
  item.status = 'Approved'
  item.editing = false
  const doc = documents.value.find(d => d.title === item.title)
  if (doc) {
    if (item.modifiedCategory) doc.category = item.modifiedCategory
    if (item.modifiedDepartmentTag) doc.departmentTag = item.modifiedDepartmentTag
    if (doc.status === 'Pending Review') doc.status = 'Published'
  }
  addAuditEntry('classify', item.title, `Classification modified: ${item.modifiedCategory}`)
  toast.value = `Classification modified and approved for "${item.title}".`
}

function rejectClassification(item) {
  item.status = 'Rejected'
  item.editing = false
  addAuditEntry('classify', item.title, 'AI classification rejected')
  toast.value = `Classification rejected for "${item.title}".`
}

function refreshClassification() {
  classificationQueue.value.forEach(item => {
    if (item.status !== 'Approved') {
      item.confidence = Math.floor(Math.random() * 20) + 75
    }
  })
  toast.value = 'AI classification suggestions refreshed.'
  addLog('Refreshed AI classification suggestions', 'Document Classification', 'Success', 'Administrator')
}

// ─── MODULE 4.3 + 4.4: REPOSITORY FUNCTIONS ───

function previewRepositoryDoc(doc) {
  previewDoc.value = doc
  showPreviewModal.value = true

  addAuditEntry(
    'view',
    doc.title,
    'Viewed document details'
  )
}



// ─── MODULE 4.5: ARCHIVE FUNCTIONS ───

function openArchiveModal(doc) {
  if (doc.status === 'Archived') {
    toast.value = 'This document is already archived.'
    return
  }
  archiveTarget.value = doc
  archiveForm.value = { reason: '', successorReference: '', reasonDetails: '' }
  showArchiveModal.value = true
}

function confirmArchive() {
  if (!archiveForm.value.reason) {
    toast.value = 'Please select an archive reason.'
    return
  }
  archiveTarget.value.status = 'Archived'
  addAuditEntry('archive', archiveTarget.value.title,
    `Archived: ${archiveForm.value.reason}${archiveForm.value.successorReference ? ' · Successor: ' + archiveForm.value.successorReference : ''}`)
  notifications.value.unshift({
    id: Date.now(),
    title: 'Document archived',
    message: `${archiveTarget.value.title} has been archived.${archiveForm.value.successorReference ? ' Successor: ' + archiveForm.value.successorReference : ''}`,
    time: 'Just now',
    read: false
  })
  toast.value = `"${archiveTarget.value.referenceNo}" archived successfully.`
  showArchiveModal.value = false
  archiveTarget.value = null
}

// ─── MODULE 4.5: VERSION MANAGEMENT FUNCTIONS ───

function openNewVersionModal() {
  versionForm.value = {
    documentId: selectedDoc.value?.documentId || '',
    changeSummary: '',
    updateType: '',
    newEffectiveDate: '',
    fileName: '',
    fileObject: null
  }
  showVersionModal.value = true
}

function selectDocForVersion(doc) {
  selectedDoc.value = doc
  openNewVersionModal()
}

function triggerVersionFileInput() {
  versionFileInputRef.value?.click()
}

function handleVersionFileSelect(event) {
  const file = event.target.files[0]
  if (!file) return
  versionForm.value.fileName = file.name
  versionForm.value.fileObject = file
}

function handleVersionFileDrop(event) {
  const file = event.dataTransfer.files[0]
  if (!file) return
  versionForm.value.fileName = file.name
  versionForm.value.fileObject = file
}

const nextVersionNumber = computed(() => {
  if (!versionForm.value.documentId) return '2.0'
  const doc = documents.value.find(d => d.documentId == versionForm.value.documentId)
  if (!doc) return '2.0'
  const current = parseFloat(doc.version) || 1.0
  return (current + 1.0).toFixed(1)
})

function confirmUploadNewVersion() {
  if (!versionForm.value.documentId) {
    toast.value = 'Please select a document to update.'
    return
  }
  if (!versionForm.value.updateType) {
    toast.value = 'Please select an update type.'
    return
  }
  if (!versionForm.value.changeSummary) {
    toast.value = 'Please enter a change summary.'
    return
  }
  if (!versionForm.value.fileName) {
    toast.value = 'Please select the new PDF file.'
    return
  }
  const doc = documents.value.find(d => d.documentId == versionForm.value.documentId)
  if (!doc) return

  const newVersion = nextVersionNumber.value
  doc.version = newVersion
  doc.status = 'Published'
  if (versionForm.value.newEffectiveDate) doc.effectiveDate = versionForm.value.newEffectiveDate

  addAuditEntry('version', doc.title, `v${newVersion} uploaded: ${versionForm.value.changeSummary}`)
  notifications.value.unshift({
    id: Date.now(),
    title: 'Document updated',
    message: `${doc.title} has a new version (v${newVersion}). ${versionForm.value.changeSummary}`,
    time: 'Just now',
    read: false
  })
  toast.value = `"${doc.title}" updated to version ${newVersion}.`
  showVersionModal.value = false
}

// ─── AUDIT LOG HELPER ───

function addAuditEntry(actionType, documentTitle, actionDetails) {
  const labels = {
    upload: 'Document Uploaded',
    draft: 'Draft Saved',
    classify: 'Classification Reviewed',
    archive: 'Document Archived',
    version: 'New Version Uploaded'
  }
  documentAuditLog.value.unshift({
    id: Date.now(),
    actionType,
    actionLabel: labels[actionType] || actionType,
    documentTitle,
    actionDetails,
    performedBy: session.value === 'Admin' ? 'Administrator' : session.value,
    createdAt: new Date().toLocaleString('en-MY', { dateStyle: 'short', timeStyle: 'short' })
  })
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

  const words = keyword
    .trim()
    .split(/\s+/)
    .filter((word) => word.length > 1)

  if (words.length === 0) {
    return text
  }

  let highlightedText = text

  words.forEach((word) => {
    const escapedWord = word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
    const regex = new RegExp(`(${escapedWord})`, 'gi')
    highlightedText = highlightedText.replace(regex, '<mark>$1</mark>')
  })

  return highlightedText
}

function clearSearchResults() {
  smartQuery.value = ''
  searchResults.value = []
  hasSearched.value = false
  lastSearchKeyword.value = ''
  toast.value = 'Search results cleared.'
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

function openEscalationPanel() {
  const latestUserMessage = [...chatMessages.value]
    .reverse()
    .find((message) => message.sender === 'user')

  escalationForm.value = {
    question: latestUserMessage ? latestUserMessage.text : '',
    description: latestUserMessage
      ? 'User requested HR officer support for this chatbot question.'
      : 'User requested HR officer support from FAQ or chatbot panel.'
  }

  escalationPanelOpen.value = true
}

async function submitEscalationRequest() {
  if (!escalationForm.value.question.trim()) {
    toast.value = 'Please enter a question before escalating.'
    return
  }

  try {
    const response = await fetch('http://localhost:3000/api/escalation-requests', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        conversationId: latestConversationId.value,
        userId: currentUserId,
        escalationQuestion: escalationForm.value.question,
        escalationDescription: escalationForm.value.description
      })
    })

    if (!response.ok) {
      throw new Error('Failed to escalate question')
    }

    escalationPanelOpen.value = false

    escalationForm.value = {
      question: '',
      description: ''
    }

    toast.value = 'Question escalated to HR officer successfully.'

    await loadConversationHistory()
    await loadEscalationRequests()

    addLog('Escalated question to HR officer', 'AI Chatbot', 'Success', session.value)
  } catch (error) {
    console.error(error)
    toast.value = 'Failed to escalate question.'
  }
}

function cancelEscalationPanel() {
  escalationPanelOpen.value = false
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
  user.updated_at = getCurrentDateTime()

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
function openCreateRoleForm() {
  editingRoleIndex.value = null

  roleForm.value = {
    name: '',
    description: '',
    permissions: ''
  }

  roleModalOpen.value = true
}

function openEditRoleForm(role, index) {
  editingRoleIndex.value = index

  roleForm.value = {
    name: role.name,
    description: role.description,
    permissions: role.permissions.join(', ')
  }

  roleModalOpen.value = true
}

function saveRole() {
  const roleName = roleForm.value.name.trim()
  const roleDescription = roleForm.value.description.trim()
  const permissions = roleForm.value.permissions
    .split(',')
    .map((permission) => permission.trim())
    .filter(Boolean)

  if (!roleName || !roleDescription || permissions.length === 0) {
    toast.value = 'Please enter role name, description and at least one permission.'
    return
  }

  const duplicateRole = roles.value.some((role, index) => {
    return role.name.toLowerCase() === roleName.toLowerCase() &&
      index !== editingRoleIndex.value
  })

  if (duplicateRole) {
    toast.value = `${roleName} role already exists.`
    return
  }

  const roleData = {
    name: roleName,
    description: roleDescription,
    permissions
  }

  if (editingRoleIndex.value === null) {
    roles.value.push(roleData)
    toast.value = `${roleName} role created successfully.`
    addLog('Created new user role', 'Role Management', 'Success', 'Administrator')
  } else {
    roles.value[editingRoleIndex.value] = roleData
    toast.value = `${roleName} role updated successfully.`
    addLog('Edited user role', 'Role Management', 'Success', 'Administrator')
  }

  cancelRoleForm()
}

function cancelRoleForm() {
  roleModalOpen.value = false
  editingRoleIndex.value = null

  roleForm.value = {
    name: '',
    description: '',
    permissions: ''
  }
}

function filterLogs() {
  logs.value = logs.value.filter((log) => log.result === 'Success')
  toast.value = 'Showing success logs only.'
}
</script>