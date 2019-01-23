create or replace package pkg_law_func is

  -- author  : sunyf
  -- created : 2014-9-01 16:01:04
  -- purpose : �������߰�

  --
  type ty_array is table of varchar2(128);

  function split(p_sourcestr in char, p_splitstr in char) return ty_array;

  function f_calc_cond(i_field in char, -- 'field_test'
                       i_cond  in char, -- �������ʽ���磺(120,+��)|any|any, {1, 2, 3, }
                       i_type  in int -- �������ͣ�1���ڣ�2���䣬3ö��
                       ) return varchar2;

  function is_table_exists(p_tablename in char) return boolean;

  function lock_person(i_calc_month   in char,
                       i_dept_code    in char,
                       i_line_code    in char,
                       p_user_name    in char,
                       i_task_id      in char,
                       i_version_code char) return integer;

  function unlock_person(i_calc_month   in char,
                         i_dept_code    in char,
                         i_line_code    in char,
                         i_user_name    in char,
                         i_task_id      in char,
                         i_version_code in char) return integer;
                         
  --��ȡ����ʱ��
  function get_spend_time(i_begin_time in date) return number;
end pkg_law_func;
/
create or replace package body pkg_law_func is

  -- �ֿ��ַ�
  -- ������p_sourcestr Դ�ַ���
  --       p_splitstr  �ָ�����
  function split(p_sourcestr in char, p_splitstr in char) return ty_array is
    arr  ty_array := ty_array();
    i    integer := 0;
    j    integer := 1;
    len1 integer;
    len2 integer;
    str  varchar2(128);
  begin
    len1 := length(p_sourcestr);
    len2 := length(p_splitstr);
    while i < len1 loop
      i := instr(p_sourcestr, p_splitstr, j);
      if i = 0 then
        i   := len1;
        str := substr(p_sourcestr, j);
        arr.extend;
        arr(arr.count) := str;
      else
        str := substr(p_sourcestr, j, i - j);
        j   := i + len2;
        arr.extend;
        arr(arr.count) := str;
      end if;
    end loop;
    return arr;
  end split;

  --���ܣ���֤��ʽ��������1���ڣ�2���䣬3ö��
  --������i_field����ʽ����,����Ǽ��������������볣���ַ���
  --      i_cond���������ʽ���磺(120,+��)|any|any, {1, 2, 3, }
  --      i_type���������ͣ�1���ڣ�2���䣬3ö��
  --���أ�1.�ǿ��ַ�����������ת��Ϊsql
  --      2.Ϊ���ַ��ܣ����õ���������
  function f_calc_cond(i_field in char, -- 'field_test'
                       i_cond  in char, -- �������ʽ���磺(120,+��)|any|any, {1, 2, 3, }
                       i_type  in int -- �������ͣ�1���ڣ�2���䣬3ö��
                       ) return varchar2 is
    v_cond_sql varchar2(1024); --���ص������ַ���
    v_sub_str1 varchar2(1024);
    v_sub_str2 varchar2(1024);
    v_arr      ty_array := ty_array();
  begin
    v_cond_sql := null;
  
    --��ӡ
    --dbms_output.put_line(p_field||':'||p_cond);
  
    --any
    if instr(i_cond, 'any') > 0 then
      return '1=1';
    end if;
  
    --null
    if instr(i_cond, 'null') > 0 then
      return i_field || ' is ' || i_cond;
    end if;
  
    --1.����
    if i_type = 1 then
      v_cond_sql := i_field || '=' || i_cond;
    end if;
  
    --2.����
    if i_type = 2 then
      v_arr := split(i_cond, ',');
      --
      if v_arr.count <> 2 then
        v_cond_sql := null;
      else
        --����
        if substr(v_arr(1), 1, 1) in ('(', '[') and substr(v_arr(2), length(v_arr(2)), 1) in (')', ']') then
          if instr(v_arr(1), '+��') > 0 or instr(v_arr(2), '-��') > 0 then
            v_cond_sql := null;
          else
            v_cond_sql := '';
            if instr(v_arr(1), '-��') > 0 then
              v_sub_str1 := null;
            else
              if substr(v_arr(1), 1, 1) = '(' then
                v_sub_str1 := i_field || '>' || substr(v_arr(1), 2);
              else
                v_sub_str1 := i_field || '>=' || substr(v_arr(1), 2);
              end if;
            end if;
            if instr(v_arr(2), '+��') > 0 then
              v_sub_str2 := null;
            else
              if substr(v_arr(2), length(v_arr(2)), 1) = ')' then
                v_sub_str2 := i_field || '<' || substr(v_arr(2), 1, length(v_arr(2)) - 1);
              else
                v_sub_str2 := i_field || '<=' || substr(v_arr(2), 1, length(v_arr(2)) - 1);
              end if;
            end if;
            if v_sub_str1 is not null then
              v_cond_sql := v_cond_sql || v_sub_str1;
            end if;
            if v_sub_str1 is not null and v_sub_str2 is not null then
              v_cond_sql := v_cond_sql || ' and ';
            end if;
            if v_sub_str2 is not null then
              v_cond_sql := v_cond_sql || v_sub_str2;
            end if;
            if v_cond_sql is null then
              v_cond_sql := '1=1';
            end if;
          end if;
        else
          v_cond_sql := null;
        end if;
      end if;
    end if;
  
    --3.ö��
    if i_type = 3 then
      if substr(i_cond, 1, 1) <> '{' or substr(i_cond, length(i_cond), 1) <> '}' then
        v_cond_sql := null;
      else
        v_cond_sql := i_field || ' in (' || substr(i_cond, 2, length(i_cond) - 2) || ')';
      end if;
    end if;
    return v_cond_sql;
  end f_calc_cond;

  /*��֤���Ƿ����*/
  function is_table_exists(p_tablename in char) return boolean is
    cnt int;
  begin
    select count(table_name) into cnt from user_tables where table_name = upper(p_tablename);
    if cnt > 0 then
      return true;
    else
      return false;
    end if;
  end is_table_exists;

  --������Ա����ͳ���·ݡ��������汾�����š�ҵ���߼���
  function lock_person(i_calc_month   in char,
                       i_dept_code    in char,
                       i_line_code    in char,
                       p_user_name    in char,
                       i_task_id      in char,
                       i_version_code char) return integer is
    v_person_sql varchar2(1024);
    v_func_name  varchar2(30) := 'pkg_law_func.lock_person';
    pragma autonomous_transaction;
  begin
    v_person_sql := 'update t_law_salesman set busy_flag = ' || i_task_id || ' where busy_flag = 0 ';
    v_person_sql := v_person_sql || ' and calc_month = ''' || i_calc_month;
    v_person_sql := v_person_sql || ''' and version_id = ''' || i_version_code;
    v_person_sql := v_person_sql || ''' and dept_code = ''' || i_dept_code;
    v_person_sql := v_person_sql || ''' and line_code  = ''' || i_line_code || '''';
    --
    pkg_law_log.log_debug(v_func_name, i_task_id, p_user_name, '����', v_person_sql);
    begin
      execute immediate v_person_sql;
      commit;
    exception
      when others then
        pkg_law_log.log_error(v_func_name, i_task_id, p_user_name, '������Աʧ��', '');
    end;
    return 1;
  end lock_person;

  --������Ա
  function unlock_person(i_calc_month   in char,
                         i_dept_code    in char,
                         i_line_code    in char,
                         i_user_name    in char,
                         i_task_id      in char,
                         i_version_code in char) return integer is
    v_person_sql varchar2(1024);
    v_func_name  varchar2(30) := 'pkg_law_func.unlock_person';
    pragma autonomous_transaction;
  begin
    --
    v_person_sql := 'update t_law_salesman set busy_flag = 0 where 1=1 ';
    v_person_sql := v_person_sql || ' and busy_flag = ' || i_task_id;
    v_person_sql := v_person_sql || ' and calc_month = ''' || i_calc_month;
    v_person_sql := v_person_sql || ''' and version_id = ''' || i_version_code;
    v_person_sql := v_person_sql || ''' and dept_code = ''' || i_dept_code;
    v_person_sql := v_person_sql || ''' and line_code = ''' || i_line_code || '''';
  
    pkg_law_log.log_debug(v_func_name, i_task_id, i_user_name, '����', v_person_sql);
  
    begin
      execute immediate v_person_sql;
      commit;
    exception
      when others then
        pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '������Աʧ��', '');
    end;
    return 1;
  end unlock_person;

  --��ȡ����ʱ��
  function get_spend_time(i_begin_time in date) return number is
    v_spend_time number;
  begin
    select ROUND(TO_NUMBER(sysdate - i_begin_time) * 24 * 60 * 60) into v_spend_time from dual;
    return v_spend_time;
  end get_spend_time;

end pkg_law_func;
/
