import express from 'express'
import cors from 'cors'
import path from 'path'
import { fileURLToPath } from 'url'
import db from './db.js'

const app = express()
const PORT = 3000

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

app.use(cors())
app.use(express.json())

app.use('/uploads', express.static(path.join(__dirname, 'uploads')))

app.get('/', (req, res) => {
  res.send('Johor HR Knowledge Hub backend is running. Use /api/documents to view documents.')
})

app.get('/api/documents', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM documents ORDER BY documentId DESC')
    res.json(rows)
  } catch (error) {
    res.status(500).json({ message: 'Failed to load documents', error: error.message })
  }
})

app.get('/api/documents/:documentId', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM documents WHERE documentId = ?',
      [req.params.documentId]
    )

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Document not found' })
    }

    res.json(rows[0])
  } catch (error) {
    res.status(500).json({ message: 'Failed to load document', error: error.message })
  }
})

app.get('/api/documents/search/:keyword', async (req, res) => {
  try {
    const keyword = `%${req.params.keyword}%`

    const [rows] = await db.query(
      `SELECT * FROM documents
       WHERE title LIKE ?
       OR referenceNo LIKE ?
       OR category LIKE ?
       OR summary LIKE ?
       ORDER BY documentId DESC`,
      [keyword, keyword, keyword, keyword]
    )

    res.json(rows)
  } catch (error) {
    res.status(500).json({ message: 'Search failed', error: error.message })
  }
})

// Get recommendations from database
app.get('/api/recommendations/:userId', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT 
        r.recommendationId,
        r.userId,
        r.documentId,
        r.type AS recommendationType,
        r.reason,
        r.score,
        r.status AS recommendationStatus,
        r.createdAt AS recommendationCreatedAt,
        d.referenceNo,
        d.title,
        d.category,
        d.type,
        d.status,
        d.access,
        d.effectiveDate,
        d.version,
        d.summary,
        d.fileName,
        d.filePath,
        d.totalViews,
        d.totalDownloads
      FROM recommendations r
      JOIN documents d ON r.documentId = d.documentId
      WHERE r.userId = ?
      ORDER BY r.score DESC, r.createdAt DESC`,
      [req.params.userId]
    )

    res.json(rows)
  } catch (error) {
    res.status(500).json({
      message: 'Failed to load recommendations',
      error: error.message
    })
  }
})

// Refresh recommendations
app.post('/api/recommendations/refresh/:userId', async (req, res) => {
  try {
    const userId = req.params.userId

    const [documents] = await db.query(
      `SELECT documentId, title, category, totalViews, totalDownloads
       FROM documents
       WHERE access != 'Restricted'
       ORDER BY totalViews DESC, totalDownloads DESC
       LIMIT 3`
    )

    await db.query(
      `DELETE FROM recommendations 
       WHERE userId = ? AND status = 'Active'`,
      [userId]
    )

    for (const doc of documents) {
      await db.query(
        `INSERT INTO recommendations
        (userId, documentId, type, reason, score, status)
        VALUES (?, ?, ?, ?, ?, ?)`,
        [
          userId,
          doc.documentId,
          'refreshed',
          `Recommended because ${doc.category} documents are currently relevant and frequently accessed.`,
          85.00,
          'Active'
        ]
      )
    }

    res.json({
      message: 'Recommendations refreshed successfully'
    })
  } catch (error) {
    res.status(500).json({
      message: 'Failed to refresh recommendations',
      error: error.message
    })
  }
})

// Submit incorrect recommendation report
app.post('/api/recommendation-reports', async (req, res) => {
  try {
    const {
      recommendationId,
      userId,
      reportReason,
      reportDescription
    } = req.body

    if (!recommendationId || !userId || !reportReason) {
      return res.status(400).json({
        message: 'recommendationId, userId and reportReason are required'
      })
    }

    await db.query(
      `INSERT INTO recommendationReports
      (recommendationId, userId, reportReason, reportDescription, reportStatus)
      VALUES (?, ?, ?, ?, ?)`,
      [
        recommendationId,
        userId,
        reportReason,
        reportDescription || '',
        'Pending'
      ]
    )

    await db.query(
      `UPDATE recommendations
       SET status = 'Reported'
       WHERE recommendationId = ?`,
      [recommendationId]
    )

    res.json({
      message: 'Recommendation report submitted successfully'
    })
  } catch (error) {
    res.status(500).json({
      message: 'Failed to submit recommendation report',
      error: error.message
    })
  }
})

// Get FAQs
app.get('/api/faqs', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT * FROM faqs 
       WHERE status = 'Published'
       ORDER BY faqId ASC`
    )

    res.json(rows)
  } catch (error) {
    res.status(500).json({
      message: 'Failed to load FAQs',
      error: error.message
    })
  }
})

