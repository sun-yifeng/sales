create or replace package pkg_law_cons is

  -- author  : sunyf
  -- created : 2014/11/27 15:31:32
  -- purpose : ��������

  /*
  ��־����
  c_log_debug constant number := -1;
  c_log_info  constant number := 0;
  c_log_warn  constant number := 1;
  c_log_error constant number := 2;
  */

  -- public constant declarations
  c_user_name constant varchar2(10) := 'admin';
  --ÿһ��������һtaskid,�������־���Ҵ����������
  c_taks_id_1   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_2   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_3   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_4   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_5   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_6   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  c_taks_id_7   constant varchar2(50) := to_char(sysdate, 'yyyymmddhh24miss');
  --˾�乤��/��
  c_sal_per_working_year constant number := 50;

end pkg_law_cons;
/
create or replace package body pkg_law_cons is
-- author  : sunyf
-- created : 2014/11/27 15:31:32
-- purpose : ��������
end pkg_law_cons;
/
