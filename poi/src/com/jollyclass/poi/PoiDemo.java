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

	// �������
	public static void createExcel() {
		String path = "d:/1.xls";
		// ����excel�ļ�
		HSSFWorkbook workbook = new HSSFWorkbook();
		workbook.createInformationProperties();// �����ĵ�����
		// ����ժҪ��Ϣ
		DocumentSummaryInformation information = workbook.getDocumentSummaryInformation();
		information.setCategory("excel�ļ�");// ����
		information.setManager("jack");// ������
		information.setDocumentVersion("1.0");// �ĵ��汾
		information.setCompany("sunvision");// ��˾
		// ������ժҪ��Ϣ
		SummaryInformation summaryInformation = workbook.getSummaryInformation();
		summaryInformation.setAuthor("lucy");// ����
		summaryInformation.setCreateDateTime(new Date(2016, 11, 16));// �����r�g
		summaryInformation.setEditTime(1234565);// ��݋�r�g
		summaryInformation.setSubject("poi");// ���}
		summaryInformation.setTitle("poiTest");// ���}
		summaryInformation.setComments("poi test document");// ��ע��Ϣ
		// �������
		workbook.createSheet("test");
		workbook.createSheet("test01");
		FileOutputStream fos;
		try {
			fos = new FileOutputStream(new File(path));
			// д�뵽����ĵ�ַ
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
		// �����ļ��ͱ�
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("test");
		HSSFHeader header = sheet.getHeader();
		header.setCenter("����");
		header.setLeft("���");
		header.setRight("�ұ�");
		HSSFFooter footer = sheet.getFooter();
		footer.setCenter("����");
		footer.setLeft("���");
		footer.setRight("�ұ�");
		// ������ע
		HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
		// �趨��עλ��
		HSSFClientAnchor anchor = patriarch.createAnchor(0, 0, 0, 0, 5, 1, 8, 3);
		// ������ע����
		HSSFComment comment = patriarch.createCellComment(anchor);
		comment.setAuthor("mary");
		comment.setString(new HSSFRichTextString("ok"));
		comment.setVisible(true);
		for (int i = 0; i < 100; i++) {
			System.out.println("sheet");
			// �����У���i��ʼ
			HSSFRow row = sheet.createRow(i);
			for (int j = 0; j < 3; j++) {
				System.out.println("cell");
				// �����еĵ�Ԫ�񣬴�j��ʼ
				HSSFCell cell = row.createCell(j);
				if (j == 0) {
					// ���õ�Ԫ���ֵ
					cell.setCellValue(i + 1);
					// �����ע
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
			// д�뵽����ĵ�ַ
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
		// �����ļ��ͱ�
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

