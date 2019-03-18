package com.yanxi.tingpng.tool;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.log4j.Logger;

import com.tinify.Options;
import com.tinify.Source;
import com.tinify.Tinify;

public class TPTool {
	private static Logger logger = Logger.getLogger("TPTool");
	private static  String[] types={"png","jpg","gif"};
	public static void init(String key) {
		Tinify.setKey(key);
	}

	/**
	 * 压缩图片
	 * 
	 * @param path
	 */
	public static void compress(String path) {
		logger.info("--------------compress start------------------");
		File file = new File(path);
		if (file.isFile()) {
			compressFile(path);
		} else {
			File[] listFiles = file.listFiles();
			for (final File listFile : listFiles) {
				if (listFile.isFile()) {
					String type=FilenameUtils.getExtension(listFile.getName());
					if (ArrayUtils.contains(types,type)) {
						new Thread() {

							@Override
							public void run() {
								logger.info("thread " + Thread.currentThread().getId() + "  " + listFile.getName()
										+ " start compress------");
								compressFile(listFile.getAbsolutePath());
								logger.info("thread " + Thread.currentThread().getId() + "  " + listFile.getName()
										+ " end compress------");
							}

						}.start();
					}

				} else {
					compress(listFile.getAbsolutePath());
				}
			}
			logger.info("success");
		}
	}

	private static void compressFile(String path) {
		try {
			Source source = Tinify.fromFile(path);
			String replaceStr = path.charAt(path.lastIndexOf(".")) + "";
			String newFile = path.replace(replaceStr, "_p.");
			source.toFile(newFile);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 缩放图片
	 * 
	 * @param path
	 * @param keys
	 * @param values
	 */
	public static void resize(String path, final String[] keys, final String[] values) {
		logger.info("--------------compress start------------------");
		File file = new File(path);
		if (file.isFile()) {
			resizeFile(path, keys, values);
		} else {
			File[] listFiles = file.listFiles();
			for (final File listFile : listFiles) {
				if (listFile.isFile()) {
					new Thread() {
						@Override
						public void run() {
							logger.info("thread " + Thread.currentThread().getId() + " start compress------");
							resizeFile(listFile.getAbsolutePath(), keys, values);
							logger.info("thread " + Thread.currentThread().getId() + " end compress------");
						}
					}.start();
				} else {
					compress(listFile.getAbsolutePath());
				}
			}

		}
	}

	private static void resizeFile(String path, String[] keys, String[] values) {
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
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
