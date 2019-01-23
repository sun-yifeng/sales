create or replace package pkg_law_salesman is

  -- Author  : sunyf
  -- Created : 2014/11/26 16:53:04
  -- Purpose : 导入需要考核的人员

  --function
  function f_imp_salesman(i_version_id in char,
                          i_calc_month in char,
                          i_dept_code  in char,
                          i_line_code  in char,
                          i_user_name  in char,
                          i_task_id    in char) return number;

  function f_chk_salesman(i_version_id in char,
                          i_calc_month in char,
                          i_dept_code  in char,
                          i_line_code  in char,
                          i_user_name  in char,
                          i_task_id    in char) return number;

end pkg_law_salesman;
/
create or replace package body pkg_law_salesman is
  --检测考核人员团队，第一职级，第二职级是否配置正确
  function f_chk_salesman(i_version_id in char,
                          i_calc_month in char,
                          i_dept_code  in char,
                          i_line_code  in char,
                          i_user_name  in char,
                          i_task_id    in char) return number is
    v_func_name varchar2(30) := 'pkg_law_person.f_imp_person';
    v_last_day  date := last_day(to_date(i_calc_month, 'yyyymm'));
    v_count_2   number := 0; --判断团队是否有效
    v_count_3   number := 0; --判断第一职级是否有效
    v_count_4   number := 0; --判断第二职级时候有效
    --取出所有参加考核的销售人员，判断其所在的团队和设置的职级是否有效
    cursor check_salesmans is
      select t.salesman_code, --考核人员代码
             t.group_code, --考核人员团队
             t.sale_rank, --考核人员第一职级
             t.sale_rank_two --考核人员第二职级（如果该考核人员配置了第二职级）
        from salesman t
        left join t_law_rank_def t1
          on t.sale_rank = t1.rank_code
       where 1 = 1
         and t.valid_ind = '1'
         and t1.manager_flag in ('0', '1') --只导入客户经理和团队经理
         and t.process_status = '2' --已经处理的销售人员
            --and t.evaluate = '1' --是否参加考核
         and t.dept_code like i_dept_code || '%' --分公司
         and t.business_line = i_line_code --业务线
         and t.group_code is not null --团队不能为空
         and t.sale_rank is not null --职级不能为空
         and t.entry_date is not null --入职时间不能为空
         and t.front_date < trunc(v_last_day + 1) --在岗时间小余统计月份
         and t.dimission_date > to_date(i_calc_month,'yyyymm') --离职日期在考核月份之前
         and t.dept_code is not null --部门编号不能为空
         and t.salesman_flag = '1'; --只计算前台人员
    check_salesmans_row check_salesmans%rowtype;
  
  begin
    --判断其所在的团队和设置的职级是否有效
    for check_salesmans_row in check_salesmans loop
      --判断考核人员所在的团队是否有效
      select count(1)
        into v_count_2
        from group_main t
       where t.valid_ind = '1'
         and t.group_code = check_salesmans_row.group_code;
    
      --判断考核人员配置的第一职级是否有效
      select count(1)
        into v_count_3
        from t_law_rank_def t
       where t.valid_ind = '1'
         and t.version_id = i_version_id
         and t.item_status = '1' --分公司改职级使用状态为"不使用"
         and t.valid_ind = '1' --删除标志位
         and t.rank_code = check_salesmans_row.sale_rank;
    
      --如果该考核人员配置了第二职级，则需要判断该职级是否正在使用
      if (check_salesmans_row.sale_rank_two is not null) then
        select count(1)
          into v_count_4
          from t_law_rank_def t
         where t.valid_ind = '1'
           and t.version_id = i_version_id
           and t.item_status = '1' --分公司职级使用状态
           and t.valid_ind = '1' --删除标志位
           and t.rank_code = check_salesmans_row.sale_rank_two;
        if (v_count_2 <= 0 or v_count_3 <= 0 or v_count_4 <= 0) then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '考核销售人员：' || check_salesmans_row.salesman_code || ',团队,第一职级或者第二职级配置无效，请核实！',
                                sqlerrm);
        end if;
      else
        if (v_count_2 <= 0 or v_count_3 <= 0) then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '考核销售人员：' || check_salesmans_row.salesman_code || ',团队或者第一职级级配置无效，请核实！',
                                sqlerrm);
        end if;
      end if;
    end loop;
    return 1;
  end;

  --导入人员
  function f_imp_salesman(i_version_id in char,
                          i_calc_month in char,
                          i_dept_code  in char,
                          i_line_code  in char,
                          i_user_name  in char,
                          i_task_id    in char) return number is
    v_count_1   number := 0;
    v_func_name varchar2(30) := 'pkg_law_person.f_imp_person';
    v_last_day  date := last_day(to_date(i_calc_month, 'yyyymm'));
    v_result    number := 0;
  begin
    begin
      --检测考核人员团队，第一职级，第二职级是否配置正确
      v_result := f_chk_salesman(i_version_id, i_calc_month, i_dept_code, i_line_code, i_user_name, i_task_id);
      --清除人员
      delete from t_law_salesman t
       where 1 = 1
         and t.version_id = i_version_id
         and t.calc_month = i_calc_month
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code;
      --导入人员
      insert into t_law_salesman
        (pk_id,
         version_id,
         calc_month,
         bng_date,
         end_date,
         salesman_code,
         rank_code,
         manager_flag, --职级类型
         sale_rank_two, --允许团队长按客户经理考核的职级
         group_code,
         dept_code,
         busy_flag,
         line_code,
         created_user,
         created_date,
         updated_user,
         updated_date)
        select sys_guid() as pk_id,
               i_version_id as version_id, --基本法版本
               i_calc_month as calc_month, -- 格式:yyyymm
               to_date(i_calc_month, 'yyyymm') as bng_date, --
               v_last_day as end_date,
               t.salesman_code as salesman_code,
               t.sale_rank as rank_code,
               pkg_law_check.f_check_leader(t.sale_rank) as manager_flag, --职级类型
               t.sale_rank_two as sale_rank_two, --允许团队长按客户经理考核的职级
               t.group_code,
               i_dept_code as dept_code,
               0 as busy_flag, --busy_flag
               i_line_code as line_code, --业务线
               'admin' as created_user,
               sysdate as created_date,
               'admin' as updated_user,
               sysdate as updated_date
          from salesman t
          left join t_law_rank_def t1
            on t.sale_rank = t1.rank_code
         where 1 = 1
           and t.valid_ind = '1'
           and t1.manager_flag in ('0', '1') --只导入客户经理和团队经理
           and t.process_status = '2' --已经处理的销售人员
              --and t.evaluate = '1' --是否参加考核
           and t.dept_code like i_dept_code || '%' --分公司
           and t.business_line = i_line_code --业务线
           and t.group_code is not null --团队不能为空
           and t.sale_rank is not null --职级不能为空
           and t.entry_date is not null --入职时间不能为空
           and t.dimission_date > to_date(i_calc_month,'yyyymm') --离职日期在考核月份之前
           and t.front_date < trunc(v_last_day + 1) --在岗时间小余统计月份
           and t.dept_code is not null --部门编号不能为空
           and t.salesman_flag = '1' --只计算前台人员
        ;
    exception
      when others then
        rollback;
        pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '导入人员错误', sqlerrm);
        return - 1;
    end;
  
    --commit;
    commit;
  
    --统计导入多少人
    select count(1)
      into v_count_1
      from t_law_salesman t
     where 1 = 1
       and t.calc_month = i_calc_month
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.version_id = i_version_id;
    --
    pkg_law_log.log_info(v_func_name,
                         i_task_id,
                         i_user_name,
                         '参与计算的人员,分公司:' || i_dept_code || ',业务线:' || i_line_code || ',共' || v_count_1 || '人',
                         '');
    return v_result;
  end; --end function

end pkg_law_salesman;
/
