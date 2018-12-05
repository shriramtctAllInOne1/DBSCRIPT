 ---update sequence value--------------------------------
 
 CREATE PROCEDURE UPDATE_SEQUENCE_VALUE( v_table_name IN varchar2,v_seq_name IN varchar2,v_column_name IN varchar2)
    AS
    v_last_number NUMBER;
    v_table_max_id NUMBER;
    v_increment_number NUMBER;
    v_query varchar2(255);
    sqlalterstmt varchar2(255);
    sqlnxtvalstmt varchar2(255);
    sqlIdCountstmt varchar2(255);
    sqlresetvalstmt varchar2(255);
    id_counter NUMBER;
    BEGIN
      sqlnxtvalstmt:='SELECT '|| v_seq_name ||'.NEXTVAL FROM dual';
      sqlalterstmt:='ALTER SEQUENCE ' || v_seq_name || ' INCREMENT BY ';
      sqlresetvalstmt :='ALTER SEQUENCE ' || v_seq_name || ' restart start with 1 ';
      v_query :='SELECT MAX('||v_column_name||') from '|| v_table_name ;
      sqlIdCountstmt :='SELECT count('||v_column_name||') from '|| v_table_name ;
      execute immediate sqlnxtvalstmt into v_last_number;
      execute immediate v_query into v_table_max_id;
      execute immediate sqlIdCountstmt into id_counter ;
       if id_counter = 0 then	
            v_increment_number :=  id_counter+1 - v_last_number ;            
          else 
          v_increment_number := v_table_max_id - v_last_number;
        end if;
       if v_increment_number <> 0 then	
            execute immediate sqlalterstmt || v_increment_number;
            execute immediate sqlnxtvalstmt into v_last_number;
            execute immediate sqlalterstmt || 1;
       end if;
       if id_counter = 0 then	
        execute immediate sqlresetvalstmt;
       end if;
  END;
/  