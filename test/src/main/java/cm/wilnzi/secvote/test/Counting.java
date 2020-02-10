/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.test;

import cm.wilnzi.database.DataBaseConnectionManager;
import cm.wilnzi.encryption.Cypher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.validation.constraints.NotNull;

/**
 *
 * @author WILFRIED
 */
public class Counting {

    private final HashMap<Integer, String> systemKeys;
    private static final int SYSTEMS_KEYS_NUMBER = 6;

    public Counting(@NotNull HashMap<Integer, String> keys) {
        systemKeys = keys;
    }

    public static HashMap<Integer, String> initiateSystemKeys() {
        HashMap<Integer, String> hashMap = new HashMap();
        hashMap.put(1, "cle1juge4cle2juge6");
        hashMap.put(2, "cle2juge4cle1juge5");
        hashMap.put(3, "cle1juge5cle1juge6");
        hashMap.put(4, "cle1juge1cle2juge3");
        hashMap.put(5, "cle2juge1cle1juge2");
        hashMap.put(6, "cle1juge2cle1juge3");
        return hashMap;
    }

    public boolean count() throws Exception {
        if (systemKeys == null || systemKeys.size() != SYSTEMS_KEYS_NUMBER) {
            throw new Exception("Clés de système non conforme");
        }
        boolean exitStatus = false;

        // Lecture des informations dans la vue v_decompte
        DataBaseConnectionManager dataBaseConnectionManager = new DataBaseConnectionManager();
        Connection connection = dataBaseConnectionManager.openConnection();

        try {
            // Chargement des informations dans la decompte
            String query = "CALL loadCountingTable();";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                if (resultSet.getInt("elementNumber") % SYSTEMS_KEYS_NUMBER != 0) {
                    throw new Exception("Erreur lors de la mise à jour de la table décompte ");
                }
//                if(resultSet.getInt("elementNumber") % SYSTEMS_KEYS_NUMBER != 0) throw new Exception("Mise à jour de la table décompte échouée");
                System.out.println("Mise à jour de la table décompte effectuée avec succès");
            }

            query = "SELECT * FROM v_decompte;";
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            Cypher cypher;
            StringBuilder stringBuilder = new StringBuilder();
            String secondaryQuery;
            while (resultSet.next()) {
                cypher = new Cypher(systemKeys.get(resultSet.getInt("ordre_cle")));
                secondaryQuery = "UPDATE t_decompte SET valeur_dechiffree = '@1@' WHERE id = @2@ LIMIT 1;";
                secondaryQuery = secondaryQuery.replace("@1@", cypher.decrypt(resultSet.getString("valeur_chiffree")));
                secondaryQuery = secondaryQuery.replace("@2@", "" + resultSet.getInt("id"));
                stringBuilder.append(secondaryQuery);
            }

//            System.out.println("updateQuery " + stringBuilder.toString());
            dataBaseConnectionManager.closeConnection();

            // Mise à jour des données de la table décompte 
            connection = dataBaseConnectionManager.openConnection(true);
            preparedStatement = connection.prepareStatement(stringBuilder.toString());
//            long executeValue = preparedStatement.executeLargeUpdate();
            preparedStatement.executeLargeUpdate();
            connection.commit();
            dataBaseConnectionManager.closeConnection();

            // Vérification des données déchiffrées
            connection = dataBaseConnectionManager.openConnection();
            query = "SELECT code_electeur, empreinte FROM vote ; ";
            preparedStatement = connection.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();
            String candidate;
            stringBuilder = new StringBuilder();
            while (resultSet.next()) {
                candidate = verifyVotingData(resultSet.getString("empreinte"));
                if (candidate == null) {
                    continue;
                }

                secondaryQuery = "INSERT INTO t_decompte_simplifie (code_electeur, valeur_dechiffree) VALUE ('@1@', '@2@'); ";
                secondaryQuery = secondaryQuery.replace("@1@", resultSet.getString("code_electeur"));
                secondaryQuery = secondaryQuery.replace("@2@", candidate);
                stringBuilder.append(secondaryQuery);
            }
            dataBaseConnectionManager.closeConnection();

            // Insertion dans la table t_decompte_simplifie
            connection = dataBaseConnectionManager.openConnection(true);
            preparedStatement = connection.prepareStatement(stringBuilder.toString());
            preparedStatement.executeLargeUpdate();
            connection.commit();
            dataBaseConnectionManager.closeConnection();

            // Insertion dans la table t_decompte_final
            exitStatus = finalCountingInsertion();
            if (exitStatus) {
                System.out.println("Mise à jour terminée");
            }

        } catch (Exception e) {
            Logger.getLogger(Counting.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            dataBaseConnectionManager.closeConnection();
        }

        return exitStatus;
    }

