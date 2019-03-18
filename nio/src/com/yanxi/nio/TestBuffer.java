package com.yanxi.nio;

import java.nio.ByteBuffer;

import org.junit.Test;

public class TestBuffer {
	/**
	 * 創建缓冲，两种方式 allocateDirect：直接缓冲区：保存到os系统物理内存中，速度快，高效，但有时出现内存爆满
	 * allocate：非直接缓冲区，保存到jvm的内存中
	 */
	@Test
	public void test_buffer_1() {
		ByteBuffer allocateDirect = ByteBuffer.allocateDirect(1024);
		System.out.println(allocateDirect.capacity());
		System.out.println(allocateDirect.limit());
		System.out.println(allocateDirect.position());
		System.out.println(allocateDirect.mark());
		System.out.println(allocateDirect.hasRemaining());
		System.out.println(allocateDirect.remaining());
		ByteBuffer allocate = ByteBuffer.allocate(1024);
		System.out.println(allocate.capacity());
		System.out.println(allocate.limit());
		System.out.println(allocate.position());
		System.out.println(allocate.mark());
		System.out.println(allocate.hasRemaining());
		System.out.println(allocate.remaining());
	}
	/**
	 * 存放和取出数据
	 * get：取出，每次只能取一個
	 * put：存放数据
	 * hasRemaining：判断缓冲是否还有数据
	 * 
	 */
	@Test
	public void test_buffer_2() {
		String string = "123456789";
		ByteBuffer allocateDirect = ByteBuffer.allocateDirect(1024);
		allocateDirect.put(string.getBytes());
		allocateDirect.flip();
		int i = 0;
		while (allocateDirect.hasRemaining()) {
			byte b = allocateDirect.get(i);
			byte[] bts = { b };
			System.out.println(new String(bts));
			i++;
		}
	}
}
