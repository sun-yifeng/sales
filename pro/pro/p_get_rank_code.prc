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
  -- Purpose : ְ������=���Ŵ��루2λ��+ҵ���ߣ�6λ��+ ְ�����ࣨ1λ��+��Ӧ�ܹ�˾ְ����2λ��+β����4λ��
  -- Note    : β��ǰ����κ�һ���ַ����仯��β������ˮ������ͷ��ʼ����

  v_length := 4; --β���ĳ���

  begin

    if (i_dept_code is null or i_rank_type is null or i_line_code is null or i_map_rank is null) then
      o_rank_code := '�ֹ�˾,ְ������,ҵ����,��Ӧ�ܹ�˾ְ������Ϊ�գ�';
      return;
    end if;

    --ְ������
    v_prefix    := i_dept_code || i_line_code || i_rank_type || i_map_rank;
    v_suffix    := lpad(1, v_length, 0);
    o_rank_code := v_prefix || v_suffix;

    --ְ�������Ѿ�������ȡ��һ������
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

