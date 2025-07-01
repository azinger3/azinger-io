IF (OBJECT_ID('dbo.business_expense') IS NOT NULL)
	DROP TABLE dbo.[business_expense]
GO

CREATE TABLE dbo.[business_expense] (
	business_expense_id INT IDENTITY(1, 1) NOT NULL
	,category VARCHAR(255) NULL
	,merchant VARCHAR(255) NULL
	,amount MONEY NULL
	,note VARCHAR(255) NULL
	,[date] DATETIME NULL
	,tax_year INT NULL
	,[status] VARCHAR(255) NULL
	,datetime_added DATETIME NOT NULL
	,datetime_modified DATETIME NOT NULL 
    
    CONSTRAINT [PK_business_expense_id] PRIMARY KEY CLUSTERED (business_expense_id ASC) WITH (
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

ALTER TABLE dbo.[business_expense] ADD CONSTRAINT DF_business_expense__datetime_added DEFAULT(GETDATE())
FOR datetime_added
GO

ALTER TABLE dbo.[business_expense] ADD CONSTRAINT DF_business_expense__datetime_modified DEFAULT(GETDATE())
FOR datetime_modified
GO

--verify
SELECT business_expense_id
FROM dbo.[business_expense]
