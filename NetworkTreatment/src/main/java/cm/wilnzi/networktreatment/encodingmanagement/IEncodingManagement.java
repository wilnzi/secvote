/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.networktreatment.encodingmanagement;

/**
 *
 * @author WILFRIED
 */
public interface IEncodingManagement {
    
    String encode(String message);
    String decode(String message);
}
