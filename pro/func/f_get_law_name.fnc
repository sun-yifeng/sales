create or replace function F_GET_LAW_NAME(i_dept_code in char, i_line_code in char) return varchar as
  v_dept_name varchar2(50);
  v_line_name varchar2(50);
begin

  -- Author  : sunyf
  -- Created : 2014-12-25
  -- Purpose : 基本法名称=分公司名称+业务线简称+年份+基本法
  -- Note    ：必须要选择业务线

  --取分公司简称
  select t.dept_simple_name into v_dept_name from department t where t.dept_code = i_dept_code;
  --取业务线简称
  select t.line_name into v_line_name from business_line t where t.line_code = i_line_code;
  --基本法版本名称
  return v_dept_name || v_line_name || '销售人员管理办法' || to_char(sysdate, 'yyyy') || '版';

end F_GET_LAW_NAME;
/

