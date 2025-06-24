const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const Company = require('./company');
const Provider = require('/provider');

const Dependency = sequelize.define('Dependency', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },

    company_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Company,
            key: 'id'
        }
    },

    provider_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Provider,
            key: 'id'
        }
    },

    name: {
        type: DataTypes.STRING(255),
        allowNull: false
    },

    sign_date: {
        type: DataTypes.DATE,
        allowNull: true
    },

    validity_time: {
        type: DataTypes.STRING(255),
        allowNull: true
    },

    termination_date: {
        type: DataTypes.DATE,
        allowNull: true
    },

    aniversary: {
        type: DataTypes.STRING(255),
        allowNull: true
    },
    
    equipment: {
        type: DataTypes.STRING(255),
        allowNull: true
    }
}, {
    tableName: 'dependencies',
    timestamps: false
});

// Definimos la relación con Company
Contact.belongsTo(Company, {
    foreignKey: 'company_id',
    as: 'company' // Alias opcional para usar en consultas
});

// Definimos la relación con Provider
Contact.belongsTo(Provider, {
    foreignKey: 'provider_id',
    as: 'provider' // Alias opcional para usar en consultas
});

module.exports = Dependency;