    private String verifyVotingData(String fingerPrint) {
        DataBaseConnectionManager dataBaseConnectionManager = new DataBaseConnectionManager();
        Connection connection = dataBaseConnectionManager.openConnection();
        String query;
        String candidate = null;
        try {

            query = "SELECT DISTINCT valeur_dechiffree FROM t_decompte WHERE empreinte = ? ";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, fingerPrint);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (!resultSet.last() || resultSet.getRow() != 1) {
                query = "UPDATE t_decompte SET etat = 0, dmaj = NOW() WHERE empreinte = ? ";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, fingerPrint);
                preparedStatement.executeUpdate();
            } else {
                candidate = resultSet.getString("valeur_dechiffree");

            }

        } catch (SQLException e) {
            Logger.getLogger(Counting.class
                    .getName()).log(Level.SEVERE, null, e);
        } finally {
            dataBaseConnectionManager.closeConnection();
        }
        return candidate;
    }

    private String insertIntoFinalCountingTable(@NotNull
            final String electorCode, @NotNull
            final String candidate) {
        String insertQuery = "INSERT INTO t_decompte_final (code_electeur, candidat) VALUES ('@1@','@2@'); ";
        insertQuery = insertQuery.replace("@1@", electorCode);
        insertQuery = insertQuery.replace("@2@", candidate);
        return insertQuery;
    }

    private boolean finalCountingInsertion() {
        DataBaseConnectionManager dataBaseConnectionManager = new DataBaseConnectionManager();
        boolean exitStatus = false;
        try {
            // Insertion dans la table t_decompte_final
            Connection connection = dataBaseConnectionManager.openConnection();
            String query = "SELECT * FROM v_decompte_simplifie ; ";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();
            StringBuilder stringBuilder = new StringBuilder();

            HashMap<String, Integer> finalCountingHashMap = new HashMap();
            HashMap<String, String> singleCountingHashMap = new HashMap();

            while (resultSet.next()) {
                if (finalCountingHashMap.containsKey(resultSet.getString("code_electeur"))) { 
                    if (!finalCountingHashMap.get(resultSet.getString("code_electeur")).equals(resultSet.getInt("nombre_vote"))
                            && singleCountingHashMap.containsKey(resultSet.getString("code_electeur"))) {
                        stringBuilder.append(insertIntoFinalCountingTable(resultSet.getString("code_electeur"),
                                singleCountingHashMap.get(resultSet.getString("code_electeur"))));

                    }
                    singleCountingHashMap.remove(resultSet.getString("code_electeur"));
                } else {
                    singleCountingHashMap.put(resultSet.getString("code_electeur"), resultSet.getString("candidat"));
                    finalCountingHashMap.put(resultSet.getString("code_electeur"), resultSet.getInt("nombre_vote"));
                }
            }
            dataBaseConnectionManager.closeConnection();

            singleCountingHashMap.forEach((k, v) -> {
//                System.out.println("electeur " + k);
                stringBuilder.append(insertIntoFinalCountingTable(k, v));
            });

            // Insertion dans la table t_decompte_final
            
//            System.out.println("InsertQuery " + stringBuilder.toString());
            connection = dataBaseConnectionManager.openConnection(true);
            preparedStatement = connection.prepareStatement(stringBuilder.toString());
            preparedStatement.executeLargeUpdate();
            connection.commit();
            exitStatus = true;

        } catch (SQLException e) {
            Logger.getLogger(Counting.class
                    .getName()).log(Level.SEVERE, null, e);
        } finally {
            dataBaseConnectionManager.closeConnection();
        }
        return exitStatus;

    }
}
