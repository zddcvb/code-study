package com.yanxi.linux.utils;

import java.io.File;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URL;
import java.util.List;

import org.bouncycastle.asn1.crmf.PKIPublicationInfo;
import org.csource.fastdfs.ClientGlobal;
import org.csource.fastdfs.StorageClient1;
import org.csource.fastdfs.TrackerServer;
import org.junit.Test;

import junit.framework.TestCase;

public class FastdfsUtilsTest extends TestCase {
	@Test
	public void test() {
		String fileId = FastdfsUtils.uploadFile(new File("d:/XXX-行政考题2016-7-26.doc"));
		System.out.println(fileId);

	}

	@Test
	public void test_downLoad() {
		FastdfsUtils.downLoadFile("group1/M00/00/01/wKiRgVtbNbSAJbVVAAAMy53tGR4568.jpg", new File("f:/"));
	}

	@Test
	public void test_res() {
		FileUtils utils = new FileUtils();
		List<AnimRes> animRes = utils.getAnimRes(new File("d:/xls"));
		System.out.println(animRes);
	}

	@Test
	public void test_ip() {
		InetSocketAddress[] tracker_servers = new InetSocketAddress[1];
		tracker_servers[0] = new InetSocketAddress("172.16.2.128", 22122);
		System.out.println(tracker_servers[0]);
	}

	@Test
	public void test_fdfs() throws IOException {
		@SuppressWarnings("resource")
		Socket sock = new Socket();
		sock.setReuseAddress(true);
		sock.setSoTimeout(ClientGlobal.g_network_timeout);
		sock.connect(new InetSocketAddress("192.168.145.128", 22122), ClientGlobal.g_connect_timeout);
		TrackerServer trackerServer = new TrackerServer(sock, new InetSocketAddress("192.168.145.128", 22122));
		System.out.println(trackerServer.getSocket().getInetAddress().getHostName());
		
	}
}
