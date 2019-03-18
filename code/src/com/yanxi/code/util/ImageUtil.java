package com.yanxi.code.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.imageio.stream.FileImageOutputStream;
import javax.imageio.stream.ImageOutputStream;

import org.junit.Test;

/**
 * 现在已有完成的功能： 1、将jpg图按比例缩小，并保存，生成新的命名，添加了_New的后缀
 * 2、将png图按比例缩小，并保存成jpg格式，文件的名称与png一致
 * 
 * 新的需求： 1、读取到png图，转换成同等宽高的jpg图。 2、读取到png图，按比例缩小，并保存成jpg图，生成新的命名，添加_New的字段
 * 
 *
 */
public class ImageUtil {

	/**
	 * 递归搜索文件，如果是文件夹，就递归，如果是文件，进行图片转换和尺寸缩放
	 * 
	 * @param file
	 */
	public static void createNewImg(File file) {
		if (file.exists()) {
			File[] listFiles = file.listFiles();
			if (listFiles != null) {
				for (File listFile : listFiles) {
					// 获取文件的绝对路径，判断listFile是文件，还是文件夹，并判断他的路径以什么结尾
					String path = listFile.getAbsolutePath();
					if (listFile.isFile() && (path.endsWith(".jpg") || path.endsWith(".png"))) {
						// scaleImg(listFile);
						renameImage(listFile);
					} else {
						createNewImg(listFile);
					}
				}
			}
		}
	}

	/**
	 * 图片转换，使用ImageIo、BufferedImage类 ImageIo负责读取图片，保存图片。
	 * BufferedImage负责设置图片信息，并重绘图片：图片的宽高、x、y坐标、颜色模式、格式等
	 * 
	 * @param listFile
	 *            图片文件
	 */
	private static void scaleImg(File listFile) {
		try {
			// 1、读取图片，获取图片的宽高，并计算缩放比例
			BufferedImage bufi = ImageIO.read(listFile);
			int height = bufi.getHeight();
			int width = bufi.getWidth();
			int scale = Math.abs(width / height) * 10;
			// png图的绘制
			BufferedImage im = drawImage(bufi, width / scale, height / scale);
			// png转jpg，同等宽高
			BufferedImage pim = drawImage(bufi, width, height);
			// ImageIo写入图片，需要三个参数：BufferedImage、formatName（图片格式）、ImageOutputStream（图片保存的地址）
			String formatName = "jpg";
			String oldPath = listFile.getAbsolutePath();
			String outputPath = null;
			// 针对原始图片的不同格式，进行不同的路径截取和拼接
			if (oldPath.endsWith(".jpg")) {
				outputPath = createNewPath(listFile, ".jpg", "_New.jpg");
			} else if (oldPath.endsWith(".png")) {
				// 缩放的jpg图路径
				outputPath = createNewPath(listFile, ".png", "_New.jpg");
				// 没有缩放jpg图的路径
				String pngOutputPath = createNewPath(listFile, ".png", ".jpg");
				writeImage(pim, formatName, pngOutputPath);
			}
			writeImage(im, formatName, outputPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据不同的后缀，获得替换后的路径
	 * 
	 * @param listFile
	 * @param oldPrefix
	 * @param newPrefix
	 * @return
	 */
	private static String createNewPath(File listFile, String oldPrefix, String newPrefix) {
		String outputPath = listFile.getAbsolutePath().replace(oldPrefix, newPrefix);
		return outputPath;
	}

	/**
	 * 绘制image图
	 * 
	 * @param bufi
	 * @param width
	 * @param height
	 * @return
	 */
	private static BufferedImage drawImage(BufferedImage bufi, int width, int height) {
		// 2、新建图片缓存类BufferedImage，设置宽高和颜色模式
		BufferedImage im = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		// 3、重新绘制图片
		im.getGraphics().drawImage(bufi, 0, 0, width, height, null);
		return im;
	}

	/***
	 * 保存image图
	 * 
	 * @param bufi
	 * @param formatName
	 * @param outputPath
	 */
	private static void writeImage(BufferedImage bufi, String formatName, String outputPath) {
		ImageOutputStream output;
		try {
			output = new FileImageOutputStream(new File(outputPath));
			ImageIO.write(bufi, formatName, output);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void renameImage(File listFile) {
		try {
			// 1、读取图片，获取图片的宽高，并计算缩放比例
			BufferedImage bufi = ImageIO.read(listFile);
			int height = bufi.getHeight();
			int width = bufi.getWidth();
			// png图的绘制
			BufferedImage im = drawImage(bufi, width, height);
			// png转jpg，同等宽高
			BufferedImage pim = drawImage(bufi, width, height);
			// ImageIo写入图片，需要三个参数：BufferedImage、formatName（图片格式）、ImageOutputStream（图片保存的地址）
			String formatName = "jpg";
			String oldPath = listFile.getAbsolutePath();
			String outputPath = null;
			// 针对原始图片的不同格式，进行不同的路径截取和拼接
			if (oldPath.endsWith("_New.jpg")) {
				outputPath = createNewPath(listFile, "_New.jpg", "_small.jpg");
				System.out.println("small image path:"+oldPath);
				System.out.println("======small image success==============");
			} else if (oldPath.endsWith(".jpg") && !oldPath.contains("_New")) {
				// 缩放的jpg图路径
				outputPath = createNewPath(listFile, ".jpg", "_large.jpg");
				// 没有缩放jpg图的路径
				// String pngOutputPath = createNewPath(listFile, ".png",
				// ".jpg");
				// writeImage(pim, formatName, pngOutputPath);
				System.out.println("large image path:"+oldPath);
				System.out.println("======large image success==============");
			}
			writeImage(im, formatName, outputPath);
			listFile.delete();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Test
	public void test_rename() {
		ImageUtil.createNewImg(new File("C:\\Users\\Administrator\\Desktop\\res\\人物\\其他人物"));
	}

}
