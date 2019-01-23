create or replace package PKG_UTIL_SYN is

  -- Author  : sunyf
  -- Created : 2014-10-11
  -- Purpose : 同步销售人员

  -- 同步HR人员
  function f_synchro_salesman(i_dept_code in department.dept_code%type default null)
    return integer;

  -- 同步机构
  function f_synchro_dept(i_dept_code in department.dept_code%type default null)
    return integer;

end PKG_UTIL_SYN;
/
create or replace package body pkg_util_syn is

  -- Author  : sunyf
  -- Created : 2014-10-11
  -- Purpose : 同步人员,同步机构

  /*
  * 功能：同步机构
  * 参数：i_dept_code,可选参数，按分公司同步机构
  * 作者: sunyf
  */
  function f_synchro_dept(i_dept_code in department.dept_code%type default null)
    return integer is
    v_fun_syn varchar2(128);
  begin
  
    v_fun_syn := 'pkg_util_syn.f_synchro_dept';
  
    declare
      v_count_1 number := -1;
      --cursor
      cursor cur_dept is
        select *
          from um_department t
         where t.dpt_cde like i_dept_code || '%'
         order by t.dpt_cde;
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
          --是否有机构
          select count(1)
            into v_count_1
            from department t
           where t.dept_code = v_row_cur.dpt_cde;
          --如果不存在，则插入
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
               --expire_date,   --失效日期
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
                     --t.abd_tm,   --失效日期
                     t.taxrgst_no, --
                     t.lcn_abr,
                     t.bnsrgst_no, --展业资格证
                     '1',
                     sysdate,
                     'admin',
                     sysdate,
                     'admin'
                from um_department t
               where t.dpt_cde = v_row_cur.dpt_cde;
            --如果已存在，则更新
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
                                   'UM系统机构代码:' || v_row_cur.dpt_cde ||
                                   ',ORA错误代码:' || sqlcode || ',ORA错误信息:' ||
                                   sqlerrm);
        end;
        --info
        pkg_util_log.log_info(v_fun_syn,
                              pkg_util_cons.c_taks_id,
                              pkg_util_cons.c_user_name,
                              'UM系统机构代码:' || v_row_cur.dpt_cde);
        commit;
      
      end loop;
    
      if cur_dept%isopen = true then
        close cur_dept;
      end if;
    end; -- end declare
  
    return 1;
  end f_synchro_dept;

  /*
  * 功能：同步人员
  * 参数：i_dept_code废除（由于有些HR人员的部门代码为空，所以不能用此参数按机构取数）
  * 作者: sunyf
  */
  function f_synchro_salesman(i_dept_code in department.dept_code%type default null)
    return integer is
    v_date_range date := sysdate - 365 * 3;
  begin
    --execute immediate 'create table salesmam20160505 as select * from salesman';
    --1、清除中间表数据
    execute immediate 'truncate table emp_base_info_extract';
    --2、同步机构信息
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
             t1.rpt_tel, --
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
             --t1.abd_tm,   --失效日期
             t1.taxrgst_no, --
             t1.lcn_abr,
             t1.bnsrgst_no, --展业资格证
             '1',
             sysdate,
             'admin',
             sysdate,
             'admin'
        from um_department t1
       where t1.dpt_cde not in (select t2.dept_code from department t2);
  
    -- 3、插入中间表数据
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
       fgscode,
       positioncategoryname)
      select t.em_id,
             t.employeename,
             t.age,
             case
               when t.sex = '1' then
                '106001' --男
               when t.sex = '2' then
                '106002' --女
               else
                '106003' --未知
             end,
             t.nativeplace,
             t.birthplace,
             t.birthday,
             t.idcardid,
             t.idtype,
             case
               when t.employeetype = '2' then
                '1' --试用期
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
               when t.jobcategoryname = '前台' then
                '1'
               else
                '0'
             end,
             case
               when substr(t.fgsname, 1, 2) = '深圳' then
                '01'
               when substr(t.fgsname, 1, 2) = '广东' then
                '02'
               when substr(t.fgsname, 1, 2) = '湖南' then
                '03'
               when substr(t.fgsname, 1, 2) = '福建' then
                '04'
               when substr(t.fgsname, 1, 2) = '广西' then
                '05'
               when substr(t.fgsname, 1, 2) = '上海' then
                '06'
               when substr(t.fgsname, 1, 2) = '北京' then
                '07'
               when substr(t.fgsname, 1, 2) = '江苏' then
                '08'
               when substr(t.fgsname, 1, 2) = '浙江' then
                '09'
               when substr(t.fgsname, 1, 2) = '四川' then
                '10'
               when substr(t.fgsname, 1, 2) = '大连' then
                '11'
               when substr(t.fgsname, 1, 2) = '山东' then
                '12'
               when substr(t.fgsname, 1, 2) = '重庆' then
                '13'
               when substr(t.fgsname, 1, 2) = '云南' then
                '14'
               when substr(t.fgsname, 1, 2) = '陕西' then
                '15'
               when substr(t.fgsname, 1, 2) = '辽宁' then
                '16'
               when substr(t.fgsname, 1, 2) = '江西' then
                '17'
               when substr(t.fgsname, 1, 2) = '山西' then
                '18'
               when substr(t.fgsname, 1, 2) = '天津' then
                '19'
               when substr(t.fgsname, 1, 2) = '安徽' then
                '20'
               when substr(t.fgsname, 1, 2) = '湖北' then
                '21'
               when substr(t.fgsname, 1, 2) = '河南' then
                '22'
               when substr(t.fgsname, 1, 2) = '宁波' then
                '23'
               when substr(t.fgsname, 1, 2) = '东莞' then
                '24'
               when substr(t.fgsname, 1, 2) = '河北' then
                '25'
               when substr(t.fgsname, 1, 2) = '黑龙' then
                '26'
               when substr(t.fgsname, 1, 2) = '吉林' then
                '27'
               when substr(t.fgsname, 1, 2) = '内蒙' then
                '28'
               when substr(t.fgsname, 1, 2) = '贵州' then
                '29'
               when substr(t.fgsname, 1, 2) = '青岛' then
                '30'
               when substr(t.fgsname, 1, 2) = '海南' then
                '31'
               when substr(t.fgsname, 1, 2) = '总共' then
                '00'
               when substr(t.fgsname, 1, 2) = '华安' then
                '00'
               else
                '00'
             end,
             t.positioncategoryname
        from emp_base_info t
       where 1=1
        and t.dimissiontime > v_date_range
       ;
    -- 4、更新销售人员数据              
    merge into salesman t3
    using (select t1.*
             from emp_base_info_extract t1
            where 1 = 1
              and t1.account not in
                  (select t5.account
                     from (select t1.account, t1.dimissiontime
                             from emp_base_info_extract t1
                            where 1 = 1
                              and not exists
                            (select 1
                                     from emp_base_info_extract t2
                                    where t1.account = t2.account
                                      and t1.dimissiontime < t2.dimissiontime)
                            group by t1.account, t1.dimissiontime
                           having count(1) > 1) t5)
              and t1.dimissiontime in
                  (select max(t2.dimissiontime)
                     from emp_base_info_extract t2
                    where t1.account = t2.account
                      and t2.dimissiontime > v_date_range --
                    group by t2.account)) t4
    on (t3.salesman_code = t4.account)
    when matched then
      update
         set t3.salesman_cname         = t4.employeename, --姓名
             t3.status                 = t4.status, --在职状态
             t3.salesman_type          = t4.employeetype, --在职分类
             t3.contract_date          = t4.enterdate, --入司时间
             t3.entry_date             = t4.inpositiondate, --入职日期
             t3.regular_date           = t4.induedate, -- 转正日期
             t3.trytou                 = t4.employeetype, -- 是否试用期
             t3.dimission_date         = t4.dimissiontime, --离职日期
             t3.salesman_flag          = t4.jobcategoryname, --是否前台
             t3.dept_extend            = to_char(sysdate,
                                                 'yyyy-MM-dd hh24:mi:ss'), --最后一次更新时间
             t3.position_category_name = t4.positioncategoryname
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
         salesman_flag,
         position_category_name)
      values
        (t4.account,
         t4.fgscode, --机构
         t4.employeename,
         t4.account,
         t4.sex,
         t4.age,
         t4.birthday,
         t4.idcardid,
         '01', --国籍
         t4.birthplace,
         --1
         t4.status,
         t4.employeetype, --在职状态
         t4.enterdate,
         t4.inpositiondate,
         t4.induedate,
         t4.employeetype, --是否试用期
         --2
         '1', -- process_status
         '1',
         'admin',
         sysdate,
         'admin',
         sysdate,
         --
         t4.dimissiontime,
         t4.jobcategoryname,
         t4.positioncategoryname);
    -- 5、根据HRID更新工号和部门（核心的HRID非空）
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
         and (t3.dept_code <> t4.c_dpt_cde or
             t3.employ_code <> t4.c_emp_cde);
    --6、重置处理状态(失效的、离职的都重置，防止重新入职后直接是已经处理)
    /*update salesman t
       set t.process_status = '1'
     where 1 = 1
       and t.process_status = '2'
       and (t.valid_ind <> '1' or t.status <> '1');*/
    --
    commit;
    --7、计算考核时间
    pkg_law_front.p_main('');
    --hr人员离职以后，将离职时间更新到团队离开时间
    pkg_law_front.p_update_date('');
    --hr人员离职更新对应销售助理的挂靠结束时间
    pkg_law_front.p_virtual_enddate('');
    return 1;
  exception
    when others then
      rollback;
      pkg_util_log.log_info('pkg_util_syn.f_synchro_salesman',
                            pkg_util_cons.c_taks_id,
                            pkg_util_cons.c_user_name,
                            '同步人员出错' || sqlerrm);
      return - 1;
  end f_synchro_salesman;

end pkg_util_syn;
/
