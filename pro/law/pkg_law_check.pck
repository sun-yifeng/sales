create or replace package pkg_law_check is

  function f_exist_func(p_func_name in char,
                        p_user_name in char, --
                        p_ms_id     in integer) return integer;
  /*
  function f_exist_factor(i_factor_code in char,
                          i_dept_code   in char,
                          i_line_code   in char,
                          i_user_name   in char,
                          i_task_id     in integer) return integer;
  
  function f_exist_index(i_index_code in char,
                         i_dept_code  in char,
                         i_line_code  in char,
                         i_user_name  in char,
                         i_task_id    in integer) return integer;
  
  function f_check_index(i_index_formula in char,
                         i_dept_code     in char,
                         i_line_code     in char,
                         i_user_name     in char,
                         i_task_id       in integer) return integer;
  
  function f_check_cond(p_index_code in char,
                        p_index_cond in char,
                        p_version_id in char,
                        i_user_name  in char,
                        i_task_id    in integer) return integer;
  
  function f_check_rank(i_rank_code  in char, --ְ������
                        i_rank_cond  in char, --����������[80,90)|[6000000,+��)
                        i_version_id in char,
                        i_task_name  in char,
                        i_task_id    in integer) return integer;
  */

  --����ְ�������ж��Ƿ�Ϊ�ŶӾ���,0-�ͻ�����1-�ŶӾ���2-����
  function f_check_leader(i_rank_code in char) return char;

  --�������Ƿ������ŶӾ����ͻ�������
  function f_mgr_cfg(i_version_id varchar2,
                     i_user_name  in varchar2,
                     i_task_id    in varchar2 --
                     ) return char;

  --�ж��Ƿ��ŶӾ����ͻ������ˡ����أ�0-��1-��
  function f_check_mgr_cal_by_cus(i_is_client_manager_check varchar2, --�ŶӾ����Ƿ���Ҫ���ͻ�������
                                  i_manager_flag            varchar2, --ְ������
                                  i_rank_code               varchar2, --ְ��
                                  i_sale_rank_two           varchar2 --�����Ŷӳ����ͻ������˵�ְ��
                                  ) return varchar2;

  --�ж��Ƿ��ŶӾ����ͻ������ˡ����أ�0-��1-��
  function f_mgr_cus(i_manager_flag in varchar2,
                     i_sales_code   in varchar2,
                     i_rank_code    in varchar2,
                     i_rank_two     in varchar2,
                     i_user_name    in varchar2,
                     i_task_id      in varchar2 --
                     ) return char;

  --��������������������Ƿ������á�-1��δ���ã�1��������
  function f_check_law_define_cfg(i_version_id varchar2 --�汾����
                                  ) return varchar2;

