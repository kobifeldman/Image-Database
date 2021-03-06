USE [Kobi]
GO
/****** Object:  StoredProcedure [dbo].[insertImageWithTags]    Script Date: 8/14/2021 1:36:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kobi Feldman>
-- Create date: <7/21/2020>
-- Description:	<Adds an image to the database along with both already existing tags and new tags>
-- =============================================
ALTER PROCEDURE [dbo].[insertImageWithTags] 
@image varbinary(max),
@tagNames varchar(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @imageID int

	insert Images(image, description)
	values(@image, 'BANANA')
	select @imageID = SCOPE_IDENTITY()
	--Calls on addTagsToImage stored procedure to add all the tags to the new image
	exec addTagsToImage @imageID = @imageID, @tagNames = @tagNames
END
