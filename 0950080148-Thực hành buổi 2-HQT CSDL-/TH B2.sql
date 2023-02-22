use AdventureWorks2008R2
--Bài 1:
--1) Liệt kê danh sách các hóa đơn (SalesOrderID) lặp trong tháng 6 năm 2008 có
--tổng tiền >70000, thông tin gồm SalesOrderID, Orderdate, SubTotal, trong đó
--SubTotal =sum(OrderQty*UnitPrice).
select t.SalesOrderID, OrderDate, SubTotal=sum(OrderQty * UnitPrice)
	from Sales.SalesOrderDetail t join Sales.SalesOrderHeader h on t.SalesOrderID = h.SalesOrderID
	where  month(OrderDate) = 6 and year(OrderDate) = 2008  
	group by t.SalesOrderID, OrderDate
	having SUM(OrderQty * UnitPrice) > 70000
--Bài 2:
--Đếm tổng số khách hàng và tổng tiền của những khách hàng thuộc các quốc gia
--có mã vùng là US (lấy thông tin từ các bảng SalesTerritory, Sales.Customer,
--Sales.SalesOrderHeader, Sales.SalesOrderDetail). Thông tin bao gồm
--TerritoryID, tổng số khách hàng (countofCus), tổng tiền (Subtotal) với Subtotal
--= SUM(OrderQty*UnitPrice)
select t.TerritoryID, CountofCus= COUNT(c.CustomerID) , Subtotal=SUM(d.OrderQty * d.UnitPrice)  
	from Sales.SalesTerritory t join Sales.Customer  c on t.TerritoryID=c.TerritoryID
								join Sales.SalesOrderHeader h on h.CustomerID=h.CustomerID
								join Sales.SalesOrderDetail d on h.SalesOrderID=d.SalesOrderID
	where CountryRegionCode = 'US' 
	group by t.TerritoryID
--Bài 3:
--Tính tổng trị giá của những hóa đơn với Mã theo dõi giao hàng (CarrierTrackingNumber) có 3 ký tự đầu là 4BD, 
-- thông tin bao gồm SalesOrderID, CarrierTrackingNumber, SubTotal=sum(OrderQty*UnitPrice)  
select ssod.SalesOrderID, ssod.CarrierTrackingNumber, SUM(OrderQty*UnitPrice) as 'SubTotal'
from sales.SalesOrderDetail as ssod
group by ssod.SalesOrderID,ssod.CarrierTrackingNumber
having ssod.CarrierTrackingNumber like '4BD%'
--Bài 4:
select pro.ProductID, pro.Name, AverageofQty=AVG(det.OrderQty) 
from Sales.SalesOrderDetail det join Production.Product pro on det.ProductID = pro.ProductID
	where det.UnitPrice < 25
	group by pro.ProductID, pro.Name
	having AVG(det.OrderQty) > 5
--Bài 5:
select JobTitle, CountofEmployee=count(BusinessEntityID) 
	from HumanResources.Employee 
	group by JobTitle
	having COUNT(BusinessEntityID) > 20
--Bài 6:
select v.BusinessEntityID, v.Name, ProductID, sumofQty = SUM(OrderQty), SubTotal = SUM(OrderQty * UnitPrice)
	from Purchasing.Vendor v join Purchasing.PurchaseOrderHeader h on h.VendorID = v.BusinessEntityID
							 join Purchasing.PurchaseOrderDetail d on h.PurchaseOrderID = d.PurchaseOrderID
	where v.Name like '%Bicycles'
	group by v.BusinessEntityID, v.Name, ProductID
	having SUM(OrderQty * UnitPrice) > 800000	
--Bài 7:
select distinct ProductID, UnitPrice
from Sales.SalesOrderDetail
where UnitPrice>=all (select distinct UnitPrice
					 from Sales.SalesOrderDetail)
--Bài 8:
select P.productID, Name
from Production.Product p left join Sales.SalesOrderDetail d on p.ProductID=d.ProductID
where d.ProductID is null

select productID, Name
from Production.Product
where productID not in (select productID 
						from Sales.SalesOrderDetail)

select productID, Name
from Production.Product p
where not exists (select productID 
				  from Sales.SalesOrderDetail
				  where p.ProductID=ProductID)
--Bài 9:
select [BusinessEntityID] as EmployeeID, FirstName, LastName
from [Person].[Person]
where [BusinessEntityID]  in (select [SalesPersonID]
								 from [Sales].[SalesOrderHeader]
								 where [OrderDate]>'2008-5-1'
								 )

--Bài 10:
select [CustomerID]
from [Sales].[SalesOrderHeader]
where [CustomerID] in (select [CustomerID]
					   from [Sales].[SalesOrderHeader]
					   where year([OrderDate])=2007 )  
	and [CustomerID] not in (select [CustomerID]
					   from [Sales].[SalesOrderHeader]
					   where year([OrderDate])=2008)


