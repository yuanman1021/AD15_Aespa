import mysql from 'mysql2/promise'

const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'johor_hr_knowledge_hub',
  waitForConnections: true,
  connectionLimit: 10
})

export default db