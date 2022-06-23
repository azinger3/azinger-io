SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Rob Azinger
-- Create Date: 02/25/2021
-- Description: Read from object table in azingerio
-- =============================================

CREATE OR ALTER PROCEDURE dbo.pr_azingerio_object_sel
AS
BEGIN
	SET NOCOUNT ON;

	SELECT o.[object_id]
		,s.[name] AS [schema]
		,o.[name] AS [object]
		,o.[type]
		,o.[create_date] AS datetime_added
		,o.[modify_date] AS datetime_modified
	FROM [sys].[objects] AS o WITH (NOLOCK)
	INNER JOIN [sys].[schemas] AS s WITH (NOLOCK)
		ON s.[schema_id] = o.[schema_id]
	WHERE s.[name] = 'dbo'
		AND o.[type] IN (
			'U'
			,'P'
			,'FN'
			)
	ORDER BY CASE o.[type]
			WHEN 'U'
				THEN 1
			WHEN 'FN'
				THEN 2
			WHEN 'P'
				THEN 3
			END
		,o.[name] ASC
END
GO

