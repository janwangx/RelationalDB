USE  classiscModels;

--find all tables having foreign key constraint
select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where CONSTRAINT_NAME like 'fk_%'

--drop the foreign keys on tables
Alter table dbo.tblOrderDetails DROP CONSTRAINT fk_tblOrderDetails_tblProducts
Alter table dbo.tblCustomers DROP CONSTRAINT fk_employee_id
Alter table dbo.tblEmployees DROP CONSTRAINT fk_offices_ofcCode
Alter table dbo.tblOrders DROP CONSTRAINT fk_tblOrders_tblCustomers
Alter table dbo.tblProducts DROP CONSTRAINT fk_tblProducts_tblPayments

