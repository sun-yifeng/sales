function statusRender(svalue){
//{"text":"请选择","value":""},{"text":"草稿","value":"0"},{"text":"已终止","value":"9"}
	//{"text":"已发布","value":"1"},{"text":"执行结束","value":"3"},{"text":"待发布","value":"5"}
  	if(svalue == "0"){  			
 		return "草稿";
	}else if (svalue == "1"){
		return "已发布";
	}else if (svalue == "3"){
		return "执行结束";
	}else if(svalue=="5"){
		return "待发布";
	}else if(svalue=="9"){
		return "已终止";
	}
  	
   
}