create or replace package pkg_law_manual is

  /*
  ��������淶
  1����������������v��ͷ�����磺v_count;
  2�������������������i��ͷ������i_version_id,������o��ͷ������o_result���ȿ���
  */

  -- author  : sunyf
  -- created : 2015-07-24
  -- purpose : �ֶ�ִ�м���

  procedure run(i_version_id  in char,
                i_calc_month  in char,
                i_dept_code   in char,
                i_line_code   in char,
                i_user_name   in char,
                o_result_flag out varchar2);

  -- �ֶ�ִ�м��㣬��1��������MIS����
  procedure run_manual_step1(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- �ֶ�ִ�м��㣬��2��������������Ա
  procedure run_manual_step2(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- �ֶ�ִ�м��㣬��3���������׼����
  procedure run_manual_step3(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- �ֶ�ִ�м��㣬��4������������
  procedure run_manual_step4(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- �ֶ�ִ�м��㣬��5�������㹫ʽ
  procedure run_manual_step5(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);
  -- �ֶ�ִ�м��㣬��6������������
  procedure run_manual_step6(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);

  -- �ֶ�ִ�м��㣬��7��������ְ��
  procedure run_manual_step7(i_version_id  in char,
                             i_calc_month  in char,
                             i_dept_code   in char,
                             i_line_code   in char,
                             i_user_name   in char,
                             o_result_flag out varchar2);

  --��ʼִ��ǰ����t_law_define_manual״̬
  procedure p_bgn_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in char,
                         i_result_msg  in char);

  --ִ�к����t_law_define_manual״̬
  procedure p_end_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in out char,
                         i_result_msg  in char);
                         
  function f_get_status(i_version_id in char, --
                        i_calc_month in char, --
                        i_task_code  in char) return varchar2;
end pkg_law_manual;
/
create or replace package body pkg_law_manual is

  /***********************************״̬˵��***********************************************
    �������(1����MIS����,2ȡ������Ա,3����걣,4��������,5���㹫ʽ,6��������,7����ְ��)
    ����״̬(1δ��ʼ,2����ִ��,3ִ�����,9ִ��ʧ��)
  *******************************************************************************************/

  procedure run(i_version_id  in char,
                i_calc_month  in char,
                i_dept_code   in char,
                i_line_code   in char,
                i_user_name   in char,
                o_result_flag out varchar2) is
  v_task_status char(1) := '';                                
  begin
    --ȡ��������������Ա
    run_manual_step2(i_version_id,
                     i_calc_month,
                     i_dept_code,
                     i_line_code,
                     i_user_name,
                     o_result_flag --
                     );
  
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '2');
    --�����׼����
    if (o_result_flag = 1 and v_task_status = '3' )then
      run_manual_step3(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
  
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '3');
    --����������Ա�ĸ�������
    if (o_result_flag = 1 and v_task_status = '3' ) then
      run_manual_step4(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
    
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '4');
    --����������Ա�ĸ���ָ�꼰н��
    if (o_result_flag = 1 and v_task_status = '3' ) then
      run_manual_step5(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
    
    v_task_status := pkg_law_manual.f_get_status(i_version_id, i_calc_month, '4');
    --����������Ա�ĸ�������
    if (o_result_flag = 1 and v_task_status = '3' ) then
      run_manual_step6(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
  
    --����������Ա��ְ��
    if o_result_flag = 1 then
      run_manual_step7(i_version_id,
                       i_calc_month,
                       i_dept_code,
                       i_line_code,
                       i_user_name,
                       o_result_flag --
                       );
    else
      return;
    end if;
  end run;

  --����MIS����
  procedure run_manual_step1(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code char(1) := '1'; --�������
    v_task_id   varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --TODO:
    o_result_flag := '1';
  end run_manual_step1;

  --ȡ��������������Ա
  procedure run_manual_step2(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '2'; --�������
    v_sale_count number := 0; --��Ա����
    v_result_msg varchar2(100); --������Ϣ
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --����״̬Ϊ��ʼ
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
  
    --���������������Ƿ�������
    o_result_flag := pkg_law_check.f_check_law_define_cfg(i_version_id);
    if o_result_flag = '1' then
      --ִ���߼�
      o_result_flag := pkg_law_salesman.f_imp_salesman(i_version_id,
                                                       i_calc_month,
                                                       i_dept_code,
                                                       i_line_code,
                                                       i_user_name,
                                                       v_task_id);
    end if;
  
    if o_result_flag = '1' then
      --��ȡ��������
      select count(1)
        into v_sale_count
        from t_law_salesman t
       where t.version_id = i_version_id
         and t.calc_month = i_calc_month;
      --
      v_result_msg := '��' || to_char(v_sale_count) || '��';
    else
      v_result_msg := 'δ���û�����������';
    end if;
  
    --���½���״̬
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  
  end run_manual_step2;

  --�����׼����
  procedure run_manual_step3(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '3'; --�������
    v_calc_all   char := '0'; --0��ֻ�����ϸ��µ�
    v_result_msg varchar2(50) := '��'; --������Ϣ
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --����״̬Ϊ��ʼ
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --ִ���߼�
    o_result_flag := pkg_law_standard.run(i_version_id,
                                          i_dept_code,
                                          i_line_code,
                                          i_calc_month, --
                                          v_calc_all, --
                                          i_user_name,
                                          v_task_id);
    --���½���״̬
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step3;

  --����������Ա�ĸ�������
  procedure run_manual_step4(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '4'; --�������
    v_result_msg varchar2(50) := '��'; --������Ϣ
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --����״̬Ϊ��ʼ
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --ִ���߼�
    o_result_flag := pkg_law_sum.run(i_calc_month,
                                     i_dept_code,
                                     i_line_code,
                                     i_version_id,
                                     i_user_name, --
                                     v_task_id);
    --���½���״̬
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step4;

  --����������Ա�ĸ���ָ�꼰н��
  procedure run_manual_step5(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '5'; --�������
    v_result_msg varchar2(50) := '��'; --������Ϣ
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --����״̬Ϊ��ʼ
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --ִ���߼�
    o_result_flag := pkg_law_wage.run(i_dept_code,
                                      i_line_code,
                                      i_version_id,
                                      i_calc_month,
                                      i_user_name, --
                                      v_task_id);
    --���½���״̬
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step5;

  --����������Ա�ĸ�������
  procedure run_manual_step6(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '6'; --�������
    v_result_msg varchar2(50) := '��'; --������Ϣ
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --����״̬Ϊ��ʼ
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --ִ���߼�
    o_result_flag := pkg_law_result.f_insert_main(i_version_id, --
                                                  i_dept_code, --
                                                  i_line_code, --
                                                  i_calc_month, --
                                                  i_user_name, --
                                                  v_task_id);
    --���½���״̬
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step6;

  --����������Ա��ְ��
  procedure run_manual_step7(i_version_id  in char, --�������汾ID
                             i_calc_month  in char, --��������yyyymm
                             i_dept_code   in char, --�ֹ�˾���룬��λ
                             i_line_code   in char, --ҵ�����925007
                             i_user_name   in char, --��ǰ�û��Ĵ���
                             o_result_flag out varchar2) is
    v_task_code  char(1) := '7'; --�������
    v_result_msg varchar2(50) := '��'; --������Ϣ
    v_task_id    varchar2(50) := i_dept_code || to_char(systimestamp, 'yyyymmddhh24missff3');
  begin
    --����״̬Ϊ��ʼ
    p_bgn_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code, --
                 '',
                 '');
    --ִ���߼�
    o_result_flag := pkg_law_rank.run(i_dept_code, i_line_code, i_version_id, i_calc_month, i_user_name, v_task_id);
    --���½���״̬
    p_end_status(i_dept_code,
                 i_line_code,
                 i_version_id,
                 i_calc_month,
                 i_user_name,
                 v_task_id,
                 v_task_code,
                 o_result_flag,
                 v_result_msg);
  end run_manual_step7;

  procedure p_bgn_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in char,
                         i_result_msg  in char) is
    pragma autonomous_transaction;
  begin
    update t_law_define_manual t
       set t.task_status   = '2', --����״̬(1δ��ʼ,2����ִ��,3ִ�����,9ִ��ʧ��)
           t.task_bng_date = sysdate,
           t.task_end_date = null,
           t.remark        = '',
           t.updated_user  = i_user_name,
           t.updated_date  = sysdate,
           t.task_id       = i_task_id
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.line_code = i_line_code
       and t.task_code = i_task_code;
    --
    update t_law_define t set t.last_start_tm = sysdate where t.version_id = i_version_id;
    commit;
  end p_bgn_status;

  procedure p_end_status(i_dept_code   in char,
                         i_line_code   in char,
                         i_version_id  in char,
                         i_calc_month  in char,
                         i_user_name   in char,
                         i_task_id     in char,
                         i_task_code   in char,
                         i_task_status in out char,
                         i_result_msg  in char) is
    pragma autonomous_transaction;
    v_erro_count  integer;
    v_task_status char(1);
  begin
    --�ж���־���Ƿ����쳣����������ִ��ʧ��
    select count(1)
      into v_erro_count
      from t_law_log t
     where t.task_id = i_task_id
       and t.log_level = '2';
    if (v_erro_count > 0) then
      v_task_status := '9';
    else
      v_task_status := '3';
    end if;
    --dbms_output.put_line(i_task_status);
    --����״̬(1δ��ʼ,2����ִ��,3ִ�����,9ִ��ʧ��)
    update t_law_define_manual t
       set t.task_status   = v_task_status,
           t.task_end_date = sysdate,
           t.remark        = i_result_msg,
           t.updated_user  = i_user_name,
           t.updated_date  = sysdate
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.line_code = i_line_code
       and t.task_code = i_task_code;
    commit;
  end p_end_status;

  function f_get_status(i_version_id in char, --
                        i_calc_month in char, --
                        i_task_code  in char) return varchar2 is
    v_task_status char(1) := '';
  begin
    select t.task_status
      into v_task_status
      from t_law_define_manual t
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.task_code = i_task_code;
  end f_get_status;
end pkg_law_manual;
/
