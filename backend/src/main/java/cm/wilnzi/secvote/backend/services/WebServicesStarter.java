/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cm.wilnzi.secvote.backend.services;

import org.glassfish.jersey.server.ResourceConfig;

/**
 *
 * @author WILFRIED
 */
public class WebServicesStarter extends ResourceConfig {

    public WebServicesStarter() {
        System.setProperty("file.encoding", "UTF-8");
        System.out.println("Démarrage services webs");
        packages(new String[]{"cm.wilnzi.secvote.backend.services.core"});
    }

     
}
