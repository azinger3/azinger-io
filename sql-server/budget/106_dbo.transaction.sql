IF (OBJECT_ID('dbo.transaction') IS NOT NULL)
	DROP TABLE dbo.[transaction]
GO

CREATE TABLE dbo.[transaction] (
	transaction_id INT IDENTITY(1, 1) NOT NULL
	,[type_id] INT NOT NULL
	,group_id INT NOT NULL
	,category_id INT NOT NULL
	,merchant_id INT NOT NULL
	,amount MONEY NOT NULL
	,note VARCHAR(255) NULL
	,[date] DATETIME NOT NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
	
	CONSTRAINT [PK_transaction_id] PRIMARY KEY CLUSTERED (transaction_id ASC) WITH (
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

ALTER TABLE dbo.[transaction] ADD CONSTRAINT DF_transaction__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.[transaction] ADD CONSTRAINT DF_transaction__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--indexes
CREATE NONCLUSTERED INDEX [IX_transaction_1] ON dbo.[transaction] ([date] ASC)
	WITH (
			PAD_INDEX = OFF
			,STATISTICS_NORECOMPUTE = OFF
			,SORT_IN_TEMPDB = OFF
			,DROP_EXISTING = OFF
			,ONLINE = OFF
			,ALLOW_ROW_LOCKS = ON
			,ALLOW_PAGE_LOCKS = ON
			,FILLFACTOR = 90
			) ON [primary]

--verify
SELECT transaction_id
FROM dbo.[transaction]