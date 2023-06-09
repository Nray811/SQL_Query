﻿Use Northwind
-- 找出和最貴的產品同類別的所有產品
SELECT  * from 
Products p
WHERE p.CategoryID =  
(       
	SELECT Top 1 CategoryID
	FROM Products
	ORDER BY UnitPrice DESC
)
Order by UnitPrice Desc
-- 找出和最貴的產品同類別最便宜的產品
SELECT top 1 * from 
Products p
WHERE p.CategoryID =  
(       
	SELECT Top 1 CategoryID
	FROM Products
	ORDER BY UnitPrice DESC
)
order by UnitPrice
--offset  0 rows
--fetch next 1 rows only
-- 計算出上面類別最貴和最便宜的兩個產品的價差
SELECT MAX(p.UnitPrice) - MIN(p.UnitPrice) as 價差
FROM Products p, Categories c
WHERE c.CategoryID =
(
SELECT p.CategoryID
FROM Products p
WHERE p.UnitPrice =
(
SELECT MAX(UnitPrice)
FROM Products p
))

-- 找出沒有訂過任何商品的客戶所在的城市的所有客戶
Select *
from Customers c
Where not exists(
	select * from Orders
	Where CustomerID = c.CustomerID
)
--找出第5貴和第8便宜的產品的產品類別
With tb AS (
	SELECT
		ProductID , ProductName, UnitPrice,CategoryID ,
		row_NUMBER() OVER (
			ORDER BY UnitPrice DESC
		) AS NoDesc,
		ROW_NUMBER() OVER (
			ORDER BY UnitPrice 
		) AS NoAsc
	FROM Products p
)
SELECT c.CategoryID , c.CategoryName   FROM tb
INNER JOIN Categories c ON tb.CategoryID = c.CategoryID
WHERE NoDesc = 5  OR NoAsc = 8 
order by UnitPrice desc
-- 找出誰買過第 5 貴跟第 8 便宜的產品
With tb as (
	SELECT
		ProductID, ProductName, UnitPrice,CategoryID,
		ROW_NUMBER() OVER (
			ORDER BY UnitPrice DESC
		) AS Expensive,
		ROW_NUMBER() OVER (
			ORDER BY UnitPrice 
		) AS Cheap
	FROM Products p
)
SELECT c.CustomerID, od.ProductID
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.ProductID IN (
	SELECT ProductID FROM tb
	WHERE Expensive = 5 OR Cheap = 8
)
-- 找出誰賣過第 5 貴跟第 8 便宜的產品
WITH tb AS (
	SELECT
		ProductID, ProductName, UnitPrice,CategoryID,
		ROW_NUMBER() OVER (
			ORDER BY UnitPrice DESC
		) AS Expensive,
		ROW_NUMBER() OVER (
			ORDER BY UnitPrice 
		) AS Cheap
	FROM Products
)
SELECT e.EmployeeID ,ProductID
FROM Employees e
INNER JOIN Orders o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE od.ProductID IN (
SELECT ProductID
FROM tb
WHERE Expensive = 5 Or Cheap = 8
)
-- 找出 13 號星期五的訂單 (惡魔的訂單)
Select * from  Orders o
Where
 (DATEPART(day, OrderDate) = 13 and  DATEPART(weekday, OrderDate) = 6)
select datename(weekday, '1996-09-13')
-- 找出誰訂了惡魔的訂單
Select CustomerID from  Orders o
Where  
 (DATEPART(day, OrderDate) = 13 and  DATEPART(weekday, OrderDate) = 6)
 
-- 找出惡魔的訂單裡有什麼產品
Select  distinct  p.ProductID , p.ProductName
from  Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID
Where  
 (DATEPART(day, OrderDate) = 13 and  DATEPART(weekday, OrderDate) = 6)

-- 列出從來沒有打折 (Discount) 出售的產品
Select * From [Order Details]
Where discount = 0
-- 列出購買非本國的產品的客戶
SELECT distinct c.CustomerID , c.ContactName FROM Customers c
inner join Orders o on o.CustomerID= c.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
Where (
	s.Country != c.Country
)
-- 列出在同個城市中有公司員工可以服務的客戶
Select c.CustomerID , c.ContactName
From Employees e
INNER JOIN Customers c On e.City = c.City
-- 列出那些產品沒有人買過
Select p.ProductID From Products p
Where not exists(
Select od.ProductID
From [Order Details] od
)


----------------------------------------------------------------------------------------
-- 列出所有在每個月月底的訂單
	select distinct * from Orders
	where OrderDate =  EOMONTH(OrderDate)
-- 列出每個月月底售出的產品
	select distinct p.ProductID, p.ProductName
	from Orders o 
	inner join [Order Details] od on o.OrderID = od.OrderID
	inner join Products p on od.ProductID = p.ProductID
	where OrderDate = EOMONTH(OrderDate)
	order by ProductID desc
-- 找出有敗過最貴的三個產品中的任何一個的前三個大客戶

-- 找出有敗過銷售金額前三高個產品的前三個大客戶

-- 找出有敗過銷售金額前三高個產品所屬類別的前三個大客戶

-- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及客戶的消費總金額

-- 列出最熱銷的產品，以及被購買的總金額

-- 列出最少人買的產品

-- 列出最沒人要買的產品類別 (Categories)

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (含購買其它供應商的產品)

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品)

-- 列出那些產品沒有人買過

-- 列出沒有傳真 (Fax) 的客戶和它的消費總金額

-- 列出每一個城市消費的產品種類數量

-- 列出目前沒有庫存的產品在過去總共被訂購的數量

-- 列出目前沒有庫存的產品在過去曾經被那些客戶訂購過

-- 列出每位員工的下屬的業績總金額

-- 列出每家貨運公司運送最多的那一種產品類別與總數量

-- 列出每一個客戶買最多的產品類別與金額

-- 列出每一個客戶買最多的那一個產品與購買數量

-- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間

-- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距

