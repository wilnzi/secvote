/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.backend.management.counting;

import cm.wilnzi.secvote.backend.mvc.model.AbstractManager;
import cm.wilnzi.secvote.backend.mvc.model.DataBaseConnectionManager; 
import com.google.gson.JsonObject;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author WILFRIED
 */
public class CountingManagement extends AbstractManager{
    
    public CountingManagement(JsonObject jsonObject){
        super(jsonObject);
    }
    
    
    public JsonObject launch(){
        DataBaseConnectionManager dataBaseConnectionManager = new DataBaseConnectionManager();
        Connection connection = dataBaseConnectionManager.openConnection();
        
        try {
            String query = "SELECT * FROM personne;";
            PreparedStatement preparedStatement = connection.prepareStatement(query); 
            ResultSet resultSet = preparedStatement.executeQuery(); 
            String exit = "";
            while (resultSet.next()) {
                
               exit += resultSet.getString(2);
               exit += "--"+resultSet.getString(1);
               exit += "****end****";
            }

            this.exitJsonObject.addProperty("result", exit);
        } catch (SQLException ex) {
            Logger.getLogger(CountingManagement.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            dataBaseConnectionManager.closeConnection();
        }
    
        return this.exitJsonObject;
    }
}
