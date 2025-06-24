const express = require('express');
const fs = require('fs');
const app = express();
const PORT = 3000;

app.use(express.json());

let ispServices = [];

// Cargar los datos al iniciar
fs.readFile('./assets/jsons/isp_service.json', 'utf8', (err, data) => {
  if (err) {
    console.error('Error al leer isp_service.json:', err);
  } else {
    ispServices = JSON.parse(data);
    console.log(`Cargados ${ispServices.length} servicios`);
  }
});

// GET /isp-service?providerId=ID
app.get('/isp-service', (req, res) => {
  const providerId = parseInt(req.query.providerId, 10);

  if (providerId) {
    const filtered = ispServices.filter(s => s.providerId === providerId);
    return res.status(200).json({
      status: 200,
      body: filtered
    });
  }

  // Si no se pasa providerId, devuelve todos
  res.status(200).json({
    status: 200,
    body: ispServices
  });
});

// POST /isp-service
app.post('/isp-service', (req, res) => {
  const { id, description, providerId } = req.body;

  if (!id || !description || !providerId) {
    return res.status(400).json({
      status: 400,
      body: 'Missing id, description, or providerId'
    });
  }

  // Verificar si existe
  const exists = ispServices.some(s => 
    s.description === description && s.providerId === providerId
  );

  if (exists) {
    return res.status(409).json({
      status: 409,
      body: false
    });
  }

  // Agregar al array (en memoria)
  ispServices.push({ id, description, providerId });

  res.status(201).json({
    status: 201,
    body: true
  });
});

app.listen(PORT, () => {
  console.log(`Servidor backend corriendo en http://localhost:${PORT}`);
});

