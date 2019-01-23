create or replace package pkg_law_manual is

  /*
  存过开发规范
  1、变量命名规则，以v开头，比如：v_count;
  2、参数命名规则，入参以i开头，比如i_version_id,出参以o开头，比如o_result，既可以
  */

  -- author  : sunyf
  -- created : 2015-07-24
  -- purpose : 手动执行计算

  procedure run(i_version_id  in char,
                i_calc_month  in char,
                i_dept_code   in char,
                i_line_code   in char,
                i_user_name   in char,
                o_result_flag out varchar2);

  -- 手动执行计算，第1步：导入MIS数据
  procedure run_manual_step1(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- 手动执行计算，第2步：导入销售人员
  procedure run_manual_step2(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- 手动执行计算，第3步：计算标准保费
  procedure run_manual_step3(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- 手动执行计算，第4步：计算因素
  procedure run_manual_step4(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- 手动执行计算，第5步：计算公式
  procedure run_manual_step5(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- 手动执行计算，第6步：计算评分
  procedure run_manual_step6(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);

  -- 手动执行计算，第7步：计算职级
  procedure run_manual_step7(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);

  --开始执行前更新t_law_define_manual状态
  procedure p_bgn_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in char,
                         i_result_msg  in char);

  --执行后更新t_law_define_manual状态
  procedure p_end_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in out char,
                         i_result_msg  in char);
                         
  function f_get_status(i_version_id in char, --
                        i_calc_month in char, --
                        i_task_code  in char) return varchar2;
end pkg_law_manual;
/
create or replace package body pkg_law_manual is

  /***********************************状态说明***********************************************
    任务代码(1导入MIS数据,2取销售人员,3计算标保,4计算因素,5计算公式,6计算评分,7计算职级)
    任务状态(1未开始,2正在执行,3执行完成,9执行失败)
  *******************************************************************************************/

  procedure run(i_version_id  in char,
                i_calc_month  in char,
                i_dept_code   in char,
                i_line_code   in char,
                i_user_name   in char,
                o_result_flag out varchar2) is
  v_task_status char(1) := '';                                
  begin
    --取参与计算的销售人员
    run_manual_step2(i_version_id,
                     i_calc_month,
                     i_dept_code,
                     i_line_code,
                     i_user_name,
                     o_result_flag --
                     );
  
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '2');
    --计算标准保费
    if (o_result_flag = 1 and v_task_status = '3' )then
      run_manual_step3(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
  
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '3');
    --计算销售人员的各项因素
    if (o_result_flag = 1 and v_task_status = '3' ) then
      run_manual_step4(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
    
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '4');
    --计算销售人员的各项指标及薪酬
    if (o_result_flag = 1 and v_task_status = '3' ) then
      run_manual_step5(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
    
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '4');
    --计算销售人员的各项评分
    if (o_result_flag = 1 and v_task_status = '3' ) then
      run_manual_step6(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
  
    --计算销售人员的职级
    if o_result_flag = 1 then
      run_manual_step7(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
  end run;

  --导入MIS数据
  procedure run_manual_step1(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code char(1) := '1'; --任务代码
    v_task_id   varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --TODO:
    o_result_flag := '1';
  end run_manual_step1;

  --取参与计算的销售人员
  procedure run_manual_step2(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '2'; --任务代码
    v_sale_count number := 0; --人员数量
    v_result_msg varchar2(100); --返回消息
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --更新状态为开始
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
  
    --检查基本法配置项是否已配置
    o_result_flag := pkg_law_check.f_check_law_define_cfg(i_version_id);
    if o_result_flag = '1' then
      --执行逻辑
      o_result_flag := pkg_law_salesman.f_imp_salesman(i_version_id,
                                                       i_calc_month,
                                                       i_dept_code,
                                                       i_line_code,
                                                       i_user_name,
                                                       v_task_id);
    end if;
  
    if o_result_flag = '1' then
      --获取导入人数
      select count(1)
        into v_sale_count
        from t_law_salesman t
       where t.version_id = i_version_id
         and t.calc_month = i_calc_month;
      --
      v_result_msg := '共' || to_char(v_sale_count) || '人';
    else
      v_result_msg := '未配置基本法，请检查';
    end if;
  
    --更新结束状态
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  
  end run_manual_step2;

  --计算标准保费
  procedure run_manual_step3(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '3'; --任务代码
    v_calc_all   char := '0'; --0：只计算上个月的
    v_result_msg varchar2(50) := '无'; --返回消息
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --更新状态为开始
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --执行逻辑
    o_result_flag := pkg_law_standard.run(i_version_id,
                                          i_dept_code,
                                          i_line_code,
                                          i_calc_month, --
                                          v_calc_all, --
                                          i_user_name,
                                          v_task_id);
    --更新结束状态
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step3;

  --计算销售人员的各项因素
  procedure run_manual_step4(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '4'; --任务代码
    v_result_msg varchar2(50) := '无'; --返回消息
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --更新状态为开始
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --执行逻辑
    o_result_flag := pkg_law_sum.run(i_calc_month,
                                     i_dept_code,
                                     i_line_code,
                                     i_version_id,
                                     i_user_name, --
                                     v_task_id);
    --更新结束状态
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step4;

  --计算销售人员的各项指标及薪酬
  procedure run_manual_step5(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '5'; --任务代码
    v_result_msg varchar2(50) := '无'; --返回消息
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --更新状态为开始
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --执行逻辑
    o_result_flag := pkg_law_wage.run(i_dept_code,
                                      i_line_code,
                                      i_version_id,
                                      i_calc_month,
                                      i_user_name, --
                                      v_task_id);
    --更新结束状态
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step5;

  --计算销售人员的各项评分
  procedure run_manual_step6(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '6'; --任务代码
    v_result_msg varchar2(50) := '无'; --返回消息
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --更新状态为开始
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --执行逻辑
    o_result_flag := pkg_law_result.f_insert_main(i_version_id, --
                                                  i_dept_code, --
                                                  i_line_code, --
                                                  i_calc_month, --
                                                  i_user_name, --
                                                  v_task_id);
    --更新结束状态
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step6;

  --计算销售人员的职级
  procedure run_manual_step7(i_version_id  in char, --基本法版本ID
                             i_calc_month  in char, --计算年月yyyymm
                             i_dept_code   in char, --分公司代码，两位
                             i_line_code   in char, --业务代码925007
                             i_user_name   in char, --当前用户的代码
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '7'; --任务代码
    v_result_msg varchar2(50) := '无'; --返回消息
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --更新状态为开始
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --执行逻辑
    o_result_flag := pkg_law_rank.run(i_dept_code, i_line_code, i_version_id, i_calc_month, i_user_name, v_task_id);
    --更新结束状态
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step7;

  procedure p_bgn_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in char,
                         i_result_msg  in char) is
    pragma autonomous_transaction;
  begin
    update t_law_define_manual t
       set t.task_status   = '2', --任务状态(1未开始,2正在执行,3执行完成,9执行失败)
           t.task_bng_date = sysdate,
           t.task_end_date = null,
           t.remark        = '',
           t.updated_user  = i_user_name,
           t.updated_date  = sysdate,
           t.task_id       = i_task_id
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.line_code = i_line_code
       and t.task_code = i_task_code;
    --
    update t_law_define t set t.last_start_tm = sysdate where t.version_id = i_version_id;
    commit;
  end p_bgn_status;

  procedure p_end_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in out char,
                         i_result_msg  in char) is
    pragma autonomous_transaction;
    v_erro_count  integer;
    v_task_status char(1);
  begin
    --判断日志中是否有异常，有则任务执行失败
    select count(1)
      into v_erro_count
      from t_law_log t
     where t.task_id = i_task_id
       and t.log_level = '2';
    if (v_erro_count > 0) then
      v_task_status := '9';
    else
      v_task_status := '3';
    end if;
    --dbms_output.put_line(i_task_status);
    --任务状态(1未开始,2正在执行,3执行完成,9执行失败)
    update t_law_define_manual t
       set t.task_status   = v_task_status,
           t.task_end_date = sysdate,
           t.remark        = i_result_msg,
           t.updated_user  = i_user_name,
           t.updated_date  = sysdate
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.line_code = i_line_code
       and t.task_code = i_task_code;
    commit;
  end p_end_status;

  function f_get_status(i_version_id in char, --
                        i_calc_month in char, --
                        i_task_code  in char) return varchar2 is
    v_task_status char(1) := '';
  begin
    select t.task_status
      into v_task_status
      from t_law_define_manual t
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.task_code = i_task_code;
  end f_get_status;
end pkg_law_manual;
/
