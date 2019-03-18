package com.yanxi.tingpng.thread;

import java.io.IOException;

import org.apache.log4j.Logger;

import com.tinify.Source;
import com.tinify.Tinify;

public class ImageCompressTask {
	private static Logger logger = Logger.getLogger("PngCompressTask");

	public static void compressFile(String path) {
		try {
			Source source = Tinify.fromFile(path);
			String replaceStr = path.charAt(path.lastIndexOf(".")) + "";
			String newFile = path.replace(replaceStr, "_p.");
			logger.info(newFile);
			source.toFile(newFile);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
