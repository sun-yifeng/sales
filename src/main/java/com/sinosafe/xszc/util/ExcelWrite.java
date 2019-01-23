package com.sinosafe.xszc.util;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class ExcelWrite {
    
    /**
     * 工作本
     * @param outPath
     * @return
     */
    public boolean createWorkBook(List<String> emplist,String outPath){
    	try {
    		File file = new File(outPath);
    		//创建工作簿
			Workbook wb = new HSSFWorkbook();
			//创建工作表
			Sheet sheet1 = wb.createSheet("sheet1");
			sheet1.createFreezePane(0, 1);
			sheet1.autoSizeColumn((short)0);
			CellStyle headerCellStyle = getHeaderCellStyle(wb);
			CellStyle cellStyle  = getCellStyle(wb);
			Cell cell = null;
			Row  row = null;
			int rowIndex = 0;
			int columnSize = 0;
			String[] empArray = null;
			for (String emp:emplist) {
				empArray = emp.split("`");
				columnSize = empArray.length;
				row = sheet1.createRow(rowIndex);
				row.setHeightInPoints(25);
				//创建一行
				for (int j = 0; j < columnSize; j++) {
					 //创建单元格
					 cell = row.createCell((short) j);
				     cell.setCellValue(empArray[j]);
				     if(rowIndex==0){
						cell.setCellStyle(headerCellStyle);
					 }else{
						cell.setCellStyle(cellStyle);
					 }
				}
				rowIndex++;
			}
			for (int i = 0; i < columnSize; i++) {
				 sheet1.autoSizeColumn((short)i,true); //调整列宽度
			}
			//四个参数分别是：起始行，起始列，结束行，结束列   
			FileOutputStream fileOut = new FileOutputStream(file);
			wb.write(fileOut);
			fileOut.close();
			return true;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return false;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
    }
    
    //设置单元格的样式
    private static CellStyle getHeaderCellStyle(Workbook wb){
    	CellStyle cellStyle = wb.createCellStyle();
    		cellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
    		cellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        //cellStyle.setAlignment(halign);
        //cellStyle.setVerticalAlignment(valign);
        cellStyle.setWrapText(true);
        //设置边框颜色
        cellStyle.setBorderBottom(CellStyle.BORDER_THIN);
        cellStyle.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        cellStyle.setBorderLeft(CellStyle.BORDER_THIN);
        cellStyle.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        cellStyle.setBorderRight(CellStyle.BORDER_THIN);
        cellStyle.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        cellStyle.setBorderTop(CellStyle.BORDER_THIN);
        cellStyle.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        //设置字体
        Font font = wb.createFont();
        font.setFontHeightInPoints((short)9);
        font.setFontName("微软雅黑");
        font.setItalic(false);
        font.setColor(IndexedColors.DARK_BLUE.getIndex());
        font.setBoldweight((short)5);
        cellStyle.setFont(font);
		return cellStyle;
    }
    
    //设置单元格的样式
    private static CellStyle getCellStyle(Workbook wb){
    	CellStyle cellStyle = wb.createCellStyle();
    	//cellStyle.setAlignment(halign);
    	//cellStyle.setVerticalAlignment(valign);
    	cellStyle.setWrapText(true);
    	//设置边框颜色
    	cellStyle.setBorderBottom(CellStyle.BORDER_THIN);
    	cellStyle.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    	cellStyle.setBorderLeft(CellStyle.BORDER_THIN);
    	cellStyle.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    	cellStyle.setBorderRight(CellStyle.BORDER_THIN);
    	cellStyle.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    	cellStyle.setBorderTop(CellStyle.BORDER_THIN);
    	cellStyle.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
    	//设置字体
    	Font font = wb.createFont();
    	font.setFontHeightInPoints((short)9);
    	font.setFontName("微软雅黑");
    	font.setItalic(false);
    	font.setBoldweight((short)1);
    	cellStyle.setFont(font);
    	return cellStyle;
    }
    
    //测试案例
    public static void main(String[] args) throws IOException {
    	String outPath = "D:\\输出文档\\kkk.xls";
    	File file = new File(outPath);
    	if(!file.exists()){
    		file.createNewFile();
    	}
    	ExcelWrite workBook  = new ExcelWrite();
    	List<String> emplist = new ArrayList<String>();
    	StringBuffer sb = new StringBuffer();
    	for (int i = 0; i < 10; i++) {
			sb.append(i+"`");
			sb.append("卢水发"+i+"`");
			sb.append("1587068859`");
			sb.append("男"+"`");
			sb.append("java软件工程师");
			emplist.add(sb.toString());
			sb = new StringBuffer();
		}
		boolean result = workBook.createWorkBook(emplist,outPath);
    	System.out.println("程序创建工作本的结果是："+result);
	}
}
