const express = require("express");
const jwt = require("jsonwebtoken");
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
				attributes: ["id", "username", "password"], // Asegúrate de incluir `listProvider` y `password`
				where: {
					username: username,
				},
			});

			if (admin) {
				// Verificar si la contraseña es correcta (en caso de que esté hasheada en la base de datos)
				const passwordMatch = await bcrypt.compare(password, admin.password); // Compara la contraseña hasheada

				if (passwordMatch) {
					// 👇 Aquí generamos el token JWT
					const token = jwt.sign(
						{
							id: admin.id,
							username: admin.username,
							// puedes incluir más info si es necesario
						},
						process.env.JWT_SECRET || "fallback-secret-key", // Usa una buena clave
						{ expiresIn: "1h" } // Tiempo de expiración del token
					);

					// 👇 Devolvemos el usuario + token
					status = 200;
					response = {
						admin,
						token,
					};
				} else {
					// Si la contraseña no es correcta
					status = 401; // Unauthorized
					response = {
						message: "Credenciales incorrectas",
						detail: passwordMatch,
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
