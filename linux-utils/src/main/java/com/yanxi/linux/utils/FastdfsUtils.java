package com.yanxi.linux.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import org.apache.commons.io.IOUtils;
import org.csource.common.MyException;
import org.csource.common.NameValuePair;
import org.csource.fastdfs.ClientGlobal;
import org.csource.fastdfs.StorageClient1;
import org.csource.fastdfs.StorageServer;
import org.csource.fastdfs.TrackerClient;
import org.csource.fastdfs.TrackerServer;

public class FastdfsUtils {
	private static String config = "client.conf";

	public static StorageClient1 getStorageClient() {
		URL url = FastdfsUtils.class.getClassLoader().getResource(config);
		String conf = url.toString();
		conf=conf.substring(conf.indexOf("/")+1);
		System.out.println(conf);
		StorageClient1 storageClient1 = null;
		try {
			ClientGlobal.init(conf);
			TrackerClient trackerClient = new TrackerClient();
			TrackerServer trackerServer = trackerClient.getConnection();
			StorageServer storageServer = trackerClient.getStoreStorage(trackerServer);
			storageClient1 = new StorageClient1(trackerServer, storageServer);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (MyException e) {
			e.printStackTrace();
		}
		return storageClient1;
	}
	/**
	 * 下载文件，传递数据
	 * @param file
	 * @return
	 */
	public static  String uploadFile(File file) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("fileName", file.getName());
		map.put("fileSize", file.getFreeSpace() + "");
		map.put("fileModifyTime", file.lastModified() + "");
		map.put("fileParentName", file.getParentFile().getName());
		System.out.println(map);
		return uploadFile(file, map);
	}

	/**
	 * 上传文件，获取上传文件的id
	 * 
	 * @param file
	 * @return
	 */
	public static String uploadFile(File file, Map<String, String> map) {
		StorageClient1 storageClient = getStorageClient();
		byte[] file_buff;
		String file_ext_name = "doc";
		try {
			file_buff = IOUtils.toByteArray(new FileInputStream(file));
			NameValuePair[] meta_list = new NameValuePair[map.size()];
			Iterator<Entry<String, String>> iterator = map.entrySet().iterator();
			int i = 0;
			while (iterator.hasNext()) {
				Entry<String, String> next = iterator.next();
				NameValuePair nameValuePair = new NameValuePair();
				nameValuePair.setName(next.getKey());
				nameValuePair.setValue(next.getValue());
				meta_list[i] = nameValuePair;
				i++;
			}
			System.out.println(meta_list.length);
			String fileId = storageClient.upload_file1(file_buff, file_ext_name, meta_list);
			return fileId;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (MyException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 下载文件，根据fileId
	 * 
	 * @param fileId
	 * @return
	 */
	public static  void downLoadFile(String fileId, File baseFile) {
		StorageClient1 storageClient = getStorageClient();
		String local_filename = null;
		try {
			byte[] buffer = storageClient.download_file1(fileId);
			NameValuePair[] nameValuePairs = storageClient.get_metadata1(fileId);
			for (NameValuePair nameValuePair : nameValuePairs) {
				String name = nameValuePair.getName();
				if ("fileName".equals(name)) {
					local_filename = nameValuePair.getValue();
					break;
				}
			}
			IOUtils.write(buffer, new FileOutputStream(new File(baseFile, "/" + local_filename)));
		} catch (IOException e) {
			e.printStackTrace();
		} catch (MyException e) {
			e.printStackTrace();
		}
	}
}
