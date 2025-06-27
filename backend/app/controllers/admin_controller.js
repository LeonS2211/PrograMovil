const express = require("express");
const Admin = require("../models/admin"); // Importamos el modelo Admin
const bcrypt = require("bcrypt"); // Para la validación segura de contraseñas
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
        message: "Por favor complete todos los campos",
        detail: "Faltan usuario o contraseña",
      };
      status = 400; // Solicitud incompleta
    } else {
      // Buscamos al administrador en la base de datos
      const admin = await Admin.findOne({
        attributes: ['id', 'username', 'email', 'role', 'password', 'listProvider'], // Asegúrate de incluir `listProvider` y `password`
        where: {
          username: username,
        },
      });

      if (admin) {
        // Verificar si la contraseña es correcta (en caso de que esté hasheada en la base de datos)
        const passwordMatch = await bcrypt.compare(password, admin.password); // Compara la contraseña hasheada

        if (passwordMatch) {
          status = 200;
          response = {
            message: "Login exitoso",
            body: {
              id: admin.id,
              username: admin.username,
              email: admin.email,
              role: admin.role,
              listProvider: admin.listProvider, // Lista de proveedores para la siguiente pantalla
            },
          };
        } else {
          // Si la contraseña no es correcta
          status = 401; // Unauthorized
          response = {
            message: "Credenciales incorrectas",
            detail: "La contraseña es incorrecta",
          };
        }
      } else {
        // Si no encontramos el administrador
        status = 404; // No encontrado
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
