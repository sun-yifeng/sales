create or replace package pkg_law_log is

  -- author  : sunyf
  -- created : 2014-9-01 16:01:04
  -- purpose : 通用日志级别

  debug_on constant varchar2(10) := upper('Y');

  procedure log_debug(i_func_name in char,
                      i_task_id   in char,
                      i_user_name in char,
                      i_log_sub   in char,
                      i_log_msg   in char);

  procedure log_info(i_func_name in char,
                     i_task_id   in char,
                     i_user_name in char,
                     i_log_sub   in char,
                     i_log_msg   in char --
                     );

  procedure log_error(i_func_name in char,
                      i_task_id   in char,
                      i_user_name in char,
                      i_log_sub   in char,
                      i_log_msg   in char);

  procedure log_warning(i_func_name in char,
                        i_task_id   in char,
                        i_user_name in char,
                        i_log_sub   in char,
                        i_log_msg   in char);

end pkg_law_log;
/
create or replace package body pkg_law_log is

  procedure log_debug(i_func_name in char,
                      i_task_id   in char,
                      i_user_name in char,
                      i_log_sub   in char,
                      i_log_msg   in char) is
  begin
    if (debug_on = upper('Y')) then
      pkg_law_define.insert_law_log(i_func_name, i_task_id, i_user_name, -1, i_log_sub, i_log_msg);
    end if;
  end log_debug;

  procedure log_info(i_func_name in char,
                     i_task_id   in char,
                     i_user_name in char,
                     i_log_sub   in char,
                     i_log_msg   in char --
                     ) is
  begin
    pkg_law_define.insert_law_log(i_func_name, i_task_id, i_user_name, 0, i_log_sub, i_log_msg);
  end log_info;

  procedure log_error(i_func_name in char,
                      i_task_id   in char,
                      i_user_name in char,
                      i_log_sub   in char,
                      i_log_msg   in char) is
  begin
    pkg_law_define.insert_law_log(i_func_name, i_task_id, i_user_name, 2, i_log_sub, i_log_msg);
  end log_error;

  procedure log_warning(i_func_name in char,
                        i_task_id   in char,
                        i_user_name in char,
                        i_log_sub   in char,
                        i_log_msg   in char) is
  begin
    pkg_law_define.insert_law_log(i_func_name, i_task_id, i_user_name, 1, i_log_sub, i_log_msg);
  end log_warning;

end pkg_law_log;
/
