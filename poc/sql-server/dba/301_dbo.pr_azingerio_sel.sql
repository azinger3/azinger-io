SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Rob Azinger
-- Create Date: 02/25/2021
-- Description: Read from all tables in azingerio
-- =============================================

CREATE OR ALTER PROCEDURE dbo.pr_azingerio_sel
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 10 b.* FROM dbo.budget AS b WITH (NOLOCK) ORDER BY 1 DESC
	SELECT TOP 10 b.* FROM dbo.budget_type AS b WITH (NOLOCK) ORDER BY 1 DESC
	SELECT TOP 10 b.* FROM dbo.budget_year AS b WITH (NOLOCK) ORDER BY 1 DESC
END
GO


