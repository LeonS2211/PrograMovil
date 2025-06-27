const express = require("express");
const Dependency = require("../models/dependency");
const Provider = require("../models/provider");
const router = express.Router();

// GET: /dependencies
router.get("/", async (req, res) => {
  try {
    const dependencies = await Dependency.findAll();
    res.status(200).json(dependencies);
  } catch (error) {
    console.error("Error al obtener dependencias:", error);
    res.status(500).json({
      message: "Error al obtener dependencias",
      detail: error.message,
    });
  }
});

// GET: /dependencies/:id
router.get("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const dependency = await Dependency.findByPk(id);
    if (!dependency) {
      return res.status(404).json({
        message: "Dependencia no encontrada",
        detail: "",
      });
    }

    res.status(200).json(dependency);
  } catch (error) {
    console.error("Error al obtener dependencia:", error);
    res.status(500).json({
      message: "Error al obtener dependencia",
      detail: error.message,
    });
  }
});

// GET: /dependencies/provider/:provider_id/company/:company_id
router.get("/provider/:provider_id/company/:company_id", async (req, res) => {
  const { provider_id, company_id } = req.params;

  try {
    const dependencies = await Dependency.findAll({
      where: {
        provider_id,
        company_id
      },
    });

    if (dependencies.length === 0) {
      return res.status(404).json({
        message: "No se encontraron dependencias para el proveedor y la compañía especificados",
        detail: "",
      });
    }

    res.status(200).json(dependencies);
  } catch (error) {
    console.error("Error al obtener dependencias:", error);
    res.status(500).json({
      message: "Error al obtener dependencias",
      detail: error.message,
    });
  }
});

// GET: /dependencies/providers/names
router.get("/providers/names", async (req, res) => {
  try {
    const providers = await Provider.findAll({
      attributes: ['id', 'name']
    });

    if (providers.length === 0) {
      return res.status(404).json({
        message: "No se encontraron proveedores",
        detail: "",
      });
    }

    const formatted = providers.map(p => ({ id: p.id, name: p.name }));
    res.status(200).json(formatted);
  } catch (error) {
    console.error("Error al obtener nombres de proveedores:", error);
    res.status(500).json({
      message: "Error al obtener nombres de proveedores",
      detail: error.message,
    });
  }
});

// POST: /dependencies
router.post("/", async (req, res) => {
  const { provider_id, company_id, name, sign_date, validity_time, termination_date, anniversary, equipment } = req.body;

  try {
    if (!provider_id || !company_id || !name || !sign_date || !validity_time || !termination_date || !anniversary) {
      return res.status(400).json({
        message: "provider_id, company_id, name, sign_date, validity_time, termination_date y anniversary son requeridos",
        detail: "",
      });
    }

    const newDependency = await Dependency.create({ provider_id, company_id, name, sign_date, validity_time, termination_date, anniversary, equipment });
    res.status(201).json(newDependency);
  } catch (error) {
    console.error("Error al crear dependencia:", error);
    res.status(500).json({
      message: "Error al crear dependencia",
      detail: error.message,
    });
  }
});

// PUT: /dependencies/:id
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { provider_id, company_id, name, sign_date, validity_time, termination_date, anniversary, equipment } = req.body;

  try {
    const dependency = await Dependency.findByPk(id);

    if (!dependency) {
      return res.status(404).json({
        message: "Dependencia no encontrada",
        detail: "",
      });
    }

    await dependency.update({
      provider_id: provider_id || dependency.provider_id,
      company_id: company_id || dependency.company_id,
      name: name || dependency.name,
      sign_date: sign_date || dependency.sign_date,
      validity_time: validity_time || dependency.validity_time,
      termination_date: termination_date || dependency.termination_date,
      anniversary: anniversary || dependency.anniversary,
      equipment: equipment || dependency.equipment
    });

    res.status(200).json(dependency);
  } catch (error) {
    console.error("Error al actualizar dependencia:", error);
    res.status(500).json({
      message: "Error al actualizar dependencia",
      detail: error.message,
    });
  }
});

// DELETE: /dependencies/:id
router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const dependency = await Dependency.findByPk(id);

    if (!dependency) {
      return res.status(404).json({
        message: "Dependencia no encontrada",
        detail: "",
      });
    }

    await dependency.destroy();
    res.status(200).json({
      message: "Dependencia eliminada correctamente",
      detail: "",
    });
  } catch (error) {
    console.error("Error al eliminar dependencia:", error);
    res.status(500).json({
      message: "Error al eliminar dependencia",
      detail: error.message,
    });
  }
});

module.exports = router;
