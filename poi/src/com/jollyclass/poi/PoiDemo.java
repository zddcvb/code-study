package com.jollyclass.poi;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;

import org.apache.poi.hpsf.DocumentSummaryInformation;
import org.apache.poi.hpsf.SummaryInformation;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFComment;
import org.apache.poi.hssf.usermodel.HSSFFooter;
import org.apache.poi.hssf.usermodel.HSSFHeader;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;

public class PoiDemo {
	public static void main(String[] args) throws IOException {
		// createExcel();
		// createSheet();
		// foreachExcel();
		readDoc();
		//writeDoc();
	}

	// 创建表格
	public static void createExcel() {
		String path = "d:/1.xls";
		// 创建excel文件
		HSSFWorkbook workbook = new HSSFWorkbook();
		workbook.createInformationProperties();// 创建文档属性
		// 创建摘要信息
		DocumentSummaryInformation information = workbook.getDocumentSummaryInformation();
		information.setCategory("excel文件");// 分类
		information.setManager("jack");// 管理者
		information.setDocumentVersion("1.0");// 文档版本
		information.setCompany("sunvision");// 公司
		// 创建子摘要信息
		SummaryInformation summaryInformation = workbook.getSummaryInformation();
		summaryInformation.setAuthor("lucy");// 作者
		summaryInformation.setCreateDateTime(new Date(2016, 11, 16));// 創建時間
		summaryInformation.setEditTime(1234565);// 編輯時間
		summaryInformation.setSubject("poi");// 主題
		summaryInformation.setTitle("poiTest");// 標題
		summaryInformation.setComments("poi test document");// 备注信息
		// 常见表格
		workbook.createSheet("test");
		workbook.createSheet("test01");
		FileOutputStream fos;
		try {
			fos = new FileOutputStream(new File(path));
			// 写入到具体的地址
			workbook.write(fos);
			fos.close();
			System.out.println("workbook ok");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void createSheet() {
		String path = "d:/2.xls";
		// 创建文件和表
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("test");
		HSSFHeader header = sheet.getHeader();
		header.setCenter("中心");
		header.setLeft("左边");
		header.setRight("右边");
		HSSFFooter footer = sheet.getFooter();
		footer.setCenter("中心");
		footer.setLeft("左边");
		footer.setRight("右边");
		// 创建批注
		HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
		// 设定批注位置
		HSSFClientAnchor anchor = patriarch.createAnchor(0, 0, 0, 0, 5, 1, 8, 3);
		// 设置批注内容
		HSSFComment comment = patriarch.createCellComment(anchor);
		comment.setAuthor("mary");
		comment.setString(new HSSFRichTextString("ok"));
		comment.setVisible(true);
		for (int i = 0; i < 100; i++) {
			System.out.println("sheet");
			// 创建行，从i开始
			HSSFRow row = sheet.createRow(i);
			for (int j = 0; j < 3; j++) {
				System.out.println("cell");
				// 创建列的单元格，从j开始
				HSSFCell cell = row.createCell(j);
				if (j == 0) {
					// 设置单元格的值
					cell.setCellValue(i + 1);
					// 添加批注
					cell.setCellComment(comment);
				} else if (j == 1) {
					cell.setCellValue("jack" + i);
				} else {
					cell.setCellValue(20 + i);
				}
			}
		}
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(new File(path));
			// 写入到具体的地址
			workbook.write(fos);
			fos.close();
			System.out.println("workbook ok");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public static void foreachExcel() throws IOException {
		String path = "d:/2.xls";
		FileInputStream fis = new FileInputStream(new File(path));
		// 创建文件和表
		HSSFWorkbook workbook = new HSSFWorkbook(fis);
		HSSFSheet sheet = workbook.getSheet("test");
		for (Row row : sheet) {
			for (Cell cell : row) {
				System.out.println(cell.toString());
			}
		}
	}

	public static void readDoc() {
		try {
			FileInputStream fis = new FileInputStream("d:/2.doc");
			System.out.println(fis.toString());
			XWPFDocument document = new XWPFDocument(fis);
			for (XWPFParagraph paragraph : document.getParagraphs()) {
				System.out.println(paragraph.getParagraphText());
			}
			fis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void writeDoc() {
		XWPFDocument document = new XWPFDocument();
		FileOutputStream fos;
		try {
			XWPFParagraph p = document.createParagraph();
			XWPFRun run = p.createRun();
			run.setText("poi read word");
			fos = new FileOutputStream("d:/2.doc");
			document.write(fos);
			fos.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}

