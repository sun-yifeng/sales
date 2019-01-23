create or replace function F_GET_LAW_NAME(i_dept_code in char, i_line_code in char) return varchar as
  v_dept_name varchar2(50);
  v_line_name varchar2(50);
begin

  -- Author  : sunyf
  -- Created : 2014-12-25
  -- Purpose : ����������=�ֹ�˾����+ҵ���߼��+���+������
  -- Note    ������Ҫѡ��ҵ����

  --ȡ�ֹ�˾���
  select t.dept_simple_name into v_dept_name from department t where t.dept_code = i_dept_code;
  --ȡҵ���߼��
  select t.line_name into v_line_name from business_line t where t.line_code = i_line_code;
  --�������汾����
  return v_dept_name || v_line_name || '������Ա����취' || to_char(sysdate, 'yyyy') || '��';

end F_GET_LAW_NAME;
/

