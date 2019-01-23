create or replace procedure p_get_dept_virtual(i_parent_code in department.dept_code%type,
                                               o_dept_code   out department.dept_code%type,
                                               o_dept_name   out department.dept_cname%type,
                                               o_inter_code   out department.inter_code%type) is

begin

  -- Author  : sunyf
  -- Created : 2014-10-11
  -- Purpose : 自动生成虚拟机构的代码，虚拟机构的名称

  --declare
  declare
    v_count            number := -1;
    v_dept_simple_name department.dept_cname%type;
  begin
    --是否有虚拟机构
    select count(t.dept_code)
      into v_count
      from department t
     where t.parent_dept_code = i_parent_code
       and t.dept_code like '%' || upper('V') || '%';

    --取父机构的名称
    select t.dept_simple_name
      into v_dept_simple_name
      from department t
     where t.dept_code = i_parent_code;

    --无虚拟子机构
    if (v_count = 0) then
      if (length(i_parent_code) = 2) then
        o_dept_code := i_parent_code || upper('0V');
      elsif (length(i_parent_code) = 4) then
        o_dept_code := i_parent_code || upper('000V');
      else
        o_dept_code := i_parent_code || upper('000V');
      end if;
    --有虚拟子机构
    else
      --如果父机构是分公司
      if (length(i_parent_code) = 2) then
        select i_parent_code || to_char(substr(max(t.dept_code), 3, 1) + 1) ||
               upper('V')
          into o_dept_code
          from department t
         where t.parent_dept_code = i_parent_code
           and t.dept_code like '%' || upper('V') || '%';
      --如果父机构是支公司
      elsif (length(i_parent_code) = 4) then
        --如果父机构是虚拟机构
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
        --如果父机构非虚拟机构
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

    --机构名称
    if (length(i_parent_code) = 2) then
      o_dept_name := v_dept_simple_name || '本部';
    elsif (length(i_parent_code) = 4) then
      o_dept_name := v_dept_simple_name || '管部';
    else
      o_dept_name := v_dept_simple_name || '***部';
    end if;

    --机构内部码
    o_inter_code := '9' || o_dept_code;

    --dbms_output.put_line('code:' || o_dept_code || ',name:' || o_dept_name);
  end;
end p_get_dept_virtual;
/

