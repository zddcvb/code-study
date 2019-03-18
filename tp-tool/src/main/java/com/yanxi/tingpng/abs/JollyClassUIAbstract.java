package com.yanxi.tingpng.abs;

import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionListener;

import javax.swing.JFrame;

public abstract class JollyClassUIAbstract extends JFrame implements ActionListener{
	private static final long serialVersionUID = -646453877795567248L;
	public abstract void initUI();
	public abstract void initButton();
	public abstract void onStart();
	public abstract void onStop();
	public abstract void onPause();
	
	public void setWindowsWidthAndHeight(){
		int windowWidth = this.getWidth(); // 获得窗口宽
		int windowHeight = this.getHeight(); // 获得窗口高
		Toolkit kit = Toolkit.getDefaultToolkit(); // 定义工具包
		Dimension screenSize = kit.getScreenSize(); // 获取屏幕的尺寸
		int screenWidth = screenSize.width; // 获取屏幕的宽
		int screenHeight = screenSize.height; // 获取屏幕的高
		this.setLocation(screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2);// 设置窗口居中显示
	}
	
	
}
