create or replace package pkg_law_adapt is

  -- Author  : sunyf
  -- Created : 2016/5/7 14:10:52  
  -- Purpose : �����׼���ѿھ������嵥���ֵ�ҵ��Ա�����ֵ��Ŷ�?

  function f_calc_prem(i_dept_code  in char,
                       i_bgn_date   in date,
                       i_end_date   in date,
                       i_sale_code  in char,
                       i_oper_user  in char,
                       i_task_id    in char,
                       i_prem_type  in char,
                       i_sale_type  in char,
                       i_calc_code  in char,
                       i_year_flag  in char,
                       i_month_flag in char --
                       ) return number;

  function f_calc_prof(i_dept_code in char,
                       i_bgn_date  in date,
                       i_end_date  in date,
                       i_sale_code in char,
                       i_oper_user in char,
                       i_task_id   in char,
                       i_sale_type in char,
                       i_calc_code in char --
                       ) return number;

  function f_calc_claim(i_dept_code in char,
                        i_bgn_date  in date,
                        i_end_date  in date,
                        i_sale_code in char,
                        i_oper_user in char,
                        i_task_id   in char,
                        i_sale_type in char,
                        i_calc_code in char --
                        ) return number;

  function f_sale_cond(i_sale_type in char,
                       i_end_date  in date,
                       i_sale_code in char --
                       ) return varchar2;

  function f_calc_single_prem(i_dept_code  in char,
                              i_bgn_date   in date,
                              i_end_date   in date,
                              i_sls_cde    in char,
                              i_oper_user  in char,
                              i_task_id    in char,
                              i_prem_type  in char,
                              i_sale_type  in char,
                              i_calc_code  in char, --
                              i_year_flag  in char,
                              i_month_flag in char) return number;

  function f_calc_single_prem_group(i_dept_code  in char,
                                    i_bgn_date   in date,
                                    i_end_date   in date,
                                    i_sign_bgn   in date,
                                    i_sign_end   in date,
                                    i_sls_cde    in char,
                                    i_oper_user  in char,
                                    i_task_id    in char,
                                    i_prem_type  in char,
                                    i_sale_type  in char,
                                    i_calc_code  in char,
                                    i_year_flag  in char,
                                    i_month_flag in char --
                                    ) return number;
  function f_calc_single_prof(i_dept_code in char,
                              i_bgn_date  in date,
                              i_end_date  in date,
                              i_sls_cde   in char,
                              i_oper_user in char,
                              i_task_id   in char,
                              i_sale_type in char,
                              i_calc_code in char --
                              ) return number;

  function f_calc_single_prof_group(i_dept_code in char,
                                    i_bgn_date  in date,
                                    i_end_date  in date,
                                    i_udr_bgn   in date,
                                    i_udr_end   in date,
                                    i_sls_cde   in char,
                                    i_oper_user in char,
                                    i_task_id   in char,
                                    i_sale_type in char,
                                    i_calc_code in char --
                                    ) return number;

  function f_calc_single_claim(i_dept_code in char,
                               i_bgn_date  in date,
                               i_end_date  in date,
                               i_sls_cde   in char,
                               i_oper_user in char,
                               i_task_id   in char,
                               i_sale_type in char,
                               i_calc_code in char --                             
                               ) return number;
  function f_calc_single_claim_group(i_dept_code in char,
                                     i_bgn_date  in date,
                                     i_end_date  in date,
                                     i_udr_bgn   in date,
                                     i_udr_end   in date,
                                     i_sls_cde   in char,
                                     i_oper_user in char,
                                     i_task_id   in char,
                                     i_sale_type in char,
                                     i_calc_code in char --
                                     ) return number;

