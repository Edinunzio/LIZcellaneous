USE [cts_data_mat] -- what database to use
GO
/****** Object:  StoredProcedure [dbo].[proc_Reporting_Merchandising_SellableProductsMerchandisedByWebCategory]    Script Date: 04/02/2014 10:44:45 ******/
SET ANSI_NULLS ON --When SET ANSI_NULLS is ON, a SELECT statement that uses WHERE column_name = NULL returns zero rows even if there are null values in column_name. A SELECT statement that uses WHERE column_name <> NULL returns zero rows even if there are nonnull values in column_name.
GO --SQL Server utilities interpret GO as a signal that they should send the current batch of Transact-SQL statements to an instance of SQL Server. The current batch of statements is composed of all statements entered since the last GO, or since the start of the ad hoc session or script if this is the first GO.
SET QUOTED_IDENTIFIER ON --When SET QUOTED_IDENTIFIER is ON, identifiers can be delimited by double quotation marks, and literals must be delimited by single quotation marks. When SET QUOTED_IDENTIFIER is OFF, identifiers cannot be quoted and must follow all Transact-SQL rules for identifiers. SET QUOTED_IDENTIFIER must be ON when you are creating or changing indexes on computed columns or indexed views. SET QUOTED_IDENTIFIER must be ON when you are creating a filtered index. SET QUOTED_IDENTIFIER must be ON when you invoke XML data type methods.
GO

ALTER PROCEDURE [dbo].[proc_Reporting_Merchandising_SellableProductsMerchandisedByWebCategory] --Alters a previously created procedure, created by executing the CREATE PROCEDURE statement, without changing permissions and without affecting any dependent stored procedures or triggers. 
AS
BEGIN -- this and END are used to group statements into a logical block.

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; --controls locking and row versioning behavior
	-- READ UNCOMMITTED = Specifies that statements can read rows that have been modified by other transactions but not yet committed.
	
	SET NOCOUNT ON; --Stops the message that shows the count of the number of rows affected by a Transact-SQL statement or stored procedure from being returned as part of the result set.
	
	
	SELECT	LocationBreadcrumbUrl =
			LOWER(
				REPLACE(
					REPLACE(
						REPLACE(plg.LocationBreadcrumb, N'&', 'and'),
						N'  ', N' '),
					N' ', N'-')), -- this looks like it removes white space and replaces with a '-' and is also swaps out '&' with 'and'
			LocationFolderId = plg.FolderId,
			ProductId = pa.ProductId,
			p.ProductDescription
	FROM	dbo.ProductAvailability_global pa
			JOIN dbo.ProductLocationGenerated plg	ON pa.ProductId = plg.ProductId
			JOIN dbo.Products p						ON pa.ProductId = p.ProductId
			-- Add a join (and fancy XML T-SQL code) to the dbo.FileVersions table to determine the ranking.
	WHERE	pa.HasStock = 1
			AND pa.ColorInStockHasImagery = 1
			AND pa.HasWebTitle = 1
			AND pa.HasRetailPrice = 1
			AND pa.Sellable = 1
	ORDER BY LocationBreadcrumbUrl;

END
