/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.backend.services.core;

import cm.wilnzi.networktreatment.encodingmanagement.EncodingManagement; 
import cm.wilnzi.networktreatment.fabricator.Fabricator;
import cm.wilnzi.networktreatment.validator.IValidator;
import com.google.gson.JsonObject; 
import com.google.gson.JsonParser;

/**
 *
 * @author WILFRIED
 */
public abstract class AbstractWebService {
    
  protected Boolean status = true;
  protected JsonObject responseJsonObject = new JsonObject();
  protected JsonObject requestJsonObject  = new JsonObject();  
  protected IValidator validator = Fabricator.getValidator();
  protected EncodingManagement encodingManagement = Fabricator.getEncodingManagement();
  protected JsonParser parser  = new JsonParser(); 
  
   
    
}
