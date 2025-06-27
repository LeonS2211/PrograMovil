const express = require("express");
const Contact = require("../models/contact");
const Dependency = require("../models/dependency");

const router = express.Router();

// GET: /contacts
router.get("/", async (req, res) => {
  try {
    const contacts = await Contact.findAll();
    res.status(200).json(contacts);
  } catch (error) {
    console.error("Error al obtener contactos:", error);
    res.status(500).json({
      message: "Error al obtener contactos",
      detail: error.message
    });
  }
});

// GET: /contacts/:id
router.get("/:id", async (req, res) => {
  const { id } = req.params;

  if (!id || isNaN(id)) {
    return res.status(400).json({
      message: "ID de contacto inválido",
      detail: ""
    });
  }

  try {
    const contact = await Contact.findByPk(id);

    if (!contact) {
      return res.status(404).json({
        message: "Contacto no encontrado",
        detail: ""
      });
    }

    res.status(200).json(contact);
  } catch (error) {
    console.error("Error al obtener contacto:", error);
    res.status(500).json({
      message: "Error al obtener contacto",
      detail: error.message
    });
  }
});

// GET: /contacts/dependency/:dependency_id
router.get("/dependency/:dependency_id", async (req, res) => {
  const { dependency_id } = req.params;

  if (!dependency_id || isNaN(dependency_id)) {
    return res.status(400).json({
      message: "ID de dependencia inválido",
      detail: ""
    });
  }

  try {
    const contacts = await Contact.findAll({
      where: { dependency_id },
    });

    if (contacts.length === 0) {
      return res.status(404).json({
        message: "No se encontraron contactos para esta dependencia",
        detail: ""
      });
    }

    res.status(200).json(contacts);
  } catch (error) {
    console.error("Error al obtener contactos por dependencia:", error);
    res.status(500).json({
      message: "Error al obtener contactos por dependencia",
      detail: error.message
    });
  }
});

// POST: /contacts
router.post("/", async (req, res) => {
  const { dependency_id, name, last_name, cellphone, rank, position, birthday } = req.body;

  if (!dependency_id || !name || !last_name || !cellphone || !rank || !position || !birthday) {
    return res.status(400).json({
      message: "dependency_id, name, last_name, cellphone, rank, position y birthday son requeridos",
      detail: ""
    });
  }

  try {
    const dependency = await Dependency.findByPk(dependency_id);
    if (!dependency) {
      return res.status(404).json({
        message: "La dependencia especificada no existe",
        detail: ""
      });
    }

    const newContact = await Contact.create({
      dependency_id, name, last_name, cellphone, rank, position, birthday
    });

    res.status(201).json(newContact);
  } catch (error) {
    console.error("Error al crear contacto:", error);
    res.status(500).json({
      message: "Error al crear contacto",
      detail: error.message
    });
  }
});

// PUT: /contacts/:id
router.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { dependency_id, name, last_name, cellphone, rank, position, birthday } = req.body;

  if (!id || isNaN(id)) {
    return res.status(400).json({
      message: "ID de contacto inválido",
      detail: ""
    });
  }

  try {
    const contact = await Contact.findByPk(id);

    if (!contact) {
      return res.status(404).json({
        message: "Contacto no encontrado",
        detail: ""
      });
    }

    if (dependency_id && dependency_id !== contact.dependency_id) {
      const dependency = await Dependency.findByPk(dependency_id);
      if (!dependency) {
        return res.status(404).json({
          message: "La nueva dependencia no existe",
          detail: ""
        });
      }
    }

    await contact.update({
      dependency_id: dependency_id || contact.dependency_id,
      name: name || contact.name,
      last_name: last_name|| contact.last_name,
      cellphone: cellphone || contact.cellphone,
      rank: rank || contact.rank,
      position: position || contact.position,
      birthday: birthday || contact.birthday
    });

    res.status(200).json(contact);
  } catch (error) {
    console.error("Error al actualizar contacto:", error);
    res.status(500).json({
      message: "Error al actualizar contacto",
      detail: error.message
    });
  }
});

// DELETE: /contacts/:id
router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  if (!id || isNaN(id)) {
    return res.status(400).json({
      message: "ID de contacto inválido",
      detail: ""
    });
  }

  try {
    const contact = await Contact.findByPk(id);

    if (!contact) {
      return res.status(404).json({
        message: "Contacto no encontrado",
        detail: ""
      });
    }

    await contact.destroy();
    res.status(200).json({
      message: "Contacto eliminado correctamente",
      detail: ""
    });
  } catch (error) {
    console.error("Error al eliminar contacto:", error);
    res.status(500).json({
      message: "Error al eliminar contacto",
      detail: error.message
    });
  }
});

module.exports = router;
