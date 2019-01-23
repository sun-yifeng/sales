   
function deptdrop(_path) {
     return false;
	//树形机构，异步加载
    $("#deptDropListTree").omTree({
        dataSource : _path+ "/department/queryDeptDropList.do",
	    simpleDataModel:true,
	    //
	    onBeforeExpand : function(node){
		  var nodeDom = $("#"+node.nid);
		  if(nodeDom.hasClass("hasChildren")){
			nodeDom.removeClass("hasChildren");
			$.ajax({
				url: _path+ '/department/queryDeptDropList.do?parentCode='+node.id,
				method: 'POST',
				dataType: 'json',
				success: function(data){
					$("#deptDropListTree").omTree("insert", data, node);
				}
			});
		 }
		return true;
	   },
	   //触发选择事件时，回填数据到输入框
       onSelect : function(nodedata) {
         var ndata = nodedata, text = ndata.text;
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }

         $("#deptCname").val(text); //填充部门名称
         $("#publishDeptCode").val(nodedata.id); //填充部门代码

         //
         hideDropList();
       },
       //
       onBeforeSelect : function(nodedata) {
         if (nodedata.children) {
	        return true;
         }
       }
   });
    
   //点击下拉按钮
   $("#choose").click(function() {
      showDropList();
   });
   
   //点击输入框
   $("#deptCname").click(function() {
      showDropList();
   });
   
   
     //显示下来框
   function showDropList() {
	  var cityInput = $("#deptCname");
   	  var cityOffset = cityInput.offset();
   	  var topnum = cityOffset.top+cityInput.outerHeight()-2;
   	  var leftnum = cityOffset.left-1;
   	  
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	  topnum = topnum + 2;
      }
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"})
      						.show();
      //body绑定mousedown事件
      $("body").bind("mousedown", onBodyDown);
   }
   
   //隐藏下来框
   function hideDropList() {
      $("#deptDropListTree").hide();
      $("body").unbind("mousedown", onBodyDown);
   }
   
  
   
   //
   function onBodyDown(event) {
      if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
	       hideDropList();
        }
   }
   
}
