-- =========================================================
-- Johor HR Knowledge Hub Database
-- Project: AD15 Aespa
-- Purpose: Initial database for frontend UI + document data
-- =========================================================

CREATE DATABASE IF NOT EXISTS johor_hr_knowledge_hub;

USE johor_hr_knowledge_hub;

-- =========================================================
-- Drop existing tables if you want to reset database
-- You can comment these lines if you do not want to reset.
-- =========================================================

DROP TABLE IF EXISTS escalationRequests;
DROP TABLE IF EXISTS documentSummaries;
DROP TABLE IF EXISTS chatbotConversations;
DROP TABLE IF EXISTS faqs;
DROP TABLE IF EXISTS recommendationReports;
DROP TABLE IF EXISTS personalNotes;
DROP TABLE IF EXISTS savedDocuments;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS recommendations;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS users;

-- =========================================================
-- USERS TABLE
-- Keep simple first for UI testing
-- =========================================================

CREATE TABLE users (
  userId INT AUTO_INCREMENT PRIMARY KEY,
  fullName VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  department VARCHAR(100),
  role VARCHAR(50) DEFAULT 'registered_user',
  designation VARCHAR(100),
  status VARCHAR(50) DEFAULT 'Active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- DOCUMENTS TABLE
-- Attribute names follow current frontend / zip folder style
-- =========================================================

CREATE TABLE documents (
  documentId INT AUTO_INCREMENT PRIMARY KEY,
  referenceNo VARCHAR(100) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  type VARCHAR(50),
  status VARCHAR(50) DEFAULT 'Published',
  access VARCHAR(50) DEFAULT 'Public',
  effectiveDate VARCHAR(50),
  version VARCHAR(20) DEFAULT '1.0',
  reason VARCHAR(500),
  summary TEXT,
  fileName VARCHAR(255),
  filePath VARCHAR(500),
  totalViews INT DEFAULT 0,
  totalDownloads INT DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- RECOMMENDATIONS TABLE
-- For Personalized Recommendation Module
-- =========================================================

CREATE TABLE recommendations (
  recommendationId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  documentId INT NOT NULL,
  type VARCHAR(50) DEFAULT 'personalized',
  reason VARCHAR(500),
  score DECIMAL(5,2) DEFAULT 0.00,
  status VARCHAR(50) DEFAULT 'Active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_recommendation_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE SET NULL,

  CONSTRAINT fk_recommendation_document
    FOREIGN KEY (documentId) REFERENCES documents(documentId)
    ON DELETE CASCADE
);

-- =========================================================
-- RECOMMENDATION REPORTS TABLE
-- For Report Incorrect Recommendation function
-- =========================================================

CREATE TABLE recommendationReports (
  reportId INT AUTO_INCREMENT PRIMARY KEY,
  recommendationId INT NOT NULL,
  userId INT NOT NULL,
  adminId INT NULL,
  reportReason VARCHAR(100) NOT NULL,
  reportDescription VARCHAR(1000),
  reportStatus VARCHAR(50) DEFAULT 'Pending',
  submittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  reviewedAt DATETIME NULL,

  CONSTRAINT fk_report_recommendation
    FOREIGN KEY (recommendationId) REFERENCES recommendations(recommendationId)
    ON DELETE CASCADE,

  CONSTRAINT fk_report_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE CASCADE,

  CONSTRAINT fk_report_admin
    FOREIGN KEY (adminId) REFERENCES users(userId)
    ON DELETE SET NULL
);

-- =========================================================
-- FAQS TABLE
-- For FAQ and Knowledge Assistance Module
-- =========================================================

CREATE TABLE faqs (
  faqId INT AUTO_INCREMENT PRIMARY KEY,
  question VARCHAR(500) NOT NULL,
  answer VARCHAR(1000) NOT NULL,
  category VARCHAR(100) DEFAULT 'General',
  status VARCHAR(50) DEFAULT 'Published',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================================
-- CHATBOT CONVERSATIONS TABLE
-- For chatbot assistance, rating and history
-- =========================================================

CREATE TABLE chatbotConversations (
  conversationId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  questionText VARCHAR(1000) NOT NULL,
  responseText VARCHAR(2000),
  relatedDocumentId INT NULL,
  confidenceScore DECIMAL(5,2) DEFAULT 0.00,
  ratingValue INT NULL,
  ratingComment VARCHAR(500) NULL,
  conversationStatus VARCHAR(50) DEFAULT 'Answered',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_chatbot_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE SET NULL,

  CONSTRAINT fk_chatbot_document
    FOREIGN KEY (relatedDocumentId) REFERENCES documents(documentId)
    ON DELETE SET NULL
);

-- =========================================================
-- DOCUMENT SUMMARIES TABLE
-- For Generate Document Summary function
-- =========================================================

CREATE TABLE documentSummaries (
  summaryId INT AUTO_INCREMENT PRIMARY KEY,
  documentId INT NOT NULL,
  userId INT,
  summaryText VARCHAR(2000) NOT NULL,
  summaryStatus VARCHAR(50) DEFAULT 'Generated',
  generatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_summary_document
    FOREIGN KEY (documentId) REFERENCES documents(documentId)
    ON DELETE CASCADE,

  CONSTRAINT fk_summary_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE SET NULL
);

-- =========================================================
-- ESCALATION REQUESTS TABLE
-- For Escalate Question to HR Officer function
-- =========================================================

CREATE TABLE escalationRequests (
  escalationId INT AUTO_INCREMENT PRIMARY KEY,
  conversationId INT NULL,
  userId INT,
  hrOfficerId INT NULL,
  escalationQuestion VARCHAR(1000) NOT NULL,
  escalationDescription VARCHAR(1000),
  escalationStatus VARCHAR(50) DEFAULT 'Pending',
  submittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  resolvedAt DATETIME NULL,

  CONSTRAINT fk_escalation_conversation
    FOREIGN KEY (conversationId) REFERENCES chatbotConversations(conversationId)
    ON DELETE SET NULL,

  CONSTRAINT fk_escalation_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE SET NULL,

  CONSTRAINT fk_escalation_hr_officer
    FOREIGN KEY (hrOfficerId) REFERENCES users(userId)
    ON DELETE SET NULL
);

-- =========================================================
-- NOTIFICATIONS TABLE
-- For Notification and Update Alert Module
-- =========================================================

CREATE TABLE notifications (
  notificationId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT,
  documentId INT,
  title VARCHAR(150) NOT NULL,
  message VARCHAR(1000) NOT NULL,
  type VARCHAR(50) DEFAULT 'policy_update',
  isRead TINYINT(1) DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  readAt DATETIME NULL,

  CONSTRAINT fk_notification_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE SET NULL,

  CONSTRAINT fk_notification_document
    FOREIGN KEY (documentId) REFERENCES documents(documentId)
    ON DELETE SET NULL
);

-- =========================================================
-- SAVED DOCUMENTS TABLE
-- For Saved Documents and Personal Storage Module
-- =========================================================

CREATE TABLE savedDocuments (
  savedId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  documentId INT NOT NULL,
  savedAt DATETIME DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_saved_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE CASCADE,

  CONSTRAINT fk_saved_document
    FOREIGN KEY (documentId) REFERENCES documents(documentId)
    ON DELETE CASCADE,

  CONSTRAINT unique_saved_document
    UNIQUE (userId, documentId)
);

-- =========================================================
-- PERSONAL NOTES TABLE
-- For Saved Documents and Personal Storage Module
-- =========================================================

CREATE TABLE personalNotes (
  noteId INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  documentId INT NOT NULL,
  noteContent VARCHAR(1000) NOT NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_note_user
    FOREIGN KEY (userId) REFERENCES users(userId)
    ON DELETE CASCADE,

  CONSTRAINT fk_note_document
    FOREIGN KEY (documentId) REFERENCES documents(documentId)
    ON DELETE CASCADE
);

-- =========================================================
-- SAMPLE USERS
-- Passwords are plain text only for prototype/testing.
-- Later, backend should hash passwords.
-- =========================================================

INSERT INTO users
(fullName, email, password, department, role, designation, status)
VALUES
(
  'Admin User',
  'admin@johorhr.gov.my',
  'admin123',
  'Human Resource',
  'administrator',
  'System Administrator',
  'Active'
),
(
  'Registered User',
  'user@johorhr.gov.my',
  'user123',
  'Human Resource',
  'registered_user',
  'HR Officer',
  'Active'
);

-- =========================================================
-- SIX OFFICIAL DOCUMENT RECORDS
-- Store PDF files inside:
-- backend/uploads/documents/
-- =========================================================

INSERT INTO documents
(referenceNo, title, category, type, status, access, effectiveDate, version, reason, summary, fileName, filePath, totalViews, totalDownloads)
VALUES
(
  'JHR-TASKA-FORM-2025',
  'Borang Permohonan Subsidi TASKA',
  'Staff Benefits',
  'Form',
  'Published',
  'Public',
  '16 May 2025',
  '1.0',
  'Related to childcare subsidy application for eligible public officers.',
  'Application form for claiming childcare fee subsidy at workplace TASKA for public sector officers. It includes applicant details, spouse details, monthly income information, child information, TASKA confirmation and supporting document checklist.',
  'Borang.Subsidi TASKA.pdf',
  '/uploads/documents/Borang.Subsidi TASKA.pdf',
  42,
  15
),
(
  'JHR-TASKA-GUIDE-2025',
  'Garis Panduan Permohonan Subsidi TASKA',
  'Staff Benefits',
  'Guideline',
  'Published',
  'Public',
  '2025',
  '1.0',
  'Useful for officers searching about TASKA subsidy eligibility and application requirements.',
  'Guideline explaining the implementation of childcare fee subsidy at workplace TASKA. It covers household income eligibility, maximum subsidy amount, child age requirement, supporting documents, yearly resubmission and responsibilities of department heads.',
  'Garis Panduan Permohonan Subsidi TASKA.pdf',
  '/uploads/documents/Garis Panduan Permohonan Subsidi TASKA.pdf',
  65,
  24
),
(
  'JHR-PANGKAT-TBK-2025',
  'Garis Panduan Permohonan Kenaikan Pangkat Secara TBK',
  'Promotion',
  'Guideline',
  'Published',
  'Registered',
  '2025',
  '1.0',
  'Recommended for users searching about promotion, TBK1, TBK2 or career advancement.',
  'Guideline for time-based promotion implementation for Johor public service officers. It explains TBK1 and TBK2, 13-year service requirement, performance condition, affected officer categories, submission period and promotion date determination.',
  'GARIS PANDUAN PERMOHONAN KENAIKAN PANGKAT SECARA TBK.pdf',
  '/uploads/documents/GARIS PANDUAN PERMOHONAN KENAIKAN PANGKAT SECARA TBK.pdf',
  88,
  37
),
(
  'JHR-SPKN-2025',
  'Garis Panduan SPKN',
  'Overseas Travel',
  'Guideline',
  'Published',
  'Registered',
  '29 Dec 2025',
  '1.0',
  'Related to overseas travel application and SPKN procedure.',
  'Guideline for managing overseas travel applications for Johor public officers through the SPKN system. It covers official travel, personal travel, hajj and umrah applications, supporting documents, department approval and submission timeline.',
  'Garis Panduan SPKN 29122025.pdf',
  '/uploads/documents/Garis Panduan SPKN 29122025.pdf',
  51,
  12
),
(
  'JHR-COS-CFS-2024',
  'Garis Panduan Pengurusan Pegawai Lantikan Kontrak COS dan CFS',
  'Contract Service',
  'Guideline',
  'Published',
  'Registered',
  '1 Dec 2024',
  '1.0',
  'Useful for users searching about contract officer management under SSPA.',
  'Guideline for managing contract officers under Contract of Service and Contract for Service in Johor public service. It covers implementation of SSPA, contract officer categories, salary adjustment and appointment management.',
  'Lampiran 1.Garis PanduanCOS.CFS.pdf',
  '/uploads/documents/Lampiran 1.Garis PanduanCOS.CFS.pdf',
  34,
  9
),
(
  'JHR-PANGKAT-TATATERTIB-2025',
  'Senarai Garis Panduan Seksyen Naik Pangkat dan Tatatertib',
  'Promotion and Discipline',
  'Reference Document',
  'Published',
  'Restricted',
  '2025',
  '1.0',
  'Related to promotion and disciplinary guideline reference.',
  'Scanned reference document related to promotion and disciplinary section guidelines. This document may require OCR before full-text search can work accurately.',
  'Senarai garis panduan sekyen Naik Pangkat Tatatertib.pdf',
  '/uploads/documents/Senarai garis panduan sekyen Naik Pangkat Tatatertib.pdf',
  23,
  6
);

-- =========================================================
-- SAMPLE FAQS
-- For FAQ and Knowledge Assistance Module
-- =========================================================

INSERT INTO faqs
(question, answer, category, status)
VALUES
(
  'How do I search for a HR document?',
  'You can search by document title, reference number, category or keyword from the Public Portal or Smart Support page.',
  'Search',
  'Published'
),
(
  'Why can I not access a restricted document?',
  'Restricted documents require registered user access and suitable permission level before they can be viewed or downloaded.',
  'Access Control',
  'Published'
),
(
  'How are document recommendations generated?',
  'Recommendations are generated based on user activity, document category, recent searches and frequently accessed documents.',
  'Recommendation',
  'Published'
),
(
  'How do I apply for TASKA subsidy?',
  'You may refer to the TASKA subsidy guideline and complete the Borang Permohonan Subsidi TASKA with the required supporting documents.',
  'Staff Benefits',
  'Published'
),
(
  'How do I find promotion guidelines?',
  'Search for promotion, pangkat, TBK, or staff evaluation in the Smart Search module to view related promotion documents.',
  'Promotion',
  'Published'
);

-- =========================================================
-- SAMPLE RECOMMENDATIONS
-- For UI display testing
-- =========================================================

INSERT INTO recommendations
(userId, documentId, type, reason, score, status)
VALUES
(
  2,
  2,
  'personalized',
  'Recommended because you viewed staff benefit and TASKA-related documents.',
  92.50,
  'Active'
),
(
  2,
  3,
  'related_document',
  'Recommended because this document is related to promotion and career advancement policies.',
  88.00,
  'Active'
),
(
  2,
  4,
  'personalized',
  'Recommended because officers in your department frequently access overseas travel guidelines.',
  81.75,
  'Active'
);

-- =========================================================
-- SAMPLE NOTIFICATIONS
-- For UI display testing
-- =========================================================

INSERT INTO notifications
(userId, documentId, title, message, type, isRead)
VALUES
(
  2,
  1,
  'New TASKA subsidy form available',
  'The Borang Permohonan Subsidi TASKA document is now available in the system.',
  'policy_update',
  0
),
(
  2,
  3,
  'Promotion guideline updated',
  'A time-based promotion guideline has been added for public service officers.',
  'smart_alert',
  0
),
(
  2,
  4,
  'SPKN guideline available',
  'The SPKN overseas travel guideline is available for registered users.',
  'policy_update',
  1
);

-- =========================================================
-- SAMPLE SAVED DOCUMENTS
-- For UI display testing
-- =========================================================

INSERT INTO savedDocuments
(userId, documentId)
VALUES
(2, 2),
(2, 3),
(2, 4);

-- =========================================================
-- SAMPLE PERSONAL NOTES
-- For UI display testing
-- =========================================================

INSERT INTO personalNotes
(userId, documentId, noteContent)
VALUES
(
  2,
  2,
  'Check TASKA subsidy eligibility before submitting monthly claim.'
),
(
  2,
  3,
  'Important for officers who have completed 13 years of service.'
);

-- =========================================================
-- Test queries
-- Run these after import to check data
-- =========================================================

SELECT * FROM users;
SELECT * FROM documents;
SELECT * FROM recommendations;
SELECT * FROM notifications;
SELECT * FROM savedDocuments;
SELECT * FROM personalNotes;
SELECT * FROM recommendationReports;
SELECT * FROM faqs;
SELECT * FROM chatbotConversations;
SELECT * FROM documentSummaries;
SELECT * FROM escalationRequests;