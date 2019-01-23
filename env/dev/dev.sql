/*本文件作为开发时修改数据库字段文件，测试、上线时直接运行此SQL文件*/

-- 20151207 by sunyf 开发电商渠道管理功能
-- 增加字段 
alter table CHANNEL_MAIN add channel_origin CHAR(1) default 0 not null;
comment on column CHANNEL_MAIN.channel_origin is '渠道来源，0-内部，1-外部';
-- 增加字段  
alter table CHANNEL_CONFER add calclate_flag char(1) default '1';
comment on column CHANNEL_CONFER.calclate_flag is '是否独立结算,0-不独立结算，1-独立结算';
 -- 修改个代为非空
alter table CHANNEL_AGENT_DETAIL modify contract_no null;
alter table CHANNEL_AGENT_DETAIL modify mobile null;
alter table CHANNEL_AGENT_DETAIL modify tel null;
alter table CHANNEL_AGENT_DETAIL modify sex null;
alter table CHANNEL_AGENT_DETAIL modify birthday null;
alter table CHANNEL_AGENT_DETAIL modify educatioin null;
alter table CHANNEL_AGENT_DETAIL modify adderss null;
-- 增加字段 
alter table CHANNEL_AGENT_DETAIL add parent_channel_code VARCHAR2(30);
comment on column CHANNEL_AGENT_DETAIL.parent_channel_code is '上级渠道代码';
comment on column CHANNEL_CONFER.confer_type
  is '协议类型,B-代理协议,Q-经纪协议,H-互联网协议';
  

-- 20151209 by xulinchao 修改邮件发送功能
alter table CHANNEL_MAIL_RECORD add copy_mail VARCHAR2(600);
comment on column CHANNEL_MAIL_RECORD.copy_mail
  is '抄送人';

-- 20151209 by sunyf 渠道主表字段
alter table CHANNEL_MAIN rename column t_adb_tm to overdue_date;
-- Add comments to the columns 
comment on column CHANNEL_MAIN.overdue_date
  is '渠道过期时间（核心使用）';  
  
-- 20151215 by sunyf 更改自动任务的注释
comment on column AUTO_TASK.dispatch_result
  is '执行结果（1-成功（未开始），0-失败，2-进行中）';
  
-- 20151217 by liuym 增加邮件类型标志位
alter table CHANNEL_MAIL_RECORD add MAIL_TYPE CHAR(1) default '1';
comment on column CHANNEL_MAIL_RECORD.MAIL_TYPE
  is '预警邮件类型（1系统默认邮件,2手动邮件）';
  
-- 20151231 by xulinchao 增加公告接受人角色代码
alter table NOTICE_RECEIVE_DEPT add role_code varchar2(200) not null;
comment on column NOTICE_RECEIVE_DEPT.role_code
  is '公告接受人角色代码';
  
-- 20151231 by xulinchao 修改业务线为公告上传角色代码
alter table UPLOAD rename column business_line to ROLE_CODE;
alter table UPLOAD modify role_code VARCHAR2(100);
comment on column UPLOAD.role_code
  is '文件上传机构角色代码';
  
-- 20151231 by xulinchao 修改业务线为角色代码( 公告反馈信息)
alter table NOTICE_FEEDBACK rename column business_line to ROLE_CODE;
alter table NOTICE_FEEDBACK modify role_code VARCHAR2(200) not null;
-- Add comments to the columns 
comment on column NOTICE_FEEDBACK.role_code
  is '角色代码';
 
  -- 20151231 by xulinchao 增加公告发送层级
alter table NOTICE add relation_type char(1) not null;
comment on column NOTICE.relation_type
  is '发送层级：总-分（0）、分-支（1）、总-支（2）';
  
    -- 20150106 by xulinchao 增加创建人角色
alter table NOTICE add created_user_role varchar2(100) not null;
comment on column NOTICE.created_user_role
  is '创建人角色';
  
  -- 20150107 by xulinchao 增加反馈类型 
alter table NOTICE add feedback_type char(1) not null;
comment on column NOTICE.feedback_type
  is '反馈类型：所有接收岗位必反馈（0）、任意接收岗位反馈（1）';
