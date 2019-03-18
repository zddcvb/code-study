package com.yanxi.code.util;

import java.io.File;

import it.sauronsoftware.jave.Encoder;
import it.sauronsoftware.jave.EncoderException;
import it.sauronsoftware.jave.MultimediaInfo;

public class ReadUtils {
	public static void main(String[] args) {
		// getFileName();
		String path = "G:\\盒子4.0\\中文儿歌";
		File file = new File(path);
		createVideo(file);
	}

	@SuppressWarnings("unused")
	private static void getFileName() {
		String path = "E:\\小水滴课堂V3.0\\项目制作文件\\教学资源\\英文儿歌";
		File file = new File(path);
		File[] listFiles = file.listFiles();
		for (File listFile : listFiles) {
			System.out.println(listFile.getName());
		}
	}

	public static void createVideo(File file) {

		File[] listFiles = file.listFiles();
		for (File listFile : listFiles) {
			if (listFile.isFile()) {
				if (listFile.getName().endsWith(".mp4")) {
					getVideoTime(listFile.getAbsolutePath());
				} else {
					continue;
				}
			} else {
				createVideo(listFile);
			}
		}
	}

	public static void getVideoTime(String path) {
		// String path = "G:\\盒子4.0\\中文儿歌\\拔萝卜\\拔萝卜.mp4";
		File file = new File(path);
		Encoder encoder = new Encoder();
		try {
			MultimediaInfo info = encoder.getInfo(file);
			long duration = info.getDuration();
			long min = duration / 60000;
			long sencode = (duration % 60000) / 1000;
			String min_str = "";
			String second_str = "";
			if (min < 10) {
				min_str = "0" + min;
			} else {
				min_str = min + "";
			}
			if (sencode < 10) {
				second_str = "0" + sencode;
			} else {
				second_str = sencode + "";
			}
			String time = file.getName() + "---00:" + min_str + ":" + second_str;
			System.out.println(time);
		} catch (EncoderException e) {
			e.printStackTrace();
		}
	}
}
