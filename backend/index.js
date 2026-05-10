import express from 'express';
import pg from 'pg';
import { createClient } from 'redis';

const app = express();
app.use(express.json());

// Configuración de Postgres usando la variable de entorno de Docker
const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL 
});

// Configuración de Redis [cite: 91, 104]
const redisClient = createClient({
  url: process.env.REDIS_URL
});

redisClient.on('error', err => console.log('Redis Client Error', err));
await redisClient.connect();

app.listen(3000, () => {
  console.log('Motor de Reglas FinTech corriendo en el puerto 3000');
});