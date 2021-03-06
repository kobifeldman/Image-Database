USE [Kobi]
GO
/****** Object:  StoredProcedure [dbo].[tagsOnImage]    Script Date: 8/14/2021 1:38:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kobi Feldman>
-- Create date: <7/11/2020>
-- Description:	<Selects all the tags associated with a given image>
-- =============================================
ALTER PROCEDURE [dbo].[tagsOnImage]
@image varbinary(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select t.name
	from Tags as t
	inner join ImageTags as it
		on t.tagID = it.tagID
	inner join Images as i
		on it.imageID = i.imageID
	where i.image = @image
END
