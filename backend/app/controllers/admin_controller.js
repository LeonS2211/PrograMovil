const express = require("express");
const Admin = require("../models/admin"); // Importamos el modelo Admin
const router = express.Router();

// POST: Sign-in for admin login
router.post("/sign-in", async (req, res) => {
  const { username, password } = req.body;

  let response = {};
  let status = null;

  try {
    // Verificamos si se recibieron los parámetros
    if (!username || !password) {
      response = {
        message: "No envió usuario y contraseña",
        detail: "",
      };
      status = 400; // Cambié a 400 para indicar que la solicitud está incompleta
    } else {
      // Buscamos al administrador en la base de datos
      const admin = await Admin.findOne({
        attributes: ['id', 'username', 'email', 'role'], // Asegúrate de que estos son los campos que necesitas
        where: {
          username: username,
          password: password, // Asegúrate de manejar contraseñas de forma segura (con hash)
        },
      });

      if (admin) {
        status = 200;
        response = admin; // Devolvemos el administrador encontrado
      } else {
        status = 404; // Si no encontramos al administrador
        response = {
          message: "Administrador no encontrado",
          detail: "",
        };
      }
    }
  } catch (error) {
    console.error("Error al validar el administrador:", error);
    status = 500; // Error interno
    response = {
      message: "Error al validar el administrador",
      detail: error,
    };
  }

  // Enviar respuesta con el status adecuado
  res.status(status).json(response);
});

module.exports = router;
