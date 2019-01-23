create or replace package pkg_law_factor is

  -- Author  : ADMINISTRATOR
  -- Created : 2015/7/8 14:54:21
  -- Purpose : 计算因素

  --------------------------------------------个人系统因素开始---------------------------------------------
  --A001 在岗时间(个人)
  function a001(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A002 本月实收保费(个人)
  function a002(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A003 本月标准保费(个人)
  function a003(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A004 当年累计实收保费
  function a004(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A005 当年累计标准保费
  function a005(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A006 本年度标准保费计划
  function a006(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A007 月度固定工资标准
  function a007(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A008 月度绩效工资标准
  function a008(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A009 绩效工资暂发系数
  function a009(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A010 计提系数(团队成员)
  function a010(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A011 本年度已决未决赔款
  function a011(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A012 本年度满期保费
  function a012(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A013 本年度已决未决（含费用）（个人）
  function a013(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A014 滚动12个月的已决未决（个人）
  function a014(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A015 滚动12个月的满期保费（个人）
  function a015(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A016 本年度累计非车险标准保费（个人）
  function a016(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --本年度累计车险标准保费（个人）
  function a017(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A018 本年度累计财产险标准保费（个人）
  function a018(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A019 本年度累计人身险标准保费（个人）
  function a019(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A020 是否试用期
  function a020(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A021 考核所在月份
  function a021(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A022 本年度非车险已决未决赔款
  function a022(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A023 本年度非车险满期保费
  function a023(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A024 本季度累计标准保费
  function a024(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A025 本季度经过月数
  function a025(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A026 试用期员工工资系数
  function a026(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A027 区域薪酬系数
  function a027(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A028 地域标识
  function a028(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A029 是否启用司龄工资
  function a029(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A030 司龄工资总额
  function a030(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  --上季度考核得分              
  function A031(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  -- A032 (本年度累计交强险实收保费)
  function A032(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  -- A033 (本年度累计非车险实收保费)
  function A033(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  
  -- A034 （四川）去年已实收，起期在本年业务
  function A034(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  --A035 截止考核月份的累积直接业务标保             
  function A035(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;                
  --------------------------------------------个人系统因素结束---------------------------------------------

  --------------------------------------------团队系统因素开始---------------------------------------------
  --A101  团队本年度有效时间(团队)
  function a101(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A102  当月实收保费(团队)
  function a102(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A103 当月标准保费(团队)
  function a103(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A104 本年度累计实收保费(团队)
  function a104(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A105 本年度累计标准保费(团队)
  function a105(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A106 本年度标准保费计划(团队)
  function a106(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A107 团队长销售津贴(团队)
  function a107(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A108 绩效工资计提基数(团队)
  function a108(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A109 本年度已决未决赔款(团队)
  function a109(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A110 本年度满期保费(团队)
  function a110(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A111 本年度在岗时间(团队经理)
  function a111(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A112 本年度已决未决（含费用）（团队）
  function a112(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A113 滚动12个月的已决未决（团队）
  function a113(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A114  滚动12个月的满期保费（团队）
  function a114(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A115  本年度累计非车险标准保费（团队）
  function a115(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A116  本年度累计车险标准保费（团队）
  function a116(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A117  本年度累计财产险标准保费（团队）
  function a117(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A118  本年度累计人身险标准保费（团队）
  function a118(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A119  是否试用期
  function a119(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A120  本年度团队经理个人实际标准保费
  function a120(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A121  团队当月实收保费
  function a121(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A122  团队当月车险实收保费
  function a122(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A123  团队当月非车险实收保费
  function a123(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A124 已赚赔付率（含费用）
  function a124(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A125  考核所在月份
  function a125(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A126 团队长固定工资
  function a126(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A127 团队长绩效工资
  function a127(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A128  团队长个人标保要求
  function a128(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A129  月度固定工资标准（团队长按客户经理拿工资）
  function a129(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A130  月度绩效工资标准（团队长按客户经理拿工资）
  function a130(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A131 本年度非车险已决未决赔款
  function a131(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A132 本年度非车险满期保费
  function a132(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A133 本季度累计标准保费
  function a133(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A134 本季度经过月数
  function a134(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A135 试用期员工工资系数              
  function a135(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A136 是否按团队考核的四级机构经理1是0否              
  function a136(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A137 是否按客户经理考核              
  function a137(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A138 所在区域薪酬系数              
  function a138(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A139 是否启用司龄工资              
  function a139(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A140 司龄工资总额              
  function a140(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A141 按客户经理考核时的固定工资                              
  function A141(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A142 按客户经理考核时的绩效工资              
  function A142(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A143 地域标识              
  function a143(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A144 是否销售总监1是0否              
  function a144(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A145 销售总监补贴金额              
  function a145(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  --上季度考核得分              
  function A146(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A147 本年度累计交强险实收保费(团队)
  function A147(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
   --A148 本年度累计非车险实收保费(团队)
  function A148(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  --A149 （四川）去年已实收，起期在本年业务(团队)
  function A149(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  
  --A150 截止考核月份的累积直接业务标保(团队)
  function A150(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;               
  --------------------------------------------团队系统因素结束---------------------------------------------

  --------------------------------------------导入计算因素开始---------------------------------------------
  function bxxx(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char --
                ) return number;
  --------------------------------------------职级计算因素开始---------------------------------------------
  function cx01(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  function cx02(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  function cx03(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  --------------------------------------------职级计算因素完成---------------------------------------------

end pkg_law_factor;
/
create or replace package body pkg_law_factor is

  --------------------------------------------客户经理系统因素开始---------------------------------------------

  --A001 在岗时间(个人)
  function A001(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(6, 4);
    v_month_1    number(6, 4);
    v_month_2    number(6, 4);
    v_day_1      number;
    v_day_2      number;
    v_entry_date salesman.entry_date%type;
    v_func_name  varchar(30) := 'pkg_law_factor.a001';
    v_func_desc  varchar(100) := '在岗时间(个人)';
  begin
    /*
    见王聚国2016年6月20日 (周一) 13:29的邮件：
    关于今天上午（2016.6.20）讨论的“待解决问题”中的“关于分公司考核时间按天计算与系统按月计算的差异”，具体说明如下：
    经与您沟通，评估系统改动量与系统原有计算时间BUG（系统程序每月按31天计算）后，方案如下：
    在考核期内，本年度在岗时间A001（建议保留四位有效数字）
    按月计算，在岗时间为整月的数据直接记为 1。
    按月计算 ，在岗时间为非整月的数据，本月的在岗时间/本月总天数 。
    整月数据+非整月的数据=在岗时间（月份）
    举例：
    销售人员 甲   考核区间（2016.1.1-2016.5.31） 实际在岗区间（2016.1.15-2016.5.31）
    按月计算：整月的数据  2月 3月 4月 5月（共计4个月）   非整月数据 20116.1.15-2016.1.31   （31-15）/31=0.5161月
    故销售人员  甲  在岗时间 A001=4+0.5161=4.5161 （月）
     */
    --1、取业务员入司日期
    select nvl(t.front_date, trunc(i_end_date, 'yyyy'))
      into v_entry_date
      from salesman t
     where t.valid_ind = '1'
       and t.salesman_code = i_sale_code;
  
    --2、入司时间大于当年
    if (trunc(v_entry_date) <= trunc(i_end_date, 'yyyy')) then
      return to_number(to_char(i_end_date, 'mm'));
    end if;
  
    --3、入司时间小于当年
    -- 取月份整数
    select months_between(last_day(i_end_date) + 1,
                          last_day(v_entry_date) + 1)
      into v_month_1
      from dual;
    -- 取在职天数
    select to_char(v_entry_date, 'dd') into v_day_1 from dual;
    -- 取当月天数
    select to_char(last_day(v_entry_date), 'dd') into v_day_2 from dual;
    -- 取月份小数
    select ((v_day_2 - v_day_1 + 1) / v_day_2) into v_month_2 from dual;
    -- 在岗时间=月份整数+月份小数
    v_month := round(v_month_1 + v_month_2, 4);
    return v_month;
  
    --日志信息
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          '销售人员' || i_sale_code || ',在岗时间:' || v_month ||
                          ',考核时间:' || to_char(i_end_date, 'yyyy-mm-dd') ||
                          ',入司日期:' || to_char(v_entry_date, 'yyyy-mm-dd'),
                          '');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end;

  --A002 本月实收保费(个人)
  function A002(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a002';
    v_func_desc varchar2(100) := '本月实收保费(个人)';
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a002', --计算因素代码
                                     '1',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A002;

  --A003 本月标准保费(个人)
  function A003(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a003';
    v_func_desc varchar2(100) := '本月标准保费(个人)';
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a003', --计算因素代码
                                     '1',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A003;

  --A004 当年累计实收保费
  function A004(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a004';
    v_func_desc    varchar2(100) := '当年累计实收保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a004', --计算因素代码
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A004;

  --A005 当年累计标准保费
  function A005(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a005';
    v_func_desc    varchar2(100) := '当年累计标准保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a005', --计算因素代码
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A005;

  --A006 本年度标准保费计划
  function A006(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_plan_fee  t_law_rank_def.norm_premium%type;
    v_func_name varchar2(30) := 'pkg_law_factor.a006';
    v_func_desc varchar2(100) := '当年标准保费计划';
  begin
    begin
      select sum(t.norm_premium) * 10000
        into v_plan_fee
        from t_law_rank_def t
       where t.rank_code = i_rank_code
         and t.item_status = '1';
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              v_func_desc || ',销售人员' || i_sale_code ||
                              ',职级代码:' || i_rank_code,
                              sqlerrm);
        return - 1;
    end;
    return nvl(v_plan_fee, 0);
  end A006;

  --A007 月度固定工资标准
  function A007(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_base_salary   t_law_rank_def.base_salary%type;
    v_salesman_type salesman.salesman_type%type;
    v_func_name     varchar2(30) := 'pkg_law_factor.a007';
    v_func_desc     varchar2(100) := '月度绩效工资标准';
  begin
    select nvl(max(t.base_salary), 0)
      into v_base_salary
      from t_law_rank_def t
     where t.rank_code = i_rank_code
       and t.item_status = '1';
    return nvl(v_base_salary, 0);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A007;

  --A008 月度绩效工资标准
  function A008(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_calc_salary t_law_rank_def.cacl_salary%type;
    v_count_1     number;
    v_func_name   varchar2(30) := 'pkg_law_factor.a008';
    v_func_desc   varchar2(100) := '月度绩效工资标准';
  begin
    begin
      select t.cacl_salary
        into v_calc_salary
        from t_law_rank_def t
       where 1 = 1
         and t.rank_code = i_rank_code
         and t.cacl_salary is not null;
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              v_func_desc || ',销售人员' || i_sale_code ||
                              ',职级代码:' || i_rank_code,
                              sqlerrm);
        return - 1;
    end;
    return nvl(v_calc_salary, 0);
  
  end A008;

  --A009 TODO 此因素在页面上已剔除，暂时没用
  function A009(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_calc_month  varchar2(2);
    v_salary_rate t_law_salary_rate.salary_rate%type;
    v_func_name   varchar2(30) := 'pkg_law_factor.a009';
  begin
    -- TODO:
    return 1;
  end A009;

  --A010 计提系数(团队成员)
  function A010(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_base_rate t_law_rank_def.base_rate%type;
    v_func_name varchar2(30) := 'pkg_law_factor.a010';
  begin
  
    --计提系数(团队成员),不是计提基数！
  
    select count(t2.base_rate)
      into v_base_rate
      from salesman t1, t_law_rank_def t2
     where 1 = 1
       and t1.sale_rank = t2.rank_code
       and t1.salesman_code = i_sale_code;
    --debug
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          '销售人员' || i_sale_code || ',计提系数:' || v_base_rate,
                          '');
  
    return v_base_rate;
  
  end A010;

  --A011 本年度已决未决赔款
  function A011(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      v_year_bgn_day, --统计区间开始
                                      v_year_end_day, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '0', --0个人，1团队
                                      'a011' --计算因素代码
                                      );
  end A011;

  --A012 本年度满期保费
  function A012(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    --本年度满期保费(个人)
    return pkg_law_adapt.f_calc_prof(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0个人，1团队
                                     'a012' --计算因素代码
                                     );
  end A012;

  --A013 本年度已决未决（含费用）（个人）
  function A013(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_got_fee      number := 0;
    v_func_name    varchar2(30) := 'pkg_law_factor.a013';
    v_year_bgn_day date := trunc(i_bgn_date, 'yyyy');
  begin
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      v_year_bgn_day, --统计区间开始
                                      i_end_date, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '0', --0个人，1团队
                                      'a013' --计算因素代码
                                      );
  end A013;

  --A014 滚动12个月的已决未决（个人）TODO:
  function A014(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_claim_fee t_law_mis_claim.n_fee%type;
    v_func_name varchar2(30) := 'pkg_law_factor.a014';
    p_end_date  date := i_end_date;
    p_bgn_date  date := trunc(add_months(i_bgn_date, -11), 'month');
  begin
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      p_bgn_date, --统计区间开始
                                      p_end_date, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '0', --0个人，1团队
                                      'a014' --计算因素代码
                                      );
  
  end A014;

  --A015 滚动12个月的满期保费（个人）TODO:
  function A015(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_profit_fee t_law_mis_profit.n_fee%type;
    v_func_name  varchar2(30) := 'pkg_law_factor.a015';
    p_bgn_date   date := trunc(add_months(i_bgn_date, -11), 'month');
    p_end_date   date := i_end_date;
  begin
    --再保后满期净保费
    return pkg_law_adapt.f_calc_prof(i_dept_code, --分公司代码
                                     p_bgn_date, --统计区间开始
                                     p_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0个人，1团队
                                     'a015' --计算因素代码
                                     );
  end A015;

  --A016 本年度累计非车险标准保费（个人）
  function A016(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a016', --计算因素代码
                                     '0',
                                     '1');
  end A016;

  --本年度累计车险标准保费（个人）TODO:
  function A017(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a017', --计算因素代码
                                     '0',
                                     '1');
  
  end A017;

  --A018 本年度累计财产险标准保费（个人）TODO:
  function A018(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a018', --计算因素代码
                                     '0',
                                     '1');
  
  end A018;

  --A019 本年度累计人身险标准保费（个人）TODO:
  function A019(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a019', --计算因素代码
                                     '0',
                                     '1');
  end A019;

  --A020 是否试用期
  function A020(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_try       number := 0;
    v_func_name varchar2(30) := 'pkg_law_factor.a014';
  begin
    begin
      select to_number(t.trytou)
        into v_try
        from salesman t
       where t.salesman_code = i_sale_code;
      --
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              '销售人员' || i_sale_code || ',职级代码:' ||
                              i_rank_code || ',取是否试用期出错',
                              sqlerrm);
        return - 1;
    end;
    return v_try;
  end A020;

  --A021 考核所在月份
  function A021(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a021';
    v_func_desc varchar2(100) := '取考核所在月份';
    month_value number;
  begin
    begin
      select to_char(add_months(sysdate, -1), 'mm')
        into month_value
        from dual;
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              v_func_desc || ',销售人员' || i_sale_code ||
                              ',职级代码:' || i_rank_code,
                              sqlerrm);
        return - 1;
    end;
    return month_value;
  end A021;

  --A022 本年度非车险已决未决赔款 TODO
  function A022(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      v_year_bgn_day, --统计区间开始
                                      v_year_end_day, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '0', --0个人，1团队
                                      'a022' --计算因素代码
                                      );
  end A022;

  --A023 本年度非车险满期保费
  function A023(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prof(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0个人，1团队
                                     'a023' --计算因素代码
                                     );
  end A023;

  --A024 本季度累计标准保费
  function A024(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a024';
    v_func_desc varchar2(100) := '本季度累计标准保费';
    v_got_fee   t_law_mis_got_prm.n_prem_stan%type;
    --
    v_year     varchar2(4);
    v_season   integer;
    v_bgn_date date;
    v_end_date date;
  begin
    select to_char(i_bgn_date, 'yyyy') into v_year from dual;
    select ceil(substr(to_char(i_bgn_date, 'yyyymm'), 5, 2) / 3)
      into v_season
      from dual;
    --
    if (v_season = 1) then
      v_bgn_date := to_date(v_year || '0101 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '0331 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    elsif (v_season = 2) then
      v_bgn_date := to_date(v_year || '0401 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '0630 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    elsif (v_season = 3) then
      v_bgn_date := to_date(v_year || '0701 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '0930 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    elsif (v_season = 4) then
      v_bgn_date := to_date(v_year || '1001 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '1231 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    end if;
    --
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_bgn_date, --统计区间开始
                                     v_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a024', --计算因素代码
                                     '1',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A024;

  --A025 本季度经过月数 

  function A025(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a025';
    v_func_desc varchar2(100) := '本季度经过月数';
    v_return    number := 0;
  begin
  
    v_return := to_number(to_char(add_months(sysdate, -1), 'mm'));
    v_return := v_return - trunc((v_return - 1) / 3) * 3;
    return 0;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A025;

  --A026 试用期员工工资系数
  function A026(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a026';
    v_func_desc varchar2(100) := '试用期员工工资系数';
    v_return    number; --试用期员工固定工资系数
  begin
    --获取试用期员工工资系数
    v_return := pkg_law_define.f_get_temp_emp_salary_rate_cfg(i_version_id);
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A026;

  --A027 区域薪酬系数
  function A027(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A027';
    v_func_desc varchar2(100) := '区域薪酬系数';
    v_return    number := 1;
  begin
    --获取区域薪酬系数
    select to_char(t3.area_rate, 'fm99999999999990.00')
      into v_return
      from salesman s,
           (select t2.dept_code, t2.area_rate
              from t_law_define t1, department t2
             where t1.dept_code = substr(t2.dept_code, 0, 2)
               and length(t2.dept_code) = 4
               and t1.version_id = i_version_id) t3
     where substr(s.dept_code, 0, 4) = t3.dept_code
       and s.salesman_code = i_sale_code;
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A027;

  --A028 地域标识 （1-同城，0-异地）
  function A028(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name   varchar2(30) := 'pkg_law_factor.a028';
    v_func_desc   varchar2(100) := '地域标识';
    v_is_area_cfg number := 1; --基本法配置中，是否开启地域标识
    v_return      number := 0;
    v_area_val    char(1) := '1';
  begin
    --获取是否开启地域标识    
    v_is_area_cfg := pkg_law_define.f_get_is_area_cfg(i_version_id);
    if v_is_area_cfg = '1' then
      select nvl(max(t.area), 1)
        into v_return
        from salesman t
       where t.salesman_code = i_sale_code;
    end if;
  
    if v_is_area_cfg = '0' then
      select v_area_val
        into v_return
        from salesman t
       where t.salesman_code = i_sale_code;
    end if;
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A028;

  --A029 是否启用司龄工资
  function A029(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a029';
    v_func_desc varchar2(100) := '是否启用司龄工资';
    v_return    number := 0;
  begin
    --获取是否启用司龄工资
    v_return := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A029;

  --A030 司龄工资总额
  function A030(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name          varchar2(30) := 'pkg_law_factor.a030';
    v_func_desc          varchar2(100) := '司龄工资总额';
    v_age_salary         number := 0;
    v_contract_date      date; --入司日期
    v_working_age_begin  date;
    v_working_age        number := 0; --司龄
    v_is_working_age_cfg varchar2(1) := '0';
  begin
    --获取是否启用司龄工资
    v_is_working_age_cfg := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    if v_is_working_age_cfg = '1' then
      --获取司龄工资计算起期
      v_working_age_begin := pkg_law_define.f_get_working_age_begin_cfg(i_version_id);
      --获取销售员的入职日期
      select t.contract_date
        into v_contract_date
        from salesman t
       where t.salesman_code = i_sale_code;
      if v_contract_date is not null then
        --判断入职日期是否在配置的司龄工资计算起期之后，若在之后，则按入职日期算
        if v_contract_date > v_working_age_begin then
          select round(months_between(sysdate, v_contract_date) / 12, 0)
            into v_working_age
            from dual;
        else
          select round(months_between(sysdate, v_working_age_begin) / 12, 0)
            into v_working_age
            from dual;
        end if;
        --计算司龄工资总额
        v_age_salary := nvl(v_working_age, 0) *
                        pkg_law_cons.c_sal_per_working_year;
        --更新销售员信息表中的司龄工资
        update salesman t
           set t.age_salary = v_age_salary
         where t.salesman_code = i_sale_code;
        commit;
      end if;
    end if;
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_age_salary;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_age_salary;
  end A030;

  function A031(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name     varchar2(30) := 'pkg_law_factor.a031';
    v_func_desc     varchar2(100) := '上季度考核得分';
    v_quarter_score number := 0;
    v_last_quarter  varchar2(6) := '';
    v_curr_month    varchar2(2) := '';
  begin
    select to_char(i_bgn_date, 'mm') into v_curr_month from dual;
    if (v_curr_month = '01' or v_curr_month = '02' or v_curr_month = '03') then
      select (to_char(add_months(i_bgn_date, -12), 'yyyy') || '12')
        into v_last_quarter
        from dual;
    elsif (v_curr_month = '04' or v_curr_month = '05' or
          v_curr_month = '06') then
      select (to_char(i_bgn_date, 'yyyy') || '03')
        into v_last_quarter
        from dual;
    elsif (v_curr_month = '07' or v_curr_month = '08' or
          v_curr_month = '09') then
      select (to_char(i_bgn_date, 'yyyy') || '06')
        into v_last_quarter
        from dual;
    elsif (v_curr_month = '10' or v_curr_month = '11' or
          v_curr_month = '12') then
      select (to_char(i_bgn_date, 'yyyy') || '09')
        into v_last_quarter
        from dual;
    end if;
    select nvl(max(t.score), 0)
      into v_quarter_score
      from review_score t
     where t.calc_month = v_last_quarter
       and t.salesman_code = i_sale_code
       and t.valid_ind = '1';
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_quarter_score;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_quarter_score;
    
  end A031;
  
  -- A032 (本年度累计交强险实收保费)
  function A032(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
                v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a032';
    v_func_desc    varchar2(100) := '本年度累计交强险实收保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a032', --计算因素代码
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
    
  end A032;
  
  -- A033 (本年度累计非车险实收保费)
  function A033(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
                v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a033';
    v_func_desc    varchar2(100) := '本年度累计非车险实收保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a033', --计算因素代码
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
    
  end A033;
  
  
  
  -- A034 （四川）去年已实收，起期在本年业务
  function A034(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
                v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a034';
    v_func_desc    varchar2(100) := '（四川）去年已实收，起期在本年业务';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a034', --计算因素代码
                                     '0',
                                     '2');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
    
  end A034;
  
  --A035 截止考核月份的累积直接业务标保
  function A035(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a035';
    v_func_desc    varchar2(100) := '截止考核月份的累积直接业务标保';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a035', --计算因素代码
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A035;
  --------------------------------------------客户经理系统因素结束---------------------------------------------

  --------------------------------------------团队经理系统因素开始---------------------------------------------

  --A101  团队本年度有效时间(团队)
  function A101(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(6, 4);
    v_month_1    number(6, 4);
    v_month_2    number(6, 4);
    v_day_1      number;
    v_day_2      number;
    v_found_date group_main.found_date%type;
    v_func_name  varchar2(30) := 'pkg_law_factor.a101';
    v_func_desc  varchar(100) := '在岗时间(个人)';
  begin
    --1、取团队成立日期
    select nvl(t.found_date, trunc(i_end_date, 'yyyy'))
      into v_found_date
      from group_main t
     where 1 = 1
       and t.valid_ind = '1'
       and t.group_code = i_group_code;
    --2、成立时间小于当年
    if (trunc(v_found_date) <= trunc(i_end_date, 'yyyy')) then
      return to_number(to_char(i_end_date, 'mm'));
    end if;
  
    --3、成立时间小于当年
    -- 取月份整数
    select months_between(last_day(i_end_date) + 1,
                          last_day(v_found_date) + 1)
      into v_month_1
      from dual;
    -- 取在职天数
    select to_char(v_found_date, 'dd') into v_day_1 from dual;
    -- 取当月天数
    select to_char(last_day(v_found_date), 'dd') into v_day_2 from dual;
    -- 取月份小数
    select ((v_day_2 - v_day_1 + 1) / v_day_2) into v_month_2 from dual;
    -- 在岗时间=月份整数+月份小数
    v_month := round(v_month_1 + v_month_2, 4);
    return v_month;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '销售人员' || i_sale_code || ',职级代码:' ||
                            i_rank_code,
                            sqlerrm);
      return - 1;
  end;

  --A102 团队长月度津贴计提基数(实收)
  function A102(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
  begin
    --取团队下所有的实收保费
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a102', --计算因素代码
                                     '1',
                                     '0');
  end A102;

  --A103 团队长月度津贴计提基数(标保)
  function A103(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a103', --计算因素代码
                                     '1',
                                     '0');
  end A103;

  --A104 本年度累计实收保费(团队)
  function A104(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a004';
    v_func_desc    varchar2(100) := '当年累计实收保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a104', --计算因素代码
                                     '0',
                                     '1');
  end A104;

  --A105 本年度累计标准保费(团队)
  function A105(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a004';
    v_func_desc    varchar2(100) := '当年累计标准保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a105', --计算因素代码
                                     '0',
                                     '1');
  end A105;

  --A106 本年度标准保费计划(团队)
  function A106(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_plan_fee  t_law_rank_def.norm_premium%type;
    v_func_name varchar2(30) := 'pkg_law_factor.a106';
  begin
    --取职级标准保费
    select sum(t.norm_premium) * 10000
      into v_plan_fee
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --
    return nvl(v_plan_fee, 0);
  end A106;

  --A107 团队长销售津贴(团队)
  function A107(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_return    number(16, 4) := -1;
    v_func_name varchar2(30) := 'pkg_law_factor.a107';
    v_func_desc varchar2(100) := '团队长销售津贴(团队)';
  begin
    begin
      select t.base_rate
        into v_return
        from t_law_rank_def t
       where t.rank_code = i_rank_code;
      return v_return;
    end;
    return v_return;
  end A107;

  --A108 绩效工资计提基数(团队当月) 暂时未使用
  function A108(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_got_fee   t_law_mis_got_prm.n_prem_calc%type;
    v_func_name varchar2(30) := 'pkg_law_factor.a108';
  begin
    return 1;
  end A108;

  --A109 本年度已决未决赔款(团队)
  function A109(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      v_year_bgn_day, --统计区间开始
                                      v_year_end_day, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '1', --0个人，1团队
                                      'a109' --计算因素代码
                                      );
  
  end A109;

  --A110 本年度满期保费(团队)
  function A110(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prof(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0个人，1团队
                                     'a110' --计算因素代码
                                     );
  end a110;

  --A111 本年度在岗时间(团队经理)
  function A111(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a111';
  begin
    --邮件：2015-07-03
    --B、在岗时间（团队经理）（跟团队的成立时间没有关系）
    --   字段含义：团队经理个人的在岗时间；
    --   统计规则：团队经理不是在本年入职的，按照今年已经过去的时间计算；客户经理本年入职的，按照今年的实际在岗时间计算；
    --             本处的团队经理入职，指的即为该人员入职做销售人员起，如该人2015.1.5入职做销售，2015.3.1做团队经理，则该处应从2015.1.5计算起；
    --   数值精度：时间按照截止统计日期的天数计算，单位折算成月后，保留两位小数；
  
    --入职时间
    select t.entry_date
      into v_entry_date
      from salesman t
     where t.salesman_code = i_sale_code;
    --入职时间只算当年
    if (v_entry_date < trunc(i_end_date, 'yyyy')) then
      v_entry_date := trunc(i_end_date, 'yyyy');
    end if;
  
    --计算在岗时间
    select round(months_between(i_end_date, v_entry_date), 2)
      into v_month
      from dual;
    --返回数据
    return nvl(v_month, 0);
  
  end A111;

  --A112 本年度已决未决（含费用）（团队）
  function A112(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      v_year_bgn_day, --统计区间开始
                                      v_year_end_day, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '1', --0个人，1团队
                                      'a112' --计算因素代码
                                      );
  
  end A112;

  --A113 滚动12个月的已决未决（团队）
  function A113(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a113';
    v_claim_fee  t_law_mis_claim.n_fee%type;
    p_end_date   date := i_end_date;
    p_bgn_date   date := trunc(add_months(i_bgn_date, -11), 'month');
  begin
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      p_bgn_date, --统计区间开始
                                      p_end_date, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '1', --0个人，1团队
                                      'a113' --计算因素代码
                                      );
  
  end A113;

  --A114  滚动12个月的满期保费（团队）
  function A114(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    p_end_date date := i_end_date;
    p_bgn_date date := trunc(add_months(i_bgn_date, -11), 'month');
  begin
    return pkg_law_adapt.f_calc_prof(i_dept_code, --分公司代码
                                     p_bgn_date, --统计区间开始
                                     p_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0个人，1团队
                                     'a114' --计算因素代码
                                     );
  
  end A114;

  --A115  本年度累计非车险标准保费（团队）
  function A115(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a115', --计算因素代码
                                     '0',
                                     '1');
  
  end A115;

  --A116  本年度累计车险标准保费（团队）
  function A116(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a116', --计算因素代码
                                     '0',
                                     '1');
  
  end A116;

  --A117  本年度累计财产险标准保费（团队）
  function A117(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a117', --计算因素代码
                                     '0',
                                     '1');
  end A117;

  --A118  本年度累计人身险标准保费（团队）
  function A118(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a118', --计算因素代码
                                     '0',
                                     '1');
  
  end A118;

  --A119  是否试用期
  function A119(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a119';
    v_try        number;
  begin
  
    select to_number(t.trytou)
      into v_try
      from salesman t
     where t.salesman_code = i_sale_code;
    return v_try;
  
  end A119;

  --A120  本年度团队经理个人实际标准保费
  function A120(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a004';
    v_func_desc    varchar2(100) := '本年度团队经理个人实际标准保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '0', --0个人，1团队
                                     'a120', --计算因素代码
                                     '0',
                                     '1');
  
  end A120;

  --A121  团队当月实收保费
  function A121(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a121', --计算因素代码
                                     '1',
                                     '1');
  
  end A121;

  --A122  团队当月车险实收保费
  function A122(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a122', --计算因素代码
                                     '1',
                                     '1');
  
  end A122;

  --A123  团队当月非车险实收保费
  function A123(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     i_bgn_date, --统计区间开始
                                     i_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a123', --计算因素代码
                                     '1',
                                     '1');
  
  end A123;

  --A124 已赚赔付率（含费用）TODO
  function A124(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a124';
  begin
    --TODO 
    return 0;
  
  end A124;

  --A125  考核所在月份
  function A125(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a125';
    month_value  number;
  begin
    --
    select to_number(to_char(i_bgn_date, 'mm')) into month_value from dual;
    return month_value;
  
  end A125;

  --A126 团队长固定工资
  function A126(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_return    number(16, 4) := -1;
    v_func_name varchar2(30) := 'pkg_law_factor.a126';
    v_func_desc varchar2(100) := '团队长固定工资';
  begin
    begin
      select t.base_salary
        into v_return
        from t_law_rank_def t
       where t.rank_code = i_rank_code;
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              v_func_desc || ',销售人员' || i_sale_code ||
                              ',职级代码:' || i_rank_code,
                              sqlerrm);
        return v_return;
    end;
    return v_return;
  end A126;

  --A127 团队长绩效工资
  function A127(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_return    number(16, 4) := -1;
    v_func_name varchar2(30) := 'pkg_law_factor.a127';
    v_func_desc varchar2(100) := '团队长绩效工资';
  begin
    begin
      select t.cacl_salary
        into v_return
        from t_law_rank_def t
       where t.rank_code = i_rank_code;
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              v_func_desc || ',销售人员' || i_sale_code ||
                              ',职级代码:' || i_rank_code,
                              sqlerrm);
        return v_return;
    end;
    return v_return;
  end A127;

  --A128  团队长个人标保要求 TODO
  function A128(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a128';
    v_return     number(12, 4) := 0;
  begin
  
    select t.personal_requirements
      into v_return
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    return v_return;
  
  end A128;

  --A129  月度固定工资标准（团队长按客户经理拿工资） TODO
  function A129(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a129';
    v_return    integer := 0;
  begin
    select count(1) into v_return
      from salesman t
      left join group_main t1
        on t.group_code = t1.group_code
     where t.status = '1'
       and t.dept_code like i_dept_code || '%'
       and t1.group_type = '1'
       and t.salesman_flag = '1'
       and t.group_code = i_group_code
     group by t.group_code, t1.group_name;
  
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '团队平均人数:' || i_sale_code,
                            '');
      return 1; --做分母用不能返回位0
  end A129;

  --A130  月度绩效工资标准（团队长按客户经理拿工资） TODO
  function A130(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a130';
    v_return     number(12, 4) := 0;
  begin
  
    select t.monthly_performance_standard
      into v_return
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    return v_return;
  
  end A130;

  --A131 本年度非车险已决未决赔款
  function A131(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_claim(i_dept_code, --分公司代码
                                      v_year_bgn_day, --统计区间开始
                                      v_year_end_day, --统计区间结束
                                      i_sale_code, --业务员代码
                                      i_user_name, --操作人代码
                                      i_task_id, --任务id
                                      '1', --0个人，1团队
                                      'a131' --计算因素代码
                                      );
  
  end A131;

  --A132 本年度非车险满期保费
  function A132(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prof(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0个人，1团队
                                     'a132' --计算因素代码
                                     );
  end A132;

  --A133 本季度累计标准保费
  function A133(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a130';
    v_return     number(12, 4) := 0;
    v_got_fee    t_law_mis_got_prm.n_prem_stan%type;
    --
    v_year     varchar2(4);
    v_season   integer;
    v_bgn_date date;
    v_end_date date;
  begin
    --
    select to_char(sysdate, 'yyyy') into v_year from dual;
    select ceil(substr(to_char(sysdate, 'yyyymm'), 5, 2) / 3)
      into v_season
      from dual;
    --
    if (v_season = 1) then
      v_bgn_date := to_date(v_year || '0101 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '0331 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    elsif (v_season = 2) then
      v_bgn_date := to_date(v_year || '0401 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '0630 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    elsif (v_season = 3) then
      v_bgn_date := to_date(v_year || '0701 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '0930 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    elsif (v_season = 4) then
      v_bgn_date := to_date(v_year || '1001 00:00:00',
                            'yyyymmdd hh24:mi:ss');
      v_end_date := to_date(v_year || '1231 23:59:59',
                            'yyyymmdd hh24:mi:ss');
    end if;
  
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_bgn_date, --统计区间开始
                                     v_end_date, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a133', --计算因素代码
                                     '1',
                                     '1');
  end A133;

  --A134 本季度经过月数
  function A134(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_month      number(4, 2);
    v_found_date date;
    v_entry_date date;
    v_func_name  varchar2(30) := 'pkg_law_factor.a130';
    v_return     number := 0;
  begin
  
    v_return := to_number(to_char(add_months(sysdate, -1), 'mm'));
    v_return := v_return - trunc((v_return - 1) / 3) * 3;
  
    return v_return;
  end A134;

  --A135 试用期员工工资系数
  function A135(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.a026';
    v_func_desc varchar2(100) := '试用期员工工资系数';
    v_return    number := 0;
  begin
    select nvl(max(t.temp_emp_salary_rate), 0)
      into v_return
      from t_law_define_config t
     where exists (select 1
              from t_law_define t2
             where t2.dept_code = i_dept_code
               and t2.version_status = '1'
               and exists (select 1
                      from t_law_salesman s
                     where s.salesman_code = i_sale_code
                       and s.calc_month =
                           to_char(i_bgn_date, 'yyyymm')
                       and s.version_id = t2.version_id)
               and t.version_id = t2.version_id);
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A135;

  --A136 是否按团队考核的四级机构经理 1是0否
  function A136(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name  varchar2(30) := 'pkg_law_factor.A136';
    v_func_desc  varchar2(100) := '是否按团队考核的四级机构经理1是0否';
    v_return     number := 0;
    v_group_type varchar2(5); --团队类型,1真实团队,2虚拟团队,3四级机构（按团队考核）
  begin
    select max(t.group_type)
      into v_group_type
      from group_main t
     where t.group_code = i_group_code;
  
    if v_group_type = '3' then
      v_return := 1;
    end if;
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A136;

  --A137 是否按客户经理考核
  function A137(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name    varchar2(30) := 'pkg_law_factor.A137';
    v_func_desc    varchar2(100) := '是否按客户经理考核';
    v_version_flag char(1);
    v_manager_flag char(1);
    v_rank_two     char(50);
  begin
    --取基本法里面的团队经理按客户经理考核开关
    select t.is_client_manager_check
      into v_version_flag
      from t_law_define_config t
     where t.valid_ind = '1'
       and t.version_id = i_version_id;
    if (v_version_flag <> '1') then
      return 0;
    end if;
    --取销售人员的职级类型
    select t.manager_flag
      into v_manager_flag
      from t_law_rank_def t
     where t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.rank_code = i_rank_code;
    if (v_manager_flag <> '1') then
      return 0;
    end if;
    --取销售人员的职级代码
    select t.sale_rank_two
      into v_rank_two
      from salesman t
     where t.valid_ind = '1'
       and t.salesman_code = i_sale_code;
    --非团队经理并且无两个职级的
    if (v_manager_flag <> '1' or v_rank_two is null or
       i_rank_code = v_rank_two) then
      return 0;
    elsif (v_version_flag = '1' and v_manager_flag = '1' and
          i_rank_code <> v_rank_two) then
      return 1;
    end if;
    --
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A137;

  --A138 所在区域薪酬系数
  function A138(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A138';
    v_func_desc varchar2(100) := '所在区域薪酬系数';
    v_return    number := 1;
  begin
    --获取区域薪酬系数
    select to_char(t3.area_rate, 'fm99999999999990.00')
      into v_return
      from salesman s,
           (select t2.dept_code, t2.area_rate
              from t_law_define t1, department t2
             where t1.dept_code = substr(t2.dept_code, 0, 2)
               and length(t2.dept_code) = 4
               and t1.version_id = i_version_id) t3
     where substr(s.dept_code, 0, 4) = t3.dept_code
       and s.salesman_code = i_sale_code;
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A138;

  --A139 是否启用司龄工资
  function A139(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A139';
    v_func_desc varchar2(100) := '是否启用司龄工资';
    v_return    number := 0;
  begin
    --获取是否启用司龄工资  
    v_return := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A139;

  --A140 司龄工资总额
  function A140(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name          varchar2(30) := 'pkg_law_factor.A140';
    v_func_desc          varchar2(100) := '司龄工资总额';
    v_age_salary         number := 0;
    v_contract_date      date; --入司日期
    v_working_age_begin  date;
    v_working_age        number := 0; --司龄
    v_is_working_age_cfg varchar2(1) := '0';
  begin
    --获取是否启用司龄工资
    v_is_working_age_cfg := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    if v_is_working_age_cfg = '1' then
      --获取司龄工资计算起期
      v_working_age_begin := pkg_law_define.f_get_working_age_begin_cfg(i_version_id);
      --获取销售员的入职日期
      select t.contract_date
        into v_contract_date
        from salesman t
       where t.salesman_code = i_sale_code;
      if v_contract_date is not null then
        --判断入职日期是否在配置的司龄工资计算起期之后，若在之后，则按入职日期算
        if v_contract_date > v_working_age_begin then
          select round(months_between(sysdate, v_contract_date) / 12, 0)
            into v_working_age
            from dual;
        else
          select round(months_between(sysdate, v_working_age_begin) / 12, 0)
            into v_working_age
            from dual;
        end if;
        --计算司龄工资总额
        v_age_salary := nvl(v_working_age, 0) *
                        pkg_law_cons.c_sal_per_working_year;
        --更新销售员信息表中的司龄工资
        update salesman t
           set t.age_salary = v_age_salary
         where t.salesman_code = i_sale_code;
        commit;
      end if;
    end if;
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_age_salary;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_age_salary;
  end A140;

  --团队长按客户经理考核，可以在团队长的公式中直接使用客户经理的因素，不然此两项不好获取值。
  --A141 按客户经理考核时的固定工资
  function A141(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A141';
    v_func_desc varchar2(100) := '按客户经理考核时的固定工资';
    v_return    number := 0;
  begin
    return v_return;
  end A141;

  --A142 按客户经理考核时的绩效工资
  function A142(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A142';
    v_func_desc varchar2(100) := '按客户经理考核时的绩效工资';
    v_return    number := 0;
  begin
    --TODO
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A142;

  --A143 地域标识（1-同城，0-异地）
  function A143(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name   varchar2(30) := 'pkg_law_factor.A143';
    v_func_desc   varchar2(100) := '地域标识';
    v_is_area_cfg number := 1; --基本法配置中，是否开启地域标识
    v_return      number := 0;
    v_area_val    char(1) := '1';
  begin
    --获取是否开启地域标识    
    v_is_area_cfg := pkg_law_define.f_get_is_area_cfg(i_version_id);
    if v_is_area_cfg = '1' then
      select nvl(max(t.area), 1)
        into v_return
        from salesman t
       where t.salesman_code = i_sale_code;
    end if;
  
    if v_is_area_cfg = '0' then
      select v_area_val
        into v_return
        from salesman t
       where t.salesman_code = i_sale_code;
    end if;
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A143;

  --A144 是否销售总监1是0否
  function A144(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A144';
    v_func_desc varchar2(100) := '是否销售总监1是0否';
    v_return    number := 0;
  begin
    select nvl(max(t.director), 0)
      into v_return
      from salesman t
     where t.salesman_code = i_sale_code;
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A144;

  --A145 销售总监补贴金额
  function A145(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.A145';
    v_func_desc varchar2(100) := '销售总监补贴金额';
    v_return    number := 0;
  begin
    --获取销售总监补贴金额
    v_return := pkg_law_define.f_get_subsidy_sum_cfg(i_version_id);
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A145;

  function A146(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name     varchar2(30) := 'pkg_law_factor.a146';
    v_func_desc     varchar2(100) := '上季度考核得分';
    v_quarter_score number := 0;
    v_last_quarter  varchar2(6) := '';
    v_curr_month    varchar2(2) := '';
  begin
    select to_char(i_bgn_date, 'mm') into v_curr_month from dual;
    if (v_curr_month = '01' or v_curr_month = '02' or v_curr_month = '03') then
      select (to_char(add_months(i_bgn_date, -12), 'yyyy') || '12')
        into v_last_quarter
        from dual;
    elsif (v_curr_month = '04' or v_curr_month = '05' or
          v_curr_month = '06') then
      select (to_char(i_bgn_date, 'yyyy') || '03')
        into v_last_quarter
        from dual;
    elsif (v_curr_month = '07' or v_curr_month = '08' or
          v_curr_month = '09') then
      select (to_char(i_bgn_date, 'yyyy') || '06')
        into v_last_quarter
        from dual;
    elsif (v_curr_month = '10' or v_curr_month = '11' or
          v_curr_month = '12') then
      select (to_char(i_bgn_date, 'yyyy') || '09')
        into v_last_quarter
        from dual;
    end if;
    select nvl(max(t.score), 0)
      into v_quarter_score
      from review_score t
     where t.calc_month = v_last_quarter
       and t.salesman_code = i_sale_code
       and t.valid_ind = '1';
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',销售人员' || i_sale_code || ',职级代码:' ||
                          i_rank_code,
                          '');
    return v_quarter_score;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return v_quarter_score;
    
  end A146;
  
  --A147 本年度累计交强险实收保费(团队)
  function A147(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a147';
    v_func_desc    varchar2(100) := '本年度累计交强险实收保费(团队)';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a147', --计算因素代码
                                     '0',
                                     '1');
  end A147;
  
  --A148 本年度累计非车险实收保费(团队)
  function A148(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a148';
    v_func_desc    varchar2(100) := '本年度累计非车险实收保费(团队)';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a148', --计算因素代码
                                     '0',
                                     '1');
  end A148;
  
  --A149 （四川）去年已实收，起期在本年业务(团队)
  function A149(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a149';
    v_func_desc    varchar2(100) := '当年累计实收保费';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '0', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a149', --计算因素代码
                                     '0',
                                     '2');
  end A149;
  
  --A150 截止考核月份的累积直接业务标保(团队)
  function A150(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_year_bgn_day date;
    v_year_end_day date;
    v_func_name    varchar2(30) := 'pkg_law_factor.a004';
    v_func_desc    varchar2(100) := '截止考核月份的累积直接业务标保';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --分公司代码
                                     v_year_bgn_day, --统计区间开始
                                     v_year_end_day, --统计区间结束
                                     i_sale_code, --业务员代码
                                     i_user_name, --操作人代码
                                     i_task_id, --任务id
                                     '1', --0实收保费,1标准保费
                                     '1', --0个人，1团队
                                     'a150', --计算因素代码
                                     '0',
                                     '1');
  end A150;
  --------------------------------------------导入手工因素开始---------------------------------------------
  -- 导入因素共用方法
  function BXXX(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char --
                ) return number is
    v_func_name  varchar2(30) := 'pkg_law_factor.bxxx';
    v_func_desc  varchar2(100) := '导入因素共用方法';
    v_index_code varchar(30) := i_group_code;
    v_calc_month varchar(6) := to_char(i_bgn_date, 'yyyymm');
    v_return     number(16, 4) := -1;
  begin
    begin
      select nvl(max(t.index_value), 0)
        into v_return
        from t_law_factor_imp_value t
       where t.valid_ind = '1'
         and t.index_code = v_index_code
         and t.version_id = i_version_id
         and t.calc_month = v_calc_month
         and t.salesman_code = i_sale_code;
    exception
      when others then
        pkg_law_log.log_error(v_func_name,
                              i_task_id,
                              i_user_name,
                              v_func_desc || ',销售人员' || i_sale_code ||
                              ',导入因素:' || v_index_code,
                              sqlerrm);
        return v_return;
    end;
    return v_return;
  end BXXX;
  --------------------------------------------导入手工因素完成---------------------------------------------

  --------------------------------------------职级计算因素开始---------------------------------------------
  --上一级别全年标准保费计划
  function CX01(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.cx01';
    v_func_desc varchar2(100) := '上一级别全年标准保费计划';
    v_norm_prem number(16, 4) := 0;
    v_norm_max1 number(16, 4) := 0;
    v_return    number(16, 4) := -1;
  begin
    --
    select t1.norm_premium
      into v_norm_prem
      from t_law_rank_def t1
     where t1.rank_code = i_rank_code;
    --
    select max(t2.norm_premium)
      into v_norm_max1
      from t_law_rank_def t2
     where t2.valid_ind = '1'
       and t2.item_status = '1'
       and t2.version_id = i_version_id
       and t2.manager_flag = pkg_law_check.f_check_leader(i_rank_code);
    --
    if (v_norm_prem >= v_norm_max1) then
      return v_norm_prem * 10000;
    end if;
    --
    select t3.norm_premium * 10000
      into v_return
      from t_law_rank_def t3
     where 1 = 1
       and t3.valid_ind = '1'
       and t3.item_status = '1'
       and t3.version_id = i_version_id
       and t3.manager_flag = pkg_law_check.f_check_leader(i_rank_code)
       and t3.norm_premium =
           (select min(t2.norm_premium)
              from t_law_rank_def t2
             where t2.valid_ind = '1'
               and t2.item_status = '1'
               and t2.version_id = i_version_id
               and t2.manager_flag =
                   pkg_law_check.f_check_leader(i_rank_code)
               and t2.norm_premium > v_norm_prem);
    return nvl(v_return, v_norm_prem * 10000);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end CX01;

  --最低级别全年标准保费计划
  function CX02(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.CX02';
    v_func_desc varchar2(100) := '最低级别全年标准保费计划';
    v_return    number(16, 4) := -1;
  begin
    select min(t.norm_premium) * 10000
      into v_return
      from t_law_rank_def t
     where t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.manager_flag = pkg_law_check.f_check_leader(i_rank_code);
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end CX02;

  --现在级别全年标准保费计划
  function CX03(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number is
    v_func_name varchar2(30) := 'pkg_law_factor.cx03';
    v_func_desc varchar2(100) := '现在级别全年标准保费计划';
    v_return    number(16, 4) := -1;
  begin
    select t.norm_premium * 10000
      into v_return
      from t_law_rank_def t
     where t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.rank_code = i_rank_code;
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name, --
                            v_func_desc || ',销售人员' || i_sale_code ||
                            ',职级代码:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end CX03;

--------------------------------------------职级计算因素完成---------------------------------------------

end pkg_law_factor;
/
