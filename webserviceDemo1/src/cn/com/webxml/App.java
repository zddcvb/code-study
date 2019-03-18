package cn.com.webxml;

public class App {
	public static void main(String[] args) {
		MobileCodeWS mobileCodeWS = new MobileCodeWS();
		MobileCodeWSSoap soap = mobileCodeWS.getMobileCodeWSSoap();
		String string = soap.getMobileCodeInfo("1597568246", null);
		System.out.println(string);
	}
}
