package com.jollyclass.netty.main;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

/**
 * 时间 实现的协议是 TIME 协议
 */
public class TimeServerHandler extends ChannelInboundHandlerAdapter {

	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {

		// 出现异常关闭连接
		cause.printStackTrace();
		ctx.close();
	}

	@Override
	public void channelActive(final ChannelHandlerContext ctx) throws Exception {
		ByteBuf buffer = ctx.alloc().buffer(4);
		buffer.writeInt((int) (System.currentTimeMillis() / 1000L + 2208988800L));
		final ChannelFuture future = ctx.writeAndFlush(buffer);
		future.addListener(new ChannelFutureListener() {

			@Override
			public void operationComplete(ChannelFuture f) throws Exception {
				assert future == f;
				ctx.close();
			}
		});
	}

}
