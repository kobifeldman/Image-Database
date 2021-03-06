USE [Kobi]
GO
/****** Object:  StoredProcedure [dbo].[search]    Script Date: 8/14/2021 1:37:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Search for images based on tags>
-- =============================================
ALTER PROCEDURE [dbo].[search] 
@tagIDS varchar(4000),
@allAny bit
AS
BEGIN
SET NOCOUNT ON;

	--Checks if the temp tables exist and deletes the old ones
	IF OBJECT_ID(N'tempdb..#ImagesWithTag') IS NOT NULL BEGIN
		DROP TABLE #ImagesWithTag
	END
	IF OBJECT_ID(N'tempdb..#Tags') IS NOT NULL BEGIN
		DROP TABLE #Tags
	END

	declare @aImageID int
	declare @sqlStatements varchar(5000)
	declare @whereClause varchar(1000) = ''
	declare @fullStatement varchar(6000) = ''
	declare @numberOfTags varchar(10)
	
	create table #ImagesWithTag(imageID int)

	select value into #Tags from string_split(@tagIDS, ',')

	-- = 0 if we want images that have ALL the tags
	if @allAny = 0 begin
		begin try
			select @numberOfTags = Count(*) from #Tags
			set @sqlStatements = 'select imageID from ImageTags I join #Tags t on I.tagID = t.value group by imageID having count(*) = ' + cast(@numberOfTags as varchar(10))
			--select @sqlStatements
			exec(@sqlStatements)
		end try
		begin catch
			print('Error: ' + ERROR_MESSAGE() + ' on line: ' + ERROR_LINE() + ' in procedure: ' + ERROR_PROCEDURE())
		end catch
	end
	-- = 1 if we want images that have ANY of the tags
	else if @allAny = 1 begin
		begin try
			set @sqlStatements = 'select * from ImageTags where '
			select @whereClause = @whereClause + 'tagID = ''' + [value] + ''' or ' from #Tags;
			set @whereClause = LEFT(@whereClause, DATALENGTH(@whereClause) - 4)

			set @fullStatement = @sqlStatements + @whereClause
			exec(@fullStatement)
		end try
		begin catch
			print('Error: ' + ERROR_MESSAGE() + ' on line: ' + ERROR_LINE() + ' in procedure: ' + ERROR_PROCEDURE())
		end catch
	end
END
