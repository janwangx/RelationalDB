USE classiscModels

Go
BULK
INSERT tblOrders
--add the correct file path
FROM 'E:\Janwang\RelationalDB\OrderData.csv'
WITH
(
FIELDTERMINATOR = '|',
ROWTERMINATOR = '\n'
)
