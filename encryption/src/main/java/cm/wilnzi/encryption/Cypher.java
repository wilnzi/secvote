/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.encryption;

import org.apache.commons.codec.binary.Base64;
 
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
 
public class Cypher{
 
    private static final String SECRET_KEY_1 = "ssdkF$HUy2A#D%kd";
    private static final String SECRET_KEY_2 = Hash.sha256("012345678901234567890123sdlsdlopspqsoqsoqssssssssssskskskdsl;c;xcxoqqsmqmsqosdmqsoqsqsqpsqsoqso45678231");
 
    private IvParameterSpec ivParameterSpec;
    private SecretKeySpec secretKeySpec;
    private Cipher cipher;
 
    public Cypher() throws UnsupportedEncodingException, NoSuchPaddingException, NoSuchAlgorithmException {
        ivParameterSpec = new IvParameterSpec(SECRET_KEY_1.getBytes("UTF-8"));
//        secretKeySpec = new SecretKeySpec(SECRET_KEY_2.getBytes("UTF-8"), "AES");
        secretKeySpec = new SecretKeySpec(Hash.sha256Byte("012345678901234567890123sdlsdlopspqsoqsoqssssssssssskskskdsl;c;xcxoqqsmqmsqosdmqsoqsqsqpsqsoqso45678231"), "AES");
 
        cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
    }
    
    public Cypher(String password){
       
        try {
             ivParameterSpec = new IvParameterSpec(SECRET_KEY_1.getBytes("UTF-8"));
//        secretKeySpec = new SecretKeySpec(SECRET_KEY_2.getBytes("UTF-8"), "AES");
        secretKeySpec = new SecretKeySpec(Hash.sha256Byte(password), "AES");
 
            cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Cypher.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchPaddingException ex) {
            Logger.getLogger(Cypher.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(Cypher.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
 
 
    /**
     * Encrypt the string with this internal algorithm.
     *
     * @param toBeEncrypt string object to be encrypt.
     * @return returns encrypted string.
     * @throws NoSuchPaddingException
     * @throws NoSuchAlgorithmException
     * @throws InvalidAlgorithmParameterException
     * @throws InvalidKeyException
     * @throws BadPaddingException
     * @throws IllegalBlockSizeException
     */
    public String encrypt(String toBeEncrypt) throws NoSuchPaddingException, NoSuchAlgorithmException,
            InvalidAlgorithmParameterException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
        byte[] encrypted = cipher.doFinal(toBeEncrypt.getBytes());
        return Base64.encodeBase64String(encrypted);
    }
 
    /**
     * Decrypt this string with the internal algorithm. The passed argument should be encrypted using
     * {@link #encrypt(String) encrypt} method of this class.
     *
     * @param encrypted encrypted string that was encrypted using {@link #encrypt(String) encrypt} method.
     * @return decrypted string.
     * @throws InvalidAlgorithmParameterException
     * @throws InvalidKeyException
     * @throws BadPaddingException
     * @throws IllegalBlockSizeException
     */
    public String decrypt(String encrypted) throws InvalidAlgorithmParameterException, InvalidKeyException,
            BadPaddingException, IllegalBlockSizeException {
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec);
        byte[] decryptedBytes = cipher.doFinal(Base64.decodeBase64(encrypted));
        return new String(decryptedBytes);
    }
}
