
USE  classiscModels;
--drop table if exists tblOffice,tblEmployees ,tblCustomers, tblPayments,tblProductLines,tblProducts,tblOrderDetails, tblOrders;

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

--one to many in between office and tblEmployees, so officeCode will come as a foreign key
create table tblEmployees(
employeeNumber int,
lastName varchar(30),
firstName varchar(30) not null,
extension int,
email varchar(250),
ofcCode char(10),
--reports to manager unary relationship, it is the emp Number
reportsTo int default not null,
jobTitle varchar(250) not null,

CONSTRAINT pk_employee_empId primary key(employeeNumber),
CONSTRAINT fk_offices_ofcCode foreign key(ofcCode) references tblOffice(officeCode) 
on delete cascade,
);


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


create table tblPayments(
customerNumber int,
checkNumber int not null,
paymentDate date not null,
amount money check(amount > 0),

CONSTRAINT fk_customer_id foreign key(customerNumber) references tblCustomers(customerNumber),
CONSTRAINT pk_payments_cusID_checkNo primary key(customerNumber,checkNumber),
);

create table tblProductLines(
productLine int,
textDescription varchar(500),
htmlDescription varchar(1000),
image varbinary(max),

CONSTRAINT pk_tblProductLines primary key(productLine),
);

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
CONSTRAINT fk_productLine_prdLine foreign key(prodLine)references tblProductLines(productLine),

);

create table tblOrderDetails(
orderNumber int,
productCode varchar(30) foreign key references tblProducts(productCode),
qunatityOrdered int not null,
priceEach money,
OrderLineNumber int not null,

CONSTRAINT pk_tblOrderDetails primary key(orderNumber),
CONSTRAINT fk_prdCode
);

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
-- adding a contraint after generating the table
ALter table tblOrders 
ADD CONSTRAINT fk_tblOrders_tblCustomers foreign key(customerNumber) references tblCustomers(customerNumber);

--view all keys
select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE
where constraint_name like 'fk_%'

