select t1.group_code 团队代码,
       t2.group_name 团队名称,
       decode(t2.group_type,
              '1',
              '真实团队',
              '2',
              '虚拟团队',
              '3',
              '四级机构') 是否真实团队,
         case
           when t6.salesman_cname is null then
           '无'
         else 
           '有'
       end  是否有团队长,
       t6.salesman_cname 团队长,
       to_char(t2.found_date, 'yyyy-mm-dd') 团队成立时间,
       t1.employ_code 团队成员工号,
       t3.salesman_cname 团队成员姓名,
       t1.sales_code 团队成员HRID,
       to_char(t3.contract_date, 'yyyy-mm-dd') 入司时间,
       to_char(t3.entry_date, 'yyyy-mm-dd') 入职时间,
       to_char(t3.REGULAR_DATE, 'yyyy-mm-dd') 转正时间,
       to_char(t3.DIMISSION_DATE, 'yyyy-mm-dd') 离职时间,
       to_char(t3.front_date, 'yyyy-mm-dd') 开始考核时间,
       to_char(t1.entry_date, 'yyyy-mm-dd') 加入团队的时间,
       to_char(t1.leave_date, 'yyyy-mm-dd') 离开团队的时间
  from group_menber t1
  left join group_main t2
    on t1.group_code = t2.group_code
  left join salesman t3
    on t1.sales_code = t3.salesman_code
  left join (select t4.group_code, t4.group_leader, t5.salesman_cname
               from group_leader_record t4
               left join salesman t5
                 on t4.group_leader = t5.salesman_code
              where t4.valid_ind = '1') t6
    on t1.group_code = t6.group_code
 where 1 = 1
   and substr(t1.group_code, 1, 2) = '20'
 order by t1.group_code, t1.sales_code
