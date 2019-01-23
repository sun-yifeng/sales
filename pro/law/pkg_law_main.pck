create or replace package PKG_LAW_MAIN is

  -- Author  : ADMINISTRATOR
  -- Created : 2014-10-8 15:19:30
  -- Purpose : �������������

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

  -- ִ�м��㣬���շֹ�˾��ҵ���߼��㣺
  -- ��������,������Ա,��������,����ָ��,����ְ��...
  function f_run_calc(i_calc_month in char,
                      i_dept_code  in char,
                      i_line_code  in char,
                      i_version_id in char,
                      i_user_name  in char,
                      i_task_id    in integer) return integer is
    v_return integer;
  begin
  
    --��������
    --v_return := f_add_task(i_stat_month, i_dept_code, i_line_code, i_version_id, i_user_name, i_task_id);
  
    --������Ա
    v_return := pkg_law_salesman.f_imp_salesman(i_version_id,
                                              i_calc_month,
                                              i_dept_code,
                                              i_line_code,
                                              i_user_name,
                                              i_task_id);
  
    /*--����걣
    v_return := pkg_law_stand.f_stand_main(i_version_id,
                                            i_stat_month,
                                            i_dept_code,
                                            i_user_name,
                                            i_task_id);*/
  
    --��������
    if (v_return = 1) then
      v_return := pkg_law_sum.run(i_dept_code,
                                  i_line_code,
                                  i_version_id,
                                  i_calc_month,
                                  i_user_name, --
                                  i_task_id);
    end if;
  
    --����ָ��
    if (v_return = 1) then
      v_return := pkg_law_wage.run(i_dept_code,
                                   i_line_code,
                                   i_version_id,
                                   i_calc_month,
                                   i_user_name, --
                                   i_task_id);
    end if;
  
    /*--����ְ��
    if (v_return = 1) then
      v_return := pkg_law_assess.run_as_dept(
                                             i_stat_month,
                                             i_dept_code,
                                             i_line_code,
                                             i_user_name,
                                             i_task_id,
                                             i_version_id);
    end if;*/
  
    --������
    if ((v_return = 1)) then
      v_return := pkg_law_result.f_insert_main(i_version_id,
                                               i_dept_code,
                                               i_line_code,
                                               i_calc_month,
                                               i_user_name,
                                               i_task_id);
    end if;
  
    /*��������
    if ((v_return = 1)) then
      --v_return := f_upd_task(i_stat_month, i_dept_code, i_version_id, i_user_name, i_task_id, 2);
    else
      v_return := f_upd_task(i_stat_month, i_dept_code, i_version_id, i_user_name, i_task_id, 3);
    end if;
    
    --ȷ����Ϣ
    v_return := f_add_confirm(i_stat_month, i_dept_code, i_version_id, i_user_name, i_task_id);
    */
  
    --
    return v_return;
  
  end;

  -- ���ܣ���������������
  -- ������i_dump_flag �Ƿ���MIS�����ݣ����еķֹ�˾��ҵ����ÿ����ֻ����һ��
  --
  function f_run_main(i_exec_date  in date default null, -- ִ����
                      i_dept_code  in char default null, -- �ֹ�˾
                      i_line_code  in char default null, -- ҵ����
                      i_version_id in char default null, -- �汾����
                      i_dump_flag  in boolean -- �Ƿ�������
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
  
    /*--��������
    if (i_dump_flag) then
      v_return := pkg_law_mis.f_imp_main(v_stat_month,
                                         i_dept_code,
                                         i_line_code,
                                         '1',
                                         i_version_id,
                                         pkg_law_cons.c_user_name,
                                         pkg_law_cons.c_taks_id);
    end if;
    
    --ȡ��������
    v_sql_str := 'select * from t_law_define t where t.valid_ind = ''1'' and t.version_status = ''1''';
    --�ֹ�˾����
    v_sql_str := v_sql_str || ' and t.dept_code = ''' || i_dept_code;
    --ҵ��������
    v_sql_str := v_sql_str || ''' and t.line_code = ''' || i_line_code;
    --����������
    v_sql_str := v_sql_str || ''' and t.version_id = ''' || i_version_id || '''';
    
    --ִ�м���
    begin
    
      pkg_law_log.log_info('pkg_law_main.f_run_main',
                           pkg_law_cons.c_taks_id,
                           pkg_law_cons.c_user_name,
                           'ȡ��Ҫִ�еĻ�����',
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
                                  'ִ�л������������',
                                  sqlerrm);
        end;
    
        pkg_law_log.log_info('pkg_law_main.f_run_main',
                             pkg_law_cons.c_taks_id,
                             pkg_law_cons.c_user_name,
                             '������' || v_row_cur.version_id || 'ִ�����',
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
