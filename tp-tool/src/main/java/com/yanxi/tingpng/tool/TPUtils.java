package com.yanxi.tingpng.tool;

import java.io.File;
import java.util.concurrent.ThreadPoolExecutor;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.log4j.Logger;
import com.tinify.Tinify;
import com.yanxi.tingpng.thread.ImageCompressThreadPool;
import com.yanxi.tingpng.thread.ImageCompressThreadTask;
import com.yanxi.tingpng.thread.ImageResizeThreadTask;

public class TPUtils {
	private static Logger logger = Logger.getLogger("TPTool");
	private static String[] types = { "png", "jpg" };
	private static ThreadPoolExecutor executor;
	public static String MSG = "";

	public static void init(String key) {
		Tinify.setKey(key);
		executor = ImageCompressThreadPool.getThreadPoolExecutor();
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
			executeCompressFile(file);
		} else {
			File[] listFiles = file.listFiles();
			for (final File listFile : listFiles) {
				if (listFile.isFile()) {
					executeCompressFile(listFile);
				} else {
					compress(listFile.getAbsolutePath());
				}
			}
			// 判断线程池是否执行完毕。
			if (ImageCompressThreadPool.isEmpty()) {
				logger.info("success");
				MSG = "SUCCESS";
			}
		}

	}

	/**
	 * 执行图片压缩的线程池
	 * 
	 * @param listFile
	 */
	private static void executeCompressFile(File listFile) {
		String type = FilenameUtils.getExtension(listFile.getName());
		if (ArrayUtils.contains(types, type)) {
			executor.execute(new ImageCompressThreadTask(listFile.getAbsolutePath()));
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
			executeResizeFile(file, keys, values);
		} else {
			File[] listFiles = file.listFiles();
			for (final File listFile : listFiles) {
				if (listFile.isFile()) {
					executeResizeFile(listFile, keys, values);
				} else {
					compress(listFile.getAbsolutePath());
				}
			}

		}
	}

	/**
	 * 执行图片缩放的线程池
	 * 
	 * @param listFile
	 * @param keys
	 * @param values
	 */
	private static void executeResizeFile(File listFile, String[] keys, String[] values) {
		String type = FilenameUtils.getExtension(listFile.getName());
		if (ArrayUtils.contains(types, type)) {
			executor.execute(new ImageResizeThreadTask(listFile.getAbsolutePath(), keys, values));
		}
	}

	public static void clearCache() {
		if (MSG != null) {
			MSG = "";
		}
	}
}
