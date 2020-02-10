/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.networktreatment;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.core.Response;

/**
 *
 * @author WILFRIED
 */
public class ResponseElement {

    public static Response createResponse(JsonElement output, boolean status) {
        JsonObject jsonObject = new JsonObject();
        if (output == null) {
            status = true;
        }
        jsonObject.addProperty("error", "" + status);
        jsonObject.add("value", output);
        String message = jsonObject.toString();
        System.out.println(" ResponseElement.createResponse() " + message);

        try {
            message = new String(Base64.getEncoder().encode(message.getBytes("UTF-8")));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ResponseElement.class.getName()).log(Level.SEVERE, null, ex);
            jsonObject.addProperty("error", "true");
            jsonObject.addProperty("value", "");
            message = jsonObject.toString();
        }
        return Response.status(200)
                .entity(message)
                .header("Content-Type", "text/plain; charset=UTF-8")
                .build();
    }
}
