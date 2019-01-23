select       t2.calc_month as "计算月份",
             t2.dept_name_two as "分公司" ,
             t2.dept_name_three as "支公司",
             t2.dept_name_four  as "四级单位",
             t2.group_name as "团队",
             t2.salesman_code as "域账户",
             t2.salesman_name as "姓名",
             t3.rank_name as "变更前职级",
             t4.rank_name as "变更后职级",
             t1.changeuser  as "变更人" ,
             to_char(t1.changedate,'yyyy-MM-dd HH24:mi:ss') as "变更日期"
        from review_rank_history t1
        left join review_rank t2
          on t1.rank_id = t2.rank_id
        left join t_law_rank_def t3
          on t1.before_rank=t3.rank_code
        left join t_law_rank_def t4
          on t1.after_rank = t4.rank_code
        where 1=1
        and t2.dept_code_two = '26'
        and t2.calc_Month = '201606'
        order by t2.dept_code_four,t2.salesman_code;