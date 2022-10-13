
create database sample1
use sample1
create table tblOrders
(
	OrderID int primary key identity(1,1) not null,
	OrderApprovalDateTime datetime,
	OrderStatus Varchar(30)
)

Create table tblOrderAudit(
OrderAuditID int primary key identity(1,1) not null,
OrderID int ,
OrderApprovalDateTime datetime,
OrderStatus varchar(30),
UpdatedBy varchar(30),
UpdatedOn datetime
)

	   ---------store procedure in peramitter-----
	   drop proc sp_tblOrders_insert
	   go

		create proc sp_tblOrders_insert
			@OrderApprovalDateTime datetime,
			@OrderStatus Varchar(30)
		as 
		begin 
			insert into tblOrders(OrderApprovalDateTime,OrderStatus) 
			values(@OrderApprovalDateTime,@OrderStatus)
		end
------execute procedure-----
exec sp_tblOrders_insert '2022-10-02 10:00','approval'
select * from tblOrders

---------store procedure out peramitter-----
drop proc sp_output_peramitter

create proc sp_output_peramitter
@EmployeeName varchar(50) output
as 
begin 
select @EmployeeName=count(OrderID) from tblOrders
end
------execute output procedure-----
declare @EmployeeName varchar(50)
execute sp_output_peramitter @EmployeeName output
print @EmployeeName
----------return perametter------------
drop proc sp_return_peramitter
create proc sp_return_peramitter
as 
begin
return (select count(OrderID) from tblOrders)
end
-------exicute return peramitter--------
declare @total int 
execute @total=sp_return_peramitter
print  @total

--------------function-------------

---------------table value function----------------
drop function fn_table_tblorders
create function fn_table_tblorders
()
returns table 
return
(
select * from tblOrders
)
select * from fn_table_tblorders();

-----------scelar function-------------
drop function fn_scelartable
create function fn_scelartable
()
returns table 
return
(
select  count(orderid) as sumprice from tblOrders
)

select * from fn_scelartable();
-------------multi table statement function------------
create function multi_table
()
returns @multi table(orderid int,OrderApprovalDateTime datetime,OrderStatus varchar(50))
begin 
  insert into @multi( orderid,OrderApprovalDateTime,OrderStatus)
  select OrderID, OrderApprovalDateTime,OrderStatus
  from tblOrders
  return;
 end
select * from multi_table();
select * from tblOrders

-------------------after trigger--------------------
Create Trigger tblTriggerAuditRecord
on tblOrders
after update, insert
as
begin
	insert into tblOrderAudit(OrderID,OrderApprovalDateTime,OrderStatus,UpdatedBy,UpdatedOn)
	select i.OrderID,i.OrderApprovalDateTime,i.OrderStatus,SUSER_SNAME(),getdate()
	from tblOrders t
	inner join inserted i on t.orderID=i.orderID
end
go 

insert into tblOrders values(Null,'Pending'),
					(Null,'Pending'),
					(Null,'Pending')


	select* from tblOrders
	select* from tblOrderAudit

	update tblOrders
	set OrderStatus='Approved', OrderApprovalDateTime=getdate()
	where OrderID=2

	update tblOrders
	set OrderStatus='Cancelled', OrderApprovalDateTime=getdate()
	where OrderID=1

	-------------------instead of trigger---------------
	CREATE TABLE [dbo].[Customer](

       [ID] [int] primary key IDENTITY(1,1) NOT NULL,

       [Name] [nvarchar](50) NULL,

       [Phone] [varchar](15) NULL

       );
       INSERT [dbo].[Customer] ([Name], [Phone]) VALUES (N'Solaiman', N'01987654231')

       INSERT [dbo].[Customer] ([Name], [Phone]) VALUES (N'Razib', N'01857564567')

       INSERT [dbo].[Customer] ([Name], [Phone]) VALUES (N'Nasir', N'01578975674')

       INSERT [dbo].[Customer] ([Name], [Phone]) VALUES (N'Akram', N'0157897681')

       CREATE TABLE [dbo].[CustomerLogs](

       [LogId] [int] IDENTITY(1,1) NOT NULL,

       [CustomerId] [int] NULL,

       [ACTION] [varchar](50) NULL);

 create TRIGGER [dbo].[Customer_InsteadOfDELETE]

       ON [dbo].[Customer]

INSTEAD OF DELETE
AS
BEGIN
       SET NOCOUNT ON;
       DECLARE @CustomerId INT
       SELECT @CustomerId = DELETED.ID      
       FROM DELETED
       IF @CustomerId = 2
       BEGIN
              RAISERROR('ID 2 record cannot be deleted',16 ,1)
              ROLLBACK
              INSERT INTO CustomerLogs
              VALUES(@CustomerId, 'Record cannot be deleted.')

       END
       ELSE
       BEGIN
              DELETE FROM Customer
              WHERE ID = @CustomerId
              INSERT INTO CustomerLogs
              VALUES(@CustomerId, 'Instead Of Delete')
       END
END

 

select * from Customer
select * from CustomerLogs
delete from Customer where ID = 4