end pkg_law_check;
/
create or replace package body pkg_law_check is

  -- �����Ƿ񴴽�is_func_exist
  function f_exist_func(p_func_name in char, p_user_name in char, p_ms_id in integer) return integer is
    sp_methodname varchar2(100);
    sp_status     varchar2(16);
  begin
    sp_methodname := 'pkg_law_check.f_exist_func';
    begin
      select status
        into sp_status
        from user_objects -- user_objects
       where object_type = upper('FUNCTION')
         and object_name = upper(p_func_name);
    exception
      when no_data_found then
        return 0;
      when others then
        pkg_law_log.log_error(sp_methodname, p_ms_id, p_user_name, '�������ʧ�ܣ�У����㺯��ʧ��', '');
    end;
    --
    if sp_status = upper('INVALID') then
      pkg_law_log.log_error(sp_methodname,
                            p_ms_id,
                            p_user_name,
                            '�������ʧ�ܣ�����' || upper(p_func_name) || 'ʧЧ',
                            '');
    end if;
    return 1;
  end f_exist_func;

  -- �����Ƿ����
  function f_exist_factor(i_factor_code in char,
                          i_dept_code   in char,
                          i_line_code   in char,
                          i_user_name   in char,
                          i_task_id     in integer,
                          i_version_id  in char) return integer is
    sp_methodname varchar2(100);
    sp_cnt        integer;
  begin
    sp_methodname := 'pkg_law_check.f_exist_factor';
    select count(0)
      into sp_cnt
      from t_law_factor_sys
     where 1 = 1
       and item_code = i_factor_code
       and version_id = i_version_id;
    --
    if sp_cnt > 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('��t_factor_def���ظ�����:') || i_factor_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    elsif sp_cnt < 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('��t_factor_defδ��������:') || i_factor_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    end if;
    return(case when sp_cnt <> 1 then 0 else 1 end);
  end f_exist_factor;

  -- ���ָ��
  /*
  function f_exist_index(i_index_code in char,
                         i_dept_code  in char,
                         i_line_code  in char,
                         i_user_name  in char,
                         i_task_id    in integer) return integer is
    sp_methodname varchar2(100);
    sp_cnt        integer;
  begin
    sp_methodname := 'pkg_law_check.f_exist_index';
  
    --ָ����汾�޹�
    select count(0)
      into sp_cnt
      from t_index_def
     where 1 = 1
       and index_code = i_index_code
       and dept_code = i_dept_code --
       and line_code = i_line_code --
    ;
    --
    if sp_cnt > 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('��t_index_def���ظ���ʽ:') || i_index_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    elsif sp_cnt < 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('��t_index_defδ���ù�ʽ:') || i_index_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    end if;
    return(case when sp_cnt <> 1 then 0 else 1 end);
  end f_exist_index;
  
  --���ָ��Ĺ�ʽ
  function f_check_index(i_index_formula in char,
                         i_dept_code     in char,
                         i_line_code     in char,
                         i_user_name     in char,
                         i_task_id       in integer) return integer is
    sp_methodname   varchar2(100);
    sp_index_result varchar2(256);
    sp_arr          pkg_law_func.ty_array;
    v_arr_index     integer;
    v_arr_value     varchar2(100);
  begin
    sp_methodname := 'pkg_law_check.f_check_index';
    pkg_law_log.log_debug(sp_methodname,
                          i_task_id,
                          i_user_name,
                          '�����㹫ʽ' || i_index_formula || ',���Ŵ���' || i_dept_code || ',ҵ����' || i_line_code,
                          '');
  
    --ȥ���Ӽ��˳�
    sp_index_result := replace(i_index_formula, '+', '|');
    sp_index_result := replace(sp_index_result, '-', '|');
    sp_index_result := replace(sp_index_result, '*', '|');
    sp_index_result := replace(sp_index_result, '/', '|');
    --ȥ����������
    sp_index_result := replace(sp_index_result, '(', '|');
    sp_index_result := replace(sp_index_result, ')', '|');
    --ת����Ϊ����
    sp_arr      := pkg_law_func.split(sp_index_result, '|');
    v_arr_index := 1;
    v_arr_value := '';
    --�������Ԫ��
    while v_arr_index <= sp_arr.count loop
      v_arr_value := sp_arr(v_arr_index);
      if v_arr_value is not null and upper(v_arr_value) <> lower(v_arr_value) then
        if (upper(substr(v_arr_value, 1, 2)) = pkg_law_cons.c_prefix_f) then
          return f_exist_factor(v_arr_value, i_dept_code, i_line_code, i_user_name, i_task_id);
        elsif (upper(substr(v_arr_value, 1, 2)) = pkg_law_cons.c_prefix_w) or
              (upper(substr(v_arr_value, 1, 2)) = pkg_law_cons.c_prefix_r) then
          return f_exist_index(v_arr_value, i_dept_code, i_line_code, i_user_name, i_task_id);
        end if;
      end if;
      v_arr_index := v_arr_index + 1;
    end loop;
    return 1;
  end f_check_index;
  
  --���ָ��Ĺ�ʽ�����Ƿ���ȷ
  function f_check_cond(p_index_code in char,
                        p_index_cond in char,
                        p_version_id in char,
                        i_user_name  in char,
                        i_task_id    in integer) return integer is
    sp_methodname varchar2(100);
    v_arr         pkg_law_func.ty_array;
    v_cnt         integer;
    v_len         integer;
  begin
    sp_methodname := 'pkg_law_check.f_check_cond';
  
    --1.�Ƿ�������
    if instr('��', p_index_cond) > 0 or instr('��', p_index_cond) > 0 or instr('��', p_index_cond) > 0 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            '��ʽ' || p_index_code || '������' || p_index_cond || '�����Ķ��Ż�����',
                            '');
      return - 1;
    end if;
  
    --��ʽ�������������飩
    v_arr := pkg_law_func.split(p_index_cond, '|');
  
    --ָ���Ӧ�����ظ���
    select count(0)
      into v_cnt
      from t_index_factor t
     where t.version_id = p_version_id
       and t.index_code = p_index_code;
  
    --2.���ع�ϵ�����������Ƿ����
    if v_cnt <> v_arr.count then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            '��ʽ' || p_index_code || '�ڱ�t_index_factor��������' || to_char(v_cnt) || '������' || p_index_cond || '����' ||
                            to_char(v_arr.count) || '����',
                            '');
      return - 2;
    end if;
  
    v_len := 0;
    --3.����������
    for rec in (select t.*
                  from t_index_factor t
                 where t.version_id = p_version_id
                   and t.index_code = p_index_code
                 order by t.order_no) loop
      v_len := v_len + 1;
      -- ���������Ƿ����
      if pkg_law_func.f_calc_cond('field_test', v_arr(v_len), rec.exhibit_type) is null then
        pkg_law_log.log_error(sp_methodname,
                              i_task_id,
                              i_user_name,
                              '��ʽ' || p_index_code || '�ļ�������' || p_index_cond || '���ô���:' || v_arr(v_len),
                              '');
        return - 3;
      end if;
    end loop;
    return 1;
  end f_check_cond;
  
  --���ܣ����ְ���ļ��㹫ʽ
  --������i_rank_code ְ������
  --      i_rank_cond ְ��������������[80,90)|[6000000,+��)
  function f_check_rank(i_rank_code  in char, --ְ������
                        i_rank_cond  in char, --����������[80,90)|[6000000,+��)
                        i_version_id in char,
                        i_task_name  in char,
                        i_task_id    in integer) return integer is
    v_methodname varchar2(128);
    v_arr        pkg_law_func.ty_array;
    sp_cnt       integer;
    sp_index     integer;
  begin
    v_methodname := 'pkg_law_check.f_check_rank';
  
    --1.��鹫ʽ�������Ƿ������ĵĶ��š���������
    if instr('��', i_rank_cond) > 0 or instr('��', i_rank_cond) > 0 or instr('��', i_rank_cond) > 0 then
      return - 1;
    end if;
    --ְ�����㹫ʽ�����飩
    v_arr := pkg_law_func.split(i_rank_cond, '|');
    select count(0)
      into sp_cnt
      from t_rank_factor t --ְ����������ָ���
     where 1 = 1
       and t.version_id = '1'
          --and t.version_id = p_version_id
       and t.rank_code = i_rank_code;
    --2.���ְ�����㹫ʽ�еĲ�����ְ�����ع�ϵ���еĲ����Ƿ����
    if sp_cnt <> v_arr.count then
      return - 2;
    end if;
  
    sp_index := 0;
    --3.���ְ�����㹫ʽ
    for rec in (select t.*
                  from t_rank_factor t
                 where 1 = 1
                   and t.version_id = '1'
                      --and t.version_id = p_version_id
                   and t.rank_code = i_rank_code
                 order by t.order_no) loop
      sp_index := sp_index + 1;
      -- ���ְ�����������Ƿ����
      if pkg_law_func.f_calc_cond('field_test', v_arr(sp_index), rec.exhibit_type) is null then
        pkg_law_log.log_error(v_methodname,
                              i_task_id,
                              i_task_name,
                              '������' || i_version_id || 'ְ��' || i_rank_code || '�ļ�������' || i_rank_cond || '���ô���:' ||
                              v_arr(sp_index),
                              '');
        return - 3;
      end if;
    end loop;
    return 1;
  end f_check_rank;
  */

  --����ְ�������ж��Ƿ�Ϊ�ŶӾ���,0-�ͻ�����1-�ŶӾ���2-����
  function f_check_leader(i_rank_code in char) return char is
    v_manager_flag varchar2(50) := '-1';
  begin
    select max(t.manager_flag)
      into v_manager_flag
      from t_law_rank_def t
     where t.valid_ind = '1'
       and t.rank_code = i_rank_code;
    --
    return v_manager_flag;
  end f_check_leader;

  --�������Ƿ������ŶӾ����ͻ�������
  function f_mgr_cfg(i_version_id varchar2,
                     i_user_name  in varchar2,
                     i_task_id    in varchar2 --
                     ) return char is
    v_return_flag char(1);
    v_func_name   varchar(30) := 'pkg_law_check.f_mgr_cfg';
  begin
    --ȡ������������ŶӾ����ͻ������˿���
    select t.is_client_manager_check
      into v_return_flag
      from t_law_define_config t
     where t.valid_ind = '1'
       and t.version_id = i_version_id;
    --����boolean���
    return '1';
  exception
    when no_data_found then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '�������������ŶӾ����Ƿ񰴿ͻ������˳���,������ID:' || i_version_id,
                            sqlerrm);
      return '-1';
  end f_mgr_cfg;

  --�ж��Ƿ��ŶӾ����ͻ������ˡ����أ�0-��1-��
  function f_mgr_cus(i_manager_flag in varchar2,
                     i_sales_code   in varchar2,
                     i_rank_code    in varchar2,
                     i_rank_two     in varchar2,
                     i_user_name    in varchar2,
                     i_task_id      in varchar2 --
                     ) return char is
    v_return char(2) := '-1';
  begin
    --���ŶӾ�����������ְ����
    if (i_manager_flag <> '1' or i_rank_two is null or i_sales_code = i_rank_two) then
      v_return := 1;
    end if;
    return v_return;
  end f_mgr_cus;

  --�ж��Ƿ��ŶӾ����ͻ������ˡ����أ�0-��1-��
  function f_check_mgr_cal_by_cus(i_is_client_manager_check varchar2, --�ŶӾ����Ƿ���Ҫ���ͻ�������
                                  i_manager_flag            varchar2, --ְ������
                                  i_rank_code               varchar2, --ְ��
                                  i_sale_rank_two           varchar2 --�����Ŷӳ����ͻ������˵�ְ��
                                  ) return varchar2 is
    v_return_flag varchar2(1) := '0';
  begin
    --����ǿͻ��������أ��������ŶӾ����ͻ������ˣ�����Ա���ŶӾ�����SALE_RANK_TWO��Ϊ��
    if (i_is_client_manager_check = '1' and i_manager_flag = '1' and i_sale_rank_two is not null and
       i_sale_rank_two <> i_rank_code) then
      v_return_flag := '1';
    end if;
    return v_return_flag;
  end f_check_mgr_cal_by_cus;

  --��������������������Ƿ������á�-1��δ���ã�1��������
  function f_check_law_define_cfg(i_version_id varchar2 --�汾����
                                  ) return varchar2 is
    v_count number := 0;
  begin
    select count(1)
      into v_count
      from t_law_define_config t
     where t.valid_ind = '1' --��Ч
       and t.version_id = i_version_id;
    if v_count = 0 then
      return '-1';
    else
      return '1';
    end if;
  end f_check_law_define_cfg;

end pkg_law_check;
/
