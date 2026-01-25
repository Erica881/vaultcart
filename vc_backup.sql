USE [master]
GO
/****** Object:  Database [VaultCartDB]    Script Date: 1/2/2026 6:34:21 AM ******/
CREATE DATABASE [VaultCartDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'VaultCart_Data', FILENAME = N'C:\asm\SQLData\VaultCartDB.mdf' , SIZE = 102400KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'VaultCartDB_Log', FILENAME = N'C:\asm\SQLLogs\VaultCartDB.ldf' , SIZE = 51200KB , MAXSIZE = 2097152KB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [VaultCartDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [VaultCartDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [VaultCartDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [VaultCartDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [VaultCartDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [VaultCartDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [VaultCartDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [VaultCartDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [VaultCartDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [VaultCartDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [VaultCartDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [VaultCartDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [VaultCartDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [VaultCartDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [VaultCartDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [VaultCartDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [VaultCartDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [VaultCartDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [VaultCartDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [VaultCartDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [VaultCartDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [VaultCartDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [VaultCartDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [VaultCartDB] SET RECOVERY FULL 
GO
ALTER DATABASE [VaultCartDB] SET  MULTI_USER 
GO
ALTER DATABASE [VaultCartDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [VaultCartDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [VaultCartDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [VaultCartDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [VaultCartDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [VaultCartDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'VaultCartDB', N'ON'
GO
ALTER DATABASE [VaultCartDB] SET ENCRYPTION ON
GO
ALTER DATABASE [VaultCartDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [VaultCartDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [VaultCartDB]
GO
/****** Object:  User [SuperAdminUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [SuperAdminUser] FOR LOGIN [Vault_SuperAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [SecOfficer]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [SecOfficer] FOR LOGIN [Vault_Security_Officer] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [OpsManager]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [OpsManager] FOR LOGIN [Vault_Ops_Manager] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [AppUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [AppUser] FOR LOGIN [Vault_App_Connect] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [SellerReaderUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [SellerReaderUser] FOR CERTIFICATE [SellReaderCert]
GO
/****** Object:  User [SellerOpsUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [SellerOpsUser] FOR CERTIFICATE [SellerOpsCert]
GO
/****** Object:  User [SalesAuthUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [SalesAuthUser] FOR CERTIFICATE [SalesAuthCert]
GO
/****** Object:  User [InventoryUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [InventoryUser] FOR CERTIFICATE [InventoryCert]
GO
/****** Object:  User [CustomerOpsUser]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE USER [CustomerOpsUser] FOR CERTIFICATE [CustomerOpsCert]
GO
/****** Object:  DatabaseRole [VaultCart_UserManager]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE ROLE [VaultCart_UserManager]
GO
/****** Object:  DatabaseRole [VaultCart_SessionManager]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE ROLE [VaultCart_SessionManager]
GO
/****** Object:  DatabaseRole [VaultCart_SalesClerk]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE ROLE [VaultCart_SalesClerk]
GO
/****** Object:  DatabaseRole [VaultCart_ReadOnly_Ops]    Script Date: 1/2/2026 6:34:22 AM ******/
CREATE ROLE [VaultCart_ReadOnly_Ops]
GO
ALTER ROLE [db_owner] ADD MEMBER [SuperAdminUser]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [SecOfficer]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [SecOfficer]
GO
ALTER ROLE [VaultCart_ReadOnly_Ops] ADD MEMBER [OpsManager]
GO
ALTER ROLE [VaultCart_SessionManager] ADD MEMBER [AppUser]
GO
ALTER ROLE [VaultCart_SalesClerk] ADD MEMBER [AppUser]
GO
ALTER ROLE [VaultCart_UserManager] ADD MEMBER [AppUser]
GO
/****** Object:  Schema [Catalog]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SCHEMA [Catalog]
GO
/****** Object:  Schema [Membership]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SCHEMA [Membership]
GO
/****** Object:  Schema [Sales]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SCHEMA [Sales]
GO
/****** Object:  Schema [Security]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SCHEMA [Security]
GO
/****** Object:  ColumnMasterKey [CMK_Auto1]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE COLUMN MASTER KEY [CMK_Auto1]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_CERTIFICATE_STORE',
	KEY_PATH = N'LocalMachine/My/0A68CD201A7DAA917E96288F73C434A31C335F45'
)
GO
/****** Object:  ColumnMasterKey [CMK_Auto2]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE COLUMN MASTER KEY [CMK_Auto2]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_CERTIFICATE_STORE',
	KEY_PATH = N'LocalMachine/my/2F1DCB8B3F071E9F2DB8E93DB786743B614ABFF2'
)
GO
/****** Object:  ColumnMasterKey [CMK_VaultCart]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE COLUMN MASTER KEY [CMK_VaultCart]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'MSSQL_CERTIFICATE_STORE',
	KEY_PATH = N'CurrentUser/My/FAFC08BED02024896835A88B985139EFB7377FC8'
)
GO
/****** Object:  ColumnEncryptionKey [CEK_Auto1]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE COLUMN ENCRYPTION KEY [CEK_Auto1]
WITH VALUES
(
	COLUMN_MASTER_KEY = [CMK_Auto2],
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x01700000016C006F00630061006C006D0061006300680069006E0065002F006D0079002F0032006600310064006300620038006200330066003000370031006500390066003200640062003800650039003300640062003700380036003700340033006200360031003400610062006600660032007DFCC210678A17A1D177D4B2BDAF560D6431DD17EB519D22F6C331E85FF24386E5C008757FD67ACE3B0B25E356C365AB92E5C93C3D199CCC3EECECDDFC0472E97D92E8E32CB981C2CFB358C47A70976B180853ED0BB8A74939A31D866E4571FD8A2655B76B249611DF6EF4F7F5E00FDD55AF5794C245D33B24DA332AFDA88FF469BB1955FEC0D7EB0CE84F6B8674603C1D86C6DED709BC062FD56BE9C123E4FC81D43E90D71EB15BEE67AB965E7E167003C026E274553AB5D3AC800C0A05D44239E7866B3F29705AC3CAFC7DB9E03EC66CB3374747593E3FAD3EAC94C155345F13021174BE85E23E378597455C8F7B25FA7C0A23843801EBD0ABF88EFFF896085237D859A896AEA5E8F0A4268D58755918842A08718450DB87A8D6E62FC67810CAD7B6DED6F6F4DB1500EF7D2F238AFAE93167287A8772313CF4E7934FE7BD6E4EDFB78D5281A422719E4EF131EBA7ABA6D656945D5CF2B1E5A9FEFB199EA502B2AF7F084EEB6527B317D5A1038DE9E39672A5CA7C49934C02D136BF7A5CB65325893D5168CAA0499CA1C8797FA56CF3D6319AD19C1C91E344ADE1A02538216396E84C08851B9CE9D8767428F650271D2D1D33604DD3BDE29C8559BED58C9AB3DDDF86E09D06B4EE7B28043553B1B843F00FFAA10145157CFCB3F50F38644D5B52F5E955AC5F6196CA24A61DCC3763564F5E367E0CB6F9575115C1AA749F00BE
)
GO
/****** Object:  ColumnEncryptionKey [CEK_Auto3]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE COLUMN ENCRYPTION KEY [CEK_Auto3]
WITH VALUES
(
	COLUMN_MASTER_KEY = [CMK_Auto1],
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x01700000016C006F00630061006C006D0061006300680069006E0065002F006D0079002F0030006100360038006300640032003000310061003700640061006100390031003700650039003600320038003800660037003300630034003300340061003300310063003300330035006600340035007BA1C595FE15CED0216502227C78403B57E55A4F4B72A1F97856CF77D253ED16165D897E5796F526264A7EDCBD491B6AAB6C5DA21D396D7A7842A796DC24187EDCF4F97E39498680BED84D67C9B26D5495DA5A42960F0C5D298409A96DFF815C02D7A499E83CFCFBD3D9D6BEDDB44B972AC103DD883BA4AE093C33D3498FB2D5D569FABA59F8A8043A34C7558DEF74A9F87B4DB6CD8059EE1EE42650A82AE34395008340504C24F2A783935A1FDA5009EB72629683C338E45CE2FDAAEBDA934C81B9B6A14E298900F8A24463A6F506490C5346A247F02E6D5177D3E84FB5E3081373F223802B84E070BEE503D16B6514DEEC33B6CE10475EF937265456C0D2985E5E11F9BAF18BF882EB3DE803A8B225DEAECFF0C48BC793C7D40F7BA4AE0269F9487818966A57A3B5CC4AAF76FB900477A21A8E0D661CF5A68AEC72248CFACF9EAB214287B9C951FFB4C3EBD2B080E2A63CAF116DEE5D4BE7D7D1A987FBC90E0CEE54FCA0528285E432BCE7405605741799BF5C9D60C9E6415A5F8727B61C78A675725DCCCD765F3C8450C0AE21BEA28110E724C18EB0442C6277BA3C23F384E2F50B246190CF0F4E11D3F563019E717D30D2A8BA8EA290657C81A4359B3FC37501024F63B50BCA0EF5CF7EC1575868E2AF5E8FF3C2715435DE0025697B486377A9CF94D1FF827CB8BDF7031EE8DCCBB619AD8EF5C265A1209311AAA2E864EA
)
GO
/****** Object:  ColumnEncryptionKey [CEK_VaultCart]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE COLUMN ENCRYPTION KEY [CEK_VaultCart]
WITH VALUES
(
	COLUMN_MASTER_KEY = [CMK_VaultCart],
	ALGORITHM = 'RSA_OAEP',
	ENCRYPTED_VALUE = 0x016E000001630075007200720065006E00740075007300650072002F006D0079002F0066006100660063003000380062006500640030003200300032003400380039003600380033003500610038003800620039003800350031003300390065006600620037003300370037006600630038001C747C959EE04237CFFED25F9DCE923421F363E8CD5F4DD8B12A2EC3C5E5C8782FB3C9500EB2BB07A003BB27847DF956B41D5ABF24A0B436A5B76F4FCCA4A5CE8743CC557DBDBEE727BDE45A23C9D4FF6ECFB07EB12E84A12CB314B98D3A76F6CB15F8D8C3BA62EB8BB5D22A00C2EB1238213E273A6CAF567420B52C1D52212D0ECC0AF0048A27FBDF811D396D3A7EC1C2773B670B77639B2C5B7312661B2D074445A6A767257217C4C29172D5C2A68617FF1A3FC1A0A8163F63EC2C57183D128169B84E835A016A78E8EBE5FEB72A94B99DA0583C229DD672BA1D0E34B69C608F67149D620B8B29FBE4C5A58CD38CAB0C23E0D45FDF11D9E21E1292D9AD3A8E7878B80C8DC2B50D54138604D1122BA8E8BF3A3374203345A69EC3F5269685FCD54BCF19B012801336FCAB00227D29F7A4552E1E14D91F3F2D281C2FD8ED73E9C10709135F33B69573DDC676C3013A521EF7DF03433F46B6A0A4722C3D9FD1DFA36D47B1D2D547AFA6D738695628808C2CE59D38988FEB265E591A74872B979D5EBBD802457C4C98C74A97CE95A520FE0D40CD67794AC9113CE3369DF5EB2B200CD8BA9B16F17D4F81666C608F06B6A6E9297C45E0AF721041E02B3E3A997C3860D43C16384EAD2ED3D2D845B538131C406A5E2F4FCD1965E4F5602A6F034E3449CCBD9834C3254D7624FEF3873435BD46DC0D2BFB9700EE7BE1E1336AA91D62
)
GO
/****** Object:  Table [Sales].[OrderItems]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[OrderItems](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[sale_price] [decimal](10, 2) NOT NULL,
	[quantity] [int] NOT NULL,
	[total_price]  AS ([sale_price]*[quantity]) PERSISTED,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Security].[SellerSessions]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[SellerSessions](
	[session_token] [uniqueidentifier] NOT NULL,
	[seller_id] [int] NOT NULL,
	[user_agent] [nvarchar](500) NOT NULL,
	[created_at] [datetime] NULL,
	[expires_at] [datetime] NULL,
	[is_active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Security].[CustomerSessions]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[CustomerSessions](
	[session_token] [uniqueidentifier] NOT NULL,
	[customer_id] [int] NOT NULL,
	[user_agent] [nvarchar](500) NOT NULL,
	[created_at] [datetime] NULL,
	[expires_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[session_token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Catalog].[Products]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Catalog].[Products](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[seller_id] [int] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[sale_price] [decimal](10, 2) NULL,
	[thumbnail_url] [nvarchar](500) NULL,
	[stock_qty] [int] NULL,
	[status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Security].[fn_OrderSecurityPredicate]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Security].[fn_OrderSecurityPredicate]
(@OrderID INT, @CustomerID INT)
RETURNS TABLE 
WITH SCHEMABINDING
AS
RETURN 
    SELECT 1 AS result
    WHERE  (EXISTS (SELECT 1
                    FROM   Security.CustomerSessions AS s
                    WHERE  s.session_token = CAST (SESSION_CONTEXT(N'SessionToken') AS UNIQUEIDENTIFIER)
                           AND s.user_agent = CAST (SESSION_CONTEXT(N'UserAgent') AS NVARCHAR (500))
                           AND s.customer_id = @CustomerID))
           OR (EXISTS (SELECT 1
                       FROM   Security.SellerSessions AS ss
                              INNER JOIN
                              Catalog.Products AS p
                              ON ss.seller_id = p.seller_id
                              INNER JOIN
                              Sales.OrderItems AS oi
                              ON p.id = oi.product_id
                       WHERE  ss.session_token = CAST (SESSION_CONTEXT(N'SessionToken') AS UNIQUEIDENTIFIER)
                              AND ss.user_agent = CAST (SESSION_CONTEXT(N'UserAgent') AS NVARCHAR (500))
                              AND oi.order_id = @OrderID))
           OR (IS_MEMBER('db_owner') = 1
               OR IS_MEMBER('VaultCart_ReadOnly_Ops') = 1)


GO
/****** Object:  Table [Sales].[Orders]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[order_date] [datetime] NULL,
	[status] [nvarchar](20) NULL,
	[total_amount] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Security].[fn_OrderItemPredicate]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Security].[fn_OrderItemPredicate]
(@ProductID INT)
RETURNS TABLE 
WITH SCHEMABINDING
AS
RETURN 
    SELECT 1 AS result
    WHERE  (EXISTS (SELECT 1
                    FROM   Security.CustomerSessions AS s
                           INNER JOIN
                           Sales.Orders AS o
                           ON s.customer_id = o.customer_id
                           INNER JOIN
                           Sales.OrderItems AS oi
                           ON o.id = oi.order_id
                    WHERE  s.session_token = CAST (SESSION_CONTEXT(N'SessionToken') AS UNIQUEIDENTIFIER)
                           AND s.user_agent = CAST (SESSION_CONTEXT(N'UserAgent') AS NVARCHAR (500))
                           AND oi.product_id = @ProductID))
           OR (EXISTS (SELECT 1
                       FROM   Security.SellerSessions AS ss
                              INNER JOIN
                              Catalog.Products AS p
                              ON ss.seller_id = p.seller_id
                       WHERE  ss.session_token = CAST (SESSION_CONTEXT(N'SessionToken') AS UNIQUEIDENTIFIER)
                              AND ss.user_agent = CAST (SESSION_CONTEXT(N'UserAgent') AS NVARCHAR (500))
                              AND p.id = @ProductID))
           OR (IS_MEMBER('db_owner') = 1
               OR IS_MEMBER('VaultCart_ReadOnly_Ops') = 1)


GO
/****** Object:  UserDefinedFunction [Security].[fn_ProductPredicate]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Security].[fn_ProductPredicate]
(@SellerID INT, @Status NVARCHAR (20))
RETURNS TABLE 
WITH SCHEMABINDING
AS
RETURN 
    SELECT 1 AS result
    WHERE  (EXISTS (SELECT 1
                    FROM   Security.SellerSessions AS ss
                    WHERE  ss.session_token = CAST (SESSION_CONTEXT(N'SessionToken') AS UNIQUEIDENTIFIER)
                           AND ss.user_agent = CAST (SESSION_CONTEXT(N'UserAgent') AS NVARCHAR (500))
                           AND ss.seller_id = @SellerID))
           OR (@Status = 'available')
           OR (IS_MEMBER('db_owner') = 1
               OR IS_MEMBER('VaultCart_ReadOnly_Ops') = 1)


GO
/****** Object:  UserDefinedFunction [Security].[fn_ProductSecurityPredicate]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [Security].[fn_ProductSecurityPredicate]
(@SellerID INT)
RETURNS TABLE 
WITH SCHEMABINDING
AS
RETURN 
    SELECT 1 AS fn_security_predicate_result
    WHERE  (EXISTS (SELECT 1
                    FROM   Security.SellerSessions AS ss
                    WHERE  ss.seller_id = @SellerID
                           AND ss.session_token = CAST (SESSION_CONTEXT(N'SessionToken') AS UNIQUEIDENTIFIER)))


GO
/****** Object:  View [dbo].[View_Order_Totals]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_Order_Totals]
AS
SELECT   o.id AS order_id,
         o.order_date,
         o.status,
         SUM(oi.total_price) AS calculated_total_amount
FROM     Orders AS o
         INNER JOIN
         OrderItems AS oi
         ON o.id = oi.order_id
GROUP BY o.id, o.order_date, o.status;

GO
/****** Object:  Table [Membership].[Customers]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[Customers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[email] [nvarchar](255) MASKED WITH (FUNCTION = 'email()') NOT NULL,
	[phone] [nvarchar](20) MASKED WITH (FUNCTION = 'partial(2, "XX-XXXX-", 2)') NULL,
	[address] [nvarchar](max) MASKED WITH (FUNCTION = 'default()') NULL,
	[passwordHash] [nvarchar](255) NOT NULL,
	[createdAt] [datetime] NULL,
	[PasswordSalt] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Membership].[Sellers]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Membership].[Sellers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) MASKED WITH (FUNCTION = 'partial(1, "XXXX", 0)') NOT NULL,
	[email] [nvarchar](255) MASKED WITH (FUNCTION = 'email()') NOT NULL,
	[CardNumber] [nvarchar](20) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = [CEK_Auto3], ENCRYPTION_TYPE = Deterministic, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NOT NULL,
	[passwordHash] [nvarchar](255) NOT NULL,
	[createdAt] [datetime] NULL,
	[PasswordSalt] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Sales].[PaymentCards]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[PaymentCards](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[card_number] [nvarchar](20) NOT NULL,
	[exp_month] [int] NULL,
	[exp_year] [int] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Sales].[Payments]    Script Date: 1/2/2026 6:34:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sales].[Payments](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[payment_card_id] [int] NULL,
	[status] [nvarchar](20) NULL,
	[payment_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  SecurityPolicy [Security].[OrderItemPolicy]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SECURITY POLICY [Security].[OrderItemPolicy] 
ADD FILTER PREDICATE [Security].[fn_OrderItemPredicate]([product_id]) ON [Sales].[OrderItems]
WITH (STATE = ON, SCHEMABINDING = ON)
GO
/****** Object:  SecurityPolicy [Security].[OrderPolicy]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SECURITY POLICY [Security].[OrderPolicy] 
ADD FILTER PREDICATE [Security].[fn_OrderSecurityPredicate]([id],[customer_id]) ON [Sales].[Orders]
WITH (STATE = ON, SCHEMABINDING = ON)
GO
/****** Object:  SecurityPolicy [Security].[ProductFilter]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE SECURITY POLICY [Security].[ProductFilter] 
ADD FILTER PREDICATE [Security].[fn_ProductSecurityPredicate]([seller_id]) ON [Catalog].[Products],
ADD BLOCK PREDICATE [Security].[fn_ProductSecurityPredicate]([seller_id]) ON [Catalog].[Products]
WITH (STATE = ON, SCHEMABINDING = ON)
GO
SET IDENTITY_INSERT [Membership].[Customers] ON 

INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (10, N'dd', N'dd@s.com', NULL, N'No Address', N'430A642E2C4C23696CFCD6E79CBF8DEC1DEC47417078231EFDCD11627968E4D038C975097613A4718382D6D45886C47F5C00DD7722ADD9F8A79574BD42B79F37', CAST(N'2026-01-01T21:42:03.700' AS DateTime), N'f7fb8a25-6cac-46bb-b4be-c7c95453a742')
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (11, N'rr', N'rr@wa.com', NULL, N'No Address', N'E9285527476E578571365129CEE31EE5E5F341E5E2BD35333DD2804C3CC80A3118DAD6B4F3BF9A81FD02FA0CD973AF9DAC84AFB4FFC280BF85AAD1CB2D013DE7', CAST(N'2026-01-01T21:45:09.323' AS DateTime), N'd5b9f753-ab67-4057-832e-8de12041ac85')
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (12, N'qq', N'qq@qq.com', NULL, N'No Address', N'1B22D785AFECFE9FE04B53EDAFE3CB35E5738A34CBFDAC966EC50C853A1F68FDA6993F9CBEF30B99C114FAA0AB87274ABD1F8E0DE9BAEEBE7211C2DD73A014BA', CAST(N'2026-01-01T21:51:00.523' AS DateTime), N'f73f7830-1ac1-467f-bbaf-c7cf70f66e0d')
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (13, N'Test Customer', N'test@test.com', NULL, NULL, N'hashedpassword123', CAST(N'2026-01-02T00:37:55.927' AS DateTime), NULL)
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (14, N'Test Customer A', N'testA@d.com', N'01234511162', N'Jalan Krayby 2, 01982 Petaling Jaya', N'4C2A20C4E3116AF9A5A3CB1C3AA63F89EEA7547D2DA24DC7320F9B8D5510CC346209433DCF88AC16600B929CA9304CAD6B7C3D1827FD4BA325A9895DA2A5AB88', CAST(N'2026-01-02T00:49:20.877' AS DateTime), N'afa7fa25-54ce-4681-a594-cf01fbf154a4')
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (16, N'fff', N'fff@d.com', NULL, N'No Address', N'10E1B59DD0596EA28433B4D59A2FE0A198B4A7146975EC0726366830F85632513346EECF94E71F3C43F81AE11F71E8432544F6B7006177E4689C82001BEBD43F', CAST(N'2026-01-02T01:05:41.607' AS DateTime), N'fdf44f00-5471-4643-bf95-17a40184d8e3')
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (17, N'Jinggle', N'jg@mm.com', NULL, N'No Address', N'31ECD5B7841FEE21724567E0E55562DA92548770E3350D39CB50B4131E20396CB897965C1C772255DF3BF4A2CE179887A13E492275A8453458C7034DE3696AC6', CAST(N'2026-01-02T01:08:51.800' AS DateTime), N'a5bece60-867c-4268-944a-3131c6fd46b5')
INSERT [Membership].[Customers] ([id], [name], [email], [phone], [address], [passwordHash], [createdAt], [PasswordSalt]) VALUES (18, N'cc', N'cc@c.com', NULL, N'No Address', N'CADBA2B3FD74B8A3F1916E87246E2153901582FFA25E89F1F9C72DFC2251AF20B97C0D9FCF4E812CABE63A360487B355F64F270DF037ECB384FE7083AF891A4C', CAST(N'2026-01-02T01:09:59.023' AS DateTime), N'c8a37b48-1cde-44e6-a0a1-39c3631180ee')
SET IDENTITY_INSERT [Membership].[Customers] OFF
GO
SET IDENTITY_INSERT [Membership].[Sellers] ON 

INSERT [Membership].[Sellers] ([id], [name], [email], [CardNumber], [passwordHash], [createdAt], [PasswordSalt]) VALUES (1, N'Jooo World Ltd', N'admin@gadgetworld.com', N'SqlBinary(97)', N'AB8981F922BCDD351BCE67641BE83AFA1DB46BC3D8E22ADD347240DAC2F4DC5BCA7BF79501CEE390F69338A42C8283C3AEB7A0C85B5AA5EAB4E6E3C6AD18B8DA', CAST(N'2026-01-01T21:59:49.383' AS DateTime), N'2d22ff94-1d3e-423c-9907-9794f13c6a18')
INSERT [Membership].[Sellers] ([id], [name], [email], [CardNumber], [passwordHash], [createdAt], [PasswordSalt]) VALUES (2, N'Jooo World Ltd', N'admin@t.com', N'SqlBinary(97)', N'6F0DD361F7548FE8E40A558BADB45421D63CFC831095E43C496FE706A2B4A16B48608422B1C8395087B6F20B8AA03FDF4382114E41D8AE9FC553F706703D1A09', CAST(N'2026-01-02T00:43:43.957' AS DateTime), N'e63c1db7-cfd7-4cac-88d7-ca5277564803')
INSERT [Membership].[Sellers] ([id], [name], [email], [CardNumber], [passwordHash], [createdAt], [PasswordSalt]) VALUES (3, N'UI', N'ui@test.com', N'SqlBinary(97)', N'015BCF73791662D313C9136A96A2091FA2712195263A62BA0C35543FCAC6CC9E568DD338B9F8C0BE66B32E42DD6CB19A42E5E99FFA79421906A1AD26C4104325', CAST(N'2026-01-02T04:14:52.613' AS DateTime), N'dba8fff7-9d40-4212-8428-29d496598174')
SET IDENTITY_INSERT [Membership].[Sellers] OFF
GO
INSERT [Security].[CustomerSessions] ([session_token], [customer_id], [user_agent], [created_at], [expires_at]) VALUES (N'68e5420c-82f9-4f96-9973-6d1d2b261306', 13, N'Mozilla/5.0 Test Browser', CAST(N'2026-01-02T00:37:55.937' AS DateTime), NULL)
GO
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'25895325-fe70-46fb-98fb-044d48155ebc', 1, N'unknown', CAST(N'2026-01-01T22:00:00.653' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'bccbac49-c69c-462d-ad62-0a6404cf8c45', 1, N'unknown', CAST(N'2026-01-01T22:17:08.620' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'1e40529f-4fee-4d5b-845a-1255408f70b8', 1, N'unknown', CAST(N'2026-01-02T02:37:59.893' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'f0561835-081e-4953-a9df-21f01877806b', 1, N'unknown', CAST(N'2026-01-02T04:02:29.267' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'ef2ae3be-876f-4492-9b39-2ac29d797888', 2, N'unknown', CAST(N'2026-01-02T03:42:00.233' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'135ffe7e-64df-40b4-95c9-3a0fcb1d2d22', 2, N'unknown', CAST(N'2026-01-02T03:30:28.923' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'e09bfb1a-b791-472c-92a4-3d88231909d4', 3, N'unknown', CAST(N'2026-01-02T05:02:22.830' AS DateTime), CAST(N'2026-01-02T05:02:50.157' AS DateTime), 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'f0bfc036-49cc-4f0c-8714-45839c575ed5', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T03:51:11.163' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'2cb0779c-5ebb-4652-b83b-4aeae746fd13', 1, N'Firefox/Seller', CAST(N'2026-01-02T00:40:50.223' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'34ca7f83-e2da-4234-a2ae-560b324d7b53', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T03:39:07.450' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'667facdc-308e-42dd-8699-5d17cf73ca3e', 2, N'unknown', CAST(N'2026-01-02T03:47:23.407' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'22bb1d4e-64f1-41e4-a02e-63ee47f63085', 2, N'unknown', CAST(N'2026-01-02T02:30:01.427' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'0b16d856-f8f4-4c14-b5b7-669c87fcf306', 2, N'unknown', CAST(N'2026-01-02T01:33:58.877' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'16eee0a0-34ce-4e1a-934c-7f10c7e81f56', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T03:51:11.160' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'2df62550-abb6-4808-a93e-8168352dd081', 1, N'unknown', CAST(N'2026-01-02T03:46:48.247' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'08963537-ac27-46ba-98d8-84077da30698', 2, N'unknown', CAST(N'2026-01-02T04:03:04.257' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'4d9c7c26-68c1-4149-b672-8d774f42b246', 2, N'unknown', CAST(N'2026-01-02T02:00:48.987' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'9c605541-03ee-452c-ba93-90b964e0f03c', 3, N'unknown', CAST(N'2026-01-02T04:15:04.357' AS DateTime), CAST(N'2026-01-02T05:01:48.830' AS DateTime), 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'f91b74a0-087a-4394-9dbc-9377a006e039', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T03:51:22.917' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'6db8c47b-ceaa-483d-9b56-986ceabdcaef', 3, N'unknown', CAST(N'2026-01-02T05:03:24.803' AS DateTime), NULL, 1)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'9f083a8c-804f-4823-8e57-9ea979645015', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T04:04:06.570' AS DateTime), NULL, 1)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'd63b2708-2922-4c0c-aa0d-9f7c70573471', 3, N'unknown', CAST(N'2026-01-02T05:02:23.327' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'b4a7ac06-990b-4ff7-9d80-a788cd8bdd70', 3, N'unknown', CAST(N'2026-01-02T05:02:54.187' AS DateTime), CAST(N'2026-01-02T05:03:20.270' AS DateTime), 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'3ebb2f88-adef-4664-9210-b82abdd72d4d', 2, N'unknown', CAST(N'2026-01-02T03:15:07.093' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'b2b1d952-6449-4340-bace-c184db9a16be', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T03:41:38.483' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'45d66de6-916c-4a11-abdb-d010a8e25477', 2, N'SSMS-Test-Agent', CAST(N'2026-01-02T03:41:38.487' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'48e30d01-f1f7-4e0b-a63d-f47b4ab5ece1', 1, N'unknown', CAST(N'2026-01-02T04:15:34.203' AS DateTime), NULL, 1)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'5e5b6a20-7165-429f-a332-f7e74ae13884', 2, N'unknown', CAST(N'2026-01-02T01:17:55.127' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'914a337b-0e76-4bd9-b89d-f94d41502ee0', 2, N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-02T02:09:03.527' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'1ee4fd7c-f1ac-4dc9-b10d-fa6436b2b792', 2, N'unknown', CAST(N'2026-01-02T03:22:24.243' AS DateTime), NULL, 0)
INSERT [Security].[SellerSessions] ([session_token], [seller_id], [user_agent], [created_at], [expires_at], [is_active]) VALUES (N'0ea3cbc0-c1dc-4ec1-b6c7-fb65db11f120', 2, N'unknown', CAST(N'2026-01-02T03:06:35.130' AS DateTime), NULL, 0)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Customer__AB6E6164A1C32CC2]    Script Date: 1/2/2026 6:34:23 AM ******/
ALTER TABLE [Membership].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__tmp_ms_x__AB6E61646AA1B33E]    Script Date: 1/2/2026 6:34:23 AM ******/
ALTER TABLE [Membership].[Sellers] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_orderitems_order]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE NONCLUSTERED INDEX [idx_orderitems_order] ON [Sales].[OrderItems]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_orders_customer]    Script Date: 1/2/2026 6:34:23 AM ******/
CREATE NONCLUSTERED INDEX [idx_orders_customer] ON [Sales].[Orders]
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Catalog].[Products] ADD  DEFAULT ((0)) FOR [stock_qty]
GO
ALTER TABLE [Catalog].[Products] ADD  DEFAULT ('available') FOR [status]
GO
ALTER TABLE [Membership].[Customers] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [Membership].[Sellers] ADD  DEFAULT (getdate()) FOR [createdAt]
GO
ALTER TABLE [Sales].[OrderItems] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [Sales].[Orders] ADD  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [Sales].[Orders] ADD  DEFAULT ('confirmed') FOR [status]
GO
ALTER TABLE [Sales].[Orders] ADD  DEFAULT ((0.00)) FOR [total_amount]
GO
ALTER TABLE [Sales].[PaymentCards] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [Sales].[Payments] ADD  DEFAULT ('pending') FOR [status]
GO
ALTER TABLE [Sales].[Payments] ADD  DEFAULT (getdate()) FOR [payment_date]
GO
ALTER TABLE [Security].[CustomerSessions] ADD  DEFAULT (newid()) FOR [session_token]
GO
ALTER TABLE [Security].[CustomerSessions] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [Security].[SellerSessions] ADD  DEFAULT (newid()) FOR [session_token]
GO
ALTER TABLE [Security].[SellerSessions] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [Security].[SellerSessions] ADD  CONSTRAINT [DF_SellerSessions_Active]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [Catalog].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Sellers] FOREIGN KEY([seller_id])
REFERENCES [Membership].[Sellers] ([id])
GO
ALTER TABLE [Catalog].[Products] CHECK CONSTRAINT [FK_Products_Sellers]
GO
ALTER TABLE [Sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY([order_id])
REFERENCES [Sales].[Orders] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [Sales].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Orders]
GO
ALTER TABLE [Sales].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItems_Products] FOREIGN KEY([product_id])
REFERENCES [Catalog].[Products] ([id])
GO
ALTER TABLE [Sales].[OrderItems] CHECK CONSTRAINT [FK_OrderItems_Products]
GO
ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([customer_id])
REFERENCES [Membership].[Customers] ([id])
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [Sales].[PaymentCards]  WITH CHECK ADD  CONSTRAINT [FK_PaymentCards_Customers] FOREIGN KEY([customer_id])
REFERENCES [Membership].[Customers] ([id])
GO
ALTER TABLE [Sales].[PaymentCards] CHECK CONSTRAINT [FK_PaymentCards_Customers]
GO
ALTER TABLE [Sales].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Orders] FOREIGN KEY([order_id])
REFERENCES [Sales].[Orders] ([id])
GO
ALTER TABLE [Sales].[Payments] CHECK CONSTRAINT [FK_Payments_Orders]
GO
ALTER TABLE [Sales].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_PaymentCards] FOREIGN KEY([payment_card_id])
REFERENCES [Sales].[PaymentCards] ([id])
GO
ALTER TABLE [Sales].[Payments] CHECK CONSTRAINT [FK_Payments_PaymentCards]
GO
ALTER TABLE [Security].[CustomerSessions]  WITH CHECK ADD  CONSTRAINT [FK_Sessions_Customers] FOREIGN KEY([customer_id])
REFERENCES [Membership].[Customers] ([id])
GO
ALTER TABLE [Security].[CustomerSessions] CHECK CONSTRAINT [FK_Sessions_Customers]
GO
ALTER TABLE [Security].[SellerSessions]  WITH CHECK ADD  CONSTRAINT [FK_SellerSessions_Sellers] FOREIGN KEY([seller_id])
REFERENCES [Membership].[Sellers] ([id])
GO
ALTER TABLE [Security].[SellerSessions] CHECK CONSTRAINT [FK_SellerSessions_Sellers]
GO
ALTER TABLE [Catalog].[Products]  WITH CHECK ADD  CONSTRAINT [CHK_Status] CHECK  (([status]='not available' OR [status]='available'))
GO
ALTER TABLE [Catalog].[Products] CHECK CONSTRAINT [CHK_Status]
GO
ALTER TABLE [Sales].[Orders]  WITH CHECK ADD  CONSTRAINT [CHK_OrderStatus] CHECK  (([status]='completed' OR [status]='cancelled' OR [status]='shipped' OR [status]='confirmed'))
GO
ALTER TABLE [Sales].[Orders] CHECK CONSTRAINT [CHK_OrderStatus]
GO
ALTER TABLE [Sales].[PaymentCards]  WITH CHECK ADD CHECK  (([exp_month]>=(1) AND [exp_month]<=(12)))
GO
ALTER TABLE [Sales].[Payments]  WITH CHECK ADD  CONSTRAINT [CHK_PaymentStatus] CHECK  (([status]='pending' OR [status]='failed' OR [status]='successful'))
GO
ALTER TABLE [Sales].[Payments] CHECK CONSTRAINT [CHK_PaymentStatus]
GO
/****** Object:  StoredProcedure [Catalog].[usp_AddProductSecurely]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Catalog].[usp_AddProductSecurely]
@ProductName NVARCHAR (200), @Price DECIMAL (18, 2), @Stock INT, @SessionToken UNIQUEIDENTIFIER, @UserAgent NVARCHAR (500)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        EXECUTE sp_set_session_context @key = N'SessionToken', @value = @SessionToken;
        EXECUTE sp_set_session_context @key = N'UserAgent', @value = @UserAgent;
        INSERT INTO Catalog.Products (name, price, stock_qty, seller_id)
        SELECT @ProductName,
               @Price,
               @Stock,
               S.seller_id
        FROM   Security.SellerSessions AS S
        WHERE  S.session_token = @SessionToken
               AND S.is_active = 1;
        IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR ('Vault Security Violation: Invalid or Inactive Session Token.', 16, 1);
                RETURN;
            END
        SELECT SCOPE_IDENTITY() AS NewProductID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage AS NVARCHAR (4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END

GO
/****** Object:  StoredProcedure [Catalog].[usp_DeleteProductSecurely]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Catalog].[usp_DeleteProductSecurely]
@ProductID INT, @SessionToken UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE P
    FROM   Catalog.Products AS P
           INNER JOIN
           Security.SellerSessions AS S
           ON P.seller_id = S.seller_id
    WHERE  P.id = @ProductID
           AND S.session_token = @SessionToken
           AND S.is_active = 1;
    IF @@ROWCOUNT = 0
        RAISERROR ('Unauthorized or Product Not Found.', 16, 1);
END

GO
/****** Object:  StoredProcedure [Catalog].[usp_UpdateProductSecurely]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Catalog].[usp_UpdateProductSecurely]
@ProductID INT, @ProductName NVARCHAR (200), @Price DECIMAL (18, 2), @Stock INT, @SessionToken UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE P
    SET    P.name      = @ProductName,
           P.price     = @Price,
           P.stock_qty = @Stock
    FROM   Catalog.Products AS P
           INNER JOIN
           Security.SellerSessions AS S
           ON P.seller_id = S.seller_id
    WHERE  P.id = @ProductID
           AND S.session_token = @SessionToken
           AND S.is_active = 1;
    IF @@ROWCOUNT = 0
        RAISERROR ('Unauthorized or Product Not Found.', 16, 1);
END

GO
/****** Object:  StoredProcedure [Membership].[GetCustomerProfile]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Membership].[GetCustomerProfile]
@CustomerID INT
AS
BEGIN
    SELECT id,
           name,
           email,
           phone,
           address
    FROM   Membership.Customers
    WHERE  id = @CustomerID;
END

GO
/****** Object:  StoredProcedure [Membership].[GetSellerProfile]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Membership].[GetSellerProfile]
@SellerID INT
AS
BEGIN
    SELECT id,
           name,
           email,
           CardNumber
    FROM   Membership.Sellers
    WHERE  id = @SellerID;
END

GO
/****** Object:  StoredProcedure [Membership].[LoginCustomer]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Membership].[LoginCustomer]
@Email NVARCHAR (255), @InputPassword NVARCHAR (100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserID AS INT;
    DECLARE @StoredHash AS NVARCHAR (255);
    DECLARE @StoredSalt AS UNIQUEIDENTIFIER;
    DECLARE @NewToken AS UNIQUEIDENTIFIER = NEWID();
    SELECT @UserID = id,
           @StoredHash = passwordHash,
           @StoredSalt = PasswordSalt
    FROM   Membership.Customers
    WHERE  email = @Email;
    IF @UserID IS NOT NULL
        BEGIN
            DECLARE @CheckHash AS NVARCHAR (255) = NEWID();
            SET @CheckHash = CONVERT (NVARCHAR (255), HASHBYTES('SHA2_512', @InputPassword + CAST (@StoredSalt AS NVARCHAR (36))), 2);
            IF @CheckHash = @StoredHash
                BEGIN
                    INSERT  INTO Security.CustomerSessions (session_token, customer_id, user_agent, created_at)
                    VALUES                                (@NewToken, @UserID, 'Chrome/Test', GETDATE());
                    SELECT 'SUCCESS' AS [Status],
                           @NewToken AS [SessionToken],
                           @UserID AS [CustomerID];
                    RETURN;
                END
        END
    SELECT 'FAILED' AS Status,
           NULL AS CustomerID;
END

GO
/****** Object:  StoredProcedure [Membership].[LoginSeller]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Membership].[LoginSeller]
@Email NVARCHAR (255), @InputPassword NVARCHAR (100), @UserAgent NVARCHAR (500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SellerID AS INT;
    DECLARE @StoredHash AS NVARCHAR (255);
    DECLARE @StoredSalt AS UNIQUEIDENTIFIER;
    DECLARE @NewToken AS UNIQUEIDENTIFIER = NEWID();
    SELECT @SellerID = id,
           @StoredHash = passwordHash,
           @StoredSalt = PasswordSalt
    FROM   Membership.Sellers
    WHERE  email = @Email;
    IF @SellerID IS NOT NULL
        BEGIN
            DECLARE @CheckHash AS NVARCHAR (255) = NEWID();
            SET @CheckHash = CONVERT (NVARCHAR (255), HASHBYTES('SHA2_512', @InputPassword + CAST (@StoredSalt AS NVARCHAR (36))), 2);
            IF @CheckHash = @StoredHash
                BEGIN
                    UPDATE Security.SellerSessions
                    SET    is_active = 0
                    WHERE  seller_id = @SellerID
                           AND is_active = 1;
                    INSERT  INTO Security.SellerSessions (session_token, seller_id, user_agent, created_at, is_active)
                    VALUES                              (@NewToken, @SellerID, @UserAgent, GETDATE(), 1);
                    SELECT 'SUCCESS' AS [Status],
                           @NewToken AS [SessionToken],
                           @SellerID AS [SellerID];
                    RETURN;
                END
        END
    SELECT 'FAILED' AS [Status],
           NULL AS [SessionToken],
           NULL AS [SellerID];
END

GO
/****** Object:  StoredProcedure [Membership].[LogoutSeller]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Membership].[LogoutSeller]
@SessionToken UNIQUEIDENTIFIER
AS
BEGIN
    UPDATE Security.SellerSessions
    SET    is_active = 0
    WHERE  session_token = @SessionToken;
    PRINT 'Session Revoked.';
END

GO
/****** Object:  StoredProcedure [Membership].[RegisterCustomer]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Membership].[RegisterCustomer]
@Name NVARCHAR (100), @Email NVARCHAR (255), @Phone NVARCHAR (20), @Address NVARCHAR (MAX), @PlainPassword NVARCHAR (100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewSalt AS UNIQUEIDENTIFIER = NEWID();
    DECLARE @HashedPassword AS NVARCHAR (255) = NEWID();
    SET @HashedPassword = CONVERT (NVARCHAR (255), HASHBYTES('SHA2_512', @PlainPassword + CAST (@NewSalt AS NVARCHAR (36))), 2);
    INSERT  INTO Membership.Customers (name, email, phone, address, passwordHash, PasswordSalt, createdAt)
    VALUES                           (@Name, @Email, @Phone, @Address, @HashedPassword, @NewSalt, GETDATE());
    DECLARE @NewCustomerID AS INT = SCOPE_IDENTITY();
    SELECT 'SUCCESS' AS [Status],
           @NewCustomerID AS [CustomerID];
END

GO
/****** Object:  StoredProcedure [Membership].[RegisterSeller]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Membership].[RegisterSeller]
@Name NVARCHAR (100), @Email NVARCHAR (255), @CardNumber NVARCHAR (20), @PlainPassword NVARCHAR (100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewSalt AS UNIQUEIDENTIFIER = NEWID();
    DECLARE @HashedPassword AS NVARCHAR (255) = NEWID();
    SET @HashedPassword = CONVERT (NVARCHAR (255), HASHBYTES('SHA2_512', @PlainPassword + CAST (@NewSalt AS NVARCHAR (36))), 2);
    INSERT  INTO Membership.Sellers (name, email, CardNumber, passwordHash, PasswordSalt, createdAt)
    VALUES                         (@Name, @Email, @CardNumber, @HashedPassword, @NewSalt, GETDATE());
    DECLARE @NewSellerID AS INT = SCOPE_IDENTITY();
    SELECT 'SUCCESS' AS [Status],
           @NewSellerID AS [SellerID];
END

GO
/****** Object:  StoredProcedure [Membership].[usp_LogoutSeller]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Membership].[usp_LogoutSeller]
@SessionToken UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Security.SellerSessions
    SET    is_active  = 0,
           expires_at = GETDATE()
    WHERE  session_token = @SessionToken;
    EXECUTE sp_set_session_context @key = N'SessionToken', @value = NULL;
END

GO
/****** Object:  StoredProcedure [Sales].[PlaceNewOrder]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Sales].[PlaceNewOrder]
@CustomerID INT, @ProductID INT, @Qty INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RealPrice AS DECIMAL (10, 2);
    SELECT @RealPrice = price
    FROM   Catalog.Products
    WHERE  id = @ProductID;
    IF @RealPrice IS NULL
        THROW 50001, 'Product not found', 1;
    INSERT  INTO Sales.Orders (customer_id, status, total_amount)
    VALUES                   (@CustomerID, 'confirmed', 0);
    DECLARE @NewOrderID AS INT = SCOPE_IDENTITY();
    INSERT  INTO Sales.OrderItems (order_id, product_id, quantity, sale_price)
    VALUES                       (@NewOrderID, @ProductID, @Qty, @RealPrice);
    SELECT @NewOrderID AS [OrderPlaced];
END

GO
/****** Object:  StoredProcedure [Security].[RegisterCard]    Script Date: 1/2/2026 6:34:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Security].[RegisterCard]
@CustomerID INT, @CardNumber NVARCHAR (20), @ExpMonth INT, @ExpYear INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1
                   FROM   Membership.Customers
                   WHERE  id = @CustomerID)
        BEGIN
            THROW 50001, 'Customer does not exist.', 1;
        END
    INSERT  INTO Sales.PaymentCards (customer_id, card_number, exp_month, exp_year, created_at)
    VALUES                         (@CustomerID, @CardNumber, @ExpMonth, @ExpYear, GETDATE());
    SELECT SCOPE_IDENTITY() AS [CardID];
END

GO
USE [master]
GO
ALTER DATABASE [VaultCartDB] SET  READ_WRITE 
GO
