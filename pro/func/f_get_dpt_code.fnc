CREATE OR REPLACE FUNCTION f_get_dpt_code(sDpt   IN VARCHAR2,
                                             iLevel IN NUMBER)
  RETURN VARCHAR2 AS
  ret       VARCHAR2(11);
  sDptCde   VARCHAR2(11);
  sInDptCde VARCHAR2(11);
  iDptLvl   NUMBER(1);
BEGIN
  /************************ �˺�������������������ػ�������************************
  -------------------------����sDpt���������룻����iLevel�����ұ�ʶ----------------
  ************************1������������iLevel=1������sDpt�����ܹ�˾����**********
  ************************2������������iLevel=-1���򷵻��������sDpt���ϼ�����***
  ************************3������������iLevel=2������sDpt�����ֹ�˾����**********/
  iDptLvl := 0;
  sDptCde := '';
  ret     := '';
  sDptCde := LTRIM(RTRIM(sDpt));
  IF sDptCde IS NOT NULL THEN
    SELECT NVL(a.inter_code, CHR(0))
      INTO sInDptCde
      FROM DEPARTMENT a
     WHERE trim(a.dept_code) = sDptCde;
  END IF;
  sInDptCde := LTRIM(RTRIM(sInDptCde));

  ---------------------ȡ�ܹ�˾����----------------------------------
  IF (iLevel = 1) THEN
    SELECT C_DPT_CDE INTO ret FROM T_DEPARTMENT WHERE N_DPT_LEVL = 0;
    ----------------------ȡ�ϼ���������--------------------------------
  ELSIF (iLevel = -1) THEN
    SELECT NVL(a.dept_level, 0)
      INTO iDptLvl
      FROM DEPARTMENT a
     WHERE LTRIM(RTRIM(dept_code)) = sDptCde;

    IF (iDptLvl > 0) THEN
      SELECT a.parent_dept_code
        INTO ret
        FROM DEPARTMENT a
       WHERE trim(dept_code) = sDptCde;
    END IF;
    ------------------------ȡ�ֹ�˾����-----------------------------------
  ELSIF (iLevel = 2) THEN
    SELECT NVL(dept_level, 0)
      INTO iDptLvl
      FROM DEPARTMENT
     WHERE LTRIM(RTRIM(dept_code)) = sDptCde;

    IF (iDptLvl <= 1) THEN
      --�����������ܹ�˾��ֹ�˾�����ر������
      ret := sDptCde;
      RETURN ret;
    ELSE
      --���������Ƿֹ�˾���»��������طֹ�˾����
      SELECT dept_code
        INTO ret
        FROM DEPARTMENT
       WHERE sInDptCde LIKE LTRIM(RTRIM(inter_code)) || '%'
         AND dept_level = 1
         and inter_code is not null;
    END IF;
    ------------------------ȡ֧��˾����-----------------------------------
  ELSIF (iLevel = 3) THEN
    SELECT NVL(dept_level, 0)
      INTO iDptLvl
      FROM DEPARTMENT
     WHERE LTRIM(RTRIM(dept_code)) = sDptCde;

    IF (iDptLvl <= 2) THEN
      --�����������ܹ�˾��ֹ�˾�����ر������
      ret := sDptCde;
      RETURN ret;
    ELSE
      --���������Ƿֹ�˾���»��������طֹ�˾����
      SELECT dept_code
        INTO ret
        FROM DEPARTMENT
       WHERE sInDptCde LIKE LTRIM(RTRIM(inter_code)) || '%'
         AND dept_level = 2
         and inter_code is not null;
    END IF;
  ELSE
    RETURN ret;
  END IF;
  RETURN ret;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;
/

