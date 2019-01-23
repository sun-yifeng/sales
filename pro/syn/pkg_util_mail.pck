create or replace package pkg_util_mail is

  -- author  : sunyf
  -- created : 2015/1/26 17:56:03
  -- purpose : ȡԤ���ʼ����ռ���

  -- ϵͳ����
  c_sys_code constant varchar2(10) := lower('xszc');

  -- ���Կ���
  send_flag constant boolean := true;

  -- ���ܣ���ȡumϵͳȡ�ʼ��ռ��˳�����
  -- ˵�������н���������˴����������
  procedure p_get_email(i_channel_code in varchar2, --�������루�����н飬���ˣ�
                        o_receive_user out varchar2,
                        o_copy_user    out varchar2);

  -- ���ܣ����ݽ�ɫ����������ȡ�û����������䣩
  function f_get_user(i_role_ename in varchar2, --��ɫ����
                      i_dept_code  in varchar2 --���Ŵ���
                      ) return varchar2;

end pkg_util_mail;
/
create or replace package body pkg_util_mail is

  -- ���ܣ���ȡumϵͳȡ�ʼ��ռ��˳�����
  -- ˵�������н���������˴����������
  procedure p_get_email(i_channel_code in varchar2, --�����������루�����н飬���ˣ�
                        o_receive_user out varchar2, --�����ʼ��������б�
                        o_copy_user    out varchar2 --�����ʼ��������б�
                        ) is
    v_dept_code    varchar2(2) := '';
    v_channel_flag varchar2(2) := '';
  begin
    --���Կ���
    if (send_flag) then
      --ȡ��������λ���룬������ʾ
      select substr(t.dept_code, 0, 2), t.channel_flag
        into v_dept_code, v_channel_flag
        from channel_main t
       where t.channel_code = i_channel_code;
      --1.������н����
      if (v_channel_flag = '0') then
        o_receive_user := f_get_user('subDeptMediumChannelNew', v_dept_code);
        --����ֹ�˾���ռ���Ϊ�գ���ȡ�ܹ�˾���ռ���
        if (o_receive_user is null) then
          o_receive_user := f_get_user('headDeptMediumChanelNew', '00');
          --ȡ�ֹ�˾�ĳ�����
          o_copy_user := f_get_user('subDeptManagerChannelNew', v_dept_code);
          --ȡ�ܹ�˾�ĳ����ˣ����Ҽ��Ϸֹ�˾�ĳ�����
          if (o_copy_user is null) then
            o_copy_user := f_get_user('headDeptAdminChannelNew', '00');
          else
            o_copy_user := o_copy_user || ',' || f_get_user('headDeptAdminChannelNew', '00');
          end if;
          --����ֹ�˾�ռ��˲�Ϊ�գ���Ҫȡ�ֹ�˾�ĳ�����
        else
          o_copy_user := f_get_user('subDeptManagerChannelNew', v_dept_code);
        end if;
        --2.����Ǹ��˴���
      elsif (v_channel_flag = '1' or v_channel_flag = '4') then
        --select nvl(wm_concat(t.user_code), v_defualt_mail) as usercode
        o_receive_user := f_get_user('subDeptSalesmanAgentNew', v_dept_code);
        --����ֹ�˾���ռ���Ϊ�գ���ȡ�ܹ�˾���ռ���
        if (o_receive_user is null) then
          o_receive_user := f_get_user('headDeptSalesmanAgentNew', '00');
          --ȡ�ֹ�˾�ĳ�����
          o_copy_user := f_get_user('subDeptMangerNew', v_dept_code);
          --ȡ�ܹ�˾�ĳ����ˣ����Ҽ��Ϸֹ�˾�ĳ�����
          if (o_copy_user is null) then
            o_copy_user := f_get_user('headDeptSalesmanAgentNew', '00');
          else
            o_copy_user := o_copy_user || ',' || f_get_user('headDeptSalesmanAgentNew', '00');
          end if;
          --����ֹ�˾�ռ��˲�Ϊ�գ���Ҫȡ�ֹ�˾�ĳ�����
        else
          o_copy_user := f_get_user('subDeptMangerNew', v_dept_code);
        end if;
      end if;

      --����ռ��˻�����Ϊ�գ����͵�Ĭ������
      if (o_receive_user is null) then
        o_receive_user := 'xszc@sinosafe.com.cn';
      end if;
    else
      o_receive_user := 'ex_xulinchao@sinosafe.com.cn,ex_liuyangming@sinosafe.com.cn';
      o_copy_user    := 'ex_xulinchao@sinosafe.com.cn,sunyifeng@sinosafe.com.cn';
    end if;

  end;

  -- ���ܣ����ݽ�ɫ����������ȡ�û����������䣩
  function f_get_user(i_role_ename in varchar2, --��ɫ����
                      i_dept_code  in varchar2 --���Ŵ���
                      ) return varchar2 is
    result varchar2(500) := '';
  begin
    select wm_concat(t.user_code) as usercode
      into result
      from um_role r, um_sys_user_role e, um_system_user t, um_user_dept p
     where r.role_code = e.role_code
       and e.sys_user_id = t.sys_user_id
       and r.sys_code = t.sys_code
       and t.user_code = p.user_code
       and r.sys_code = c_sys_code
       and r.role_ename = i_role_ename
       and p.dept_code like i_dept_code || '%'
       and r.valid_ind = '1'
       and e.valid_ind = '1'
       and t.valid_ind = '1'
       and p.valid_ind = '1';
    return(result);
  end;

end pkg_util_mail;
/
