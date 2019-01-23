select t6.DEPT_CODE || t6.DEPT_SIMPLE_NAME as "分公司",
       
       case
         when t1.manager_flag = '0' then
          '客户经理'
         when t1.manager_flag = '1' then
          '团队经理'
       end as "人员类别",
       
       t2.EMPLOY_CODE as "工号",
       t2.salesman_cname as "姓名",
       t2.SALESMAN_CODE as "HR账号",
       decode(t2.TRYTOU, 1, '是', 0, '否', '其他') as "试用期",
       to_char(t2.contract_Date, 'yyyy-mm-dd') as "入司时间",
       to_char(t2.entry_date, 'yyyy-mm-dd') as "入职时间",
       t3.rank_name as "当前职级",
       to_char(t2.front_date, 'yyyy-mm-dd') as "考核时间",
       to_char(t10.found_date, 'yyyy-mm-dd') as "团队成立时间",
       to_char(t13.entry_date, 'yyyy-mm-dd') as "加入团队时间",
       to_char(t13.leave_date, 'yyyy-mm-dd') as "离开团队时间",
       decode(t11.review_result,'S','升级','J','降级','W','维持','T','淘汰') "考核结果",
       t12.rank_name as "推荐职级",
       t9.group_name as "所属团队", 
       case
         when t1.manager_flag = '0' then
          t8.a001
         when t1.manager_flag = '1' then
          t8.a101
       end as "考核在职时间（月）",
       
       
       t3.NORM_PREMIUM as "考核保费任务（万元）",
       t3.base_salary  as "职级固定工资标准",
       t3.cacl_salary  as "职级绩效工资标准",
       
       t8.a102 as "团队长月度津贴计提基数(实收)",
       t8.a103 as "团队长月度津贴计提基数(标保)",
       case
         when t1.manager_flag = '0' then
          t8.a004
         when t1.manager_flag = '1' then
          t8.a104
       end as "当年累计实收",
       
       case
         when t1.manager_flag = '0' then
          t8.a005
         when t1.manager_flag = '1' then
          t8.a105
       end as "当年累计标保",

       case
         when t1.manager_flag = '0' then
          (t8.a005 / t8.a001) * 12
         when t1.manager_flag = '1' then
          (t8.a105 / t8.a101) * 12
       end as "年化标保",
       
       case
         when t1.manager_flag = '0' then
          (t8.a005 / t8.a001) * 12 / (t3.NORM_PREMIUM * 10000)
         when t1.manager_flag = '1' then
          (t8.a105 / t8.a101) * 12 / (t3.NORM_PREMIUM * 10000)
       end as "年化标保达成率",
       t8.d002 as "累计标准保费达成率(D002)",
       t8.D005 as "当年度再保后满期保费赔付率",
       case
         when t1.manager_flag = '0' then
          t8.a011
         when t1.manager_flag = '1' then
          t8.a109
       end as "本年度已决未决赔款",
   
       case
         when t1.manager_flag = '0' then
          t8.a012
         when t1.manager_flag = '1' then
          t8.a110
       end as "本年度满期保费",
       
       case
         when t1.manager_flag = '0' then
          t8.A014
         when t1.manager_flag = '1' then
          t8.A113
       end as "滚动12个月的已决未决",
       
       case
         when t1.manager_flag = '0' then
          t8.A015
         when t1.manager_flag = '1' then
          t8.A114
       end as "滚动12个月满期保费",
    
       case
         when t1.manager_flag = '0' and t8.A015 = 0 then
          0
         when t1.manager_flag = '0' and t8.a011 <> 0 then
          round(t8.A014/t8.A015,6)
         when t1.manager_flag = '1' and t8.A114 = 0 then
          0
         when t1.manager_flag = '1' and t8.A114 <> 0 then
          round(t8.A113/A114,6)
       end as "滚动12个月满期赔付率",
       
       t9.score as "考核得分",
       
       t5.salary_fixed as "考核固定工资",
       t5.salary_perform as "考核绩效工资",
       t5.salary_base as "考核基本工资",
       t5.salary_total as "考核合计",
       '' as "人员基本信息确认",    
       '' as "累计实收保费确认", 
       '' as "累计标准保费确认",
       '' as "已决未决确认", 
       '' as "满期保费确认",
       '' as "得分确认",
       '' as "职级确认",
       '' as "薪酬确认"
  from t_law_salesman t1
  left join salesman t2
    on t1.salesman_code = t2.salesman_code
   and t2.valid_ind = '1'
  left join t_law_rank_def t3
    on t3.rank_code = t1.rank_code
   and t3.valid_ind = '1'
   and t3.version_id = t1.version_id
  left join review_rank t4
    on t4.salesman_code = t1.salesman_code
    and t4.calc_month = t1.calc_month
    and t4.valid_ind = '1' 
  left join t_law_rank_def t12
    on t12.rank_code = t4.recommend_rank
  left join review_salary t5
    on t5.salesman_code = t1.salesman_code
   and t5.calc_month = t1.calc_month
   and t5.valid_ind = '1'
  left join department t6
    on t6.dept_code = t1.dept_code
   and t6.valid_ind = '1'
  left join t_law_calc_extra t8
    on t1.salesman_code = t8.sales_code
   and t8.calc_month = t1.calc_month
  left join review_score t9
    on t9.salesman_code = t1.salesman_code
   and t9.calc_month = t1.calc_month
  left join GROUP_MAIN t10
    on t2.GROUP_CODE = t10.GROUP_CODE
   and t10.VALID_IND = '1'
  left join review_rank t11
    on t11.salesman_code = t1.salesman_code
    and t11.calc_month = t1.calc_month
  left join (select t11.sales_code sales_code,max(t11.entry_date) entry_date,max(t11.leave_date) leave_date 
             from group_menber t11 group by t11.sales_code) t13
    on t13.sales_code = t1.salesman_code
 where 1 = 1
   and t1.calc_month = '201609'
   and t1.dept_code = '26'
 order by t1.dept_code, t1.manager_flag, t2.SALESMAN_CODE;