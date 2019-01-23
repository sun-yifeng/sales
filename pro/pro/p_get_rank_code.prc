CREATE OR REPLACE PROCEDURE "P_GET_RANK_CODE"(i_dept_code in char,
                                              i_line_code in char,
                                              i_rank_type in char,
                                              i_map_rank  in char,
                                              o_rank_code out varchar2) is
  v_count_1 number(10);
  v_length  number(10);
  v_prefix  varchar2(20);
  v_suffix  varchar2(10);
begin

  -- Author  : sunyf
  -- Created : 2014-12-25
  -- Purpose : 职级代码=部门代码（2位）+业务线（6位）+ 职级分类（1位）+对应总公司职级（2位）+尾数（4位）
  -- Note    : 尾数前面的任何一部分发生变化，尾数（流水）将从头开始计算

  v_length := 4; --尾数的长度

  begin

    if (i_dept_code is null or i_rank_type is null or i_line_code is null or i_map_rank is null) then
      o_rank_code := '分公司,职级分类,业务线,对应总公司职级不能为空！';
      return;
    end if;

    --职级代码
    v_prefix    := i_dept_code || i_line_code || i_rank_type || i_map_rank;
    v_suffix    := lpad(1, v_length, 0);
    o_rank_code := v_prefix || v_suffix;

    --职级代码已经存在则取下一个代码
    while true loop
      --
      select count(1)
        into v_count_1
        from t_law_rank_def t
       where 1 = 1
         and t.valid_ind = '1'
         and t.rank_code = o_rank_code;
      --
      if (v_count_1 >= 1) then
        v_suffix    := lpad(v_suffix + 1, v_length, 0);
        o_rank_code := v_prefix || v_suffix;
      else
        exit;
      end if;

    end loop;

  end;

end p_get_rank_code;
/

