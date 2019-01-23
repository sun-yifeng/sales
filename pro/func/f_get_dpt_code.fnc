CREATE OR REPLACE FUNCTION f_get_dpt_code(sDpt   IN VARCHAR2,
                                             iLevel IN NUMBER)
  RETURN VARCHAR2 AS
  ret       VARCHAR2(11);
  sDptCde   VARCHAR2(11);
  sInDptCde VARCHAR2(11);
  iDptLvl   NUMBER(1);
BEGIN
  /************************ 此函数根据输入参数，返回机构代码************************
  -------------------------参数sDpt：机构代码；参数iLevel：查找标识----------------
  ************************1。如果输入参数iLevel=1，返回sDpt所属总公司代码**********
  ************************2。如果输入参数iLevel=-1，则返回输入机构sDpt的上级机构***
  ************************3。如果输入参数iLevel=2，返回sDpt所属分公司代码**********/
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

  ---------------------取总公司代码----------------------------------
  IF (iLevel = 1) THEN
    SELECT C_DPT_CDE INTO ret FROM T_DEPARTMENT WHERE N_DPT_LEVL = 0;
    ----------------------取上级机构代码--------------------------------
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
    ------------------------取分公司代码-----------------------------------
  ELSIF (iLevel = 2) THEN
    SELECT NVL(dept_level, 0)
      INTO iDptLvl
      FROM DEPARTMENT
     WHERE LTRIM(RTRIM(dept_code)) = sDptCde;

    IF (iDptLvl <= 1) THEN
      --如果输入的是总公司或分公司，返回本身代码
      ret := sDptCde;
      RETURN ret;
    ELSE
      --如果输入的是分公司以下机构，返回分公司代码
      SELECT dept_code
        INTO ret
        FROM DEPARTMENT
       WHERE sInDptCde LIKE LTRIM(RTRIM(inter_code)) || '%'
         AND dept_level = 1
         and inter_code is not null;
    END IF;
    ------------------------取支公司代码-----------------------------------
  ELSIF (iLevel = 3) THEN
    SELECT NVL(dept_level, 0)
      INTO iDptLvl
      FROM DEPARTMENT
     WHERE LTRIM(RTRIM(dept_code)) = sDptCde;

    IF (iDptLvl <= 2) THEN
      --如果输入的是总公司或分公司，返回本身代码
      ret := sDptCde;
      RETURN ret;
    ELSE
      --如果输入的是分公司以下机构，返回分公司代码
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

