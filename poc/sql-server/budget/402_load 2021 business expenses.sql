TRUNCATE TABLE dbo.business_expense

INSERT INTO dbo.business_expense (
	category
	,merchant
	,amount
	,note
	,[date]
	,tax_year
	,[status]
	)
SELECT c.label AS category
	,m.label AS merchant
	,t.amount
	,t.note
	,t.[date]
	,'2021' AS tax_year
	,'pending' AS [status]
FROM dbo.[transaction] AS t WITH (NOLOCK)
INNER JOIN dbo.[type] AS tp WITH (NOLOCK)
	ON t.[type_id] = tp.[type_id]
INNER JOIN dbo.[group] AS g WITH (NOLOCK)
	ON t.[group_id] = g.[group_id]
INNER JOIN dbo.[category] AS c WITH (NOLOCK)
	ON t.[category_id] = c.[category_id]
INNER JOIN dbo.[merchant] AS m WITH (NOLOCK)
	ON t.[merchant_id] = m.[merchant_id]
WHERE t.group_id = 1 -- ubam
ORDER BY t.[date] ASC

SELECT be.*
FROM dbo.business_expense AS be WITH (NOLOCK)
WHERE be.category = 'ubam'
	AND be.[status] = 'pending'


/*
    -- find the line
    SELECT *
    FROM dbo.business_expense AS be
    WHERE be.amount = 39.15

    -- set to invalid
    UPDATE be
    SET be.[status] = 'invalid'
    FROM dbo.business_expense AS be
    WHERE be.business_expense_id = 170
*/
