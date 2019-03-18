package com.yanxi.code.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import org.junit.Test;
import org.mozilla.universalchardet.UniversalDetector;
import info.monitorenter.cpdetector.io.ASCIIDetector;
import info.monitorenter.cpdetector.io.CodepageDetectorProxy;
import info.monitorenter.cpdetector.io.JChardetFacade;
import info.monitorenter.cpdetector.io.ParsingDetector;
import info.monitorenter.cpdetector.io.UnicodeDetector;

public class FileEncode {
	public static String getFileEncode(File file) throws IOException {
		BufferedInputStream bin = new BufferedInputStream(new FileInputStream(file));
		int p = (bin.read() << 8) + bin.read();
		bin.close();
		String code = null;

		switch (p) {
		case 0xefbb:
			code = "UTF-8";
			break;
		case 0xfffe:
			code = "Unicode";
			break;
		case 0xfeff:
			code = "UTF-16BE";
			break;
		default:
			code = "GBK";
		}
		return code;
	}

	public static String getFileEncodeByCpd(String filePath) {
		CodepageDetectorProxy detector = CodepageDetectorProxy.getInstance();
		/*
		 * ParsingDetector可用于检查HTML、XML等文件或字符流的编码,
		 * 构造方法中的参数用于指示是否显示探测过程的详细信息，为false不显示。
		 */
		detector.add(new ParsingDetector(false));
		/*
		 * JChardetFacade封装了由Mozilla组织提供的JChardet，它可以完成大多数文件的编码测定。
		 * 所以，一般有了这个探测器就可满足大多数项目的要求，如果你还不放心，可以再多加几个探测器，
		 * 比如下面的ASCIIDetector、UnicodeDetector等。
		 */
		detector.add(JChardetFacade.getInstance());
		detector.add(ASCIIDetector.getInstance());
		detector.add(UnicodeDetector.getInstance());
		Charset charset = null;
		// File file = new File(filePath);
		try {
			// charset = detector.detectCodepage(file.toURI().toURL());
			InputStream is = new BufferedInputStream(new FileInputStream(filePath));
			charset = detector.detectCodepage(is, 8);
		} catch (Exception e) {
			e.printStackTrace();
			// throw e;
		}

		String charsetName = "GBK";
		if (charset != null) {
			if (charset.name().equals("US-ASCII")) {
				charsetName = "ISO_8859_1";
			} else if (charset.name().startsWith("UTF")) {
				charsetName = charset.name();// 例如:UTF-8,UTF-16BE.
			}
		}
		return charsetName;
	}

	public static void getFilesCode(File file) throws IOException {

		if (file.isDirectory()) {
			if (file.exists()) {
				File[] listFiles = file.listFiles();
				for (File targeFile : listFiles) {
					String path = targeFile.getAbsolutePath();
					if (targeFile.isFile()) {
						// if (path.endsWith(".zip")) {
						String fileEncode = getFileCodeByUniversa(targeFile);
						System.out.println(targeFile.getName() + "::" + fileEncode);
						// }
					} else {
						getFilesCode(targeFile);
					}
				}
			}
		}
	}

	@SuppressWarnings("resource")
	public static String getFileCodeByUniversa(File file) throws IOException {
		UniversalDetector detector = new UniversalDetector(null);
		InputStream is = new FileInputStream(file);
		byte[] buffer = new byte[1024];
		int len = 0;
		while ((len = is.read(buffer)) != -1 && !detector.isDone()) {
			detector.handleData(buffer, 0, len);
		}
		detector.dataEnd();
		String charset = detector.getDetectedCharset();
		return charset;
	}

	@SuppressWarnings("resource")
	public static String getFileCodeByCommonsIo(File file) throws IOException {

		return null;
	}

	@Test
	public void test_code() throws IOException {
		// String fileEncode = FileEncode.getFileEncode(new
		// File("G:\\内网通缓存\\李勇\\给设计的文件(1)\\整合课程小中大上动画评估文件2018-09-25.rar"));
		// System.out.println(fileEncode);
		FileEncode.getFilesCode(new File("d:/1"));
	}
}
