package com.yanxi.util;

import java.io.File;

import org.junit.Test;

public class FileReadOnly {
	public static  void readOnly(File file){
		if (file.exists()) {
			file.setReadOnly();
		}
	}
	@Test
	public void test(){
		FileReadOnly.readOnly(new File("H:\\swf_弟子规第1则"));
	}
}
