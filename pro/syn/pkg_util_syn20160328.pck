create or replace package PKG_UTIL_SYN is

  -- Author  : sunyf
  -- Created : 2014-10-11
  -- Purpose : ͬ��������Ա

  -- ͬ������
  function f_synchro_dept(i_dept_code in department.dept_code%type default null) return integer;

end PKG_UTIL_SYN;
/
create or replace package body pkg_util_syn is

  -- Author  : sunyf
  -- Created : 2014-10-11
  -- Purpose : ͬ����Ա,ͬ������

  /*
  * ���ܣ�ͬ������
  * ������i_dept_code,��ѡ���������ֹ�˾ͬ������
  * ����: sunyf
  */
  function f_synchro_dept(i_dept_code in department.dept_code%type default null) return integer is
    v_fun_syn varchar2(128);
  begin
  
    v_fun_syn := 'pkg_util_syn.f_synchro_dept';
  
    declare
      v_count_1 number := -1;
      --cursor
      cursor cur_dept is
        select * from um_department t where t.dpt_cde like i_dept_code || '%' order by t.dpt_cde;
      --rowtype
      v_row_cur cur_dept%rowtype;
    
    begin
      if cur_dept%isopen = false then
        open cur_dept;
      end if;
    
      loop
        fetch cur_dept
          into v_row_cur;
        exit when cur_dept%notfound;
      
        begin
        
          savepoint sp;
          --�Ƿ��л���
          select count(1) into v_count_1 from department t where t.dept_code = v_row_cur.dpt_cde;
          --��������ڣ������
          if (v_count_1 = 0) then
            insert into department
              (dept_code,
               dept_cname,
               dept_ename,
               parent_dept_code,
               dept_level,
               dept_relation_code,
               insure_license_no,
               case_address,
               case_tel, --
               alarm_flag,
               dept_flag,
               fax,
               tel,
               consult_tel, --
               dept_caddress,
               dept_eaddress,
               post_code,
               dept_simple_name,
               dept_series, --
               contact_user,
               inter_code,
               found_date,
               --expire_date,   --ʧЧ����
               tax_regist_no, --
               license_no,
               qualify_no, --
               --special_dept,
               --tel_dept_flag,
               --license_valid,
               --license_expire,
               --circ_code,
               --sale_region_code,
               --tax_recognize_no,
               valid_ind,
               created_date,
               created_user,
               updated_date,
               updated_user)
              select t.dpt_cde,
                     t.dpt_cnm,
                     t.c_dpt_enm,
                     t.c_snr_dpt,
                     t.n_dpt_levl,
                     t.dpt_rel_cde,
                     t.insprmt_no,
                     t.rpt_addr,
                     t.rpt_tel, --
                     t.alarm_mrk,
                     t.department_mrk,
                     t.fax,
                     t.tel,
                     t.con_tel, --
                     t.dpt_caddr,
                     t.dpt_eaddr,
                     t.zip_cde,
                     t.dpt_abr,
                     t.dpt_serno, --
                     t.ctct_cde,
                     t.inter_cde,
                     t.fnd_tm,
                     --t.abd_tm,   --ʧЧ����
                     t.taxrgst_no, --
                     t.lcn_abr,
                     t.bnsrgst_no, --չҵ�ʸ�֤
                     '1',
                     sysdate,
                     'admin',
                     sysdate,
                     'admin'
                from um_department t
               where t.dpt_cde = v_row_cur.dpt_cde;
            --����Ѵ��ڣ������
          else
            update department
               set dept_cname       = v_row_cur.dpt_cnm,
                   dept_ename       = v_row_cur.c_dpt_enm,
                   parent_dept_code = v_row_cur.c_snr_dpt,
                   --dept_level         = v_row_cur.n_dpt_levl,
                   dept_relation_code = v_row_cur.dpt_rel_cde,
                   insure_license_no  = v_row_cur.insprmt_no,
                   case_address       = v_row_cur.rpt_addr,
                   case_tel           = v_row_cur.rpt_tel,
                   alarm_flag         = v_row_cur.alarm_mrk,
                   dept_flag          = v_row_cur.department_mrk,
                   fax                = v_row_cur.fax,
                   tel                = v_row_cur.tel,
                   consult_tel        = v_row_cur.con_tel,
                   dept_caddress      = v_row_cur.dpt_caddr,
                   dept_eaddress      = v_row_cur.dpt_eaddr,
                   post_code          = v_row_cur.zip_cde,
                   dept_simple_name   = v_row_cur.dpt_abr,
                   dept_series        = v_row_cur.dpt_serno,
                   contact_user       = v_row_cur.ctct_cde,
                   inter_code         = v_row_cur.inter_cde,
                   found_date         = v_row_cur.fnd_tm,
                   tax_regist_no      = v_row_cur.taxrgst_no,
                   license_no         = v_row_cur.lcn_abr,
                   qualify_no         = v_row_cur.bnsrgst_no,
                   updated_date       = sysdate,
                   updated_user       = 'admin'
             where dept_code = v_row_cur.dpt_cde;
          end if;
        exception
          when others then
            rollback to sp;
            --error
            pkg_util_log.log_error(v_fun_syn,
                                   pkg_util_cons.c_taks_id,
                                   pkg_util_cons.c_user_name,
                                   'UMϵͳ��������:' || v_row_cur.dpt_cde || ',ORA�������:' || sqlcode || ',ORA������Ϣ:' || sqlerrm);
        end;
        --info
        pkg_util_log.log_info(v_fun_syn,
                              pkg_util_cons.c_taks_id,
                              pkg_util_cons.c_user_name,
                              'UMϵͳ��������:' || v_row_cur.dpt_cde);
        commit;
      
      end loop;
    
      if cur_dept%isopen = true then
        close cur_dept;
      end if;
    end; -- end declare
  
    return 1;
  end f_synchro_dept;

  /********************************************************************************************
  * ���ܣ�ͬ����Ա
  * ������i_dept_code�ϳ���������ЩHR��Ա�Ĳ��Ŵ���Ϊ�գ����Բ����ô˲���������ȡ����
  * ����: sunyf
  *********************************************************************************************/
  function f_synchro_salesman_bak20160324(i_dept_code in department.dept_code%type default null) return integer is
  begin
  
    declare
      --
      v_func_name varchar2(128) := 'pkg_util_syn.f_synchro_salesman';
      --
      v_count_1 number := -1;
      v_count_2 number := -1;
      v_count_3 number := -1;
      v_count_4 number := -1;
    
      v_dpt_cde   t_emp_cde.c_dpt_cde%type;
      v_emp_cde   t_emp_cde.c_emp_cde%type;
      v_log_level number;
      v_row_hr    emp_base_info%rowtype;
      --cursor
      cursor cur_emp_hr is
        select distinct t1.account
          from emp_base_info t1
         where 1 = 1
              --and t1.hrms_userfield_140 like i_dept_code || '%'
              --and t1.dimissiontime >= trunc(sysdate, 'yyyy')
           and t1.dimissiontime >= trunc(sysdate - 7);
      v_row_cur cur_emp_hr%rowtype;
    
    begin
      if cur_emp_hr%isopen = false then
        open cur_emp_hr;
      end if;
    
      loop
        fetch cur_emp_hr
          into v_row_cur;
        exit when cur_emp_hr%notfound;
      
        begin
        
          savepoint sp;
          --clear
          v_dpt_cde := '';
          v_emp_cde := '';
        
          --�����Ƿ��и��û�
          select count(1) into v_count_1 from t_emp_cde t where t.c_hr_id = v_row_cur.account;
        
          --����ϵͳȡ������
          if (v_count_1 = 0) then
            --warning
            pkg_util_log.log_warning(v_func_name,
                                     pkg_util_cons.c_taks_id,
                                     pkg_util_cons.c_user_name,
                                     upper('����ϵͳ��T_EMP_CDEû�д�HR�û��û�ID:') || v_row_cur.account);
          elsif (v_count_1 = 1) then
            select t.c_dpt_cde, t.c_emp_cde
              into v_dpt_cde, v_emp_cde
              from t_emp_cde t
             where t.c_hr_id = v_row_cur.account;
          else
            --warning
            pkg_util_log.log_warning(v_func_name,
                                     pkg_util_cons.c_taks_id,
                                     pkg_util_cons.c_user_name,
                                     upper('����ϵͳ��T_EMP_CDE�ж��HR�û��û�ID:') || v_row_cur.account);
            --ȡ���µĹ���
            select t.c_dpt_cde, t.c_emp_cde
              into v_dpt_cde, v_emp_cde
              from t_emp_cde t
             where t.c_hr_id = v_row_cur.account
               and t.t_passwd_efc_tm =
                   (select max(t1.t_passwd_efc_tm) from t_emp_cde t1 where t1.c_hr_id = v_row_cur.account);
          end if;
        
          --�л�������
          if (v_dpt_cde is not null) then
            select *
              into v_row_hr
              from emp_base_info t1
             where 1 = 1
                  --���ܼӲ�����Ϊ��Щ�˲���Ϊ�գ�shenqianbing1
                  --and t1.hrms_userfield_140 like v_array(i) || '%'
               and t1.account = v_row_cur.account
               and t1.rowid =
                  --��ͬ��ְ���ڻ��ж�����¼
                   (select max(t2.rowid)
                      from emp_base_info t2
                     where t2.account = v_row_cur.account
                       and t2.dimissiontime =
                           (select max(t3.dimissiontime) from emp_base_info t3 where t3.account = v_row_cur.account));
            --�Ƿ���ͬ��
            select count(1)
              into v_count_2
              from salesman t
             where 1 = 1
               and t.salesman_code = v_row_hr.account;
          
            --���SALSMAN��û�м�¼
            if (v_count_2 = 0) then
              --�����Ƿ��Ѿ�����
              select count(1) into v_count_3 from department t where t.dept_code = v_dpt_cde;
              --�������
              if (v_count_3 = 0) then
                --
                select count(1) into v_count_4 from um_department t where t.dpt_cde = v_dpt_cde;
                --
                if (v_count_4 = 0) then
                  --warning
                  pkg_util_log.log_warning(v_func_name,
                                           pkg_util_cons.c_taks_id,
                                           pkg_util_cons.c_user_name,
                                           upper('UMϵͳ��UM_DEPARTMENTû�д˻�������:') || v_dpt_cde);
                else
                  --
                  insert into department
                    (dept_code,
                     dept_cname,
                     dept_ename,
                     parent_dept_code,
                     dept_level,
                     dept_relation_code,
                     insure_license_no,
                     case_address,
                     case_tel, --
                     alarm_flag,
                     dept_flag,
                     fax,
                     tel,
                     consult_tel, --
                     dept_caddress,
                     dept_eaddress,
                     post_code,
                     dept_simple_name,
                     dept_series, --
                     contact_user,
                     inter_code,
                     found_date,
                     --expire_date,
                     tax_regist_no, --
                     license_no,
                     qualify_no, --
                     --special_dept,
                     --tel_dept_flag,
                     --license_valid,
                     --license_expire,
                     --circ_code,
                     --sale_region_code,
                     --tax_recognize_no,
                     valid_ind,
                     created_date,
                     created_user,
                     updated_date,
                     updated_user)
                    select t.dpt_cde,
                           t.dpt_cnm,
                           t.c_dpt_enm,
                           t.c_snr_dpt,
                           t.n_dpt_levl,
                           t.dpt_rel_cde,
                           t.insprmt_no,
                           t.rpt_addr,
                           t.rpt_tel, --
                           t.alarm_mrk,
                           t.department_mrk,
                           t.fax,
                           t.tel,
                           t.con_tel, --
                           t.dpt_caddr,
                           t.dpt_eaddr,
                           t.zip_cde,
                           t.dpt_abr,
                           t.dpt_serno, --
                           t.ctct_cde,
                           t.inter_cde,
                           t.fnd_tm,
                           --t.abd_tm,   --ʧЧ����
                           t.taxrgst_no, --
                           t.lcn_abr,
                           t.bnsrgst_no, --չҵ�ʸ�֤
                           '1',
                           sysdate,
                           'admin',
                           sysdate,
                           'admin'
                      from um_department t
                     where t.dpt_cde = v_dpt_cde;
                end if;
              end if;
              --insert������Ա
              insert into salesman
                (salesman_code,
                 dept_code,
                 salesman_cname,
                 sex,
                 age,
                 birthday,
                 certify_no,
                 nation, --����
                 status,
                 salesman_type,
                 contract_date, --��˾����
                 entry_date, --��ְ����
                 regular_date,
                 dimission_date,
                 trytou,
                 employ_code,
                 valid_ind,
                 process_status,
                 salesman_flag,
                 stat_flag,
                 created_user,
                 created_date,
                 position_category_name)
              values
                (v_row_hr.account,
                 v_dpt_cde,
                 v_row_hr.employeename,
                 case
                 --��
                  when v_row_hr.sex = '1' then '106001'
                 --Ů
                  when v_row_hr.sex = '2' then '106002'
                 --δ֪
                  else '106003' end,
                 v_row_hr.age,
                 v_row_hr.birthday,
                 v_row_hr.idcardid,
                 '01', --����
                 v_row_hr.status,
                 v_row_hr.employeetype,
                 v_row_hr.enterdate, --��˾ʱ��
                 v_row_hr.inpositiondate, --��ְʱ��
                 v_row_hr.induedate,
                 v_row_hr.dimissiontime,
                 case
                 --��ʽԱ��
                  when v_row_hr.employeetype = '1' then '0'
                 --����Ա
                  when v_row_hr.employeetype = '2' then '1'
                 --��ְԱ��
                  when v_row_hr.employeetype = '12' then '0'
                 --��ְԱ��
                  else '0' end,
                 v_emp_cde,
                 '1',
                 '1', -- δ����
                 case when trim(v_row_hr.jobcategoryname) = 'ǰ̨' then '1' else '0' end,
                 '0', --�Ƿ����ͳ�ƣ�Ĭ�ϲ�����ͳ��
                 'admin',
                 sysdate,
                 v_row_hr.positioncategoryname);
              --���SALSMAN�����м�¼
            else
              update salesman t
                 set t.salesman_cname = v_row_hr.employeename,
                     t.status         = v_row_hr.status,
                     t.salesman_type  = v_row_hr.employeetype,
                     t.contract_date  = v_row_hr.enterdate, --��˾ʱ��
                     t.entry_date     = v_row_hr.inpositiondate, --��ְ����
                     t.regular_date   = v_row_hr.induedate,
                     t.dept_code      = decode(t.process_status, '1', v_dpt_cde, t.dept_code),
                     t.trytou = case
                                --��ʽԱ��
                                  when v_row_hr.employeetype = '1' then
                                   '0'
                                --����Ա��
                                  when v_row_hr.employeetype = '2' then
                                   '1'
                                --��ְԱ��
                                  when v_row_hr.employeetype = '12' then
                                   '0'
                                  else
                                   '0'
                                end,
                     t.dimission_date = v_row_hr.dimissiontime, --��ְ����
                     t.salesman_flag = case
                                         when trim(v_row_hr.jobcategoryname) = 'ǰ̨' then
                                          '1'
                                         else
                                          '0'
                                       end,
                     t.dept_extend    = to_char(sysdate, 'yyyy-MM-dd hh24:mi:ss'),
                     --t.updated_date   = sysdate,
                     --t.updated_user   = 'admin',
                     --t.dept_code      = v_dpt_cde, --��Ҫͬ��������ͬ���˻���֮����Ҳ����Ŷ�
                     t.employ_code            = v_emp_cde,
                     t.position_category_name = v_row_hr.positioncategoryname --ְλ��������
               where t.salesman_code = v_row_hr.account;
            end if; --��ͬ��
          else
            --warning
            pkg_util_log.log_warning(v_func_name,
                                     pkg_util_cons.c_taks_id,
                                     pkg_util_cons.c_user_name,
                                     upper('����ϵͳ��T_EMP_CDEû��HR�û�ID:') || v_row_cur.account || '�Ļ�������');
          end if; --�в��Ŵ���
        exception
          when others then
            rollback to sp;
            --error
            pkg_util_log.log_error(v_func_name,
                                   pkg_util_cons.c_taks_id,
                                   pkg_util_cons.c_user_name,
                                   'HR�û�:' || v_row_cur.account || ',ORA�������:' || sqlcode || ',ORA������Ϣ:' || sqlerrm);
        end;
        --info
        pkg_util_log.log_info(v_func_name,
                              pkg_util_cons.c_taks_id,
                              pkg_util_cons.c_user_name,
                              'HR�û�:' || v_row_cur.account || 'ͬ���ɹ�');
        commit;
      
      end loop;
    
      if cur_emp_hr%isopen = true then
        close cur_emp_hr;
      end if;
    end;
  
    --���ݼ���ɾ��������
    insert into salesman_del
      select sysdate, t1.*
        from salesman t1
       where not exists (select 1 from emp_base_info t2 where t1.salesman_code = t2.account);
    --ɾ����HR�����ڵ��û�
    delete from salesman t1 where not exists (select 1 from emp_base_info t2 where t1.salesman_code = t2.account);
    --
    commit;
    return 1;
  end f_synchro_salesman_bak20160324;

  /********************************************************************************************
  * ���ܣ�ͬ����Ա
  * ������i_dept_code�ϳ���������ЩHR��Ա�Ĳ��Ŵ���Ϊ�գ����Բ����ô˲���������ȡ����
  * ����: sunyf
  *********************************************************************************************/
  function f_synchro_salesman(i_dept_code in department.dept_code%type default null) return integer is
    v_func_name varchar2(128) := 'pkg_util_syn.f_synchro_salesman';
  begin
    begin
      --1������м������
      execute immediate 'truncate table emp_base_info_extract';
    
      --2��ͬ��������Ϣ
      insert into department
        (dept_code,
         dept_cname,
         dept_ename,
         parent_dept_code,
         dept_level,
         dept_relation_code,
         insure_license_no,
         case_address,
         case_tel, --
         alarm_flag,
         dept_flag,
         fax,
         tel,
         consult_tel, --
         dept_caddress,
         dept_eaddress,
         post_code,
         dept_simple_name,
         dept_series, --
         contact_user,
         inter_code,
         found_date,
         tax_regist_no, --
         license_no,
         qualify_no,
         valid_ind,
         created_date,
         created_user,
         updated_date,
         updated_user)
        select t1.dpt_cde,
               t1.dpt_cnm,
               t1.c_dpt_enm,
               t1.c_snr_dpt,
               t1.n_dpt_levl,
               t1.dpt_rel_cde,
               t1.insprmt_no,
               t1.rpt_addr,
               t1.rpt_tel,
               t1.alarm_mrk,
               t1.department_mrk,
               t1.fax,
               t1.tel,
               t1.con_tel, --
               t1.dpt_caddr,
               t1.dpt_eaddr,
               t1.zip_cde,
               t1.dpt_abr,
               t1.dpt_serno, --
               t1.ctct_cde,
               t1.inter_cde,
               t1.fnd_tm,
               t1.taxrgst_no, --
               t1.lcn_abr,
               t1.bnsrgst_no, --չҵ�ʸ�֤
               '1',
               sysdate,
               'admin',
               sysdate,
               'admin'
          from um_department t1
         where t1.dpt_cde not in (select t2.dept_code from department t2);
    
      -- 3�������м������
      insert into emp_base_info_extract
        (em_id,
         employeename,
         age,
         sex,
         nativeplace,
         birthplace,
         birthday,
         idcardid,
         idtype,
         employeetype,
         inpositiondate,
         enterdate,
         induedate,
         dimissiontime,
         status,
         account,
         positionname,
         jobcategoryname,
         fgscode)
        select t.em_id,
               t.employeename,
               t.age,
               case
                 when t.sex = '1' then
                  '106001' --��
                 when t.sex = '2' then
                  '106002' --Ů
                 else
                  '106003' --δ֪
               end,
               t.nativeplace,
               t.birthplace,
               t.birthday,
               t.idcardid,
               t.idtype,
               case
                 when t.employeetype = '2' then
                  '1' --������
                 else
                  '0'
               end,
               t.inpositiondate,
               t.enterdate,
               t.induedate,
               t.dimissiontime,
               t.status,
               t.account,
               t.positionname,
               case
                 when t.jobcategoryname = 'ǰ̨' then
                  '1'
                 else
                  '0'
               end,
               case
                 when substr(t.fgsname, 1, 2) = '����' then
                  '01'
                 when substr(t.fgsname, 1, 2) = '�㶫' then
                  '02'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '03'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '04'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '05'
                 when substr(t.fgsname, 1, 2) = '�Ϻ�' then
                  '06'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '07'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '08'
                 when substr(t.fgsname, 1, 2) = '�㽭' then
                  '09'
                 when substr(t.fgsname, 1, 2) = '�Ĵ�' then
                  '10'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '11'
                 when substr(t.fgsname, 1, 2) = 'ɽ��' then
                  '12'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '13'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '14'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '15'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '16'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '17'
                 when substr(t.fgsname, 1, 2) = 'ɽ��' then
                  '18'
                 when substr(t.fgsname, 1, 2) = '���' then
                  '19'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '20'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '21'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '22'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '23'
                 when substr(t.fgsname, 1, 2) = '��ݸ' then
                  '24'
                 when substr(t.fgsname, 1, 2) = '�ӱ�' then
                  '25'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '26'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '27'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '28'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '29'
                 when substr(t.fgsname, 1, 2) = '�ൺ' then
                  '30'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '31'
                 when substr(t.fgsname, 1, 2) = '�ܹ�' then
                  '00'
                 when substr(t.fgsname, 1, 2) = '����' then
                  '00'
                 else
                  '00'
               end
          from emp_base_info t
         where t.dimissiontime > sysdate - 365;
    
      -- 4������������Ա����              
      merge into salesman t3
      using (select t1.*
               from emp_base_info_extract t1
              where 1 = 1
                and t1.account not in (select t5.account
                                         from (select t1.account, t1.dimissiontime
                                                 from emp_base_info_extract t1
                                                where 1 = 1
                                                  and not exists (select 1
                                                         from emp_base_info_extract t2
                                                        where t1.account = t2.account
                                                          and t1.dimissiontime < t2.dimissiontime)
                                                group by t1.account, t1.dimissiontime
                                               having count(1) > 1) t5)
                and t1.dimissiontime in (select max(t2.dimissiontime)
                                           from emp_base_info_extract t2
                                          where t1.account = t2.account
                                            and t2.dimissiontime > sysdate - 365 --
                                          group by t2.account)) t4
      on (t3.salesman_code = t4.account)
      when matched then
        update
           set t3.salesman_cname         = t4.employeename, --����
               t3.status                 = t4.status, --��ְ״̬
               t3.salesman_type          = t4.employeetype, --��ְ����
               t3.contract_date          = t4.enterdate, --��˾ʱ��
               t3.entry_date             = t4.inpositiondate, --��ְ����
               t3.regular_date           = t4.induedate, -- ת������
               t3.trytou                 = t4.employeetype, -- �Ƿ�������
               t3.dimission_date         = t4.dimissiontime, --��ְ����
               t3.salesman_flag          = t4.jobcategoryname, --�Ƿ�ǰ̨
               t3.dept_extend            = to_char(sysdate, 'yyyy-MM-dd hh24:mi:ss'), --���һ�θ���ʱ��
               t3.position_category_name = t4.positioncategoryname
         where t3.valid_ind = '1'
      when not matched then
        insert
          (salesman_code,
           dept_code,
           salesman_cname,
           salesman_ename,
           sex,
           age,
           birthday,
           certify_no,
           nation,
           from_address,
           --1
           status,
           salesman_type,
           contract_date,
           entry_date,
           regular_date,
           trytou,
           --2
           process_status,
           valid_ind,
           created_user,
           created_date,
           updated_user,
           updated_date,
           --3
           dimission_date,
           salesman_flag)
        values
          (t4.account,
           t4.fgscode, --����
           t4.employeename,
           t4.account,
           t4.sex,
           t4.age,
           t4.birthday,
           t4.idcardid,
           '01', --����
           t4.birthplace,
           --1
           t4.status,
           t4.employeetype, --��ְ״̬
           t4.enterdate,
           t4.inpositiondate,
           t4.induedate,
           t4.employeetype, --�Ƿ�������
           --2
           '1', -- process_status
           '1',
           'admin',
           sysdate,
           'admin',
           sysdate,
           --
           t4.dimissiontime,
           t4.jobcategoryname);
    
      -- 5�����¹��źͲ���
      merge into salesman t3
      using (select t1.c_hr_id, t1.c_dpt_cde, t1.c_emp_cde
               from t_emp_cde t1
              where 1 = 1
                and t1.c_dpt_cde is not null
                and t1.c_hr_id is not null
                and not exists (select 1
                       from t_emp_cde t2
                      where t1.c_hr_id = t2.c_hr_id
                        and t1.t_upd_tm < t2.t_upd_tm)) t4
      on (t3.salesman_code = t4.c_hr_id and t3.valid_ind = '1')
      when matched then
        update
           set t3.dept_code = t4.c_dpt_cde, t3.employ_code = t4.c_emp_cde
         where 1 = 1
           and (t3.dept_code <> t4.c_dpt_cde or t3.employ_code <> t4.c_emp_cde);
    exception
      when others then
        begin
          rollback;
          --error
          pkg_util_log.log_error(v_func_name,
                                 pkg_util_cons.c_taks_id,
                                 pkg_util_cons.c_user_name,
                                 'ͬ����Աʧ�ܡ�' || sqlcode || ',ORA������Ϣ:' || sqlerrm);
        
          return - 1;
        end;
    end;
    --info
    pkg_util_log.log_info(v_func_name, pkg_util_cons.c_taks_id, pkg_util_cons.c_user_name, 'ͬ����Ա�ɹ���');
    --commit;
    commit;
    return 1;
  end f_synchro_salesman;

end pkg_util_syn;
/
