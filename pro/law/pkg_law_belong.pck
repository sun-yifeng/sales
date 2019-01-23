create or replace package pkg_law_belong is

  -- Author  : ADMINISTRATOR
  -- Created : 2016/7/6 15:29:20
  -- Purpose : 计算保单归属

  --按签单时间归属实收保费清单的团队
  function f_ply_group(i_dept_code in char, i_employ_code in char, i_sign_date in date) return varchar2;
  
  function f_clm_group(i_dept_code in char, i_employ_code in char, i_ply_no in char) return varchar2;

  procedure f_sale_check(i_sale_code in char);

  procedure p_sale_main(i_para_null in char);

end pkg_law_belong;
/
create or replace package body pkg_law_belong is

  --按签单时间归属实收清单的团队
  function f_ply_group(i_dept_code in char, i_employ_code in char, i_sign_date in date) return varchar2 is
    v_group_code varchar(50) := '';
    v_group_name varchar(50) := '';
  begin
    if ((i_employ_code is not null) and (regexp_like(i_employ_code, '(^[0-9])'))) then
      select max(t1.group_code)
        into v_group_code
        from group_menber t1
       where 1 = 1
         and t1.entry_date <= i_sign_date
         and t1.leave_date > i_sign_date
         and t1.employ_code = i_employ_code;
      --
      if (v_group_code is not null) then
        select max(t2.group_name)
          into v_group_name
          from group_main t2
         where 1 = 1
           and t2.group_type = '1'
           and t2.group_code = v_group_code;
      end if;
    end if;
    return v_group_name;
  end;

  --按核保时间归属理赔清单的团队
  function f_clm_group(i_dept_code in char, i_employ_code in char, i_ply_no in char) return varchar2 is
    v_udr_date  date;
    v_group_code varchar(50) := '';
    v_group_name varchar(50) := '';
  begin
    select min(t.t_udr_date)
      into v_udr_date
      from t_law_mis_pro_clm t
     where 1 = 1
       and t.c_dept_cde = i_dept_code
       and t.c_ply_no = i_ply_no;
    if (v_udr_date is not null) then
      if ((i_employ_code is not null) and (regexp_like(i_employ_code, '(^[0-9])'))) then
        select max(t1.group_code)
          into v_group_code
          from group_menber t1
         where 1 = 1
           and t1.entry_date <= v_udr_date
           and t1.leave_date > v_udr_date
           and t1.employ_code = i_employ_code;
        --
        if (v_group_code is not null) then
          select max(t2.group_name)
            into v_group_name
            from group_main t2
           where 1 = 1
             and t2.group_type = '1'
             and t2.group_code = v_group_code;
        end if;
      end if;
    end if;
    return v_group_name;
  end;

  --检查团队成员是否有交叉时间
  procedure f_sale_check(i_sale_code in char) is
    v_entry_date date;
    v_leave_date date;
    v_index_num  pls_integer;
    v_count_num  pls_integer;
    cursor c_sale is
      select t.entry_date, t.leave_date
        from group_menber t
       where 1 = 1
         and t.valid_ind = '1'
         and t.sales_code = i_sale_code
       order by t.entry_date desc;
    type type_arry is table of c_sale%rowtype index by pls_integer;
    type_arry_1 type_arry;
  begin
    open c_sale;
    fetch c_sale bulk collect
      into type_arry_1;
    close c_sale;
    --
    v_index_num := type_arry_1.first;
    while (v_index_num is not null) loop
      v_leave_date := type_arry_1(v_index_num).leave_date;
      v_index_num  := type_arry_1.next(v_index_num);
      if (v_index_num is not null) then
        v_entry_date := type_arry_1(v_index_num).entry_date;
        if (trunc(v_entry_date) - trunc(v_leave_date) <= 0) then
          v_count_num := nvl(v_count_num, 0) + 1;
          dbms_output.put_line(v_count_num || '团队成员数据有问题:''' || i_sale_code || ''',');
        end if;
      end if;
    end loop;
  end;

  procedure p_sale_main(i_para_null in char) is
  begin
    for c in (select distinct t.sales_code from group_menber t where t.valid_ind = '1') loop
      f_sale_check(c.sales_code);
    end loop;
  end;

end pkg_law_belong;
/
