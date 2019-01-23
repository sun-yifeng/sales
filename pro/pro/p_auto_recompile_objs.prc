create or replace procedure p_auto_recompile_objs as
  cursor objects_list is
    select object_name, object_type
      from user_objects
     where status = upper('INVALID');
begin
  for v_object in objects_list loop
    --proc
    if v_object.object_type = upper('PROCEDURE') then
      execute immediate 'alter procedure ' || v_object.object_name || ' compile';
    --func
    elsif v_object.object_type = upper('FUNCTION') then
      execute immediate 'alter function ' || v_object.object_name || ' compile';
    --view
    elsif v_object.object_type = upper('VIEW') then
      execute immediate 'alter view ' || v_object.object_name || ' compile';
    --mate
    elsif v_object.object_type = upper('MATERIALIZED VIEW') then
      execute immediate 'alter materialized view ' || v_object.object_name || ' compile';
    --pack
    elsif v_object.object_type = upper('PACKAGE') then
      execute immediate 'alter package ' || v_object.object_name || ' compile';
    --body
    elsif v_object.object_type = upper('PACKAGE BODY') then
      execute immediate 'alter package body ' || v_object.object_name || ' compile';
    end if;
  end loop;
end;
/

