/****** Object:  Schema [Crm]    Script Date: 11/11/2017 13:49:09 ******/
CREATE SCHEMA [Crm] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CrmSecurity]    Script Date: 11/11/2017 13:49:09 ******/
CREATE SCHEMA [CrmSecurity] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CrmSys]    Script Date: 11/11/2017 13:49:09 ******/
CREATE SCHEMA [CrmSys] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CrmSysAccent]    Script Date: 11/11/2017 13:49:09 ******/
CREATE SCHEMA [CrmSysAccent] AUTHORIZATION [dbo]
GO
/****** Object:  Table [CrmSecurity].[Groups]    Script Date: 11/11/2017 13:49:06 ******/
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
/****** Object:  StoredProcedure [Crm].[IssueDelete]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueDelete] 
@Id bigint output

AS
BEGIN
	SET NOCOUNT ON;
	
	--delete from Crm.Issues where Id = @Id
	exec sp_executesql N' EXEC Попович.dbo.ap_trash_delete   @P1' ,N'@P1 int', @Id
	
END
GO
/****** Object:  Table [CrmSys].[_CONST]    Script Date: 11/11/2017 13:49:06 ******/
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
SET IDENTITY_INSERT [CrmSys].[_CONST] ON
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (1, 3, N'ID Workers root folder', N'@AgTreeWorkerRoot', 1543, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (4, 3, N'ID Customers root folder', N'@AgTreeCustomerRoot', 2135, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (5, 7, N'Issue ID Template', N'@TmlIdIssue', 312, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (6, NULL, N'Issue ID Form', N'@FrmIdIssue', 177, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (7, 1, N'Issue Folder ID', N'@FldIdIssue', 130, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (8, 2, N'Issue Acc ID', N'@AccIdIssue', 686, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (9, 4, N'Issue Ent ID', N'@EntIdIssue', 1057, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (10, 3, N'My Company ID', N'@McId', 303, NULL, NULL, NULL, NULL)
INSERT [CrmSys].[_CONST] ([CONST_ID], [CONST_KIND], [CONST_NAME], [CONST_CODE], [CONST_LONG], [CONST_STRING], [CONST_DOUBLE], [CONST_DATE], [CONST_CY]) VALUES (11, NULL, N'Trans Param String1', N'@PrmTrString1', 20, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [CrmSys].[_CONST] OFF
/****** Object:  UserDefinedFunction [dbo].[parseJSON]    Script Date: 11/11/2017 13:49:09 ******/
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
/****** Object:  StoredProcedure [Crm].[IssueDetailUpdateIssueLnNo]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueDetailUpdateIssueLnNo] 

--declare

@IssueId int, @LnNo int, @Description nvarchar(255), @Hours money

--select @IssueId = 22814, @LnNo = 0, @Description = N'Description1', @Hours = 1

AS
BEGIN
	SET NOCOUNT ON;
	update Crm.IssuesDetail
	   set 	 [Description] = @Description
			,[Hours] = @Hours
	where IssueId = @IssueId and LnNo = @LnNo
END
GO
/****** Object:  StoredProcedure [Crm].[IssueDetailUpdate]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueDetailUpdate] 

--declare

@Id int, @IssueId int, @LnNo int, @Description nvarchar(255), @Hours money

--select @Id = 109267, @IssueId = 22814, @LnNo = 0, @Description = N'Description1', @Hours = 1

AS
BEGIN
	SET NOCOUNT ON;
	update Crm.IssuesDetail
	   set IssueId = @IssueId
			,LnNo = @LnNo
			,[Description] = @Description
			,[Hours] = @Hours
	where Id = @Id
END
GO
/****** Object:  Table [CrmSecurity].[Users]    Script Date: 11/11/2017 13:49:06 ******/
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
SET IDENTITY_INSERT [CrmSecurity].[Users] ON
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (1, N'00000000-0000-0000-0000-000000000000', N'tttttt@tttt.tt', N'dfgjdsfgjsdfgjsd', N'AIcRMIRV4wIsJLSqA7Pee2v12qrjnQtn/RbrQwBEuywRE3VfjDHM1xE/W8+E4l09RA==', 0, N'tttttt@tttt.tt', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (3, N'00000000-0000-0000-0000-000000000000', N'tttttt@ttt1.ttt', N'dfgjdsfgjsdfgjsd', N'ABwAgkKiAK8TTw98sQ/W2O4CoRPAiGEcVmQDYQ+JZAp8XGfHAoRnRvZsxVwxrGQm7Q==', 0, N'tttttt@ttt1.ttt', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (5, N'00000000-0000-0000-0000-000000000000', N'ttttttt1@ttt.ttt', N'dfgjdsfgjsdfgjsd', N'ABpddWI/0EhWZatJNo6RVZdg/XzVn4MW84HUS45f6mEe5HjVeJ+p7Q41oHY+TwEmsw==', 0, N'ttttttt1@ttt.ttt', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (6, N'00000000-0000-0000-0000-000000000000', N'ttttttt2@ttt.tt', N'dfgjdsfgjsdfgjsd', N'AOrJo6hxrpBcXosIqEuqsljUv+1RQ1QPuoFAVXfxaxqaiViCRzS+KDyQkwRm6Ngx5w==', 0, N'ttttttt2@ttt.tt', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (7, N'00000000-0000-0000-0000-000000000000', N'rrrrrrr1@rrr.rrr', N'18dea0a6-680f-40b9-b6a9-14169c4a7db5', N'ADZZIXGjoa2enMsY8/cYKbtAV+W70QeWmPvcAs0d71o0FuCAnxwxcjxQiaS2Yt/awA==', 0, N'rrrrrrr1@rrr.rrr', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (9, N'00000000-0000-0000-0000-000000000000', N'b.paul4@gmail.com', N'fbec43f1-5add-48cc-a080-21196f2f5d27', N'ANCDFa/yCLb6PYYpfWxlf5EM4M9iibfel0dGOV/6Q5gUIQFFiTpB9l3FPyaVUvMEfA==', 0, N'b.paul4@gmail.com', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (11, N'00000000-0000-0000-0000-000000000000', N'rrrrr287@rr.rrr', N'5746ab9d-5c73-467a-b3f9-1499408cdd06', N'AE5jmAemIuDxXLhEG6RsnRVvE46A20XRg0UPUIfsBzEE7JeHkI8elBv3klNcv43Qpg==', 0, N'rrrrr287@rr.rrr', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (12, N'20adf476-51fc-41f2-b47a-7b6151494e74', N'rrrrrr@rrr.r', N'de6906d9-4a86-4188-9c32-adf73c63dd4e', N'AOZyT9KhfgOD/DdTzhTHg7+w/ZZeSF+MZBfnZoW4QJNbdPcL/pT8OBwyUhdNreJp3g==', 0, N'rrrrrr@rrr.r', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (13, N'e068ccd4-a922-4080-be25-419b23b3a9da', N'rrrrrr123@rrr.r', N'3613a30b-bb8b-4168-9e02-2e4c8ba7cb0d', N'ALw+xjoXfGTZaVqU+hrgXC8D/KQoOzSV6zdkYwj6KOeQ0gJmR0yQWCqQW4CWzGwf8g==', 0, N'rrrrrr123@rrr.r', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (14, N'5d179b54-772b-4144-9a7e-4faef52f1fce', N'trtrtrtrtrt@ss.vv', N'e5509b10-996e-42f4-9a96-e1d977a883d7', N'AM7gZs92u7sPc3xH1JAYyXWqOHff1hUVKF3YXg9OCd4FJm66U93wmO18wr8UAgV9ug==', 0, N'trtrtrtrtrt@ss.vv', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (15, N'1528e58d-8ebd-49a1-b086-46202dafa6e0', N'trtrtrtrtrt1@ss.vv', N'e493865d-93ca-4d0e-b160-59f51fae5b25', N'AHvKtpeZOFYu6o3JPI0+L9JaoQp4gNHigFfFK8eyhM4vv45zUrSBxMyF2KZxtev96w==', 0, N'trtrtrtrtrt1@ss.vv', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (16, N'50627990-8ad0-4f3f-87e1-958f723f0455', N'trtrtrtrtrt3@ss.vv', N'c8b4b1fd-fe00-4451-9156-91464f5750a6', N'AO9taNeA8l/tQb29xyd+6hc9gV52gfuu4s10aEkTVwyg41JPUaz+Ez0MM/9DgHq2fw==', 0, N'trtrtrtrtrt3@ss.vv', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (17, N'aa9a32b6-7a30-4f2c-a93b-b76ef99ddc39', N'eeeee@ee.ee', N'31819c57-aa5a-44f2-a997-ac5e20c6bb32', N'AEzkpL7dpY+94N0OPbymc9VK/Oc/2D8446ixvxZspweSTgwaGwRXnTvWEs/5ylQj2w==', 0, N'eeeee@ee.ee', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (19, N'b9c010be-64f6-489b-b82c-1d32d6b9bb13', N'rrrr222@gmail.com', N'4a04da5b-61bb-44e9-af5c-3a381f62a959', N'ACvRNdIACvIqNNL3/KrFVDLl1CTGutaub1HxLu/zov/4MO9/gD0DRIkTAAOTpNOWgQ==', 0, N'rrrr222@gmail.com', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (20, N'40120f45-8ec1-45de-aea1-c98a9f42bb41', N'tttt@t.t', N'c15ff132-1bfd-4b3a-8495-771575634d41', N'AFPOa53UFjTZBUiWhDY1LArR46ZmiJmziozPrYljgMuJ/MpWnZjd3VKHZFL46jq5ig==', 0, N'tttt@t.t', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (21, N'd17b6052-5aca-4256-959f-d7fbee50ee65', N'rrrrr@rr.rr', N'0ce19a67-9f53-4c4f-b455-27ede1430045', N'AAUCVpZEwtps9K0li4k4nUKRb2mYdXMAtkAc9aidNMgKyiJtqm4QNjsj4GLFHdCaqw==', 0, N'rrrrr@rr.rr', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (22, N'f717fed0-bfcb-4113-aa2a-bd5968844b86', N'eeeeee@ee.ee', N'94be9b89-8ab1-4848-8bd3-d07fa29665fc', N'AN+EYDH45bIWE2SCmgrTeDHuPvUvA3DzaUuWtCq7PDSlsuCBzR1rvHHOzTZRZmRiqg==', 0, N'eeeeee@ee.ee', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (23, N'22e9c598-0209-4e25-a847-31bcde8c1d4d', N'eeeeeee@ee.ee', N'b83ffc18-4a62-4cf0-83da-33808e01f40c', N'AIeLodCyzS3My3uNsiM7oMumSipxJn7SPmaySUKXxUVIoVnfkC+BCM236UKrZZ1KJA==', 0, N'eeeeeee@ee.ee', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (24, N'581ea905-9166-46d9-920d-4a7a35632eb0', N'rrrrr@rrrr1.rr', N'29bc1d75-ce10-496f-956f-5d0134da610e', N'AEjP9NPVTauVTmNpAua/tBacHULbKJrWrnoOyjVGzZBGeVxjjtQ/8l+e20d0RCfMAw==', 0, N'rrrrr@rrrr1.rr', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (25, N'a2b8d8be-f120-4a44-bd86-272f8e9514a0', N'qqqqq@qqq.qq', N'6c2b16d7-bea7-4405-975d-bbc978b097b9', N'AHvAoX74Yx/Sx7rlj9Ucm0NETF2GDhzGWHNdMrcyn3NitnLKEBJrHzWfGEiILzWQrA==', 0, N'qqqqq@qqq.qq', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (26, N'2d688f1d-dbd2-4d2e-86d3-62904896b48e', N'ytyty@hj.uu', N'605d401d-10ef-43ac-9cd0-93688aef984e', N'AMu1YCOW7/+EwbowpuJc6LYRgaWzIjzT144Q7XdT5HT+6rj2AWt5vr9hO818BZy0HQ==', 0, N'ytyty@hj.uu', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (27, N'bc5dca9f-077c-4f2d-b78f-e7f2581731f8', N'ddffdddf@fff.f', N'fa8e65ae-7bb4-43dc-b60b-786c4f5f7c77', N'AOIdSEkJrQdJVGuKS/p4GVeEkncpsGOPW16ZjTnX2dlzA+L4CARxpyzw3jlP3FpGjg==', 0, N'ddffdddf@fff.f', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (28, N'479f4246-6381-46e4-b99d-e7746a921887', N'sssss@dsdsd.ff', N'9311b53d-df57-433f-b63b-5d2e7aa746cf', N'AJJnoRf1uTVGtBgwxH9pRBfLk6imuOAIQJJZ8rAX9wnSr7XlwBpMaWT/CdFM1rFp6g==', 0, N'sssss@dsdsd.ff', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (29, N'9d51a4d1-e892-4045-b23d-e92c956694aa', N'dfgdfgdfg@ddd1.we', N'1853247b-faf0-4a70-80e3-80f9cadb5341', N'AI8FRmV1PSV8RxaKFVuiHAWgZfNU8Qr8nJqnxEc/l1Hh4jzwc5zYAbOpBvgPjuYOhg==', 0, N'dfgdfgdfg@ddd1.we', 0, NULL, 0, 0, NULL, 0, N'Ru', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (30, N'083afd91-b19b-4441-9616-d48826efcc05', N'asdasd@sss.s', N'3f459cd4-43bc-428c-8fab-932ff6674e19', N'AAvsOG1j3jvf9COUwTUFj5Kj8C+gzbNUE5RHJLfymtEikWJ/qr8NV82XSMpfpCZ7yw==', 0, N'asdasd@sss.s', 0, NULL, 0, 1, NULL, 0, N'uk_UA', NULL, NULL)
INSERT [CrmSecurity].[Users] ([Id], [Guid], [UserName], [SecurityStamp], [PasswordHash], [TwoFactorEnabled], [Email], [EmailConfirmed], [PhoneNumber], [PhoneNumberConfirmed], [LockoutEnabled], [LockoutEndDateUtc], [AccessFailedCount], [Locale], [PersonName], [Memo]) VALUES (31, N'4b08a1d5-d0ae-4379-8bef-f32ed281b32c', N'rrrr@r.com', N'b284d1af-740f-4263-bf72-9fd2b8fcdf0e', N'AMaWW1kTJ/qLGHnPYgmqdwDFpS1806LBSah+BtE59cCwa26pkGyvJ7ay03elhF1Ufw==', 0, N'rrrr@r.com', 0, NULL, 0, 1, NULL, 0, N'uk_UA', NULL, NULL)
SET IDENTITY_INSERT [CrmSecurity].[Users] OFF
/****** Object:  StoredProcedure [Crm].[IssueDetailCreate]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueDetailCreate] 

--declare

@RetId int output, @IssueId int, @LnNo int, @Description nvarchar(255), @Hours money

--select @IssueId = 22814, @LnNo = N'0', @Description = N'Description1', @Hours = 1

AS
BEGIN
	SET NOCOUNT ON;
	insert into Crm.IssueDetails(IssueId, LnNo, [Description], [Hours])
	select @IssueId, @LnNo, @Description, @Hours
	
	set @RetId = scope_identity();
END
GO
/****** Object:  Table [CrmSecurity].[Roles]    Script Date: 11/11/2017 13:49:06 ******/
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
/****** Object:  StoredProcedure [Crm].[IssueDetailDeleteExcess]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create procedure [Crm].[IssueDetailDeleteExcess]
	@IssueId int, @maxNo int
AS 
BEGIN
	SET NOCOUNT ON;
	set transaction isolation level serializable
	begin tran
		delete from Попович.dbo.JOURNAL where DOC_ID = @IssueId and J_TR_NO = 0 and J_LN_NO > @maxNo
					

	commit tran
end
GO
/****** Object:  View [CrmSecurity].[ViewUsers]    Script Date: 11/11/2017 13:49:07 ******/
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
/****** Object:  View [Crm].[IssuesDetails]    Script Date: 11/11/2017 13:49:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Crm].[IssuesDetails]
AS
	select N'Id'=j.J_ID, N'IssueId'=DOC_ID, N'LnNo'=J_LN_NO, N'Description'=p.PRM_STRING, N'Hours'=J_QTY
	from [Попович].[dbo].JOURNAL j with (nolock)
		inner join ([Попович].[dbo].JRN_PARAMS p  with (nolock) 
			inner join [Попович].[dbo].JRN_PARAM_NAMES  pn	 with (nolock) on  pn.PRM_NAME	= N'String1' and pn.PRM_ID	=  p.PRM_ID) on p.J_ID = j.J_ID
	where ACC_DB = 686 and J_TR_NO = 0
GO
/****** Object:  Table [CrmSecurity].[UserRoles]    Script Date: 11/11/2017 13:49:06 ******/
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
/****** Object:  Table [CrmSecurity].[UserGroups]    Script Date: 11/11/2017 13:49:06 ******/
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
/****** Object:  View [Crm].[Issues]    Script Date: 11/11/2017 13:49:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Crm].[Issues]
AS
select N'Id'=j.DOC_ID, N'OpDate'=max(DOC_DATE), N'SuppId'=max(J_AG1), N'ClientId'=max(J_AG2), N'Name' = max(p.PRM_STRING)
from [Попович].[dbo].JOURNAL j with (nolock)
	inner join [Попович].[dbo].DOCUMENTS d with (nolock) on j.DOC_ID = d.DOC_ID
	left join ([Попович].[dbo].JRN_PARAMS p  with (nolock) inner join [Попович].[dbo].JRN_PARAM_NAMES  pn	 with (nolock) on  pn.PRM_NAME	= N'String1' and pn.PRM_ID	=  p.PRM_ID) on p.J_ID = j.J_ID
where ACC_DB = 686 and J_TR_NO = 0 and J_LN_NO = 0 and J_DONE = 2
group by j.DOC_ID
GO
/****** Object:  Table [CrmSecurity].[Acl]    Script Date: 11/11/2017 13:49:06 ******/
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
/****** Object:  StoredProcedure [CrmSys].[_SetConstLong]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [CrmSys].[_GetConstLong]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  UserDefinedFunction [CrmSys].[_fnGetConstLong]    Script Date: 11/11/2017 13:49:09 ******/
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
/****** Object:  UserDefinedFunction [CrmSysAccent].[GetAgFolderByType]    Script Date: 11/11/2017 13:49:09 ******/
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
/****** Object:  StoredProcedure [Crm].[IssueDetailFindById]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[IssueDetailFindById] 

--declare
	@Id int

--select @Id = 109267

AS
BEGIN
	SET NOCOUNT ON;
	
	select * from Crm.IssuesDetails where Id = @Id
	
END
GO
/****** Object:  StoredProcedure [Crm].[IssueCreate]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueCreate] 

--declare

@RetId bigint output, @OpDate datetime, @SuppId int, @ClientId int

--select @OpDate = N'20171031', @SuppId = N'1076', @ClientId = 1612

AS
BEGIN
	SET NOCOUNT ON;
	
	declare @Temp table(id int, OpDate datetime, SuppId int, ClientId int)
	
	insert into Crm.Issues(OpDate, SuppId, ClientId)
	OUTPUT inserted.* into @Temp(id, OpDate, SuppId, ClientId)
	select @OpDate, @SuppId, @ClientId;

	select * from @Temp
	--
	set @RetId = scope_identity();
END
GO
/****** Object:  StoredProcedure [Crm].[IssueAddOrUpdate]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec [Crm].[IssueInsertUpdate] 58646, N'20171108', 1464, 2309
CREATE procedure [Crm].[IssueAddOrUpdate]
--declare
	@RetId bigint output, @Id int, @OpDate datetime,  @SuppId int, @ClientId int
AS 
BEGIN
	SET NOCOUNT ON;
	set transaction isolation level serializable
	begin tran
	
		declare @TmlIdIssue int exec CrmSys._GetConstLong '@TmlIdIssue'	,	@TmlIdIssue	output
		declare @FrmIdIssue int exec CrmSys._GetConstLong '@FrmIdIssue'	,	@FrmIdIssue	output
		declare @FldIdIssue int exec CrmSys._GetConstLong '@FldIdIssue'	,	@FldIdIssue	output
		declare @McId		int exec CrmSys._GetConstLong '@McId'		,	@McId		output
		declare @AccIdIssue int exec CrmSys._GetConstLong '@AccIdIssue'	,	@AccIdIssue output
		declare @EntIdIssue int exec CrmSys._GetConstLong '@EntIdIssue'	,	@EntIdIssue	output
		
		--declare @AutonumID int select @AutonumID = FA_ID from Попович.dbo.FORMS where FRM_ID = @FrmIdIssue
		
		declare @DocNoInt bigint
		
		select @DocNoInt = max(convert(bigint, case when patindex('%[^0-9]%', DOC_NO) = 0 then DOC_NO else left(DOC_NO, patindex('%[^0-9]%', DOC_NO) - 1) end))
		from Попович.dbo.DOCUMENTS d with (nolock) 
			inner join Попович.dbo.FORMS f with (nolock) on d.FRM_ID = 177
		where MC_ID = 303 and DOC_DONE < 100 and DOC_DATE >= N'20170101' 

		--select @DocNoInt
	
		declare @DocName nVarChar(255) select @DocName	= N'Вызов к клиенту'
		declare @DocNo   nVarChar(20 ) select @DocNo	= cast(@DocNoInt as nvarchar(50))
		
		declare @DocTag  nVarChar(50 ) select top 1 @DocTag = Left(AG_NAME, 50) from Попович.dbo.AGENTS where AG_ID = @ClientId
		select @DocTag = isnull(@DocTag, N'')
		
		declare @mergeResult table(act nvarchar(255), Id int, DDate datetime)
		declare @mergeResult2 table(act nvarchar(255), Id int)

		----------------------------------------------------------------------------------------------
		-- DOCUMENTS
		----------------------------------------------------------------------------------------------				
		merge Попович.dbo.DOCUMENTS as target
		using (select @Id, @OpDate, @SuppId, @ClientId) as source(Id, OpDate, SuppId, ClientId) on (target.DOC_ID = source.Id)
			when matched then
				update set target.DOC_DATE = source.OpDate, target.DOC_TAG = @DocTag
			when not matched by target then
				insert(DOC_DATE, DOC_DONE, DOC_NO, TML_ID		, FRM_ID		, FLD_ID		, MC_ID, DOC_NAME, DOC_TAG,	LAST_DATE)
				values(OpDate,          2, @DocNo, @TmlIdIssue	, @FrmIdIssue	, @FldIdIssue	, @McId, @DocName, @DocTag,	GETDATE()) 
		OUTPUT $action, inserted.DOC_ID, inserted.DOC_DATE into @mergeResult;
				
		declare @DocId int select @DocId = max(Id) from @mergeResult
		
		set @RetId = @DocId

		----------------------------------------------------------------------------------------------
		-- JOURNAL1
		----------------------------------------------------------------------------------------------				
		merge Попович.dbo.JOURNAL as target
		using (select DOC_ID, DOC_DATE, @SuppId, @ClientId
			   from @mergeResult m
					inner join Попович.dbo.DOCUMENTS d on m.Id = d.DOC_ID
				) as source(DOC_ID, DOC_DATE, ClientId, SuppId) on (target.DOC_ID = source.DOC_ID and target.J_TR_NO = 0 and target.J_LN_NO = 0)
		when matched then
			update set target.J_DATE = source.DOC_DATE, target.J_AG1 = source.ClientId, target.J_AG2 = source.SuppId
		when not matched by target then
			insert(DOC_ID, J_TR_NO, J_LN_NO, J_DATE  , J_DONE, ACC_DB,			 ACC_CR, J_ENT		, J_QTY, J_SUM, MC_ID,  J_AG1    , J_AG2  )
			values(DOC_ID,       0,       0, DOC_DATE,      2, @AccIdIssue, @AccIdIssue, @EntIdIssue,     0,     0, @McId,  @SuppId, @ClientId) 
				
		OUTPUT $action, inserted.DOC_ID into @mergeResult2;

		----------------------------------------------------------------------------------------------
		-- JOURNAL2
		----------------------------------------------------------------------------------------------				
		merge Попович.dbo.JOURNAL as target
		using (select DOC_ID, DOC_DATE, @ClientId, @SuppId
			   from @mergeResult m
					inner join Попович.dbo.DOCUMENTS d on m.Id = d.DOC_ID
				) as source(DOC_ID, DOC_DATE, ClientId, SuppId) on (target.DOC_ID = source.DOC_ID and target.J_TR_NO = 1 and target.J_LN_NO = 0)
		when matched then
			update set target.J_DATE = source.DOC_DATE, target.J_AG2 = source.SuppId
		when not matched by target then
			insert(DOC_ID, J_TR_NO, J_LN_NO, J_DATE  , J_DONE, ACC_DB		, ACC_CR	 , J_ENT, J_QTY, J_SUM, MC_ID, J_AG2 )
			values(DOC_ID,       1,       0, DOC_DATE,      2, @AccIdIssue	, @AccIdIssue,	   0,     0,     0, @McId, SuppId) 
				
		OUTPUT $action, inserted.DOC_ID into @mergeResult2;
				
	commit tran

END
GO
/****** Object:  StoredProcedure [CrmSecurity].[GetUserGroups]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [CrmSecurity].[FindUserByName]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [CrmSecurity].[FindUserById]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [CrmSecurity].[FindUserByEmail]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [CrmSecurity].[CreateUser]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [Crm].[IssueUpdate]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueUpdate] 

--declare
@Id int, @OpDate datetime, @SuppId int, @ClientId int

--select @Id = 22814, @OpDate = N'20171031', @SuppId = N'1076', @ClientId = 1612

AS
BEGIN
	SET NOCOUNT ON;
	
	update Crm.Issues
	   set OpDate = @OpDate
		  ,SuppId = @SuppId
		  ,ClientId = @ClientId
	where Id = @Id

END
GO
/****** Object:  StoredProcedure [Crm].[IssueGetSuppIssues]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[IssueGetSuppIssues] 
	-- Add the parameters for the stored procedure here
	@SuppId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 500 * from Crm.Issues where SuppId = @SuppId order by OpDate desc
END
GO
/****** Object:  StoredProcedure [Crm].[IssueGetPage]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[IssueGetPage] 

--declare
	@PageNo int, @PageCount int

--select @PageNo = 1, @PageCount = 20

AS
BEGIN
	SET NOCOUNT ON;

	with cte as (
	select ROW_NUMBER() OVER(ORDER BY OpDate, Id) RowNo, *
	from Crm.Issues p) 
	select cte.*
	from cte
	where RowNo >= (@PageNo - 1) * @PageCount and RowNo < (@PageNo) * @PageCount;	

END
GO
/****** Object:  StoredProcedure [Crm].[IssueGetDetails]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[IssueGetDetails] 

--declare
	@Id int

--select @Id = 4

AS
BEGIN
	SET NOCOUNT ON;
	
	select * from Crm.IssuesDetails 
	where IssueId = @Id
	order by LnNo
	
END
GO
/****** Object:  StoredProcedure [Crm].[IssueFindById]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[IssueFindById] 

--declare
	@Id int

--select @Id = 4

AS
BEGIN
	SET NOCOUNT ON;
	
	select * from Crm.Issues where Id = @Id
	
END
GO
/****** Object:  StoredProcedure [CrmSecurity].[UpdateUserPassword]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [CrmSecurity].[UpdateUserLockout]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  View [Crm].[Persons]    Script Date: 11/11/2017 13:49:07 ******/
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
		   a.AG_MEMO as Memo,
		   a.AG_EMAIL as Email
FROM         Попович.dbo.AGENTS a
GO
/****** Object:  StoredProcedure [Crm].[IssueDetailAddOrUpdate]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [Crm].[IssueDetailAddOrUpdate]
	@RetId bigint output, @IssueId int, @LnNo int, @Description nvarchar(255), @Hours money
AS 
BEGIN
	SET NOCOUNT ON;
	set transaction isolation level serializable
	begin tran
	
		declare @McId		int exec CrmSys._GetConstLong '@McId'		,	@McId		output
		declare @AccIdIssue int exec CrmSys._GetConstLong '@AccIdIssue'	,	@AccIdIssue output
		declare @EntIdIssue int exec CrmSys._GetConstLong '@EntIdIssue'	,	@EntIdIssue	output

		declare @PrmTrString1 int exec CrmSys._GetConstLong '@PrmTrString1',@PrmTrString1 output

	
		declare @Ag1 int, @Ag2 int	select top 1 @Ag1 = J_AG1, @Ag2 = J_AG2 from Попович.dbo.JOURNAL where DOC_ID = @IssueId and J_TR_NO = 0 and J_LN_NO = 0

		declare @DocDate datetime	select top 1 @DocDate = DOC_DATE from Попович.dbo.DOCUMENTS where DOC_ID = @IssueId
	
		declare @mergeResult table(act nvarchar(255), Id int)
		----------------------------------------------------------------------------------------------
		-- JOURNAL
		----------------------------------------------------------------------------------------------				
		merge Попович.dbo.JOURNAL as target
		using (select @DocDate, @IssueId, @LnNo, @Description, @Hours, @Ag1, @Ag2) 
			as source(DocDate, IssueId, LnNo, [Description], [Hours], AG1, AG2) 
			on (target.DOC_ID = source.IssueId and target.J_LN_NO = source.LnNo and target.J_TR_NO = 0)
				when matched then
					update set
						target.J_DATE = source.DocDate, target.J_QTY = [Hours]
				when not matched by target then
					insert(DOC_ID,  J_TR_NO, J_LN_NO,   J_DATE, J_DONE, ACC_DB	   , ACC_CR		, J_ENT		 ,  J_QTY, J_SUM, MC_ID, J_AG1, J_AG2)
					values(IssueId,       0,    LnNo,  DocDate,      2, @AccIdIssue, @AccIdIssue, @EntIdIssue,[Hours],     0, @McId,   AG1,   AG2) 
				OUTPUT $action, inserted.J_ID into @mergeResult;

		merge Попович.dbo.JRN_PARAMS as target
		using (	select J_ID
				from @mergeResult m
					inner join Попович.dbo.JOURNAL j on m.Id = j.J_ID
				) as source(
					J_ID
				) on (target.J_ID = source.J_ID and target.PRM_ID = @PrmTrString1)
				when matched then
					update set
						target.PRM_STRING = @Description
				when not matched by target then
					insert(J_ID,  PRM_ID, PRM_STRING)
					values(J_ID,  @PrmTrString1,  @Description)
		OUTPUT $action, inserted.J_ID into @mergeResult;
		
		select * from @mergeResult
					

	commit tran
end
GO
/****** Object:  StoredProcedure [Crm].[PersonUpdate]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [Crm].[PersonGetPage]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [Crm].[PersonGetAll]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Crm].[PersonGetAll] 
AS
BEGIN
	SET NOCOUNT ON;


	select *
	from Crm.Persons
	order by Name
END
GO
/****** Object:  StoredProcedure [Crm].[PersonFindById]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [Crm].[PersonFindByEmail]    Script Date: 11/11/2017 13:49:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [Crm].[PersonFindByEmail] 

--declare
	@Email nvarchar(255)

--select @Email = N'eeeeee@ee.ee'


AS
BEGIN
	SET NOCOUNT ON;
	
	select * from Crm.Persons where Email = @Email
	
END
GO
/****** Object:  StoredProcedure [Crm].[PersonDelete]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  StoredProcedure [Crm].[PersonCreate]    Script Date: 11/11/2017 13:49:08 ******/
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
/****** Object:  Default [DF_Acl_CanView]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanView]  DEFAULT ((0)) FOR [CanView]
GO
/****** Object:  Default [DF_Acl_CanEdit]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanEdit]  DEFAULT ((0)) FOR [CanEdit]
GO
/****** Object:  Default [DF_Acl_CanDelete]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanDelete]  DEFAULT ((0)) FOR [CanDelete]
GO
/****** Object:  Default [DF_Acl_CanApply]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl] ADD  CONSTRAINT [DF_Acl_CanApply]  DEFAULT ((0)) FOR [CanApply]
GO
/****** Object:  Default [DF_User_Guid]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_User_Guid]  DEFAULT (newid()) FOR [Guid]
GO
/****** Object:  Default [DF_Users_TwoFactorEnabled]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_TwoFactorEnabled]  DEFAULT ((0)) FOR [TwoFactorEnabled]
GO
/****** Object:  Default [DF_Users_EmailConfirmed]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_EmailConfirmed]  DEFAULT ((0)) FOR [EmailConfirmed]
GO
/****** Object:  Default [DF_Users_PhoneNumberConfirmed]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_PhoneNumberConfirmed]  DEFAULT ((0)) FOR [PhoneNumberConfirmed]
GO
/****** Object:  Default [DF_Users_LockoutEnabled]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_LockoutEnabled]  DEFAULT ((1)) FOR [LockoutEnabled]
GO
/****** Object:  Default [DF_Users_AccessFailedCount]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_AccessFailedCount]  DEFAULT ((0)) FOR [AccessFailedCount]
GO
/****** Object:  Default [DF_Users_Locale]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Users] ADD  CONSTRAINT [DF_Users_Locale]  DEFAULT ('uk_UA') FOR [Locale]
GO
/****** Object:  Check [CK_Acl_CanApply]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanApply] CHECK  (([CanApply]=(-1) OR [CanApply]=(1) OR [CanApply]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanApply]
GO
/****** Object:  Check [CK_Acl_CanDelete]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanDelete] CHECK  (([CanDelete]=(-1) OR [CanDelete]=(1) OR [CanDelete]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanDelete]
GO
/****** Object:  Check [CK_Acl_CanEdit]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanEdit] CHECK  (([CanEdit]=(-1) OR [CanEdit]=(1) OR [CanEdit]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanEdit]
GO
/****** Object:  Check [CK_Acl_CanView]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [CK_Acl_CanView] CHECK  (([CanView]=(-1) OR [CanView]=(1) OR [CanView]=(0)))
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [CK_Acl_CanView]
GO
/****** Object:  ForeignKey [FK_Acl_GroupId_Groups]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [FK_Acl_GroupId_Groups] FOREIGN KEY([GroupId])
REFERENCES [CrmSecurity].[Groups] ([Id])
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [FK_Acl_GroupId_Groups]
GO
/****** Object:  ForeignKey [FK_Acl_UserId_AG_USER]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[Acl]  WITH CHECK ADD  CONSTRAINT [FK_Acl_UserId_AG_USER] FOREIGN KEY([UserId])
REFERENCES [CrmSecurity].[Users] ([Id])
GO
ALTER TABLE [CrmSecurity].[Acl] CHECK CONSTRAINT [FK_Acl_UserId_AG_USER]
GO
/****** Object:  ForeignKey [FK_UserGroups_Group_Id]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[UserGroups]  WITH CHECK ADD  CONSTRAINT [FK_UserGroups_Group_Id] FOREIGN KEY([GroupId])
REFERENCES [CrmSecurity].[Groups] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserGroups] CHECK CONSTRAINT [FK_UserGroups_Group_Id]
GO
/****** Object:  ForeignKey [FK_UserGroups_Users_Id]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[UserGroups]  WITH CHECK ADD  CONSTRAINT [FK_UserGroups_Users_Id] FOREIGN KEY([UserId])
REFERENCES [CrmSecurity].[Users] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserGroups] CHECK CONSTRAINT [FK_UserGroups_Users_Id]
GO
/****** Object:  ForeignKey [FK_UserRoles_GroupId_Id]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_GroupId_Id] FOREIGN KEY([GroupId])
REFERENCES [CrmSecurity].[Groups] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_GroupId_Id]
GO
/****** Object:  ForeignKey [FK_UserRoles_Roles_Id]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Roles_Id] FOREIGN KEY([RoleId])
REFERENCES [CrmSecurity].[Roles] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Roles_Id]
GO
/****** Object:  ForeignKey [FK_UserRoles_Users_Id]    Script Date: 11/11/2017 13:49:06 ******/
ALTER TABLE [CrmSecurity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Users_Id] FOREIGN KEY([UserId])
REFERENCES [CrmSecurity].[Users] ([Id])
GO
ALTER TABLE [CrmSecurity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Users_Id]
GO
GRANT EXECUTE ON SCHEMA::[CrmSecurity] TO [public] AS [dbo]
GO
