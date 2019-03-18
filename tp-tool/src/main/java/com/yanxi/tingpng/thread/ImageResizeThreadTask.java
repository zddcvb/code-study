package com.yanxi.tingpng.thread;

import org.apache.commons.io.FilenameUtils;
import org.apache.log4j.Logger;

public class ImageResizeThreadTask implements Runnable {
	private static Logger logger = Logger.getLogger("PngCompressThreadTask");

	private String path;
	private String[] keys;
	private String[] values;

	public ImageResizeThreadTask(String path, String[] keys, String[] values) {
		super();
		this.path = path;
		this.keys = keys;
		this.values = values;
	}

	@Override
	public void run() {
		String baseName = FilenameUtils.getBaseName(path);
		logger.info("----" + baseName + " resize start-------");
		ImageResizeTask.resizeFile(path, keys, values);
		logger.info("----" + baseName + " resize end-------");
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String[] getKeys() {
		return keys;
	}

	public void setKeys(String[] keys) {
		this.keys = keys;
	}

	public String[] getValues() {
		return values;
	}

	public void setValues(String[] values) {
		this.values = values;
	}

}
