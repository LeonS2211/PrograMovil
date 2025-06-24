const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const ISP = sequelize.define('ISP', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    name: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    ruc: {
        type: DataTypes.STRING(11),
        allowNull: false
    }
}, {
    tableName: 'isps',
    timestamps: false
});



module.exports = ISP;
