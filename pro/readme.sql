˵������Ŀ¼pro������������ 20160312

--20160312 ����ҵ����Դϵ��
-- Add/modify columns 
alter table T_LAW_MIS_GOT_PRM add n_rate_orig NUMBER(10,5);
-- Add comments to the columns 
comment on column T_LAW_MIS_GOT_PRM.n_rate_orig
  is 'ҵ����Դϵ��';
  
-- ϵ������
comment on column T_LAW_RATE.rate_type
  is ' ϵ�����ͣ�1-����ϵ����2-ҵ����ϵ����3-����ϵ���� 4-����ϵ���� 5-ҵ����Դϵ��';
  
-- Drop columns 
alter table T_LAW_MIS_GOT_PRM drop column v_clac_flag;
alter table T_LAW_MIS_GOT_PRM rename column v_employ_code to EMPLOY_CODE;
alter table T_LAW_MIS_GOT_PRM rename column v_dx_flag to TEL_FLAG;
alter table T_LAW_MIS_GOT_PRM rename column c_edr_no to ENDORSE_NO;
-- Add comments to the columns 
comment on column T_LAW_MIS_GOT_PRM.tel_flag
  is '�Ƿ�������뵥���';  
-- Add comments to the columns 
comment on column T_LAW_MIS_GOT_PRM.calc_flag
  is '��׼����״̬��ʾ,0-δ�����׼����,1-�Ѿ������׼����';  