select t.c_dept_cde  "分公司",
       t.c_inter_cde "机构代码",
       t.c_ply_no    "保单号",
       t.endorse_no  "批单号",
       t.c_prod_no   "产品代码",
       t.C_VHL_NAME  "车型",
       t.C_CHA_NME   "渠道名称",
       t.C_CMPNY_AGT_CDE "渠道代码",
       t.C_BUSI_ORIA  "业务来源",
       t.C_BUSI_LINE  "业务线",
       t.c_sls_cde   "业务员MIS",
       t.c_sls_per   "业务归属MIS",
       t.c_sls_cde1  "业务员XSZC",
       t.ENDORSE_NO  "批单号",
       t.N_PREM_GOT  "实收保费（不含税）",
       nvl(t.N_TAX,0)       "增值税",
       (t.N_PREM_GOT+nvl(t.N_TAX,0)) "实收保费（含税）",
       nvl(t.N_RATE_VEHL,1) "车型系数",
       nvl(t.N_RATE_PROD,1) "产品系数",
       nvl(t.N_RATE_CHAN,1) "渠道系数",
       nvl(t.N_RATE_ORIG,1) "业务来源系数",
       t.N_PREM_STAN "标准保费（含税）",
       t.t_insrnc_bgn_tm "保险起期",
       t.t_pay_tm "实收日期",
       t.sign_date "签单日期",
       t.t_udr_date "核保日期"
  from T_LAW_MIS_GOT_PRM t
  where 1=1
    and t.c_dept_cde = '30'
    --and t.c_busi_line in ('925004','925005')
    and (
       (t.t_pay_tm >= date'2017-01-01' and t.t_pay_tm < date'2017-3-01' and  t.t_insrnc_bgn_tm < date'2017-06-01')
     or
       (t.t_pay_tm < date'2017-01-01' and t.t_insrnc_bgn_tm >= date'2017-01-01' and t.t_insrnc_bgn_tm < date'2017-06-01')
      )
   order by t.c_inter_cde,t.c_sls_cde,t.c_ply_no;