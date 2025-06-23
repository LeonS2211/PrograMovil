const express = require("express");
//const User = require("../models/user");
const sequelize = require("../../config/database");
const { jwtMiddleware } = require("../../config/middlewares");
const router = express.Router();

// GET: BASE_URL + /apis/v1/topics
router.get("/", jwtMiddleware, async (req, res) => {
  const users = await User.findAll();
  res.json(users);
});

router.post("/sign-in", async (req, res) => {
  // recibir parametros
  const { username, password } = req.body;
  // trabajar respuesta
  var response = {};
  var status = null;
  try {
    if (!username || !password) {
      response = {
        message: "No envió usuario y contraseña",
        detail: "",
      };
      status = 500;
    } else {
      const user = await User.findOne({
        attributes: ['id', 'username', 'email', 'image', 'fullname'],
        where: {
          username: username,
          password: password,
        },
      });
      if (user) {
        status = 200;
        response = user;
      } else {
        status = 404;
        response = {
          message: "Usuario no encontrado",
          detail: "",
        };
      }
    }
  } catch (error) {
    console.error("Error al validar el usuario:", error);
    status = 500;
    response = {
      message: "Error al validar el usuario",
      detail: error,
    };
  }
  // enviar respuesta
  res.status(status).json(response);
});

function generateRandomKey(length = 30) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  
  for (let i = 0; i < length; i++) {
      const randomIndex = Math.floor(Math.random() * chars.length);
      result += chars[randomIndex];
  }
  
  return result;
}

router.post("/reset-password", async (req, res) => {
  const { email } = req.body;

  let response = {};
  let status = null;

  try {
    if (!email) {
      return res.status(400).json({
        message: "Correo no proporcionado",
      });
    }

    const user = await User.findOne({
      where: {
        email: email,
      },
    });

    if (!user) {
      return res.status(404).json({
        message: "Usuario no encontrado",
      });
    }

    // Generar nueva reset_key y actualizar
    const newResetKey = generateRandomKey();
    await user.update({ reset_key: newResetKey });

    // Recargar datos para tener la información actualizada
    await user.reload();

    response = {
      message: "Clave de restablecimiento generada correctamente",
    };

    status = 200;

  } catch (error) {
    console.error("Error al procesar solicitud:", error);

    // Manejo específico para SQLITE_BUSY u otros errores conocidos
    if (error.original?.code === 'SQLITE_BUSY') {
      return res.status(503).json({
        message: "Servicio temporalmente no disponible. Inténtalo más tarde."
      });
    }

    return res.status(500).json({
      message: "Ocurrió un error interno",
      error: process.env.NODE_ENV === 'production' ? undefined : error.message
    });
  }

  return res.status(status).json(response);
});

router.get("/record", jwtMiddleware, async (req, res) => {
  const { user_id } = req.query;

  let response = {};
  let status = null;

  try {
    const [results, metadata] = await sequelize.query(`
      SELECT 
          COALESCE((
              SELECT COUNT(*) FROM alternatives A
              INNER JOIN users_answers UA ON UA.alternative_id = A.id
              WHERE A.correct = 1 AND UA.user_id = ${user_id}), 0) AS aciertos,
  
          COALESCE((
              SELECT COUNT(*) FROM users U 
              INNER JOIN quizzes Q ON U.id = Q.user_id 
              INNER JOIN quizzes_questions QQ ON QQ.quiz_id = Q.id 
              WHERE U.id = ${user_id}), 0) AS total_alternativas,
  
          (COALESCE((
              SELECT COUNT(*) FROM alternatives A
              INNER JOIN users_answers UA ON UA.alternative_id = A.id
              WHERE A.correct = 1 AND UA.user_id = 1), 0)
          ) * 1.0 /
          NULLIF((
              SELECT COUNT(*) FROM users U 
              INNER JOIN quizzes Q ON U.id = Q.user_id 
              INNER JOIN quizzes_questions QQ ON QQ.quiz_id = Q.id 
              WHERE U.id = ${user_id}), 0) AS proporcion_acierto;
    `);
  
    console.log('Resultado:', results[0]); // El resultado viene como un array de objetos
  
    response = results[0];
      status = 200;
    

  } catch (error) {
    console.error("Error al procesar solicitud:", error);

    // Manejo específico para SQLITE_BUSY u otros errores conocidos
    if (error.original?.code === 'SQLITE_BUSY') {
      return res.status(503).json({
        message: "Servicio temporalmente no disponible. Inténtalo más tarde."
      });
    }

    return res.status(500).json({
      message: "Ocurrió un error interno",
      error: process.env.NODE_ENV === 'production' ? undefined : error.message
    });
  }

  return res.status(status).json(response);
});

module.exports = router;
