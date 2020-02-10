/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.networktreatment.encodingmanagement;

import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author WILFRIED
 */
public class EncodingManagement implements IEncodingManagement{

    @Override
    public String encode(String message) {
        try {
            return Base64.getEncoder().encodeToString(message.getBytes("UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(EncodingManagement.class.getName()).log(Level.SEVERE, null, ex);

            return "";
        }
    }

    @Override
    public String decode(String message) {
        try {
            byte[] byteArray = (new String(message.getBytes("UTF-8"), "UTF-8")).getBytes("UTF-8");
            message = new String(Base64.getDecoder().decode(byteArray), "UTF-8");
        } catch (Exception ex) {
            Logger.getLogger(EncodingManagement.class.getName()).log(Level.SEVERE, null, ex);
            message = "";
        }
        return message;
    }
}
