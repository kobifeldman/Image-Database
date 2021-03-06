USE [Kobi]
GO
/****** Object:  StoredProcedure [dbo].[removeTagFromImage]    Script Date: 8/14/2021 1:37:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kobi Feldman>
-- Create date: <8/1/2020>
-- Description:	<Removes a tage from an image>
-- =============================================
ALTER PROCEDURE [dbo].[removeTagFromImage]
@imageid int,
@tagNames varchar(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @aTag varchar(100)
	declare @tagid int
	declare @throwMessage nvarchar(100)
	set @throwMessage = 'Tag: ' + @aTag + ' does not exist.'
	declare cur cursor for select value from string_split(@tagNames, ',')

	open cur
	fetch next from cur into @aTag

	--Loops through each tag that needs to be assigned to the image
	while @@FETCH_STATUS = 0 begin
		--If the tag doesn't exist, throw an error
		if (not exists (select 1 from Tags where name = @aTag)) begin;
			throw 50001, @throwMessage, 1
		end

		--Removes the reference between the image and tag
		select @tagID = tagID from Tags where name = @aTag
		delete from ImageTags where tagID = @tagid and imageID = @imageid

		fetch next from cur into @aTag
	end

	close cur
	deallocate cur
END
