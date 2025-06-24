const express = require('express');
const fs = require('fs');
const app = express();
const PORT = 3000;

app.use(express.json());

// Cargar el JSON de ISPs al arrancar
let isps = [];
fs.readFile('./assets/jsons/isp.json', 'utf8', (err, data) => {
  if (err) {
    console.error('Error al leer el archivo isp.json:', err);
  } else {
    isps = JSON.parse(data);
  }
});

// GET: obtener todos los ISPs
app.get('/isp', (req, res) => {
  const ispNamesWithId = isps.map(isp => ({
    id: isp.id,
    name: isp.name
  }));
  res.status(200).json({
    status: 200,
    body: ispNamesWithId
  });
});

// GET: obtener un ISP por ID
app.get('/isp/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const isp = isps.find(i => i.id === id);

  if (isp) {
    res.status(200).json({
      status: 200,
      body: isp
    });
  } else {
    res.status(404).json({
      status: 404,
      body: null
    });
  }
});

// POST: agregar un nuevo ISP
app.post('/isp', (req, res) => {
  const { id, name } = req.body;

  if (!id || !name) {
    return res.status(400).json({
      status: 400,
      body: 'Missing id or name'
    });
  }

  // Simular agregar al array (no persiste en el archivo)
  isps.push({ id, name });

  res.status(201).json({
    status: 201,
    body: { id, name }
  });
});

app.listen(PORT, () => {
  console.log(`Servidor backend corriendo en http://localhost:${PORT}`);
});

