create or replace procedure P_DICT_INFO_SYNC(sPram in varchar2,
                                               sRest   out varchar2,
                                               sMessage   out varchar2) is

begin

--ͬ���ֵ��
  --declare
  begin
    sRest    := '1';
    sMessage := '�ɹ�';

    --������Ϣ
    delete from bank;
    insert into bank(bank_code,bank_cname,valid_ind,updated_user,updated_date)
    select bnm.c_bank_cde,bnm.c_bank_cnm,decode(bnm.t_adb_tm,null,'1','0'),'system',sysdate from t_fin_bank_nm bnm;
    --����������Ϣ
    delete from bank_node;
    insert into bank_node(bank_node_code,cname,bank_code,province_code,city_code,valid_ind,updated_user,updated_date)
    select bnd.c_node_cde,bnd.c_node_cnm,bnd.c_bank_cde,bnd.c_region_cde,bnd.c_country_cde,decode(bnd.t_adb_tm,null,'1','0'),bnd.c_upd_cde,bnd.t_upd_tm from t_fin_bank_node bnd;
    
    
    delete from city;
    delete from province;
    delete from country;
    
    --���Ҵ���
    insert into country(country_code,country_name,valid_ind,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_CDE,C_CNM,'1',t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where c_par_cde = '008';
    
    --ʡ����
    insert into province(province_code,cname,valid_ind,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_DISP_CDE,C_CNM,'1',t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where c_par_cde = '702';

    
    --�д���
    insert into city(city_code,cname,province_code,valid_ind,Created_User,Created_Date,Updated_User,Updated_Date)
    select t.c_city_cde,t.c_city_cnm,t.c_region_cde,'1',t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_FIN_CITY t ;


    /*--�������ࡢ���ʡ�����
    delete from CATEGORY;
    insert into CATEGORY(CATEGORY_CODE,CATEGORY_NAME,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_CDE,C_CNM,t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where t.c_par_cde in ('190','192') or t.c_par_cde like '19002%';
    */

    --ҵ����
    insert into business_line(line_code,line_name,line_dict,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_CDE,C_CNM,C_CDE,t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where c_par_cde = '925'
    and t.c_cde not in (select bl.line_code from business_line bl);
    

    /*--���֤������
    delete from certify_type;
    insert into certify_type(certify_type_code,certify_type_name,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_CDE,C_CNM,t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where c_par_cde = '120';
    */

    /*--��������
    delete from channel_feature;
    insert into channel_feature(channel_code,channel_name,valid_ind,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_CDE,C_CNM,'1',t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where c_par_cde = '192';
    */

    /*--�����㼶
    delete from channel_level;
    insert into channel_level(level_code,level_name,valid_ind,Created_User,Created_Date,Updated_User,Updated_Date)
    select C_CDE,C_CNM,'1',t.c_crt_cde,t.t_crt_tm,t.c_upd_cde,t_Upd_Tm from T_COMM_CODE t where c_par_cde = '141';
    */
    commit;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest := '-1';
          sMessage := 'ͬ���ֵ����Ϣʧ�ܣ��������:' || SUBSTR(SQLERRM, 1, 150);
          COMMIT;
          RETURN;
        END;
  end;
end P_DICT_INFO_SYNC;
/

