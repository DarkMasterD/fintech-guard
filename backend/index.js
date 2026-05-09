import express from 'express';
import pg from 'pg';
import { createClient } from 'redis';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

// Configuración de Postgres (DATABASE_URL viene del docker-compose)
const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
});

// Configuración de Redis
const redisClient = createClient({ url: process.env.REDIS_URL });
redisClient.on('error', err => console.error('Redis Error', err));
await redisClient.connect();

// RUTA DE PRUEBA: Para ver si la base de datos responde
app.get('/health', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ status: 'ok', db_time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`🚀 Motor de Reglas en puerto ${PORT}`);
});