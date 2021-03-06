/****** Object:  Schema [Crm]    Script Date: 10/19/2017 09:46:51 ******/
CREATE SCHEMA [Crm] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CrmSecurity]    Script Date: 10/19/2017 09:46:51 ******/
CREATE SCHEMA [CrmSecurity] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CrmSys]    Script Date: 10/19/2017 09:46:51 ******/
CREATE SCHEMA [CrmSys] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CrmSysAccent]    Script Date: 10/19/2017 09:46:51 ******/
CREATE SCHEMA [CrmSysAccent] AUTHORIZATION [dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[parseJSON]    Script Date: 10/19/2017 09:46:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[parseJSON]( @JSON NVARCHAR(MAX))
RETURNS @hierarchy TABLE
  (
   element_id INT IDENTITY(1, 1) NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
   sequenceNo [int] NULL, /* the place in the sequence for the element */
   parent_ID INT,/* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
   Object_ID INT,/* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
   NAME NVARCHAR(2000),/* the name of the object */
   StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
   ValueType VARCHAR(10) NOT null /* the declared type of the value represented as a string in StringValue*/
  )
AS
BEGIN
  DECLARE
    @FirstObject INT, --the index of the first open bracket found in the JSON string
    @OpenDelimiter INT,--the index of the next open bracket found in the JSON string
    @NextOpenDelimiter INT,--the index of subsequent open bracket found in the JSON string
    @NextCloseDelimiter INT,--the index of subsequent close bracket found in the JSON string
    @Type NVARCHAR(10),--whether it denotes an object or an array
    @NextCloseDelimiterChar CHAR(1),--either a '}' or a ']'
    @Contents NVARCHAR(MAX), --the unparsed contents of the bracketed expression
    @Start INT, --index of the start of the token that you are parsing
    @end INT,--index of the end of the token that you are parsing
    @param INT,--the parameter at the end of the next Object/Array token
    @EndOfName INT,--the index of the start of the parameter at end of Object/Array token
    @token NVARCHAR(200),--either a string or object
    @value NVARCHAR(MAX), -- the value as a string
    @SequenceNo int, -- the sequence number within a list
    @name NVARCHAR(200), --the name as a string
    @parent_ID INT,--the next parent ID to allocate
    @lenJSON INT,--the current length of the JSON String
    @characters NCHAR(36),--used to convert hex to decimal
    @result BIGINT,--the value of the hex symbol being parsed
    @index SMALLINT,--used for parsing the hex value
    @Escape INT --the index of the next escape character


  DECLARE @Strings TABLE /* in this temporary table we keep all strings, even the names of the elements, since they are 'escaped' in a different way, and may contain, unescaped, brackets denoting objects or lists. These are replaced in the JSON string by tokens representing the string */
    (
     String_ID INT IDENTITY(1, 1),
     StringValue NVARCHAR(MAX)
    )
  SELECT--initialise the characters to convert hex to ascii
    @characters='0123456789abcdefghijklmnopqrstuvwxyz',
    @SequenceNo=0, --set the sequence no. to something sensible.
  /* firstly we process all strings. This is done because [{} and ] aren't escaped in strings, which complicates an iterative parse. */
    @parent_ID=0;
  WHILE 1=1 --forever until there is nothing more to do
    BEGIN
      SELECT
        @start=PATINDEX('%[^a-zA-Z]["]%', @json collate SQL_Latin1_General_CP850_Bin);--next delimited string
      IF @start=0 BREAK --no more so drop through the WHILE loop
      IF SUBSTRING(@json, @start+1, 1)='"'
        BEGIN --Delimited Name
          SET @start=@Start+1;
          SET @end=PATINDEX('%[^\]["]%', RIGHT(@json, LEN(@json+'|')-@start) collate SQL_Latin1_General_CP850_Bin);
        END
      IF @end=0 --no end delimiter to last string
        BREAK --no more
      SELECT @token=SUBSTRING(@json, @start+1, @end-1)
      --now put in the escaped control characters
      SELECT @token=REPLACE(@token, FROMString, TOString)
      FROM
        (SELECT
          '\"' AS FromString, '"' AS ToString
         UNION ALL SELECT '\\', '\'
         UNION ALL SELECT '\/', '/'
         UNION ALL SELECT '\b', CHAR(08)
         UNION ALL SELECT '\f', CHAR(12)
         UNION ALL SELECT '\n', CHAR(10)
         UNION ALL SELECT '\r', CHAR(13)
         UNION ALL SELECT '\t', CHAR(09)
        ) substitutions
      SELECT @result=0, @escape=1
  --Begin to take out any hex escape codes
      WHILE @escape>0
        BEGIN
          SELECT @index=0,
          --find the next hex escape sequence
          @escape=PATINDEX('%\x[0-9a-f][0-9a-f][0-9a-f][0-9a-f]%', @token collate SQL_Latin1_General_CP850_Bin)
          IF @escape>0 --if there is one
            BEGIN
              WHILE @index<4 --there are always four digits to a \x sequence  
                BEGIN
                  SELECT --determine its value
                    @result=@result+POWER(16, @index)
                    *(CHARINDEX(SUBSTRING(@token, @escape+2+3-@index, 1),
                                @characters)-1), @index=@index+1 ;

                END
                -- and replace the hex sequence by its unicode value
              SELECT @token=STUFF(@token, @escape, 6, NCHAR(@result))
            END
        END
      --now store the string away
      INSERT INTO @Strings (StringValue) SELECT @token
      -- and replace the string with a token
      SELECT @JSON=STUFF(@json, @start, @end+1,
                    '@string'+CONVERT(NVARCHAR(5), @@identity))
    END
  -- all strings are now removed. Now we find the first leaf. 
  WHILE 1=1  --forever until there is nothing more to do
  BEGIN

  SELECT @parent_ID=@parent_ID+1
  --find the first object or list by looking for the open bracket
  SELECT @FirstObject=PATINDEX('%[{[[]%', @json collate SQL_Latin1_General_CP850_Bin)--object or array
  IF @FirstObject = 0 BREAK
  IF (SUBSTRING(@json, @FirstObject, 1)='{')
    SELECT @NextCloseDelimiterChar='}', @type='object'
  ELSE
    SELECT @NextCloseDelimiterChar=']', @type='array'
  SELECT @OpenDelimiter=@firstObject

  WHILE 1=1 --find the innermost object or list...
    BEGIN
      SELECT
        @lenJSON=LEN(@JSON+'|')-1
  --find the matching close-delimiter proceeding after the open-delimiter
      SELECT
        @NextCloseDelimiter=CHARINDEX(@NextCloseDelimiterChar, @json,
                                      @OpenDelimiter+1)
  --is there an intervening open-delimiter of either type
      SELECT @NextOpenDelimiter=PATINDEX('%[{[[]%',
             RIGHT(@json, @lenJSON-@OpenDelimiter)collate SQL_Latin1_General_CP850_Bin)--object
      IF @NextOpenDelimiter=0
        BREAK
      SELECT @NextOpenDelimiter=@NextOpenDelimiter+@OpenDelimiter
      IF @NextCloseDelimiter<@NextOpenDelimiter
        BREAK
      IF SUBSTRING(@json, @NextOpenDelimiter, 1)='{'
        SELECT @NextCloseDelimiterChar='}', @type='object'
      ELSE
        SELECT @NextCloseDelimiterChar=']', @type='array'
      SELECT @OpenDelimiter=@NextOpenDelimiter
    END
  ---and parse out the list or name/value pairs
  SELECT
    @contents=SUBSTRING(@json, @OpenDelimiter+1,
                        @NextCloseDelimiter-@OpenDelimiter-1)
  SELECT
    @JSON=STUFF(@json, @OpenDelimiter,
                @NextCloseDelimiter-@OpenDelimiter+1,
                '@'+@type+CONVERT(NVARCHAR(5), @parent_ID))
  WHILE (PATINDEX('%[A-Za-z0-9@+.e]%', @contents collate SQL_Latin1_General_CP850_Bin))<>0
    BEGIN
      IF @Type='Object' --it will be a 0-n list containing a string followed by a string, number,boolean, or null
        BEGIN
          SELECT
            @SequenceNo=0,@end=CHARINDEX(':', ' '+@contents)--if there is anything, it will be a string-based name.
          SELECT  @start=PATINDEX('%[^A-Za-z@][@]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)--AAAAAAAA
          SELECT @token=SUBSTRING(' '+@contents, @start+1, @End-@Start-1),
            @endofname=PATINDEX('%[0-9]%', @token collate SQL_Latin1_General_CP850_Bin),
            @param=RIGHT(@token, LEN(@token)-@endofname+1)
          SELECT
            @token=LEFT(@token, @endofname-1),
            @Contents=RIGHT(' '+@contents, LEN(' '+@contents+'|')-@end-1)
          SELECT  @name=stringvalue FROM @strings
            WHERE string_id=@param --fetch the name
        END
      ELSE
        SELECT @Name=null,@SequenceNo=@SequenceNo+1
      SELECT
        @end=CHARINDEX(',', @contents)-- a string-token, object-token, list-token, number,boolean, or null
      IF @end=0
        SELECT  @end=PATINDEX('%[A-Za-z0-9@+.e][^A-Za-z0-9@+.e]%', @Contents+' ' collate SQL_Latin1_General_CP850_Bin)
          +1
       SELECT
        @start=PATINDEX('%[^A-Za-z0-9@+.e][A-Za-z0-9@+.e]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)
      --select @start,@end, LEN(@contents+'|'), @contents 
      SELECT
        @Value=RTRIM(SUBSTRING(@contents, @start, @End-@Start)),
        @Contents=RIGHT(@contents+' ', LEN(@contents+'|')-@end)
      IF SUBSTRING(@value, 1, 7)='@object'
        INSERT INTO @hierarchy
          (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
          SELECT @name, @SequenceNo, @parent_ID, SUBSTRING(@value, 8, 5),
            SUBSTRING(@value, 8, 5), 'object'
      ELSE
        IF SUBSTRING(@value, 1, 6)='@array'
          INSERT INTO @hierarchy
            (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
            SELECT @name, @SequenceNo, @parent_ID, SUBSTRING(@value, 7, 5),
              SUBSTRING(@value, 7, 5), 'array'
        ELSE
          IF SUBSTRING(@value, 1, 7)='@string'
            INSERT INTO @hierarchy
              (NAME, SequenceNo, parent_ID, StringValue, ValueType)
              SELECT @name, @SequenceNo, @parent_ID, stringvalue, 'string'
              FROM @strings
              WHERE string_id=SUBSTRING(@value, 8, 5)
          ELSE
            IF @value IN ('true', 'false')
              INSERT INTO @hierarchy
                (NAME, SequenceNo, parent_ID, StringValue, ValueType)
                SELECT @name, @SequenceNo, @parent_ID, @value, 'boolean'
            ELSE
              IF @value='null'
                INSERT INTO @hierarchy
                  (NAME, SequenceNo, parent_ID, StringValue, ValueType)
                  SELECT @name, @SequenceNo, @parent_ID, @value, 'null'
              ELSE
                IF PATINDEX('%[^0-9]%', @value collate SQL_Latin1_General_CP850_Bin)>0
                  INSERT INTO @hierarchy
                    (NAME, SequenceNo, parent_ID, StringValue, ValueType)
                    SELECT @name, @SequenceNo, @parent_ID, @value, 'real'
                ELSE
                  INSERT INTO @hierarchy
                    (NAME, SequenceNo, parent_ID, StringValue, ValueType)
                    SELECT @name, @SequenceNo, @parent_ID, @value, 'int'
      if @Contents=' ' Select @SequenceNo=0
    END
  END
INSERT INTO @hierarchy (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
  SELECT '-',1, NULL, '', @parent_id-1, @type
--
   RETURN
END
GO
/****** Object:  Table [CrmSecurity].[Groups]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CrmSecurity].[Groups](
	[Id] [bigint] NOT NULL,
	[Key] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Memo] [nvarchar](255) NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNQ_Groups_Key] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNQ_Groups_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CrmSys].[_CONST]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CrmSys].[_CONST](
	[CONST_ID] [int] IDENTITY(1,1) NOT NULL,
	[CONST_GUID]  AS (newid()),
	[CONST_KIND] [int] NULL,
	[CONST_NAME] [varchar](255) NOT NULL,
	[CONST_CODE] [varchar](50) NOT NULL,
	[CONST_LONG] [int] NULL,
	[CONST_STRING] [varchar](50) NULL,
	[CONST_DOUBLE] [float] NULL,
	[CONST_DATE] [datetime] NULL,
	[CONST_CY] [money] NULL,
 CONSTRAINT [PK__ec_CONST] PRIMARY KEY CLUSTERED 
(
	[CONST_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CrmSecurity].[Users]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CrmSecurity].[Users](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Guid] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[SecurityStamp] [nvarchar](max) NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[Email] [nvarchar](255) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PhoneNumber] [nvarchar](255) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetimeoffset](7) NULL,
	[AccessFailedCount] [int] NOT NULL,
	[Locale] [nvarchar](32) NOT NULL,
	[PersonName] [nvarchar](255) NULL,
	[Memo] [nvarchar](255) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNQ_Users_UserName] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Crm].[Emails]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Crm].[Emails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Crm.Emails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CrmSecurity].[Roles]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CrmSecurity].[Roles](
	[Id] [bigint] NOT NULL,
	[Key] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Memo] [nvarchar](255) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNQ_Roles_Key] UNIQUE NONCLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UNQ_Roles_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Crm].[Phones]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Crm].[Phones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [nvarchar](255) NOT NULL,
	[AddNumber] [nvarchar](255) NULL,
	[Memo] [nvarchar](255) NULL,
 CONSTRAINT [PK_Crm.Phones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [CrmSecurity].[ViewUsers]    Script Date: 10/19/2017 09:46:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
CREATE view [CrmSecurity].[ViewUsers]
as
	select Id, UserName, PasswordHash, SecurityStamp, Email, PhoneNumber,
		LockoutEnabled, AccessFailedCount, LockoutEndDateUtc, TwoFactorEnabled, [Locale],
		PersonName, Memo
	from CrmSecurity.Users;
GO
/****** Object:  Table [CrmSecurity].[UserRoles]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CrmSecurity].[UserRoles](
	[Id] [bigint] NOT NULL,
	[RoleId] [bigint] NULL,
	[UserId] [bigint] NULL,
	[GroupId] [bigint] NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CrmSecurity].[UserGroups]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CrmSecurity].[UserGroups](
	[UserId] [bigint] NOT NULL,
	[GroupId] [bigint] NOT NULL,
 CONSTRAINT [PK_UserGroups] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[GroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CrmSecurity].[Acl]    Script Date: 10/19/2017 09:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CrmSecurity].[Acl](
	[Id] [bigint] NOT NULL,
	[Object] [sysname] NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[UserId] [bigint] NULL,
	[GroupId] [bigint] NULL,
	[CanView] [smallint] NOT NULL,
	[CanEdit] [smallint] NOT NULL,
	[CanDelete] [smallint] NOT NULL,
	[CanApply] [smallint] NOT NULL,
 CONSTRAINT [PK_Acl] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [CrmSys].[_SetConstLong]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [CrmSys].[_SetConstLong]
--exec [dbo].[_mk_SetConstLong] '@Acc92', 2, N'ИД счета 92 Административные расходы',	405
--declare
@ConstCode varchar(50), @ConstKind int, @ConstName nVarChar(255), @ConstLong int

--select @ConstCode = N''

AS
SET NOCOUNT ON

if not exists(select * from CrmSys._CONST where CONST_CODE = @ConstCode) -- если записи нет - добавляем
Begin	
	insert into CrmSys._CONST(CONST_KIND, CONST_NAME, CONST_CODE, CONST_LONG)
	values				 (@ConstKind, @ConstName, @ConstCode, @ConstLong)
end
else
Begin
	if not exists(select * from CrmSys._CONST where CONST_CODE = @ConstCode and CONST_LONG = @ConstLong) --если есть - проверяем совпадает ли значение
	Begin
		update CrmSys._CONST
		set CONST_LONG = @ConstLong
		where CONST_CODE = @ConstCode
	end
end
GO
/****** Object:  StoredProcedure [CrmSys].[_GetConstLong]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [CrmSys].[_GetConstLong]
--declare

@ConstCode varchar(50), @ConstValue int out


--select @ConstCode = N''

AS

--declare @BndID_GrA	int exec [dbo].[_ec_GetConstLong] 'BndID_GrA',	@BndID_GrA	output

begin

	select @ConstValue = null
	
	select Top 1 @ConstValue	= CONST_LONG from CrmSys._CONST where CONST_CODE = @ConstCode  

	declare @ErrorText nVarChar(50) select @ErrorText = N'Не указан ' + @ConstCode
	if @ConstValue is null raiserror(@ErrorText, 16, 1)

	--select @ConstValue

end
GO
/****** Object:  UserDefinedFunction [CrmSys].[_fnGetConstLong]    Script Date: 10/19/2017 09:46:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [CrmSys].[_fnGetConstLong]
(
	@ConstCode varchar(50)
)
RETURNS int
AS
BEGIN


	declare @ConstValue int  select @ConstValue = null
	
	select Top 1 @ConstValue = CONST_LONG from CrmSys._CONST where CONST_CODE = @ConstCode  

	declare @ErrorText nVarChar(50) select @ErrorText = N'Not filled value in ' + @ConstCode
	--if @ConstValue is null raiserror(@ErrorText, 16, 1)

	-- Return the result of the function
	RETURN @ConstValue

END
GO
/****** Object:  UserDefinedFunction [CrmSysAccent].[GetAgFolderByType]    Script Date: 10/19/2017 09:46:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [CrmSysAccent].[GetAgFolderByType] (@AgType int)
RETURNS int
AS
BEGIN

	--declare @AgTreeWorkerRoot	int exec [CrmSys].[_GetConstLong] '@AgTreeWorkerRoot',		@AgTreeWorkerRoot output
	--declare @AgTreeCustomerRoot	int exec [CrmSys].[_GetConstLong] '@AgTreeCustomerRoot',	@AgTreeCustomerRoot output
	declare @Res int
	
	if @AgType = 3
		select Top 1 @Res = CONST_LONG from CrmSys._CONST where CONST_CODE = '@AgTreeWorkerRoot'
	else
		select Top 1 @Res = CONST_LONG from CrmSys._CONST where CONST_CODE = '@AgTreeCustomerRoot'

	return @Res
END
GO
/****** Object:  StoredProcedure [CrmSecurity].[GetUserGroups]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
CREATE procedure [CrmSecurity].[GetUserGroups]
@UserId bigint
as
begin
	set nocount on;
	select r.Id, r.Name 
	from CrmSecurity.UserGroups ur
		inner join CrmSecurity.Groups r on ur.GroupId = r.Id
	where ur.UserId = @UserId;
end
GO
/****** Object:  StoredProcedure [CrmSecurity].[FindUserByName]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
create procedure [CrmSecurity].[FindUserByName]
@UserName nvarchar(255)
as
begin
	set nocount on;
	select * from CrmSecurity.ViewUsers with(nolock)
	where UserName=@UserName;
end
GO
/****** Object:  StoredProcedure [CrmSecurity].[FindUserById]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
create procedure [CrmSecurity].[FindUserById]
@Id bigint
as
begin
	set nocount on;
	select * from CrmSecurity.ViewUsers where Id=@Id;
end
GO
/****** Object:  StoredProcedure [CrmSecurity].[FindUserByEmail]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
create procedure [CrmSecurity].[FindUserByEmail]
@Email nvarchar(255)
as
begin
	set nocount on;
	select * from CrmSecurity.ViewUsers with(nolock)
	where Email=@Email;
end
GO
/****** Object:  StoredProcedure [CrmSecurity].[UpdateUserPassword]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
create procedure [CrmSecurity].[UpdateUserPassword]
@Id bigint,
@PasswordHash nvarchar(max),
@SecurityStamp nvarchar(max)
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;
	update CrmSecurity.ViewUsers set PasswordHash = @PasswordHash, SecurityStamp = @SecurityStamp where Id=@Id;
	--TODO: log
end
GO
/****** Object:  StoredProcedure [CrmSecurity].[UpdateUserLockout]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
create procedure [CrmSecurity].[UpdateUserLockout]
@Id bigint,
@AccessFailedCount int,
@LockoutEndDateUtc datetimeoffset
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;
	update CrmSecurity.ViewUsers set 
		AccessFailedCount = @AccessFailedCount, LockoutEndDateUtc = @LockoutEndDateUtc
	where Id=@Id;
	--TODO: log
end
GO
/****** Object:  View [Crm].[Persons]    Script Date: 10/19/2017 09:46:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Crm].[Persons]
AS
SELECT     a.AG_ID as Id, 
		   a.AG_NAME as Name, 
		   a.AG_CODE as Code, 
		   a.AG_TYPE as [Type],
		   a.AG_MEMO as Memo
FROM         Попович.dbo.AGENTS a
GO
/****** Object:  StoredProcedure [CrmSecurity].[CreateUser]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------
create procedure [CrmSecurity].[CreateUser]
@UserName nvarchar(255),
@PasswordHash nvarchar(max) = null,
@SecurityStamp nvarchar(max),
@Email nvarchar(255) = null,
@PhoneNumber nvarchar(255) = null
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;
	insert into CrmSecurity.ViewUsers(UserName, PasswordHash, SecurityStamp, Email, PhoneNumber)
		values (@UserName, @PasswordHash, @SecurityStamp, @Email, @PhoneNumber);
	--TODO: log
end
GO
/****** Object:  StoredProcedure [Crm].[PersonUpdate]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[PersonUpdate] 

--declare

@Id int, @Name nvarchar(255), @Code nvarchar(50), @Type smallint, @Memo nvarchar(255)

--select @Name = N'sds', @Code = N'123', @Type = 1, @Memo = N'Memo'

AS
BEGIN
	SET NOCOUNT ON;
	
	update Crm.Persons
	   set Name = @Name
		  ,Code = @Code
		  ,[Type] = @Type
		  ,Memo = @Memo
	where Id = @Id

END
GO
/****** Object:  StoredProcedure [Crm].[PersonGetPage]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[PersonGetPage] 

--declare
	@PageNo int, @PageCount int

--select @PageNo = 1, @PageCount = 20

AS
BEGIN
	SET NOCOUNT ON;

	with cte as (
	select ROW_NUMBER() OVER(ORDER BY name) RowNo, *
	from Crm.Persons p) 
	select cte.*
	from cte
	where RowNo >= (@PageNo - 1) * @PageCount and RowNo < (@PageNo) * @PageCount;	

END
GO
/****** Object:  StoredProcedure [Crm].[PersonFindById]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[PersonFindById] 

--declare
	@Id int

--select @Id = 4

AS
BEGIN
	SET NOCOUNT ON;
	
	select * from Crm.Persons where Id = @Id
	
END
GO
/****** Object:  StoredProcedure [Crm].[PersonDelete]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[PersonDelete] 

--declare

@Id int

--select @Id = 4

AS
BEGIN
	SET NOCOUNT ON;
	
	delete from Crm.Persons
	where Id = @Id

END
GO
/****** Object:  StoredProcedure [Crm].[PersonCreate]    Script Date: 10/19/2017 09:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[PersonCreate] 

--declare

@RetId int output, @Name nvarchar(255), @Code nvarchar(50), @Type smallint, @Memo nvarchar(255)

--select @Name = N'sds', @Code = N'123', @Type = 1, @Memo = N'Memo'

AS
BEGIN
	SET NOCOUNT ON;
	insert into Crm.Persons(Name, Code, [Type], Memo)
	select @Name, @Code, @Type, @Memo
	
	set @RetId = scope_identity();
END
GO
/****** Object:  Default [DF_Acl_CanView]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanView]  DEFAULT ((0)) FOR [CanView]
GO
/****** Object:  Default [DF_Acl_CanEdit]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanEdit]  DEFAULT ((0)) FOR [CanEdit]
GO
/****** Object:  Default [DF_Acl_CanDelete]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanDelete]  DEFAULT ((0)) FOR [CanDelete]
GO
/****** Object:  Default [DF_Acl_CanApply]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanApply]  DEFAULT ((0)) FOR [CanApply]
GO
/****** Object:  Default [DF_User_Guid]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_User_Guid]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF_Users_TwoFactorEnabled]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_TwoFactorEnabled]  DEFAULT ((0)) FOR [TwoFactorEnabled]
GO
/****** Object:  Default [DF_Users_EmailConfirmed]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_EmailConfirmed]  DEFAULT ((0)) FOR [EmailConfirmed]
GO
/****** Object:  Default [DF_Users_PhoneNumberConfirmed]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_PhoneNumberConfirmed]  DEFAULT ((0)) FOR [PhoneNumberConfirmed]
GO
/****** Object:  Default [DF_Users_LockoutEnabled]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_LockoutEnabled]  DEFAULT ((1)) FOR [LockoutEnabled]
GO
/****** Object:  Default [DF_Users_AccessFailedCount]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_AccessFailedCount]  DEFAULT ((0)) FOR [AccessFailedCount]
GO
/****** Object:  Default [DF_Users_Locale]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_Locale]  DEFAULT ('uk_UA') FOR [Locale]
GO
/****** Object:  Check [CK_Acl_CanApply]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanApply] CHECK  (([CanApply]=(-1) OR [CanApply]=(1) OR [CanApply]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanApply]
GO
/****** Object:  Check [CK_Acl_CanDelete]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanDelete] CHECK  (([CanDelete]=(-1) OR [CanDelete]=(1) OR [CanDelete]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanDelete]
GO
/****** Object:  Check [CK_Acl_CanEdit]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanEdit] CHECK  (([CanEdit]=(-1) OR [CanEdit]=(1) OR [CanEdit]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanEdit]
GO
/****** Object:  Check [CK_Acl_CanView]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanView] CHECK  (([CanView]=(-1) OR [CanView]=(1) OR [CanView]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanView]
GO
/****** Object:  ForeignKey [FK_Acl_GroupId_Groups]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [FK_Acl_GroupId_Groups] FOREIGN KEY([GroupId])
REFERENCES [CrmSecurity].[Groups] ([Id])
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [FK_Acl_GroupId_Groups]
GO
/****** Object:  ForeignKey [FK_Acl_UserId_AG_USER]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [FK_Acl_UserId_AG_USER] FOREIGN KEY([UserId])
REFERENCES [CrmSecurity].[Users] ([Id])
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [FK_Acl_UserId_AG_USER]
GO
/****** Object:  ForeignKey [FK_UserGroups_Group_Id]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[UserGroups]  WITH CHECK ADD  CONSTRAINT [FK_UserGroups_Group_Id] FOREIGN KEY([GroupId])
REFERENCES [CrmSecurity].[Groups] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserGroups] CHECK CONSTRAINT [FK_UserGroups_Group_Id]
GO
/****** Object:  ForeignKey [FK_UserGroups_Users_Id]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[UserGroups]  WITH CHECK ADD  CONSTRAINT [FK_UserGroups_Users_Id] FOREIGN KEY([UserId])
REFERENCES [CrmSecurity].[Users] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserGroups] CHECK CONSTRAINT [FK_UserGroups_Users_Id]
GO
/****** Object:  ForeignKey [FK_UserRoles_GroupId_Id]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_GroupId_Id] FOREIGN KEY([GroupId])
REFERENCES [CrmSecurity].[Groups] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_GroupId_Id]
GO
/****** Object:  ForeignKey [FK_UserRoles_Roles_Id]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Roles_Id] FOREIGN KEY([RoleId])
REFERENCES [CrmSecurity].[Roles] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Roles_Id]
GO
/****** Object:  ForeignKey [FK_UserRoles_Users_Id]    Script Date: 10/19/2017 09:46:48 ******/
ALTER TABLE [CrmSecurity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Users_Id] FOREIGN KEY([UserId])
REFERENCES [CrmSecurity].[Users] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Users_Id]
GO
GRANT EXECUTE ON SCHEMA::[CrmSecurity] TO [public] AS [dbo]
GO
