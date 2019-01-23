create or replace package pkg_law_wage is

  -- author  : sunyf
  -- created : 2014-9-01 16:01:04
  -- purpose : �����������ָ��

  function f_clean_data(i_calc_month in char,
                        i_dept_code  in char,
                        i_line_code  in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_version_id in char) return char;

  function f_move_data(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char;

  function f_calc_wage(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char;

  --����ָ��
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2, --
               i_task_id    in varchar2) return char;

end pkg_law_wage;
/
create or replace package body pkg_law_wage is

  -- author  : sunyf
  -- created : 2014-9-01 16:01:04
  -- purpose : �����������ָ�꣨��������н�꣩

  --�����������м��
  function f_clean_data(i_calc_month in char,
                        i_dept_code  in char,
                        i_line_code  in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_version_id in char) return char is
    pragma autonomous_transaction;
  begin
    --��������
    delete from t_law_calc_value t
     where t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.item_type = '2';
    --������ٱ�
    delete from t_law_calc_proce t
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.calc_type = '2';
    --��������
    delete from t_law_calc_extra t
     where t.calc_month = i_calc_month
       and t.version_id = i_version_id;
    commit;
    return '1';
  end f_clean_data;

  -- �����ؽ���ᵽ��չ��
  function f_move_data(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char is
  
    v_sql_str1  varchar2(30000);
    v_sql_str2  varchar2(30000);
    v_sql_str3  varchar2(30000);
    v_func_name varchar2(100) := 'pkg_law_wage.f_move_calc';
    pragma autonomous_transaction;
  begin
    v_sql_str1 := 'insert into t_law_calc_extra(dept_code,line_code,version_id,calc_month,sales_code,group_code';
    v_sql_str2 := ')(select dept_code,line_code,version_id,calc_month,sales_code,group_code ';
    --1.ѭ������
    for rec in (select distinct t.item_code
                  from t_law_factor_sys t
                 where t.valid_ind = '1'
                   and t.item_status = '1'
                   and t.version_id = i_version_id
                union
                select distinct t.item_code
                  from t_law_factor_imp t
                 where t.valid_ind = '1'
                   and t.item_status = '1'
                   and t.version_id = i_version_id
                union
                select distinct t.item_code
                  from t_law_factor_exa t
                 where t.valid_ind = '1'
                   and t.item_status = '1'
                   and t.version_id = i_version_id) loop
      v_sql_str1 := v_sql_str1 || ',' || rec.item_code; --���ش���
      v_sql_str2 := v_sql_str2 || ',' || 'round(max(case when object_code = ''' || rec.item_code ||
                    ''' then object_value else 0 end),4) as ' || rec.item_code;
    end loop;
  
    --���㹫ʽ
    v_sql_str3 := v_sql_str1 || v_sql_str2 || ' from t_law_calc_value where calc_month = ''' || i_calc_month ||
                  ''' and sales_code in (select salesman_code from t_law_salesman t where t.dept_code = ''' ||
                  i_dept_code || ''' and t.calc_month = ''' || i_calc_month || ''' and t.line_code = ''' || i_line_code ||
                  ''' ) group by calc_month, line_code, version_id, sales_code, group_code, dept_code)';
  
    --д����־
    pkg_law_log.log_info(v_func_name, i_task_id, i_user_name, '���ؽ���ᵽ��չ��', v_sql_str3);
    execute immediate v_sql_str3;
    commit;
    return '1';
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���ذᵽ��չ��ʱ����' || sqlerrm, v_sql_str3);
      rollback;
      return '-1';
  end f_move_data;

  --����ָ�꣬����ͻ������ָ�꣬��Ϊ�ŶӾ�����õ��ͻ�����ָ��
  function f_calc_wage(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char is
  
    v_sql_1   varchar2(2048); --�����������
    v_sql_2   varchar2(1024); --��¼�������
    v_law_cfg char(1) := '1'; --������������
    v_toggle  boolean := false; --�߼��л�����
    pragma autonomous_transaction;
    v_func_name  varchar2(100) := 'pkg_law_wage.f_index_calc';
    v_val_result varchar2(1000);
    v_decimal_digit number;
  begin
    --ȡ�������������е����أ�����ָ�꣬�Լ��㹫ʽ�ͼ�������������֤
    v_val_result := pkg_law_validate.f_main(i_version_id);
    if (v_val_result is not null) then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '������û��������������ػ���ָ�꣺' || v_val_result,
                            v_val_result);
    end if;
    --ȡ����������
    select nvl(t.is_client_manager_check, '0')
      into v_law_cfg
      from t_law_define_config t
     where t.version_id = i_version_id;
    --ȡ����Ĺ�ʽ
    for c_rule in (select t.index_code, t.index_name, t.ret, t.index_cond, t.item_type, t.order_no
                     from t_law_calc t --ָ�깫ʽ
                    where 1 = 1
                      and t.valid_ind = '1'
                      and t.item_status = '1'
                      and t.version_id = i_version_id
                    order by t.item_type, t.order_no, t.index_code) loop
      --�������е�������Ա
      for c_sale in (select t.salesman_code, t.manager_flag, t.sale_rank_two
                       from t_law_salesman t
                      where 1 = 1
                        and t.dept_code = i_dept_code
                        and t.line_code = i_line_code
                        and t.version_id = i_version_id
                        and t.calc_month = i_calc_month
                      order by t.manager_flag) loop
        --�Ƿ���Ҫִ�й�ʽ      
        if ((c_sale.manager_flag = c_rule.item_type) or (v_law_cfg = '1' and c_rule.item_type = '0' and
           c_sale.manager_flag = '1' and c_sale.sale_rank_two is not null)) then
          v_toggle := true;
        else
          v_toggle := false;
        end if;
        --������������ʱ����
        if (v_toggle) then
          --��������ƴװ���Ƭ��
          select t.decimal_digit into v_decimal_digit from t_law_rule t where t.item_code = c_rule.index_code and t.valid_ind = '1';
          v_sql_1 := 'update t_law_calc_extra set ' || c_rule.index_code || '= round(' || nvl(c_rule.ret, 0) || ','|| v_decimal_digit ||')' ||
                     ' where calc_month = ''' || i_calc_month || ''' and version_id = ''' || i_version_id || ''' and (' ||
                     nvl(trim(replace(replace(c_rule.index_cond, '---', ''), '--', '')), '1=1') ||
                     ') and sales_code = ''' || c_sale.salesman_code || '''';
          --���������̵���䣬��Ҫ��������ֶΣ���Ҫ�����ŰѼ���������ס����Ϊ���������а�����or�ġ�
          v_sql_2 := 'insert into t_law_calc_proce select sys_guid(),''' || i_version_id || ''',''' || i_calc_month ||
                     ''',''' || i_dept_code || ''',''' || i_line_code || ''',''' || c_rule.index_code || ''',''' ||
                     c_rule.ret || ''',''' || nvl(trim(c_rule.index_cond), '---') || ''',round(' || c_rule.index_code ||
                     ','|| v_decimal_digit ||'),1,''' || i_user_name || ''',sysdate,''' || i_user_name || ''',sysdate,sales_code,' ||
                     '''2'',''' || c_rule.index_name || ''',''' || c_rule.order_no ||
                     ''',null from t_law_calc_extra where ' || c_rule.index_code || ' is not null and calc_month = ''' ||
                     i_calc_month || ''' and version_id = ''' || i_version_id || ''' and (' ||
                     nvl(trim(replace(replace(c_rule.index_cond, '---', ''), '--', '')), '1=1') ||
                     ') and sales_code = ''' || c_sale.salesman_code || '''';
          --������־��Ϣ
          pkg_law_log.log_info(v_func_name,
                               i_task_id,
                               i_user_name,
                               'ִ�м��㹫ʽ',
                               '������Ա:' || c_sale.salesman_code || ',�����·�:' || i_calc_month || ',���㹫ʽ:' ||
                               c_rule.index_code || ',��������:' || c_rule.index_cond || 'ִ�����:' || v_sql_1 || ',����������:' ||
                               v_sql_2);
        
          --ִ�м��㹫ʽ
          begin
            execute immediate v_sql_1;
            commit;
          exception
            when others then
              pkg_law_log.log_error(v_func_name,
                                    i_task_id,
                                    i_user_name,
                                    'ִ�й�ʽ����,������Ա:' || c_sale.salesman_code || ',�����·�:' || i_calc_month || ',���㹫ʽ:' ||
                                    c_rule.index_code || ',��������:' || c_rule.index_cond || sqlerrm,
                                    v_sql_1);
          end;
          --����������
          begin
            execute immediate v_sql_2;
            commit;
          exception
            when others then
              pkg_law_log.log_error(v_func_name,
                                    i_task_id,
                                    i_user_name,
                                    '��¼���̳���,������Ա:' || c_sale.salesman_code || ',�����·�:' || i_calc_month || ',���㹫ʽ:' ||
                                    c_rule.index_code || ',��������:' || c_rule.index_cond || sqlerrm,
                                    v_sql_2);
          end;
        end if;
      end loop;
    end loop;
    return '1';
  end f_calc_wage;

  --�������
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2, --
               i_task_id    in varchar2) return char is
    v_return    char;
    v_func_name varchar2(128) := 'pkg_law_wage.run';
  begin
    --�������
    v_return := f_clean_data(i_calc_month,
                             i_dept_code,
                             i_line_code,
                             i_user_name,
                             i_task_id, --
                             i_version_id);
    --д�м��
    if v_return = '1' then
      v_return := f_move_data(i_calc_month,
                              i_dept_code,
                              i_line_code,
                              i_user_name,
                              i_task_id, --
                              i_version_id);
    end if;
    --����ָ��
    if v_return = '1' then
      v_return := f_calc_wage(i_calc_month,
                              i_dept_code,
                              i_line_code,
                              i_user_name,
                              i_task_id, --
                              i_version_id);
    end if;
    return v_return;
  exception
    when others then
      v_return := pkg_law_func.unlock_person(i_calc_month,
                                             i_dept_code,
                                             i_line_code,
                                             i_user_name,
                                             i_task_id,
                                             i_version_id);
      pkg_law_log.log_info(v_func_name, i_task_id, i_user_name, '���㹫ʽ����', sqlerrm);
      --raise_application_error(-20001, sqlerrm);
      return '-1';
  end run;

end pkg_law_wage;
/
