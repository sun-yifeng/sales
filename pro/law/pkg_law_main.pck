create or replace package PKG_LAW_MAIN is

  -- Author  : ADMINISTRATOR
  -- Created : 2014-10-8 15:19:30
  -- Purpose : 基本法调用入口

  -- function
  /*
  function f_run_main(i_exec_date    in date default null,
                      i_dept_code    in char default null,
                      i_line_code    in char default null,
                      i_version_id in char default null,
                      i_dump_flag    in boolean) return integer;
  */

  function f_run_main(i_exec_date  in date default null,
                      i_dept_code  in char default null,
                      i_line_code  in char default null,
                      i_version_id in char default null,
                      i_dump_flag  in boolean) return integer;

end PKG_LAW_MAIN;
/
create or replace package body pkg_law_main is

  -- 执行计算，按照分公司、业务线计算：
  -- 插入任务,导入人员,计算因素,计算指标,计算职级...
  function f_run_calc(i_calc_month in char,
                      i_dept_code  in char,
                      i_line_code  in char,
                      i_version_id in char,
                      i_user_name  in char,
                      i_task_id    in integer) return integer is
    v_return integer;
  begin
  
    --插入任务
    --v_return := f_add_task(i_stat_month, i_dept_code, i_line_code, i_version_id, i_user_name, i_task_id);
  
    --导入人员
    v_return := pkg_law_salesman.f_imp_salesman(i_version_id,
                                              i_calc_month,
                                              i_dept_code,
                                              i_line_code,
                                              i_user_name,
                                              i_task_id);
  
    /*--计算标保
    v_return := pkg_law_stand.f_stand_main(i_version_id,
                                            i_stat_month,
                                            i_dept_code,
                                            i_user_name,
                                            i_task_id);*/
  
    --计算因素
    if (v_return = 1) then
      v_return := pkg_law_sum.run(i_dept_code,
                                  i_line_code,
                                  i_version_id,
                                  i_calc_month,
                                  i_user_name, --
                                  i_task_id);
    end if;
  
    --计算指标
    if (v_return = 1) then
      v_return := pkg_law_wage.run(i_dept_code,
                                   i_line_code,
                                   i_version_id,
                                   i_calc_month,
                                   i_user_name, --
                                   i_task_id);
    end if;
  
    /*--计算职级
    if (v_return = 1) then
      v_return := pkg_law_assess.run_as_dept(
                                             i_stat_month,
                                             i_dept_code,
                                             i_line_code,
                                             i_user_name,
                                             i_task_id,
                                             i_version_id);
    end if;*/
  
    --插入结果
    if ((v_return = 1)) then
      v_return := pkg_law_result.f_insert_main(i_version_id,
                                               i_dept_code,
                                               i_line_code,
                                               i_calc_month,
                                               i_user_name,
                                               i_task_id);
    end if;
  
    /*更新任务
    if ((v_return = 1)) then
      --v_return := f_upd_task(i_stat_month, i_dept_code, i_version_id, i_user_name, i_task_id, 2);
    else
      v_return := f_upd_task(i_stat_month, i_dept_code, i_version_id, i_user_name, i_task_id, 3);
    end if;
    
    --确认信息
    v_return := f_add_confirm(i_stat_month, i_dept_code, i_version_id, i_user_name, i_task_id);
    */
  
    --
    return v_return;
  
  end;

  -- 功能：基本法程序的入口
  -- 参数：i_dump_flag 是否导入MIS的数据，所有的分公司、业务线每个月只导入一次
  --
  function f_run_main(i_exec_date  in date default null, -- 执行月
                      i_dept_code  in char default null, -- 分公司
                      i_line_code  in char default null, -- 业务线
                      i_version_id in char default null, -- 版本代码
                      i_dump_flag  in boolean -- 是否导入数据
                      ) return integer is
    v_return     integer;
    v_stat_month char(6);
    type cur_type is ref cursor;
    cur_law   cur_type;
    v_row_cur t_law_define%rowtype;
    v_sql_str varchar2(1000);
  begin
  
    if (i_exec_date is null) then
      v_stat_month := to_char(add_months(sysdate, -1), 'yyyymm');
    else
      v_stat_month := to_char(add_months(i_exec_date, -1), 'yyyymm');
    end if;
  
    /*--导入数据
    if (i_dump_flag) then
      v_return := pkg_law_mis.f_imp_main(v_stat_month,
                                         i_dept_code,
                                         i_line_code,
                                         '1',
                                         i_version_id,
                                         pkg_law_cons.c_user_name,
                                         pkg_law_cons.c_taks_id);
    end if;
    
    --取出基本法
    v_sql_str := 'select * from t_law_define t where t.valid_ind = ''1'' and t.version_status = ''1''';
    --分公司条件
    v_sql_str := v_sql_str || ' and t.dept_code = ''' || i_dept_code;
    --业务线条件
    v_sql_str := v_sql_str || ''' and t.line_code = ''' || i_line_code;
    --基本法代码
    v_sql_str := v_sql_str || ''' and t.version_id = ''' || i_version_id || '''';
    
    --执行计算
    begin
    
      pkg_law_log.log_info('pkg_law_main.f_run_main',
                           pkg_law_cons.c_taks_id,
                           pkg_law_cons.c_user_name,
                           '取出要执行的基本法',
                           v_sql_str);
    
      open cur_law for v_sql_str;
    
      loop
        fetch cur_law
          into v_row_cur;
        exit when cur_law%notfound;
    
        begin
          --
          v_return := f_run_calc(v_stat_month,
                                 v_row_cur.dept_code,
                                 v_row_cur.line_code,
                                 v_row_cur.version_id,
                                 pkg_law_cons.c_user_name,
                                 pkg_law_cons.c_taks_id);
        exception
          when others then
            rollback;
            v_return := -1;
            pkg_law_log.log_error('pkg_law_main.f_run_main',
                                  pkg_law_cons.c_taks_id,
                                  pkg_law_cons.c_user_name,
                                  '执行基本法计算出错',
                                  sqlerrm);
        end;
    
        pkg_law_log.log_info('pkg_law_main.f_run_main',
                             pkg_law_cons.c_taks_id,
                             pkg_law_cons.c_user_name,
                             '基本法' || v_row_cur.version_id || '执行完成',
                             '');
        commit;
    
      end loop;
    
      if cur_law%isopen = true then
        close cur_law;
      end if;
    
    end;*/
  
    return v_return;
  end;

end pkg_law_main;
/
