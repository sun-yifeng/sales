create or replace function f_get_inter_dept(i_dept_code varchar2)
  return varchar2 is
  -- author  : sunyf
  -- created : 2014-12-12
  -- purpose : 机构代码转换为内部代码
  -- note    : 报表查询条件，导出数据，HR人员查询条件，基本法取数据
  v_inter_code varchar2(30);
begin
  --
  select t.inter_code
    into v_inter_code
    from department t
   where t.dept_code = i_dept_code;
  --
  return(v_inter_code);

end f_get_inter_dept;
/

