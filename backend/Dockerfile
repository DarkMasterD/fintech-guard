# Usamos una versión ligera de Node.js
FROM node:18-alpine

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos dependencias
RUN npm install

# Copiamos el resto del código
COPY . .

# Puerto que exponemos
EXPOSE 3000

# Comando para arrancar
CMD ["npm", "start"]