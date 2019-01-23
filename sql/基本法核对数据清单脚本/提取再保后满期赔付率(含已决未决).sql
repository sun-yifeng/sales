select t.c_dept_cde "分公司",
       t.c_ply_no "保单号",
       t.c_sls_cde "业务员MIS",
       t.c_sls_per   "业务归属MIS",
       t.c_sls_cde1  "业务员XSZC",
       t.t_insrnc_bgn_tm "保险起期",
       t.t_insrnc_end_tm "保险止期",
       t.wj_ri "未决金额",
       t.yj_ri "已决金额",
       t.manqi*nvl(t.rate,1) "再保后满期净保费",
       t.t_udr_date "核保日期"
  from t_law_mis_pro_clm t
 where t.c_dept_cde = '20'
   and t.t_insrnc_bgn_tm >= date '2015-06-01' --向前滚动12月
   --and t.t_insrnc_bgn_tm >= date '2016-01-01' --只算当年（不向前滚动12月）
   and t.t_insrnc_bgn_tm < date '2016-06-01'
   order by t.c_ply_no