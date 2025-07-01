IF (OBJECT_ID('dbo.merchant') IS NOT NULL)
	DROP TABLE dbo.merchant
GO

CREATE TABLE dbo.merchant (
	merchant_id INT IDENTITY(1, 1) NOT NULL
	,label VARCHAR(255) NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
	
	CONSTRAINT [PK_merchant_id] PRIMARY KEY CLUSTERED (merchant_id ASC) WITH (
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

ALTER TABLE dbo.merchant ADD CONSTRAINT DF_merchant__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.merchant ADD CONSTRAINT DF_merchant__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--verify
SELECT merchant_id
FROM dbo.merchant