create or replace procedure p_get_law_code(i_dept_code    in char,
                                           i_line_code    in char default null,
                                           i_version_date in date default null,
                                           o_version_code out varchar2,
                                           o_version_name out varchar2) is
  v_dept_name varchar2(50);
  v_line_abbr varchar2(10);
  v_line_name varchar2(100);
  v_count_1   number(10);
begin

  -- Author  : sunyf
  -- Created : 2014-12-25
  -- Purpose : 基本法代码=业务线简称-部门代码-年份-三位序号

  begin
    --
    select t.dept_simple_name
      into v_dept_name
      from department t
     where t.dept_code = i_dept_code;

    --
    if (i_line_code is null) then
      v_line_abbr := upper('ALL');
    else
      select t.abbr_code, t.line_name
        into v_line_abbr, v_line_name
        from business_line t
       where t.line_code = i_line_code;
    end if;

    --
    if (i_version_date is null) then
      o_version_code := v_line_abbr || '-' || i_dept_code || '-' ||
                        to_char(sysdate, 'yyyy') || '-00001';
      o_version_name := v_dept_name || to_char(sysdate, 'yyyy') || '年' ||
                        v_line_name || '基本法';
    else
      --
      select count(1)
        into v_count_1
        from t_law_define t
       where t.line_code = v_line_abbr
         and t.dept_code = i_dept_code
         and trunc(t.law_bgn_date) = trunc(i_version_date);

      --
      o_version_code := v_line_abbr || '-' || i_dept_code || '-' ||
                        to_char(i_version_date, 'yyyy') || '-' ||
                        lpad(v_count_1 + 1, 5, 0);
      --
      o_version_name := v_dept_name || to_char(i_version_date, 'yyyy') || '年' ||
                        v_line_name || '基本法';
    end if;
  end;

end p_get_law_code;
/

