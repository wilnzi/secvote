/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.encryption;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.codec.digest.DigestUtils;

/**
 *
 * @author WILFRIED
 */
public class Hash {

    public static String sha256(String text) {
        try {
            return Encoding.bytesToHex(MessageDigest.getInstance("SHA-256").digest(text.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Hash.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    
    

    public static String sha384(String text) {
        try {
            return Encoding.bytesToHex(MessageDigest.getInstance("SHA-384").digest(text.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Hash.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    public static String sha512(String text) {
         try {
            return Encoding.bytesToHex(MessageDigest.getInstance("SHA-512").digest(text.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Hash.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    
    public static byte[] sha256Byte(String text) {
        try {
            return  MessageDigest.getInstance("SHA-256").digest(text.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Hash.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    public static byte[] sha384Byte(String text) {
        try {
            return  MessageDigest.getInstance("SHA-384").digest(text.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Hash.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    public static byte[] sha512Byte(String text) {
        try {
            return  MessageDigest.getInstance("SHA-512").digest(text.getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Hash.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    

}
