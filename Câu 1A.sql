create proc lab5_cau1_a @name nvarchar(20)
as
	begin
		print 'welcome to đại học nhàn lắm: ' + @name
	end
exec lab5_cau1_a 'Đoan Trang'
go