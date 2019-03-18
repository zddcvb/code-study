package com.jollyclass.jmeter.main;

import java.io.File;
import java.io.PrintWriter;

public class OutputService {

	public static void output(String filename, int a, int b) throws Exception {
		PrintWriter out = new PrintWriter(new File(filename));
		out.write(a + ":" + b);
		out.close();
	}

}
