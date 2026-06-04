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

app.listen(PORT, () => {
  console.log(`Backend running at http://localhost:${PORT}`)
})