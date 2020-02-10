/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.backend.mvc.model;

import com.google.gson.JsonObject;

/**
 *
 * @author WILFRIED
 */
public abstract class AbstractManager {

    protected JsonObject requestJsonObject = null;
    protected String tableName = null;
    protected JsonObject errorJsonObject;
    protected JsonObject exitJsonObject = new JsonObject();

    protected AbstractManager(JsonObject jsonObject) {
        this.requestJsonObject = jsonObject;
    }
}
