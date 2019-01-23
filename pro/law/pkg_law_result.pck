create or replace package pkg_law_result is

  -- Author  : sunyf
  -- Created : 2014-11-14 11:55:52
  -- Purpose : д�������

  function f_calc_value(i_clit_code in char,
                        i_magr_code in char,
                        i_sale_code in char,
                        i_magr_flag in char,
                        i_rank_code in char) return number;

  function f_insert_score(i_dept_code  char, --
                          i_line_code  char, --
                          i_calc_month char, --
                          i_user_name  char, --
                          i_taks_id    char) return number;

  function f_insert_salary(i_dept_code  char, --
                           i_line_code  char, --
                           i_calc_month char, --
                           i_user_name  char, --
                           i_taks_id    char) return number;

  function f_insert_main(i_version_id in char, --
                         i_dept_code  char, --
                         i_line_code  char, --
                         i_stat_month char, --
                         i_user_name  char, --
                         i_taks_id    char) return number;
end pkg_law_result;
/
create or replace package body pkg_law_result is

  -- author  : sunyf
  -- created : 2014-11-14 11:55:52
  -- purpose : д�������

  --ȫ�ֱ���
  v_dept_code  varchar2(50);
  v_line_code  varchar2(50);
  v_version_id varchar2(50);
  v_calc_month varchar2(50);
  v_user_name  varchar2(50);
  v_task_id    varchar2(50);

  --ȡ��������
  function f_calc_value(i_clit_code in char,
                        i_magr_code in char,
                        i_sale_code in char,
                        i_magr_flag in char,
                        i_rank_code in char) return number is
    v_result    number(16, 4) := 0;
    v_count     integer;
    v_rule_code varchar2(10);
    v_exec_par1 varchar2(500);
    v_exec_str1 varchar2(500);
    v_func_name varchar2(30) := 'pkg_law_result.f_calc_value';
  begin
    --ȡ���ع�ʽ����
    if (i_magr_flag = '0') then
      v_rule_code := upper(i_clit_code);
    elsif (i_magr_flag = '1') then
      v_rule_code := upper(i_magr_code);
    end if;
    --�����������ô���
    select count(1)
      into v_count
      from (select t.item_code
              from t_law_factor_sys t
             where t.valid_ind = '1'
               and t.item_status = '1'
               and t.version_id = v_version_id
            union
            select t.index_code
              from t_law_calc t
             where t.valid_ind = '1'
               and t.item_status = '1'
               and t.version_id = v_version_id) t1
     where t1.item_code = v_rule_code;
    --д����־��Ϣ
    if (v_count = 0) then
      pkg_law_log.log_warning(v_func_name,
                              v_task_id,
                              v_user_name,
                              '������δ���ô˼������:' || v_rule_code,
                              '������δ���ô˼������:' || v_rule_code);
      return null;
    end if;
    --ִ�����Ĳ���
    v_exec_par1 := 'dept_code:' || v_dept_code || ',line_code:' || v_line_code || ',calc_month:' || v_calc_month ||
                   ',calc_code:' || i_clit_code || ',' || i_magr_code || ',sale_code:' || i_sale_code || ',magr_flag:' ||
                   i_magr_flag || ',rank_code:' || i_rank_code;
    --�����ϵͳ����
    if (substr(upper(i_clit_code), 1, 1) = upper('a')) then
      v_exec_str1 := 'select t.object_value into :v0 from t_law_calc_value t where t.dept_code = ''' || v_dept_code ||
                     ''' and t.line_code = ''' || v_line_code || ''' and t.calc_month = ''' || v_calc_month ||
                     ''' and t.sales_code = ''' || i_sale_code || ''' and t.rank_code = ''' || i_rank_code ||
                     ''' and t.object_code = ''' || v_rule_code || '''';
    elsif (substr(upper(i_clit_code), 1, 1) = upper('d')) then
      v_exec_str1 := 'select t.' || v_rule_code || ' into :v0 from t_law_calc_extra t where t.dept_code =''' ||
                     v_dept_code || ''' and t.line_code = ''' || v_line_code || ''' and t.calc_month = ''' ||
                     v_calc_month || ''' and t.sales_code = ''' || i_sale_code || '''';
    end if;
    --ִ�����
    execute immediate v_exec_str1
      into v_result;
    return v_result;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            v_task_id,
                            v_user_name,
                            'ȡ����������',
                            sqlerrm || ',ִ�����:' || v_exec_str1 || ',�������:' || v_exec_par1);
      return - 1;
  end f_calc_value;

  -- ����
  function f_insert_score(i_dept_code  char, --
                          i_line_code  char, --
                          i_calc_month char, --
                          i_user_name  char, --
                          i_taks_id    char) return number is
  begin
    --�������
    delete from review_score t
     where t.dept_code_two = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month;
    --������Ա
    for c_sales in (select t.salesman_code, t.manager_flag, t.rank_code, t.sale_rank_two, t.group_code
                      from t_law_salesman t
                     where 1 = 1
                       and t.dept_code = i_dept_code
                       and t.line_code = i_line_code
                       and t.calc_month = i_calc_month
                     order by t.salesman_code) loop
      --
      insert into review_score
        (score_id,
         calc_month,
         dept_code_two,
         dept_name_two,
         dept_code_three,
         dept_name_three,
         dept_code_four,
         dept_name_four,
         group_code,
         group_name,
         salesman_code,
         salesman_name,
         rank_code,
         rank_name,
         line_code,
         manager_flag, --�ͻ��Ŷ�
         --
         stand_fee, --ʵ����ɱ�׼���� 
         tatol_prem_rate, --�ۼƱ�׼���Ѵ���� 
         tatol_group_rate, --�ۼƱ�׼���Ѵ����(�Ŷ�)      
         claim_fee, --������Ѿ�δ�����
         reinsure_claim_rate, --����ȱ����ٱ��������⸶�ʿ�����
         score, --�÷�
         --
         confirm_status,
         valid_ind,
         created_user,
         created_date,
         updated_user,
         updated_date)
        select sys_guid(),
               t5.calc_month,
               t2.pro_dept dept_code_two,
               t2.pro_name dept_name_two,
               t2.city_dept dept_code_three,
               t2.city_name dept_name_three,
               t2.market_dept dept_code_four,
               t2.market_name dept_name_four,
               t3.group_code,
               t3.group_name,
               t1.salesman_code,
               t1.salesman_cname,
               t4.rank_code,
               t4.rank_name,
               t5.line_code,
               pkg_law_check.f_check_leader(t1.sale_rank) manager_flag,
               --ȫ���׼���Ѽƻ�����Ҫд�룬ͨ��ְ������
               f_calc_value('a005', 'a105', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --ʵ���ۼƱ걣
               f_calc_value('d002', 'd102', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --�ۼƱ걣�����
               f_calc_value('d002', 'd102', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --�ۼƱ걣����ʣ��Ŷӣ�
               f_calc_value('a011', 'a112', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --������Ѿ�δ���������ã�
               f_calc_value('d005', 'd105', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --�����⸶��
               f_calc_value('d069', 'd220', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --���˵÷�
               --
               '0', --confirm_status
               '1',
               'admin',
               sysdate,
               'admin',
               sysdate
          from salesman t1
          left join department_level t2
            on t1.dept_code = t2.market_dept
          left join group_main t3
            on t1.group_code = t3.group_code
          left join t_law_rank_def t4
            on t1.sale_rank = t4.rank_code
          left join t_law_salesman t5
            on t1.salesman_code = t5.salesman_code
           and t5.dept_code = i_dept_code
           and t5.line_code = i_line_code
           and t5.calc_month = i_calc_month
         where 1 = 1
           and t1.salesman_code = c_sales.salesman_code;
      --
    end loop;
    commit;
    return 1;
  exception
    when others then
      rollback;
      pkg_law_log.log_error('pkg_law_result.f_insert_score',
                            i_taks_id,
                            i_user_name,
                            '�������ִ���,i_dept_code:' || i_dept_code || ',i_calc_month:' || i_calc_month,
                            sqlerrm);
      return - 1;
  end;

  -- salary
  function f_insert_salary(i_dept_code  char, --
                           i_line_code  char, --
                           i_calc_month char, --
                           i_user_name  char, --
                           i_taks_id    char) return number is
  begin
    --clear
    delete from review_salary t
     where t.dept_code_two = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month;
  
    --������Ա
    for c_sales in (select t.salesman_code, t.manager_flag, t.rank_code, t.sale_rank_two, t.group_code
                      from t_law_salesman t
                     where 1 = 1
                       and t.dept_code = i_dept_code
                       and t.line_code = i_line_code
                       and t.calc_month = i_calc_month
                     order by t.salesman_code) loop
      --
      insert into review_salary
        (salary_id,
         calc_month,
         dept_code_two,
         dept_name_two,
         dept_code_three,
         dept_name_three,
         dept_code_four,
         dept_name_four,
         group_code,
         group_name,
         salesman_code,
         salesman_name,
         rank_code,
         rank_name,
         biz_line_code,
         line_code,
         company_date,
         position_date,
         manager_flag,
         --
         salary_fixed, --�̶�����
         salary_perform, --��Ч����
         salary_base, --��������
         salary_benefit,--����
         salary_total, --�ϼƣ�����н�꣩
         --
         confirm_status,
         valid_ind,
         created_user,
         created_date,
         updated_user,
         updated_date)
        select sys_guid(),
               t5.calc_month,
               t2.pro_dept dept_code_two,
               t2.pro_name dept_name_two,
               t2.city_dept dept_code_three,
               t2.city_name dept_name_three,
               t2.market_dept dept_code_four,
               t2.market_name dept_name_four,
               t3.group_code,
               t3.group_name,
               t1.salesman_code,
               t1.salesman_cname,
               t4.rank_code,
               t4.rank_name,
               t5.line_code,
               t5.line_code,
               t1.contract_date,
               t1.entry_date,
               pkg_law_check.f_check_leader(t1.sale_rank) manager_flag,
               --ȫ���׼���Ѽƻ�����Ҫд�룬ͨ��ְ������
               f_calc_value('a007', 'a126', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --�̶�����
               f_calc_value('d071', 'd225', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --��Ч����
               f_calc_value('d072', 'd227', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --��������
               f_calc_value('d080', 'd226', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --����
               f_calc_value('d073', 'd228', c_sales.salesman_code, c_sales.manager_flag, c_sales.rank_code), --�ϼƣ�����н�꣩TODO:
               --
               '0', --confirm_status
               '1',
               'admin',
               sysdate,
               'admin',
               sysdate
          from salesman t1
          left join department_level t2
            on t1.dept_code = t2.market_dept
          left join group_main t3
            on t1.group_code = t3.group_code
          left join t_law_rank_def t4
            on t1.sale_rank = t4.rank_code
          left join t_law_salesman t5
            on t1.salesman_code = t5.salesman_code
           and t5.dept_code = i_dept_code
           and t5.line_code = i_line_code
           and t5.calc_month = i_calc_month
         where 1 = 1
           and t1.salesman_code = c_sales.salesman_code;
      --
    end loop;
  
    --�ύ����
    commit;
    --
    return 1;
  exception
    when others then
      rollback;
      pkg_law_log.log_error('pkg_law_result.f_insert_salary',
                            i_taks_id,
                            i_user_name,
                            '����н�����,i_dept_code:' || i_dept_code || ',i_calc_month:' || i_calc_month,
                            sqlerrm);
      return - 1;
  end;

  function f_insert_main(i_version_id in char, --
                         i_dept_code  char, --
                         i_line_code  char, --
                         i_stat_month char, --
                         i_user_name  char, --
                         i_taks_id    char) return number is
    v_return    number := -1;
    v_func_name varchar2(30) := 'pkg_law_result.f_insert_main';
  begin
    --ȫ�ֱ���
    v_dept_code  := i_dept_code;
    v_line_code  := i_line_code;
    v_version_id := i_version_id;
    v_calc_month := i_stat_month;
    v_user_name  := i_user_name;
    v_task_id    := i_taks_id;
    --��������
    v_return := f_insert_score(i_dept_code,
                               i_line_code,
                               i_stat_month,
                               i_user_name, --
                               i_taks_id);
    --����н��
    v_return := f_insert_salary(i_dept_code,
                                i_line_code,
                                i_stat_month,
                                i_user_name, --
                                i_taks_id);
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_taks_id,
                            i_user_name, --
                            '�������������',
                            sqlerrm);
      return v_return;
  end;

end pkg_law_result;
/
