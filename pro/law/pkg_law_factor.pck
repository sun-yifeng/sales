create or replace package pkg_law_factor is

  -- Author  : ADMINISTRATOR
  -- Created : 2015/7/8 14:54:21
  -- Purpose : ��������

  --------------------------------------------����ϵͳ���ؿ�ʼ---------------------------------------------
  --A001 �ڸ�ʱ��(����)
  function a001(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A002 ����ʵ�ձ���(����)
  function a002(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A003 ���±�׼����(����)
  function a003(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A004 �����ۼ�ʵ�ձ���
  function a004(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A005 �����ۼƱ�׼����
  function a005(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A006 ����ȱ�׼���Ѽƻ�
  function a006(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A007 �¶ȹ̶����ʱ�׼
  function a007(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A008 �¶ȼ�Ч���ʱ�׼
  function a008(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A009 ��Ч�����ݷ�ϵ��
  function a009(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A010 ����ϵ��(�Ŷӳ�Ա)
  function a010(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A011 ������Ѿ�δ�����
  function a011(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A012 ��������ڱ���
  function a012(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A013 ������Ѿ�δ���������ã������ˣ�
  function a013(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A014 ����12���µ��Ѿ�δ�������ˣ�
  function a014(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A015 ����12���µ����ڱ��ѣ����ˣ�
  function a015(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A016 ������ۼƷǳ��ձ�׼���ѣ����ˣ�
  function a016(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --������ۼƳ��ձ�׼���ѣ����ˣ�
  function a017(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A018 ������ۼƲƲ��ձ�׼���ѣ����ˣ�
  function a018(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A019 ������ۼ������ձ�׼���ѣ����ˣ�
  function a019(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A020 �Ƿ�������
  function a020(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A021 ���������·�
  function a021(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A022 ����ȷǳ����Ѿ�δ�����
  function a022(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A023 ����ȷǳ������ڱ���
  function a023(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A024 �������ۼƱ�׼����
  function a024(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A025 �����Ⱦ�������
  function a025(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A026 ������Ա������ϵ��
  function a026(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A027 ����н��ϵ��
  function a027(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A028 �����ʶ
  function a028(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A029 �Ƿ�����˾�乤��
  function a029(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A030 ˾�乤���ܶ�
  function a030(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  --�ϼ��ȿ��˵÷�              
  function A031(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  -- A032 (������ۼƽ�ǿ��ʵ�ձ���)
  function A032(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  -- A033 (������ۼƷǳ���ʵ�ձ���)
  function A033(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  
  -- A034 ���Ĵ���ȥ����ʵ�գ������ڱ���ҵ��
  function A034(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  --A035 ��ֹ�����·ݵ��ۻ�ֱ��ҵ��걣             
  function A035(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;                
  --------------------------------------------����ϵͳ���ؽ���---------------------------------------------

  --------------------------------------------�Ŷ�ϵͳ���ؿ�ʼ---------------------------------------------
  --A101  �Ŷӱ������Чʱ��(�Ŷ�)
  function a101(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A102  ����ʵ�ձ���(�Ŷ�)
  function a102(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A103 ���±�׼����(�Ŷ�)
  function a103(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A104 ������ۼ�ʵ�ձ���(�Ŷ�)
  function a104(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A105 ������ۼƱ�׼����(�Ŷ�)
  function a105(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A106 ����ȱ�׼���Ѽƻ�(�Ŷ�)
  function a106(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A107 �Ŷӳ����۽���(�Ŷ�)
  function a107(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A108 ��Ч���ʼ������(�Ŷ�)
  function a108(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A109 ������Ѿ�δ�����(�Ŷ�)
  function a109(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A110 ��������ڱ���(�Ŷ�)
  function a110(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A111 ������ڸ�ʱ��(�ŶӾ���)
  function a111(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A112 ������Ѿ�δ���������ã����Ŷӣ�
  function a112(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A113 ����12���µ��Ѿ�δ�����Ŷӣ�
  function a113(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A114  ����12���µ����ڱ��ѣ��Ŷӣ�
  function a114(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A115  ������ۼƷǳ��ձ�׼���ѣ��Ŷӣ�
  function a115(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A116  ������ۼƳ��ձ�׼���ѣ��Ŷӣ�
  function a116(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A117  ������ۼƲƲ��ձ�׼���ѣ��Ŷӣ�
  function a117(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A118  ������ۼ������ձ�׼���ѣ��Ŷӣ�
  function a118(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A119  �Ƿ�������
  function a119(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A120  ������ŶӾ������ʵ�ʱ�׼����
  function a120(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A121  �Ŷӵ���ʵ�ձ���
  function a121(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A122  �Ŷӵ��³���ʵ�ձ���
  function a122(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A123  �Ŷӵ��·ǳ���ʵ�ձ���
  function a123(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A124 ��׬�⸶�ʣ������ã�
  function a124(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A125  ���������·�
  function a125(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A126 �Ŷӳ��̶�����
  function a126(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A127 �Ŷӳ���Ч����
  function a127(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A128  �Ŷӳ����˱걣Ҫ��
  function a128(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A129  �¶ȹ̶����ʱ�׼���Ŷӳ����ͻ������ù��ʣ�
  function a129(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A130  �¶ȼ�Ч���ʱ�׼���Ŷӳ����ͻ������ù��ʣ�
  function a130(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A131 ����ȷǳ����Ѿ�δ�����
  function a131(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A132 ����ȷǳ������ڱ���
  function a132(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A133 �������ۼƱ�׼����
  function a133(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A134 �����Ⱦ�������
  function a134(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A135 ������Ա������ϵ��              
  function a135(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A136 �Ƿ��Ŷӿ��˵��ļ���������1��0��              
  function a136(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A137 �Ƿ񰴿ͻ�������              
  function a137(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A138 ��������н��ϵ��              
  function a138(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A139 �Ƿ�����˾�乤��              
  function a139(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A140 ˾�乤���ܶ�              
  function a140(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A141 ���ͻ�������ʱ�Ĺ̶�����                              
  function A141(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A142 ���ͻ�������ʱ�ļ�Ч����              
  function A142(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A143 �����ʶ              
  function a143(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A144 �Ƿ������ܼ�1��0��              
  function a144(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A145 �����ܼಹ�����              
  function a145(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  --�ϼ��ȿ��˵÷�              
  function A146(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;

  --A147 ������ۼƽ�ǿ��ʵ�ձ���(�Ŷ�)
  function A147(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
   --A148 ������ۼƷǳ���ʵ�ձ���(�Ŷ�)
  function A148(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
                
  --A149 ���Ĵ���ȥ����ʵ�գ������ڱ���ҵ��(�Ŷ�)
  function A149(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;
  
  --A150 ��ֹ�����·ݵ��ۻ�ֱ��ҵ��걣(�Ŷ�)
  function A150(i_version_id in char,
                i_user_name  in char,
                i_task_id    in char,
                i_bgn_date   in date,
                i_end_date   in date,
                i_sale_code  in char,
                i_dept_code  in char,
                i_rank_code  in char,
                i_group_code in char) return number;               
  --------------------------------------------�Ŷ�ϵͳ���ؽ���---------------------------------------------

  --------------------------------------------����������ؿ�ʼ---------------------------------------------
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
  --------------------------------------------ְ���������ؿ�ʼ---------------------------------------------
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
  --------------------------------------------ְ�������������---------------------------------------------

end pkg_law_factor;
/
create or replace package body pkg_law_factor is

  --------------------------------------------�ͻ�����ϵͳ���ؿ�ʼ---------------------------------------------

  --A001 �ڸ�ʱ��(����)
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
    v_func_desc  varchar(100) := '�ڸ�ʱ��(����)';
  begin
    /*
    �����۹�2016��6��20�� (��һ) 13:29���ʼ���
    ���ڽ������磨2016.6.20�����۵ġ���������⡱�еġ����ڷֹ�˾����ʱ�䰴�������ϵͳ���¼���Ĳ��족������˵�����£�
    ��������ͨ������ϵͳ�Ķ�����ϵͳԭ�м���ʱ��BUG��ϵͳ����ÿ�°�31����㣩�󣬷������£�
    �ڿ������ڣ�������ڸ�ʱ��A001�����鱣����λ��Ч���֣�
    ���¼��㣬�ڸ�ʱ��Ϊ���µ�����ֱ�Ӽ�Ϊ 1��
    ���¼��� ���ڸ�ʱ��Ϊ�����µ����ݣ����µ��ڸ�ʱ��/���������� ��
    ��������+�����µ�����=�ڸ�ʱ�䣨�·ݣ�
    ������
    ������Ա ��   �������䣨2016.1.1-2016.5.31�� ʵ���ڸ����䣨2016.1.15-2016.5.31��
    ���¼��㣺���µ�����  2�� 3�� 4�� 5�£�����4���£�   ���������� 20116.1.15-2016.1.31   ��31-15��/31=0.5161��
    ��������Ա  ��  �ڸ�ʱ�� A001=4+0.5161=4.5161 ���£�
     */
    --1��ȡҵ��Ա��˾����
    select nvl(t.front_date, trunc(i_end_date, 'yyyy'))
      into v_entry_date
      from salesman t
     where t.valid_ind = '1'
       and t.salesman_code = i_sale_code;
  
    --2����˾ʱ����ڵ���
    if (trunc(v_entry_date) <= trunc(i_end_date, 'yyyy')) then
      return to_number(to_char(i_end_date, 'mm'));
    end if;
  
    --3����˾ʱ��С�ڵ���
    -- ȡ�·�����
    select months_between(last_day(i_end_date) + 1,
                          last_day(v_entry_date) + 1)
      into v_month_1
      from dual;
    -- ȡ��ְ����
    select to_char(v_entry_date, 'dd') into v_day_1 from dual;
    -- ȡ��������
    select to_char(last_day(v_entry_date), 'dd') into v_day_2 from dual;
    -- ȡ�·�С��
    select ((v_day_2 - v_day_1 + 1) / v_day_2) into v_month_2 from dual;
    -- �ڸ�ʱ��=�·�����+�·�С��
    v_month := round(v_month_1 + v_month_2, 4);
    return v_month;
  
    --��־��Ϣ
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          '������Ա' || i_sale_code || ',�ڸ�ʱ��:' || v_month ||
                          ',����ʱ��:' || to_char(i_end_date, 'yyyy-mm-dd') ||
                          ',��˾����:' || to_char(v_entry_date, 'yyyy-mm-dd'),
                          '');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end;

  --A002 ����ʵ�ձ���(����)
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
    v_func_desc varchar2(100) := '����ʵ�ձ���(����)';
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a002', --�������ش���
                                     '1',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A002;

  --A003 ���±�׼����(����)
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
    v_func_desc varchar2(100) := '���±�׼����(����)';
  begin
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a003', --�������ش���
                                     '1',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A003;

  --A004 �����ۼ�ʵ�ձ���
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
    v_func_desc    varchar2(100) := '�����ۼ�ʵ�ձ���';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a004', --�������ش���
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A004;

  --A005 �����ۼƱ�׼����
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
    v_func_desc    varchar2(100) := '�����ۼƱ�׼����';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a005', --�������ش���
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A005;

  --A006 ����ȱ�׼���Ѽƻ�
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
    v_func_desc varchar2(100) := '�����׼���Ѽƻ�';
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
                              v_func_desc || ',������Ա' || i_sale_code ||
                              ',ְ������:' || i_rank_code,
                              sqlerrm);
        return - 1;
    end;
    return nvl(v_plan_fee, 0);
  end A006;

  --A007 �¶ȹ̶����ʱ�׼
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
    v_func_desc     varchar2(100) := '�¶ȼ�Ч���ʱ�׼';
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A007;

  --A008 �¶ȼ�Ч���ʱ�׼
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
    v_func_desc   varchar2(100) := '�¶ȼ�Ч���ʱ�׼';
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
                              v_func_desc || ',������Ա' || i_sale_code ||
                              ',ְ������:' || i_rank_code,
                              sqlerrm);
        return - 1;
    end;
    return nvl(v_calc_salary, 0);
  
  end A008;

  --A009 TODO ��������ҳ�������޳�����ʱû��
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

  --A010 ����ϵ��(�Ŷӳ�Ա)
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
  
    --����ϵ��(�Ŷӳ�Ա),���Ǽ��������
  
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
                          '������Ա' || i_sale_code || ',����ϵ��:' || v_base_rate,
                          '');
  
    return v_base_rate;
  
  end A010;

  --A011 ������Ѿ�δ�����
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      v_year_bgn_day, --ͳ�����俪ʼ
                                      v_year_end_day, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '0', --0���ˣ�1�Ŷ�
                                      'a011' --�������ش���
                                      );
  end A011;

  --A012 ��������ڱ���
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
    --��������ڱ���(����)
    return pkg_law_adapt.f_calc_prof(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0���ˣ�1�Ŷ�
                                     'a012' --�������ش���
                                     );
  end A012;

  --A013 ������Ѿ�δ���������ã������ˣ�
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      v_year_bgn_day, --ͳ�����俪ʼ
                                      i_end_date, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '0', --0���ˣ�1�Ŷ�
                                      'a013' --�������ش���
                                      );
  end A013;

  --A014 ����12���µ��Ѿ�δ�������ˣ�TODO:
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      p_bgn_date, --ͳ�����俪ʼ
                                      p_end_date, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '0', --0���ˣ�1�Ŷ�
                                      'a014' --�������ش���
                                      );
  
  end A014;

  --A015 ����12���µ����ڱ��ѣ����ˣ�TODO:
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
    --�ٱ������ھ�����
    return pkg_law_adapt.f_calc_prof(i_dept_code, --�ֹ�˾����
                                     p_bgn_date, --ͳ�����俪ʼ
                                     p_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0���ˣ�1�Ŷ�
                                     'a015' --�������ش���
                                     );
  end A015;

  --A016 ������ۼƷǳ��ձ�׼���ѣ����ˣ�
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a016', --�������ش���
                                     '0',
                                     '1');
  end A016;

  --������ۼƳ��ձ�׼���ѣ����ˣ�TODO:
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a017', --�������ش���
                                     '0',
                                     '1');
  
  end A017;

  --A018 ������ۼƲƲ��ձ�׼���ѣ����ˣ�TODO:
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a018', --�������ش���
                                     '0',
                                     '1');
  
  end A018;

  --A019 ������ۼ������ձ�׼���ѣ����ˣ�TODO:
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a019', --�������ش���
                                     '0',
                                     '1');
  end A019;

  --A020 �Ƿ�������
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
                              '������Ա' || i_sale_code || ',ְ������:' ||
                              i_rank_code || ',ȡ�Ƿ������ڳ���',
                              sqlerrm);
        return - 1;
    end;
    return v_try;
  end A020;

  --A021 ���������·�
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
    v_func_desc varchar2(100) := 'ȡ���������·�';
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
                              v_func_desc || ',������Ա' || i_sale_code ||
                              ',ְ������:' || i_rank_code,
                              sqlerrm);
        return - 1;
    end;
    return month_value;
  end A021;

  --A022 ����ȷǳ����Ѿ�δ����� TODO
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      v_year_bgn_day, --ͳ�����俪ʼ
                                      v_year_end_day, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '0', --0���ˣ�1�Ŷ�
                                      'a022' --�������ش���
                                      );
  end A022;

  --A023 ����ȷǳ������ڱ���
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
    return pkg_law_adapt.f_calc_prof(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0���ˣ�1�Ŷ�
                                     'a023' --�������ش���
                                     );
  end A023;

  --A024 �������ۼƱ�׼����
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
    v_func_desc varchar2(100) := '�������ۼƱ�׼����';
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_bgn_date, --ͳ�����俪ʼ
                                     v_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a024', --�������ش���
                                     '1',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A024;

  --A025 �����Ⱦ������� 

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
    v_func_desc varchar2(100) := '�����Ⱦ�������';
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A025;

  --A026 ������Ա������ϵ��
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
    v_func_desc varchar2(100) := '������Ա������ϵ��';
    v_return    number; --������Ա���̶�����ϵ��
  begin
    --��ȡ������Ա������ϵ��
    v_return := pkg_law_define.f_get_temp_emp_salary_rate_cfg(i_version_id);
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A026;

  --A027 ����н��ϵ��
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
    v_func_desc varchar2(100) := '����н��ϵ��';
    v_return    number := 1;
  begin
    --��ȡ����н��ϵ��
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A027;

  --A028 �����ʶ ��1-ͬ�ǣ�0-��أ�
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
    v_func_desc   varchar2(100) := '�����ʶ';
    v_is_area_cfg number := 1; --�����������У��Ƿ��������ʶ
    v_return      number := 0;
    v_area_val    char(1) := '1';
  begin
    --��ȡ�Ƿ��������ʶ    
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A028;

  --A029 �Ƿ�����˾�乤��
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
    v_func_desc varchar2(100) := '�Ƿ�����˾�乤��';
    v_return    number := 0;
  begin
    --��ȡ�Ƿ�����˾�乤��
    v_return := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A029;

  --A030 ˾�乤���ܶ�
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
    v_func_desc          varchar2(100) := '˾�乤���ܶ�';
    v_age_salary         number := 0;
    v_contract_date      date; --��˾����
    v_working_age_begin  date;
    v_working_age        number := 0; --˾��
    v_is_working_age_cfg varchar2(1) := '0';
  begin
    --��ȡ�Ƿ�����˾�乤��
    v_is_working_age_cfg := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    if v_is_working_age_cfg = '1' then
      --��ȡ˾�乤�ʼ�������
      v_working_age_begin := pkg_law_define.f_get_working_age_begin_cfg(i_version_id);
      --��ȡ����Ա����ְ����
      select t.contract_date
        into v_contract_date
        from salesman t
       where t.salesman_code = i_sale_code;
      if v_contract_date is not null then
        --�ж���ְ�����Ƿ������õ�˾�乤�ʼ�������֮������֮������ְ������
        if v_contract_date > v_working_age_begin then
          select round(months_between(sysdate, v_contract_date) / 12, 0)
            into v_working_age
            from dual;
        else
          select round(months_between(sysdate, v_working_age_begin) / 12, 0)
            into v_working_age
            from dual;
        end if;
        --����˾�乤���ܶ�
        v_age_salary := nvl(v_working_age, 0) *
                        pkg_law_cons.c_sal_per_working_year;
        --��������Ա��Ϣ���е�˾�乤��
        update salesman t
           set t.age_salary = v_age_salary
         where t.salesman_code = i_sale_code;
        commit;
      end if;
    end if;
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_age_salary;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
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
    v_func_desc     varchar2(100) := '�ϼ��ȿ��˵÷�';
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
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_quarter_score;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_quarter_score;
    
  end A031;
  
  -- A032 (������ۼƽ�ǿ��ʵ�ձ���)
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
    v_func_desc    varchar2(100) := '������ۼƽ�ǿ��ʵ�ձ���';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a032', --�������ش���
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
    
  end A032;
  
  -- A033 (������ۼƷǳ���ʵ�ձ���)
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
    v_func_desc    varchar2(100) := '������ۼƷǳ���ʵ�ձ���';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a033', --�������ش���
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
    
  end A033;
  
  
  
  -- A034 ���Ĵ���ȥ����ʵ�գ������ڱ���ҵ��
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
    v_func_desc    varchar2(100) := '���Ĵ���ȥ����ʵ�գ������ڱ���ҵ��';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a034', --�������ش���
                                     '0',
                                     '2');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
    
  end A034;
  
  --A035 ��ֹ�����·ݵ��ۻ�ֱ��ҵ��걣
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
    v_func_desc    varchar2(100) := '��ֹ�����·ݵ��ۻ�ֱ��ҵ��걣';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a035', --�������ش���
                                     '0',
                                     '1');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A035;
  --------------------------------------------�ͻ�����ϵͳ���ؽ���---------------------------------------------

  --------------------------------------------�ŶӾ���ϵͳ���ؿ�ʼ---------------------------------------------

  --A101  �Ŷӱ������Чʱ��(�Ŷ�)
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
    v_func_desc  varchar(100) := '�ڸ�ʱ��(����)';
  begin
    --1��ȡ�Ŷӳ�������
    select nvl(t.found_date, trunc(i_end_date, 'yyyy'))
      into v_found_date
      from group_main t
     where 1 = 1
       and t.valid_ind = '1'
       and t.group_code = i_group_code;
    --2������ʱ��С�ڵ���
    if (trunc(v_found_date) <= trunc(i_end_date, 'yyyy')) then
      return to_number(to_char(i_end_date, 'mm'));
    end if;
  
    --3������ʱ��С�ڵ���
    -- ȡ�·�����
    select months_between(last_day(i_end_date) + 1,
                          last_day(v_found_date) + 1)
      into v_month_1
      from dual;
    -- ȡ��ְ����
    select to_char(v_found_date, 'dd') into v_day_1 from dual;
    -- ȡ��������
    select to_char(last_day(v_found_date), 'dd') into v_day_2 from dual;
    -- ȡ�·�С��
    select ((v_day_2 - v_day_1 + 1) / v_day_2) into v_month_2 from dual;
    -- �ڸ�ʱ��=�·�����+�·�С��
    v_month := round(v_month_1 + v_month_2, 4);
    return v_month;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '������Ա' || i_sale_code || ',ְ������:' ||
                            i_rank_code,
                            sqlerrm);
      return - 1;
  end;

  --A102 �Ŷӳ��¶Ƚ����������(ʵ��)
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
    --ȡ�Ŷ������е�ʵ�ձ���
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a102', --�������ش���
                                     '1',
                                     '0');
  end A102;

  --A103 �Ŷӳ��¶Ƚ����������(�걣)
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a103', --�������ش���
                                     '1',
                                     '0');
  end A103;

  --A104 ������ۼ�ʵ�ձ���(�Ŷ�)
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
    v_func_desc    varchar2(100) := '�����ۼ�ʵ�ձ���';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a104', --�������ش���
                                     '0',
                                     '1');
  end A104;

  --A105 ������ۼƱ�׼����(�Ŷ�)
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
    v_func_desc    varchar2(100) := '�����ۼƱ�׼����';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a105', --�������ش���
                                     '0',
                                     '1');
  end A105;

  --A106 ����ȱ�׼���Ѽƻ�(�Ŷ�)
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
    --ȡְ����׼����
    select sum(t.norm_premium) * 10000
      into v_plan_fee
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --
    return nvl(v_plan_fee, 0);
  end A106;

  --A107 �Ŷӳ����۽���(�Ŷ�)
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
    v_func_desc varchar2(100) := '�Ŷӳ����۽���(�Ŷ�)';
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

  --A108 ��Ч���ʼ������(�Ŷӵ���) ��ʱδʹ��
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

  --A109 ������Ѿ�δ�����(�Ŷ�)
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      v_year_bgn_day, --ͳ�����俪ʼ
                                      v_year_end_day, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '1', --0���ˣ�1�Ŷ�
                                      'a109' --�������ش���
                                      );
  
  end A109;

  --A110 ��������ڱ���(�Ŷ�)
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
    return pkg_law_adapt.f_calc_prof(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0���ˣ�1�Ŷ�
                                     'a110' --�������ش���
                                     );
  end a110;

  --A111 ������ڸ�ʱ��(�ŶӾ���)
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
    --�ʼ���2015-07-03
    --B���ڸ�ʱ�䣨�ŶӾ��������Ŷӵĳ���ʱ��û�й�ϵ��
    --   �ֶκ��壺�ŶӾ�����˵��ڸ�ʱ�䣻
    --   ͳ�ƹ����ŶӾ������ڱ�����ְ�ģ����ս����Ѿ���ȥ��ʱ����㣻�ͻ���������ְ�ģ����ս����ʵ���ڸ�ʱ����㣻
    --             �������ŶӾ�����ְ��ָ�ļ�Ϊ����Ա��ְ��������Ա�������2015.1.5��ְ�����ۣ�2015.3.1���ŶӾ�����ô�Ӧ��2015.1.5������
    --   ��ֵ���ȣ�ʱ�䰴�ս�ֹͳ�����ڵ��������㣬��λ������º󣬱�����λС����
  
    --��ְʱ��
    select t.entry_date
      into v_entry_date
      from salesman t
     where t.salesman_code = i_sale_code;
    --��ְʱ��ֻ�㵱��
    if (v_entry_date < trunc(i_end_date, 'yyyy')) then
      v_entry_date := trunc(i_end_date, 'yyyy');
    end if;
  
    --�����ڸ�ʱ��
    select round(months_between(i_end_date, v_entry_date), 2)
      into v_month
      from dual;
    --��������
    return nvl(v_month, 0);
  
  end A111;

  --A112 ������Ѿ�δ���������ã����Ŷӣ�
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      v_year_bgn_day, --ͳ�����俪ʼ
                                      v_year_end_day, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '1', --0���ˣ�1�Ŷ�
                                      'a112' --�������ش���
                                      );
  
  end A112;

  --A113 ����12���µ��Ѿ�δ�����Ŷӣ�
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      p_bgn_date, --ͳ�����俪ʼ
                                      p_end_date, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '1', --0���ˣ�1�Ŷ�
                                      'a113' --�������ش���
                                      );
  
  end A113;

  --A114  ����12���µ����ڱ��ѣ��Ŷӣ�
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
    return pkg_law_adapt.f_calc_prof(i_dept_code, --�ֹ�˾����
                                     p_bgn_date, --ͳ�����俪ʼ
                                     p_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0���ˣ�1�Ŷ�
                                     'a114' --�������ش���
                                     );
  
  end A114;

  --A115  ������ۼƷǳ��ձ�׼���ѣ��Ŷӣ�
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a115', --�������ش���
                                     '0',
                                     '1');
  
  end A115;

  --A116  ������ۼƳ��ձ�׼���ѣ��Ŷӣ�
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a116', --�������ش���
                                     '0',
                                     '1');
  
  end A116;

  --A117  ������ۼƲƲ��ձ�׼���ѣ��Ŷӣ�
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a117', --�������ش���
                                     '0',
                                     '1');
  end A117;

  --A118  ������ۼ������ձ�׼���ѣ��Ŷӣ�
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a118', --�������ش���
                                     '0',
                                     '1');
  
  end A118;

  --A119  �Ƿ�������
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

  --A120  ������ŶӾ������ʵ�ʱ�׼����
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
    v_func_desc    varchar2(100) := '������ŶӾ������ʵ�ʱ�׼����';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '0', --0���ˣ�1�Ŷ�
                                     'a120', --�������ش���
                                     '0',
                                     '1');
  
  end A120;

  --A121  �Ŷӵ���ʵ�ձ���
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a121', --�������ش���
                                     '1',
                                     '1');
  
  end A121;

  --A122  �Ŷӵ��³���ʵ�ձ���
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a122', --�������ش���
                                     '1',
                                     '1');
  
  end A122;

  --A123  �Ŷӵ��·ǳ���ʵ�ձ���
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
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     i_bgn_date, --ͳ�����俪ʼ
                                     i_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a123', --�������ش���
                                     '1',
                                     '1');
  
  end A123;

  --A124 ��׬�⸶�ʣ������ã�TODO
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

  --A125  ���������·�
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

  --A126 �Ŷӳ��̶�����
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
    v_func_desc varchar2(100) := '�Ŷӳ��̶�����';
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
                              v_func_desc || ',������Ա' || i_sale_code ||
                              ',ְ������:' || i_rank_code,
                              sqlerrm);
        return v_return;
    end;
    return v_return;
  end A126;

  --A127 �Ŷӳ���Ч����
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
    v_func_desc varchar2(100) := '�Ŷӳ���Ч����';
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
                              v_func_desc || ',������Ա' || i_sale_code ||
                              ',ְ������:' || i_rank_code,
                              sqlerrm);
        return v_return;
    end;
    return v_return;
  end A127;

  --A128  �Ŷӳ����˱걣Ҫ�� TODO
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

  --A129  �¶ȹ̶����ʱ�׼���Ŷӳ����ͻ������ù��ʣ� TODO
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
                            '�Ŷ�ƽ������:' || i_sale_code,
                            '');
      return 1; --����ĸ�ò��ܷ���λ0
  end A129;

  --A130  �¶ȼ�Ч���ʱ�׼���Ŷӳ����ͻ������ù��ʣ� TODO
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

  --A131 ����ȷǳ����Ѿ�δ�����
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
    return pkg_law_adapt.f_calc_claim(i_dept_code, --�ֹ�˾����
                                      v_year_bgn_day, --ͳ�����俪ʼ
                                      v_year_end_day, --ͳ���������
                                      i_sale_code, --ҵ��Ա����
                                      i_user_name, --�����˴���
                                      i_task_id, --����id
                                      '1', --0���ˣ�1�Ŷ�
                                      'a131' --�������ش���
                                      );
  
  end A131;

  --A132 ����ȷǳ������ڱ���
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
    return pkg_law_adapt.f_calc_prof(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0���ˣ�1�Ŷ�
                                     'a132' --�������ش���
                                     );
  end A132;

  --A133 �������ۼƱ�׼����
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
  
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_bgn_date, --ͳ�����俪ʼ
                                     v_end_date, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a133', --�������ش���
                                     '1',
                                     '1');
  end A133;

  --A134 �����Ⱦ�������
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

  --A135 ������Ա������ϵ��
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
    v_func_desc varchar2(100) := '������Ա������ϵ��';
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
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A135;

  --A136 �Ƿ��Ŷӿ��˵��ļ��������� 1��0��
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
    v_func_desc  varchar2(100) := '�Ƿ��Ŷӿ��˵��ļ���������1��0��';
    v_return     number := 0;
    v_group_type varchar2(5); --�Ŷ�����,1��ʵ�Ŷ�,2�����Ŷ�,3�ļ����������Ŷӿ��ˣ�
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
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A136;

  --A137 �Ƿ񰴿ͻ�������
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
    v_func_desc    varchar2(100) := '�Ƿ񰴿ͻ�������';
    v_version_flag char(1);
    v_manager_flag char(1);
    v_rank_two     char(50);
  begin
    --ȡ������������ŶӾ����ͻ������˿���
    select t.is_client_manager_check
      into v_version_flag
      from t_law_define_config t
     where t.valid_ind = '1'
       and t.version_id = i_version_id;
    if (v_version_flag <> '1') then
      return 0;
    end if;
    --ȡ������Ա��ְ������
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
    --ȡ������Ա��ְ������
    select t.sale_rank_two
      into v_rank_two
      from salesman t
     where t.valid_ind = '1'
       and t.salesman_code = i_sale_code;
    --���ŶӾ�����������ְ����
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
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end A137;

  --A138 ��������н��ϵ��
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
    v_func_desc varchar2(100) := '��������н��ϵ��';
    v_return    number := 1;
  begin
    --��ȡ����н��ϵ��
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A138;

  --A139 �Ƿ�����˾�乤��
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
    v_func_desc varchar2(100) := '�Ƿ�����˾�乤��';
    v_return    number := 0;
  begin
    --��ȡ�Ƿ�����˾�乤��  
    v_return := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A139;

  --A140 ˾�乤���ܶ�
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
    v_func_desc          varchar2(100) := '˾�乤���ܶ�';
    v_age_salary         number := 0;
    v_contract_date      date; --��˾����
    v_working_age_begin  date;
    v_working_age        number := 0; --˾��
    v_is_working_age_cfg varchar2(1) := '0';
  begin
    --��ȡ�Ƿ�����˾�乤��
    v_is_working_age_cfg := pkg_law_define.f_get_is_working_age_cfg(i_version_id);
    if v_is_working_age_cfg = '1' then
      --��ȡ˾�乤�ʼ�������
      v_working_age_begin := pkg_law_define.f_get_working_age_begin_cfg(i_version_id);
      --��ȡ����Ա����ְ����
      select t.contract_date
        into v_contract_date
        from salesman t
       where t.salesman_code = i_sale_code;
      if v_contract_date is not null then
        --�ж���ְ�����Ƿ������õ�˾�乤�ʼ�������֮������֮������ְ������
        if v_contract_date > v_working_age_begin then
          select round(months_between(sysdate, v_contract_date) / 12, 0)
            into v_working_age
            from dual;
        else
          select round(months_between(sysdate, v_working_age_begin) / 12, 0)
            into v_working_age
            from dual;
        end if;
        --����˾�乤���ܶ�
        v_age_salary := nvl(v_working_age, 0) *
                        pkg_law_cons.c_sal_per_working_year;
        --��������Ա��Ϣ���е�˾�乤��
        update salesman t
           set t.age_salary = v_age_salary
         where t.salesman_code = i_sale_code;
        commit;
      end if;
    end if;
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_age_salary;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_age_salary;
  end A140;

  --�Ŷӳ����ͻ������ˣ��������Ŷӳ��Ĺ�ʽ��ֱ��ʹ�ÿͻ���������أ���Ȼ������û�ȡֵ��
  --A141 ���ͻ�������ʱ�Ĺ̶�����
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
    v_func_desc varchar2(100) := '���ͻ�������ʱ�Ĺ̶�����';
    v_return    number := 0;
  begin
    return v_return;
  end A141;

  --A142 ���ͻ�������ʱ�ļ�Ч����
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
    v_func_desc varchar2(100) := '���ͻ�������ʱ�ļ�Ч����';
    v_return    number := 0;
  begin
    --TODO
  
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A142;

  --A143 �����ʶ��1-ͬ�ǣ�0-��أ�
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
    v_func_desc   varchar2(100) := '�����ʶ';
    v_is_area_cfg number := 1; --�����������У��Ƿ��������ʶ
    v_return      number := 0;
    v_area_val    char(1) := '1';
  begin
    --��ȡ�Ƿ��������ʶ    
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
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A143;

  --A144 �Ƿ������ܼ�1��0��
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
    v_func_desc varchar2(100) := '�Ƿ������ܼ�1��0��';
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_return;
  end A144;

  --A145 �����ܼಹ�����
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
    v_func_desc varchar2(100) := '�����ܼಹ�����';
    v_return    number := 0;
  begin
    --��ȡ�����ܼಹ�����
    v_return := pkg_law_define.f_get_subsidy_sum_cfg(i_version_id);
    --
    return v_return;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
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
    v_func_desc     varchar2(100) := '�ϼ��ȿ��˵÷�';
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
                          v_func_desc || ',������Ա' || i_sale_code || ',ְ������:' ||
                          i_rank_code,
                          '');
    return v_quarter_score;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return v_quarter_score;
    
  end A146;
  
  --A147 ������ۼƽ�ǿ��ʵ�ձ���(�Ŷ�)
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
    v_func_desc    varchar2(100) := '������ۼƽ�ǿ��ʵ�ձ���(�Ŷ�)';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a147', --�������ش���
                                     '0',
                                     '1');
  end A147;
  
  --A148 ������ۼƷǳ���ʵ�ձ���(�Ŷ�)
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
    v_func_desc    varchar2(100) := '������ۼƷǳ���ʵ�ձ���(�Ŷ�)';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a148', --�������ش���
                                     '0',
                                     '1');
  end A148;
  
  --A149 ���Ĵ���ȥ����ʵ�գ������ڱ���ҵ��(�Ŷ�)
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
    v_func_desc    varchar2(100) := '�����ۼ�ʵ�ձ���';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '0', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a149', --�������ش���
                                     '0',
                                     '2');
  end A149;
  
  --A150 ��ֹ�����·ݵ��ۻ�ֱ��ҵ��걣(�Ŷ�)
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
    v_func_desc    varchar2(100) := '��ֹ�����·ݵ��ۻ�ֱ��ҵ��걣';
  begin
    v_year_bgn_day := trunc(i_bgn_date, 'yyyy');
    --v_year_end_day := to_date(to_char(v_year_bgn_day, 'yyyy') || '-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss');
    v_year_end_day := i_end_date;
    return pkg_law_adapt.f_calc_prem(i_dept_code, --�ֹ�˾����
                                     v_year_bgn_day, --ͳ�����俪ʼ
                                     v_year_end_day, --ͳ���������
                                     i_sale_code, --ҵ��Ա����
                                     i_user_name, --�����˴���
                                     i_task_id, --����id
                                     '1', --0ʵ�ձ���,1��׼����
                                     '1', --0���ˣ�1�Ŷ�
                                     'a150', --�������ش���
                                     '0',
                                     '1');
  end A150;
  --------------------------------------------�����ֹ����ؿ�ʼ---------------------------------------------
  -- �������ع��÷���
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
    v_func_desc  varchar2(100) := '�������ع��÷���';
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
                              v_func_desc || ',������Ա' || i_sale_code ||
                              ',��������:' || v_index_code,
                              sqlerrm);
        return v_return;
    end;
    return v_return;
  end BXXX;
  --------------------------------------------�����ֹ��������---------------------------------------------

  --------------------------------------------ְ���������ؿ�ʼ---------------------------------------------
  --��һ����ȫ���׼���Ѽƻ�
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
    v_func_desc varchar2(100) := '��һ����ȫ���׼���Ѽƻ�';
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end CX01;

  --��ͼ���ȫ���׼���Ѽƻ�
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
    v_func_desc varchar2(100) := '��ͼ���ȫ���׼���Ѽƻ�';
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end CX02;

  --���ڼ���ȫ���׼���Ѽƻ�
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
    v_func_desc varchar2(100) := '���ڼ���ȫ���׼���Ѽƻ�';
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
                            v_func_desc || ',������Ա' || i_sale_code ||
                            ',ְ������:' || i_rank_code,
                            sqlerrm);
      return - 1;
  end CX03;

--------------------------------------------ְ�������������---------------------------------------------

end pkg_law_factor;
/
