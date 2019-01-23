create or replace package pkg_law_salesman is

  -- Author  : sunyf
  -- Created : 2014/11/26 16:53:04
  -- Purpose : ������Ҫ���˵���Ա

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
  --��⿼����Ա�Ŷӣ���һְ�����ڶ�ְ���Ƿ�������ȷ
  function f_chk_salesman(i_version_id in char,
                          i_calc_month in char,
                          i_dept_code  in char,
                          i_line_code  in char,
                          i_user_name  in char,
                          i_task_id    in char) return number is
    v_func_name varchar2(30) := 'pkg_law_person.f_imp_person';
    v_last_day  date := last_day(to_date(i_calc_month, 'yyyymm'));
    v_count_2   number := 0; --�ж��Ŷ��Ƿ���Ч
    v_count_3   number := 0; --�жϵ�һְ���Ƿ���Ч
    v_count_4   number := 0; --�жϵڶ�ְ��ʱ����Ч
    --ȡ�����вμӿ��˵�������Ա���ж������ڵ��ŶӺ����õ�ְ���Ƿ���Ч
    cursor check_salesmans is
      select t.salesman_code, --������Ա����
             t.group_code, --������Ա�Ŷ�
             t.sale_rank, --������Ա��һְ��
             t.sale_rank_two --������Ա�ڶ�ְ��������ÿ�����Ա�����˵ڶ�ְ����
        from salesman t
        left join t_law_rank_def t1
          on t.sale_rank = t1.rank_code
       where 1 = 1
         and t.valid_ind = '1'
         and t1.manager_flag in ('0', '1') --ֻ����ͻ�������ŶӾ���
         and t.process_status = '2' --�Ѿ������������Ա
            --and t.evaluate = '1' --�Ƿ�μӿ���
         and t.dept_code like i_dept_code || '%' --�ֹ�˾
         and t.business_line = i_line_code --ҵ����
         and t.group_code is not null --�ŶӲ���Ϊ��
         and t.sale_rank is not null --ְ������Ϊ��
         and t.entry_date is not null --��ְʱ�䲻��Ϊ��
         and t.front_date < trunc(v_last_day + 1) --�ڸ�ʱ��С��ͳ���·�
         and t.dimission_date > to_date(i_calc_month,'yyyymm') --��ְ�����ڿ����·�֮ǰ
         and t.dept_code is not null --���ű�Ų���Ϊ��
         and t.salesman_flag = '1'; --ֻ����ǰ̨��Ա
    check_salesmans_row check_salesmans%rowtype;
  
  begin
    --�ж������ڵ��ŶӺ����õ�ְ���Ƿ���Ч
    for check_salesmans_row in check_salesmans loop
      --�жϿ�����Ա���ڵ��Ŷ��Ƿ���Ч
      select count(1)
        into v_count_2
        from group_main t
       where t.valid_ind = '1'
         and t.group_code = check_salesmans_row.group_code;
    
      --�жϿ�����Ա���õĵ�һְ���Ƿ���Ч
      select count(1)
        into v_count_3
        from t_law_rank_def t
       where t.valid_ind = '1'
         and t.version_id = i_version_id
         and t.item_status = '1' --�ֹ�˾��ְ��ʹ��״̬Ϊ"��ʹ��"
         and t.valid_ind = '1' --ɾ����־λ
         and t.rank_code = check_salesmans_row.sale_rank;
    
      --����ÿ�����Ա�����˵ڶ�ְ��������Ҫ�жϸ�ְ���Ƿ�����ʹ��
      if (check_salesmans_row.sale_rank_two is not null) then
        select count(1)
          into v_count_4
          from t_law_rank_def t
         where t.valid_ind = '1'
           and t.version_id = i_version_id
           and t.item_status = '1' --�ֹ�˾ְ��ʹ��״̬
           and t.valid_ind = '1' --ɾ����־λ
           and t.rank_code = check_salesmans_row.sale_rank_two;
        if (v_count_2 <= 0 or v_count_3 <= 0 or v_count_4 <= 0) then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '����������Ա��' || check_salesmans_row.salesman_code || ',�Ŷ�,��һְ�����ߵڶ�ְ��������Ч�����ʵ��',
                                sqlerrm);
        end if;
      else
        if (v_count_2 <= 0 or v_count_3 <= 0) then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '����������Ա��' || check_salesmans_row.salesman_code || ',�Ŷӻ��ߵ�һְ����������Ч�����ʵ��',
                                sqlerrm);
        end if;
      end if;
    end loop;
    return 1;
  end;

  --������Ա
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
      --��⿼����Ա�Ŷӣ���һְ�����ڶ�ְ���Ƿ�������ȷ
      v_result := f_chk_salesman(i_version_id, i_calc_month, i_dept_code, i_line_code, i_user_name, i_task_id);
      --�����Ա
      delete from t_law_salesman t
       where 1 = 1
         and t.version_id = i_version_id
         and t.calc_month = i_calc_month
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code;
      --������Ա
      insert into t_law_salesman
        (pk_id,
         version_id,
         calc_month,
         bng_date,
         end_date,
         salesman_code,
         rank_code,
         manager_flag, --ְ������
         sale_rank_two, --�����Ŷӳ����ͻ������˵�ְ��
         group_code,
         dept_code,
         busy_flag,
         line_code,
         created_user,
         created_date,
         updated_user,
         updated_date)
        select sys_guid() as pk_id,
               i_version_id as version_id, --�������汾
               i_calc_month as calc_month, -- ��ʽ:yyyymm
               to_date(i_calc_month, 'yyyymm') as bng_date, --
               v_last_day as end_date,
               t.salesman_code as salesman_code,
               t.sale_rank as rank_code,
               pkg_law_check.f_check_leader(t.sale_rank) as manager_flag, --ְ������
               t.sale_rank_two as sale_rank_two, --�����Ŷӳ����ͻ������˵�ְ��
               t.group_code,
               i_dept_code as dept_code,
               0 as busy_flag, --busy_flag
               i_line_code as line_code, --ҵ����
               'admin' as created_user,
               sysdate as created_date,
               'admin' as updated_user,
               sysdate as updated_date
          from salesman t
          left join t_law_rank_def t1
            on t.sale_rank = t1.rank_code
         where 1 = 1
           and t.valid_ind = '1'
           and t1.manager_flag in ('0', '1') --ֻ����ͻ�������ŶӾ���
           and t.process_status = '2' --�Ѿ������������Ա
              --and t.evaluate = '1' --�Ƿ�μӿ���
           and t.dept_code like i_dept_code || '%' --�ֹ�˾
           and t.business_line = i_line_code --ҵ����
           and t.group_code is not null --�ŶӲ���Ϊ��
           and t.sale_rank is not null --ְ������Ϊ��
           and t.entry_date is not null --��ְʱ�䲻��Ϊ��
           and t.dimission_date > to_date(i_calc_month,'yyyymm') --��ְ�����ڿ����·�֮ǰ
           and t.front_date < trunc(v_last_day + 1) --�ڸ�ʱ��С��ͳ���·�
           and t.dept_code is not null --���ű�Ų���Ϊ��
           and t.salesman_flag = '1' --ֻ����ǰ̨��Ա
        ;
    exception
      when others then
        rollback;
        pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '������Ա����', sqlerrm);
        return - 1;
    end;
  
    --commit;
    commit;
  
    --ͳ�Ƶ��������
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
                         '����������Ա,�ֹ�˾:' || i_dept_code || ',ҵ����:' || i_line_code || ',��' || v_count_1 || '��',
                         '');
    return v_result;
  end; --end function

end pkg_law_salesman;
/
