package com.sinosafe.xszc.util;

import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
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
public class ExportExcelNew {

	private static final Log log = LogFactory.getLog(CommonController.class);

	

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
				if ( "直接业务".equals(map.get("C_BSNS")) ) {
					directList.add(map);
				} else if ("间接业务".equals(map.get("C_BSNS"))) {
					if ("19002代理业务".equals(map.get("C_BSNS_TYP"))) {
						arg[0]++;
					} else if ("19003经纪业务".equals(map.get("C_BSNS_TYP"))) {
						arg[1]++;
					}
					indirectList.add(map);
				}else if("其他业务".equals(map.get("C_BSNS"))) {
					
					arg1[0]++;
					otherList.add(map);
				}
				
				else if (map.get("C_BSNS") == null) {
					Total.add(map);
				} 
			}
			HSSFRow directRows;
			//直接业务LIST循环
			for (int i = 0; i < directList.size(); i++) {
				Map<String, Object> map = directList.get(i);
				if (i == 0) {
					sheet.addMergedRegion(new CellRangeAddress(2, (directList.size() + 1), (short) 0, (short) 0));
					directRows = sheet.createRow(2);

					HSSFCell cellHead = directRows.createCell(0);
					//第一列
					cellHead.setCellValue("直接业务");
					cellHead.setCellStyle(style);
					//第二列和第三列
					
					if (map.get("C_BSNS_TYP") != null){
						HSSFCell cellcBsnsTyp = directRows.createCell(1);
						cellcBsnsTyp.setCellValue(map.get("C_BSNS_TYP").toString());
					cellcBsnsTyp.setCellStyle(style);}

					
					if (map.get("CHANNEL_TYPE") != null){
						 HSSFCell cellcChaType= directRows.createCell(2);
					cellcChaType.setCellValue(map.get("CHANNEL_TYPE").toString());
						cellcChaType.setCellStyle(style);}
					writeRows(map, directRows, style);
					//直接业务的最后一行---小计
				}else if(i==(directList.size()-1)){
					//第二列和第三列合并
					sheet.addMergedRegion(new CellRangeAddress((i + 2), (i + 2), (short) 1, (short) 2));
					directRows = sheet.createRow(i + 2);
					
					if (map.get("C_BSNS_TYP") == null){
						HSSFCell cellcBsnsTyp = directRows.createCell(1);
						cellcBsnsTyp.setCellValue("小计");
					cellcBsnsTyp.setCellStyle(style);}
					writeRows(map, directRows, style);
				}
				
				else {
					directRows = sheet.createRow(i + 2);
					//第二列
					HSSFCell cellcBsnsTyp = directRows.createCell(1);
					if (map.get("C_BSNS_TYP") != null){
						cellcBsnsTyp.setCellValue(map.get("C_BSNS_TYP").toString());
					cellcBsnsTyp.setCellStyle(style);
                     //第三列
					}
					if (map.get("CHANNEL_TYPE") != null){
						HSSFCell cellcChaType = directRows.createCell(2);
						cellcChaType.setCellValue(map.get("CHANNEL_TYPE").toString());
					cellcChaType.setCellStyle(style);}
					writeRows(map, directRows, style);
				}
			}
             //间接业务LIST循环
			for (int i = 0; i < indirectList.size(); i++) {
				Map<String, Object> map = indirectList.get(i);
				if (i == 0) {
					directRows = sheet.createRow(directList.size() + 2);
                   //间接业务LIST的第一列
					HSSFCell cellHead1 = directRows.createCell(0);
					cellHead1.setCellValue("间接业务");
					cellHead1.setCellStyle(style);
					sheet.addMergedRegion(new CellRangeAddress(directList.size() + 2, (directList.size() + indirectList.size() + 1), 0, 0));
                    //第二列
					sheet.addMergedRegion(new Region(directList.size() + 2, (short) 1, (directList.size() + arg[0] + 1), (short) 1));
					HSSFCell cellcBsnsTyp = directRows.createCell(1);
					cellcBsnsTyp.setCellValue("19002代理业务");
					cellcBsnsTyp.setCellStyle(style);
					//第三列
					
					if (map.get("CHANNEL_TYPE") != null){
						HSSFCell cellcChaType = directRows.createCell(2);
						cellcChaType.setCellValue(map.get("CHANNEL_TYPE").toString());
						cellcChaType.setCellStyle(style);
					writeRows(map, directRows, style);}
				} else  if 
					 (i == (arg[0]-1)) {
						directRows = sheet.createRow(directList.size() + arg[0] + 1);

						
						if (map.get("CHANNEL_TYPE") == null){
							//第三列
							HSSFCell cellcChaType = directRows.createCell(2);
							HSSFCell cellcChaType1 = directRows.createCell(1);
							cellcChaType.setCellValue("小计");
							cellcChaType.setCellStyle(style);
							cellcChaType1.setCellStyle(style);
						writeRows(map, directRows, style);}
					} else if(i ==arg[0])
					{
						directRows = sheet.createRow(directList.size() + arg[0] + 2);
				       
				    if (map.get("C_BSNS_TYP") != null){
				    	  //第二列
					    HSSFCell cellcBsnsTyp = directRows.createCell(1);
					cellcBsnsTyp.setCellValue(map.get("C_BSNS_TYP").toString());
				cellcBsnsTyp.setCellStyle(style);}
                
				if (map.get("CHANNEL_TYPE") != null){
					 //第三列
					HSSFCell cellcChaType = directRows.createCell(2);
					cellcChaType.setCellValue(map.get("CHANNEL_TYPE").toString());
					cellcChaType.setCellStyle(style);}
				    writeRows(map, directRows, style);
					}
				
					else if(i==(indirectList.size()-1)){
						sheet.addMergedRegion(new CellRangeAddress((directList.size() + indirectList.size() + 1), (directList.size() + indirectList.size() + 1), (short) 1, (short) 2));
						directRows = sheet.createRow(directList.size() + indirectList.size() + 1);
						
						if (map.get("C_BSNS_TYP") == null){
							HSSFCell cellcBsnsTyp = directRows.createCell(1);
							HSSFCell cellcBsnsTyp2 = directRows.createCell(2);
							cellcBsnsTyp.setCellValue("小计");
						cellcBsnsTyp.setCellStyle(style);
						cellcBsnsTyp2.setCellStyle(style);
						
						writeRows(map, directRows, style);}
					}
					else  {
						directRows = sheet.createRow(directList.size() + i + 2);
						
						
						if (map.get("C_BSNS_TYP") != null){
							//第二列
							HSSFCell cellcBsnsTyp = directRows.createCell(1);
							cellcBsnsTyp.setCellValue(map.get("C_BSNS_TYP").toString());
						cellcBsnsTyp.setCellStyle(style);}
	                    
						if (map.get("CHANNEL_TYPE") != null){
							 //第三列
							HSSFCell cellcChaType = directRows.createCell(2);
							cellcChaType.setCellValue(map.get("CHANNEL_TYPE").toString());
						cellcChaType.setCellStyle(style);}
						writeRows(map, directRows, style);
					}
				}
			
            //其他业务循环
			for (int i = 0; i < otherList.size(); i++) {
				if(arg1[0]>0){
				Map<String, Object> map = otherList.get(i);
				
                //间接业务LIST的第一列
					
					sheet.addMergedRegion(new CellRangeAddress(directList.size() +indirectList.size()+ 2, directList.size() +indirectList.size()+ 2, (short) 0, (short) 2));
					directRows = sheet.createRow(directList.size() +indirectList.size()+ 2);
					HSSFCell cellHead1 = directRows.createCell(0);
					cellHead1.setCellValue("其他业务");
					cellHead1.setCellStyle(style);
					writeRows(map, directRows, style);
				}}

			for (int i = 0; i < Total.size(); i++) {
				
					Map<String, Object> map = Total.get(i);
					directRows = sheet.createRow(directList.size() +indirectList.size()+otherList.size()+ 2);
	                //间接业务LIST的第一列
						
						sheet.addMergedRegion(new CellRangeAddress(directList.size() +indirectList.size()+otherList.size()+ 2, directList.size() +indirectList.size()+otherList.size()+ 2, (short) 0, (short) 2));
						HSSFCell cellHead0 = directRows.createCell(0);
						HSSFCell cellHead1 = directRows.createCell(1);
						HSSFCell cellHead2 = directRows.createCell(2);
						cellHead0.setCellStyle(style);
						cellHead0.setCellValue("合计");
						cellHead1.setCellStyle(style);
						cellHead2.setCellStyle(style);
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
		
	}

	@SuppressWarnings("deprecation")
	private static void initTableHead(HSSFSheet sheet, HSSFCellStyle style) {
		HSSFRow row1 = sheet.createRow(0);
		HSSFRow row2 = sheet.createRow(1);

		sheet.addMergedRegion(new Region(0, (short) 0, 1, (short) 2)); // 设置第一行表头
		HSSFCell cell1 = row1.createCell(0);
		cell1.setCellValue("业务来源");
		cell1.setCellStyle(style);

		

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
		HSSFCell cell47 = row1.createCell(47);
		cell17.setCellValue("合计(元)");
		cell17.setCellStyle(style);
		cell47.setCellStyle(style);

		HSSFCell cell17r1 = row2.createCell(45);
		cell17r1.setCellValue("保费收入");
		cell17r1.setCellStyle(style);

		HSSFCell cell17r2 = row2.createCell(46);
		cell17r2.setCellValue("手续费及佣金");
		cell17r2.setCellStyle(style);

		HSSFCell cell17r3 = row2.createCell(47);
		cell17r3.setCellValue("实付佣金");
		cell17r3.setCellStyle(style);

		
	}

	private static void writeRows(Map<String, Object> map, HSSFRow directRows, HSSFCellStyle style) {
		// HSSFCell cellcBsnsTyp = directRows.createCell(2);
		// cellcBsnsTyp.setCellValue(map.get("cBsnsTyp").toString());
		// cellcBsnsTyp.setCellStyle(style);

		

		HSSFCell cellcompTakeIn = directRows.createCell(3);
		if (map.get("qcxprmtotal") != null)
			cellcompTakeIn.setCellValue(map.get("qcxprmtotal").toString());
		cellcompTakeIn.setCellStyle(style);

		HSSFCell cellcompCommision = directRows.createCell(4);
		if (map.get("qcxcmmamt") != null)
			cellcompCommision.setCellValue(map.get("qcxcmmamt").toString());
		cellcompCommision.setCellStyle(style);

		HSSFCell cellcompRealCommision = directRows.createCell(5);
		if (map.get("qcxpaidamt") != null)
			cellcompRealCommision.setCellValue(map.get("qcxpaidamt").toString());
		cellcompRealCommision.setCellStyle(style);

		HSSFCell cellfarmTakeIn = directRows.createCell(6);
		if (map.get("jtprmtotal") != null)
			cellfarmTakeIn.setCellValue(map.get("jtprmtotal").toString());
		cellfarmTakeIn.setCellStyle(style);

		HSSFCell cellfarmCommision = directRows.createCell(7);
		if (map.get("jtcmmamt") != null)
			cellfarmCommision.setCellValue(map.get("jtcmmamt").toString());
		cellfarmCommision.setCellStyle(style);

		HSSFCell cellfarmRealCommision = directRows.createCell(8);
		if (map.get("jtpaidamt") != null)
			cellfarmRealCommision.setCellValue(map.get("jtpaidamt").toString());
		cellfarmRealCommision.setCellStyle(style);

		HSSFCell cellbusiTakeIn = directRows.createCell(9);
		if (map.get("syxprmtotal") != null)
			cellbusiTakeIn.setCellValue(map.get("syxprmtotal").toString());
		cellbusiTakeIn.setCellStyle(style);

		HSSFCell cellbusiCommision = directRows.createCell(10);
		if (map.get("syxcmmamt") != null)
			cellbusiCommision.setCellValue(map.get("syxcmmamt").toString());
		cellbusiCommision.setCellStyle(style);

		HSSFCell cellbusiRealCommision = directRows.createCell(11);
		if (map.get("syxpaidamt") != null)
			cellbusiRealCommision.setCellValue(map.get("syxpaidamt").toString());
		cellbusiRealCommision.setCellStyle(style);

		HSSFCell celltransTakeIn = directRows.createCell(12);
		if (map.get("jqxprmtotal") != null)
			celltransTakeIn.setCellValue(map.get("jqxprmtotal").toString());
		celltransTakeIn.setCellStyle(style);

		HSSFCell celltransCommision = directRows.createCell(13);
		if (map.get("jqxcmmamt") != null)
			celltransCommision.setCellValue(map.get("jqxcmmamt").toString());
		celltransCommision.setCellStyle(style);

		HSSFCell celltransRealCommision = directRows.createCell(14);
		if (map.get("jqxpaidamt") != null)
			celltransRealCommision.setCellValue(map.get("jqxpaidamt").toString());
		celltransRealCommision.setCellStyle(style);

		HSSFCell cellprojectTakeIn = directRows.createCell(15);
		if (map.get("gcxprmtotal") != null)
			cellprojectTakeIn.setCellValue(map.get("gcxprmtotal").toString());
		cellprojectTakeIn.setCellStyle(style);

		HSSFCell cellprojectCommision = directRows.createCell(16);
		if (map.get("gcxcmmamt") != null)
			cellprojectCommision.setCellValue(map.get("gcxcmmamt").toString());
		cellprojectCommision.setCellStyle(style);

		HSSFCell cellprojectRealCommision = directRows.createCell(17);
		if (map.get("gcxpaidamt") != null)
			cellprojectRealCommision.setCellValue(map.get("gcxpaidamt").toString());
		cellprojectRealCommision.setCellStyle(style);

		HSSFCell celldutyTakeIn = directRows.createCell(18);
		if (map.get("zrxprmtotal") != null)
			celldutyTakeIn.setCellValue(map.get("zrxprmtotal").toString());
		celldutyTakeIn.setCellStyle(style);

		HSSFCell celldutyCommision = directRows.createCell(19);
		if (map.get("zrx_cmm_amt") != null)
			celldutyCommision.setCellValue(map.get("zrx_cmm_amt").toString());
		celldutyCommision.setCellStyle(style);

		HSSFCell celldutyRealCommision = directRows.createCell(20);
		if (map.get("zrxpaidamt") != null)
			celldutyRealCommision.setCellValue(map.get("zrxpaidamt").toString());
		celldutyRealCommision.setCellStyle(style);

		HSSFCell cellcreditTakeIn = directRows.createCell(21);
		if (map.get("xybzprmtotal") != null)
			cellcreditTakeIn.setCellValue(map.get("xybzprmtotal").toString());
		cellcreditTakeIn.setCellStyle(style);

		HSSFCell cellcreditCommision = directRows.createCell(22);
		if (map.get("xybzcmmamt") != null)
			cellcreditCommision.setCellValue(map.get("xybzcmmamt").toString());
		cellcreditCommision.setCellStyle(style);

		HSSFCell cellcreditRealCommision = directRows.createCell(23);
		if (map.get("xybzpaidamt") != null)
			cellcreditRealCommision.setCellValue(map.get("xybzpaidamt").toString());
		cellcreditRealCommision.setCellStyle(style);

		HSSFCell cellguaranteeTakeIn = directRows.createCell(24);
		if (map.get("bzbzprmtotal") != null)
			cellguaranteeTakeIn.setCellValue(map.get("bzbzprmtotal").toString());
		cellguaranteeTakeIn.setCellStyle(style);

		HSSFCell cellguaranteeCommision = directRows.createCell(25);
		if (map.get("bzbzcmmamt") != null)
			cellguaranteeCommision.setCellValue(map.get("bzbzcmmamt").toString());
		cellguaranteeCommision.setCellStyle(style);

		HSSFCell cellguaranteeRealCommision = directRows.createCell(26);
		if (map.get("bzbzpaidamt") != null)
			cellguaranteeRealCommision.setCellValue(map.get("bzbzpaidamt").toString());
		cellguaranteeRealCommision.setCellStyle(style);

		HSSFCell cellshipTakeIn = directRows.createCell(27);
		if (map.get("cbxprmtotal") != null)
			cellshipTakeIn.setCellValue(map.get("cbxprmtotal").toString());
		cellshipTakeIn.setCellStyle(style);

		HSSFCell cellshipCommision = directRows.createCell(28);
		if (map.get("cbxcmmamt") != null)
			cellshipCommision.setCellValue(map.get("cbxcmmamt").toString());
		cellshipCommision.setCellStyle(style);

		HSSFCell cellshipRealCommision = directRows.createCell(29);
		if (map.get("cbxpaidamt") != null)
			cellshipRealCommision.setCellValue(map.get("cbxpaidamt").toString());
		cellshipRealCommision.setCellStyle(style);

		HSSFCell cellcargoTakeIn = directRows.createCell(30);
		if (map.get("hyxprmtotal") != null)
			cellcargoTakeIn.setCellValue(map.get("hyxprmtotal").toString());
		cellcargoTakeIn.setCellStyle(style);

		HSSFCell cellcargoCommision = directRows.createCell(31);
		if (map.get("hyxcmmamt") != null)
			cellcargoCommision.setCellValue(map.get("hyxcmmamt").toString());
		cellcargoCommision.setCellStyle(style);

		HSSFCell cellcargoRealCommision = directRows.createCell(32);
		if (map.get("hyxpaidamt") != null)
			cellcargoRealCommision.setCellValue(map.get("hyxpaidamt").toString());
		cellcargoRealCommision.setCellStyle(style);

		HSSFCell cellspecialTakeIn = directRows.createCell(33);
		if (map.get("tsxprmtotal") != null)
			cellspecialTakeIn.setCellValue(map.get("tsxprmtotal").toString());
		cellspecialTakeIn.setCellStyle(style);

		HSSFCell cellspecialCommision = directRows.createCell(34);
		if (map.get("tsxcmmamt") != null)
			cellspecialCommision.setCellValue(map.get("tsxcmmamt").toString());
		cellspecialCommision.setCellStyle(style);

		HSSFCell cellspecialRealCommision = directRows.createCell(35);
		if (map.get("tsxpaidamt") != null)
			cellspecialRealCommision.setCellValue(map.get("tsxpaidamt").toString());
		cellspecialRealCommision.setCellStyle(style);

		HSSFCell cellfarmingTakeIn = directRows.createCell(36);
		if (map.get("nyxprmtotal") != null)
			cellfarmingTakeIn.setCellValue(map.get("nyxprmtotal").toString());
		cellfarmingTakeIn.setCellStyle(style);

		HSSFCell cellfarmingCommision = directRows.createCell(37);
		if (map.get("nyxcmmamt") != null)
			cellfarmingCommision.setCellValue(map.get("nyxcmmamt").toString());
		cellfarmingCommision.setCellStyle(style);

		HSSFCell cellfarmingRealCommision = directRows.createCell(38);
		if (map.get("nyxpaidamt") != null)
			cellfarmingRealCommision.setCellValue(map.get("nyxpaidamt").toString());
		cellfarmingRealCommision.setCellStyle(style);

		HSSFCell cellhealthTakeIn = directRows.createCell(39);
		if (map.get("jkxprmtotal") != null)
			cellhealthTakeIn.setCellValue(map.get("jkxprmtotal").toString());
		cellhealthTakeIn.setCellStyle(style);

		HSSFCell cellhealthCommision = directRows.createCell(40);
		if (map.get("jkxcmmamt") != null)
			cellhealthCommision.setCellValue(map.get("jkxcmmamt").toString());
		cellhealthCommision.setCellStyle(style);

		HSSFCell cellhealthRealCommision = directRows.createCell(41);
		if (map.get("jkxpaidamt") != null)
			cellhealthRealCommision.setCellValue(map.get("jkxpaidamt").toString());
		cellhealthRealCommision.setCellStyle(style);

		HSSFCell cellhurtTakeIn = directRows.createCell(42);
		if (map.get("ywxprmtotal") != null)
			cellhurtTakeIn.setCellValue(map.get("ywxprmtotal").toString());
		cellhurtTakeIn.setCellStyle(style);

		HSSFCell cellhurtCommision = directRows.createCell(43);
		if (map.get("ywxcmmamt") != null)
			cellhurtCommision.setCellValue(map.get("ywxcmmamt").toString());
		cellhurtCommision.setCellStyle(style);

		HSSFCell cellhurtRealCommision = directRows.createCell(44);
		if (map.get("ywxpaidamt") != null)
			cellhurtRealCommision.setCellValue(map.get("ywxpaidamt").toString());
		cellhurtRealCommision.setCellStyle(style);

		HSSFCell cellotherTakeIn = directRows.createCell(45);
		if (map.get("rpprmtotal") != null)
			cellotherTakeIn.setCellValue(map.get("rpprmtotal").toString());
		cellotherTakeIn.setCellStyle(style);

		HSSFCell cellotherCommision = directRows.createCell(46);
		if (map.get("ncmmamt") != null)
			cellotherCommision.setCellValue(map.get("ncmmamt").toString());
		cellotherCommision.setCellStyle(style);

		HSSFCell cellotherRealCommision = directRows.createCell(47);
		if (map.get("npaidamt") != null)
			cellotherRealCommision.setCellValue(map.get("npaidamt").toString());
		cellotherRealCommision.setCellStyle(style);

		
	}

	
}
