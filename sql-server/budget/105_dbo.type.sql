IF (OBJECT_ID('dbo.type') IS NOT NULL)
	DROP TABLE dbo.[type]
GO

CREATE TABLE dbo.[type] (
	[type_id] INT IDENTITY(1, 1) NOT NULL
	,label VARCHAR(255) NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
	
	CONSTRAINT [PK_type_id] PRIMARY KEY CLUSTERED (type_id ASC) WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
		,FILLFACTOR = 90
		)
	ON [primary]
	) ON [primary]
GO

ALTER TABLE dbo.[type] ADD CONSTRAINT DF_type__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.[type] ADD CONSTRAINT DF_type__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--verify
SELECT [type_id]
FROM dbo.[type]