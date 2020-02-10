/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.networktreatment.validator;

import cm.wilnzi.networktreatment.encodingmanagement.EncodingManagement;

/**
 *
 * @author WILFRIED
 */
public class Validator implements IValidator{

    @Override
    public String validate(String message) {
        try {
            message = (new EncodingManagement()).decode(message);
        } catch (Exception e) {
            e.printStackTrace();
            message = null;
        }
        return message;
    }

    @Override
    public boolean authentication(String message) {
        return true;
    }

}
