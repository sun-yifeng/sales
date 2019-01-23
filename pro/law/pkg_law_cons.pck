create or replace package pkg_law_cons is

  -- author  : sunyf
  -- created : 2014/11/27 15:31:32
  -- purpose : 常量定义

  /*
  日志级别
  c_log_debug constant number := -1;
  c_log_info  constant number := 0;
  c_log_warn  constant number := 1;
  c_log_error constant number := 2;
  */

  -- public constant declarations
  c_user_name constant varchar2(10) := 'admin';
  --每一个任务都有一taskid,方便从日志查找错误或计算过程
  c_taks_id_1   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_2   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_3   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_4   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_5   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_6   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_7   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  --司龄工资/年
  c_sal_per_working_year constant number := 50;

end pkg_law_cons;
/
create or replace package body pkg_law_cons is
-- author  : sunyf
-- created : 2014/11/27 15:31:32
-- purpose : 常量定义
end pkg_law_cons;
/
