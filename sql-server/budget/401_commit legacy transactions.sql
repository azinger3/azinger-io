TRUNCATE TABLE dbo.[type];

TRUNCATE TABLE dbo.[group];

TRUNCATE TABLE dbo.[category];

TRUNCATE TABLE dbo.[merchant];

TRUNCATE TABLE dbo.[transaction];

IF (OBJECT_ID('tempdb..#list') IS NOT NULL)
	DROP TABLE #list

CREATE TABLE #list (
	row_id INT IDENTITY(1, 1)
	,type VARCHAR(255)
	,[group] VARCHAR(255)
	,category VARCHAR(255)
	,merchant VARCHAR(255)
	,amount MONEY
	,note VARCHAR(255)
	,[date] DATETIME
	)

INSERT INTO #list (
	type
	,[group]
	,category
	,merchant
	,amount
	,note
	,[date]
	)
SELECT ts.type
	,ts.[group]
	,ts.category
	,ts.merchant
	,ts.amount
	,ts.note
	,ts.[date]
FROM dbo.transaction_seed AS ts

DECLARE
	-- loop vars
	@min_id INT = ISNULL((
			SELECT MIN(l.row_id)
			FROM #list AS l
			), 0)
	,@max_id INT = ISNULL((
			SELECT MAX(l.row_id)
			FROM #list AS l
			), 0)
	-- my vars
	,@this_type VARCHAR(255)
	,@this_group VARCHAR(255)
	,@this_category VARCHAR(255)
	,@this_merchant VARCHAR(255)
	,@this_amount MONEY
	,@this_note VARCHAR(255)
	,@this_date DATETIME
	-- my keys
	,@this_type_id INT
	,@this_group_id INT
	,@this_category_id INT
	,@this_merchant_id INT

WHILE (@min_id <= @max_id)
BEGIN
	-- setup
	SET @this_type_id = NULL
	SET @this_group_id = NULL
	SET @this_category_id = NULL
	SET @this_merchant_id = NULL

	-- init
	SELECT @this_type = l.[type]
		,@this_group = l.[group]
		,@this_category = l.category
		,@this_merchant = l.merchant
		,@this_amount = l.amount
		,@this_note = l.note
		,@this_date = l.[date]
	FROM #list AS l
	WHERE l.row_id = @min_id

	-- magic
	/*
		type
	*/
	IF (@this_type LIKE '%expense%')
	BEGIN
		SET @this_type = 'Expense'
	END

	-- check
	SELECT @this_type_id = t.[type_id]
	FROM dbo.[type] AS t WITH (NOLOCK)
	WHERE t.label = @this_type

	-- add 
	IF (@this_type_id IS NULL)
	BEGIN
		INSERT INTO dbo.[type] (label)
		VALUES (@this_type)

		SET @this_type_id = SCOPE_IDENTITY()
	END

	/*
		group
	*/
	-- check
	SELECT @this_group_id = g.[group_id]
	FROM dbo.[group] AS g WITH (NOLOCK)
	WHERE g.label = @this_group

	-- add
	IF (@this_group_id IS NULL)
	BEGIN
		INSERT INTO dbo.[group] (label)
		VALUES (@this_group)

		SET @this_group_id = SCOPE_IDENTITY()
	END

	/*
		category
	*/
	-- check 
	SELECT @this_category_id = c.[category_id]
	FROM dbo.[category] AS c WITH (NOLOCK)
	WHERE c.label = @this_category

	-- add 
	IF (@this_category_id IS NULL)
	BEGIN
		INSERT INTO dbo.[category] (label)
		VALUES (@this_category)

		SET @this_category_id = SCOPE_IDENTITY()
	END

	/*
		merchant
	*/
	IF (
			@this_merchant IN (
				'UBAM Venmo'
				,'UBAM Stamps'
				,'UBAM Canva'
				,'UBAM Project Broadcast'
				,'UBAM Zoom'
				,'UBAM USPS'
				,'UBAM Stamps.com'
				)
			)
	BEGIN
		SET @this_merchant = REPLACE(@this_merchant, 'UBAM ', '')
	END

	IF (@this_merchant IN ('Stamps'))
	BEGIN
		SET @this_merchant = REPLACE(@this_merchant, 'Stamps', 'Stamps.com')
	END

	IF (@this_note LIKE '%usps%')
	BEGIN
		SET @this_merchant = 'USPS'
	END
	ELSE IF (@this_note LIKE '%zoom%')
	BEGIN
		SET @this_merchant = 'Zoom'
	END
	ELSE IF (@this_note LIKE '%paypal%')
	BEGIN
		SET @this_merchant = 'PayPal'
	END
	ELSE IF (@this_note LIKE '%venmo%')
	BEGIN
		SET @this_merchant = 'Venmo'
	END
	ELSE IF (@this_note LIKE '%fedex%')
	BEGIN
		SET @this_merchant = 'Fedex'
	END
	ELSE IF (@this_note LIKE '%canva%')
	BEGIN
		SET @this_merchant = 'Canva'
	END
	ELSE IF (@this_note LIKE '%stamp%')
	BEGIN
		SET @this_merchant = 'Stamps.com'
	END
	ELSE IF (@this_note LIKE '%amazon%')
	BEGIN
		SET @this_merchant = 'Amazon'
	END
	ELSE IF (@this_note LIKE '%walmart%')
	BEGIN
		SET @this_merchant = 'Walmart'
	END
	ELSE IF (@this_note LIKE '%vistaprint%')
	BEGIN
		SET @this_merchant = 'Vista Print'
	END
	ELSE IF (@this_note LIKE '%dollartree%')
	BEGIN
		SET @this_merchant = 'Dollar Tree'
	END
	ELSE IF (@this_note LIKE '%ups%')
	BEGIN
		SET @this_merchant = 'UPS'
	END
	ELSE IF (@this_note LIKE '%broadcast%')
	BEGIN
		SET @this_merchant = 'Project Broadcast'
	END

	-- check 
	SELECT @this_merchant_id = m.[merchant_id]
	FROM dbo.[merchant] AS m WITH (NOLOCK)
	WHERE m.label = @this_merchant

	-- add 
	IF (@this_merchant_id IS NULL)
	BEGIN
		INSERT INTO dbo.[merchant] (label)
		VALUES (@this_merchant)

		SET @this_merchant_id = SCOPE_IDENTITY()
	END

	-- add transaction
	INSERT INTO dbo.[transaction] (
		[type_id]
		,group_id
		,category_id
		,merchant_id
		,amount
		,note
		,[date]
		)
	VALUES (
		@this_type_id
		,@this_group_id
		,@this_category_id
		,@this_merchant_id
		,@this_amount
		,@this_note
		,@this_date
		)

	-- next
	SELECT @min_id = @min_id + 1
END

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
WHERE t.group_id = 2
ORDER BY t.[date] ASC
