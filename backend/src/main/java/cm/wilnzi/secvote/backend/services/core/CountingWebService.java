/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.backend.services.core;

import cm.wilnzi.networktreatment.ResponseElement;
import cm.wilnzi.secvote.backend.management.counting.CountingManagement;
import com.google.gson.JsonElement;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

/**
 *
 * @author WILFRIED
 */

@Path("/counting")
public class CountingWebService extends AbstractWebService {
    
  @POST
  @Path("/launch")
  @Consumes({"application/json"})
  @Produces({"application/json;charset=utf-8"})
  public Response search(String message) { 
    if ((message = this.validator.validate(message)) != null && this.validator.authentication(message)) {
      try {
//        this.validator.log("POST", "/datatable/search", message);
        this.requestJsonObject = this.parser.parse(message).getAsJsonObject();
//        this.output = this.controller.search(this.jsonObject);
        this.responseJsonObject = new CountingManagement(requestJsonObject).launch();
        this.status = false;
      } catch (Exception e) {
        e.printStackTrace();
      } 
    }
    
    return ResponseElement.createResponse((JsonElement)this.responseJsonObject, this.status.booleanValue());
  }
    
}
