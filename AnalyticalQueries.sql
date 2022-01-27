--1. maximun credit amount of each country.
select * ,
max(creditLimit) over (partition by country order by country) as	MaxCredit
from tblCustomers

--2. top two employees who has maxmim credit amount of each country
select *
from (select * ,
ROW_NUMBER() over (partition by country order by creditLimit desc) as	Id
from tblCustomers) temp
where temp.Id in (1,2)

--3.second highest paid amount from the payment table.
--option 1
select * from tblPayments
order by amount desc
offset 1 rows
fetch next 1 rows only

--option2
select top 1 * from tblPayments
where amount <> (select max(amount) from tblPayments)
order by amount desc

--option 3
select *
from (select * ,
ROW_NUMBER() over (order by amount desc) as	rowId
from tblPayments) temp
where temp.rowId = 2

--4. finding running total/cumulative frequency for amount in payment table
select *, 
sum(amount) over(order by amount) as runningTotal
from tblPayments

-- 4.1 finding running total/cumulative frequency for quantity in stock from tblProduct table
select productCode,quantityInStock,
sum(quantityInStock) over (order by productName ) as runningTotal
from tblProducts

-- 5. finding running total/cumulative frequency for quantity in stock from tblProduct table
--for each product line
select productCode,quantityInStock,prodLine,
sum(quantityInStock) over (partition by prodLine order by productName ) as runningTotal
from tblProducts

--6. ranking employees based on their creditLimit 
--use rank(), Row_number
select *,
dense_rank() over(order by creditLimit desc) as empRank
from tblCustomers

--7. select sub total of payments by date 
select *,
sum(amount)over(partition by paymentDate order by paymentDate) as subtot
from tblpayments

--8. common table expressions/CTES
WITH 
qunatity_CTE (productCode,qStatus)  AS  
(  
    select productCode,
	case 
	when quantityInStock > 5000 then 'enough stock'
	when quantityInStock between 2000 and 5000 then 'Order within 6 months'
	when quantityInStock < 2000 then 'immediate order'
	end
	from tblProducts
)  
SELECT p.productCode, p.quantityInStock, Qte.qStatus
FROM tblProducts as p
inner join qunatity_CTE as Qte
on p.productCode = Qte.productCode

--9. lets find the customers whose creditlimit is greater than average amount
--take the maximum/minimum of each state
--take average of each state from above customers
--rank customer within state
with 
UpperAvgCutomers(cusName, cusState,payamount) as
(
select cus.customerName,  cus.state ,pay.amount
from tblPayments pay
inner join tblCustomers  cus
on pay.customerNumber = cus.customerNumber
where pay.amount > (select avg(amount) from tblPayments)
)
select *,
max(payamount) over(partition by cusState order by payamount
range between unbounded preceding and unbounded following) as maxAmountonState,
Min(payamount) over(partition by cusState order by payamount
range between unbounded preceding and unbounded following) as minAmountonState,
Avg(payamount) over(partition by cusState order by payamount
range between unbounded preceding and unbounded following) as avgOnState,
dense_rank() over(partition by cusState order by payamount desc) as CusRank
from UpperAvgCutomers
where cusState is not null



