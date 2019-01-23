select *
  from (select a.*, rownum rn
          from (select pb.DEPT_CODE,
                       dept.dept_simple_name,
                       pb.CHANNEL_CODE,
                       MEDIUM_CNAME,
                       deptp.dept_simple_name PROCESS_DEPT_CODE,
                       decode(pb.APPROVE_FLAG, '1', '已审核', '0', '未审核', '已审核') APPROVE_FLAG,
                       sa.salesman_cname APPROVE_CODE,
                       decode(pb.valid_ind, '1', '否', '是') STATUS,
                       cg.CATEGORY_NAME CATEGORY,
                       bl.LINE_NAME BUSINESS_LINE,
                       decode(MSG_CAR, '1', '是', '0', '否', '') MSG_CAR,
                       decode(MSG_CUSTOMER, '1', '是', '0', '否', '') MSG_CUSTOMER,
                       cm.UPDATED_DATE,
                       decode(PARTER_LEVEL, '1', '分对分', '0', '总对总', '') PARTER_LEVEL,
                       (case
                         when (select case
                                        when max(clcr.expire_date) is not null and max(clcr.expire_date) < sysdate then
                                         '1'
                                        else
                                         '0'
                                      end
                                 from CHANNEL_CONFER clcr
                                where clcr.CHANNEL_CODE = cm.channel_code
                                  and clcr.VALID_IND = '1') = '1' and cm.expire_date is not null and
                              trunc(cm.expire_date) < trunc(sysdate) then
                          '资质和协议过期'
                         when cm.expire_date is not null and trunc(cm.expire_date) < trunc(sysdate) then
                          '资质过期'
                         when (select case
                                        when max(clcr.expire_date) is not null and max(clcr.expire_date) < sysdate then
                                         '1'
                                        else
                                         '0'
                                      end
                                 from CHANNEL_CONFER clcr
                                where clcr.CHANNEL_CODE = cm.channel_code
                                  and clcr.VALID_IND = '1') = '1' then
                          '协议过期'
                         when (cm.expire_date is null or trunc(cm.expire_date) > trunc(sysdate)) and
                              (select case
                                        when max(clcr.expire_date) is null or max(clcr.expire_date) > sysdate then
                                         '1'
                                        else
                                         '0'
                                      end
                                 from CHANNEL_CONFER clcr
                                where clcr.CHANNEL_CODE = cm.channel_code
                                  and clcr.VALID_IND = '1') = '1' then
                          '正在代理'
                         else
                          '---'
                       end) "newStatus"
                  from CHANNEL_MEDIUM_DETAIL cm
                  left join CHANNEL_MAIN pb
                    on pb.CHANNEL_CODE = cm.CHANNEL_CODE
                  left join salesman sa
                    on pb.APPROVE_CODE = sa.employ_code
                  left join DEPARTMENT dept
                    on pb.DEPT_CODE = dept.DEPT_CODE
                  left join channel_medium_contact fb
                    on pb.CHANNEL_CODE = fb.CHANNEL_CODE
                   and fb.get_flag = 1
                   and fb.VALID_IND = 1
                  left join BUSINESS_LINE bl
                    on pb.BUSINESS_LINE = bl.LINE_CODE
                   and bl.VALID_IND = 1
                  left join CATEGORY cg
                    on pb.CATEGORY = cg.CATEGORY_CODE
                   and cg.VALID_IND = 1
                  left join DEPARTMENT deptp
                    on cm.PROCESS_DEPT_CODE = deptp.DEPT_CODE
                 WHERE 1 = 1
                   and pb.channel_flag = '0'
                   and cm.EXPIRE_DATE >= trunc(sysdate)
                   and pb.VALID_IND = 1
                   and cm.VALID_IND = 1
                 order by cm.UPDATED_DATE desc) a
         where rownum <= 20)
 where rn >= 1
