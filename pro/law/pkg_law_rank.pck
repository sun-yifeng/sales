create or replace package pkg_law_rank is

  -- author  : sunyf
  -- created : 2014/10/22 08:23:02
  -- purpose : ְ�����˼���

  -- ����Ƶ�ȣ�һ��ļ�������
  cons_freq constant number := 4;

  -- ��ְ������
  cons_null constant varchar2(20) := '100000000000000'; --000000000000000

  function f_oper_1(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  -- ���˲���2ά��
  function f_oper_2(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_3(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_4(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_5(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_6(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_7(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_8(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_9(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) return varchar2;

  function f_oper_10(i_version_id in varchar2, --�������汾��
                     i_dept_code  in varchar2, --��������
                     i_line_code  in varchar2, --ҵ���ߴ���
                     i_calc_month in varchar2, --�����·�
                     i_sale_code  in varchar2, --������Ա
                     i_rank_code  in varchar2, --��ǰְ��
                     i_user_name  in varchar2, --�����û�
                     i_task_id    in varchar2) return varchar2;

  function f_init_rank(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ����
                       i_version_id in varchar2, --��������
                       i_calc_month in varchar2, --��������
                       i_user_name  in varchar2, --�����û�
                       i_task_id    in varchar2) return boolean;

  function f_calc_reco(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ���ߴ���
                       i_version_id in varchar2, --�������汾��
                       i_calc_month in varchar2, --�����·�
                       i_user_name  in varchar2, --������
                       i_task_id    in varchar2) return boolean;

  function f_tran_rank(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ���ߴ���
                       i_version_id in varchar2, --�������汾��
                       i_calc_month in varchar2, --�����·�
                       i_user_name  in varchar2, --������
                       i_task_id    in varchar2) return boolean;

  function f_tran_code(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ���ߴ���
                       i_version_id in varchar2, --�������汾��
                       i_calc_month in varchar2, --�����·�
                       i_user_name  in varchar2, --������
                       i_task_id    in varchar2) return boolean;

  -- ����ְ��
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2, --
               i_task_id    in varchar2) return varchar2;
end pkg_law_rank;
/
create or replace package body pkg_law_rank is

  -- author  : sunyf
  -- created : 2014/10/22 08:23:02
  -- purpose : ְ�����˼���
  -- ��ȡ��ǰְ�����͵����ְ��(�ж�����̭��),Ҫע�⣺
  --1��������������е������֣�����Ҫ����"�����ͻ�����F","�����ŶӾ���E"����������ֵ����򲻿���"�����ͻ�����F","�����ŶӾ���E"��
  --2����Ա����ҳ�棬��ѡ��ͬ�ǣ�����Ҫ����"�����ͻ�����F","�����ŶӾ���E"�������ѡ��ͬ�ǣ��򲻿���"�����ͻ�����F","�����ŶӾ���E"��
  -- �ܽ᣺"�����ͻ�����F","�����ŶӾ���E"��ֻ��Ӧ����ػ������������Ա��

  /* ���˲�����ѡ�����
  1  �������껯��׼���Ѷ�Ӧ��ְ��
  2  ά�����е�����ְ��
  3  ������һ��
  4  ���½�һ��
  5  ���͵��ֹ�˾���ְ��
  6  ������
  7  ������
  8  TODO:δʹ��
  9  ���ϸ�(����)
  10 ������(�껯����/95%)��Ӧ��ְ��
  */

  -- ���˲���1�������걣��Ӧְ��
  function f_oper_1(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_rank_code  varchar2(30);
    v_pram_str1  varchar2(500);
    v_stan_prem  number(20, 4); --��׼����
    v_work_time  number(20, 4); --�ڸ�ʱ��
    v_year_stan  number(20, 4); --�껯�걣
    v_curr_level number; --��ǰְ��
    i_lead_flag  char(1); --��������
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_1';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --dbms_output.put_line('v_curr_level:' || v_curr_level || ',i_lead_flag:' || i_lead_flag);
    --ȡ�����ۼƱ�׼����
    if(i_dept_code = '10')then
    	select case
             when i_lead_flag = '0' then
              t.a005 - t.a034
             when i_lead_flag = '1' then
              t.a105 - t.a149
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    else
      select case
             when i_lead_flag = '0' then
              t.a005
             when i_lead_flag = '1' then
              t.a105
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    end if;
    --dbms_output.put_line('v_stan_prem:' || v_stan_prem);
    --ȡ�ڸ�ʱ��
    select case
             when i_lead_flag = '0' then
              t.a001
             when i_lead_flag = '1' then
              t.a101
             else
              -1
           end
      into v_work_time
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    --���ܱ�0��
    if (v_work_time = 0) then
      v_work_time := -1;
    end if;
    --dbms_output.put_line('v_work_time:' || v_work_time);
    --�����Ķ�Ӧְ��
    begin
      select t.rank_code
        into v_rank_code
        from t_law_rank_def t
       where 1 = 1
         and t.valid_ind = '1'
         and t.item_status = '1'
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.version_id = i_version_id
         and t.manager_flag = i_lead_flag
         and t.levle_no = (select max(t1.levle_no)
                             from t_law_rank_def t1
                            where 1 = 1
                              and t1.valid_ind = '1'
                              and t1.item_status = '1'
                              and t1.levle_no is not null
                              and t1.dept_code = i_dept_code
                              and t1.line_code = i_line_code
                              and t1.version_id = i_version_id
                              and t1.manager_flag = i_lead_flag
                              and t1.norm_premium <= (v_stan_prem * 12) / (10000 * v_work_time) --
                           );
    exception
      when no_data_found then
        pkg_law_log.log_warning(v_func_name,
                                i_task_id,
                                i_user_name,
                                '���˲���1�������걣��Ӧְ��',
                                sqlerrm || ',��׼����̫��,�Ҳ�����Ӧ����,ϵͳ������������,���鿼�˼����������걣����:' || v_stan_prem || ',������Ա:' ||
                                i_sale_code);
        return v_rank_code;
    end;
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '���˲���1�������걣��Ӧְ��',
                            sqlerrm || ',������Ա:' || i_sale_code || '�����·�:' || i_calc_month || ',��׼����:' || v_stan_prem ||
                            ',�ڸ�ʱ��:' || v_work_time || ',�껯�걣:' || to_char((v_stan_prem * 12) / (10000 * v_work_time)) ||
                            ',�Ƽ�ְ��:' || v_rank_code);
  end f_oper_1;

  -- ���˲���2ά��
  function f_oper_2(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_func_name varchar2(30) := 'pkg_law_rank.f_oper_2';
  begin
    return i_rank_code;
  end f_oper_2;

  -- ���˲���3��һ��
  function f_oper_3(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_top1_level number;
    v_rank_code  varchar2(30);
    v_lead_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_3';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, v_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --ȡ��߼���
    select max(t.levle_no)
      into v_top1_level
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.levle_no is not null
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag;
    --�����ǰ����Ϊ��߼����򷵻�ԭְ��
    if (v_curr_level = v_top1_level) then
      return i_rank_code;
    end if;
    --�����ǰ�������߼�������һ��ְ��
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag
       and t.levle_no = v_curr_level + 1;
    --return
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���˲���3��һ��' || i_sale_code, sqlerrm);
  end f_oper_3;

  -- ���˲���4��һ��
  function f_oper_4(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_low1_level number;
    v_rank_code  varchar2(30);
    v_lead_flag  char(1);
    v_area_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_4';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, v_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --ȡ���ְ��
    select min(t.levle_no)
      into v_low1_level
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.levle_no is not null
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag;
    --�����ǰְ��Ϊ��ͣ��򷵻�ԭְ��
    if (v_curr_level = v_low1_level) then
      return i_rank_code;
    end if;
    --�����ǰְ������ͣ���һ��ְ��
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag
       and t.levle_no = v_curr_level - 1;
    --return
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���˲���4��һ��' || i_sale_code, sqlerrm);
  end f_oper_4;

  -- ���˲���5���͵����ְ��
  function f_oper_5(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_low1_level number;
    v_rank_code  varchar2(30);
    i_lead_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_5';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --ȡ���ְ��
    select min(t.levle_no)
      into v_low1_level
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.levle_no is not null
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag;
    --�����ǰְ����ͣ��򷵻�ԭְ��
    if (v_curr_level = v_low1_level) then
      return i_rank_code;
    end if;
    --ȡ���ְ��
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag
       and t.levle_no = 1;
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���˲���5���͵����ְ��' || i_sale_code, sqlerrm);
  end f_oper_5;

  -- ���˲���6����������
  function f_oper_6(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    i_lead_flag  char(1);
    v_area_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_6';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --�����ǰ����С�ڵ���3
    if (v_curr_level <= 3) then
      select t.rank_code
        into v_rank_code
        from t_law_rank_def t
       where t.version_id = i_version_id
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.manager_flag = i_lead_flag
         and t.levle_no = 1;
      return v_rank_code;
    end if;
    --���������������
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag
       and t.levle_no = v_curr_level - 2;
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���˲���6����������' || i_sale_code, sqlerrm);
  end f_oper_6;

  -- ���˲���7����������
  function f_oper_7(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    i_lead_flag  char(1);
    v_area_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_7';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --�����ǰ����С��4
    if (v_curr_level <= 4) then
      select t.rank_code
        into v_rank_code
        from t_law_rank_def t
       where 1 = 1
         and t.valid_ind = '1'
         and t.item_status = '1'
         and t.version_id = i_version_id
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.manager_flag = i_lead_flag
         and t.levle_no = 1;
      return v_rank_code;
    end if;
    --���������������
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag
       and t.levle_no = v_curr_level - 3;
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���˲���7����������' || i_sale_code, sqlerrm);
  end f_oper_7;

  -- ���˲���8TODO��δʹ���������
  function f_oper_8(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_8';
  begin
    return 'TODO:';
  end f_oper_8;

  -- ���˲���9����̭�����ϸ�
  function f_oper_9(i_version_id in varchar2, --�������汾��
                    i_dept_code  in varchar2, --��������
                    i_line_code  in varchar2, --ҵ���ߴ���
                    i_calc_month in varchar2, --�����·�
                    i_sale_code  in varchar2, --������Ա
                    i_rank_code  in varchar2, --��ǰְ��
                    i_user_name  in varchar2, --�����û�
                    i_task_id    in varchar2) --����id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_9';
  begin
    return upper('t');
  end f_oper_9;

  -- ���˲���10������(�껯����/95%)��Ӧ��ְ��
  function f_oper_10(i_version_id in varchar2, --�������汾��
                     i_dept_code  in varchar2, --��������
                     i_line_code  in varchar2, --ҵ���ߴ���
                     i_calc_month in varchar2, --�����·�
                     i_sale_code  in varchar2, --������Ա
                     i_rank_code  in varchar2, --��ǰְ��
                     i_user_name  in varchar2, --�����û�
                     i_task_id    in varchar2) --����id
   return varchar2 is
    v_rank_code  varchar2(30);
    v_work_time  number(20, 4); --�ڸ�ʱ��
    v_year_stan  number(20, 4); --�껯�걣
    v_stan_prem  number(16, 4); --��׼����
    v_curr_level number;
    i_lead_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_10';
  begin
    --ȡ�Ƽ�ְ��
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --��ǰְ����
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --ȡ�����ۼƱ�׼����
    if(i_dept_code = '10')then
    	select case
             when i_lead_flag = '0' then
              t.a005 - t.a034
             when i_lead_flag = '1' then
              t.a105 - t.a149
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    else
      select case
             when i_lead_flag = '0' then
              t.a005
             when i_lead_flag = '1' then
              t.a105
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    end if;
    --ȡ�ڸ�ʱ��
    select case
             when i_lead_flag = '0' then
              t.a001
             when i_lead_flag = '1' then
              t.a101
             else
              -1
           end
      into v_work_time
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    -- �����Ķ�Ӧְ��
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.version_id = i_version_id
       and t.manager_flag = i_lead_flag
       and t.levle_no = (select max(t1.levle_no)
                           from t_law_rank_def t1
                          where 1 = 1
                            and t.valid_ind = '1'
                            and t1.item_status = '1'
                            and t1.levle_no is not null
                            and t1.dept_code = i_dept_code
                            and t1.line_code = i_line_code
                            and t1.version_id = i_version_id
                            and t1.manager_flag = i_lead_flag
                            and t1.norm_premium <= (v_stan_prem * 12) / (10000 * v_work_time * 0.95) --
                         );
    --��־
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          '���˲���1�������걣��Ӧְ��', --
                          '������Ա:' || i_sale_code || '�����·�:' || i_calc_month || ',��׼����:' || v_stan_prem || ',�ڸ�ʱ��:' ||
                          v_work_time || ',�껯�걣:' || (v_stan_prem * 12) / (10000 * v_work_time * 0.95) || ',�Ƽ�ְ��:' ||
                          v_rank_code);
  
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '���˲���1�������걣��Ӧְ��' || i_sale_code, sqlerrm);
  end f_oper_10;

  --ÿ�μ���ְ��ʱ����Ҫ����������Ϊ�ֹ�˾ʹ����Щְ���ǲ�ȷ����
  function f_adjust_level(i_dept_code  in varchar2, --��������
                          i_line_code  in varchar2, --ҵ����
                          i_version_id in varchar2, --��������
                          i_calc_month in varchar2, --��������
                          i_user_name  in varchar2, --�����û�
                          i_task_id    in varchar2) return boolean is
    v_levle_1   integer := 1;
    v_levle_2   integer := 1;
    v_func_name varchar2(30) := 'pkg_law_rank.f_adjust_level';
  begin
    --��ռ���
    update t_law_rank_def t
       set t.levle_no = ''
     where 1 = 1
          --and t.valid_ind = '1'
          --and t.item_status = '1'
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.version_id = i_version_id;
  
    --�ͻ�����0
    for c in (select t.pk_id
                from t_law_rank_def t
               where t.valid_ind = '1'
                 and t.item_status = '1'
                 and t.manager_flag = '0'
                 and t.dept_code = i_dept_code
                 and t.line_code = i_line_code
                 and t.version_id = i_version_id
                 and t.norm_premium is not null
               order by t.norm_premium) loop
      --���¼���
      update t_law_rank_def t set t.levle_no = v_levle_1 where t.pk_id = c.pk_id;
      --��������
      v_levle_1 := v_levle_1 + 1;
    end loop;
  
    --�ŶӾ���1
    for c in (select t.pk_id
                from t_law_rank_def t
               where t.valid_ind = '1'
                 and t.item_status = '1'
                 and t.manager_flag = '1'
                 and t.dept_code = i_dept_code
                 and t.line_code = i_line_code
                 and t.version_id = i_version_id
                 and t.norm_premium is not null
               order by t.norm_premium) loop
      --���¼���
      update t_law_rank_def t set t.levle_no = v_levle_2 where t.pk_id = c.pk_id;
      --��������
      v_levle_2 := v_levle_2 + 1;
    end loop;
    --
    commit;
    return true;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '��������ʱ����i_dept_code:' || i_dept_code || ',i_line_code:' || i_line_code || ',i_calc_month:' ||
                            i_calc_month,
                            sqlerrm);
      rollback;
      return false;
  end f_adjust_level;

  --�������
  function f_clean_data(i_dept_code  in varchar2, --��������
                        i_line_code  in varchar2, --ҵ����
                        i_version_id in varchar2, --��������
                        i_calc_month in varchar2, --��������
                        i_user_name  in varchar2, --�����û�
                        i_task_id    in varchar2) return boolean is
    v_func_name varchar2(30) := 'pkg_law_rank.f_clean_data';
  begin
    --
    delete from review_rank t
     where 1 = 1
       and t.line_code = i_line_code
       and t.dept_code_two = i_dept_code
       and t.calc_month = i_calc_month;
    --��չ��̼�¼
    delete from t_law_calc_proce t
     where t.dept_code = i_dept_code
       and t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.line_code = i_line_code
       and t.calc_type = '3';
    --
    commit;
    return true;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '�������ʱ����i_dept_code:' || i_dept_code || ',i_line_code:' || i_line_code || ',i_calc_month:' ||
                            i_calc_month,
                            sqlerrm);
      rollback;
      return false;
  end f_clean_data;

  --��ʼ��ְ������(�Ȳ���ԭְ����Ϊ�Ƽ�ְ��)
  function f_init_rank(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ����
                       i_version_id in varchar2, --��������
                       i_calc_month in varchar2, --��������
                       i_user_name  in varchar2, --�����û�
                       i_task_id    in varchar2) return boolean is
    v_func_name varchar2(30) := 'pkg_law_rank.f_rank_rank';
  begin
    --ְ�����˱�����
    insert into review_rank
      (rank_id,
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
       recommend_rank,
       rank_score,
       prem_rate,
       confirm_status,
       line_code,
       valid_ind,
       created_user,
       created_date,
       updated_user,
       updated_date,
       cus_recommend_rank)
      select sys_guid(),
             i_calc_month,
             t2.dept_code dept_code_two,
             t2.dept_simple_name dept_name_two,
             t3.dept_code dept_code_three,
             t3.dept_simple_name dept_name_three,
             t4.dept_code dept_code_four,
             t4.dept_simple_name dept_name_four,
             t1.group_code,
             t5.group_name,
             t1.salesman_code,
             t1.salesman_cname,
             t1.sale_rank,
             t6.rank_name,
             t1.sale_rank,
             t7.score,
             t7.tatol_prem_rate,
             '0',
             t1.business_line,
             '1',
             'admin',
             sysdate,
             'admin',
             to_char(sysdate, 'yyyy-mm-dd hh:mm:ss'),
             t.sale_rank_two
        from t_law_salesman t
        left join salesman t1
          on t.salesman_code = t1.salesman_code
        left join department t2
          on substr(t1.dept_code, 1, 2) = t2.dept_code
        left join department t3
          on substr(t1.dept_code, 1, 4) = t3.dept_code
        left join department t4
          on substr(t1.dept_code, 1, 8) = t4.dept_code
        left join group_main t5
          on t1.group_code = t5.group_code
        left join t_law_rank_def t6
          on t1.sale_rank = t6.rank_code
        left join review_score t7
          on t1.salesman_code = t7.salesman_code
         and t7.calc_month = i_calc_month
         and t7.line_code = i_line_code
         and t7.rank_code = t1.sale_rank --�ŶӾ����ͻ�������review_score������������¼��������Ӵ���������
       where 1 = 1
         and t.version_id = i_version_id
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.calc_month = i_calc_month;
    return true;
    commit;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '��ʼְ������ʱ����i_dept_code:' || i_dept_code || ',i_line_code:' || i_line_code ||
                            ',i_calc_month:' || i_calc_month,
                            sqlerrm);
      rollback;
      return false;
  end f_init_rank;

  --�����Ƽ�ְ����ѭ��ÿ��������ˣ�
  function f_calc_reco(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ���ߴ���
                       i_version_id in varchar2, --�������汾��
                       i_calc_month in varchar2, --�����·�
                       i_user_name  in varchar2, --������
                       i_task_id    in varchar2) return boolean is
    v_sql_count  varchar2(1000) := ''; --ͳ�ƽű�
    v_sql_result integer := 0; --ͳ�ƽ��
    v_sql_func   varchar2(200) := ''; --�����ű�
    v_sql_para   varchar2(200) := ''; --��������
    v_sql_proc   varchar2(1000) := ''; --�������
    v_reco_rank  varchar2(30) := ''; --�Ƽ�ְ��
    v_calc_flag  char(1) := '1'; --�Ŷӳ����ͻ�������
    v_tmp_rank   varchar2(200) := ''; --��ʱְ��
    v_func_name  varchar2(30) := 'pkg_law_rank.f_calc_rank';
  begin
    --���ͻ�������
    select t.is_client_manager_check into v_calc_flag from t_law_define_config t where t.version_id = i_version_id;
    --ȡ���˵���Ա
    for c_sales in (select t.salesman_code, t.manager_flag, t.rank_code, t.sale_rank_two
                      from t_law_salesman t
                     where 1 = 1
                       and t.version_id = i_version_id
                       and t.dept_code = i_dept_code
                       and t.line_code = i_line_code
                       and t.calc_month = i_calc_month) loop
      begin
        savepoint sp;
        --ȡ���еĹ���
        for c_rules in (select t.calc_code, t.calc_note, t.calc_cond, t.item_type, t.calc_desc
                          from t_law_calc_review t
                         where 1 = 1
                           and t.valid_ind = '1'
                           and t.item_status = '1'
                           and t.version_id = i_version_id
                         order by t.calc_code) loop
          --�Ƿ��������
          v_sql_count := 'select count(1) from t_law_calc_extra t where t.dept_code =''' || i_dept_code ||
                         ''' and t.calc_month = ''' || i_calc_month || ''' and t.sales_code = ''' ||
                         c_sales.salesman_code || ''' and (' || c_rules.calc_cond || ')';
          execute immediate v_sql_count
            into v_sql_result;
          --������ϼ�������
          if (v_sql_result > 0) then
            --���ְ������ƥ�䣨�ͻ�����Ĺ���Կͻ������ŶӾ���Ĺ�����ŶӾ���
            if (c_rules.item_type = c_sales.manager_flag) then
              --��ѯ�Ƽ�ְ��              
              select t.recommend_rank
                into v_tmp_rank
                from review_rank t
               where t.calc_month = i_calc_month
                 and t.dept_code_two = i_dept_code
                 and t.salesman_code = c_sales.salesman_code;
              --�����������
              v_sql_para := i_version_id || ',' || i_dept_code || ',' || i_line_code || ',' || i_calc_month || ',' ||
                            c_sales.salesman_code || ',' || v_tmp_rank || ',' || i_user_name || ',' || i_task_id;
              --�����Ƽ�ְ��
              v_sql_func := 'begin :v0 := pkg_law_rank.f_oper_' || c_rules.calc_note ||
                            '(:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8); end;';
              execute immediate v_sql_func
                using out v_reco_rank, i_version_id, i_dept_code, i_line_code, i_calc_month, c_sales.salesman_code, v_tmp_rank, i_user_name, i_task_id;
              --��¼������̣���������Ϊ3��
              v_sql_proc := 'insert into t_law_calc_proce select sys_guid(),''' || i_version_id || ''',''' ||
                            i_calc_month || ''',''' || i_dept_code || ''',''' || i_line_code || ''',''' ||
                            c_rules.calc_code || ''',''---'',''' || nvl(trim(c_rules.calc_cond), '---') || ''',''' ||
                            c_rules.calc_note || ''', 1, ''' || i_user_name || ''', sysdate, ''' || i_user_name ||
                            ''', sysdate, ''' || c_sales.salesman_code || ''',''3'',''' || c_rules.calc_note ||
                            ''', null,''' || v_reco_rank || ''' from dual';
              execute immediate v_sql_proc;
              --���¿��˲������Ƽ�ְ������һְ����
              if (c_rules.calc_note is not null and v_reco_rank is not null) then
                update review_rank t
                   set t.recommend_rank = v_reco_rank
                 where t.valid_ind = '1'
                   and t.dept_code_two = i_dept_code
                   and t.line_code = i_line_code
                   and t.calc_month = i_calc_month
                   and t.salesman_code = c_sales.salesman_code;
              end if;
              --���ְ�����Ͳ���(���������ŶӾ����ͻ������ˣ�������Ϊ�ͻ�����...)
            elsif (c_rules.item_type = '0' and c_sales.manager_flag = '1' and v_calc_flag = '1' and
                  c_sales.sale_rank_two is not null) then
              --��ѯ�Ƽ�ְ��              
              select t.cus_recommend_rank
                into v_tmp_rank
                from review_rank t
               where t.calc_month = i_calc_month
                 and t.dept_code_two = i_dept_code
                 and t.salesman_code = c_sales.salesman_code;
              --���������������������Ϊ3��
              v_sql_para := i_version_id || ',' || i_dept_code || ',' || i_line_code || ',' || i_calc_month || ',' ||
                            c_sales.salesman_code || ',' || v_tmp_rank || ',' || i_user_name || ',' || i_task_id;
              --�����Ƽ�ְ��
              v_sql_func := 'begin :v0 := pkg_law_rank.f_oper_' || c_rules.calc_note ||
                            '(:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8); end;';
              execute immediate v_sql_func
                using out v_reco_rank, i_version_id, i_dept_code, i_line_code, i_calc_month, c_sales.salesman_code, v_tmp_rank, i_user_name, i_task_id;
              --��¼�������(��������Ϊ3��
              v_sql_proc := 'insert into t_law_calc_proce select sys_guid(),''' || i_version_id || ''',''' ||
                            i_calc_month || ''',''' || i_dept_code || ''',''' || i_line_code || ''',''' ||
                            c_rules.calc_code || ''',''---'',''' || nvl(trim(c_rules.calc_cond), '---') || ''',''' ||
                            c_rules.calc_note || ''', 1, ''' || i_user_name || ''', sysdate, ''' || i_user_name ||
                            ''', sysdate, ''' || c_sales.salesman_code || ''',''3'',''' || c_rules.calc_note ||
                            ''', null,''' || v_reco_rank || ''' from dual';
              execute immediate v_sql_proc;
              --���¿��˲������Ƽ�ְ�����ڶ�ְ����
              if (c_rules.calc_note is not null and v_reco_rank is not null) then
                update review_rank t
                   set t.cus_recommend_rank = v_reco_rank
                 where t.valid_ind = '1'
                   and t.dept_code_two = i_dept_code
                   and t.line_code = i_line_code
                   and t.calc_month = i_calc_month
                   and t.salesman_code = c_sales.salesman_code;
              end if;
            end if;
          end if;
        end loop;
      exception
        when others then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '���㿼��ְ��ʱʧ��',
                                sqlerrm || ',����:' || v_sql_func || '����:' || v_sql_para || ',������Ŀ:' || v_sql_count ||
                                ',��¼����:' || v_sql_proc);
          rollback to sp;
      end;
      commit;
    end loop;
    commit;
    return true;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '���㿼��ְ��ʱʧ��',
                            sqlerrm || ',����:' || v_sql_func || '����:' || v_sql_para || ',������Ŀ:' || v_sql_count ||
                            ',��¼����:' || v_sql_proc);
      return true;
      rollback;
  end f_calc_reco;

  --ת�����������S��������J��������T��̭����Wά�֡�
  function f_tran_rank(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ���ߴ���
                       i_version_id in varchar2, --�������汾��
                       i_calc_month in varchar2, --�����·�
                       i_user_name  in varchar2, --������
                       i_task_id    in varchar2) return boolean is
    v_leve_no_1 integer;
    v_leve_no_2 integer;
    v_tran_ret1 char(1);
    v_tran_ret2 char(1);
    v_func_name varchar2(30) := 'pkg_law_rank.f_tran_rank';
  begin
    for c_rank in (select t.rank_id, t.salesman_code, t.rank_code, t.recommend_rank,t.cus_recommend_rank,t1.sale_rank_two
                     from review_rank t left join t_law_salesman t1 
                     on t1.salesman_code = t.salesman_code
                    where 1 = 1
                      and t.valid_ind = '1'
                      and t.dept_code_two = i_dept_code
                      and t.calc_month = i_calc_month
                      and t.line_code = i_line_code) loop
      begin
        savepoint sp;
        if (c_rank.recommend_rank = upper('t')) then
          --��̭����Ҫת��
          v_tran_ret1 := c_rank.recommend_rank;
        else
          --ȡԭ��ְ�ļ���
          select t1.levle_no
            into v_leve_no_1
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.rank_code;
          --ȡ�Ƽ�ְ�ļ���
          select t1.levle_no
            into v_leve_no_2
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.recommend_rank;
          --ת���������
          if (v_leve_no_1 = v_leve_no_2) then
            v_tran_ret1 := upper('w');
          elsif (v_leve_no_1 < v_leve_no_2) then
            v_tran_ret1 := upper('s');
          elsif (v_leve_no_1 > v_leve_no_2) then
            v_tran_ret1 := upper('j');
          else
            v_tran_ret1 := upper('t');
          end if;
        end if;
        
        --����ڶ�ְ���Ƽ�ְ��Ϊ����̭��
        if(c_rank.sale_rank_two is not null and c_rank.cus_recommend_rank is not null)then
          if(c_rank.cus_recommend_rank = upper('t')) then
             v_tran_ret2 := c_rank.cus_recommend_rank;
           else
         
           --ȡԭ��ְ�ļ���
          select t1.levle_no
            into v_leve_no_1
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.sale_rank_two;
          --ȡ�Ƽ�ְ�ļ���
          select t1.levle_no
            into v_leve_no_2
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.cus_recommend_rank;
          --ת���������
          if (v_leve_no_1 = v_leve_no_2) then
            v_tran_ret2 := upper('w');
          elsif (v_leve_no_1 < v_leve_no_2) then
            v_tran_ret2 := upper('s');
          elsif (v_leve_no_1 > v_leve_no_2) then
            v_tran_ret2 := upper('j');
          else
            v_tran_ret2 := upper('t');
          end if;                       
         end if; 
         update review_rank t set t.cus_review_result = v_tran_ret2 where t.rank_id = c_rank.rank_id;                       
        end if;
                 
        --�����������  
        update review_rank t set t.review_result = v_tran_ret1 where t.rank_id = c_rank.rank_id;
      exception
        when others then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                'ת���������ʱ����,calc_month:' || i_calc_month || ',sale_code:' || c_rank.salesman_code,
                                sqlerrm);
          rollback to sp;
      end;
    end loop;
    commit;
    return true;
  end f_tran_rank;

  --ת���Ƽ�ְ�����˲���
  function f_tran_code(i_dept_code  in varchar2, --��������
                       i_line_code  in varchar2, --ҵ���ߴ���
                       i_version_id in varchar2, --�������汾��
                       i_calc_month in varchar2, --�����·�
                       i_user_name  in varchar2, --������
                       i_task_id    in varchar2) return boolean is
    v_tran_ret1 char(100);
    v_tran_ret2 char(100);
    v_func_name varchar2(30) := 'pkg_law_rank.f_tran_code';
  begin
    for c_reco in (select t.pk_id, t.sales_code, t.reco_rank, t.calc_desc
                     from t_law_calc_proce t
                    where 1 = 1
                      and t.dept_code = i_dept_code
                      and t.line_code = i_line_code
                      and t.version_id = i_version_id
                      and t.calc_month = i_calc_month
                      and t.calc_type = '3'
                      and t.reco_rank is not null) loop
      begin
        savepoint sp;
        if (c_reco.reco_rank = upper('t')) then
          v_tran_ret1 := '��̭(���ϸ�)';
        else
          select t.rank_name
            into v_tran_ret1
            from t_law_rank_def t
           where 1 = 1
             and t.rank_code = c_reco.reco_rank;
        end if;
        select t.item_name
          into v_tran_ret2
          from t_law_rule t
         where t.valid_ind = '1'
           and t.item_type = upper('A')
           and t.item_code = c_reco.calc_desc;
        --�����������
        update t_law_calc_proce t
           set t.reco_rank = v_tran_ret1, t.calc_desc = v_tran_ret2
         where t.pk_id = c_reco.pk_id;
      exception
        when others then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                'ת��ְ������ʱ����,������Ա:' || c_reco.sales_code || ',ְ������:' || c_reco.reco_rank,
                                sqlerrm);
          rollback to sp;
      end;
    end loop;
    commit;
    return true;
  end f_tran_code;

  --����ְ�������
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2,
               i_task_id    in varchar2) return varchar2 is
    v_result boolean := true;
  begin
    --������������
    if (v_result) then
      v_result := f_adjust_level(i_dept_code, --��������
                                 i_line_code, --ҵ����
                                 i_version_id, --��������
                                 i_calc_month, --��������
                                 i_user_name, --�����û�
                                 i_task_id); --����ID
    end if;
    --����������
    if (v_result) then
      v_result := f_clean_data(i_dept_code, --��������
                               i_line_code, --ҵ����
                               i_version_id, --��������
                               i_calc_month, --��������
                               i_user_name, --�����û�
                               i_task_id); --����ID
    end if;
    --����ְ������
    if (v_result) then
      v_result := f_init_rank(i_dept_code, --��������
                              i_line_code, --ҵ����
                              i_version_id, --��������
                              i_calc_month, --��������
                              i_user_name, --�����û�
                              i_task_id); --����ID
    end if;
    --�����Ƽ�ְ��
    if (v_result) then
      v_result := f_calc_reco(i_dept_code, --��������
                              i_line_code, --ҵ���ߴ���
                              i_version_id, --�������汾��
                              i_calc_month, --�����·�
                              i_user_name, --�����û�
                              i_task_id); --����ID
    end if;
    --ת���������
    if (v_result) then
      v_result := f_tran_rank(i_dept_code, --��������
                              i_line_code, --ҵ���ߴ���
                              i_version_id, --�������汾��
                              i_calc_month, --�����·�
                              i_user_name, --������
                              i_task_id); --����ID
    end if;
    --ת��ְ������
    if (v_result) then
      v_result := f_tran_code(i_dept_code, --��������
                              i_line_code, --ҵ���ߴ���
                              i_version_id, --�������汾��
                              i_calc_month, --�����·�
                              i_user_name, --������
                              i_task_id); --����ID
    end if;
    --
    return '1';
  exception
    when others then
      pkg_law_log.log_error('pkg_law_rank.run',
                            i_task_id,
                            i_user_name,
                            '�ֹ�˾' || i_dept_code || '����ְ������',
                            sqlerrm);
      return '-1';
  end run;

end pkg_law_rank;
/