// Save chatbot conversation
app.post('/api/chatbot/conversations', async (req, res) => {
  try {
    const {
      userId,
      questionText,
      responseText,
      relatedDocumentId,
      confidenceScore
    } = req.body

    if (!questionText) {
      return res.status(400).json({
        message: 'questionText is required'
      })
    }

    const [result] = await db.query(
      `INSERT INTO chatbotConversations
      (userId, questionText, responseText, relatedDocumentId, confidenceScore, conversationStatus)
      VALUES (?, ?, ?, ?, ?, ?)`,
      [
        userId || null,
        questionText,
        responseText || '',
        relatedDocumentId || null,
        confidenceScore || 85.00,
        'Answered'
      ]
    )

    res.json({
      message: 'Chatbot conversation saved successfully',
      conversationId: result.insertId
    })
  } catch (error) {
    res.status(500).json({
      message: 'Failed to save chatbot conversation',
      error: error.message
    })
  }
})

// Get chatbot conversation history
app.get('/api/chatbot/conversations/:userId', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT * FROM chatbotConversations
       WHERE userId = ?
       ORDER BY createdAt DESC
       LIMIT 10`,
      [req.params.userId]
    )

    res.json(rows)
  } catch (error) {
    res.status(500).json({
      message: 'Failed to load chatbot conversation history',
      error: error.message
    })
  }
})

// Rate chatbot response
app.patch('/api/chatbot/conversations/:conversationId/rating', async (req, res) => {
  try {
    const { ratingValue, ratingComment } = req.body

    await db.query(
      `UPDATE chatbotConversations
       SET ratingValue = ?, ratingComment = ?
       WHERE conversationId = ?`,
      [
        ratingValue,
        ratingComment || '',
        req.params.conversationId
      ]
    )

    res.json({
      message: 'Chatbot response rating saved successfully'
    })
  } catch (error) {
    res.status(500).json({
      message: 'Failed to rate chatbot response',
      error: error.message
    })
  }
})

// Generate document summary
app.post('/api/document-summaries', async (req, res) => {
  try {
    const { documentId, userId } = req.body

    if (!documentId) {
      return res.status(400).json({
        message: 'documentId is required'
      })
    }

    const [documents] = await db.query(
      `SELECT * FROM documents WHERE documentId = ?`,
      [documentId]
    )

    if (documents.length === 0) {
      return res.status(404).json({
        message: 'Document not found'
      })
    }

    const doc = documents[0]

    const summaryText = `Summary for ${doc.title}: ${doc.summary || 'This document contains HR policy information related to ' + doc.category + '.'}`

    const [result] = await db.query(
      `INSERT INTO documentSummaries
      (documentId, userId, summaryText, summaryStatus)
      VALUES (?, ?, ?, ?)`,
      [
        documentId,
        userId || null,
        summaryText,
        'Generated'
      ]
    )

    res.json({
      message: 'Document summary generated successfully',
      summaryId: result.insertId,
      summaryText
    })
  } catch (error) {
    res.status(500).json({
      message: 'Failed to generate document summary',
      error: error.message
    })
  }
})

// Escalate question to HR officer
app.post('/api/escalation-requests', async (req, res) => {
  try {
    const {
      conversationId,
      userId,
      escalationQuestion,
      escalationDescription
    } = req.body

    if (!escalationQuestion) {
      return res.status(400).json({
        message: 'escalationQuestion is required'
      })
    }

    await db.query(
      `INSERT INTO escalationRequests
      (conversationId, userId, escalationQuestion, escalationDescription, escalationStatus)
      VALUES (?, ?, ?, ?, ?)`,
      [
        conversationId || null,
        userId || null,
        escalationQuestion,
        escalationDescription || '',
        'Pending'
      ]
    )

    if (conversationId) {
      await db.query(
        `UPDATE chatbotConversations
         SET conversationStatus = 'Escalated'
         WHERE conversationId = ?`,
        [conversationId]
      )
    }

    res.json({
      message: 'Question escalated to HR officer successfully'
    })
  } catch (error) {
    res.status(500).json({
      message: 'Failed to escalate question',
      error: error.message
    })
  }
})

app.listen(PORT, () => {
  console.log(`Backend running at http://localhost:${PORT}`)
})