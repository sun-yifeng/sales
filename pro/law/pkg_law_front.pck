create or replace package pkg_law_front is

  function f_begin_date(i_sale_code char) return date;

  procedure p_main(i_null_para char default null);
  
  procedure p_update_date(i_null_para char default null);
  
  procedure p_virtual_enddate(i_null_para char default null);

end pkg_law_front;
/
create or replace package body pkg_law_front is

  --算前台工作的时间起点
  function f_begin_date(i_sale_code char) return date is
    v_entry_date date;
    v_leave_date date;
    v_front_date date;
    v_enter_date date;
    v_front_flag varchar2(20);
    v_index_num  pls_integer;
    cursor c_sale is
      select t.inpositiondate,
             t.dimissiontime,
             t.enterdate,
             t.induedate,
             t.ifty,
             t.jobcategoryname
        from emp_base_info_extract t
       where t.account = i_sale_code
       order by t.inpositiondate desc;
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
      v_front_flag := type_arry_1(v_index_num).jobcategoryname;
      
      if (v_front_flag = '1') then
        v_entry_date := type_arry_1(v_index_num).inpositiondate;
        v_index_num  := type_arry_1.next(v_index_num);
        dbms_output.put_line('v_index_num :' || v_index_num);
        if (v_index_num is not null) then
          v_front_flag := type_arry_1(v_index_num).jobcategoryname;
           dbms_output.put_line('v_front_flag :' || v_front_flag);
          if (v_front_flag = '1') then
            v_leave_date := type_arry_1(v_index_num).dimissiontime;
            v_enter_date := type_arry_1(v_index_num -1).inpositiondate;  
            dbms_output.put_line('v_enter_date :' || v_enter_date);
            dbms_output.put_line('v_leave_date :' || v_leave_date);
            if ((trunc(v_leave_date) - trunc(v_front_date)) > 10) then
              v_front_date := v_entry_date;
               dbms_output.put_line('1 :'||  v_front_date);
            end if;
          else
            v_front_date := v_entry_date;
             dbms_output.put_line( '2 :' || v_front_date);
          end if;
        else
          v_front_date := v_entry_date;
           dbms_output.put_line('3 :'||v_front_date);
        end if;
      else
        return v_front_date;
      end if;
          
    end loop;
    return v_front_date;
  end;

  procedure p_main(i_null_para char default null) is
    v_count_1    integer := 0;
    v_front_date date;
  begin
    --
    update salesman t
       set t.front_date = t.contract_date
     where t.front_date is null;
    --
    for c in (select t2.account
                from emp_base_info_extract t2
               where 1 = 1
                 and t2.account in
                     (select t1.salesman_code
                        from salesman t1
                       where t1.salesman_flag = '1'
                         and t1.dimission_date > trunc(sysdate, 'yyyy'))
               group by t2.account
              having count(1) > 1) loop
      v_front_date := f_begin_date(c.account);
      update salesman t
         set t.front_date = v_front_date
       where t.salesman_code = c.account
         and t.front_date <> v_front_date;
      v_count_1 := v_count_1 + sql%rowcount;
    end loop;
    commit;
    --dbms_output.put_line('更新数目:' || v_count_1);
  end;

  --hr人员离职以后，将离职时间更新到团队离开时间
  procedure p_update_date(i_null_para char default null) is
    v_dimissdate date;
  begin
    for c_sales in (select t.sales_code
                      from group_menber t
                     where t.leave_date = date '2099-12-31') loop
      begin
        select t1.dimission_date
          into v_dimissdate
          from salesman t1
         where t1.salesman_code = c_sales.sales_code
           and t1.valid_ind = '1';
      exception
        when no_data_found then
          null;
      end;
      if (v_dimissdate < sysdate) then
        update group_menber t2
           set t2.leave_date   = v_dimissdate,
               t2.updated_date = sysdate,
               t2.updated_user = 'admin'
         where t2.sales_code = c_sales.sales_code
           and t2.leave_date = date '2099-12-31';
      end if;
    end loop;
    commit;
  end;
  
  --hr人员离职更新对应销售助理的挂靠结束时间
  procedure p_virtual_enddate(i_null_para char default null) is
    v_count integer := 0;
  begin
    for c_sales in (select t.salesman_code  salecode,
                           t.dimission_date dimissdate
                      from salesman t
                     where t.valid_ind = '1'
                       and t.process_status = '2') loop
      if (c_sales.dimissdate < sysdate) then
        for c_virtuals in (select t1.employ_code employcode, t1.end_date
                             from salesman_virtual_record t1
                            where t1.salesman_code = c_sales.salecode
                              and t1.valid_ind = '1') loop
          if (c_virtuals.end_date > c_sales.dimissdate) then
            update salesman_virtual_record t2
               set t2.end_date     = c_sales.dimissdate,
                   t2.updated_user = 'lucifer',
                   t2.updated_date = sysdate
             where t2.salesman_code = c_sales.salecode
               and t2.employ_code = c_virtuals.employcode;
            v_count := v_count + sql%rowcount;
          end if;
        end loop;
      end if;
    end loop;
    commit;
    dbms_output.put_line('更新的条目数:' || v_count);
  end;

end pkg_law_front;
/
