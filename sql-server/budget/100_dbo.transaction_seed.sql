IF (OBJECT_ID('dbo.transaction_seed') IS NOT NULL)
	DROP TABLE dbo.transaction_seed
GO

CREATE TABLE dbo.transaction_seed (
	transaction_seed_id INT IDENTITY(1, 1) NOT NULL
	,type VARCHAR(255) NULL
	,[group] VARCHAR(255) NULL
	,category VARCHAR(255) NULL
	,merchant VARCHAR(255) NULL
	,amount MONEY
	,note VARCHAR(255) NULL
	,[date] DATETIME NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
	
	CONSTRAINT [PK_transaction_seed_id] PRIMARY KEY CLUSTERED (transaction_seed_id ASC) WITH (
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

ALTER TABLE dbo.transaction_seed ADD CONSTRAINT DF_transaction_seed__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.transaction_seed ADD CONSTRAINT DF_transaction_seed__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--verify
SELECT transaction_seed_id
FROM dbo.transaction_seed
