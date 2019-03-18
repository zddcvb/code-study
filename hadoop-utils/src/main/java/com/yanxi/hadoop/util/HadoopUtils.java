package com.yanxi.hadoop.util;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.io.IOUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.LocatedFileStatus;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.RemoteIterator;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.hdfs.DistributedFileSystem;
import org.junit.Before;
import org.junit.Test;

public class HadoopUtils {
	private static String hdfsUrl = "hdfs://192.168.145.130:9000";
	private static DistributedFileSystem fs = null;
	/**
	 * 初始化系统
	 */
	@Before
	public void initFileSystem() {
		try {
			System.out.println("hadoop 系统初始化开始");
			System.setProperty("HADOOP_USER_NAME", "root");
			System.setProperty("HADOOP_HOME", "/usr/local/hadoop3");
			fs = new DistributedFileSystem();
			Configuration configuration = new Configuration();
			configuration.set("fs.default.name", "hdfs://192.168.145.130:8020");
			fs.initialize(new URI(hdfsUrl), configuration);
			System.out.println("hdfs连接成功");
			Path workingDirectory = fs.getWorkingDirectory();
			System.out.println(workingDirectory.getName());
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 创建目录
	 */
	@Test
	public void mkdirFile() {
		try {
			boolean mkdirs = fs.mkdirs(new Path("/test/demoFile"));
			System.out.println("mkdirs:" + mkdirs);
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 删除文件
	 */
	@Test
	public void deleteFile() {
		try {
			boolean deleteOnExit = fs.deleteOnExit(new Path("/test/demoFile"));
			System.out.println("deleteOnExit:" + deleteOnExit);
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 获得文件信息
	 */
	@Test
	public void getFileList() {
		try {
			RemoteIterator<LocatedFileStatus> listFiles = fs.listFiles(new Path("/"), true);
			System.out.println(listFiles.hasNext());
			System.out.println();
			while (listFiles.hasNext()) {
				LocatedFileStatus fileStatus = listFiles.next();
				long accessTime = fileStatus.getAccessTime();
				long blockSize = fileStatus.getBlockSize();
				String group = fileStatus.getGroup();
				long len = fileStatus.getLen();
				long modificationTime = fileStatus.getModificationTime();
				String owner = fileStatus.getOwner();
				Path path = fileStatus.getPath();
				FsPermission permission = fileStatus.getPermission();
				short replication = fileStatus.getReplication();
				Path symlink = fileStatus.getSymlink();
				System.out.println("accessTime:" + accessTime + "/nblockSize:" + blockSize + "/ngroup:" + group
						+ "/nlen" + len + "/nmodificationTime:"
						+ new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(modificationTime)) + "/nowner:"
						+ owner + "/npath:" + path.getName() + "/nreplication:" + replication + "/nsymlink:"
						+ symlink.getName());
			}
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 上传文件
	 */
	@Test
	public void uploadfile() {
		try {
			FileInputStream inputStream = new FileInputStream("d:/client.conf");
			FSDataOutputStream out = fs.create(new Path("/test/demoFile/client.conf"), true);
			IOUtils.copy(inputStream, out);
			System.out.println("上传成功");
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 通过ioutil的工具类下载
	 */
	@Test
	public void downloadFile() {
		FSDataInputStream input;
		try {
			input = fs.open(new Path("/test/demoFile/client.conf"));
			FileOutputStream output = new FileOutputStream("f:/client.conf");
			IOUtils.copy(input, output);
			System.out.println("下载成功");
		} catch (IllegalArgumentException | IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 下载到本地系统
	 */
	@Test
	public void downLoadFileFromLocal() {
		try {
			Path dst = new Path("/usr/client.conf");
			Path src = new Path("/test/demoFile/client.conf");
			fs.copyToLocalFile(src, dst);
			System.out.println("下载成功");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
