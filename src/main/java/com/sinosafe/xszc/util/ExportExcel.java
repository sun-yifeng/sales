package com.sinosafe.xszc.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;

import com.sinosafe.xszc.common.controller.CommonController;

/**
 * <pre>
 * 类名:com.sinosafe.xszc.util.ExportExcel 
 * 描述:导出Excel 
 * 思路:封装POI，实现Excel导出
 * 特别说明:无 
 * 作者:黄思凯
 * 时间:2014-6-5
 * </pre>
 */
public class ExportExcel {

	private static final Log log = LogFactory.getLog(CommonController.class);

	/**
	 * <pre>
	 * 指定模板,生成Excel
	 * 方法dataToExcel的详细说明
	 * 编写者：黄思凯
	 * 创建时间：2014-6-9
	 * @param resultMap 数据
	 * @param filePath 所使用模板的路径
	 * @param colum_name 定义数据顺序数组
	 * @return void 说明
	 * @throws IOException 
	 * @throws FileNotFoundException
	 * @throws 无
	 * </pre>
	 */
	public static void dataToExcel(List<Map<String, Object>> resultMap, String filePath, String[] colum_name, OutputStream out) throws SQLException,
			FileNotFoundException, IOException {
		// 创建Excel工作簿
		HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(filePath));
		// 导出数据到Excel
		dataToExcel(resultMap, wb, colum_name, out,filePath);
	}

	/**
	 * 拷贝Excel行
	 * 
	 * @param wb
	 * @param fromsheet
	 * @param newsheet
	 * @param firstrow
	 * @param lastrow
	 */
	@SuppressWarnings("deprecation")
	public static HSSFSheet copyRows(HSSFSheet fromsheet, HSSFWorkbook wb, int firstrow, int lastrow, String sheetName) {
		HSSFSheet newsheet = wb.createSheet(sheetName);
		newsheet.createFreezePane(0, 2, 0, 2); // 冻结表头
		if ((firstrow == -1) || (lastrow == -1) || lastrow < firstrow) {
			return null;
		}
		// 拷贝合并的单元格
		Region region = null;
		for (int i = 0; i < fromsheet.getNumMergedRegions(); i++) {
			region = fromsheet.getMergedRegionAt(i);
			if ((region.getRowFrom() >= firstrow) && (region.getRowTo() <= lastrow)) {
				newsheet.addMergedRegion(region);
			}
		}

		HSSFRow fromRow = null;
		HSSFRow newRow = null;
		HSSFCell newCell = null;
		HSSFCell fromCell = null;
		// 设置列宽
		for (int i = firstrow; i <= lastrow; i++) {
			fromRow = fromsheet.getRow(i);
			if (fromRow != null) {
				for (int j = fromRow.getLastCellNum(); j >= fromRow.getFirstCellNum(); j--) {
					int colnum = fromsheet.getColumnWidth((short) j);
					if (colnum > 100) {
						newsheet.setColumnWidth((short) j, (short) colnum);
					}
					if (colnum == 0) {
						newsheet.setColumnHidden((short) j, true);
					} else {
						newsheet.setColumnHidden((short) j, false);
					}
				}
				break;
			}
		}
		// 拷贝行并填充数据
		for (int i = 0; i <= lastrow; i++) {
			fromRow = fromsheet.getRow(i);
			if (fromRow == null) {
				continue;
			}
			newRow = newsheet.createRow(i - firstrow);
			newRow.setHeight(fromRow.getHeight());
			for (int j = fromRow.getFirstCellNum(); j < fromRow.getPhysicalNumberOfCells(); j++) {
				fromCell = fromRow.getCell((short) j);
				if (fromCell == null) {
					continue;
				}
				newCell = newRow.createCell((short) j);
				newCell.setCellStyle(fromCell.getCellStyle());
				int cType = fromCell.getCellType();
				newCell.setCellType(cType);
				switch (cType) {
				case HSSFCell.CELL_TYPE_STRING:
					newCell.setCellValue(fromCell.getRichStringCellValue());
					break;
				case HSSFCell.CELL_TYPE_NUMERIC:
					newCell.setCellValue(fromCell.getNumericCellValue());
					break;
				case HSSFCell.CELL_TYPE_FORMULA:
					newCell.setCellFormula(fromCell.getCellFormula());
					break;
				case HSSFCell.CELL_TYPE_BOOLEAN:
					newCell.setCellValue(fromCell.getBooleanCellValue());
					break;
				case HSSFCell.CELL_TYPE_ERROR:
					newCell.setCellValue(fromCell.getErrorCellValue());
					break;
				default:
					newCell.setCellValue(fromCell.getRichStringCellValue());
					break;
				}
			}
		}
		return newsheet;
	}

	/**
	 * 导出基础管理类-中介业务统计报表专属方法
	 */
	@SuppressWarnings("deprecation")
	public static void reportFM(HttpServletRequest request, HttpServletResponse response, PageDto pageDto) {
		HSSFWorkbook wb = new HSSFWorkbook();// 创建一个工作薄对象
		try {

			HSSFSheet sheet = wb.createSheet();
			initSheet(sheet);
			HSSFCellStyle style = wb.createCellStyle(); // 样式对象

			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
			style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
			style.setLocked(true);
			style.setWrapText(true);
			style.setLeftBorderColor(HSSFColor.BLACK.index);// 左边框的颜色
			style.setBorderLeft((short) 1);// 边框的大小
			style.setRightBorderColor(HSSFColor.BLACK.index);// 右边框的颜色
			style.setBorderRight((short) 1);// 边框的大小
			style.setBorderTop((short) 1);
			style.setBorderBottom(HSSFCellStyle.BORDER_THIN); // 设置单元格的边框为粗体
			style.setBottomBorderColor(HSSFColor.BLACK.index); // 设置单元格的边框颜色
			// 设置单元格的背景颜色（单元格的样式会覆盖列或行的样式）
			style.setFillForegroundColor(HSSFColor.WHITE.index);

			initTableHead(sheet, style);

			List<Map<String, Object>> list = pageDto.getRows();

			List<Map<String, Object>> directList = new ArrayList<Map<String, Object>>(); // 直接业务
			List<Map<String, Object>> indirectList = new ArrayList<Map<String, Object>>(); // 间接业务
			List<Map<String, Object>> otherList = new ArrayList<Map<String, Object>>(); // 其他业务
			List<Map<String, Object>> Total = new ArrayList<Map<String, Object>>(); // 总计

			int arg[] = new int[2];
			int arg1[] = new int[2];
			for (Map<String, Object> map : list) {
				if (map.get("cBsnsTyp") != null
						&& (map.get("cBsnsTyp").equals("19001直销业务") || map.get("cBsnsTyp").equals("19007电销业务") || map.get("cBsnsTyp").equals("19008店面直销"))) {
					directList.add(map);
				} else if (map.get("cBsnsTyp") != null && (map.get("cBsnsTyp").equals("19002代理业务") || map.get("cBsnsTyp").equals("19003经纪业务"))) {
					if (map.get("cBsnsTyp").equals("19002代理业务")) {
						arg[0]++;
					} else if (map.get("cBsnsTyp").equals("19003经纪业务")) {
						arg[1]++;
					}
					indirectList.add(map);
				} else if (map.get("cBsnsTyp") == null) {
					Total.add(map);
				} else {
					/*
					 * if (map.get("cBsnsTyp").equals("19007")) { arg1[0]++; } else if (map.get("cBsnsTyp").equals("19008店面直销")) { arg1[1]++; }
					 */
					arg1[0]++;
					otherList.add(map);
				}
			}
			HSSFRow directRows;
			for (int i = 0; i < directList.size(); i++) {
				Map<String, Object> map = directList.get(i);
				if (i == 0) {
					sheet.addMergedRegion(new CellRangeAddress(2, (directList.size() + 1), (short) 0, (short) 0));
					directRows = sheet.createRow(2);

					HSSFCell cellHead = directRows.createCell(0);
					cellHead.setCellValue("直接业务");
					cellHead.setCellStyle(style);

					writeRows(map, directRows, style);
				} else {
					directRows = sheet.createRow(i + 2);
					writeRows(map, directRows, style);
				}
			}

			for (int i = 0; i < indirectList.size(); i++) {
				Map<String, Object> map = indirectList.get(i);
				if (i == 0) {
					directRows = sheet.createRow(directList.size() + 2);

					HSSFCell cellHead1 = directRows.createCell(0);
					cellHead1.setCellValue("间接业务");
					cellHead1.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress(directList.size() + 2, (directList.size() + indirectList.size() + 1), 0, 0));

					sheet.addMergedRegion(new Region(directList.size() + 2, (short) 1, (directList.size() + arg[0] + 1), (short) 1));
					HSSFCell cellcBsnsTyp = directRows.createCell(1);
					cellcBsnsTyp.setCellValue(map.get("cBsnsTyp").toString());
					cellcBsnsTyp.setCellStyle(style);

					writeRows(map, directRows, style);
				} else {
					if (i == arg[0]) {
						directRows = sheet.createRow(directList.size() + i + 2);

						sheet.addMergedRegion(new Region(directList.size() + arg[0] + 2, (short) 1, (directList.size() + arg[0] + arg[1] + 1), (short) 1));

						HSSFCell cellcBsnsTyp1 = directRows.createCell(1);
						cellcBsnsTyp1.setCellValue(map.get("cBsnsTyp").toString());
						cellcBsnsTyp1.setCellStyle(style);
						writeRows(map, directRows, style);
					} else {
						directRows = sheet.createRow(directList.size() + i + 2);
						writeRows(map, directRows, style);
					}
				}
			}

			for (int i = 0; i < otherList.size(); i++) {
				Map<String, Object> map = otherList.get(i);
				if (i == 0) {
					sheet.addMergedRegion(new CellRangeAddress(directList.size() + indirectList.size() + 2, (directList.size() + indirectList.size()
							+ otherList.size() + 1), 0, 0));
					directRows = sheet.createRow(directList.size() + indirectList.size() + 2);

					HSSFCell cellHead1 = directRows.createCell(0);
					cellHead1.setCellValue("其他业务");
					cellHead1.setCellStyle(style);

					sheet.addMergedRegion(new Region(directList.size() + indirectList.size() + 2, (short) 1,
							(directList.size() + indirectList.size() + arg1[0] + 1), (short) 1));
					HSSFCell cellcBsnsTyp = directRows.createCell(1);
					cellcBsnsTyp.setCellValue(map.get("cBsnsTyp").toString());
					cellcBsnsTyp.setCellStyle(style);

					writeRows(map, directRows, style);
				} else {
					if (i == arg1[0]) {
						directRows = sheet.createRow(directList.size() + indirectList.size() + i + 2);

						sheet.addMergedRegion(new Region(directList.size() + indirectList.size() + arg1[0] + 2, (short) 1, (directList.size()
								+ indirectList.size() + arg1[0] + arg1[1] + 1), (short) 1));

						HSSFCell cellcBsnsTyp1 = directRows.createCell(1);
						cellcBsnsTyp1.setCellValue(map.get("cBsnsTyp").toString());
						cellcBsnsTyp1.setCellStyle(style);
						writeRows(map, directRows, style);
					} else {
						directRows = sheet.createRow(directList.size() + indirectList.size() + i + 2);
						writeRows(map, directRows, style);
					}
				}
			}

			for (int i = 0; i < Total.size(); i++) {
				Map<String, Object> map = Total.get(i);
				directRows = sheet.createRow(directList.size() + indirectList.size() + otherList.size() + 2);
				sheet.addMergedRegion(new Region(directList.size() + indirectList.size() + otherList.size() + 2, (short) 0, (directList.size()
						+ indirectList.size() + otherList.size() + 2), (short) 2));
				HSSFCell cellHead1 = directRows.createCell(0);
				cellHead1.setCellValue("总计");
				cellHead1.setCellStyle(style);
				writeRows(map, directRows, style);
			}

			String strFileName = "reportFoundationMedium.xls";

			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}

			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");

			OutputStream out = response.getOutputStream();
			wb.write(out);
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 初始化sheet，设置列数和每列宽度
	@SuppressWarnings("deprecation")
	private static void initSheet(HSSFSheet sheet) {
		sheet.setColumnWidth((short) 0, (short) (35.7 * 100));
		sheet.setColumnWidth((short) 1, (short) (35.7 * 100));
		sheet.setColumnWidth(2, 20 * 256);
		sheet.setColumnWidth((short) 3, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 4, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 5, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 6, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 7, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 8, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 9, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 10, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 11, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 12, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 13, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 14, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 15, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 16, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 17, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 18, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 19, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 20, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 21, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 22, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 23, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 24, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 25, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 26, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 27, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 28, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 29, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 30, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 31, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 32, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 33, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 34, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 35, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 36, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 37, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 38, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 39, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 40, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 41, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 42, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 43, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 44, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 45, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 46, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 47, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 48, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 49, (short) (35.7 * 120));
		sheet.setColumnWidth((short) 50, (short) (35.7 * 120));
	}

	@SuppressWarnings("deprecation")
	private static void initTableHead(HSSFSheet sheet, HSSFCellStyle style) {
		HSSFRow row1 = sheet.createRow(0);
		HSSFRow row2 = sheet.createRow(1);

		sheet.addMergedRegion(new Region(0, (short) 0, 1, (short) 1)); // 设置第一行表头
		HSSFCell cell1 = row1.createCell(0);
		cell1.setCellValue("业务来源");
		cell1.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 2, 1, (short) 2));// 设置第二行表头
		HSSFCell cell2 = row1.createCell(2);
		cell2.setCellValue("代理业务");
		cell2.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 3, 0, (short) 5));
		HSSFCell cell3 = row1.createCell(3);
		cell3.setCellValue("企业财产保险(元)");
		cell3.setCellStyle(style);

		HSSFCell cell3r1 = row2.createCell(3);
		cell3r1.setCellValue("保费收入");
		cell3r1.setCellStyle(style);

		HSSFCell cell3r2 = row2.createCell(4);
		cell3r2.setCellValue("手续费及佣金");
		cell3r2.setCellStyle(style);

		HSSFCell cell3r3 = row2.createCell(5);
		cell3r3.setCellValue("实付佣金");
		cell3r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 6, 0, (short) 8));
		HSSFCell cell4 = row1.createCell(6);
		cell4.setCellValue("家庭财产保险(元)");
		cell4.setCellStyle(style);

		HSSFCell cell4r1 = row2.createCell(6);
		cell4r1.setCellValue("保费收入");
		cell4r1.setCellStyle(style);

		HSSFCell cell4r2 = row2.createCell(7);
		cell4r2.setCellValue("手续费及佣金");
		cell4r2.setCellStyle(style);

		HSSFCell cell4r3 = row2.createCell(8);
		cell4r3.setCellValue("实付佣金");
		cell4r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 9, 0, (short) 11));
		HSSFCell cell5 = row1.createCell(9);
		cell5.setCellValue("商业性机动车辆保险(元)");
		cell5.setCellStyle(style);

		HSSFCell cell5r1 = row2.createCell(9);
		cell5r1.setCellValue("保费收入");
		cell5r1.setCellStyle(style);

		HSSFCell cell5r2 = row2.createCell(10);
		cell5r2.setCellValue("手续费及佣金");
		cell5r2.setCellStyle(style);

		HSSFCell cell5r3 = row2.createCell(11);
		cell5r3.setCellValue("实付佣金");
		cell5r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 12, 0, (short) 14));
		HSSFCell cell6 = row1.createCell(12);
		cell6.setCellValue("交强险(元)");
		cell6.setCellStyle(style);

		HSSFCell cell6r1 = row2.createCell(12);
		cell6r1.setCellValue("保费收入");
		cell6r1.setCellStyle(style);

		HSSFCell cell6r2 = row2.createCell(13);
		cell6r2.setCellValue("手续费及佣金");
		cell6r2.setCellStyle(style);

		HSSFCell cell6r3 = row2.createCell(14);
		cell6r3.setCellValue("实付佣金");
		cell6r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 15, 0, (short) 17));
		HSSFCell cell7 = row1.createCell(15);
		cell7.setCellValue("工程保险(元)");
		cell7.setCellStyle(style);

		HSSFCell cell7r1 = row2.createCell(15);
		cell7r1.setCellValue("保费收入");
		cell7r1.setCellStyle(style);

		HSSFCell cell7r2 = row2.createCell(16);
		cell7r2.setCellValue("手续费及佣金");
		cell7r2.setCellStyle(style);

		HSSFCell cell7r3 = row2.createCell(17);
		cell7r3.setCellValue("实付佣金");
		cell7r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 18, 0, (short) 20));
		HSSFCell cell8 = row1.createCell(18);
		cell8.setCellValue("责任保险(元)");
		cell8.setCellStyle(style);

		HSSFCell cell8r1 = row2.createCell(18);
		cell8r1.setCellValue("保费收入");
		cell8r1.setCellStyle(style);

		HSSFCell cell8r2 = row2.createCell(19);
		cell8r2.setCellValue("手续费及佣金");
		cell8r2.setCellStyle(style);

		HSSFCell cell8r3 = row2.createCell(20);
		cell8r3.setCellValue("实付佣金");
		cell8r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 21, 0, (short) 23));
		HSSFCell cell9 = row1.createCell(21);
		cell9.setCellValue("信用险(元)");
		cell9.setCellStyle(style);

		HSSFCell cell9r1 = row2.createCell(21);
		cell9r1.setCellValue("保费收入");
		cell9r1.setCellStyle(style);

		HSSFCell cell9r2 = row2.createCell(22);
		cell9r2.setCellValue("手续费及佣金");
		cell9r2.setCellStyle(style);

		HSSFCell cell9r3 = row2.createCell(23);
		cell9r3.setCellValue("实付佣金");
		cell9r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 24, 0, (short) 26));
		HSSFCell cell10 = row1.createCell(24);
		cell10.setCellValue("保证险(元)");
		cell10.setCellStyle(style);

		HSSFCell cell10r1 = row2.createCell(24);
		cell10r1.setCellValue("保费收入");
		cell10r1.setCellStyle(style);

		HSSFCell cell10r2 = row2.createCell(25);
		cell10r2.setCellValue("手续费及佣金");
		cell10r2.setCellStyle(style);

		HSSFCell cell10r3 = row2.createCell(26);
		cell10r3.setCellValue("实付佣金");
		cell10r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 27, 0, (short) 29));
		HSSFCell cell11 = row1.createCell(27);
		cell11.setCellValue("船舶保险(元)");
		cell11.setCellStyle(style);

		HSSFCell cell11r1 = row2.createCell(27);
		cell11r1.setCellValue("保费收入");
		cell11r1.setCellStyle(style);

		HSSFCell cell11r2 = row2.createCell(28);
		cell11r2.setCellValue("手续费及佣金");
		cell11r2.setCellStyle(style);

		HSSFCell cell11r3 = row2.createCell(29);
		cell11r3.setCellValue("实付佣金");
		cell11r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 30, 0, (short) 32));
		HSSFCell cell12 = row1.createCell(30);
		cell12.setCellValue("货物运输保险(元)");
		cell12.setCellStyle(style);

		HSSFCell cell12r1 = row2.createCell(30);
		cell12r1.setCellValue("保费收入");
		cell12r1.setCellStyle(style);

		HSSFCell cell12r2 = row2.createCell(31);
		cell12r2.setCellValue("手续费及佣金");
		cell12r2.setCellStyle(style);

		HSSFCell cell12r3 = row2.createCell(32);
		cell12r3.setCellValue("实付佣金");
		cell12r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 33, 0, (short) 35));
		HSSFCell cell13 = row1.createCell(33);
		cell13.setCellValue("特殊风险保险(元)");
		cell13.setCellStyle(style);

		HSSFCell cell13r1 = row2.createCell(33);
		cell13r1.setCellValue("保费收入");
		cell13r1.setCellStyle(style);

		HSSFCell cell13r2 = row2.createCell(34);
		cell13r2.setCellValue("手续费及佣金");
		cell13r2.setCellStyle(style);

		HSSFCell cell13r3 = row2.createCell(35);
		cell13r3.setCellValue("实付佣金");
		cell13r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 36, 0, (short) 38));
		HSSFCell cell14 = row1.createCell(36);
		cell14.setCellValue("农业保险(元)");
		cell14.setCellStyle(style);

		HSSFCell cell14r1 = row2.createCell(36);
		cell14r1.setCellValue("保费收入");
		cell14r1.setCellStyle(style);

		HSSFCell cell14r2 = row2.createCell(37);
		cell14r2.setCellValue("手续费及佣金");
		cell14r2.setCellStyle(style);

		HSSFCell cell14r3 = row2.createCell(38);
		cell14r3.setCellValue("实付佣金");
		cell14r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 39, 0, (short) 41));
		HSSFCell cell15 = row1.createCell(39);
		cell15.setCellValue("健康险(元)");
		cell15.setCellStyle(style);

		HSSFCell cell15r1 = row2.createCell(39);
		cell15r1.setCellValue("保费收入");
		cell15r1.setCellStyle(style);

		HSSFCell cell15r2 = row2.createCell(40);
		cell15r2.setCellValue("手续费及佣金");
		cell15r2.setCellStyle(style);

		HSSFCell cell15r3 = row2.createCell(41);
		cell15r3.setCellValue("实付佣金");
		cell15r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 42, 0, (short) 44));
		HSSFCell cell16 = row1.createCell(42);
		cell16.setCellValue("意外伤害保险(元)");
		cell16.setCellStyle(style);

		HSSFCell cell16r1 = row2.createCell(42);
		cell16r1.setCellValue("保费收入");
		cell16r1.setCellStyle(style);

		HSSFCell cell16r2 = row2.createCell(43);
		cell16r2.setCellValue("手续费及佣金");
		cell16r2.setCellStyle(style);

		HSSFCell cell16r3 = row2.createCell(44);
		cell16r3.setCellValue("实付佣金");
		cell16r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 45, 0, (short) 47));
		HSSFCell cell17 = row1.createCell(45);
		cell17.setCellValue("其他险种(元)");
		cell17.setCellStyle(style);

		HSSFCell cell17r1 = row2.createCell(45);
		cell17r1.setCellValue("保费收入");
		cell17r1.setCellStyle(style);

		HSSFCell cell17r2 = row2.createCell(46);
		cell17r2.setCellValue("手续费及佣金");
		cell17r2.setCellStyle(style);

		HSSFCell cell17r3 = row2.createCell(47);
		cell17r3.setCellValue("实付佣金");
		cell17r3.setCellStyle(style);

		sheet.addMergedRegion(new Region(0, (short) 48, 0, (short) 50));
		HSSFCell cell18 = row1.createCell(48);
		cell18.setCellValue("合计(元)");
		cell18.setCellStyle(style);

		HSSFCell cell18r1 = row2.createCell(48);
		cell18r1.setCellValue("保费收入");
		cell18r1.setCellStyle(style);

		HSSFCell cell18r2 = row2.createCell(49);
		cell18r2.setCellValue("手续费及佣金");
		cell18r2.setCellStyle(style);

		HSSFCell cell18r3 = row2.createCell(50);
		cell18r3.setCellValue("实付佣金");
		cell18r3.setCellStyle(style);
	}

	private static void writeRows(Map<String, Object> map, HSSFRow directRows, HSSFCellStyle style) {
		// HSSFCell cellcBsnsTyp = directRows.createCell(2);
		// cellcBsnsTyp.setCellValue(map.get("cBsnsTyp").toString());
		// cellcBsnsTyp.setCellStyle(style);

		HSSFCell cellcBsnsTyp = directRows.createCell(1);
		if (map.get("cBsnsTyp") != null)
			cellcBsnsTyp.setCellValue(map.get("cBsnsTyp").toString());
		cellcBsnsTyp.setCellStyle(style);

		HSSFCell cellcChaType = directRows.createCell(2);
		if (map.get("cChaType") != null)
			cellcChaType.setCellValue(map.get("cChaType").toString());
		else if (map.get("cBsnsTyp") != null && map.get("cBsnsTyp").equals("19002代理业务"))
			cellcChaType.setCellValue("小计");
		else if (map.get("cBsnsTyp") != null)
			cellcChaType.setCellValue(map.get("cBsnsTyp").toString().replaceAll("[0-9]", ""));
		cellcChaType.setCellStyle(style);

		HSSFCell cellcompTakeIn = directRows.createCell(3);
		if (map.get("compTakeIn") != null)
			cellcompTakeIn.setCellValue(map.get("compTakeIn").toString());
		cellcompTakeIn.setCellStyle(style);

		HSSFCell cellcompCommision = directRows.createCell(4);
		if (map.get("compCommision") != null)
			cellcompCommision.setCellValue(map.get("compCommision").toString());
		cellcompCommision.setCellStyle(style);

		HSSFCell cellcompRealCommision = directRows.createCell(5);
		if (map.get("compRealCommision") != null)
			cellcompRealCommision.setCellValue(map.get("compRealCommision").toString());
		cellcompRealCommision.setCellStyle(style);

		HSSFCell cellfarmTakeIn = directRows.createCell(6);
		if (map.get("farmTakeIn") != null)
			cellfarmTakeIn.setCellValue(map.get("farmTakeIn").toString());
		cellfarmTakeIn.setCellStyle(style);

		HSSFCell cellfarmCommision = directRows.createCell(7);
		if (map.get("farmCommision") != null)
			cellfarmCommision.setCellValue(map.get("farmCommision").toString());
		cellfarmCommision.setCellStyle(style);

		HSSFCell cellfarmRealCommision = directRows.createCell(8);
		if (map.get("farmRealCommision") != null)
			cellfarmRealCommision.setCellValue(map.get("farmRealCommision").toString());
		cellfarmRealCommision.setCellStyle(style);

		HSSFCell cellbusiTakeIn = directRows.createCell(9);
		if (map.get("busiTakeIn") != null)
			cellbusiTakeIn.setCellValue(map.get("busiTakeIn").toString());
		cellbusiTakeIn.setCellStyle(style);

		HSSFCell cellbusiCommision = directRows.createCell(10);
		if (map.get("busiCommision") != null)
			cellbusiCommision.setCellValue(map.get("busiCommision").toString());
		cellbusiCommision.setCellStyle(style);

		HSSFCell cellbusiRealCommision = directRows.createCell(11);
		if (map.get("busiRealCommision") != null)
			cellbusiRealCommision.setCellValue(map.get("busiRealCommision").toString());
		cellbusiRealCommision.setCellStyle(style);

		HSSFCell celltransTakeIn = directRows.createCell(12);
		if (map.get("transTakeIn") != null)
			celltransTakeIn.setCellValue(map.get("transTakeIn").toString());
		celltransTakeIn.setCellStyle(style);

		HSSFCell celltransCommision = directRows.createCell(13);
		if (map.get("transCommision") != null)
			celltransCommision.setCellValue(map.get("transCommision").toString());
		celltransCommision.setCellStyle(style);

		HSSFCell celltransRealCommision = directRows.createCell(14);
		if (map.get("transRealCommision") != null)
			celltransRealCommision.setCellValue(map.get("transRealCommision").toString());
		celltransRealCommision.setCellStyle(style);

		HSSFCell cellprojectTakeIn = directRows.createCell(15);
		if (map.get("projectTakeIn") != null)
			cellprojectTakeIn.setCellValue(map.get("projectTakeIn").toString());
		cellprojectTakeIn.setCellStyle(style);

		HSSFCell cellprojectCommision = directRows.createCell(16);
		if (map.get("projectCommision") != null)
			cellprojectCommision.setCellValue(map.get("projectCommision").toString());
		cellprojectCommision.setCellStyle(style);

		HSSFCell cellprojectRealCommision = directRows.createCell(17);
		if (map.get("projectRealCommision") != null)
			cellprojectRealCommision.setCellValue(map.get("projectRealCommision").toString());
		cellprojectRealCommision.setCellStyle(style);

		HSSFCell celldutyTakeIn = directRows.createCell(18);
		if (map.get("dutyTakeIn") != null)
			celldutyTakeIn.setCellValue(map.get("dutyTakeIn").toString());
		celldutyTakeIn.setCellStyle(style);

		HSSFCell celldutyCommision = directRows.createCell(19);
		if (map.get("dutyCommision") != null)
			celldutyCommision.setCellValue(map.get("dutyCommision").toString());
		celldutyCommision.setCellStyle(style);

		HSSFCell celldutyRealCommision = directRows.createCell(20);
		if (map.get("dutyRealCommision") != null)
			celldutyRealCommision.setCellValue(map.get("dutyRealCommision").toString());
		celldutyRealCommision.setCellStyle(style);

		HSSFCell cellcreditTakeIn = directRows.createCell(21);
		if (map.get("creditTakeIn") != null)
			cellcreditTakeIn.setCellValue(map.get("creditTakeIn").toString());
		cellcreditTakeIn.setCellStyle(style);

		HSSFCell cellcreditCommision = directRows.createCell(22);
		if (map.get("creditCommision") != null)
			cellcreditCommision.setCellValue(map.get("creditCommision").toString());
		cellcreditCommision.setCellStyle(style);

		HSSFCell cellcreditRealCommision = directRows.createCell(23);
		if (map.get("creditRealCommision") != null)
			cellcreditRealCommision.setCellValue(map.get("creditRealCommision").toString());
		cellcreditRealCommision.setCellStyle(style);

		HSSFCell cellguaranteeTakeIn = directRows.createCell(24);
		if (map.get("guaranteeTakeIn") != null)
			cellguaranteeTakeIn.setCellValue(map.get("guaranteeTakeIn").toString());
		cellguaranteeTakeIn.setCellStyle(style);

		HSSFCell cellguaranteeCommision = directRows.createCell(25);
		if (map.get("guaranteeCommision") != null)
			cellguaranteeCommision.setCellValue(map.get("guaranteeCommision").toString());
		cellguaranteeCommision.setCellStyle(style);

		HSSFCell cellguaranteeRealCommision = directRows.createCell(26);
		if (map.get("guaranteeRealCommision") != null)
			cellguaranteeRealCommision.setCellValue(map.get("guaranteeRealCommision").toString());
		cellguaranteeRealCommision.setCellStyle(style);

		HSSFCell cellshipTakeIn = directRows.createCell(27);
		if (map.get("shipTakeIn") != null)
			cellshipTakeIn.setCellValue(map.get("shipTakeIn").toString());
		cellshipTakeIn.setCellStyle(style);

		HSSFCell cellshipCommision = directRows.createCell(28);
		if (map.get("shipCommision") != null)
			cellshipCommision.setCellValue(map.get("shipCommision").toString());
		cellshipCommision.setCellStyle(style);

		HSSFCell cellshipRealCommision = directRows.createCell(29);
		if (map.get("shipRealCommision") != null)
			cellshipRealCommision.setCellValue(map.get("shipRealCommision").toString());
		cellshipRealCommision.setCellStyle(style);

		HSSFCell cellcargoTakeIn = directRows.createCell(30);
		if (map.get("cargoTakeIn") != null)
			cellcargoTakeIn.setCellValue(map.get("cargoTakeIn").toString());
		cellcargoTakeIn.setCellStyle(style);

		HSSFCell cellcargoCommision = directRows.createCell(31);
		if (map.get("cargoCommision") != null)
			cellcargoCommision.setCellValue(map.get("cargoCommision").toString());
		cellcargoCommision.setCellStyle(style);

		HSSFCell cellcargoRealCommision = directRows.createCell(32);
		if (map.get("cargoRealCommision") != null)
			cellcargoRealCommision.setCellValue(map.get("cargoRealCommision").toString());
		cellcargoRealCommision.setCellStyle(style);

		HSSFCell cellspecialTakeIn = directRows.createCell(33);
		if (map.get("specialTakeIn") != null)
			cellspecialTakeIn.setCellValue(map.get("specialTakeIn").toString());
		cellspecialTakeIn.setCellStyle(style);

		HSSFCell cellspecialCommision = directRows.createCell(34);
		if (map.get("specialCommision") != null)
			cellspecialCommision.setCellValue(map.get("specialCommision").toString());
		cellspecialCommision.setCellStyle(style);

		HSSFCell cellspecialRealCommision = directRows.createCell(35);
		if (map.get("specialRealCommision") != null)
			cellspecialRealCommision.setCellValue(map.get("specialRealCommision").toString());
		cellspecialRealCommision.setCellStyle(style);

		HSSFCell cellfarmingTakeIn = directRows.createCell(36);
		if (map.get("farmingTakeIn") != null)
			cellfarmingTakeIn.setCellValue(map.get("farmingTakeIn").toString());
		cellfarmingTakeIn.setCellStyle(style);

		HSSFCell cellfarmingCommision = directRows.createCell(37);
		if (map.get("farmingCommision") != null)
			cellfarmingCommision.setCellValue(map.get("farmingCommision").toString());
		cellfarmingCommision.setCellStyle(style);

		HSSFCell cellfarmingRealCommision = directRows.createCell(38);
		if (map.get("farmingRealCommision") != null)
			cellfarmingRealCommision.setCellValue(map.get("farmingRealCommision").toString());
		cellfarmingRealCommision.setCellStyle(style);

		HSSFCell cellhealthTakeIn = directRows.createCell(39);
		if (map.get("healthTakeIn") != null)
			cellhealthTakeIn.setCellValue(map.get("healthTakeIn").toString());
		cellhealthTakeIn.setCellStyle(style);

		HSSFCell cellhealthCommision = directRows.createCell(40);
		if (map.get("healthCommision") != null)
			cellhealthCommision.setCellValue(map.get("healthCommision").toString());
		cellhealthCommision.setCellStyle(style);

		HSSFCell cellhealthRealCommision = directRows.createCell(41);
		if (map.get("healthRealCommision") != null)
			cellhealthRealCommision.setCellValue(map.get("healthRealCommision").toString());
		cellhealthRealCommision.setCellStyle(style);

		HSSFCell cellhurtTakeIn = directRows.createCell(42);
		if (map.get("hurtTakeIn") != null)
			cellhurtTakeIn.setCellValue(map.get("hurtTakeIn").toString());
		cellhurtTakeIn.setCellStyle(style);

		HSSFCell cellhurtCommision = directRows.createCell(43);
		if (map.get("hurtCommision") != null)
			cellhurtCommision.setCellValue(map.get("hurtCommision").toString());
		cellhurtCommision.setCellStyle(style);

		HSSFCell cellhurtRealCommision = directRows.createCell(44);
		if (map.get("hurtRealCommision") != null)
			cellhurtRealCommision.setCellValue(map.get("hurtRealCommision").toString());
		cellhurtRealCommision.setCellStyle(style);

		HSSFCell cellotherTakeIn = directRows.createCell(45);
		if (map.get("otherTakeIn") != null)
			cellotherTakeIn.setCellValue(map.get("otherTakeIn").toString());
		cellotherTakeIn.setCellStyle(style);

		HSSFCell cellotherCommision = directRows.createCell(46);
		if (map.get("otherCommision") != null)
			cellotherCommision.setCellValue(map.get("otherCommision").toString());
		cellotherCommision.setCellStyle(style);

		HSSFCell cellotherRealCommision = directRows.createCell(47);
		if (map.get("otherRealCommision") != null)
			cellotherRealCommision.setCellValue(map.get("otherRealCommision").toString());
		cellotherRealCommision.setCellStyle(style);

		HSSFCell celltotalTakeIn = directRows.createCell(48);
		if (map.get("totalTakeIn") != null)
			celltotalTakeIn.setCellValue(map.get("totalTakeIn").toString());
		celltotalTakeIn.setCellStyle(style);

		HSSFCell celltotalCommision = directRows.createCell(49);
		if (map.get("totalCommision") != null)
			celltotalCommision.setCellValue(map.get("totalCommision").toString());
		celltotalCommision.setCellStyle(style);

		HSSFCell celltotalRealCommision = directRows.createCell(50);
		if (map.get("totalRealCommision") != null)
			celltotalRealCommision.setCellValue(map.get("totalRealCommision").toString());
		celltotalRealCommision.setCellStyle(style);
	}

	/**
	 * <pre>
	 * 创建Cell
	 * 方法createCell的详细说明 
	 * 编写者：黄思凯
	 * 创建时间：2014-6-5
	 * @param wb HSSFWorkbook对象
	 * @param row HSSFRow 对象
	 * @param col HSSFRow 对象
	 * @param val 设置的值
	 * @return void 说明
	 * @throws 无
	 * </pre>
	 */
	public static void createCell(HSSFWorkbook wb, HSSFRow row, int col, String val, CellStyle style) {
		HSSFCell cell = row.createCell(col);
		cell.setCellStyle(style);
		cell.setCellValue(val);
	}

	/**
	 * <pre>
	 * 复制单个文件
	 * @param oldPath String 原文件路径 如：c:/fqf.txt
	 * @param newPath String 复制后路径 如：f:/fqf.txt
	 * @return boolean
	 * </pre>
	 */
	public static void copyFile(String oldPath, String newPath) {
		try {
			int bytesum = 0;
			int byteread = 0;
			File oldfile = new File(oldPath);
			if (oldfile.exists()) { // 文件存在时
				InputStream inStream = new FileInputStream(oldPath); // 读入原文件
				FileOutputStream fs = new FileOutputStream(newPath);
				byte[] buffer = new byte[1444];
				while ((byteread = inStream.read(buffer)) != -1) {
					bytesum += byteread; // 字节数 文件大小
					log.debug("复制文件的字节数：" + bytesum);
					fs.write(buffer, 0, byteread);
				}
				inStream.close();
				fs.close();
			}
		} catch (Exception e) {
			log.debug("报表功能，复制单个文件操作出错");
			e.printStackTrace();
		}
	}

	/**
	 * <pre>
	 * 根据查询结果集导出为Excel
	 * 方法dataToExcel的简要说明 
	 * 方法dataToExcel的详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2015年1月12日 下午5:18:50
	 * 
	 * @param resultList
	 * @param outputStream
	 * @return void 说明
	 * @throws IOException
	 * @throws FileNotFoundException
	 * @throws 异常类型说明
	 * </pre>
	 */
	public static void dataToExcel(List<Map<String, Object>> resultList, ServletOutputStream outputStream) throws FileNotFoundException, IOException {
		HSSFWorkbook wb = new HSSFWorkbook();
		String[] colum_name = null;
		String[] strArray = new String[1];
		HSSFCellStyle columnHeadStyle = wb.createCellStyle();

		// 样式设置
		HSSFFont columnHeadFont = wb.createFont();
		columnHeadFont.setFontName("微软雅黑");
		columnHeadFont.setFontHeightInPoints((short) 8);
		columnHeadFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		columnHeadStyle.setFont(columnHeadFont);
		columnHeadStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
		columnHeadStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
		columnHeadStyle.setLocked(true);
		columnHeadStyle.setWrapText(true);
		columnHeadStyle.setLeftBorderColor(HSSFColor.BLACK.index);// 左边框的颜色
		columnHeadStyle.setBorderLeft((short) 1);// 边框的大小
		columnHeadStyle.setRightBorderColor(HSSFColor.BLACK.index);// 右边框的颜色
		columnHeadStyle.setBorderRight((short) 1);// 边框的大小
		columnHeadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); // 设置单元格的边框为粗体
		columnHeadStyle.setBottomBorderColor(HSSFColor.BLACK.index); // 设置单元格的边框颜色
		// 设置单元格的背景颜色（单元格的样式会覆盖列或行的样式）
		columnHeadStyle.setFillForegroundColor(HSSFColor.WHITE.index);

		if (resultList.size() > 0) {
			colum_name = resultList.get(0).keySet().toArray(strArray);
			createRow(wb, "sheet1", 0, colum_name, columnHeadStyle);
			createRow(wb, "sheet1", 1, colum_name, columnHeadStyle);
			for (int i = 0; i < colum_name.length; i++) {
				wb.getSheetAt(0).addMergedRegion(new CellRangeAddress(0, 1, i, i));
			}
			wb.getSheetAt(0).createFreezePane(0, 1, 0, 2);
			dataToExcel(resultList, wb, colum_name, outputStream,"");
		}
	}
	
	public static void dataToExcel(List<Map<String, Object>> resultList, OutputStream outputStream) throws FileNotFoundException, IOException {
		HSSFWorkbook wb = new HSSFWorkbook();
		String[] colum_name = null;
		String[] strArray = new String[1];
		HSSFCellStyle columnHeadStyle = wb.createCellStyle();

		// 样式设置
		HSSFFont columnHeadFont = wb.createFont();
		columnHeadFont.setFontName("微软雅黑");
		columnHeadFont.setFontHeightInPoints((short) 8);
		columnHeadFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		columnHeadStyle.setFont(columnHeadFont);
		columnHeadStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
		columnHeadStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
		columnHeadStyle.setLocked(true);
		columnHeadStyle.setWrapText(true);
		columnHeadStyle.setLeftBorderColor(HSSFColor.BLACK.index);// 左边框的颜色
		columnHeadStyle.setBorderLeft((short) 1);// 边框的大小
		columnHeadStyle.setRightBorderColor(HSSFColor.BLACK.index);// 右边框的颜色
		columnHeadStyle.setBorderRight((short) 1);// 边框的大小
		columnHeadStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); // 设置单元格的边框为粗体
		columnHeadStyle.setBottomBorderColor(HSSFColor.BLACK.index); // 设置单元格的边框颜色
		// 设置单元格的背景颜色（单元格的样式会覆盖列或行的样式）
		columnHeadStyle.setFillForegroundColor(HSSFColor.WHITE.index);

		if (resultList.size() > 0) {
			colum_name = resultList.get(0).keySet().toArray(strArray);
			createRow(wb, "sheet1", 0, colum_name, columnHeadStyle);
			createRow(wb, "sheet1", 1, colum_name, columnHeadStyle);
			for (int i = 0; i < colum_name.length; i++) {
				wb.getSheetAt(0).addMergedRegion(new CellRangeAddress(0, 1, i, i));
			}
			wb.getSheetAt(0).createFreezePane(0, 1, 0, 2);
			dataToExcel(resultList, wb, colum_name, outputStream,"");
		}
	}

	/**
	 * <pre>
	 * 根据数据值填入整行数据
	 * 方法createRow的简要说明 
	 * 编写者：李晓亮
	 * 创建时间：2015年1月13日 下午2:28:59
	 * @param wb HSSFWorkbook
	 * @param rowNo 创建行数
	 * @param rowVal 行值
	 * @param style 样式控制
	 * @return void 说明
	 * @throws 异常类型   说明
	 * </pre>
	 */
	private static void createRow(HSSFWorkbook wb, String sheetName, int rowNo, String[] rowVal, HSSFCellStyle style) {
		HSSFSheet sheet = wb.getSheet(sheetName) == null ? wb.createSheet(sheetName) : wb.getSheet(sheetName);
		HSSFRow row = sheet.createRow(rowNo);
		for (int i = 0; i < rowVal.length; i++) {
			HSSFCell cell = row.createCell(i);
			cell.setCellValue(rowVal[i]);
			cell.setCellStyle(style);
		}
	}

	public static void dataToExcel(List<Map<String, Object>> resultMap, HSSFWorkbook wb, String[] columName, OutputStream out,String filePath) {
		// 设置字体
		HSSFCellStyle cellStyle = wb.createCellStyle();
		HSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) 8); // 字号
		// font.setBoldweight(HSSFFont.); //加粗
		font.setFontName("微软雅黑");
		cellStyle.setFont(font);
		//cellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		// excel工作表
		HSSFSheet sheet;
		try {
			int rows = resultMap.size();
			int page = 1;
            int rowd=2;
            if (filePath.indexOf("reportTotalGroupMenberNew")>=0){
            sheet = copyRows(wb.getSheetAt(0), wb, 0, 2, "page1");
			 rowd =3;}
            else{
            	sheet = copyRows(wb.getSheetAt(0), wb, 0, 1, "page1");
            	String a=filePath;
    			 rowd =2;
            }
			String valStr = "";
			for (int k = 0; k < rows; k++) {
				HSSFRow row = sheet.createRow(rowd);// 创建1行
				Map<String, Object> map = resultMap.get(k);
				for (int m = 0; m < columName.length; m++) {
					if (StringUtils.isBlank(columName[m]) || map.get(columName[m]) == null)
						continue;
					// 按导出列的名称取值
					valStr = map.get(columName[m]).toString();
					if (StringUtils.isBlank(valStr)) {
						valStr = ""; // 写入空字符到excel，不写入0
					}
					createCell(wb, row, m, valStr, cellStyle);
				}
				if (k == page * 60000) {
					sheet = copyRows(wb.getSheetAt(0), wb, 0, 1, "page" + (page + 1));
					page++;
					rowd = 1;
				}
				rowd++;
			}
			wb.removeSheetAt(0);

			// 向Excel中写入数据
			wb.write(out);
			out.close();
		} catch (FileNotFoundException e) {
			log.error("生成Exce异常,出现找不到文件", e);
		} catch (IOException e) {
			log.error("生成Excel出现IO异常", e);
		}
	}

}
