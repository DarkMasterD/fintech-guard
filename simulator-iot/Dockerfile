FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Puerto por defecto de Vite
EXPOSE 5173

# Ejecutamos en modo desarrollo con acceso externo
CMD ["npm", "run", "dev", "--", "--host"]