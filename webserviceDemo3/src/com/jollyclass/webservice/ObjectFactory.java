
package com.jollyclass.webservice;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.jollyclass.webservice package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _GetWebServiceResponse_QNAME = new QName("http://webservice.jollyclass.com/", "getWebServiceResponse");
    private final static QName _GetWebService_QNAME = new QName("http://webservice.jollyclass.com/", "getWebService");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.jollyclass.webservice
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link GetWebService }
     * 
     */
    public GetWebService createGetWebService() {
        return new GetWebService();
    }

    /**
     * Create an instance of {@link GetWebServiceResponse }
     * 
     */
    public GetWebServiceResponse createGetWebServiceResponse() {
        return new GetWebServiceResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link GetWebServiceResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://webservice.jollyclass.com/", name = "getWebServiceResponse")
    public JAXBElement<GetWebServiceResponse> createGetWebServiceResponse(GetWebServiceResponse value) {
        return new JAXBElement<GetWebServiceResponse>(_GetWebServiceResponse_QNAME, GetWebServiceResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link GetWebService }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://webservice.jollyclass.com/", name = "getWebService")
    public JAXBElement<GetWebService> createGetWebService(GetWebService value) {
        return new JAXBElement<GetWebService>(_GetWebService_QNAME, GetWebService.class, null, value);
    }

}
