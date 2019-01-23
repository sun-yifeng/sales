<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>系统访问记录</title>
<script type="text/javascript">
        $(document).ready(function() {
        	$("#onService_panel").hide();
        	$(".sele").css({"width":"250px"});
        	$("#button-search").omButton({icons:{left:'<%=_path%>/images/search.png'},width:50});
        	$("#button-dataToExcel").omButton({icons:{left:'<%=_path%>/images/op-edit.png'},width:57});
        	//提交按钮
        	$('#submitBtn').omButton({
        		width:100,
        		onClick:function(event){
        			var pkId = $("input[name='pkId']").val();
        			var parentPkid = $("input[name='parentPkid']").val();
        			var pageName =   $("input[name='pageName']").val();
        		    var pageCode =   $("input[name='pageCode']").val();
        		    var helpContent =   $("textarea[name='helpContent']").val();
        		    var basePath = Util.appCxtPath;
        		    $.ajax({ 
        				url: basePath+"/userHelpMsg/saveHelpMsg",
        				data:{
        				   pkId:pkId,
        				   parentPkid:parentPkid,
        				   pageName:pageName,
        				   pageCode:pageCode,
        				   helpContent:helpContent
        		        },
        				type:"post",
        				async: true,
        				dataType: "json",
        				success: function(jsonData){
        				    if(jsonData.actionFlag){
        				       alert("保存成功！");
        				       window.history.go(0);
        				    }else{
        				       alert("保存失败！");
        				    }
        				}
        		  });
        		}
        	});
        	//查询面板
        	$("#search-panel").omPanel({
            	title : "系统管理 > 帮助信息",
            	collapsible:true,
            	collapsed:false
            });	
        	
        	//页面排版
            var element = $('body').omBorderLayout({
           	   panels:[{
           	        id:"center-panel",
           	        closable:false,
           	     	header:true,
           	        title:"配置信息",
           	        region:"center"
           	    },{
           	        id:"west-panel",
           	        resizable:true,
           	        collapsible:true,
           	        title:"导航栏",
           	        closable:false,
           	        region:"west",
           	        width:220
           	    },{
           	        id:"north-panel",
           	        title:"搜索栏",
           	        height:'auto',
           	        header:false,
           	        closable:false,
           	        region:"north"
           	    }]
            });
            $("#north-panel").css("border","none");
            
            //工具栏
            $('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
            		      id:"addBtn" ,
            	 		  onClick:function(){alert('你点击了新增按钮！')}
            			},
            			{label:"删除",
              		      id:"delBtn" ,
              	 		  onClick:function(){alert('你点击了新增按钮！')}
              			}
            	]
            });
            
            //<!--------左边树结构-------->
            var data2 = [{id:"n1",text:"品牌",expanded:true},
                         {id:"n2",text:"运营商",expanded:true},
                         {id:"n11",pid:"n1",text:"三星"},
    			         {id:"n12",pid:"n1",text:"诺基亚"},
    			         {id:"n13",pid:"n1",text:"摩托罗拉"},
    			         {id:"n14",pid:"n1",text:"索尼"},
    			         {id:"n21",pid:"n2",text:"移动"},
    			         {id:"n22",pid:"n2",text:"联通"},
    			         {id:"n23",pid:"n2",text:"电信"}];
            $("#mytree2").omTree({
                dataSource:"<%=_path%>/userHelpMsg/getTreeList.do",
                simpleDataModel: true,
                onSelect: function(nodedata){
                	if(!nodedata.children && nodedata.text){
                		//避免在IE浏览器下出现中文乱码
                		$.ajax({
                			url:"<%=_path%>/userHelpMsg/getMsgDetail.do",
                			type:"post",
                			data:{
                				pkid:nodedata.id
                			},
                			dataType:'json',
                			success:function(jsonData){
                				$("input[name='pkId']").val(jsonData.pkId);
                			    $("input[name='parentPkid']").val(jsonData.parentPkid);
                			    $("input[name='pageName']").val(jsonData.pageName);
                			    $("input[name='pageCode']").val(jsonData.pageCode);
                			    $("#helpContent").text(jsonData.helpContent);
                			}
                		})
                	}else {
                		$("#grid").omGrid("setData", "griddata.do?method=fast");
                	}
                }
            });
        });
    </script>
</head>
<body>
   <div id="north-panel">
    <!-- 
     <form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">查询年月：</span></td>
					<td><input class="sele" name="formMap['actionDate']" id="actionDate" /></td>
					<td style="padding-left:15px"><span class="label">访问类型：</span></td>
					<td>
					   <input type="radio" name="formMap['accessType']" value="1" style="width:20px"/>数据访问记录&nbsp;
					   <input type="radio" name="formMap['accessType']" value="2" style="width:20px" />页面访问记录&nbsp;
					</td>
					<td colspan="4" align="right"><span id="button-search" onclick="query()">查询</span>
				</tr>
			</table>
		</div>
	  </form>
	 -->
	<!-- <div id="buttonbar" style="height:30px"></div> -->
    </div>
	<div id="west-panel">
    	<ul id="mytree2"></ul>
    </div>
	<div id="center-panel">
    	<form id="editMsgForm">
    	   <input type="hidden" name="pkId" id="pkId" />
    	   <input  type="hidden" name="parentPkid" id="parentPkid" />
		   <table>
			 <!--   <tr>
				  <td style="padding-left:15px;height:28px"><span class="label">上级页面：</span></td>
				  <td><input class="sele" name="parentPkid" id="parentPkid" />&nbsp;如果你编辑的页面属于某页面的子页面，请选择父级</td>
			   </tr> -->
			   <tr>
				  <td style="padding-left:15px;height:28px"><span class="label">页面名称：</span></td>
				  <td><input class="sele" name="pageName" id="pageName" />&nbsp;如：“管理办法内容页面”</td>
			   </tr>
			   <tr>
				  <td style="padding-left:15px;height:28px"><span class="label">页面代码：</span></td>
				  <td><input class="sele" name="pageCode" id="pageCode" style="background-color:#DCDCDC" readonly="readonly" />&nbsp;页面的识别码，一旦添加不能修改，如:'P002'</td>
			   </tr>
			   <tr>
				  <td style="padding-left:15px;height:28px"><span class="label">帮助信息：</span></td>
				  <td><textarea id="helpContent" name="helpContent" style="width:800px;height:240px;"></textarea></td>
			   </tr>
			   <tr>
				  <td colspan="2" align="center">
				     <span id="submitBtn" >保存</span>
				  </td>
			   </tr>
		   </table>
		</form>
    </div>
</body>
</html>