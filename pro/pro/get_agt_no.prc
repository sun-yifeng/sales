create or replace procedure get_agt_no(oagtcde  in out channel_main.channel_code%type,
                                       sdpt     channel_main.dept_code%type,
                                       iagtcls  channel_main.category%type,
                                       iagttype channel_main.property%type) is
  v_sequence varchar2(6);
  v_dptcde   varchar2(2);
  v_agtcls   varchar2(10);
  v_agttype  varchar2(15);
begin
  v_agtcls  := ltrim(rtrim(iagtcls));
  v_agttype := ltrim(rtrim(iagttype));
  v_dptcde  := f_get_dpt_code(rtrim(sdpt), 2);
  --todo:上线时序列脚本需要将初始序列号调整为与核心一致，并加上核心drop脚本
  select agentseq.nextval into v_sequence from dual;
  if length(v_agttype) > 0 then
    oagtcde := v_dptcde || substr(v_agttype, 6) ||
               f_fill_zero(v_sequence, 6, 0);

  else
    oagtcde := v_dptcde || substr(v_agtcls, 4) ||
               f_fill_zero(v_sequence, 6, 0);
  end if;
end;
/

