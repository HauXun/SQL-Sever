USE HowKteam
GO

BEGIN TRANSACTION
DELETE dbo.NGUOITHAN WHERE TEN = N'Dần'
-- Chuỗi thao tác loằn ngoằn phức tạp
ROLLBACK -- Hủy bỏ Transaction
GO

BEGIN TRANSACTION
DELETE dbo.NGUOITHAN WHERE TEN = N'Dần'
-- Chuỗi thao tác loằn ngoằn
COMMIT -- Chấp nhận Transaction
GO

---------------------------------------------------------

-- Đặt tên cho Transaction
DECLARE @Trans VARCHAR(20) = 'Trans'

BEGIN TRANSACTION @Trans
DELETE dbo.NGUOITHAN WHERE TEN = 'Dần'
-- Chuỗi thao tác loằn ngoằn phức tạp
COMMIT TRANSACTION @Trans -- Chấp nhận Transaction
GO
---------------------------------------------------------

BEGIN TRANSACTION

SAVE TRANSACTION Transaction_1
DELETE dbo.NGUOITHAN WHERE TEN = 'Dần 1'

SAVE TRANSACTION Transaction_2
DELETE dbo.NGUOITHAN WHERE TEN = 'Dần 2'

ROLLBACK TRANSACTION Transaction_2