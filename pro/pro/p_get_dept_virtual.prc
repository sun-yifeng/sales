create or replace procedure p_get_dept_virtual(i_parent_code in department.dept_code%type,
                                               o_dept_code   out department.dept_code%type,
                                               o_dept_name   out department.dept_cname%type,
                                               o_inter_code   out department.inter_code%type) is

begin

  -- Author  : sunyf
  -- Created : 2014-10-11
  -- Purpose : �Զ�������������Ĵ��룬�������������

  --declare
  declare
    v_count            number := -1;
    v_dept_simple_name department.dept_cname%type;
  begin
    --�Ƿ����������
    select count(t.dept_code)
      into v_count
      from department t
     where t.parent_dept_code = i_parent_code
       and t.dept_code like '%' || upper('V') || '%';

    --ȡ������������
    select t.dept_simple_name
      into v_dept_simple_name
      from department t
     where t.dept_code = i_parent_code;

    --�������ӻ���
    if (v_count = 0) then
      if (length(i_parent_code) = 2) then
        o_dept_code := i_parent_code || upper('0V');
      elsif (length(i_parent_code) = 4) then
        o_dept_code := i_parent_code || upper('000V');
      else
        o_dept_code := i_parent_code || upper('000V');
      end if;
    --�������ӻ���
    else
      --����������Ƿֹ�˾
      if (length(i_parent_code) = 2) then
        select i_parent_code || to_char(substr(max(t.dept_code), 3, 1) + 1) ||
               upper('V')
          into o_dept_code
          from department t
         where t.parent_dept_code = i_parent_code
           and t.dept_code like '%' || upper('V') || '%';
      --�����������֧��˾
      elsif (length(i_parent_code) = 4) then
        --������������������
        if (substr(i_parent_code, 4, 1) = upper('V')) then
          select i_parent_code ||
                 substr(replace(substr(max(t.dept_code), 4, 5),
                                upper('V'),
                                '1') + 1,
                        2,
                        4)
            into o_dept_code
            from department t
           where t.parent_dept_code = i_parent_code
             and t.dept_code like '%' || upper('V') || '%';
        --������������������
        else
          select i_parent_code ||
                 substr(('1' || substr(max(t.dept_code), 2, 6)) + 1 ||
                        upper('V'),
                        5,
                        4)
            into o_dept_code
            from department t
           where t.parent_dept_code = i_parent_code
             and t.dept_code like '%' || upper('V') || '%';
        end if;
      else
        o_dept_code := i_parent_code || upper('000V');
      end if;
    end if;

    --��������
    if (length(i_parent_code) = 2) then
      o_dept_name := v_dept_simple_name || '����';
    elsif (length(i_parent_code) = 4) then
      o_dept_name := v_dept_simple_name || '�ܲ�';
    else
      o_dept_name := v_dept_simple_name || '***��';
    end if;

    --�����ڲ���
    o_inter_code := '9' || o_dept_code;

    --dbms_output.put_line('code:' || o_dept_code || ',name:' || o_dept_name);
  end;
end p_get_dept_virtual;
/

