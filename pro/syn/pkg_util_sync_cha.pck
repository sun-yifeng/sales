create or replace package PKG_UTIL_SYNC_CHA is

  -- Author  : sunyf
  -- Created : 2015-04-10 17:23:51
  -- Purpose : ����֧��ϵͳ���ݵ������ϵͳ--����ʵʱ
  -- Note    : ԭ���Ĵ����PK_SYNC_2HX_CHA_INFO

  procedure p_channel_overdue(i_dept_code    in varchar, --
                              o_update_count out varchar,
                              o_result_msg   out varchar);

  procedure P_CHA_SYNC(sChaCde in varchar2, sRest out varchar2, sMessage out varchar2);

  procedure P_WRITE_ERRORLOG(sChaCde in varchar2, sError IN varchar2);

end PKG_UTIL_SYNC_CHA;
/
create or replace package body PKG_UTIL_SYNC_CHA is

  --���ܣ����Ŀ���ѡ�����ʹ��ڻ���Э����ڵ�Э����(������)��������ʵ�ʹ��򲻷��ϣ�
  --      ���˲飬���ֺ���ϵͳ��Э������ʾ�Ĺܿ���t_agent.t_adb_tm�ֶΣ���������֧��ϵͳ��û��д���ֶε�ֵ��
  --      ���Է��뿪���ڴ����ĵ�ʱ���t_adb_tm��ֵ������Ϊ���ж�����ʱ����Э���ʱ�䣬ȡ���һ��ʱ�丳��t_adb_tm��
  --���ߣ�sunyf
  --����: 2015-12-15
  procedure p_channel_overdue(i_dept_code    in varchar, --
                              o_update_count out varchar,
                              o_result_msg   out varchar) is
  begin
    declare
      --
      v_count_1     integer := 0;
      v_count_2     integer := 0;
      v_expire_date date;
    begin
      o_result_msg := '�ɹ�';
      for c in (select t.channel_code
                  from channel_main t
                 where t.valid_ind = '1'
                   and (t.t_adb_tm > sysdate or t.t_adb_tm is null)) loop
        --��ȡ�������ʵ���ʱ��           
        select max(expire_date)
          into v_expire_date
          from (select t1.expire_date as expire_date
                  from channel_medium_detail t1
                 where t1.channel_code = c.channel_code
                union
                select t2.qualification_expire_date as expire_date
                  from channel_agent_detail t2
                 where t2.channel_code = c.channel_code
                union
                select t3.expire_date
                  from channel_confer t3
                 where t3.valid_ind = '1'
                   and t3.approve_flag = '1'
                   and t3.channel_code = c.channel_code);
        --����������ʵ��ڣ���t_adb_tm����Ϊ��ǰϵͳʱ��           
        if (v_expire_date < sysdate) then
          update channel_main t set t.t_adb_tm = sysdate where t.channel_code = c.channel_code;
        else
          --�����������δ���ڣ���t_adb_tm����Ϊnull
          update channel_main t set t.t_adb_tm = null where t.channel_code = c.channel_code;
        end if;
      
        --
        v_count_1 := v_count_1 + sql%rowcount;
        v_count_2 := v_count_2 + sql%rowcount;
        --
        if (v_count_2 >= 1000) then
          commit;
          v_count_2 := 0;
        end if;
      end loop;
      commit;
      o_update_count := '���¼�¼��:' || to_char(v_count_1);
    exception
      when others then
        begin
          rollback;
          o_result_msg := 'ʧ��';
        end;
    end;
  
  end p_channel_overdue;

  procedure P_CHA_SYNC(sChaCde in varchar2, sRest out varchar2, sMessage out varchar2) is
  
  begin
    sRest    := '1';
    sMessage := '�ɹ�';
  
    begin
      -- Call the procedure
      salesupport_import_hx.P_SINGLE_IMPORT(sChaCde, sRest, sMessage);
      if sRest = '-1' then
        rollback;
        dbms_output.put_line(sMessage);
        P_WRITE_ERRORLOG(sChaCde, sMessage);
        commit;
        return;
      else
        commit;
        dbms_output.put_line('����:' || sChaCde || 'ͬ����ɲ��ύ�ɹ���');
      end if;
    exception
      when others then
        begin
          rollback;
          sRest    := '-1';
          sMessage := '���ú���ͬ�����ʧ�ܣ��������:' || SUBSTR(SQLERRM, 1, 150);
          P_WRITE_ERRORLOG(sChaCde, sMessage);
          commit;
          return;
        end;
    end;
  end P_CHA_SYNC;

  procedure P_WRITE_ERRORLOG(sChaCde in varchar2, sError IN varchar2) is
  begin
  
    insert into channel_sync_error (channel_code, error_msg) values (sChaCde, sError);
  
  exception
    when others then
      begin
        dbms_output.put_line('����:' || sChaCde || 'ͬ����ɲ��ύ�ɹ���');
      end;
    
  end P_WRITE_ERRORLOG;

end PKG_UTIL_SYNC_CHA;
/
