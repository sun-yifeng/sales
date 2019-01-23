create or replace package pkg_law_validate is

  -- author  : sunyf
  -- created : 2016/5/17 16:19:23
  -- purpose : 检查公式是否配置正确

  type type_split_str is table of varchar2(32767);

  c_regexp_replace constant varchar(200) := '[+,-,*,/,(,),<,>,<>,!=,=,>=,<=]|[-]|(AND)|(OR)|(CEIL)|(ROUND)|(TRUNC)|(FLOOR)';

  function f_split_str(i_str varchar2) return type_split_str
    pipelined;

  function f_formula(i_version_id char) return varchar;

  function f_condition(i_version_id char) return varchar;

  function f_rules(i_version_id char) return varchar;

  function f_validate(i_version_id char, i_str varchar) return varchar;

  function f_main(i_version_id varchar2) return varchar;

end pkg_law_validate;
/
create or replace package body pkg_law_validate is

  -- 字符串转换成表（表函数）
  function f_split_str(i_str varchar2) return type_split_str
    pipelined is
    --管道函数
    v_index      integer;
    v_str_prefix varchar2(500);
    v_tmp_prefix varchar2(500);
    v_str_suffix varchar2(32767) := i_str;
  begin
    loop
      v_index := nvl(instr(v_str_suffix, ','), 0);
      exit when v_index = 0;
      v_str_prefix := substr(v_str_suffix, 1, v_index - 1);
      v_str_suffix := substr(v_str_suffix, v_index + 1);
      --去掉数字
      v_tmp_prefix := regexp_replace(trim(v_str_prefix), '^[0-9.]+', '');
      --为空忽略
      if (v_tmp_prefix is null) then
        continue;
      end if;
      pipe row(v_tmp_prefix);
    end loop;
    --去掉数字
    v_str_suffix := regexp_replace(v_str_suffix, '^[0-9.]+', '');
    if (v_str_suffix is not null) then
      pipe row(trim(v_str_suffix));
    end if;
    return;
  end f_split_str;

  --将公式内容转为字符串
  function f_formula(i_version_id char) return varchar is
    result varchar(32767);
  begin
    select wm_concat(regexp_replace(upper(t.ret), c_regexp_replace, ','))
      into result
      from t_law_calc t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id;
    return(result);
  end f_formula;

  --将公式条件转为字符串
  function f_condition(i_version_id char) return varchar is
    result varchar(32767);
  begin
    select wm_concat(regexp_replace(upper(t.index_cond), c_regexp_replace, ','))
      into result
      from t_law_calc t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id;
    return(result);
  end f_condition;

  --将考核规则转为字符串
  function f_rules(i_version_id char) return varchar is
    result varchar(32767);
  begin
    select wm_concat(regexp_replace(upper(t.calc_cond), c_regexp_replace, ','))
      into result
      from t_law_calc_review t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id;
    return(result);
  end f_rules;

  function f_validate(i_version_id char, i_str varchar) return varchar is
    v_result varchar(32767);
  begin
    select wm_concat(column_value)
      into v_result
      from table(f_split_str(i_str)) t1
     where column_value not in (select t.item_code
                                  from t_law_factor_sys t
                                 where t.valid_ind = '1'
                                   and t.item_status = '1'
                                   and t.version_id = i_version_id
                                union
                                select t.item_code
                                  from t_law_factor_imp t
                                 where t.valid_ind = '1'
                                   and t.item_status = '1'
                                   and t.version_id = i_version_id
                                union
                                select t.item_code
                                  from t_law_factor_exa t
                                 where t.valid_ind = '1'
                                   and t.item_status = '1'
                                   and t.version_id = i_version_id
                                union
                                select t.index_code
                                  from t_law_calc t
                                 where 1 = 1
                                   and t.valid_ind = '1'
                                   and t.item_status = '1'
                                   and t.version_id = i_version_id);
    return v_result;
  end f_validate;

  function f_main(i_version_id varchar2) return varchar is
    v_str_1    varchar(32767);
    v_str_2    varchar(32767);
    v_str_3    varchar(32767);
    v_result_1 varchar(1000);
    v_result_2 varchar(1000);
    v_result_3 varchar(1000);
    v_result   varchar(2000);
  begin
    v_str_1    := f_formula(i_version_id);
    v_str_2    := f_condition(i_version_id);
    v_str_3    := f_rules(i_version_id);
    v_result_1 := f_validate(i_version_id, v_str_1);
    v_result_2 := f_validate(i_version_id, v_str_2);
    v_result_3 := f_validate(i_version_id, v_str_3);
    if (v_result_1 is not null or v_result_2 is not null or v_result_3 is not null) then
      v_result := v_result_1 || ',' || v_result_2 || ',' || v_result_3;
    else
      v_result := null;
    end if;
    return v_result;
  end f_main;

end pkg_law_validate;
/
