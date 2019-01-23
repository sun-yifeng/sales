<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=_path%>/core/js/ref/bootstrap/css/bootstrap.min.css" media="screen" rel="stylesheet" type="text/css">
<link href="<%=_path%>/core/js/ref/bootstrap/css/bootstrap-combobox.css" media="screen" rel="stylesheet" type="text/css">
<title>自定义清单导出</title>
</head>
<body>
    <div class="container">
      <div class="row">
        <form action="<%=_path%>/reportCommon/excelExport">
          <fieldset>
            <legend>自定义清单导出</legend>
            <div class="control-group">
              <div class="controls">
                <select class="combobox input-large" name="queryId" required="required">
                  <option value="">请选择需导出清单</option>
                </select>
                <div style="width:250px">
		            <button class="btn btn-block btn-large btn-primary" type="submit">导  出</button>
                </div>
              </div>
            </div>
          </fieldset>
        </form>
      </div>
    </div>
    <script src="<%=_path%>/core/js/ref/bootstrap/js/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=_path%>/core/js/ref/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="<%=_path%>/core/js/ref/bootstrap/js/bootstrap-combobox.js" type="text/javascript"></script>
    <script src="<%=_path%>/core/js/huaanUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function(){
          $('.combobox').bsCombobox({dataSourse:'<%=_path%>/reportCommon/getOptions.do'});
        });
    </script>
</body>
</html>