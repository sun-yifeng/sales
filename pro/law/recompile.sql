--基本法-批量执行存过包.sql
@c:\law\pkg_law_check.pck;
@c:\law\pkg_law_cons.pck;
@c:\law\pkg_law_define.pck;
@c:\law\pkg_law_factor.pck;
@c:\law\pkg_law_func.pck;
@c:\law\pkg_law_log.pck;
@c:\law\pkg_law_mis.pck;
@c:\law\pkg_law_person.pck;
@c:\law\pkg_law_rank.pck;
@c:\law\pkg_law_rank_bak.pck;
@c:\law\pkg_law_result.pck;
@c:\law\pkg_law_salesman.pck;
@c:\law\pkg_law_standard.pck;
@c:\law\pkg_law_sum.pck;
@c:\law\pkg_law_wage.pck;
@c:\law\pkg_law_main.pck;
@c:\law\pkg_law_manual.pck;

--查看是否都编译过(最后一次编译时间t.LAST_DDL_TIME)
--SELECT t.OBJECT_NAME, t.LAST_DDL_TIME,t.* FROM user_objects t where upper(t.OBJECT_NAME) like upper('pkg_law_%') order by t.LAST_DDL_TIME desc;
