const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');
const ISP = require('./isp');
const Provider = require('./provider'); // Asegúrate de tener este modelo creado

const IspService = sequelize.define('IspService', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    description: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    provider_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Provider,
            key: 'id'
        }
    },
    isp_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: ISP,
            key: 'id'
        }
    },
    cost: {
        type: DataTypes.FLOAT,
        allowNull: false
    },
    pay_code: {
        type: DataTypes.STRING(30),
        allowNull: false
    }
}, {
    tableName: 'isp_services',
    timestamps: false
});

// Definir relaciones
IspService.belongsTo(Provider, {
    foreignKey: 'provider_id',
    as: 'provider'
});

IspService.belongsTo(ISP, {
    foreignKey: 'isp_id',
    as: 'isp'
});

module.exports = IspService;
