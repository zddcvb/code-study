package com.yanxi.tingpng.ui;

import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.yanxi.tingpng.abs.JollyClassUIAbstract;
import com.yanxi.tingpng.tool.TPUtils;

public class JollyClassSysUI extends JollyClassUIAbstract implements ActionListener {
	private static Logger logger = Logger.getLogger("JollyClassSysUI");

	private static final long serialVersionUID = -6823992051044609428L;
	private JTextField file_path_tx, key_tx;
	private JButton file_select_btn;
	private JButton compress_file_btn;
	private String filePath;
	private File selectedFile;
	private static final String STEP_1 = "选择目标文件";
	private static final String STEP_2 = "压缩文件";

	/**
	 * 初始化frame窗口
	 */
	public void initUI() {
		this.setTitle("图片压缩工具   邹丹丹");
		this.setSize(400, 300);
		this.setLayout(new FlowLayout());
		setWindowsWidthAndHeight();
		this.setResizable(false);
		initButton();
		this.setVisible(true);
	}

	public void initButton() {
		// =============内容选择框================
		GridLayout gridLayout = new GridLayout(5, 5, 20, 20);
		JPanel content_panel = new JPanel(gridLayout);
		Font font = new Font("微软雅黑", 0, 16);
		file_path_tx = new JTextField("请输入图片地址", 15);
		file_path_tx.setFont(font);

		key_tx = new JTextField("请输入压缩的key值", 15);
		key_tx.setFont(font);
		// 1、选择目标文件夹
		file_select_btn = new JButton(STEP_1);
		file_select_btn.setFont(font);
		compress_file_btn = new JButton(STEP_2);
		compress_file_btn.setFont(font);
		content_panel.add(file_path_tx);
		content_panel.add(key_tx);
		content_panel.add(file_select_btn);
		content_panel.add(compress_file_btn);
		this.add(content_panel);
		// this.pack();
		initEvent();
	}

	private void initEvent() {
		compress_file_btn.addActionListener(this);
		file_select_btn.addActionListener(this);
		this.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}

			@Override
			public void windowClosed(WindowEvent e) {
				super.windowClosed(e);
			}
		});
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		String action = e.getActionCommand();
		switch (action) {
		case STEP_1:
			openWindowsFileDialog(file_path_tx);
			break;
		case STEP_2:
			String key = key_tx.getText();
			if (!StringUtils.isEmpty(key)) {
				TPUtils.init(key);
				TPUtils.compress(filePath);
				if(!StringUtils.isEmpty(TPUtils.MSG)){
					showDialog(TPUtils.MSG);
				}else {
					showDialog("压缩失败");
				}
				TPUtils.clearCache();
			} else {
				showDialog("key can not empty");
			}
			break;
		default:
			break;
		}
	}

	/**
	 * 打开选择文件对话框
	 * 
	 * @param targetTextfield
	 */
	private void openWindowsFileDialog(JTextField targetTextfield) {
		JFileChooser chooser = new JFileChooser();
		chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		chooser.setCurrentDirectory(selectedFile);
		chooser.showOpenDialog(this);
		selectedFile = chooser.getSelectedFile();
		if (selectedFile != null) {
			filePath = selectedFile.getAbsolutePath();
			logger.info(filePath);
			String displayTx = filePath.substring(filePath.lastIndexOf("\\") + 1);
			targetTextfield.setText(displayTx);
			logger.info("field:" + targetTextfield.getText().trim());
		}
	}

	/**
	 * 显示对话框
	 * 
	 * @param msg
	 */
	private void showDialog(String msg) {
		JOptionPane.showMessageDialog(this, msg);
	}

	public void onPause() {
		this.setVisible(false);
	}

	public void onStart() {
		initUI();
	}

	@Override
	public void onStop() {
		System.exit(0);
	}

}
