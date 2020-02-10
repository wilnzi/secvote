/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.backend.mvc.model;

/**
 *
 * @author WILFRIED
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseConnectionManager {

    private Connection connection = null;

    public Connection openConnection() {
        String DATABASE_PSEUDO = "seadmin";

        int DATABASE_PORT = 3306;
//        int DATABASE_PORT = 5462;

        String DATABASE_URL = "jdbc:mariadb://localhost:" + DATABASE_PORT + "/sedb01?allowMultiQueries=true&characterEncoding=UTF-8&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";

        String DATABASE_PASSWORD = "eGN4e$$GN3eEBAISFjMlZoWkcxcGNCWJrQjNhV3h1ZW1r@@dVkyMGdZMjl2YlE";

        try {
            Class.forName("org.mariadb.jdbc.Driver");

            if (this.connection == null) {
                this.connection = DriverManager.getConnection(DATABASE_URL, DATABASE_PSEUDO, DATABASE_PASSWORD);
                this.connection.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return this.connection;
    }

    public Connection openConnection(boolean autoCommit) {
        try {
            this.connection = openConnection();
            this.connection.setAutoCommit(autoCommit);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return this.connection;
    }

    public void closeConnection() {
        try {
            if (this.connection != null) {
                this.connection.close();
            }
            if (this.connection != null) {
                this.connection = null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
