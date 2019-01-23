CREATE OR REPLACE FUNCTION f_fill_zero(i_str       VARCHAR2, /* ×ª»»×Ö·û´® */
                                       i_length    NUMBER, /* ×Ö·û´®³¤¶È */
                                       i_direction NUMBER) /* ²¹0·½Ïò£¬0=×ó£¬1=ÓÒ */
 RETURN VARCHAR2 IS
  str_len NUMBER;
  n       NUMBER;
  o_str   VARCHAR2(100);
BEGIN
  str_len := LENGTH(i_str);
  IF str_len >= i_length THEN
    RETURN(i_str);
  END IF;
  IF i_direction = 0 THEN
    o_str := '';
    n     := 0;
    LOOP
      IF n >= i_length - str_len THEN
        EXIT;
      END IF;
      o_str := o_str || '0';
      n     := n + 1;
    END LOOP;
    o_str := o_str || i_str;
  ELSE
    o_str := i_str;
    n     := 0;
    LOOP
      IF n >= i_length - str_len THEN
        EXIT;
      END IF;
      o_str := o_str || '0';
      n     := n + 1;
    END LOOP;
  END IF;
  RETURN(o_str);
END f_fill_zero;
/

