USE [Kobi]
GO
/****** Object:  StoredProcedure [dbo].[addTagsToImage]    Script Date: 8/14/2021 1:34:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kobi Feldman>
-- Create date: <8/1/2020>
-- Description:	<Adds new tags to an image>
-- =============================================
ALTER PROCEDURE [dbo].[addTagsToImage]
@imageID int,
@tagNames varchar(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @aTag varchar(100)
	declare @tagID int
	--Splits each tag into individual values and declares a cursor to loop through them
	declare cur cursor for select value from string_split(@tagNames, ',')

	open cur
	fetch next from cur into @aTag

	begin try
		if not exists (select 1 from Images where imageID = @imageID) begin
			raiserror('ERROR: Image ID does not exist.', 11, 1)
		end

		--Loops through each tag that needs to be assigned to the image
		while @@FETCH_STATUS = 0 begin
			--If the tag doesn't exist, create it first
			if (not exists (select 1 from Tags where name = @aTag)) begin
				insert Tags(name)
				values(@aTag)
			end

			--Add the reference between the image and tag
			select @tagID = tagID from Tags where name = @aTag
			insert ImageTags(imageID, tagID)
			values(@imageID, @tagID)

			fetch next from cur into @aTag
		end
	end try
	begin catch
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  
  
		SELECT   
			@ErrorMessage = ERROR_MESSAGE(),  
			@ErrorSeverity = ERROR_SEVERITY(),  
			@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState) 
	end catch

	close cur
	deallocate cur
END
