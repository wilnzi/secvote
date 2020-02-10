/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.test;

import cm.wilnzi.database.DataBaseConnectionManager;
import cm.wilnzi.encryption.Cypher;
import cm.wilnzi.encryption.Hash;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

/**
 *
 * @author WILFRIED
 */
public class Main {

    public static void main(String[] args) {
        new Main(args);
    }

    public Main(String[] args) {
//        Arrays.stream(args).forEach(key -> {
//        
//            String[] array = key.split(",");
//            if(array.length == 2) {
//                try {
//                    String columnSeparator = " --> ";
//                  Cypher cypher = new Cypher(array[1]);
//                  String cypherText = cypher.encrypt(array[0]);
//                  String sqlCode = "INSERT INTO vote_chiffre(empreinte, valeur, etat, ordre_cle) VALUES('@1@','@2@',@3@,@4@);";
//                  sqlCode = sqlCode.replace("@1@","d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de");
//                  sqlCode = sqlCode.replace("@2@",cypherText);
//                  sqlCode = sqlCode.replace("@3@","1");
//                  sqlCode = sqlCode.replace("@4@","1");
////                    System.out.println(array[0] + columnSeparator + array[1]+ columnSeparator + cypherText + columnSeparator + cypher.decrypt(cypherText)+ columnSeparator +sqlCode); 
//                    System.out.println(sqlCode); 
//                } catch (NoSuchPaddingException ex) {
//                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (NoSuchAlgorithmException ex) {
//                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (InvalidAlgorithmParameterException ex) {
//                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (InvalidKeyException ex) {
//                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (BadPaddingException ex) {
//                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
//                } catch (IllegalBlockSizeException ex) {
//                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
//                }
//            }
//             
//        } ); 

        count();
    }

    public void count() {
        HashMap<Integer, String> hashMap = Counting.initiateSystemKeys();
        Counting counting = new Counting(hashMap);
        try {
            counting.count();
        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String launch() {

        try {

            System.out.println("Hash " + Hash.sha256("12134"));
            System.out.println("Hash " + Hash.sha384("12134"));
            System.out.println("Hash " + Hash.sha512("12134"));

            System.out.println("Cypher " + new Cypher().encrypt("Bonjour"));
            DataBaseConnectionManager dataBaseConnectionManager = new DataBaseConnectionManager();
            Connection connection = dataBaseConnectionManager.openConnection();

            try {
                String query = "SELECT * FROM personne;";
                PreparedStatement preparedStatement = connection.prepareStatement(query);
                ResultSet resultSet = preparedStatement.executeQuery();
                String exit = "";
                while (resultSet.next()) {

                    exit += resultSet.getString(2);
                    exit += "--" + resultSet.getString(1);
                    exit += "--" + resultSet.getString(3);
                    exit += "****end****";
                }

                return exit;
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                dataBaseConnectionManager.closeConnection();
            }
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchPaddingException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvalidAlgorithmParameterException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvalidKeyException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (BadPaddingException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalBlockSizeException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "Chargement terminé";
    }
}
