package com.jollyclass.webservice;

public class App {
	public static void main(String[] args) {
		WebServiceHandlerService service = new WebServiceHandlerService();
		WebServiceHandler handler = service.getWebServiceHandlerPort();
		String string = handler.getWebService("jollyclass");
		System.out.println(string);
	}
}