end pkg_law_adapt;
/
create or replace package body pkg_law_adapt is

  -- Author  : sunyf
  -- Created : 2016/5/7 14:10:52
  -- Purpose : ������׼���ѿھ������嵥���ֵ�ҵ��Ա�����ֵ��Ŷ�

  /*
  ע����׼����ͳ�Ƶ�ʱ��ھ�ͬʵ�ձ���
  1��ʵ��������ͳ�����ڣ������������ڱ��꣬�ұ�������С�ڵ��ڡ�ͳ�������һ��+3���¡��ı�����
  2��ʵ��������ͳ�����ڣ���������С�ڱ����һ��
  3��ʵ�������ڱ���ȵ�һ��֮ǰ���ұ���������ͳ�����ڵı�����
  */

  -- ȫ�ֳ���
  c_year_first_day date := trunc(sysdate, 'yyyy'); --����ĵ�һ��

  --ͳ�������ڱ�׼���Ѻ�ʵ�ձ��ѣ����˻��Ŷӣ�
  function f_calc_prem(i_dept_code  in char, --�ֹ�˾����
                       i_bgn_date   in date, --ͳ�����俪ʼ
                       i_end_date   in date, --ͳ���������
                       i_sale_code  in char, --ҵ��Ա����
                       i_oper_user  in char, --�����˴���
                       i_task_id    in char, --����id
                       i_prem_type  in char, --0ʵ�ձ���,1��׼����
                       i_sale_type  in char, --0���ˣ�1�Ŷ�
                       i_calc_code  in char, --�������ش���
                       i_year_flag  in char, --0����ȼ��㣬1����
                       i_month_flag in char --0���㵱�£�1����,2�Ĵ�
                       ) return number is
    v_sls_cde     varchar(50) := '';
    v_prem_1      number(16, 4) := 0;
    v_prem_2      number(16, 4) := 0;
    v_tmp_bgn     date;
    v_tmp_end     date;
    v_group_bgn   date;
    v_group_end   date;
    v_prem_3      number(16, 4) := 0;
    v_group_code  varchar2(50) := '';
    v_found_date  date;
    v_front_date  date;
    v_sales_count number := 0;
    v_sign_bgn    date;
    v_sign_end    date;
    cursor c_sales_virtuals is
      select t.employ_code || t.employ_name c_sls_cde,
             t.bgn_date,
             t.end_date
        from salesman_virtual_record t
       where 1 = 1
         and t.salesman_code = i_sale_code
         and t.valid_ind = '1'
         and t.end_date >= i_bgn_date;
  
    r_sales_virtual c_sales_virtuals%rowtype;
  begin
    --��ȡ���۾����ҵ����루����+������
    if (i_sale_type = '0') then
      select count(1)
        into v_sales_count
        from salesman t
       where t.salesman_code = i_sale_code;
      if (v_sales_count > 0) then
        select t.employ_code || t.salesman_cname,t.front_date
          into v_sls_cde,v_front_date
          from salesman t
         where t.salesman_code = i_sale_code;
        --����ͻ��������ʵ�ձ���
        if (v_sls_cde is not null) then
          v_prem_1 := f_calc_single_prem(i_dept_code,
                                         i_bgn_date,
                                         i_end_date,
                                         v_sls_cde,
                                         i_oper_user,
                                         i_task_id,
                                         i_prem_type,
                                         i_sale_type,
                                         i_calc_code,
                                         i_year_flag,
                                         i_month_flag);
          dbms_output.put_line('�ͻ�����' || v_sls_cde || '���ѣ�' || v_prem_1);                                                                                  
          for r_sales_virtual in c_sales_virtuals loop
            --��ȡ��������ͳ�ƿ�ʼʱ��
            if (r_sales_virtual.bgn_date < i_bgn_date) then
              v_tmp_bgn := i_bgn_date;
            elsif (r_sales_virtual.bgn_date >= i_bgn_date and
                  r_sales_virtual.bgn_date <= i_end_date) then
              v_tmp_bgn := r_sales_virtual.bgn_date;
            end if;
            --��ȡ��������ͳ�ƽ�ֹʱ��
            if (r_sales_virtual.end_date <= i_end_date) then
              v_tmp_end := r_sales_virtual.end_date;
            elsif (r_sales_virtual.end_date > i_end_date) then
              v_tmp_end := i_end_date;
            end if;
            if (v_tmp_bgn <= v_front_date) then
               v_tmp_bgn := v_front_date;
            end if;
            v_prem_3 := v_prem_3 +
                        f_calc_single_prem_group(i_dept_code,
                                                 i_bgn_date,
                                                 i_end_date,
                                                 v_tmp_bgn,
                                                 v_tmp_end,
                                                 r_sales_virtual.c_sls_cde,
                                                 i_oper_user,
                                                 i_task_id,
                                                 i_prem_type,
                                                 i_sale_type,
                                                 i_calc_code,
                                                 i_year_flag,
                                                 i_month_flag);
          dbms_output.put_line('��������' || r_sales_virtual.c_sls_cde || '���ѣ�' || v_prem_3 ||'��ǩ�����ڣ�'||v_tmp_bgn ||','||v_tmp_end);                                                                                                  
          end loop;
        end if;
      else
        return - 1;
      end if;
    elsif (i_sale_type = '1') then
      --ȡ���ŶӴ���
      select t.group_code, t.found_date
        into v_group_code, v_found_date
        from group_main t
        left join salesman t1
          on t.group_code = t1.group_code
       where t1.salesman_code = i_sale_code;
      if (v_group_code is not null and v_found_date is not null) then
        for r_group_members in (select t.sales_code,
                                       t.entry_date,
                                       t.leave_date
                                  from group_menber t
                                 where t.group_code = v_group_code
                                   and t.valid_ind = '1') loop
          --ȡ������Ա����+����                         
          select t.employ_code || t.salesman_cname
            into v_sls_cde
            from salesman t
           where t.salesman_code = r_group_members.sales_code;
          if (r_group_members.leave_date is not null and r_group_members.entry_date <= i_end_date) then
            --ȡ���㿪ʼʱ��                         
            if (r_group_members.entry_date < i_bgn_date) then
              v_group_bgn := i_bgn_date;
            elsif (r_group_members.entry_date >= i_bgn_date and
                  r_group_members.entry_date <= i_end_date) then
              v_group_bgn := r_group_members.entry_date;
            end if;
            --ȡ�����ֹʱ��
            if (r_group_members.leave_date is not null) then
              if (r_group_members.leave_date >= i_bgn_date and
                 r_group_members.leave_date <= i_end_date) then
                v_group_end := r_group_members.leave_date;
              elsif (r_group_members.leave_date > i_end_date) then
                v_group_end := i_end_date;
              end if;
            elsif (r_group_members.leave_date is null) then
              v_group_end := i_end_date;
            end if;
            --ǩ����ʼʱ��
            v_sign_bgn := r_group_members.entry_date;
            --ǩ������ʱ��
            v_sign_end := r_group_members.leave_date;
            v_prem_2   := v_prem_2 +
                          f_calc_single_prem_group(i_dept_code,
                                                   i_bgn_date,
                                                   i_end_date,
                                                   v_sign_bgn,
                                                   v_sign_end,
                                                   v_sls_cde,
                                                   i_oper_user,
                                                   i_task_id,
                                                   i_prem_type,
                                                   i_sale_type,
                                                   i_calc_code,
                                                   i_year_flag,
                                                   i_month_flag);
            dbms_output.put_line('���۾���' || r_group_members.sales_code || ',' ||
                                 v_group_bgn || ',' || v_group_end ||
                                 'ǩ�����ڣ�' || v_sign_bgn || ',' ||
                                 v_sign_end || ',' || v_prem_2);
            for r_virtual_sales in (select t.employ_code || t.employ_name c_sls_cde,
                                           t.bgn_date,
                                           t.end_date
                                      from salesman_virtual_record t
                                     where t.valid_ind = '1'
                                       and t.end_date >= i_bgn_date
                                       and t.salesman_code =
                                           r_group_members.sales_code) loop
              --��ȡ��������ͳ�ƿ�ʼʱ��
              if (r_virtual_sales.bgn_date < v_group_bgn) then
                v_tmp_bgn := v_group_bgn;
              elsif (r_virtual_sales.bgn_date >= v_group_bgn ) then
                v_tmp_bgn := r_virtual_sales.bgn_date;
              end if;
              --��ȡ��������ͳ�ƽ�ֹʱ��
              if (r_virtual_sales.end_date <= v_group_end) then
                v_tmp_end := r_virtual_sales.end_date;
              elsif (r_virtual_sales.end_date > v_group_end) then
                v_tmp_end := v_group_end;
              end if;
            
              v_prem_3 := v_prem_3 +
                          f_calc_single_prem_group(i_dept_code,
                                                   i_bgn_date,
                                                   i_end_date,
                                                   r_virtual_sales.bgn_date,
                                                   r_virtual_sales.end_date,
                                                   r_virtual_sales.c_sls_cde,
                                                   i_oper_user,
                                                   i_task_id,
                                                   i_prem_type,
                                                   i_sale_type,
                                                   i_calc_code,
                                                   i_year_flag,
                                                   i_month_flag);
              /*dbms_output.put_line('��������' || r_virtual_sales.c_sls_cde || ',' ||
                                   v_tmp_bgn || ',' || v_tmp_end || ',' ||
                                   'ǩ��ʱ�䣺' || r_virtual_sales.bgn_date || ',' ||
                                   r_virtual_sales.end_date || ',' ||
                                   v_prem_3);*/
            end loop;
          end if;
        end loop;
      end if;
    end if;
    return v_prem_1 + v_prem_2 + v_prem_3;
  end f_calc_prem;

  --ͳ�����������ڱ��ѣ����˺��Ŷӣ�
  --���ڱ��ѵ�ʱ�䷶Χ�����������ı������ڴ��ڵ���ͳ���ڶ�Ӧ��ݵ�ʱ����㣬����С�ڵ���ͳ�����յ�,���޳���ͳ���ڽ�ֹʱ���֮ǰδ�𱣵ı�����
  function f_calc_prof(i_dept_code in char, --�ֹ�˾����
                       i_bgn_date  in date, --ͳ�����俪ʼ
                       i_end_date  in date, --ͳ���������
                       i_sale_code in char, --ҵ��Ա����
                       i_oper_user in char, --�����˴���
                       i_task_id   in char, --����id
                       i_sale_type in char, --0���ˣ�1�Ŷ�
                       i_calc_code in char --�������ش���
                       ) return number is
    v_sls_cde    varchar(50) := '';
    v_prem_1     number(16, 4) := 0;
    v_prem_2     number(16, 4) := 0;
    v_tmp_bgn    date;
    v_tmp_end    date;
    v_prem_3     number(16, 4) := 0;
    v_group_code varchar2(50);
    v_found_date date;
    v_group_bgn  date;
    v_group_end  date;
    v_udr_bgn    date;
    v_udr_end    date;
  
    cursor c_sales_virtuals is
      select t.employ_code || t.employ_name c_sls_cde,
             t.bgn_date,
             t.end_date
        from salesman_virtual_record t
       where 1 = 1
         and t.salesman_code = i_sale_code
         and t.valid_ind = '1'
         and t.end_date >= i_bgn_date;
  
    r_sales_virtual c_sales_virtuals%rowtype;
  begin
    --��ȡ���۾����ҵ����루����+������
    if (i_sale_type = '0') then
      select t.employ_code || t.salesman_cname
        into v_sls_cde
        from salesman t
       where t.salesman_code = i_sale_code;
      --����ͻ��������ʵ�ձ���
      if (v_sls_cde is not null) then
        v_prem_1 := f_calc_single_prof(i_dept_code,
                                       i_bgn_date,
                                       i_end_date,
                                       v_sls_cde,
                                       i_oper_user,
                                       i_task_id,
                                       i_sale_type,
                                       i_calc_code);
        for r_sales_virtual in c_sales_virtuals loop
          --��ȡ��������ͳ�ƿ�ʼʱ��
          if (r_sales_virtual.bgn_date < i_bgn_date) then
            v_tmp_bgn := i_bgn_date;
          elsif (r_sales_virtual.bgn_date >= i_bgn_date and
                r_sales_virtual.bgn_date <= i_end_date) then
            v_tmp_bgn := r_sales_virtual.bgn_date;
          end if;
          --��ȡ��������ͳ�ƽ�ֹʱ��
          if (r_sales_virtual.end_date <= i_end_date) then
            v_tmp_end := r_sales_virtual.end_date;
          elsif (r_sales_virtual.end_date > i_end_date) then
            v_tmp_end := i_end_date;
          end if;
          v_prem_3 := v_prem_3 + f_calc_single_prof(i_dept_code,
                                                    v_tmp_bgn,
                                                    v_tmp_end,
                                                    r_sales_virtual.c_sls_cde,
                                                    i_oper_user,
                                                    i_task_id,
                                                    i_sale_type,
                                                    i_calc_code);
        end loop;
      end if;
    elsif (i_sale_type = '1') then
      --ȡ���ŶӴ���
      select t.group_code, t.found_date
        into v_group_code, v_found_date
        from group_main t
        left join salesman t1
          on t.group_code = t1.group_code
       where t1.salesman_code = i_sale_code;
      if (v_group_code is not null and v_found_date is not null) then
        for r_group_members in (select t.sales_code,
                                       t.entry_date,
                                       t.leave_date
                                  from group_menber t
                                 where t.group_code = v_group_code
                                   and t.valid_ind = '1') loop
          --ȡ������Ա����+����                         
          select t.employ_code || t.salesman_cname
            into v_sls_cde
            from salesman t
           where t.salesman_code = r_group_members.sales_code;
          --ȡ���㿪ʼʱ��                         
          if (r_group_members.entry_date < i_bgn_date) then
            v_group_bgn := i_bgn_date;
          elsif (r_group_members.entry_date >= i_bgn_date and
                r_group_members.entry_date <= i_end_date) then
            v_group_bgn := r_group_members.entry_date;
          end if;
          --ȡ�����ֹʱ��
          if (r_group_members.leave_date is not null) then
            if (r_group_members.leave_date <= i_end_date) then
              v_group_end := r_group_members.leave_date;
            elsif (r_group_members.leave_date > i_end_date) then
              v_group_end := i_end_date;
            end if;
          elsif (r_group_members.leave_date is null) then
            v_group_end := i_end_date;
          end if;
          --�˱���ʼʱ��
          v_udr_bgn := r_group_members.entry_date;
          --�˱�����ʱ��
          v_udr_end := r_group_members.leave_date;
          --dbms_output.put_line('���۾���' || v_group_bgn || ',' || v_group_end);
          v_prem_2 := v_prem_2 +
                      f_calc_single_prof_group(i_dept_code,
                                               i_bgn_date,
                                               i_end_date,
                                               v_udr_bgn,
                                               v_udr_end,
                                               v_sls_cde,
                                               i_oper_user,
                                               i_task_id,
                                               i_sale_type,
                                               i_calc_code);
          for r_virtual_sales in (select t.employ_code || t.employ_name c_sls_cde,
                                         t.bgn_date,
                                         t.end_date
                                    from salesman_virtual_record t
                                   where t.valid_ind = '1'
                                     and t.end_date >= i_bgn_date
                                     and t.salesman_code =
                                         r_group_members.sales_code) loop
            --��ȡ��������ͳ�ƿ�ʼʱ��
            if (r_virtual_sales.bgn_date < v_group_bgn) then
              v_tmp_bgn := v_group_bgn;
            elsif (r_virtual_sales.bgn_date >= v_group_bgn and
                  r_virtual_sales.bgn_date <= v_group_bgn) then
              v_tmp_bgn := r_virtual_sales.bgn_date;
            end if;
            --��ȡ��������ͳ�ƽ�ֹʱ��
            if (r_virtual_sales.end_date <= v_group_end) then
              v_tmp_end := r_virtual_sales.end_date;
            elsif (r_virtual_sales.end_date > v_group_end) then
              v_tmp_end := v_group_end;
            end if;
            v_prem_3 := v_prem_3 +
                        f_calc_single_prof_group(i_dept_code,
                                                 v_tmp_bgn,
                                                 v_tmp_end,
                                                 v_tmp_bgn,
                                                 v_tmp_end,
                                                 r_virtual_sales.c_sls_cde,
                                                 i_oper_user,
                                                 i_task_id,
                                                 i_sale_type,
                                                 i_calc_code);
          end loop;
        end loop;
      end if;
    end if;
    return v_prem_1 + v_prem_2 + v_prem_3;
  
  end f_calc_prof;

  --ͳ���������Ѿ�δ�������˺��Ŷӣ�
  --�Ѿ�δ������ʱ�䷶Χ�����������ı������ڴ��ڵ���ͳ���ڶ�Ӧ��ݵ�ʱ�����
  function f_calc_claim(i_dept_code in char, --�ֹ�˾����
                        i_bgn_date  in date, --ͳ�����俪ʼ
                        i_end_date  in date, --ͳ���������
                        i_sale_code in char, --ҵ��Ա����
                        i_oper_user in char, --�����˴���
                        i_task_id   in char, --����id
                        i_sale_type in char, --0���ˣ�1�Ŷ�
                        i_calc_code in char --�������ش���
                        ) return number is
    v_sls_cde    varchar(50) := '';
    v_prem_1     number(16, 4) := 0;
    v_prem_2     number(16, 4) := 0;
    v_tmp_bgn    date;
    v_tmp_end    date;
    v_prem_3     number(16, 4) := 0;
    v_group_code varchar2(50) := '';
    v_found_date date;
    v_group_bgn  date;
    v_group_end  date;
    v_udr_bgn    date;
    v_udr_end    date;
    cursor c_sales_virtuals is
      select t.employ_code || t.employ_name c_sls_cde,
             t.bgn_date,
             t.end_date
        from salesman_virtual_record t
       where 1 = 1
         and t.salesman_code = i_sale_code
         and t.valid_ind = '1'
         and t.end_date >= i_bgn_date;
  
    r_sales_virtual c_sales_virtuals%rowtype;
  begin
    --��ȡ���۾����ҵ����루����+������
    if (i_sale_type = '0') then
      select t.employ_code || t.salesman_cname
        into v_sls_cde
        from salesman t
       where t.salesman_code = i_sale_code;
      --����ͻ��������ʵ�ձ���
      if (v_sls_cde is not null) then
        v_prem_1 := f_calc_single_claim(i_dept_code,
                                        i_bgn_date,
                                        i_end_date,
                                        v_sls_cde,
                                        i_oper_user,
                                        i_task_id,
                                        i_sale_type,
                                        i_calc_code);
        for r_sales_virtual in c_sales_virtuals loop
          --��ȡ��������ͳ�ƿ�ʼʱ��
          if (r_sales_virtual.bgn_date < i_bgn_date) then
            v_tmp_bgn := i_bgn_date;
          elsif (r_sales_virtual.bgn_date >= i_bgn_date and
                r_sales_virtual.bgn_date <= i_end_date) then
            v_tmp_bgn := r_sales_virtual.bgn_date;
          end if;
          --��ȡ��������ͳ�ƽ�ֹʱ��
          if (r_sales_virtual.end_date <= i_end_date) then
            v_tmp_end := r_sales_virtual.end_date;
          elsif (r_sales_virtual.end_date > i_end_date) then
            v_tmp_end := i_end_date;
          end if;
          v_prem_3 := v_prem_3 +
                      f_calc_single_claim(i_dept_code,
                                          v_tmp_bgn,
                                          v_tmp_end,
                                          r_sales_virtual.c_sls_cde,
                                          i_oper_user,
                                          i_task_id,
                                          i_sale_type,
                                          i_calc_code);
        end loop;
      end if;
    elsif (i_sale_type = '1') then
      --ȡ���ŶӴ���
      select t.group_code, t.found_date
        into v_group_code, v_found_date
        from group_main t
        left join salesman t1
          on t.group_code = t1.group_code
       where t1.salesman_code = i_sale_code;
      if (v_group_code is not null and v_found_date is not null) then
        for r_group_members in (select t.sales_code,
                                       t.entry_date,
                                       t.leave_date
                                  from group_menber t
                                 where t.group_code = v_group_code
                                   and t.valid_ind = '1') loop
          --ȡ������Ա����+����                         
          select t.employ_code || t.salesman_cname
            into v_sls_cde
            from salesman t
           where t.salesman_code = r_group_members.sales_code;
          --ȡ���㿪ʼʱ��                         
          if (r_group_members.entry_date < i_bgn_date) then
            v_group_bgn := i_bgn_date;
          elsif (r_group_members.entry_date >= i_bgn_date and
                r_group_members.entry_date <= i_end_date) then
            v_group_bgn := r_group_members.entry_date;
          end if;
          --ȡ�����ֹʱ��
          if (r_group_members.leave_date is not null) then
            if (r_group_members.leave_date <= i_end_date) then
              v_group_end := r_group_members.leave_date;
            elsif (r_group_members.leave_date > i_end_date) then
              v_group_end := i_end_date;
            end if;
          elsif (r_group_members.leave_date is null) then
            v_group_end := i_end_date;
          end if;
        
          --�˱���ʼʱ��
          v_udr_bgn := r_group_members.entry_date;
          --�˱�����ʱ��
          v_udr_end := r_group_members.leave_date;
          --dbms_output.put_line('���۾���' || v_group_bgn || ',' || v_group_end);
          v_prem_2 := v_prem_2 +
                      f_calc_single_claim_group(i_dept_code,
                                                i_bgn_date,
                                                i_end_date,
                                                v_udr_bgn,
                                                v_udr_end,
                                                v_sls_cde,
                                                i_oper_user,
                                                i_task_id,
                                                i_sale_type,
                                                i_calc_code);
          for r_virtual_sales in (select t.employ_code || t.employ_name c_sls_cde,
                                         t.bgn_date,
                                         t.end_date
                                    from salesman_virtual_record t
                                   where t.valid_ind = '1'
                                     and t.end_date >= i_bgn_date
                                     and t.salesman_code =
                                         r_group_members.sales_code) loop
            --��ȡ��������ͳ�ƿ�ʼʱ��
            if (r_virtual_sales.bgn_date < v_group_bgn) then
              v_tmp_bgn := v_group_bgn;
            elsif (r_virtual_sales.bgn_date >= v_group_bgn and
                  r_virtual_sales.bgn_date <= v_group_bgn) then
              v_tmp_bgn := r_virtual_sales.bgn_date;
            end if;
            --��ȡ��������ͳ�ƽ�ֹʱ��
            if (r_virtual_sales.end_date <= v_group_end) then
              v_tmp_end := r_virtual_sales.end_date;
            elsif (r_virtual_sales.end_date > v_group_end) then
              v_tmp_end := v_group_end;
            end if;
            v_prem_3 := v_prem_3 +
                        f_calc_single_claim_group(i_dept_code,
                                                  v_tmp_bgn,
                                                  v_tmp_end,
                                                  v_tmp_bgn,
                                                  v_tmp_end,
                                                  r_virtual_sales.c_sls_cde,
                                                  i_oper_user,
                                                  i_task_id,
                                                  i_sale_type,
                                                  i_calc_code);
          end loop;
        end loop;
      end if;
    end if;
    return v_prem_1 + v_prem_2 + v_prem_3;
  end f_calc_claim;

  --�����ŶӲ�ѯ����
  function f_sale_cond(i_sale_type in char, --0���ˣ�1�Ŷ�
                       i_end_date  in date, --ͳ���������
                       i_sale_code in char --ҵ��Ա����
                       ) return varchar2 is
    v_sql_sale varchar2(2000) := '';
  begin
    if (i_sale_type = '0') then
      v_sql_sale := '(select t.employ_code || t.salesman_cname from salesman t where t.valid_ind = ''1'' and t.salesman_code =''' ||
                    i_sale_code ||
                    ''' union select t.employ_code || t.cname from salesman_virtual t where t.valid_ind = ''1'' and t.salesman_type = ''0'' 
                     and t.enter_date <= ''' ||
                    i_end_date || ''' and t.salesman_code =''' || --
                    i_sale_code || ''')';
    elsif (i_sale_type = '1') then
      v_sql_sale := '(select t2.employ_code || t2.salesman_cname from salesman t1, salesman t2
                     where t1.salesman_code = ''' ||
                    i_sale_code ||
                    ''' and t1.group_code = t2.group_code
                     union select t.employ_code || t.cname from salesman_virtual t
                     where t.valid_ind = ''1'' and t.salesman_type = ''0'' and t.enter_date <= ''' ||
                    i_end_date ||
                    ''' and t.salesman_code in (select t2.salesman_code from salesman t1, salesman t2 where t1.salesman_code =''' ||
                    i_sale_code || ''' and t1.group_code = t2.group_code))';
    end if;
  
    return v_sql_sale;
  end f_sale_cond;

  function f_calc_single_prem(i_dept_code  in char, --�ֹ�˾����
                              i_bgn_date   in date, --ͳ�����俪ʼ
                              i_end_date   in date, --ͳ���������
                              i_sls_cde    in char, --ҵ��Ա����(����+����)
                              i_oper_user  in char, --�����˴���
                              i_task_id    in char, --����id
                              i_prem_type  in char, --0ʵ�ձ���,1��׼����
                              i_sale_type  in char, --0���ˣ�1�Ŷ� 
                              i_calc_code  in char, --�������ش���
                              i_year_flag  in char, --0����ȼ��㣬1����
                              i_month_flag in char --0���㵱�£�1���� 
                              ) return number is
    v_func_name   varchar2(30) := 'pkg_law_adapt.f_calc_prem';
    v_sql_prem    varchar(100) := '';
    v_sql_prod    varchar(1000) := '';
    v_sql_exec    varchar(2000) := '';
    v_sql_range   varchar(2000) := '';
    v_calc_date   date;
    v_range_date  date;
    v_return_prem number(16, 4) := 0;
  begin
    if (to_char(add_months(i_end_date, 3), 'yyyy') >
       to_char(sysdate, 'yyyy')) then
      v_range_date := to_date(to_char(sysdate, 'yyyy') || '1231 23:59:59',
                              'yyyymmdd hh24:mi:ss');
    else
      v_range_date := add_months(i_end_date, 3);
    end if;
    if (i_year_flag = '0') then
      select v_range_date into v_calc_date from dual;
    elsif (i_year_flag = '1') then
      v_calc_date := i_end_date;
    end if;
    --ʵ�ձ�׼�����ֶ�
    if (i_prem_type = '0') then
      v_sql_prem := 't.n_prem_got + nvl(t.n_tax,0)';
    elsif (i_prem_type = '1') then
      v_sql_prem := 't.n_prem_stan';
    end if;
    --�������ش�������
    if (lower(i_calc_code) in ('a016', 'a115', 'a123','a033','a148')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%''';
    elsif (lower(i_calc_code) in ('a017', 'a116', 'a122')) then
      v_sql_prod := ' and t.c_prod_no like ''03%''';
    elsif (lower(i_calc_code) in ('a018', 'a117')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%'' and t.c_prod_no not like ''06%'' and t.c_prod_no not like ''12%''';
    elsif (lower(i_calc_code) in ('a019', 'a118')) then
      v_sql_prod := ' and (t.c_prod_no like ''06%'' or t.c_prod_no like ''12%'')';
    elsif(lower(i_calc_code) in ('a032','a147')) then
      v_sql_prod := ' and t.c_prod_no in (''0360'',''0361'',''0362'')';
    elsif(lower(i_calc_code) in ('a035','a150')) then
    	v_sql_prod := ' and t.c_busi_oria like ''%19001%''';          
    else
      v_sql_prod := '';
    end if;
    if (i_month_flag = '0') then
      v_sql_range := '((t.t_pay_tm <:v1 and t.t_insrnc_bgn_tm >= :v2 and t.t_insrnc_bgn_tm <= :v3)
                      or
                      (t.t_pay_tm >= :v4 and t.t_pay_tm <= :v5 and t.t_insrnc_bgn_tm <= :v6))';
    elsif (i_month_flag = '1') then
      v_sql_range := '((t.t_pay_tm >= :v1 and t.t_pay_tm <= :v2 and t.t_insrnc_bgn_tm >= :v3 and 
                    t.t_insrnc_bgn_tm <= :v4)
                    or 
                      (t.t_pay_tm >= :v5  and t.t_pay_tm <= :v6 and t.t_insrnc_bgn_tm < :v7) 
                    or
                    (t.t_pay_tm < :v8 and t.t_insrnc_bgn_tm >= :v9 and t.t_insrnc_bgn_tm <= :v10))';
    elsif (i_month_flag = '2') then                    
      v_sql_range := '(t.t_pay_tm <:v1 and t.t_insrnc_bgn_tm >= :v2 and t.t_insrnc_bgn_tm <= :v3)';  
    end if;
    --��Ҫִ�е�SQL���
    v_sql_exec := 'select sum(' || v_sql_prem ||
                  ') into :v0 from t_law_mis_got_prm t where 1 = 1 and t.c_dept_cde = ''' ||
                  i_dept_code || ''' and t.c_sls_cde1 in (''' || i_sls_cde ||
                  ''')' || v_sql_prod || --
                  ' and (' || v_sql_range || ')';
    --dbms_output.put_line(v_sql_exec);
    if (i_month_flag = '0') then
      execute immediate v_sql_exec
        into v_return_prem
        using i_bgn_date, i_bgn_date, i_end_date, i_bgn_date, i_end_date, i_end_date; --
    elsif (i_month_flag = '1') then
      execute immediate v_sql_exec
        into v_return_prem
        using i_bgn_date, i_end_date, i_bgn_date, v_range_date, i_bgn_date, i_end_date, --
      c_year_first_day, c_year_first_day, i_bgn_date, v_calc_date;
    elsif (i_month_flag = '2') then
      execute immediate v_sql_exec
        into v_return_prem
      using c_year_first_day,i_bgn_date,v_calc_date;
    end if;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_oper_user,
                          '������Ա��' || i_sls_cde || '�������ش��룺' || i_calc_code,
                          '��¼sql���̣�' || v_sql_exec);
    return nvl(v_return_prem, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_oper_user,
                            '�������ظ��ˣ����Ŷӣ���׼����ʵ�գ�����ʧ��',
                            sqlerrm || ',������Ա����:' || i_sls_cde ||
                            ',�������ش��룺' || i_calc_code || ',��¼���̣�' ||
                            v_sql_exec);
      return - 1;
  end f_calc_single_prem;

  function f_calc_single_prem_group(i_dept_code  in char, --�ֹ�˾����
                                    i_bgn_date   in date, --ͳ�����俪ʼ
                                    i_end_date   in date, --ͳ���������
                                    i_sign_bgn   in date, --ǩ����ʼ���� 
                                    i_sign_end   in date, --ǩ����������
                                    i_sls_cde    in char, --ҵ��Ա����(����+����)
                                    i_oper_user  in char, --�����˴���
                                    i_task_id    in char, --����id
                                    i_prem_type  in char, --0ʵ�ձ���,1��׼����
                                    i_sale_type  in char, --0���ˣ�1�Ŷ� 
                                    i_calc_code  in char, --�������ش���
                                    i_year_flag  in char, --0����ȼ��㣬1����
                                    i_month_flag in char --0���㵱�£�1���� 
                                    ) return number is
    v_func_name   varchar2(30) := 'pkg_law_adapt.f_calc_prem';
    v_sql_prem    varchar(100) := '';
    v_sql_prod    varchar(1000) := '';
    v_sql_exec    varchar(2000) := '';
    v_sql_range   varchar(2000) := '';
    v_calc_date   date;
    v_range_date  date;
    v_return_prem number(16, 4) := 0;
  begin
    if (to_char(add_months(i_end_date, 3), 'yyyy') >
       to_char(sysdate, 'yyyy')) then
      v_range_date := to_date(to_char(sysdate, 'yyyy') || '1231 23:59:59',
                              'yyyymmdd hh24:mi:ss');
    else
      v_range_date := add_months(i_end_date, 3);
    end if;
    if (i_year_flag = '0') then
      select v_range_date into v_calc_date from dual;
    elsif (i_year_flag = '1') then
      v_calc_date := i_end_date;
    end if;
    --ʵ�ձ�׼�����ֶ�
    if (i_prem_type = '0') then
      v_sql_prem := 't.n_prem_got + nvl(t.n_tax,0)';
    elsif (i_prem_type = '1') then
      v_sql_prem := 't.n_prem_stan';
    end if;
    --�������ش�������
    if (lower(i_calc_code) in ('a016', 'a115', 'a123','a033','a148')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%''';
    elsif (lower(i_calc_code) in ('a017', 'a116', 'a122')) then
      v_sql_prod := ' and t.c_prod_no like ''03%''';
    elsif (lower(i_calc_code) in ('a018', 'a117')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%'' and t.c_prod_no not like ''06%'' and t.c_prod_no not like ''12%''';
    elsif (lower(i_calc_code) in ('a019', 'a118')) then
      v_sql_prod := ' and (t.c_prod_no like ''06%'' or t.c_prod_no like ''12%'')';
    elsif(lower(i_calc_code) in ('a032','a147')) then
      v_sql_prod := ' and t.c_prod_no in (''0360'',''0361'',''0362'')';
    elsif(lower(i_calc_code) in ('a035','a150')) then
    	v_sql_prod := ' and t.c_busi_oria like ''%19001%''';         
    else
      v_sql_prod := '';
    end if;
    if (i_month_flag = '0') then
      v_sql_range := '((t.t_pay_tm <:v1 and t.t_insrnc_bgn_tm >= :v2 and t.t_insrnc_bgn_tm <= :v3)
                      or
                      (t.t_pay_tm >= :v4 and t.t_pay_tm <= :v5 and t.t_insrnc_bgn_tm <= :v6))
                      and 
                      (t.sign_date >= :v7 and t.sign_date <= :v8)';
    elsif (i_month_flag = '1') then
      v_sql_range := '((t.t_pay_tm >= :v1 and t.t_pay_tm <= :v2 and t.t_insrnc_bgn_tm >= :v3 and 
                    t.t_insrnc_bgn_tm <= :v4)
                    or 
                      (t.t_pay_tm >= :v5  and t.t_pay_tm <= :v6 and t.t_insrnc_bgn_tm < :v7) 
                    or
                    (t.t_pay_tm < :v8 and t.t_insrnc_bgn_tm >= :v9 and t.t_insrnc_bgn_tm <= :v10))
                    and
                    (t.sign_date >= :v11 and t.sign_date <= :v12)';
    elsif (i_month_flag = '2') then                    
      v_sql_range := '(t.t_pay_tm <:v1 and t.t_insrnc_bgn_tm >= :v2 and t.t_insrnc_bgn_tm <= :v3)';                     
    end if;
    --��Ҫִ�е�SQL���
    v_sql_exec := 'select sum(' || v_sql_prem ||
                  ') into :v0 from t_law_mis_got_prm t where 1 = 1 and t.c_dept_cde = ''' ||
                  i_dept_code || ''' and t.c_sls_cde1 in (''' || i_sls_cde ||
                  ''')' || v_sql_prod || --
                  ' and (' || v_sql_range || ')';
    /*dbms_output.put_line(v_sql_exec);
    
    dbms_output.put_line(i_bgn_date||','|| i_end_date ||','|| i_bgn_date||','|| v_range_date||','|| i_bgn_date||','|| i_end_date||','||--
      c_year_first_day||','|| c_year_first_day||','||i_bgn_date||','|| v_calc_date||','|| i_sign_bgn||','|| i_sign_end);*/
    if (i_month_flag = '0') then
      execute immediate v_sql_exec
        into v_return_prem
        using i_bgn_date, i_bgn_date, i_end_date, i_bgn_date, i_end_date, i_end_date, i_sign_bgn, i_sign_end; --
    elsif (i_month_flag = '1') then
      execute immediate v_sql_exec
        into v_return_prem
        using i_bgn_date, i_end_date, i_bgn_date, v_range_date, i_bgn_date, i_end_date, --
      c_year_first_day, c_year_first_day, i_bgn_date, v_calc_date, i_sign_bgn, i_sign_end;
    elsif (i_month_flag = '2') then
      execute immediate v_sql_exec
        into v_return_prem
      using c_year_first_day,i_bgn_date,v_calc_date;      
    end if;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_oper_user,
                          '������Ա��' || i_sls_cde || '�������ش��룺' || i_calc_code,
                          '��¼sql���̣�' || v_sql_exec);
    return nvl(v_return_prem, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_oper_user,
                            '�������ظ��ˣ����Ŷӣ���׼����ʵ�գ�����ʧ��',
                            sqlerrm || ',������Ա����:' || i_sls_cde ||
                            ',�������ش��룺' || i_calc_code || ',��¼���̣�' ||
                            v_sql_exec);
      return - 1;
  end f_calc_single_prem_group;

  function f_calc_single_prof(i_dept_code in char, --�ֹ�˾����
                              i_bgn_date  in date, --ͳ�����俪ʼ
                              i_end_date  in date, --ͳ���������
                              i_sls_cde   in char, --ҵ��Ա����
                              i_oper_user in char, --�����˴���
                              i_task_id   in char, --����id
                              i_sale_type in char, --0���ˣ�1�Ŷ�
                              i_calc_code in char --�������ش���
                              ) return number is
    v_func_name   varchar2(30) := 'pkg_law_adapt.f_calc_prem';
    v_sql_prem    varchar(100) := '';
    v_sql_sale    varchar(1000) := '';
    v_sql_prod    varchar(1000) := '';
    v_sql_exec    varchar(2000) := '';
    v_sql_con1    varchar(100) := '';
    v_sql_con2    varchar(100) := '';
    v_return_prof number(16, 4) := 0;
  begin
    --�������ش�������
    if (lower(i_calc_code) in ('a023', 'a132')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%''';
    end if;
    --��Ҫִ�е�SQL���
    v_sql_exec := 'select sum(t.manqi*nvl(t.rate,1)) into :v0 from t_law_mis_pro_clm t where 1 = 1 and t.c_dept_cde = ''' || i_dept_code ||
                  ''' and t.c_sls_cde1 in (''' || i_sls_cde || ''')' ||
                  v_sql_prod || --
                  ' and ( t.t_insrnc_bgn_tm >= :v1 and t.t_insrnc_bgn_tm <= :v2)';
    --dbms_output.put_line(v_sql_exec);
    execute immediate v_sql_exec
      into v_return_prof
      using i_bgn_date, i_end_date;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_oper_user,
                          '������Ա��' || i_sls_cde || '�������ش��룺' || i_calc_code,
                          '��¼sql���̣�' || v_sql_exec);
    return nvl(v_return_prof, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_oper_user,
                            '�������ظ��ˣ����Ŷӣ����ڱ���ʧ��',
                            sqlerrm || ',������Ա����:' || i_sls_cde ||
                            ',�������ش��룺' || i_calc_code || ',��¼���̣�' ||
                            v_sql_exec);
      return - 1;
  end f_calc_single_prof;

  function f_calc_single_prof_group(i_dept_code in char, --�ֹ�˾����
                                    i_bgn_date  in date, --ͳ�����俪ʼ
                                    i_end_date  in date, --ͳ���������
                                    i_udr_bgn   in date, --�˱���ʼ����
                                    i_udr_end   in date, --�˱��������� 
                                    i_sls_cde   in char, --ҵ��Ա����
                                    i_oper_user in char, --�����˴���
                                    i_task_id   in char, --����id
                                    i_sale_type in char, --0���ˣ�1�Ŷ�
                                    i_calc_code in char --�������ش���
                                    ) return number is
    v_func_name   varchar2(30) := 'pkg_law_adapt.f_calc_prem';
    v_sql_prem    varchar(100) := '';
    v_sql_sale    varchar(1000) := '';
    v_sql_prod    varchar(1000) := '';
    v_sql_exec    varchar(2000) := '';
    v_sql_con1    varchar(100) := '';
    v_sql_con2    varchar(100) := '';
    v_return_prof number(16, 4) := 0;
  begin
    --�������ش�������
    if (lower(i_calc_code) in ('a023', 'a132')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%''';
    end if;
    --��Ҫִ�е�SQL���
    v_sql_exec := 'select sum(t.manqi*nvl(t.rate,1)) into :v0 from t_law_mis_pro_clm t where 1 = 1 and t.c_dept_cde = ''' || i_dept_code ||
                  ''' and t.c_sls_cde1 in (''' || i_sls_cde || ''')' ||
                  v_sql_prod || --
                  ' and ( t.t_insrnc_bgn_tm >= :v1 and t.t_insrnc_bgn_tm <= :v2 and t.t_udr_date >= :v3 and t.t_udr_date <= :v4)';
    --dbms_output.put_line(v_sql_exec);
    execute immediate v_sql_exec
      into v_return_prof
      using i_bgn_date, i_end_date, i_udr_bgn, i_udr_end;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_oper_user,
                          '������Ա��' || i_sls_cde || '�������ش��룺' || i_calc_code,
                          '��¼sql���̣�' || v_sql_exec);
    return nvl(v_return_prof, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_oper_user,
                            '�������ظ��ˣ����Ŷӣ����ڱ���ʧ��',
                            sqlerrm || ',������Ա����:' || i_sls_cde ||
                            ',�������ش��룺' || i_calc_code || ',��¼���̣�' ||
                            v_sql_exec);
      return - 1;
  end f_calc_single_prof_group;

  function f_calc_single_claim(i_dept_code in char, --�ֹ�˾����
                               i_bgn_date  in date, --ͳ�����俪ʼ
                               i_end_date  in date, --ͳ���������
                               i_sls_cde   in char, --ҵ��Ա����
                               i_oper_user in char, --�����˴���
                               i_task_id   in char, --����id
                               i_sale_type in char, --0���ˣ�1�Ŷ�
                               i_calc_code in char --�������ش���
                               ) return number is
    v_func_name    varchar2(30) := 'pkg_law_adapt.f_calc_prem';
    v_sql_prem     varchar(100) := '';
    v_sql_sale     varchar(1000) := '';
    v_sql_prod     varchar(1000) := '';
    v_sql_exec     varchar(2000) := '';
    v_sql_con1     varchar(100) := '';
    v_sql_con2     varchar(100) := '';
    v_return_claim number(16, 4) := 0;
  begin
    --�������ش�������
    if (lower(i_calc_code) in ('a022', 'a131')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%''';
    end if;
    --��Ҫִ�е�SQL���
    v_sql_exec := 'select sum(t.yj_ri + t.wj_ri) into :v0 from t_law_mis_pro_clm t where 1 = 1 and t.c_dept_cde = ''' || i_dept_code ||
                  ''' and t.c_sls_cde1 in (''' || i_sls_cde || ''')' ||
                  v_sql_prod || --
                  ' and (t.t_insrnc_bgn_tm >= :v1) and t.t_insrnc_bgn_tm <= :v2 ';
    --dbms_output.put_line(v_sql_exec);
    execute immediate v_sql_exec
      into v_return_claim
      using i_bgn_date, i_end_date;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_oper_user,
                          '������Ա��' || i_sls_cde || '�������ش��룺' || i_calc_code,
                          '��¼sql���̣�' || v_sql_exec);
    return nvl(v_return_claim, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_oper_user,
                            '�������ظ��ˣ����Ŷӣ��Ѿ�δ�����ʧ��',
                            sqlerrm || ',������Ա����:' || i_sls_cde ||
                            ',�������ش��룺' || i_calc_code || ',��¼���̣�' ||
                            v_sql_exec);
      return - 1;
  end f_calc_single_claim;

  function f_calc_single_claim_group(i_dept_code in char, --�ֹ�˾����
                                     i_bgn_date  in date, --ͳ�����俪ʼ
                                     i_end_date  in date, --ͳ���������
                                     i_udr_bgn   in date, --�˱���ʼ����
                                     i_udr_end   in date, --�˱���������
                                     i_sls_cde   in char, --ҵ��Ա����
                                     i_oper_user in char, --�����˴���
                                     i_task_id   in char, --����id
                                     i_sale_type in char, --0���ˣ�1�Ŷ�
                                     i_calc_code in char --�������ش���
                                     ) return number is
    v_func_name    varchar2(30) := 'pkg_law_adapt.f_calc_prem';
    v_sql_prem     varchar(100) := '';
    v_sql_sale     varchar(1000) := '';
    v_sql_prod     varchar(1000) := '';
    v_sql_exec     varchar(2000) := '';
    v_sql_con1     varchar(100) := '';
    v_sql_con2     varchar(100) := '';
    v_return_claim number(16, 4) := 0;
  begin
    --�������ش�������
    if (lower(i_calc_code) in ('a022', 'a131')) then
      v_sql_prod := ' and t.c_prod_no not like ''03%''';
    end if;
    --��Ҫִ�е�SQL���
    v_sql_exec := 'select sum(t.yj_ri + t.wj_ri) into :v0 from t_law_mis_pro_clm t where 1 = 1 and t.c_dept_cde = ''' || i_dept_code ||
                  ''' and t.c_sls_cde1 in (''' || i_sls_cde || ''')' ||
                  v_sql_prod || --
                  ' and (t.t_insrnc_bgn_tm >= :v1) and t.t_insrnc_bgn_tm <= :v2 and t.t_udr_date >= :v3 and t.t_udr_date <= :v4';
    --dbms_output.put_line(v_sql_exec);
    execute immediate v_sql_exec
      into v_return_claim
      using i_bgn_date, i_end_date, i_udr_bgn, i_udr_end;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_oper_user,
                          '������Ա��' || i_sls_cde || '�������ش��룺' || i_calc_code,
                          '��¼sql���̣�' || v_sql_exec);
    return nvl(v_return_claim, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_oper_user,
                            '�������ظ��ˣ����Ŷӣ��Ѿ�δ�����ʧ��',
                            sqlerrm || ',������Ա����:' || i_sls_cde ||
                            ',�������ش��룺' || i_calc_code || ',��¼���̣�' ||
                            v_sql_exec);
      return - 1;
  end f_calc_single_claim_group;

end pkg_law_adapt;
/
