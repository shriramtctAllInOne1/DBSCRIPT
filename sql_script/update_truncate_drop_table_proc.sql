CREATE PROCEDURE truncate_drop_table
      @v_table_name VARCHAR(250),
	  @v_backup_table_name VARCHAR(250)
    AS
    BEGIN   
	 DECLARE 
	 @v_query_name VARCHAR(250),
	 @v_columnName VARCHAR(20);
	 
	 if @v_table_name ='pr_key_word'
	  set @v_columnName='pr_id';
	 else if  @v_table_name ='data_fields_chngd'
	   set @v_columnName='pr_id';
	 else if @v_table_name ='pr_activity_member'
       set @v_columnName='pr_activity_id';
	 else
	   set @v_columnName='ID';

	   set @v_query_name='update table_info set max_id=(SELECT MAX('+@v_columnName+') from '+@v_table_name+' ) where table_name ='+char(39)+@v_table_name+char(39)+';'; 
	 execute('truncate table  '+@v_table_name);
	 execute('insert into '+@v_table_name+' select * from '+@v_backup_table_name);
	 PRINT(@v_query_name);
	 execute (@v_query_name);
	 execute('drop table '+@v_backup_table_name);  
	END
 GO