package com.jollyclass.netty.main;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.util.CharsetUtil;
/**
 * 应答服务器 *
 */
public class EchoServerHandler extends ChannelInboundHandlerAdapter {
	/**
	 * ctx:通道上下文
	 * msg：接收到的信息
	 */
	@Override
	public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
		ByteBuf in =(ByteBuf) msg;
		System.out.print(in.toString(CharsetUtil.UTF_8));
		/**
		 * 将接受的信息写入
		 * write方法不会将信息写入通道中，而是会写入缓存中，所以需要flush方法输出，等同于writeAndFlush；
		 */
		ctx.write(msg);
		ctx.flush();
	}

	
	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
		/**
		 * exceptionCaught() 事件处理方法是当出现 Throwable 对象才会被调用，即当 Netty 由于 IO
		 * 错误或者处理器在处理事件时抛出的异常时。在大部分情况下，捕获的异常应该被记录下来 并且把关联的 channel
		 * 给关闭掉。然而这个方法的处理方式会在遇到不同异常的情况下有不 同的实现，比如你可能想在关闭连接之前发送一个错误码的响应消息。
		 */
		// 出现异常关闭连接
		cause.printStackTrace();
		ctx.close();
	}

}
