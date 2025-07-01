IF (OBJECT_ID('dbo.group') IS NOT NULL)
	DROP TABLE dbo.[group]
GO

CREATE TABLE dbo.[group] (
	group_id INT IDENTITY(1, 1) NOT NULL
	,label VARCHAR(255) NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
	
	CONSTRAINT [PK_group_id] PRIMARY KEY CLUSTERED (group_id ASC) WITH (
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

ALTER TABLE dbo.[group] ADD CONSTRAINT DF_group__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.[group] ADD CONSTRAINT DF_group__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--verify
SELECT group_id
FROM dbo.[group]