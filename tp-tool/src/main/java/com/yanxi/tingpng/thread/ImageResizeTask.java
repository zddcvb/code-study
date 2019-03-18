package com.yanxi.tingpng.thread;

import java.io.IOException;

import org.apache.log4j.Logger;

import com.tinify.Options;
import com.tinify.Source;
import com.tinify.Tinify;

public class ImageResizeTask {
	private static Logger logger = Logger.getLogger("ImageResizeTask");

	public static void resizeFile(String path, String[] keys, String[] values) {
		try {
			Source source = Tinify.fromFile(path);

			Options options = new Options();
			for (int i = 0; i < keys.length; i++) {
				options.with(keys[i], values[i]);
			}
			source.resize(options);
			String replaceStr = path.charAt(path.lastIndexOf(".")) + "";
			String newFile = path.replace(replaceStr, "_r.");
			source.toFile(newFile);
			logger.info("resize success");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
