package com.jollyclass.webservice;

import javax.jws.WebService;
import javax.xml.ws.Endpoint;

@WebService
public class WebServiceHandler {
	public static void main(String[] args) {
		Endpoint.publish("http://172.16.2.22:5567/WebService", new WebServiceHandler());
	}

	public String getWebService(String name) {
		System.out.println("getWebService");
		return "getWebService::" + name;

	}
}
