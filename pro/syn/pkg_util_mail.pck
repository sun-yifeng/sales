create or replace package pkg_util_mail is

  -- author  : sunyf
  -- created : 2015/1/26 17:56:03
  -- purpose : 取预警邮件的收件人

  -- 系统代码
  c_sys_code constant varchar2(10) := lower('xszc');

  -- 测试开关
  send_flag constant boolean := true;

  -- 功能：从取um系统取邮件收件人抄送人
  -- 说明：分中介机构、个人代理两种情况
  procedure p_get_email(i_channel_code in varchar2, --渠道代码（包括中介，个人）
                        o_receive_user out varchar2,
                        o_copy_user    out varchar2);

  -- 功能：根据角色、机构代码取用户（域名邮箱）
  function f_get_user(i_role_ename in varchar2, --角色代码
                      i_dept_code  in varchar2 --部门代码
                      ) return varchar2;

end pkg_util_mail;
/
create or replace package body pkg_util_mail is

  -- 功能：从取um系统取邮件收件人抄送人
  -- 说明：分中介机构、个人代理两种情况
  procedure p_get_email(i_channel_code in varchar2, --传入渠道代码（包括中介，个人）
                        o_receive_user out varchar2, --返回邮件接收人列表
                        o_copy_user    out varchar2 --返回邮件抄收人列表
                        ) is
    v_dept_code    varchar2(2) := '';
    v_channel_flag varchar2(2) := '';
  begin
    --测试开关
    if (send_flag) then
      --取机构的两位代码，渠道标示
      select substr(t.dept_code, 0, 2), t.channel_flag
        into v_dept_code, v_channel_flag
        from channel_main t
       where t.channel_code = i_channel_code;
      --1.如果是中介机构
      if (v_channel_flag = '0') then
        o_receive_user := f_get_user('subDeptMediumChannelNew', v_dept_code);
        --如果分公司的收件人为空，则取总公司的收件人
        if (o_receive_user is null) then
          o_receive_user := f_get_user('headDeptMediumChanelNew', '00');
          --取分公司的抄送人
          o_copy_user := f_get_user('subDeptManagerChannelNew', v_dept_code);
          --取总公司的抄送人，并且加上分公司的抄送人
          if (o_copy_user is null) then
            o_copy_user := f_get_user('headDeptAdminChannelNew', '00');
          else
            o_copy_user := o_copy_user || ',' || f_get_user('headDeptAdminChannelNew', '00');
          end if;
          --如果分公司收件人不为空，则要取分公司的抄送人
        else
          o_copy_user := f_get_user('subDeptManagerChannelNew', v_dept_code);
        end if;
        --2.如果是个人代理
      elsif (v_channel_flag = '1' or v_channel_flag = '4') then
        --select nvl(wm_concat(t.user_code), v_defualt_mail) as usercode
        o_receive_user := f_get_user('subDeptSalesmanAgentNew', v_dept_code);
        --如果分公司的收件人为空，则取总公司的收件人
        if (o_receive_user is null) then
          o_receive_user := f_get_user('headDeptSalesmanAgentNew', '00');
          --取分公司的抄送人
          o_copy_user := f_get_user('subDeptMangerNew', v_dept_code);
          --取总公司的抄送人，并且加上分公司的抄送人
          if (o_copy_user is null) then
            o_copy_user := f_get_user('headDeptSalesmanAgentNew', '00');
          else
            o_copy_user := o_copy_user || ',' || f_get_user('headDeptSalesmanAgentNew', '00');
          end if;
          --如果分公司收件人不为空，则要取分公司的抄送人
        else
          o_copy_user := f_get_user('subDeptMangerNew', v_dept_code);
        end if;
      end if;

      --如果收件人或抄送人为空，则发送到默认邮箱
      if (o_receive_user is null) then
        o_receive_user := 'xszc@sinosafe.com.cn';
      end if;
    else
      o_receive_user := 'ex_xulinchao@sinosafe.com.cn,ex_liuyangming@sinosafe.com.cn';
      o_copy_user    := 'ex_xulinchao@sinosafe.com.cn,sunyifeng@sinosafe.com.cn';
    end if;

  end;

  -- 功能：根据角色、机构代码取用户（域名邮箱）
  function f_get_user(i_role_ename in varchar2, --角色代码
                      i_dept_code  in varchar2 --部门代码
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
