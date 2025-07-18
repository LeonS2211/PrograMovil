const express = require('express');
const ISPService = require('../models/isp_service');
const router = express.Router();

// GET /isp_services?provider_id=ID (opcional)
router.get('/', async (req, res) => {
  try {
    const providerId = parseInt(req.query.provider_id, 10);
    let services;
    if (providerId) {
      services = await ISPService.findAll({ where: { provider_id: providerId } });
    } else {
      services = await ISPService.findAll();
    }
    res.status(200).json(services);
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener servicios', error: err });
  }
});

// GET /isp_services/:id
router.get('/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const service = await ISPService.findByPk(id);
    if (service) {
      res.status(200).json(service);
    } else {
      res.status(404).json({ message: 'Servicio no encontrado' });
    }
  } catch (err) {
    res.status(500).json({ message: 'Error al obtener el servicio', error: err });
  }
});

// POST /isp_services
router.post('/', async (req, res) => {
  const { isp_id, provider_id, description, cost, pay_code } = req.body;
  console.log("📥 POST /isp_services - Body recibido:", req.body);

  if (!isp_id || !provider_id || !description || !cost || !pay_code) {
    console.log("⚠️ POST /isp_services - Faltan campos obligatorios");
    return res.status(400).json({ message: 'Faltan campos obligatorios' });
  }
  
  try {
    const newService = await ISPService.create({
      isp_id,
      provider_id,
      description,
      cost,
      pay_code
    });
    console.log("✅ POST /isp_services - Servicio creado correctamente:", newService);
    res.status(201).json(newService);
  } catch (err) {
    console.error("❌ POST /isp_services - Error al crear servicio:", err);
    res.status(500).json({ message: 'Error al crear servicio', error: err });
  }
});

module.exports = router;

