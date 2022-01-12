
USE  classiscModels;

DROP TABLE IF EXISTS tblOffice
GO
create table tblOffice(
officeCode char(10),
city varchar(30) not null,
phone varchar(30),
addressLine1 varchar(30),
addressLine2 varchar(30),
state varchar(30),
country varchar(30),
postalCode varchar(30) not null,
territory varchar(30),
CONSTRAINT pk_officeCode primary key (officeCode),
);

IF EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='tblEmployees' and TABLE_SCHEMA='dbo')
drop table dbo.tblEmployees;
GO
--one to many in between office and tblEmployees, so officeCode will come as a foreign key
create table tblEmployees(
employeeNumber int,
lastName varchar(30),
firstName varchar(30) not null,
extension int,
email varchar(250),
ofcCode char(10),
--reports to manager unary relationship, it is the emp Number
reportsTo int  not null,
jobTitle varchar(250) not null,

CONSTRAINT pk_employee_empId primary key(employeeNumber),
CONSTRAINT fk_offices_ofcCode foreign key(ofcCode) references tblOffice(officeCode) 
on delete cascade,
);

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME= 'tblCustomers' and TABLE_SCHEMA='dbo')
drop table tblCustomers;
GO

create table tblCustomers(
customerNumber int,
customerName varchar(250) not null,
contactLastName varchar(250) ,
ContactFirstName varchar(250),
phone char(10) not null,
addressLine1 varchar(250),
addressLine2 varchar(250),
city varchar(250),
state varchar(250),
postalCode char(10),
country varchar(250),
salesRepemployeeNumber int,
creditLimit money, 

CONSTRAINT pk_customer_id primary key(customerNumber),
CONSTRAINT fk_employee_id foreign key(salesRepemployeeNumber) references tblEmployees(employeeNumber) on delete set null,
);

if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='tblPayments' and TABLE_SCHEMA='dbo')
drop table tblPayments;
Go
create table tblPayments(
customerNumber int,
checkNumber int not null,
paymentDate date not null,
amount money check(amount > 0),

CONSTRAINT fk_customer_id foreign key(customerNumber) references tblCustomers(customerNumber),
CONSTRAINT pk_payments_cusID_checkNo primary key(customerNumber,checkNumber),
);

if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'tblPayments' and TABLE_SCHEMA='dbo')
drop table tblPayments;
go
create table tblPayments(
productLine int,
textDescription varchar(500),
htmlDescription varchar(1000),
image varbinary(max),

CONSTRAINT pk_tblPayments primary key(productLine),
);

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='tblProducts' and TABLE_SCHEMA ='dbo')
drop table tblProducts;
go

create table tblProducts(
productCode varchar(30),
productName varchar(50) not null,
productScale int,
productVandor varchar(100),
productDescription varchar(500),
quantityInStock int not null,
buyPrice money not null check(buyPrice > 0),
--Manufacturer's Suggested Retail Price
msrp money not null,
prodLine int,

CONSTRAINT pk_tblProducts primary key(productCode),
CONSTRAINT fk_tblProducts_tblPayments foreign key(prodLine)references tblPayments(productLine),

);

if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='tblOrderDetails' and TABLE_SCHEMA='dbo')
drop table tblOrderDetails;
GO
create table tblOrderDetails(
orderNumber int,
productCode varchar(30),
qunatityOrdered int not null,
priceEach money,
OrderLineNumber int not null,

CONSTRAINT pk_tblOrderDetails primary key(orderNumber),
CONSTRAINT fk_tblOrderDetails_tblProducts foreign key(productCode) references tblProducts(productCode),
);

if exists( select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME='tblOrders' and TABLE_SCHEMA='dbo')
drop table tblOrders;
GO
create table tblOrders(
orderNumber int,
orderDate date not null,
requiredDate date not null,
shippedDate date,
status varchar(50),
comments text,
customerNumber int ,

CONSTRAINT pk_tblOrders primary key(orderNumber),
);
-- adding a contraint later once the table is already there in the database
ALter table tblOrders 
ADD CONSTRAINT fk_tblOrders_tblCustomers foreign key(customerNumber) references tblCustomers(customerNumber);



