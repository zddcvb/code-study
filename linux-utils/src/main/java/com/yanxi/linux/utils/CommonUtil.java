package com.yanxi.linux.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

public class CommonUtil {
	 /**
     * 读取文件创建时间
     */
    public static String getCreateTime(File file) {
         String strTime = null;
         if (file.exists()) {
             String path = file.getAbsolutePath();
             System.out.println(path);
             String endStr = path.substring(path.lastIndexOf("."));
             System.out.println(endStr);
             try {
                  Process p = Runtime.getRuntime().exec(
                            "cmd /C dir " + path + "/tc");
                  InputStream is = p.getInputStream();
                  BufferedReader br = new BufferedReader(
                            new InputStreamReader(is));
                  String line = null;
                  while ((line = br.readLine()) != null) {
                       if (line.endsWith(endStr)) {
                            strTime = line.substring(0, 17);
                            break;
                       }
                  }
             } catch (IOException e) {
                  e.printStackTrace();
             }
             System.out.println("创建时间    " + strTime);
             // 输出：创建时间 2009-08-17 10:21
         }
         return strTime;
    }
    /**
     * 格式化时间
     * @param time
     * @return
     */
    public static String formatTime(long time) {
         SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
         return format.format(time);
    }
	/**
	 * 格化式文件大小
	 * 
	 * @param size
	 *            文件大小，long类型
	 * @return 字符串类型的文件容量
	 */
	public static String getDataSize(long size) {
		DecimalFormat formater = new DecimalFormat("####.00");
		long kb = 1024;
		long mb = 1024 * 1024;
		long gb = 1024 * 1024 * 1024;
		long tb = (Long.valueOf(1024)) * (Long.valueOf(1024)) * (Long.valueOf(1024)) * (Long.valueOf(1024));
		if (size < kb) {
			return size + "bytes";
		} else if (size < mb) {
			float kbsize = size / 1024f;
			return formater.format(kbsize) + "KB";
		} else if (size < gb) {
			float mbsize = size / 1024f / 1024f;
			return formater.format(mbsize) + "MB";
		} else if (size < tb) {
			float gbsize = size / 1024f / 1024f / 1024f;
			System.out.println(formater.format(gbsize) + "GB");
			return formater.format(gbsize) + "GB";
		} else {
			return "size: error";
		}
	}
}
