IF (OBJECT_ID('dbo.category') IS NOT NULL)
	DROP TABLE dbo.category
GO

CREATE TABLE dbo.category (
	category_id INT IDENTITY(1, 1) NOT NULL
	,label VARCHAR(255) NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
	
	CONSTRAINT [PK_category_id] PRIMARY KEY CLUSTERED (category_id ASC) WITH (
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

ALTER TABLE dbo.category ADD CONSTRAINT DF_category__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.category ADD CONSTRAINT DF_category__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--verify
SELECT category_id
FROM dbo.category