USE [Kobi]
GO
/****** Object:  StoredProcedure [dbo].[removeImage]    Script Date: 8/14/2021 1:36:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Removes an image>
-- =============================================
ALTER PROCEDURE [dbo].[removeImage]
@imageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    delete from Images where imageID = @imageID
END
