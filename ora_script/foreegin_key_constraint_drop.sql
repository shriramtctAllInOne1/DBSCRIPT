---Drop foreign key constraints

Begin
  for i in (select table_name, constraint_name from user_constraints where constraint_type ='R' and status = 'ENABLED') LOOP
    execute immediate 'alter table ' || i.table_name|| ' disable constraint ' || i.constraint_name || '';
  end LOOP;
  
END;

Begin
  FOR i in (select table_name, constraint_name from user_constraints where constraint_type ='R' and status = 'DISABLED') LOOP
    execute immediate 'alter table ' || i.table_name|| ' enable constraint ' || i.constraint_name || '';
  end LOOP;  
END;