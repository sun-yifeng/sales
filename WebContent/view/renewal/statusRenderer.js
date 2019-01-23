 function statusRender(svalue)
{

//	dataSource : [{"text":"未下发","value":"0"},{"text":"分公司","value":"1"},{"text":"支公司","value":"2"},{"text":"团队经理","value":"3"},{"text":"客户经理","value":"4"}] ,
   	 if(svalue == "0")
		{  			
 			return "未下发";
		}else if (svalue == "1"){
			return "分公司";
		}else if (svalue == "2"){
			return "支公司";
		}
		else if (svalue == "3"){
			return "团队经理";
		}else
		{
			return "客户经理";
		}
   
}