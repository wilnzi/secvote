/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.networktreatment.fabricator;

import cm.wilnzi.networktreatment.encodingmanagement.EncodingManagement;
import cm.wilnzi.networktreatment.validator.IValidator;
import cm.wilnzi.networktreatment.validator.Validator; 
/**
 *
 * @author WILFRIED
 */
public class Fabricator {
     
 
    public static EncodingManagement getEncodingManagement() {
        return new EncodingManagement();
    }

//    @Override
//    public Logger getLogger() {
//        return new Logger();
//    }
 
    public static IValidator getValidator() {
        return new Validator();
    }
}
