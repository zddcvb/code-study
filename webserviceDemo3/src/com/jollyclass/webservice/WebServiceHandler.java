
package com.jollyclass.webservice;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.ws.Action;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.4-b01
 * Generated source version: 2.2
 * 
 */
@WebService(name = "WebServiceHandler", targetNamespace = "http://webservice.jollyclass.com/")
@XmlSeeAlso({
    ObjectFactory.class
})
public interface WebServiceHandler {


    /**
     * 
     * @param arg0
     * @return
     *     returns java.lang.String
     */
    @WebMethod
    @WebResult(targetNamespace = "")
    @RequestWrapper(localName = "getWebService", targetNamespace = "http://webservice.jollyclass.com/", className = "com.jollyclass.webservice.GetWebService")
    @ResponseWrapper(localName = "getWebServiceResponse", targetNamespace = "http://webservice.jollyclass.com/", className = "com.jollyclass.webservice.GetWebServiceResponse")
    @Action(input = "http://webservice.jollyclass.com/WebServiceHandler/getWebServiceRequest", output = "http://webservice.jollyclass.com/WebServiceHandler/getWebServiceResponse")
    public String getWebService(
        @WebParam(name = "arg0", targetNamespace = "")
        String arg0);

}
