package com.yanxi.nio;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.SortedMap;

import org.junit.Test;

public class TestChannel {
	/**
	 * 通过getchannel方式进行文件的读写
	 * 特别注意缓冲的切换：读写切换
	 * @throws Exception
	 */
	@Test
	public void test_channel()throws Exception{
		FileInputStream fis=new FileInputStream("1.png");
		FileOutputStream fos=new FileOutputStream("2.png");
		
		FileChannel inChannel = fis.getChannel();
		FileChannel outChannel = fos.getChannel();
		ByteBuffer byteBuffer=ByteBuffer.allocate(1024);
		while(inChannel.read(byteBuffer)!=-1){
			byteBuffer.flip();
			outChannel.write(byteBuffer);
			byteBuffer.flip();
		}
		outChannel.close();
		inChannel.close();
		fos.close();
		fis.close();
	}
	/**
	 * 通过transferFrom、transferTo方法进行文件的读写
	 * @throws Exception
	 */
	@Test
	public void test_channel_2()throws Exception{
		FileChannel inChannel = FileChannel.open(Paths.get("1.png"), StandardOpenOption.READ);
		FileChannel outChannel = FileChannel.open(Paths.get("4.png"), StandardOpenOption.READ,StandardOpenOption.WRITE,StandardOpenOption.CREATE);
		//inChannel.transferTo(0, inChannel.size(), outChannel);
		outChannel.transferFrom(inChannel, 0, inChannel.size());
		inChannel.close();
		outChannel.close();
	}
	/**
	 * 通过mapped方式进行读写文件
	 * @throws Exception
	 */
	@Test
	public void test_channel_3()throws Exception{
		FileChannel inChannel = FileChannel.open(Paths.get("1.png"), StandardOpenOption.READ);
		FileChannel outChannel = FileChannel.open(Paths.get("5.png"), StandardOpenOption.READ,StandardOpenOption.WRITE,StandardOpenOption.CREATE);
		MappedByteBuffer inMappedByteBuffer = inChannel.map(MapMode.READ_ONLY, 0, inChannel.size());
		MappedByteBuffer outMappedByteBuffer = outChannel.map(MapMode.READ_WRITE, 0, inChannel.size());
		while(inMappedByteBuffer.hasRemaining()){
			outMappedByteBuffer.put(inMappedByteBuffer);
		}
		inChannel.close();
		outChannel.close();
	}
	/**
	 * 分散和聚集缓冲
	 * 分散：一个通道分成多个缓存区
	 * 聚集：将多个缓冲区聚合成一个通道
	 * @throws Exception
	 */
	@Test
	public void test_channel_4()throws Exception{
		FileChannel inChannel = FileChannel.open(Paths.get("1.png"), StandardOpenOption.READ);
		FileChannel outChannel = FileChannel.open(Paths.get("6.png"), StandardOpenOption.READ,StandardOpenOption.WRITE,StandardOpenOption.CREATE);
		ByteBuffer buffer_1=ByteBuffer.allocate(100);
		ByteBuffer buffer_2=ByteBuffer.allocate(1024);
		ByteBuffer[] buffers={buffer_1,buffer_2};
		while(inChannel.read(buffers)!=-1){
			for (ByteBuffer byteBuffer : buffers) {
				byteBuffer.flip();
			}
			outChannel.write(buffers);
			for (ByteBuffer byteBuffer : buffers) {
				byteBuffer.flip();
			}
		}
		inChannel.close();
		outChannel.close();
	}
	/**
	 * 获取系统所支持的字符编码
	 * @throws Exception
	 */
	@Test
	public  void test_channel_5()throws Exception{
		SortedMap<String,Charset> availableCharsets = Charset.availableCharsets();
		Iterator<Entry<String, Charset>> iterator = availableCharsets.entrySet().iterator();
		while(iterator.hasNext()){
			Entry<String, Charset> next = iterator.next();
			Charset value = next.getValue();
			System.out.println(value.toString());
		}
	}
	/**
	 * 字符的解码和编码
	 * @throws Exception
	 */
	@Test
	public void  test_channel_6()throws Exception{
		Charset gbk = Charset.forName("GBK");
		CharsetEncoder gbkEncoder = gbk.newEncoder();
		CharsetDecoder gbkDecoder = gbk.newDecoder();
		String string="呵呵";
		CharBuffer buffer = CharBuffer.allocate(1024);
		buffer.put(string);
		ByteBuffer encodeBuffer = gbkEncoder.encode(buffer);
		CharBuffer decode = gbkDecoder.decode(encodeBuffer);
		char c = decode.get();
		System.out.println(c+"");
	}
	
}
