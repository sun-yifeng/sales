select t.c_dept_cde "分公司",
       t.c_inter_cde "机构代码",
       t.c_ply_no "保单号",
       t.endorse_no "批单号",
       t.c_prod_no "产品代码",
       t.c_vhl_name "车型",
       t.c_cha_nme "渠道名称",
       t.c_cmpny_agt_cde "渠道代码",
       t.c_busi_oria "业务来源",
       t.c_busi_line "业务线",
       t.c_sls_cde "业务员mis",
       t.c_sls_per "业务归属mis",
       t.c_sls_cde1 "业务员xszc",
       pkg_law_belong.f_ply_group(t.c_dept_cde,
                                   substr(t.c_sls_cde1, 1, 9),
                                   t.sign_date) "团队名称(XSZC当月累计)",
       t.endorse_no "批单号",
       t.n_prem_got "实收保费（不含税）",
       nvl(t.n_tax, 0) "增值税",
       (t.n_prem_got + nvl(t.n_tax, 0)) "实收保费（含税）",
       nvl(t.n_rate_vehl, 1) "车型系数",
       nvl(t.n_rate_prod, 1) "产品系数",
       nvl(t.n_rate_chan, 1) "渠道系数",
       nvl(t.n_rate_orig, 1) "业务来源系数",
       t.n_prem_stan "标准保费（含税）",
       to_char(t.t_insrnc_bgn_tm,'yyyy-mm-dd') "保险起期",
       to_char(t.t_pay_tm,'yyyy-mm-dd') "实收日期",
       to_char(t.sign_date,'yyyy-mm-dd') "签单日期",
       to_char(t.t_udr_date,'yyyy-mm-dd') "核保日期"
  from t_law_mis_got_prm t
 where 1 = 1
   and t.c_dept_cde = '10'
      --and t.c_busi_line in ('925004','925005')
   and ((t.t_pay_tm >= date '2016-12-01' and t.t_pay_tm < date '2017-01-01' and t.t_insrnc_bgn_tm < date '2017-01-01') or
        (t.t_pay_tm <  date '2016-12-01' and t.t_insrnc_bgn_tm >= date '2016-12-01' and t.t_insrnc_bgn_tm < date '2017-01-01'))
 order by t.c_inter_cde, t.c_sls_cde, t.c_ply_no