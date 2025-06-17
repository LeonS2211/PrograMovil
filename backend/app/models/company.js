const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const Question = require('./question'); // Importamos el modelo Question

const Alternative = sequelize.define('Alternative', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    statement: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    correct: {
        type: DataTypes.BOOLEAN,
        allowNull: false
    },
    question_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Question,
            key: 'id'
        }
    }
}, {
    tableName: 'alternatives',
    timestamps: false
});

// Definimos la relación con Question
Alternative.belongsTo(Question, {
    foreignKey: 'question_id',
    as: 'question' // Alias opcional para usar en consultas
});

module.exports = Alternative;