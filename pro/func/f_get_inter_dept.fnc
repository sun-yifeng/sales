create or replace function f_get_inter_dept(i_dept_code varchar2)
  return varchar2 is
  -- author  : sunyf
  -- created : 2014-12-12
  -- purpose : ��������ת��Ϊ�ڲ�����
  -- note    : �����ѯ�������������ݣ�HR��Ա��ѯ������������ȡ����
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

