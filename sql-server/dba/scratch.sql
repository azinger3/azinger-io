SELECT *
FROM dbo.[type]

SELECT *
FROM dbo.[group]

SELECT *
FROM dbo.category

SELECT *
FROM dbo.merchant

SELECT *
FROM dbo.[transaction]
ORDER BY [date]

SELECT t.[date]
	,g.label AS [group]
	,c.label AS category
	,m.label AS merchant
	,t.amount
	,t.note
FROM dbo.[transaction] AS t WITH (NOLOCK)
INNER JOIN dbo.[type] AS tp WITH (NOLOCK)
	ON t.[type_id] = tp.[type_id]
INNER JOIN dbo.[group] AS g WITH (NOLOCK)
	ON t.[group_id] = g.[group_id]
INNER JOIN dbo.[category] AS c WITH (NOLOCK)
	ON t.[category_id] = c.[category_id]
INNER JOIN dbo.[merchant] AS m WITH (NOLOCK)
	ON t.[merchant_id] = m.[merchant_id]
WHERE t.group_id = 1
ORDER BY t.[date] ASC