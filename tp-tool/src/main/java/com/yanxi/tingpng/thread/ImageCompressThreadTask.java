package com.yanxi.tingpng.thread;

import org.apache.commons.io.FilenameUtils;
import org.apache.log4j.Logger;

public class ImageCompressThreadTask implements Runnable {
	private static Logger logger = Logger.getLogger("PngCompressThreadTask");

	private String path;

	public ImageCompressThreadTask(String path) {
		super();
		this.path = path;
	}

	@Override
	public void run() {
		String baseName = FilenameUtils.getBaseName(path);
		logger.info("----" + baseName + " compress start-------");
		ImageCompressTask.compressFile(path);
		logger.info("----" + baseName + " compress end-------");
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

}
