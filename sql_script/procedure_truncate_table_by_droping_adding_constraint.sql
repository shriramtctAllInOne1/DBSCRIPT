
-- Create the stored procedure to truncate the the tables, the fields of which are reffered as foreign keys --

CREATE PROCEDURE truncateTable
      @v_table_name VARCHAR(250),
	  @v_backup_table_name VARCHAR(250),
	  @v_columnName VARCHAR(250)
    AS
    BEGIN    
		DECLARE 
			@rank int,
			@FK_Table varchar(250),
			@FK_Column varchar(250),
			@PK_Table varchar(250),
			@PK_Column varchar(250),
			@v_query_name VARCHAR(250),
			@Constraint_Name varchar(250);

		--DECLARE FK_cursor CURSOR SCROLL FOR 
SELECT  
	rank() OVER (ORDER BY fk.name) as rank,
    fk.name Constraint_Name,
    OBJECT_NAME(fk.parent_object_id) FK_Table,
    c1.name FK_Column,
    OBJECT_NAME(fk.referenced_object_id) PK_Table,
    c2.name PK_Column
	INTO #mytemp
FROM 
    sys.foreign_keys fk 
INNER JOIN 
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN
    sys.columns c1 ON fkc.parent_column_id = c1.column_id AND fkc.parent_object_id = c1.object_id
INNER JOIN
    sys.columns c2 ON fkc.referenced_column_id = c2.column_id AND fkc.referenced_object_id = c2.object_id
        WHERE OBJECT_NAME(fk.referenced_object_id) =+@v_table_name 

			-- to drop the foreign keys
			select @rank = min( rank ) from #mytemp;
			while @rank is not null
			begin
				select @FK_Table = FK_Table,@Constraint_Name = Constraint_Name 
				from #mytemp authors where rank = @rank
				 execute('ALTER TABLE ' + @FK_Table + ' DROP CONSTRAINT ' + @Constraint_Name);			
				select @rank = min( rank ) from #mytemp where rank > @rank
			end

			--truncate the table
			execute('truncate table '+@v_table_name)

		execute('insert into '+@v_table_name + ' select * from ' + @v_backup_table_name);
		set @v_query_name='update table_info set max_id=(SELECT MAX('+@v_columnName+') from '+@v_table_name+' ) where table_name ='+char(39)+@v_table_name+char(39)+';'; 	
		execute (@v_query_name);	
			-- to recreate the foreign keys
			select @rank = min( rank ) from #mytemp;
			while @rank is not null
			begin
				select @FK_Table = FK_Table,@FK_Column = FK_Column,@PK_Table = PK_Table,
				@PK_Column = PK_Column, @Constraint_Name = Constraint_Name 
				from #mytemp authors where rank = @rank
			
				execute('ALTER TABLE '+@FK_Table+' WITH CHECK ADD CONSTRAINT '+@Constraint_Name+' FOREIGN KEY('+@FK_Column+')
				REFERENCES '+@PK_Table+' ('+@PK_Column+')');		
	
				select @rank = min( rank ) from #mytemp where rank > @rank
			end
	RETURN
END