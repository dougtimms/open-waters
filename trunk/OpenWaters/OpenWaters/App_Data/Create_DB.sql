﻿/***************************************************************** */
/*************DROP EXISTING DATAABSE (only use if refreshing DB*** */
/***************************************************************** */
/*
	  EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'OpenEnvironment'
	  GO
	  USE [master]
	  GO
	  ALTER DATABASE [OpenEnvironment] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
	  GO
	  USE [master]
	  GO
	  DROP DATABASE [OpenEnvironment]
	  GO
	  IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'oe_login')
	  DROP LOGIN [oe_login]
*/

/************************************************************************* */
/*******************CREATE DATABASE*************************************** */
/************************************************************************* */
CREATE DATABASE [OpenEnvironment]
GO

/************************************************************************* */
/*************CREATE USER AND GRANT RIGHTS******************************** */
/************************************************************************* */
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'oe_login')
DROP LOGIN [oe_login]

use [OpenEnvironment]

Create login oe_login with password='R!j23@pLZ88$e';
EXEC sp_defaultdb @loginame='oe_login', @defdb='OpenEnvironment' 
Create user [oe_user] for login [oe_login]; 
exec sp_addrolemember 'db_owner', 'oe_user'; 


/************************************************************ */
/*************CREATE TABLES  ******************************** */
/************************************************************ */
Use [OpenEnvironment] 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[T_OE_APP_SETTINGS](
	[SETTING_IDX] [int] IDENTITY(1,1) NOT NULL,
	[SETTING_NAME] [varchar](100) NOT NULL,
	[SETTING_DESC] [varchar](500) NULL,
	[SETTING_VALUE] [varchar](200) NULL,
	[ENCRYPT_IND] [bit] NULL,
	[SETTING_VALUE_SALT] [varchar](100) NULL,
	[MODIFY_USERID] [varchar](25) NULL,
	[MODIFY_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_OE_APP_SETTINGS] PRIMARY KEY CLUSTERED ([SETTING_IDX] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Public App Path','http://www.open-waters.com/','The full URL of the deployed application. This is used when sending emails.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('CDX Submission URL','https://cdxnodengn.epa.gov/ngn-enws20/services/NetworkNode2ServiceConditionalMTOM','The URL used for submitting data to EPA-WQX','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('CDX Ref Data URL','http://cdx.epa.gov/WQXWeb/services.asmx','The URL used for retrieving reference data from EPA','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('CDX Submitter','','The default NAAS account used for submitting data to or retrieving data from EPA, if no value is provided at the organization level.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[ENCRYPT_IND],[SETTING_VALUE_SALT],[MODIFY_USERID],[MODIFY_DT]) VALUES ('CDX Submitter Password','','The password for the default NAAS account used for submitting data to or retrieving data from EPA, if no value is provided at the organization level.',1,'','SYSTEM',GetDate());

INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Email From','open-waters@open-environment.org','The email address in the FROM line when sending emails from Open Waters','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Email Server','','The SMTP email server used to allow Open Waters to send emails.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Email Port','25','The port used to access the SMTP email server.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Email Secure User','','If the SMTP server requires authentication, this is the SMTP server username.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Email Secure Pwd','','If the SMTP server requires authentication, this is the SMTP server password.','SYSTEM',GetDate());

INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Log Level','ERROR','Set application log level to DEBUG to perform additional system logging.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Default State','OK','Default state to be used if none is supplied at the Organization level.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Default Timezone','','Default timezone applied to samples if no default time zone is specified at the Organization level.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Allow Self Reg','Y','Set to Y to allow people to create their own user accounts.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Beta Program','Y','Set to Y to institute a beta program that would require users to obtain a beta code in order to Open Waters.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Beta Invite Code','','Beta invite code.','SYSTEM',GetDate());
INSERT INTO T_OE_APP_SETTINGS ([SETTING_NAME],[SETTING_VALUE],[SETTING_DESC],[MODIFY_USERID],[MODIFY_DT]) VALUES ('Task App Path','C:\OpenWatersSvc','Define the path to the windows service.','SYSTEM',GetDate());

	 
GO

/****** Object:  Table [dbo].[T_OE_APP_TASKS]    ******/
CREATE TABLE [dbo].[T_OE_APP_TASKS](
	[TASK_IDX] [int] IDENTITY(1,1) NOT NULL,
	[TASK_NAME] [varchar](30) NOT NULL,
	[TASK_DESC] [varchar](100) NOT NULL,
	[TASK_STATUS] [varchar](10) NOT NULL,
	[TASK_FREQ_MS] [int] NOT NULL,
	[MODIFY_USERID] [varchar](25) NULL,
	[MODIFY_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_OE_APP_TASKS] PRIMARY KEY CLUSTERED ([TASK_IDX] ASC)
) ON [PRIMARY]

INSERT INTO [T_OE_APP_TASKS] ([TASK_NAME],[TASK_DESC],[TASK_STATUS],[TASK_FREQ_MS],[MODIFY_USERID],[MODIFY_DT])
    VALUES ('WQXSubmit','Submit WQX data to EPA','STOPPED',10000,'SYSTEM',GetDate());


CREATE TABLE [dbo].[T_OE_SYS_LOG](
	[SYS_LOG_ID] [int] IDENTITY(1,1) NOT NULL,
	[LOG_DT] [datetime2](0) NOT NULL,
	[LOG_USERIDX] [int] NULL,
	[LOG_TYPE] [varchar](15) NULL,
	[LOG_MSG] [varchar](2000) NULL,
 CONSTRAINT [PK_T_REF_SYS_LOG] PRIMARY KEY CLUSTERED  (SYS_LOG_ID ASC)
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[T_OE_USERS]    ******/
CREATE TABLE [dbo].[T_OE_USERS](
	[USER_IDX] [int] IDENTITY(1,1) NOT NULL,
	[USER_ID] [varchar](25) NOT NULL,
	[PWD_HASH] [varchar](100) NOT NULL,
	[PWD_SALT] [varchar](100) NOT NULL,
	[FNAME] [varchar](40) NOT NULL,
	[LNAME] [varchar](40) NOT NULL,
	[EMAIL] [varchar](150) NULL,
	[INITAL_PWD_FLAG] [bit] NOT NULL,
	[EFFECTIVE_DT] [datetime2](0) NOT NULL,
	[LASTLOGIN_DT] [datetime2](0) NULL,
	[PHONE] [varchar](12) NULL,
	[PHONE_EXT] [varchar](4) NULL,
	[DEFAULT_ORG_ID] [varchar](30) NULL,  --added v1.3
	[ACT_IND] [bit] NOT NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[CREATE_DT] [datetime2](0) NULL,
	[MODIFY_USERID] [varchar](25) NULL,
	[MODIFY_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_OE_USERS] PRIMARY KEY CLUSTERED ( [USER_IDX] ASC)
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[T_OE_ROLES](
	[ROLE_IDX] [int] IDENTITY(1,1) NOT NULL,
	[ROLE_NAME] [varchar](25) NOT NULL,
	[ROLE_DESC] [varchar](100) NOT NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[CREATE_DT] [datetime2](0) NULL,
	[MODIFY_USERID] [varchar](25) NULL,
	[MODIFY_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_OE_ROLES] PRIMARY KEY CLUSTERED  ([ROLE_IDX] ASC)
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[T_OE_USER_ROLES](
	[USER_ROLE_IDX] [int] IDENTITY(1,1) NOT NULL,
	[USER_IDX] [int] NOT NULL,
	[ROLE_IDX] [int] NOT NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[CREATE_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_OE_USER_ROLES] PRIMARY KEY CLUSTERED ([USER_ROLE_IDX] ASC),
 CONSTRAINT [UK_T_OE_USER_ROLES] UNIQUE NONCLUSTERED ([USER_IDX] ASC, [ROLE_IDX] ASC),
 FOREIGN KEY (ROLE_IDX) references T_OE_ROLES (ROLE_IDX) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE, 
 FOREIGN KEY (USER_IDX) references T_OE_USERS (USER_IDX)
 	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ON [PRIMARY]

GO


insert into T_OE_ROLES (ROLE_NAME, ROLE_DESC, CREATE_USERID, CREATE_DT) values ('USERS', 'Application users', 'system', GetDate());
insert into T_OE_ROLES (ROLE_NAME, ROLE_DESC, CREATE_USERID, CREATE_DT) values ('ADMINS', 'Application Administrator', 'system', GetDate());
insert into T_OE_ROLES (ROLE_NAME, ROLE_DESC, CREATE_USERID, CREATE_DT) values ('READONLY', 'People with this role cannot add or edit any data in the system', 'system', GetDate());

insert into T_OE_USERS ([USER_ID], PWD_HASH, PWD_SALT, FNAME, LNAME, ACT_IND, INITAL_PWD_FLAG, EFFECTIVE_DT, LASTLOGIN_DT, PHONE, PHONE_EXT, CREATE_USERID, CREATE_DT, MODIFY_USERID, MODIFY_DT)
values ('ADMIN', 'pwd','', 'Admin','Admin',1,1,GETDATE(),null, null, null, 'SYSTEM',GETDATE(),'SYSTEM',GETDATE());

insert into T_OE_USER_ROLES (USER_IDX, ROLE_IDX) values (1,1);
insert into T_OE_USER_ROLES (USER_IDX, ROLE_IDX) values (1,2);

--******************************************************************************************************************************************
--******************************************************************************************************************************************
--************************************************************WQX TABLES  ******************************************************************
--******************************************************************************************************************************************
--******************************************************************************************************************************************
CREATE TABLE [dbo].[T_WQX_REF_DEFAULT_TIME_ZONE](
	[TIME_ZONE_NAME] [varchar](20) NOT NULL,
	[OFFICIAL_TIME_ZONE_NAME] [varchar](50) NULL,
	[WQX_CODE_STANDARD] [varchar](4) NOT NULL,
	[WQX_CODE_DAYLIGHT] [varchar](4) NULL,
	[ACT_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_REF_DEFAULT_TIME_ZONE] PRIMARY KEY CLUSTERED ([TIME_ZONE_NAME] ASC)
) ON [PRIMARY]

INSERT INTO T_WQX_REF_DEFAULT_TIME_ZONE (TIME_ZONE_NAME,OFFICIAL_TIME_ZONE_NAME,WQX_CODE_STANDARD,WQX_CODE_DAYLIGHT,ACT_IND,UPDATE_DT,UPDATE_USERID) VALUES ('Atlantic','Atlantic Standard Time','AST','ADT',1,GetDate(),'SYSTEM');
INSERT INTO T_WQX_REF_DEFAULT_TIME_ZONE (TIME_ZONE_NAME,OFFICIAL_TIME_ZONE_NAME,WQX_CODE_STANDARD,WQX_CODE_DAYLIGHT,ACT_IND,UPDATE_DT,UPDATE_USERID) VALUES ('Eastern','Eastern Standard Time','EST','EDT',1,GetDate(),'SYSTEM');
INSERT INTO T_WQX_REF_DEFAULT_TIME_ZONE (TIME_ZONE_NAME,OFFICIAL_TIME_ZONE_NAME,WQX_CODE_STANDARD,WQX_CODE_DAYLIGHT,ACT_IND,UPDATE_DT,UPDATE_USERID) VALUES ('Central','Central Standard Time','CST','CDT',1,GetDate(),'SYSTEM');
INSERT INTO T_WQX_REF_DEFAULT_TIME_ZONE (TIME_ZONE_NAME,OFFICIAL_TIME_ZONE_NAME,WQX_CODE_STANDARD,WQX_CODE_DAYLIGHT,ACT_IND,UPDATE_DT,UPDATE_USERID) VALUES ('Mountain','Mountain Standard Time','MST','MDT',1,GetDate(),'SYSTEM');
INSERT INTO T_WQX_REF_DEFAULT_TIME_ZONE (TIME_ZONE_NAME,OFFICIAL_TIME_ZONE_NAME,WQX_CODE_STANDARD,WQX_CODE_DAYLIGHT,ACT_IND,UPDATE_DT,UPDATE_USERID) VALUES ('Pacific','Pacific Standard Time','MST','MDT',1,GetDate(),'SYSTEM');
INSERT INTO T_WQX_REF_DEFAULT_TIME_ZONE (TIME_ZONE_NAME,OFFICIAL_TIME_ZONE_NAME,WQX_CODE_STANDARD,WQX_CODE_DAYLIGHT,ACT_IND,UPDATE_DT,UPDATE_USERID) VALUES ('Alaskan','Alaskan Standard Time','AKST','AKDT',1,GetDate(),'SYSTEM');



CREATE TABLE [dbo].[T_WQX_REF_LAB](
	[LAB_IDX] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](120) NOT NULL,
	[LAB_NAME] [varchar](60) NOT NULL,
	[LAB_ACCRED_IND] [char](1) NULL,
	[LAB_ACCRED_AUTHORITY] [varchar](20) NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_REF_LAB] PRIMARY KEY CLUSTERED (LAB_IDX ASC)
) ON [PRIMARY]


CREATE TABLE [dbo].[T_WQX_REF_ANAL_METHOD](
	[ANALYTIC_METHOD_IDX] [int] NOT NULL IDENTITY(1,1),
	[ANALYTIC_METHOD_ID] [varchar](20) NOT NULL,
	[ANALYTIC_METHOD_CTX] [varchar](120) NOT NULL,
	[ANALYTIC_METHOD_NAME] [varchar](120) NULL,
	[ANALYTIC_METHOD_DESC] [varchar](4000) NULL,
	[ACT_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
 CONSTRAINT [PK_WQX_REF_ANAL_METHOD] PRIMARY KEY CLUSTERED (ANALYTIC_METHOD_IDX ASC)
) ON [PRIMARY]


CREATE TABLE T_WQX_REF_SAMP_COL_METHOD(
	[SAMP_COLL_METHOD_IDX] [int] IDENTITY(1,1) NOT NULL,
	[SAMP_COLL_METHOD_ID] [varchar](20) NOT NULL,
	[SAMP_COLL_METHOD_CTX] [varchar](120) NOT NULL,
	[SAMP_COLL_METHOD_NAME] [varchar](120) NULL,
	[SAMP_COLL_METHOD_DESC] [varchar](4000) NULL,
	[ACT_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
 CONSTRAINT [PK_WQX_REF_SAMP_COL_METHOD] PRIMARY KEY CLUSTERED  ([SAMP_COLL_METHOD_IDX] ASC)
) ON [PRIMARY]


CREATE TABLE T_WQX_REF_SAMP_PREP(
	[SAMP_PREP_IDX] [int] IDENTITY(1,1) NOT NULL,
	[SAMP_PREP_METHOD_ID] [varchar](20) NOT NULL,
	[SAMP_PREP_METHOD_CTX] [varchar](120) NOT NULL,
	[SAMP_PREP_METHOD_NAME] [varchar](120) NULL,
	[SAMP_PREP_METHOD_DESC] [varchar](4000) NULL,
	[ACT_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
 CONSTRAINT [PK_WQX_REF_SAMP_PREP] PRIMARY KEY CLUSTERED  ([SAMP_PREP_IDX] ASC)
) ON [PRIMARY]


CREATE TABLE [dbo].[T_WQX_REF_DATA](
	[REF_DATA_IDX] [int] NOT NULL IDENTITY(1,1),
	[TABLE] [varchar](45) NOT NULL,
	[VALUE] [varchar](100) NOT NULL,
	[TEXT] [varchar](200) NOT NULL,
	[ACT_IND] [bit] NULL,
	[USED_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
 CONSTRAINT [PK_WQX_REF_DATA] PRIMARY KEY CLUSTERED (REF_DATA_IDX ASC)
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[T_WQX_REF_COUNTY](
	[STATE_CODE] [varchar](2) NOT NULL,
	[COUNTY_CODE] [varchar](3) NOT NULL,
	[COUNTY_NAME] [varchar](50) NOT NULL,
	[ACT_IND] [bit] NULL,
	[USED_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
 CONSTRAINT [PK_WQX_REF_COUNTY] PRIMARY KEY CLUSTERED (STATE_CODE ASC, COUNTY_CODE ASC)
) ON [PRIMARY]


CREATE TABLE [dbo].[T_WQX_REF_CHARACTERISTIC](
	[CHAR_NAME] [varchar](120) NOT NULL,
	[DEFAULT_DETECT_LIMIT] [decimal](12,5) NULL,
	[DEFAULT_UNIT] [varchar](12) NULL,
	[USED_IND] [bit] NULL,
	[ACT_IND] [bit] NULL,
	[UPDATE_DT] [datetime] NULL,
	[SAMP_FRAC_REQ] varchar(1) NULL,
	[PICK_LIST] varchar(1) NULL,
 CONSTRAINT [PK_T_WQX_REF_CHARACTERISTIC] PRIMARY KEY CLUSTERED (CHAR_NAME ASC)
) ON [PRIMARY]

CREATE TABLE [dbo].[T_WQX_REF_CHAR_LIMITS](
	[CHAR_NAME] [varchar](120) NOT NULL,
	[UNIT_NAME] [varchar](12) NOT NULL,
	[LOWER_BOUND] [decimal] NULL,
	[UPPER_BOUND] [decimal] NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_T_WQX_REF_CHAR_LIMITS] PRIMARY KEY CLUSTERED (CHAR_NAME ASC, UNIT_NAME ASC),
 FOREIGN KEY (CHAR_NAME) references T_WQX_REF_CHARACTERISTIC (CHAR_NAME) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[T_EPA_ORGS](
	[ORG_ID] [varchar](30) NOT NULL,
	[ORG_FORMAL_NAME] [varchar](120) NOT NULL,
	[UPDATE_DT] [datetime] NULL,
 CONSTRAINT [PK_EPA_ORGANIZATION] PRIMARY KEY CLUSTERED ([ORG_ID] ASC)
) ON [PRIMARY]

CREATE TABLE [dbo].[T_WQX_ORGANIZATION](
	[ORG_ID] [varchar](30) NOT NULL,
	[ORG_FORMAL_NAME] [varchar](120) NOT NULL,
	[ORG_DESC] [varchar](500) NULL,
	[TRIBAL_CODE] [varchar](3) NULL,
	[ELECTRONICADDRESS] [varchar](120) NOT NULL,
	[ELECTRONICADDRESSTYPE] [varchar](8) NULL,
	[TELEPHONE_NUM] [varchar](15) NOT NULL,
	[TELEPHONE_NUM_TYPE] [varchar](6) NULL,
	[TELEPHONE_EXT] [varchar](6) NULL,
	[CDX_SUBMITTER_ID] varchar(100) NULL, 
	[CDX_SUBMITTER_PWD_HASH] varchar(100) NULL, 
	[CDX_SUBMITTER_PWD_SALT] varchar(100) NULL, 
	[CDX_SUBMIT_IND] bit default 1 NULL,
	[DEFAULT_TIMEZONE] varchar(20) NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_ORGANIZATION] PRIMARY KEY CLUSTERED ([ORG_ID] ASC)
) ON [PRIMARY]



CREATE TABLE [dbo].[T_WQX_ORG_ADDRESS](
	[ORG_ID] [varchar](30) NOT NULL,
	[ADDRESS_TYPE] [varchar](8) NOT NULL,
	[ADDRESS] [varchar](50) NOT NULL,
	[SUPP_ADDRESS] [varchar](120) NULL,
	[LOCALITY] [varchar](30) NULL,
	[STATE_CD] [varchar](2) NULL,
	[POSTAL_CD] [varchar](10) NULL,
	[COUNTRY_CD] [varchar](2) NULL,
	[COUNTY_CD] [varchar](3) NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_ORG_ADDRESS] PRIMARY KEY CLUSTERED (ORG_ID,ADDRESS_TYPE ASC),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID)  ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[T_WQX_USER_ORGS](
	[USER_IDX] [int] NOT NULL,
	[ORG_ID] [varchar](30) NOT NULL,
	[ROLE_CD] [varchar](2) NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[CREATE_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_OE_USER_ORGS] PRIMARY KEY CLUSTERED (USER_IDX, ORG_ID),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE, 
 FOREIGN KEY (USER_IDX) references T_OE_USERS (USER_IDX)
 	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[T_WQX_PROJECT](
	[PROJECT_IDX] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](30) NOT NULL,
	[PROJECT_ID] [varchar](35) NOT NULL,
	[PROJECT_NAME] [varchar](120) NOT NULL,
	[PROJECT_DESC] [varchar](1999) NULL,
	[SAMP_DESIGN_TYPE_CD] [varchar](20) NULL,
	[QAPP_APPROVAL_IND] [bit] NULL,
	[QAPP_APPROVAL_AGENCY] [varchar](50) NULL,
	[WQX_IND] [bit] NULL,
	[WQX_SUBMIT_STATUS] [varchar](1) NULL,
	[WQX_UPDATE_DT] [datetime] NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
CONSTRAINT [PK_WQX_PROJECT] PRIMARY KEY CLUSTERED (PROJECT_IDX ASC),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID)  ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]



CREATE TABLE [dbo].[T_WQX_MONLOC](
	[MONLOC_IDX] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](30) NOT NULL,
	[MONLOC_ID] [varchar](35) NOT NULL,
	[MONLOC_NAME] [varchar](255) NOT NULL,
	[MONLOC_TYPE] [varchar](45) NOT NULL,
	[MONLOC_DESC] [varchar](1999) NULL,
	[HUC_EIGHT] [varchar](8) NULL,
	[HUC_TWELVE] [varchar](12) NULL,
	[TRIBAL_LAND_IND] [char](1) NULL,
	[TRIBAL_LAND_NAME] [varchar](200) NULL,
	[LATITUDE_MSR] [varchar](30) NOT NULL,
	[LONGITUDE_MSR] [varchar](30) NOT NULL,
	[SOURCE_MAP_SCALE] [int] NULL,
	[HORIZ_ACCURACY] [varchar](12) NULL,
	[HORIZ_ACCURACY_UNIT] [varchar](12) NULL,
	[HORIZ_COLL_METHOD] [varchar](150) NULL,
	[HORIZ_REF_DATUM] [varchar](6) NULL,
	[VERT_MEASURE] [varchar](12) NULL,
	[VERT_MEASURE_UNIT] [varchar](12) NULL,
	[VERT_COLL_METHOD] [varchar](50) NULL,
	[VERT_REF_DATUM] [varchar](10) NULL,
	[COUNTRY_CODE] [varchar](2) NULL,
	[STATE_CODE] [varchar](2) NULL,
	[COUNTY_CODE] [varchar](3) NULL,
	[WELL_TYPE] [varchar](255) NULL,
	[AQUIFER_NAME] [varchar](120) NULL,
	[FORMATION_TYPE] [varchar](50) NULL,
	[WELLHOLE_DEPTH_MSR] [varchar](12) NULL,
	[WELLHOLE_DEPTH_MSR_UNIT] [varchar](12) NULL,
	[WQX_IND] [bit] NULL,
	[WQX_SUBMIT_STATUS] [varchar](1) NULL,
	[WQX_UPDATE_DT] [datetime] NULL,
	[IMPORT_MONLOC_ID] [varchar](35) NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_MONLOC] PRIMARY KEY CLUSTERED  (MONLOC_IDX ASC),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID)  ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]




CREATE TABLE [dbo].[T_WQX_ACTIVITY](
	[ACTIVITY_IDX] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](30) NOT NULL,
	[PROJECT_IDX] [int] NOT NULL,
	[MONLOC_IDX] [int] NULL,
	[ACTIVITY_ID] [varchar](35) NOT NULL,
	[ACT_TYPE] [varchar](70) NOT NULL,
	[ACT_MEDIA] [varchar](20) NOT NULL,
	[ACT_SUBMEDIA] [varchar](45) NULL,
	[ACT_START_DT] [datetime] NOT NULL,
	[ACT_END_DT] [datetime] NULL,
	[ACT_TIME_ZONE] [varchar](4) NULL,
	[RELATIVE_DEPTH_NAME] [varchar](15) NULL,
	[ACT_DEPTHHEIGHT_MSR] [varchar](12) NULL,
	[ACT_DEPTHHEIGHT_MSR_UNIT] [varchar](12) NULL,
	[TOP_DEPTHHEIGHT_MSR] [varchar](12) NULL,
	[TOP_DEPTHHEIGHT_MSR_UNIT] [varchar](12) NULL,
	[BOT_DEPTHHEIGHT_MSR] [varchar](12) NULL,
	[BOT_DEPTHHEIGHT_MSR_UNIT] [varchar](12) NULL,
	[DEPTH_REF_POINT] [varchar](125) NULL,
	[ACT_COMMENT] [varchar](4000) NULL,
	[BIO_ASSEMBLAGE_SAMPLED] [varchar](50) NULL,
	[BIO_DURATION_MSR] [varchar](12) NULL,
	[BIO_DURATION_MSR_UNIT] [varchar](12) NULL,
	[BIO_SAMP_COMPONENT] [varchar](15) NULL,
	[BIO_SAMP_COMPONENT_SEQ] [int] NULL,
	[BIO_REACH_LEN_MSR] [varchar](12) NULL,
	[BIO_REACH_LEN_MSR_UNIT] [varchar](12) NULL,
	[BIO_REACH_WID_MSR] [varchar](12) NULL,
	[BIO_REACH_WID_MSR_UNIT] [varchar](12) NULL,
	[BIO_PASS_COUNT] [int] NULL,
	[BIO_NET_TYPE] [varchar](30) NULL,
	[BIO_NET_AREA_MSR] [varchar](12) NULL,
	[BIO_NET_AREA_MSR_UNIT] [varchar](12) NULL,
	[BIO_NET_MESHSIZE_MSR] [varchar](12) NULL,
	[BIO_MESHSIZE_MSR_UNIT] [varchar](12) NULL,
	[BIO_BOAT_SPEED_MSR] [varchar](12) NULL,
	[BIO_BOAT_SPEED_MSR_UNIT] [varchar](12) NULL,
	[BIO_CURR_SPEED_MSR] [varchar](12) NULL,
	[BIO_CURR_SPEED_MSR_UNIT] [varchar](12) NULL,
	[BIO_TOXICITY_TEST_TYPE] [varchar](7) NULL,
	[SAMP_COLL_METHOD_IDX] [int] NULL,
	[SAMP_COLL_EQUIP] [varchar](40) NULL,
	[SAMP_COLL_EQUIP_COMMENT] [varchar](4000) NULL,
	[SAMP_PREP_IDX] [int] NULL,
	[SAMP_PREP_CONT_TYPE] [varchar](35) NULL,
	[SAMP_PREP_CONT_COLOR] [varchar](15) NULL,
	[SAMP_PREP_CHEM_PRESERV] [varchar](250) NULL,
	[SAMP_PREP_THERM_PRESERV] [varchar](25) NULL,
	[SAMP_PREP_STORAGE_DESC] [varchar](250) NULL,
	[WQX_IND] [bit] NULL,
	[WQX_SUBMIT_STATUS] [varchar](1) NULL,
	[WQX_UPDATE_DT] [datetime] NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
	[TEMP_SAMPLE_IDX] [int] NULL,
	[ENTRY_TYPE] varchar(1) NULL,
 CONSTRAINT [PK_WQX_ACTIVITY] PRIMARY KEY CLUSTERED ([ACTIVITY_IDX] ASC),
 FOREIGN KEY (PROJECT_IDX) references T_WQX_PROJECT (PROJECT_IDX) ,
 FOREIGN KEY (MONLOC_IDX) references T_WQX_MONLOC (MONLOC_IDX) ,
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID)  
) ON [PRIMARY]


CREATE TABLE [dbo].[T_WQX_BIO_HABITAT_INDEX](
	[BIO_HABITAT_INDEX_IDX] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](30) NOT NULL,
	[MONLOC_IDX] [int] NULL,
	[INDEX_ID] [varchar](35) NOT NULL,
	[INDEX_TYPE_ID] [varchar](35) NOT NULL,
	[INDEX_TYPE_ID_CONTEXT] [varchar](50) NOT NULL,
	[INDEX_TYPE_NAME] [varchar](50) NOT NULL,
	[RESOURCE_TITLE] [varchar](120) NULL,
	[RESOURCE_CREATOR] [varchar](120) NULL,
	[RESOURCE_SUBJECT] [varchar](400) NULL,
	[RESOURCE_PUBLISHER] [varchar](60) NULL,
	[RESOURCE_DATE] [datetime] NULL,
	[RESOURCE_ID] [varchar](255) NULL,
	[INDEX_TYPE_SCALE] [varchar](50) NULL,
	[INDEX_SCORE] [varchar](10) NOT NULL,
	[INDEX_QUAL_CD] [varchar](5) NULL,
	[INDEX_COMMENT] [varchar](4000) NULL,
	[INDEX_CALC_DATE] [datetime] NULL,
	[WQX_IND] [bit] NULL,
	[WQX_SUBMIT_STATUS] [varchar](1) NULL,
	[WQX_UPDATE_DT] [datetime] NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_T_WQX_BIO_HABITAT_INDEX] PRIMARY KEY CLUSTERED ([BIO_HABITAT_INDEX_IDX] ASC),
 FOREIGN KEY (MONLOC_IDX) references T_WQX_MONLOC (MONLOC_IDX),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID)  
) ON [PRIMARY]


CREATE TABLE [dbo].[T_WQX_ACTIVITY_METRIC](
	[ACTIVITY_METRIC_IDX] [int] NOT NULL IDENTITY(1,1),
	[ACTIVITY_IDX] [int] NOT NULL,
	[METRIC_TYPE_ID] [varchar](35) NOT NULL,
	[METRIC_TYPE_ID_CONTEXT] [varchar](50) NOT NULL,
	[METRIC_TYPE_NAME] [varchar](50) NULL,
	[CITATION_TITLE] [varchar](120) NULL,
	[CITATION_CREATOR] [varchar](120) NULL,
	[CITATION_SUBJECT] [varchar](500) NULL,
	[CITATION_PUBLISHER] [varchar](60) NULL,
	[CITATION_DATE] [datetime] NULL,
	[CITATION_ID] [varchar](255) NULL,
	[METRIC_SCALE] [varchar](50) NULL,
	[METRIC_FORMULA_DESC] [varchar](50) NULL,
	[METRIC_VALUE_MSR] [varchar](12) NULL,
	[METRIC_VALUE_MSR_UNIT] [varchar](12) NULL,
	[METRIC_SCORE] [varchar](10) NOT NULL,
	[METRIC_COMMENT] [varchar](4000) NULL,
	[BIO_HABITAT_INDEX_IDX] [int] NULL,
	[WQX_IND] [bit] NULL,
	[WQX_SUBMIT_STATUS] [varchar](1) NULL,
	[WQX_UPDATE_DT] [datetime] NULL,
	[ACT_IND] [bit] NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[UPDATE_DT] [datetime] NULL,
	[UPDATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_ACTIVITYMETRIC] PRIMARY KEY CLUSTERED ([ACTIVITY_METRIC_IDX] ASC),
 FOREIGN KEY (ACTIVITY_IDX) references T_WQX_ACTIVITY (ACTIVITY_IDX)  ON UPDATE CASCADE ON DELETE CASCADE, 
 FOREIGN KEY (BIO_HABITAT_INDEX_IDX) references T_WQX_BIO_HABITAT_INDEX (BIO_HABITAT_INDEX_IDX)  ON UPDATE CASCADE ON DELETE CASCADE 
) ON [PRIMARY]





CREATE TABLE [dbo].[T_WQX_RESULT](
	[RESULT_IDX] [int] NOT NULL IDENTITY(1,1),
	[ACTIVITY_IDX] [int] NOT NULL,
	[DATA_LOGGER_LINE] [varchar](15) NULL,
	[RESULT_DETECT_CONDITION] [varchar](35) NULL,
	[CHAR_NAME] [varchar](120) NULL,
	[METHOD_SPECIATION_NAME] [varchar](20) NULL,
	[RESULT_SAMP_FRACTION] [varchar](25) NULL,
	[RESULT_MSR] [varchar](60) NULL,
	[RESULT_MSR_UNIT] [varchar](12) NULL,
	[RESULT_MSR_QUAL] [varchar](5) NULL,
	[RESULT_STATUS] [varchar](12) NULL,
	[STATISTIC_BASE_CODE] [varchar](25) NULL,
	[RESULT_VALUE_TYPE] [varchar](20) NULL,
	[WEIGHT_BASIS] [varchar](15) NULL,
	[TIME_BASIS] [varchar](12) NULL,
	[TEMP_BASIS] [varchar](12) NULL,
	[PARTICLESIZE_BASIS] [varchar](15) NULL,
	[PRECISION_VALUE] [varchar](60) NULL,
	[BIAS_VALUE] [varchar](60) NULL,
	[CONFIDENCE_INTERVAL_VALUE] [varchar](15) NULL,
	[UPPER_CONFIDENCE_LIMIT] [varchar](15) NULL,
	[LOWER_CONFIDENCE_LIMIT] [varchar](15) NULL,
	[RESULT_COMMENT] [varchar](4000) NULL,
	[DEPTH_HEIGHT_MSR] [varchar](12) NULL,
	[DEPTH_HEIGHT_MSR_UNIT] [varchar](12) NULL,
	[DEPTHALTITUDEREFPOINT] [varchar](125) NULL,
	[RESULT_SAMP_POINT] [varchar](12) NULL,
	[BIO_INTENT_NAME] [varchar](35) NULL,
	[BIO_INDIVIDUAL_ID] [varchar](4) NULL,
	[BIO_SUBJECT_TAXONOMY] [varchar](120) NULL,
	[BIO_UNIDENTIFIED_SPECIES_ID] [varchar](120) NULL,
	[BIO_SAMPLE_TISSUE_ANATOMY] [varchar](30) NULL,
	[GRP_SUMM_COUNT_WEIGHT_MSR] [varchar](12) NULL,
	[GRP_SUMM_COUNT_WEIGHT_MSR_UNIT] [varchar](12) NULL,
	[TAX_DTL_CELL_FORM] [varchar](11) NULL,
	[TAX_DTL_CELL_SHAPE] [varchar](18) NULL,
	[TAX_DTL_HABIT] [varchar](15) NULL,
	[TAX_DTL_VOLTINISM] [varchar](25) NULL,
	[TAX_DTL_POLL_TOLERANCE] [varchar](4) NULL,
	[TAX_DTL_POLL_TOLERANCE_SCALE] [varchar](50) NULL,
	[TAX_DTL_TROPHIC_LEVEL] [varchar](4) NULL,
	[TAX_DTL_FUNC_FEEDING_GROUP1] [varchar](6) NULL,
	[TAX_DTL_FUNC_FEEDING_GROUP2] [varchar](6) NULL,
	[TAX_DTL_FUNC_FEEDING_GROUP3] [varchar](6) NULL,
	[FREQ_CLASS_CODE] [varchar](50) NULL,
	[FREQ_CLASS_UNIT] [varchar](12) NULL,
	[FREQ_CLASS_UPPER] [varchar](8) NULL,
	[FREQ_CLASS_LOWER] [varchar](8) NULL,
	[ANALYTIC_METHOD_IDX] [int] NULL,
	[LAB_IDX] [int] NULL,
	[LAB_ANALYSIS_START_DT] [datetime] NULL,
	[LAB_ANALYSIS_END_DT] [datetime] NULL,
	[LAB_ANALYSIS_TIMEZONE] [varchar](4) NULL,
	[RESULT_LAB_COMMENT_CODE] [varchar](3) NULL,
	[DETECTION_LIMIT_TYPE] [varchar](35) NULL,
	[DETECTION_LIMIT] [varchar](12) NULL,
	[LAB_TAXON_ACCRED_IND] [char](1) NULL,
	[LAB_TAXON_ACCRED_AUTHORITY] [varchar](20) NULL,
	[LAB_REPORTING_LEVEL] varchar(12) NULL,
	[PQL] varchar(12) NULL,
	[LOWER_QUANT_LIMIT] varchar(12) NULL,
	[UPPER_QUANT_LIMIT] varchar(12) NULL,
	[DETECTION_LIMIT_UNIT] varchar(12) NULL,
	[LAB_SAMP_PREP_IDX] int NULL,
	[LAB_SAMP_PREP_START_DT] datetime NULL,
	[LAB_SAMP_PREP_END_DT] datetime NULL,
	[DILUTION_FACTOR] varchar(10) NULL,

 CONSTRAINT [PK_WQX_RESULT] PRIMARY KEY CLUSTERED ([RESULT_IDX] ASC),
  FOREIGN KEY (ACTIVITY_IDX) references T_WQX_ACTIVITY (ACTIVITY_IDX) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (LAB_IDX) references T_WQX_REF_LAB (LAB_IDX) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (ANALYTIC_METHOD_IDX) references T_WQX_REF_ANAL_METHOD (ANALYTIC_METHOD_IDX) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]





CREATE TABLE [dbo].[T_WQX_REF_CHAR_ORG](
	[CHAR_NAME] [varchar](120) NOT NULL,
	[ORG_ID] [varchar](30) NOT NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[CREATE_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_WQX_REF_CHAR_ORG] PRIMARY KEY CLUSTERED (ORG_ID, CHAR_NAME),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE, 
 FOREIGN KEY (CHAR_NAME) references T_WQX_REF_CHARACTERISTIC (CHAR_NAME)
 	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ON [PRIMARY]

GO

ALTER TABLE T_WQX_REF_CHAR_ORG add DEFAULT_DETECT_LIMIT varchar(12) NULL;
ALTER TABLE T_WQX_REF_CHAR_ORG add DEFAULT_UNIT varchar(12) NULL;
ALTER TABLE T_WQX_REF_CHAR_ORG add DEFAULT_ANAL_METHOD_IDX int NULL;
ALTER TABLE T_WQX_REF_CHAR_ORG add DEFAULT_SAMP_FRACTION varchar(25) NULL;
ALTER TABLE T_WQX_REF_CHAR_ORG add DEFAULT_RESULT_STATUS varchar(12) NULL;
ALTER TABLE T_WQX_REF_CHAR_ORG add DEFAULT_RESULT_VALUE_TYPE varchar(20) NULL;
ALTER TABLE T_WQX_REF_CHAR_ORG ADD CONSTRAINT FK_T_WQX_REF_CHAR_ORG FOREIGN KEY (DEFAULT_ANAL_METHOD_IDX) REFERENCES T_WQX_REF_ANAL_METHOD([ANALYTIC_METHOD_IDX]);

GO

CREATE TABLE [dbo].[T_WQX_REF_TAXA_ORG](
	[BIO_SUBJECT_TAXONOMY] [varchar](120) NOT NULL,
	[ORG_ID] [varchar](30) NOT NULL,
	[CREATE_USERID] [varchar](25) NULL,
	[CREATE_DT] [datetime2](0) NULL,
 CONSTRAINT [PK_T_WQX_REF_TAXA_ORG] PRIMARY KEY CLUSTERED (ORG_ID, [BIO_SUBJECT_TAXONOMY]),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID) 
	ON UPDATE CASCADE 
	ON DELETE CASCADE
) ON [PRIMARY]

GO



CREATE TABLE [dbo].[T_WQX_TRANSACTION_LOG](
	[LOG_ID] [int] NOT NULL IDENTITY(1,1),
	[TABLE_CD] [varchar](5) NOT NULL,
	[TABLE_IDX] [int] NOT NULL,
	[SUBMIT_DT] [datetime] NOT NULL,
	[SUBMIT_TYPE] [varchar](1) NOT NULL,
	[RESPONSE_FILE] [varbinary](max) NULL,
	[RESPONSE_TXT] [varchar](max) NULL,
	[CDX_SUBMIT_TRANSID] [varchar](100) NULL,
	[CDX_SUBMIT_STATUS] [varchar](20) NULL,
    [ORG_ID] [varchar](30) NULL,
 CONSTRAINT [PK_WQX_TRANSACTION_LOG] PRIMARY KEY CLUSTERED (LOG_ID ASC)
) ON [PRIMARY]


CREATE TABLE [dbo].[T_WQX_IMPORT_LOG](
	[IMPORT_ID] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](30) NOT NULL,
	[TYPE_CD] [varchar](5) NOT NULL,
	[FILE_NAME] [varchar](150) NOT NULL,
	[FILE_SIZE] [int] NOT NULL,
	[IMPORT_STATUS] [varchar](15) NULL,
	[IMPORT_PROGRESS] [varchar](10) NULL,
	[IMPORT_PROGRESS_MSG] [varchar](1000) NULL,
	[IMPORT_FILE] [varbinary](max) NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_IMPORT_LOG] PRIMARY KEY CLUSTERED (IMPORT_ID ASC),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[T_WQX_IMPORT_COL_ALIAS](
	[IMPORT_COL_ALIAS_IDX] [int] NOT NULL IDENTITY(1,1),
	[COL_NAME] [varchar](100) NOT NULL,
	[ALIAS_NAME] [varchar](100) NOT NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_IMPORT_COL_ALIAS] PRIMARY KEY CLUSTERED ([IMPORT_COL_ALIAS_IDX] ASC)
) ON [PRIMARY]

GO

insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity ID', 'ACTIVITY ID');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity ID', 'SAMPLE ID');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity ID', 'LABSAMPID');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Media', 'ACTIVITY MEDIA');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Media', 'MEDIA');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Media', 'MATRIX');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Start Date', 'ACTIVITY START DATE');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Start Date', 'SAMPLE DATE');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Start Date', 'SAMPDATE');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Start Time', 'ACTIVITY START TIME');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Start Time', 'SAMPLE TIME');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Activity Start Time', 'SAMPTIME');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Lab Name', 'LAB NAME');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Lab Name', 'LABNAME');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Lab Name', 'LAB');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Characteristic', 'CHARACTERISTIC');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Characteristic', 'ANALYTE');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Sample Prep ID', 'SAMPLE PREP ID');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Sample Prep ID', 'PREPNAME');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Sample Prep ID', 'PREPID');

insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Unit', 'UNIT');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Unit', 'UNITS_RESULT');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Result Detection Condition', 'RESULT DETECTION CONDITION');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Result Detection Condition', 'DETECTIONCONDITION');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Result Detection Condition', 'DETECTION CONDITION');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Dilution Factor', 'DILUTION FACTOR');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Dilution Factor', 'DILUTION');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Detection Threshold Limit Unit', 'DETECTION THRESHOLD LIMIT UNIT');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Detection Threshold Limit Unit', 'UNITS_DL');
insert into T_WQX_IMPORT_COL_ALIAS ([COL_NAME], [ALIAS_NAME]) values ('Detection Threshold Limit Unit', 'DETECTION LIMIT UNIT');


GO

CREATE TABLE [dbo].[T_WQX_IMPORT_TEMPLATE](
	[TEMPLATE_ID] [int] NOT NULL IDENTITY(1,1),
	[ORG_ID] [varchar](30) NOT NULL,
	[TYPE_CD] [varchar](5) NOT NULL,
	[TEMPLATE_NAME] [varchar](150) NOT NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_IMPORT_TEMPLATE] PRIMARY KEY CLUSTERED ([TEMPLATE_ID] ASC),
 FOREIGN KEY (ORG_ID) references T_WQX_ORGANIZATION (ORG_ID) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[T_WQX_IMPORT_TEMPLATE_DTL](
	[TEMPLATE_DTL_ID] [int] NOT NULL IDENTITY(1,1),
	[TEMPLATE_ID] [int] NOT NULL,
	[COL_NUM] [int] NOT NULL,
	[FIELD_MAP] [varchar](50) NULL,
	[CHAR_NAME] [varchar](120) NULL,
	[CHAR_DEFAULT_UNIT] [varchar](12) NULL,
	[CREATE_DT] [datetime] NULL,
	[CREATE_USERID] [varchar](25) NULL,
 CONSTRAINT [PK_WQX_IMPORT_TEMPLATE_DTL] PRIMARY KEY CLUSTERED ([TEMPLATE_DTL_ID] ASC),
 FOREIGN KEY ([TEMPLATE_ID]) references [T_WQX_IMPORT_TEMPLATE] ([TEMPLATE_ID]) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO



CREATE TABLE [dbo].[T_WQX_IMPORT_TEMP_SAMPLE](
	[TEMP_SAMPLE_IDX] [int] NOT NULL IDENTITY(1,1),
	[USER_ID] [varchar](25) NOT NULL,
	[ORG_ID] [varchar](30) NULL,
	[PROJECT_IDX] [int] NULL,
	[PROJECT_ID] [varchar](35) NULL,
	[MONLOC_IDX] [int] NULL,
	[MONLOC_ID] [varchar](35) NULL,
	[ACTIVITY_IDX] [int] NULL,
	[ACTIVITY_ID] [varchar](35) NULL,
	[ACT_TYPE] [varchar](70) NOT NULL,
	[ACT_MEDIA] [varchar](20) NOT NULL,
	[ACT_SUBMEDIA] [varchar](45) NULL,
	[ACT_START_DT] [datetime] NULL,
	[ACT_END_DT] [datetime] NULL,
	[ACT_TIME_ZONE] [varchar](4) NULL,
	[RELATIVE_DEPTH_NAME] [varchar](15) NULL,
	[ACT_DEPTHHEIGHT_MSR] [varchar](12) NULL,
	[ACT_DEPTHHEIGHT_MSR_UNIT] [varchar](12) NULL,
	[TOP_DEPTHHEIGHT_MSR] [varchar](12) NULL,
	[TOP_DEPTHHEIGHT_MSR_UNIT] [varchar](12) NULL,
	[BOT_DEPTHHEIGHT_MSR] [varchar](12) NULL,
	[BOT_DEPTHHEIGHT_MSR_UNIT] [varchar](12) NULL,
	[DEPTH_REF_POINT] [varchar](125) NULL,
	[ACT_COMMENT] [varchar](4000) NULL,
	[BIO_ASSEMBLAGE_SAMPLED] [varchar](50) NULL,
	[BIO_DURATION_MSR] [varchar](12) NULL,
	[BIO_DURATION_MSR_UNIT] [varchar](12) NULL,
	[BIO_SAMP_COMPONENT] [varchar](15) NULL,
	[BIO_SAMP_COMPONENT_SEQ] [int] NULL,
	[BIO_REACH_LEN_MSR] [varchar](12) NULL,
	[BIO_REACH_LEN_MSR_UNIT] [varchar](12) NULL,
	[BIO_REACH_WID_MSR] [varchar](12) NULL,
	[BIO_REACH_WID_MSR_UNIT] [varchar](12) NULL,
	[BIO_PASS_COUNT] [int] NULL,
	[BIO_NET_TYPE] [varchar](30) NULL,
	[BIO_NET_AREA_MSR] [varchar](12) NULL,
	[BIO_NET_AREA_MSR_UNIT] [varchar](12) NULL,
	[BIO_NET_MESHSIZE_MSR] [varchar](12) NULL,
	[BIO_MESHSIZE_MSR_UNIT] [varchar](12) NULL,
	[BIO_BOAT_SPEED_MSR] [varchar](12) NULL,
	[BIO_BOAT_SPEED_MSR_UNIT] [varchar](12) NULL,
	[BIO_CURR_SPEED_MSR] [varchar](12) NULL,
	[BIO_CURR_SPEED_MSR_UNIT] [varchar](12) NULL,
	[BIO_TOXICITY_TEST_TYPE] [varchar](7) NULL,
	[SAMP_COLL_METHOD_IDX] [int] NULL,
	[SAMP_COLL_METHOD_ID] [varchar](20) NULL,
	[SAMP_COLL_METHOD_CTX] [varchar](120) NULL,
    [SAMP_COLL_METHOD_NAME] varchar(120) NULL,
	[SAMP_COLL_EQUIP] [varchar](40) NULL,
	[SAMP_COLL_EQUIP_COMMENT] [varchar](4000) NULL,
	[SAMP_PREP_IDX] [int] NULL,
	[SAMP_PREP_ID] [varchar](20) NULL,
	[SAMP_PREP_CTX] [varchar](120) NULL,
	[SAMP_PREP_NAME] varchar(120) NULL,
	[SAMP_PREP_CONT_TYPE] [varchar](35) NULL,
	[SAMP_PREP_CONT_COLOR] [varchar](15) NULL,
	[SAMP_PREP_CHEM_PRESERV] [varchar](250) NULL,
	[SAMP_PREP_THERM_PRESERV] [varchar](25) NULL,
	[SAMP_PREP_STORAGE_DESC] [varchar](250) NULL,
	[IMPORT_STATUS_CD] [varchar](1) NULL,
	[IMPORT_STATUS_DESC] [varchar](100) NULL,
 CONSTRAINT [PK_WQX_IMPORT_TEMP_SAMPLE] PRIMARY KEY CLUSTERED ([TEMP_SAMPLE_IDX] ASC)
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[T_WQX_IMPORT_TEMP_RESULT](
	[TEMP_RESULT_IDX] [int] NOT NULL IDENTITY(1,1),
	[TEMP_SAMPLE_IDX] [int] NOT NULL,
	[RESULT_IDX] [int] NULL,
	[DATA_LOGGER_LINE] [varchar](15) NULL,
	[RESULT_DETECT_CONDITION] [varchar](35) NULL,
	[CHAR_NAME] [varchar](120) NULL,
	[METHOD_SPECIATION_NAME] [varchar](20) NULL,
	[RESULT_SAMP_FRACTION] [varchar](25) NULL,
	[RESULT_MSR] [varchar](60) NULL,
	[RESULT_MSR_UNIT] [varchar](12) NULL,
	[RESULT_MSR_QUAL] [varchar](5) NULL,
	[RESULT_STATUS] [varchar](12) NULL,
	[STATISTIC_BASE_CODE] [varchar](25) NULL,
	[RESULT_VALUE_TYPE] [varchar](20) NULL,
	[WEIGHT_BASIS] [varchar](15) NULL,
	[TIME_BASIS] [varchar](12) NULL,
	[TEMP_BASIS] [varchar](12) NULL,
	[PARTICLESIZE_BASIS] [varchar](40) NULL,
	[PRECISION_VALUE] [varchar](60) NULL,
	[BIAS_VALUE] [varchar](60) NULL,
	[CONFIDENCE_INTERVAL_VALUE] [varchar](15) NULL,
	[UPPER_CONFIDENCE_LIMIT] [varchar](15) NULL,
	[LOWER_CONFIDENCE_LIMIT] [varchar](15) NULL,
	[RESULT_COMMENT] [varchar](4000) NULL,
	[DEPTH_HEIGHT_MSR] [varchar](12) NULL,
	[DEPTH_HEIGHT_MSR_UNIT] [varchar](12) NULL,
	[DEPTHALTITUDEREFPOINT] [varchar](125) NULL,
	[BIO_INTENT_NAME] [varchar](35) NULL,
	[BIO_INDIVIDUAL_ID] [varchar](4) NULL,
	[BIO_SUBJECT_TAXONOMY] [varchar](120) NULL,
	[BIO_UNIDENTIFIED_SPECIES_ID] [varchar](120) NULL,
	[BIO_SAMPLE_TISSUE_ANATOMY] [varchar](30) NULL,
	[GRP_SUMM_COUNT_WEIGHT_MSR] [varchar](12) NULL,
	[GRP_SUMM_COUNT_WEIGHT_MSR_UNIT] [varchar](12) NULL,
	[TAX_DTL_CELL_FORM] [varchar](11) NULL,
	[TAX_DTL_CELL_SHAPE] [varchar](18) NULL,
	[TAX_DTL_HABIT] [varchar](15) NULL,
	[TAX_DTL_VOLTINISM] [varchar](25) NULL,
	[TAX_DTL_POLL_TOLERANCE] [varchar](4) NULL,
	[TAX_DTL_POLL_TOLERANCE_SCALE] [varchar](50) NULL,
	[TAX_DTL_TROPHIC_LEVEL] [varchar](4) NULL,
	[TAX_DTL_FUNC_FEEDING_GROUP1] [varchar](6) NULL,
	[TAX_DTL_FUNC_FEEDING_GROUP2] [varchar](6) NULL,
	[TAX_DTL_FUNC_FEEDING_GROUP3] [varchar](6) NULL,
	[FREQ_CLASS_CODE] [varchar](50) NULL,
	[FREQ_CLASS_UNIT] [varchar](12) NULL,
	[FREQ_CLASS_UPPER] [varchar](8) NULL,
	[FREQ_CLASS_LOWER] [varchar](8) NULL,
	[ANALYTIC_METHOD_IDX] [int] NULL,
	[ANALYTIC_METHOD_ID] [varchar](20) NULL,
	[ANALYTIC_METHOD_CTX] [varchar](120) NULL,
	[ANALYTIC_METHOD_NAME] [varchar](120) NULL,
	[LAB_IDX] [int] NULL,
	[LAB_NAME] [varchar](60) NULL,
	[LAB_ANALYSIS_START_DT] [datetime] NULL,
	[LAB_ANALYSIS_END_DT] [datetime] NULL,
	[LAB_ANALYSIS_TIMEZONE] [varchar](4) NULL,
	[RESULT_LAB_COMMENT_CODE] [varchar](3) NULL,
	[METHOD_DETECTION_LEVEL] [varchar](12) NULL,
	[LAB_REPORTING_LEVEL] [varchar](12) NULL,
	[PQL] [varchar](12) NULL,
	[LOWER_QUANT_LIMIT] [varchar](12) NULL,
	[UPPER_QUANT_LIMIT] [varchar](12) NULL,
	[DETECTION_LIMIT_UNIT] [varchar](12) NULL,
	[LAB_SAMP_PREP_IDX] [int] NULL,
	[LAB_SAMP_PREP_ID] [varchar](20) NULL,
	[LAB_SAMP_PREP_CTX] [varchar](120) NULL,
	[LAB_SAMP_PREP_START_DT] [datetime] NULL,
	[LAB_SAMP_PREP_END_DT] [datetime] NULL,
	[DILUTION_FACTOR] [varchar](10) NULL,
	[IMPORT_STATUS_CD] [varchar](1) NULL,
	[IMPORT_STATUS_DESC] [varchar](100) NULL,
 CONSTRAINT [PK_WQX_IMPORT_TEMP_RESULT] PRIMARY KEY CLUSTERED ([TEMP_RESULT_IDX] ASC),
 FOREIGN KEY ([TEMP_SAMPLE_IDX]) references [T_WQX_IMPORT_TEMP_SAMPLE] ([TEMP_SAMPLE_IDX]) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO



CREATE TABLE [dbo].[T_WQX_IMPORT_TEMP_PROJECT](
	[TEMP_PROJECT_IDX] [int] NOT NULL IDENTITY(1,1),
	[USER_ID] [varchar](25) NOT NULL,
	[PROJECT_IDX] [int] NULL,
	[ORG_ID] [varchar](30) NULL,
	[PROJECT_ID] [varchar](35) NOT NULL,
	[PROJECT_NAME] [varchar](120) NOT NULL,
	[PROJECT_DESC] [varchar](1999) NULL,
	[SAMP_DESIGN_TYPE_CD] [varchar](20) NULL,
	[QAPP_APPROVAL_IND] [bit] NULL,
	[QAPP_APPROVAL_AGENCY] [varchar](50) NULL,
	[IMPORT_STATUS_CD] [varchar](1) NULL,
	[IMPORT_STATUS_DESC] [varchar](100) NULL,
 CONSTRAINT [PK_WQX_IMPORT_TEMP_PROJECT] PRIMARY KEY CLUSTERED  (TEMP_PROJECT_IDX ASC)
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[T_WQX_IMPORT_TEMP_MONLOC](
	[TEMP_MONLOC_IDX] [int] NOT NULL IDENTITY(1,1),
	[USER_ID] [varchar](25) NOT NULL,
	[MONLOC_IDX] [int] NULL ,
	[ORG_ID] [varchar](30) NULL,
	[MONLOC_ID] [varchar](35) NULL,
	[MONLOC_NAME] [varchar](255) NULL,
	[MONLOC_TYPE] [varchar](45) NULL,
	[MONLOC_DESC] [varchar](1999) NULL,
	[HUC_EIGHT] [varchar](8) NULL,
	[HUC_TWELVE] [varchar](12) NULL,
	[TRIBAL_LAND_IND] [char](1) NULL,
	[TRIBAL_LAND_NAME] [varchar](200) NULL,
	[LATITUDE_MSR] [varchar](30) NOT NULL,
	[LONGITUDE_MSR] [varchar](30) NOT NULL,
	[SOURCE_MAP_SCALE] [int] NULL,
	[HORIZ_ACCURACY] [varchar](12) NULL,
	[HORIZ_ACCURACY_UNIT] [varchar](12) NULL,
	[HORIZ_COLL_METHOD] [varchar](150) NULL,
	[HORIZ_REF_DATUM] [varchar](6) NULL,
	[VERT_MEASURE] [varchar](12) NULL,
	[VERT_MEASURE_UNIT] [varchar](12) NULL,
	[VERT_COLL_METHOD] [varchar](50) NULL,
	[VERT_REF_DATUM] [varchar](10) NULL,
	[COUNTRY_CODE] [varchar](2) NULL,
	[STATE_CODE] [varchar](2) NULL,
	[COUNTY_CODE] [varchar](3) NULL,
	[WELL_TYPE] [varchar](255) NULL,
	[AQUIFER_NAME] [varchar](120) NULL,
	[FORMATION_TYPE] [varchar](50) NULL,
	[WELLHOLE_DEPTH_MSR] [varchar](12) NULL,
	[WELLHOLE_DEPTH_MSR_UNIT] [varchar](12) NULL,
	[IMPORT_STATUS_CD] [varchar](1) NULL,
	[IMPORT_STATUS_DESC] [varchar](100) NULL,
 CONSTRAINT [PK_WQX_IMPORT_TEMP_MONLOC] PRIMARY KEY CLUSTERED  ([TEMP_MONLOC_IDX] ASC)
) ON [PRIMARY]

GO

-- ****************************************************************************************************************************************
-- ************************* [VIEWS]                      *********************************************************************************
-- ****************************************************************************************************************************************

-- ************************** TRANSACTION_LOG*****************************************************************************************
CREATE VIEW V_WQX_TRANSACTION_LOG AS
	SELECT L.*, 
	       isnull(isnull((select MONLOC_ID from T_WQX_MONLOC M where M.MONLOC_IDX = L.TABLE_IDX and L.TABLE_CD='MLOC'),
                      (select PROJECT_ID from T_WQX_PROJECT P where P.PROJECT_IDX = L.TABLE_IDX)),
               (select ACTIVITY_ID from T_WQX_ACTIVITY A where A.ACTIVITY_IDX = L.TABLE_IDX)) as RECORD      
  FROM T_WQX_TRANSACTION_LOG L;  

GO


-- ************************** ACTIVITY_LATEST*****************************************************************************************
create view V_WQX_ACTIVITY_LATEST as
select A.ACTIVITY_IDX, A.ORG_ID, A.PROJECT_IDX, A.MONLOC_IDX, MM.MONLOC_NAME, A.ACTIVITY_ID, A.ACT_TYPE, A.ACT_START_DT, A.WQX_IND, A.CREATE_DT, A.CREATE_USERID, A.ACT_COMMENT
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Alkalinity, total') AS 'Alkalinity, total'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Ammonia') AS 'Ammonia'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Dissolved oxygen (DO)') AS 'Dissolved oxygen (DO)'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Escherichia coli') AS 'Escherichia coli'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Nitrate') AS 'Nitrate'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Nitrite') AS 'Nitrite'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='pH') AS 'pH'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Phosphorus') AS 'Phosphorus'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Salinity') AS 'Salinity'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Specific Conductance') AS 'Specific Conductance'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Temperature, air') AS 'Temperature, air'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Temperature, water') AS 'Temperature, water'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Total Dissolved Solids') AS 'Total Dissolved Solids'
,(select top 1 R.RESULT_MSR from T_WQX_RESULT R where R.ACTIVITY_IDX=A.ACTIVITY_IDX and R.CHAR_NAME='Turbidity') AS 'Turbidity'
from T_WQX_MONLOC MM
left join T_WQX_ACTIVITY A on MM.MONLOC_IDX = A.MONLOC_IDX and A.ACT_START_DT = (select MAX(AAA.ACT_START_DT) from T_WQX_ACTIVITY AAA where AAA.MONLOC_IDX = MM.MONLOC_IDX)
where MM.ACT_IND=1;

GO



-- ************************** ALL_ORGS*****************************************************************************************
CREATE VIEW V_WQX_ALL_ORGS as
	select Z.ORG_ID, Z.ORG_FORMAL_NAME, max(SRC) as SRC from
	(select ORG_ID, ORG_FORMAL_NAME, 'LOCAL' as SRC from T_WQX_ORGANIZATION
	union 
	select ORG_ID, ORG_FORMAL_NAME, 'EPA' as SRC  from T_EPA_ORGS) Z
	group by ORG_ID, ORG_FORMAL_NAME;

GO


-- ************************** PENDING_RECORDS*****************************************************************************************
CREATE VIEW V_WQX_PENDING_RECORDS
as
select ACTIVITY_IDX as REC_IDX, 'ACT' as TABLE_CD, ACTIVITY_ID as REC_ID, ORG_ID, COALESCE(UPDATE_USERID, CREATE_USERID) as UPDATE_USERID, COALESCE(UPDATE_DT, CREATE_DT) as UPDATE_DT from T_WQX_ACTIVITY where WQX_IND=1 and WQX_SUBMIT_STATUS='U'
UNION
select MONLOC_IDX as REC_IDX, 'MLOC' as TABLE_CD, MONLOC_ID as REC_ID, ORG_ID, COALESCE(UPDATE_USERID, CREATE_USERID) as UPDATE_USERID, COALESCE(UPDATE_DT, CREATE_DT) as UPDATE_DT from T_WQX_MONLOC where WQX_IND=1 and WQX_SUBMIT_STATUS='U'
UNION
select PROJECT_IDX as REC_IDX, 'PROJ' as TABLE_CD, PROJECT_ID as REC_ID, ORG_ID, COALESCE(UPDATE_USERID, CREATE_USERID) as UPDATE_USERID, COALESCE(UPDATE_DT, CREATE_DT) as UPDATE_DT from T_WQX_PROJECT where WQX_IND=1 and WQX_SUBMIT_STATUS='U';

GO


-- ****************************************************************************************************************************************
-- ************************* [STORED PROCS]*********************************************************************************
-- ****************************************************************************************************************************************

CREATE PROCEDURE GenWQXXML_Org
@OrgID varchar(30)
AS
BEGIN
	/*
	DESCRIPTION: RETURNS WQX XML FILE CONTAINING ALL UPDATED RECORDS for a given Organization
	CHANGE LOG: 8/6/2012 DOUG TIMMS, OPEN-ENVIRONMENT.ORG
	9/22/2012 DOUG TIMMS, fix error with project sampling design type code
	11/24/2014 DOUG TIMMS, split procedure out from individual record version
	3/26/2015 DOUG TIMMS, added sample collection and bio fields, expanded detection limit handling
    6/6/2015 DOUG TIMMS, handle situation where ResultStatus or Value Type is empty string
	*/
	SET NOCOUNT ON;

	DECLARE @strOrg varchar(max);
	DECLARE @strProj varchar(max);   --PROJ
	DECLARE @strMon varchar(max);  --MONLOC
	DECLARE @strBioIndex varchar(max);  --BIO INDX
	DECLARE @strActivity varchar(max);  --ACTIVITY
	DECLARE @strActGrp varchar(max);   -- ACTGROUP
	DECLARE @strWQX varchar(max);
	DECLARE @logLevel varchar(20);

	--**********************************************************
	--************ORGANIZATIONS ********************************
	--*that have ORG, MONLOC, PROJ, or ACTIVITY/RESULT updated**   
	--**********************************************************
	select @strOrg =(
	 SELECT distinct rtrim(O.ORG_ID) as "OrganizationDescription/OrganizationIdentifier", 
			rtrim(O.ORG_FORMAL_NAME) as "OrganizationDescription/OrganizationFormalName", 
			rtrim(O.ORG_DESC) as "OrganizationDescription/OrganizationDescriptionText", 
			rtrim(O.TRIBAL_CODE) as "OrganizationDescription/TribalCode", 
			rtrim(O.ELECTRONICADDRESS) as "ElectronicAddress/ElectronicAddressText", 
			rtrim(O.ELECTRONICADDRESSTYPE) as "ElectronicAddress/ElectronicAddressTypeName", 
			rtrim(O.TELEPHONE_NUM) as "Telephonic/TelephoneNumberText",
			'Office' as "Telephonic/TelephoneNumberTypeName", 
			rtrim(O.TELEPHONE_EXT) as "Telephonic/TelephoneExtensionNumberText"
		from T_WQX_ORGANIZATION O 
		LEFT OUTER JOIN T_WQX_PROJECT P on O.ORG_ID = P.ORG_ID
		LEFT OUTER JOIN T_WQX_MONLOC M on O.ORG_ID = M.ORG_ID
		LEFT OUTER JOIN T_WQX_ACTIVITY A on O.ORG_ID = A.ORG_ID
		where ((M.WQX_SUBMIT_STATUS = 'U' and M.WQX_IND=1 and M.ACT_IND=1)
		or (P.WQX_SUBMIT_STATUS = 'U' and P.WQX_IND=1 and P.ACT_IND=1)
		or (A.WQX_SUBMIT_STATUS = 'U' and A.WQX_IND=1 and A.ACT_IND=1))
		and O.ORG_ID = @OrgID		
	  for xml path('')
	 )


	--****************************************************************
	--************PROJECT ********************************
	--****************************************************************
	set @strProj = ''

	select @strProj = (
	select distinct rtrim(PROJECT_ID) as "Project/ProjectIdentifier",
			ISNULL(rtrim(PROJECT_NAME),'') as "Project/ProjectName",
			ISNULL(rtrim(PROJECT_DESC),'') as "Project/ProjectDescriptionText",
			case when nullif(SAMP_DESIGN_TYPE_CD,'') is not null then rtrim(SAMP_DESIGN_TYPE_CD) else null end as "Project/SamplingDesignTypeCode",
			rtrim(QAPP_APPROVAL_IND)  as "Project/QAPPApprovedIndicator",
			rtrim(QAPP_APPROVAL_AGENCY) as "Project/QAPPApprovalAgencyName"
			from T_WQX_PROJECT 
			WHERE WQX_SUBMIT_STATUS='U' 
			and WQX_IND = 1
			and ACT_IND = 1
			and (@OrgID = ORG_ID)
			for xml path('')
		);


	--****************************************************************
	--************MONITORING_LOCATION ********************************
	--****************************************************************
	set @strMon = ''

	select @strMon = (
	select distinct rtrim(MONLOC_ID) as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationIdentifier",
			ISNULL(rtrim(MONLOC_NAME),'') as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationName",
			ISNULL(rtrim(MONLOC_TYPE),'') as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationTypeName",
			ISNULL(rtrim(MONLOC_DESC), '') as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationDescriptionText",
			rtrim(HUC_EIGHT)  as "MonitoringLocation/MonitoringLocationIdentity/HUCEightDigitCode",
			rtrim(HUC_TWELVE) AS "MonitoringLocation/MonitoringLocationIdentity/HUCTwelveDigitCode",
			case when TRIBAL_LAND_IND = 'Y' then 'true' else 'false' end AS "MonitoringLocation/MonitoringLocationIdentity/TribalLandIndicator", 
			rtrim(TRIBAL_LAND_NAME) AS "MonitoringLocation/MonitoringLocationIdentity/TribalLandName",
			NULL AS "MonitoringLocation/MonitoringLocationIdentity/AlternateMonitoringLocationIdentity/MonitoringLocationIdentifier",
			NULL AS "MonitoringLocation/MonitoringLocationIdentity/AlternateMonitoringLocationIdentity/MonitoringLocationIdentifierContext",
			ISNULL(rtrim(LATITUDE_MSR), 0) as "MonitoringLocation/MonitoringLocationGeospatial/LatitudeMeasure",
			ISNULL(rtrim(LONGITUDE_MSR), 0) as "MonitoringLocation/MonitoringLocationGeospatial/LongitudeMeasure",
			ISNULL(rtrim(SOURCE_MAP_SCALE),0) AS "MonitoringLocation/MonitoringLocationGeospatial/SourceMapScaleNumeric", 
			ISNULL(HORIZ_COLL_METHOD,'Unknown') as "MonitoringLocation/MonitoringLocationGeospatial/HorizontalCollectionMethodName",
			ISNULL(HORIZ_REF_DATUM,'UNKWN') as "MonitoringLocation/MonitoringLocationGeospatial/HorizontalCoordinateReferenceSystemDatumName",
			case when nullif(VERT_MEASURE,'') is not null then rtrim(VERT_MEASURE) else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalMeasure/MeasureValue",
			case when nullif(VERT_MEASURE,'') is not null then rtrim(VERT_MEASURE_UNIT) else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalMeasure/MeasureUnitCode",
			case when nullif(VERT_MEASURE,'') is not null then ISNULL(VERT_COLL_METHOD,'Other') else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalCollectionMethodName",
			case when nullif(VERT_MEASURE,'') is not null then ISNULL(VERT_REF_DATUM,'OTHER') else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalCoordinateReferenceSystemDatumName",
			ISNULL(rtrim(COUNTRY_CODE),'US') as  "MonitoringLocation/MonitoringLocationGeospatial/CountryCode", 
			rtrim(STATE_CODE) as "MonitoringLocation/MonitoringLocationGeospatial/StateCode", 
			rtrim(COUNTY_CODE) as "MonitoringLocation/MonitoringLocationGeospatial/CountyCode",
			nullif(WELL_TYPE,'') as "MonitoringLocation/WellInformation/WellTypeText",
			nullif(AQUIFER_NAME,'') as "MonitoringLocation/WellInformation/AquiferName",
			nullif(FORMATION_TYPE,'') as "MonitoringLocation/WellInformation/FormationTypeText",
			nullif(WELLHOLE_DEPTH_MSR,'') "MonitoringLocation/WellInformation/WellHoleDepthMeasure/MeasureValue",
			nullif(WELLHOLE_DEPTH_MSR_UNIT,'') "MonitoringLocation/WellInformation/WellHoleDepthMeasure/MeasureUnitCode"
			from T_WQX_MONLOC 
			WHERE WQX_SUBMIT_STATUS='U' 
			and WQX_IND=1
			and ACT_IND=1
			and (ORG_ID = @OrgID)
			for xml path('')
		);

	--****************************************************************
	--************BIO INDICES ****************************************
	--****************************************************************
	set @strBioIndex = '';
	select @strBioIndex = (
		select distinct rtrim(B.INDEX_ID) as "BiologicalHabitatIndex/IndexIdentifier",
			   rtrim(B.INDEX_TYPE_ID) as "BiologicalHabitatIndex/IndexType/IndexTypeIdentifier",
			   rtrim(B.INDEX_TYPE_ID_CONTEXT) as "BiologicalHabitatIndex/IndexType/IndexTypeIdentifierContext",
			   rtrim(B.INDEX_TYPE_NAME) as "BiologicalHabitatIndex/IndexType/IndexTypeName",
			   rtrim(B.INDEX_SCORE)  as "BiologicalHabitatIndex/IndexScoreNumeric",
			   rtrim(B.INDEX_QUAL_CD) as "BiologicalHabitatIndex/IndexQualifierCode",
			   rtrim(B.INDEX_COMMENT) as "BiologicalHabitatIndex/IndexCommentText",
			   LEFT(CONVERT(VARCHAR, B.INDEX_CALC_DATE, 120), 10) as "BiologicalHabitatIndex/IndexCalculatedDate"
			   from T_WQX_BIO_HABITAT_INDEX B, T_WQX_MONLOC M
			   WHERE B.MONLOC_IDX = M.MONLOC_IDX
			   and B.WQX_SUBMIT_STATUS='U' 
			   and B.WQX_IND = 1
			   and B.ACT_IND = 1
			   and (@OrgID = B.ORG_ID)
			   for xml path('')
			);


	--****************************************************************
	--************ACTIVITY *******************************************
	--****************************************************************
	set @strActivity = ''

	select @strActivity = (
	select rtrim(ACTIVITY_ID) as "ActivityDescription/ActivityIdentifier",
			ISNULL(rtrim(ACT_TYPE),'') as "ActivityDescription/ActivityTypeCode",
			ISNULL(rtrim(ACT_MEDIA),'') as "ActivityDescription/ActivityMediaName",
			rtrim(ACT_SUBMEDIA) as "ActivityDescription/ActivityMediaSubdivisionName",
			LEFT(CONVERT(VARCHAR, ACT_START_DT, 120), 10) as "ActivityDescription/ActivityStartDate",
			RIGHT(CONVERT(VARCHAR, ACT_START_DT, 120), 8) as "ActivityDescription/ActivityStartTime/Time",
            case when ACT_START_DT is not null then ISNULL(nullif(ACT_TIME_ZONE,''), 'CST') else null end as "ActivityDescription/ActivityStartTime/TimeZoneCode", 
            LEFT(CONVERT(VARCHAR, ACT_END_DT, 120), 10) as "ActivityDescription/ActivityEndDate",
            RIGHT(CONVERT(VARCHAR, ACT_END_DT, 120), 8) AS "ActivityDescription/ActivityEndTime/Time",
            case when ACT_END_DT is not null then ISNULL(nullif(ACT_TIME_ZONE,''), 'CST') else null end as "ActivityDescription/ActivityEndTime/TimeZoneCode", 
			rtrim(RELATIVE_DEPTH_NAME) as "ActivityDescription/ActivityRelativeDepthName", 
			rtrim(ACT_DEPTHHEIGHT_MSR) AS "ActivityDescription/ActivityDepthHeightMeasure/MeasureValue", 
            rtrim(ACT_DEPTHHEIGHT_MSR_UNIT) AS "ActivityDescription/ActivityDepthHeightMeasure/MeasureUnitCode",
	        rtrim(TOP_DEPTHHEIGHT_MSR) AS "ActivityDescription/ActivityTopDepthHeightMeasure/MeasureValue", 
			rtrim(TOP_DEPTHHEIGHT_MSR_UNIT) AS "ActivityDescription/ActivityTopDepthHeightMeasure/MeasureUnitCode",
	        rtrim(BOT_DEPTHHEIGHT_MSR) AS "ActivityDescription/ActivityBottomDepthHeightMeasure/MeasureValue", 
			rtrim(BOT_DEPTHHEIGHT_MSR_UNIT) AS "ActivityDescription/ActivityBottomDepthHeightMeasure/MeasureUnitCode",
            rtrim(DEPTH_REF_POINT) as "ActivityDescription/ActivityDepthAltitudeReferencePointText", 
    		(SELECT p.PROJECT_ID from T_WQX_PROJECT p where p.PROJECT_IDX = T_WQX_ACTIVITY.PROJECT_IDX) AS "ActivityDescription/ProjectIdentifier",
            ORG_ID as "ActivityDescription/ActivityConductingOrganizationText",
            (SELECT MONLOC_ID from T_WQX_MONLOC M WHERE M.MONLOC_IDX = T_WQX_ACTIVITY.MONLOC_IDX)  AS "ActivityDescription/MonitoringLocationIdentifier", 
            ACT_COMMENT as "ActivityDescription/ActivityCommentText",
			   --SAMPLE BIO
	           case when isnull(T_WQX_ACTIVITY.BIO_ASSEMBLAGE_SAMPLED,'') <> '' then rtrim(BIO_ASSEMBLAGE_SAMPLED) else null end AS "BiologicalActivityDescription/AssemblageSampledName", 
	           case when isnull(T_WQX_ACTIVITY.BIO_DURATION_MSR,'') <> '' then rtrim(BIO_DURATION_MSR) else null end AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/CollectionDuration/MeasureValue", 
	           case when isnull(T_WQX_ACTIVITY.BIO_DURATION_MSR_UNIT,'') <> '' then rtrim(BIO_DURATION_MSR_UNIT) else null end AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/CollectionDuration/MeasureUnitCode", 
	           case when isnull(T_WQX_ACTIVITY.BIO_REACH_LEN_MSR,'') <> '' then rtrim(BIO_REACH_LEN_MSR) else null end AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachLengthMeasure/MeasureValue", 
	           case when isnull(T_WQX_ACTIVITY.BIO_REACH_LEN_MSR_UNIT,'') <> '' then rtrim(BIO_REACH_LEN_MSR_UNIT) else null end AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachLengthMeasure/MeasureUnitCode", 
	           case when isnull(T_WQX_ACTIVITY.BIO_REACH_WID_MSR,'') <> '' then rtrim(BIO_REACH_WID_MSR) else null end AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachWidthMeasure/MeasureValue", 
	           case when isnull(T_WQX_ACTIVITY.BIO_REACH_WID_MSR_UNIT,'') <> '' then rtrim(BIO_REACH_WID_MSR_UNIT) else null end AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachWidthMeasure/MeasureUnitCode", 

			   --SAMPLE DESCRIPTION
			   case when isnull(T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX,'') <> '' then SCL.SAMP_COLL_METHOD_ID else null end as "SampleDescription/SampleCollectionMethod/MethodIdentifier", 
			   case when isnull(T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX,'') <> '' then SCL.SAMP_COLL_METHOD_CTX else null end as "SampleDescription/SampleCollectionMethod/MethodIdentifierContext", 
			   case when isnull(T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX,'') <> '' then SCL.SAMP_COLL_METHOD_NAME else null end as "SampleDescription/SampleCollectionMethod/MethodName", 
               case when isnull(T_WQX_ACTIVITY.SAMP_COLL_EQUIP,'') <> '' then rtrim(SAMP_COLL_EQUIP) else null end as "SampleDescription/SampleCollectionEquipmentName",
               case when isnull(T_WQX_ACTIVITY.SAMP_COLL_EQUIP,'') <> '' and isnull(T_WQX_ACTIVITY.SAMP_COLL_EQUIP_COMMENT,'') <> '' then rtrim(SAMP_COLL_EQUIP_COMMENT) else null end AS "SampleDescription/SampleCollectionEquipmentCommentText",

				--RESULT
    			(SELECT rtrim(DATA_LOGGER_LINE) AS "ResultDescription/DataLoggerLineName",
    			case when RESULT_MSR ='ND' then 'Not Detected' 
    				    when RESULT_MSR = 'NR' then 'Not Reported'
    				    when RESULT_MSR = 'PAQL' then 'Present Above Quantification Limit'
    				    when RESULT_MSR = 'PBQL' then 'Present Below Quantification Limit'
    				    when RESULT_MSR = 'DNQ' then 'Detected Not Quantified' 
    				    else rtrim(RESULT_DETECT_CONDITION) END AS "ResultDescription/ResultDetectionConditionText", 
    			rtrim(CHAR_NAME) AS "ResultDescription/CharacteristicName",
    			rtrim(METHOD_SPECIATION_NAME) as "ResultDescription/MethodSpeciationName",
    			rtrim(RESULT_SAMP_FRACTION) AS "ResultDescription/ResultSampleFractionText",
				case when RESULT_MSR in ('ND', 'NR', 'PAQL', 'PBQL', 'DNQ') then null else rtrim(RESULT_MSR) END AS "ResultDescription/ResultMeasure/ResultMeasureValue",
				rtrim(RESULT_MSR_UNIT) AS "ResultDescription/ResultMeasure/MeasureUnitCode",
				rtrim(RESULT_MSR_QUAL) AS "ResultDescription/ResultMeasure/MeasureQualifierCode",
                coalesce(nullif(RESULT_STATUS,''),'Final') AS "ResultDescription/ResultStatusIdentifier",
                rtrim(STATISTIC_BASE_CODE) AS "ResultDescription/StatisticalBaseCode",
                coalesce(nullif(RESULT_VALUE_TYPE,''),'Actual') AS "ResultDescription/ResultValueTypeName",
                RTRIM(WEIGHT_BASIS) AS "ResultDescription/ResultWeightBasisText",
                rtrim(TIME_BASIS) AS "ResultDescription/ResultTimeBasisText",
                rtrim(TEMP_BASIS) AS "ResultDescription/ResultTemperatureBasisText",
				rtrim(PARTICLESIZE_BASIS) AS "ResultDescription/ResultParticleSizeBasisText",
				rtrim(PRECISION_VALUE) AS "ResultDescription/DataQuality/PrecisionValue",
				rtrim(BIAS_VALUE) AS "ResultDescription/DataQuality/BiasValue",
				rtrim(CONFIDENCE_INTERVAL_VALUE) AS "ResultDescription/DataQuality/ConfidenceIntervalValue",
				rtrim(UPPER_CONFIDENCE_LIMIT) AS "ResultDescription/DataQuality/UpperConfidenceLimitValue",
				rtrim(LOWER_CONFIDENCE_LIMIT) AS "ResultDescription/DataQuality/LowerConfidenceLimitValue",
				rtrim(RESULT_COMMENT) AS "ResultDescription/ResultCommentText",
				rtrim(DEPTH_HEIGHT_MSR) AS "ResultDescription/ResultDepthHeightMeasure/MeasureValue",
				rtrim(DEPTH_HEIGHT_MSR_UNIT) AS "ResultDescription/ResultDepthHeightMeasure/MeasureUnitCode",
				rtrim(DEPTHALTITUDEREFPOINT) AS "ResultDescription/ResultDepthAltitudeReferencePointText",
				rtrim(RESULT_SAMP_POINT) AS "ResultDescription/ResultSamplingPointName",
					
				case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_INTENT_NAME) else null end as "BiologicalResultDescription/BiologicalIntentName",
				case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_INDIVIDUAL_ID) else null end AS "BiologicalResultDescription/BiologicalIndividualIdentifier",
				case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_SUBJECT_TAXONOMY) else null end as "BiologicalResultDescription/SubjectTaxonomicName",
				case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_UNIDENTIFIED_SPECIES_ID) else null end AS "BiologicalResultDescription/UnidentifiedSpeciesIdentifier",
				case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_SAMPLE_TISSUE_ANATOMY) else null end as "BiologicalResultDescription/SampleTissueAnatomyName",
					
				rtrim(AM.ANALYTIC_METHOD_ID) as "ResultAnalyticalMethod/MethodIdentifier",
				rtrim(AM.ANALYTIC_METHOD_CTX) as "ResultAnalyticalMethod/MethodIdentifierContext",
				rtrim(AM.ANALYTIC_METHOD_NAME) AS "ResultAnalyticalMethod/MethodName",
				null AS "ResultAnalyticalMethod/MethodQualifierTypeName",
				rtrim(AM.ANALYTIC_METHOD_DESC) AS "ResultAnalyticalMethod/MethodDescriptionText",
				rtrim(LL.LAB_NAME) AS "ResultLabInformation/LaboratoryName",
 				LEFT(CONVERT(VARCHAR, LAB_ANALYSIS_START_DT, 120), 10) as "ResultLabInformation/AnalysisStartDate", 
				RIGHT(CONVERT(VARCHAR, LAB_ANALYSIS_START_DT, 120), 8) AS "ResultLabInformation/AnalysisStartTime/Time" , 
				CASE WHEN LAB_ANALYSIS_START_DT IS NOT NULL THEN 'CST' ELSE NULL END AS "ResultLabInformation/AnalysisStartTime/TimeZoneCode", 
 				LEFT(CONVERT(VARCHAR, LAB_ANALYSIS_END_DT, 120), 10) as "ResultLabInformation/AnalysisEndDate", 
				RIGHT(CONVERT(VARCHAR, LAB_ANALYSIS_END_DT, 120), 8) AS "ResultLabInformation/AnalysisEndTime/Time", 
				CASE WHEN LAB_ANALYSIS_END_DT IS NOT NULL THEN 'CST' ELSE NULL END AS "ResultLabInformation/AnalysisEndTime/TimeZoneCode",
				rtrim(RESULT_LAB_COMMENT_CODE) AS "ResultLabInformation/ResultLaboratoryCommentCode",

					--DETECTION LIMIT HANDLING
					case when (RESULT_MSR in ('ND','NR','PAQL','PBQL','DNQ') or nullif(R.DETECTION_LIMIT,'') is not null or nullif(R.LAB_REPORTING_LEVEL,'') is not null or nullif(R.PQL,'') is not null or nullif(R.LOWER_QUANT_LIMIT,'') is not null or nullif(R.UPPER_QUANT_LIMIT,'') is not null) then 
						 case when nullif(R.DETECTION_LIMIT_TYPE,'') is not null then rtrim(R.DETECTION_LIMIT_TYPE) 
						      when nullif(DETECTION_LIMIT,'') is not null then 'Method Detection Level'
						      when nullif(LAB_REPORTING_LEVEL,'') is not null then 'Laboratory Reporting Level'
						      when nullif(PQL,'') is not null then 'Practical Quantitation Limit'
						      when nullif(LOWER_QUANT_LIMIT,'') is not null then 'Lower Quantitation Limit'
						      when nullif(UPPER_QUANT_LIMIT,'') is not null then 'Upper Quantitation Limit'
							  else  'Estimated Detection Level' end
					end AS "ResultLabInformation/ResultDetectionQuantitationLimit/DetectionQuantitationLimitTypeName",
					case when (RESULT_MSR in ('ND','NR','PAQL','PBQL','DNQ') or nullif(R.DETECTION_LIMIT,'') is not null or nullif(R.LAB_REPORTING_LEVEL,'') is not null or nullif(R.PQL,'') is not null or nullif(R.LOWER_QUANT_LIMIT,'') is not null or nullif(R.UPPER_QUANT_LIMIT,'') is not null) then 
						case when nullif(DETECTION_LIMIT,'') is not null then DETECTION_LIMIT 
						      when nullif(LAB_REPORTING_LEVEL,'') is not null then LAB_REPORTING_LEVEL
						      when nullif(PQL,'') is not null then PQL
						      when nullif(LOWER_QUANT_LIMIT,'') is not null then LOWER_QUANT_LIMIT
						      when nullif(UPPER_QUANT_LIMIT,'') is not null then UPPER_QUANT_LIMIT					     
							  else '0' end
					end AS "ResultLabInformation/ResultDetectionQuantitationLimit/DetectionQuantitationLimitMeasure/MeasureValue",
					case when (RESULT_MSR in ('ND','NR','PAQL','PBQL','DNQ') or nullif(R.DETECTION_LIMIT,'') is not null or nullif(R.LAB_REPORTING_LEVEL,'') is not null or nullif(R.PQL,'') is not null or nullif(R.LOWER_QUANT_LIMIT,'') is not null or nullif(R.UPPER_QUANT_LIMIT,'') is not null) then 
						case when nullif(RESULT_MSR_UNIT,'') is not null then RESULT_MSR_UNIT ELSE 
							(select isnull(rc.DEFAULT_UNIT,'None') from T_WQX_REF_CHARACTERISTIC rc where rc.CHAR_NAME = R.CHAR_NAME) end end AS "ResultLabInformation/ResultDetectionQuantitationLimit/DetectionQuantitationLimitMeasure/MeasureUnitCode"

    			FROM T_WQX_RESULT R 
				LEFT JOIN T_WQX_REF_ANAL_METHOD AM on R.ANALYTIC_METHOD_IDX = AM.ANALYTIC_METHOD_IDX
				LEFT JOIN T_WQX_REF_LAB LL on R.LAB_IDX = LL.LAB_IDX
    			where R.ACTIVITY_IDX = T_WQX_ACTIVITY.ACTIVITY_IDX 
				for xml path('Result'),type ) 

			from T_WQX_ACTIVITY
 		    left join T_WQX_REF_SAMP_COL_METHOD SCL on T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX = SCL.SAMP_COLL_METHOD_IDX
			WHERE WQX_SUBMIT_STATUS='U' 
			and WQX_IND = 1
			and T_WQX_ACTIVITY.	ACT_IND = 1
   			and (@OrgID = ORG_ID)
			for xml path('Activity')
		);

	-- *************************************************************************
	-- ***************** COMBINE ***********************************************
	-- *************************************************************************
	set @strWQX = '<?xml version="1.0" encoding="UTF-8"?>
	<Document Id="UI_' + convert(varchar, getdate(), 112) + '" xmlns="http://www.exchangenetwork.net/schema/v1.0/ExchangeNetworkDocument.xsd">
		<Header>
			<Author>Open Waters</Author>
			<Organization>Open Environment</Organization>
			<Title>WQX</Title>
			<CreationTime>' + LEFT(CONVERT(varchar, getdate(), 120), 10) + 'T' + RIGHT(convert(varchar, getdate(), 120), 8) + '</CreationTime>
			<ContactInfo>doug.timms@open-environment.org</ContactInfo>
		</Header>
		<Payload Operation="Update-Insert">
	<WQX xmlns="http://www.exchangenetwork.net/schema/wqx/2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.exchangenetwork.net/schema/wqx/2 
	http://www.exchangenetwork.net/schema/WQX/2/index.xsd">
		<Organization>' + @strOrg + isnull(@strProj,'') + isnull(@strMon,'') + isnull(@strBioIndex,'') + isnull(@strActivity,'') + isnull(@strActGrp,'') + '</Organization></WQX></Payload></Document>'
	
	select @strWQX;

	--IF DEBUG MODE, WRITE TO TRANSACTION LOG
	select @logLevel = (select SETTING_VALUE from T_OE_APP_SETTINGS where SETTING_NAME = 'Log Level');
	if @logLevel='DEBUG' 
	BEGIN
		insert into T_WQX_TRANSACTION_LOG(TABLE_CD, TABLE_IDX, SUBMIT_DT, SUBMIT_TYPE, RESPONSE_TXT) values ('',0,GetDate(), 'I', @strWQX);
	END

END

GO

-- ****************************************************************************************************************************************
-- ************************* [WQX ANALYSIS]*********************************************************************************
-- ****************************************************************************************************************************************
CREATE PROCEDURE WQXAnalysis
@TypeText varchar(10),
@OrgID varchar(20),
@MonLocID varchar(20),
@CharName varchar(200),
@StartDt datetime,
@EndDt datetime,
@DataIncludeInd varchar(1)
AS
BEGIN
	/*
	DESCRIPTION: RETURNS DATA FOR CHARTING
	CHANGE LOG: 6/29/2012 DOUG TIMMS, OPEN-ENVIRONMENT.ORG
	4/23/2015 properly add Org filter
	*/
	SET NOCOUNT ON;

	if @TypeText='SERIES' 
		BEGIN
			select case when min(M.MONLOC_NAME)<>MAX(M.MONLOC_NAME) then 'Multiple' else min(M.MONLOC_NAME) end as MONLOC_NAME, 
				MIN(R.CHAR_NAME) as CHAR_NAME,
				dateadd(dd, datediff(dd, 0, a.ACT_START_DT)+0, 0) as START_DT, 
				avg(

case when ISNUMERIC(RESULT_MSR)=1 then cast(RESULT_MSR as DECIMAL(10,4))
when ISNUMERIC( DETECTION_LIMIT)=1 then cast(DETECTION_LIMIT as DECIMAL(10,4))
when ISNUMERIC(LAB_REPORTING_LEVEL)=1 then cast(LAB_REPORTING_LEVEL as DECIMAL(10,4))
when ISNUMERIC(PQL)=1 then cast (PQL as DECIMAL(10,4))
when ISNUMERIC(LOWER_QUANT_LIMIT)=1 then cast (LOWER_QUANT_LIMIT as DECIMAL(10,4))
when ISNUMERIC(UPPER_QUANT_LIMIT)=1 then cast (UPPER_QUANT_LIMIT as DECIMAL(10,4))
else CAST(0 as DECIMAL(10,4)) end 


				) as RESULT_MSR, 
				min(R.RESULT_MSR_UNIT) as RESULT_MSR_UNIT,
				min(R.DETECTION_LIMIT) as DETECTION_LIMIT
			from T_WQX_RESULT R, T_WQX_ACTIVITY A, T_WQX_MONLOC M
			where A.ACTIVITY_IDX = R.ACTIVITY_IDX
			and M.MONLOC_IDX = A.MONLOC_IDX
			and R.CHAR_NAME = @CharName
			and (A.ORG_ID = @OrgID or @OrgID is null)
			and (A.ACT_START_DT >= @StartDt or @StartDt is null)
			and (A.ACT_START_DT <= @EndDt or @EndDt is null)
			and (A.MONLOC_IDX = @MonLocID or @MonLocID = 0)
			and (@DataIncludeInd = 'A' or A.WQX_IND = 1)
			group by dateadd(dd, datediff(dd, 0, a.ACT_START_DT)+0, 0) 
			order by dateadd(dd, datediff(dd, 0, a.ACT_START_DT)+0, 0)
		END
	
END


GO





-- ****************************************************************************************************************************************
-- ************************* [WQX SINGLE]*********************************************************************************
-- ****************************************************************************************************************************************

CREATE PROCEDURE GenWQXXML_Single
  @TypeText varchar(4),
  @RecordIDX int
AS
BEGIN
	/*
	DESCRIPTION: RETURNS WQX XML FILE CONTAINING A SINGLE UPDATED RECORD
	TypeText can be MLOC, PROJ, IDX, or ACT

	CHANGE LOG: 8/6/2012 DOUG TIMMS, OPEN-ENVIRONMENT.ORG
	            9/22/2012 DOUG TIMMS, fix error with project sampling design type code
	            11/24/2014 DOUG TIMMS, added support to submit for single organization within multi-organization database; split into 2 stored procs for performance
				3/26/2015 DOUG TIMMS, added sample collection and bio fields, expanded detection limit handling
				6/6/2015 DOUG TIMMS, handle situation where ResultStatus or Value Type is empty string
	*/
	SET NOCOUNT ON;

	DECLARE @strOrg varchar(max);       --ORG
	DECLARE @strProj varchar(max);      --PROJ
	DECLARE @strMon varchar(max);       --MONLOC
	DECLARE @strBioIndex varchar(max);  --BIO INDX
	DECLARE @strActivity varchar(max);  --ACTIVITY
	DECLARE @strActGrp varchar(max);    --ACTGROUP
	DECLARE @strWQX varchar(max);       --output XML
	DECLARE @logLevel varchar(20);
	DECLARE @orgID varchar(30);         --Org ID for the updated record

	--**********************************************************
    -- GET ORGANIZATION based on record IDX
	--**********************************************************
	if (@TypeText='PROJ') 
		SELECT @orgID = ORG_ID from T_WQX_PROJECT where PROJECT_IDX = @RecordIDX; 
    else if (@TypeText='MLOC')
		SELECT @orgID = ORG_ID from T_WQX_MONLOC where MONLOC_IDX = @RecordIDX; 
    else if (@TypeText='ACT')
		SELECT @orgID = ORG_ID from T_WQX_ACTIVITY where ACTIVITY_IDX = @RecordIDX; 
    else if (@TypeText='IDX')
		SELECT @orgID = ORG_ID from T_WQX_BIO_HABITAT_INDEX where BIO_HABITAT_INDEX_IDX = @RecordIDX; 


	--**********************************************************
	--************ORGANIZATIONS ********************************
	--*that have ORG, MONLOC, PROJ, or ACTIVITY/RESULT updated**   
	--**********************************************************
	select @strOrg =(
	 SELECT distinct rtrim(O.ORG_ID) as "OrganizationDescription/OrganizationIdentifier", 
			rtrim(O.ORG_FORMAL_NAME) as "OrganizationDescription/OrganizationFormalName", 
			rtrim(O.ORG_DESC) as "OrganizationDescription/OrganizationDescriptionText", 
			rtrim(O.TRIBAL_CODE) as "OrganizationDescription/TribalCode", 
			rtrim(O.ELECTRONICADDRESS) as "ElectronicAddress/ElectronicAddressText", 
			rtrim(O.ELECTRONICADDRESSTYPE) as "ElectronicAddress/ElectronicAddressTypeName", 
			rtrim(O.TELEPHONE_NUM) as "Telephonic/TelephoneNumberText",
			'Office' as "Telephonic/TelephoneNumberTypeName", 
			rtrim(O.TELEPHONE_EXT) as "Telephonic/TelephoneExtensionNumberText"
		from T_WQX_ORGANIZATION O 
		where O.ORG_ID = @orgID
		for xml path('')
	 );


	--****************************************************************
	--************PROJECT ********************************
	--****************************************************************
	set @strProj = '';

	if (@TypeText='PROJ') 
	BEGIN
		select @strProj = (
		select distinct rtrim(PROJECT_ID) as "Project/ProjectIdentifier",
			   ISNULL(rtrim(PROJECT_NAME),'') as "Project/ProjectName",
			   ISNULL(rtrim(PROJECT_DESC),'') as "Project/ProjectDescriptionText",
			   case when nullif(SAMP_DESIGN_TYPE_CD,'') is not null then rtrim(SAMP_DESIGN_TYPE_CD) else null end as "Project/SamplingDesignTypeCode",
			   rtrim(QAPP_APPROVAL_IND)  as "Project/QAPPApprovedIndicator",
			   rtrim(QAPP_APPROVAL_AGENCY) as "Project/QAPPApprovalAgencyName"
			   from T_WQX_PROJECT 
			   WHERE WQX_SUBMIT_STATUS='U' 
			   and WQX_IND = 1
			   and ACT_IND = 1
			   and PROJECT_IDX = @RecordIDX
			   for xml path('')
			);
	END


	--****************************************************************
	--************MONITORING_LOCATION ********************************
	--****************************************************************
	set @strMon = ''

	if (@TypeText='MLOC') 
	BEGIN
		select @strMon = (
		select distinct rtrim(MONLOC_ID) as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationIdentifier",
			   ISNULL(rtrim(MONLOC_NAME),'') as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationName",
			   ISNULL(rtrim(MONLOC_TYPE),'') as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationTypeName",
			   ISNULL(rtrim(MONLOC_DESC), '') as "MonitoringLocation/MonitoringLocationIdentity/MonitoringLocationDescriptionText",
			   rtrim(HUC_EIGHT)  as "MonitoringLocation/MonitoringLocationIdentity/HUCEightDigitCode",
			   rtrim(HUC_TWELVE) AS "MonitoringLocation/MonitoringLocationIdentity/HUCTwelveDigitCode",
			   case when TRIBAL_LAND_IND = 'Y' then 'true' else 'false' end AS "MonitoringLocation/MonitoringLocationIdentity/TribalLandIndicator", 
			   rtrim(TRIBAL_LAND_NAME) AS "MonitoringLocation/MonitoringLocationIdentity/TribalLandName",
			   NULL AS "MonitoringLocation/MonitoringLocationIdentity/AlternateMonitoringLocationIdentity/MonitoringLocationIdentifier",
			   NULL AS "MonitoringLocation/MonitoringLocationIdentity/AlternateMonitoringLocationIdentity/MonitoringLocationIdentifierContext",
			   ISNULL(rtrim(LATITUDE_MSR), 0) as "MonitoringLocation/MonitoringLocationGeospatial/LatitudeMeasure",
			   ISNULL(rtrim(LONGITUDE_MSR), 0) as "MonitoringLocation/MonitoringLocationGeospatial/LongitudeMeasure",
			   ISNULL(rtrim(SOURCE_MAP_SCALE),0) AS "MonitoringLocation/MonitoringLocationGeospatial/SourceMapScaleNumeric", 
			   ISNULL(HORIZ_COLL_METHOD,'Unknown') as "MonitoringLocation/MonitoringLocationGeospatial/HorizontalCollectionMethodName",
			   ISNULL(HORIZ_REF_DATUM,'UNKWN') as "MonitoringLocation/MonitoringLocationGeospatial/HorizontalCoordinateReferenceSystemDatumName",
			   case when nullif(VERT_MEASURE,'') is not null then rtrim(VERT_MEASURE) else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalMeasure/MeasureValue",
			   case when nullif(VERT_MEASURE,'') is not null then rtrim(VERT_MEASURE_UNIT) else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalMeasure/MeasureUnitCode",
			   case when nullif(VERT_MEASURE,'') is not null then ISNULL(VERT_COLL_METHOD,'Other') else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalCollectionMethodName",
			   case when nullif(VERT_MEASURE,'') is not null then ISNULL(VERT_REF_DATUM,'OTHER') else null end as "MonitoringLocation/MonitoringLocationGeospatial/VerticalCoordinateReferenceSystemDatumName",
			   ISNULL(rtrim(COUNTRY_CODE),'US') as  "MonitoringLocation/MonitoringLocationGeospatial/CountryCode", 
			   rtrim(STATE_CODE) as "MonitoringLocation/MonitoringLocationGeospatial/StateCode", 
			   rtrim(COUNTY_CODE) as "MonitoringLocation/MonitoringLocationGeospatial/CountyCode",
			   nullif(WELL_TYPE,'') as "MonitoringLocation/WellInformation/WellTypeText",
			   nullif(AQUIFER_NAME,'') as "MonitoringLocation/WellInformation/AquiferName",
			   nullif(FORMATION_TYPE,'') as "MonitoringLocation/WellInformation/FormationTypeText",
			   nullif(WELLHOLE_DEPTH_MSR,'') "MonitoringLocation/WellInformation/WellHoleDepthMeasure/MeasureValue",
			   nullif(WELLHOLE_DEPTH_MSR_UNIT,'') "MonitoringLocation/WellInformation/WellHoleDepthMeasure/MeasureUnitCode"
			   from T_WQX_MONLOC 
			   WHERE WQX_SUBMIT_STATUS='U' 
			   and WQX_IND=1
			   and ACT_IND=1
			   and MONLOC_IDX = @RecordIDX
			   for xml path('')
			)
	END

	--****************************************************************
	--************BIO INDICES ****************************************
	--****************************************************************
	set @strBioIndex = '';
	if (@TypeText='IDX') 
	BEGIN
	select @strBioIndex = (
		select distinct rtrim(B.INDEX_ID) as "BiologicalHabitatIndex/IndexIdentifier",
			   rtrim(B.INDEX_TYPE_ID) as "BiologicalHabitatIndex/IndexType/IndexTypeIdentifier",
			   rtrim(B.INDEX_TYPE_ID_CONTEXT) as "BiologicalHabitatIndex/IndexType/IndexTypeIdentifierContext",
			   rtrim(B.INDEX_TYPE_NAME) as "BiologicalHabitatIndex/IndexType/IndexTypeName",
			   rtrim(B.INDEX_SCORE)  as "BiologicalHabitatIndex/IndexScoreNumeric",
			   rtrim(B.INDEX_QUAL_CD) as "BiologicalHabitatIndex/IndexQualifierCode",
			   rtrim(B.INDEX_COMMENT) as "BiologicalHabitatIndex/IndexCommentText",
			   LEFT(CONVERT(VARCHAR, B.INDEX_CALC_DATE, 120), 10) as "BiologicalHabitatIndex/IndexCalculatedDate"
			   from T_WQX_BIO_HABITAT_INDEX B
			   WHERE B.WQX_SUBMIT_STATUS='U' 
			   and B.WQX_IND = 1
			   and B.ACT_IND = 1
			   and B.BIO_HABITAT_INDEX_IDX = @RecordIDX
			   for xml path('')
			)
	END


	--****************************************************************
	--************ACTIVITY *******************************************
	--****************************************************************
	set @strActivity = ''
	if (@TypeText='ACT') 
	BEGIN
		select @strActivity = (
		select rtrim(ACTIVITY_ID) as "ActivityDescription/ActivityIdentifier",
			   ISNULL(rtrim(ACT_TYPE),'') as "ActivityDescription/ActivityTypeCode",
			   ISNULL(rtrim(ACT_MEDIA),'') as "ActivityDescription/ActivityMediaName",
			   rtrim(ACT_SUBMEDIA) as "ActivityDescription/ActivityMediaSubdivisionName",
			   LEFT(CONVERT(VARCHAR, ACT_START_DT, 120), 10) as "ActivityDescription/ActivityStartDate",
			   RIGHT(CONVERT(VARCHAR, ACT_START_DT, 120), 8) as "ActivityDescription/ActivityStartTime/Time",
               case when ACT_START_DT is not null then ISNULL(nullif(ACT_TIME_ZONE,''), 'CST') else null end as "ActivityDescription/ActivityStartTime/TimeZoneCode", 
               LEFT(CONVERT(VARCHAR, ACT_END_DT, 120), 10) as "ActivityDescription/ActivityEndDate",
               RIGHT(CONVERT(VARCHAR, ACT_END_DT, 120), 8) AS "ActivityDescription/ActivityEndTime/Time",
               case when ACT_END_DT is not null then ISNULL(nullif(ACT_TIME_ZONE,''), 'CST') else null end as "ActivityDescription/ActivityEndTime/TimeZoneCode", 
			   rtrim(RELATIVE_DEPTH_NAME) as "ActivityDescription/ActivityRelativeDepthName", 
			   rtrim(ACT_DEPTHHEIGHT_MSR) AS "ActivityDescription/ActivityDepthHeightMeasure/MeasureValue", 
               rtrim(ACT_DEPTHHEIGHT_MSR_UNIT) AS "ActivityDescription/ActivityDepthHeightMeasure/MeasureUnitCode",
	           rtrim(TOP_DEPTHHEIGHT_MSR) AS "ActivityDescription/ActivityTopDepthHeightMeasure/MeasureValue", 
			   rtrim(TOP_DEPTHHEIGHT_MSR_UNIT) AS "ActivityDescription/ActivityTopDepthHeightMeasure/MeasureUnitCode",
	           rtrim(BOT_DEPTHHEIGHT_MSR) AS "ActivityDescription/ActivityBottomDepthHeightMeasure/MeasureValue", 
			   rtrim(BOT_DEPTHHEIGHT_MSR_UNIT) AS "ActivityDescription/ActivityBottomDepthHeightMeasure/MeasureUnitCode",
               rtrim(DEPTH_REF_POINT) as "ActivityDescription/ActivityDepthAltitudeReferencePointText", 
    		   (SELECT p.PROJECT_ID from T_WQX_PROJECT p where p.PROJECT_IDX = T_WQX_ACTIVITY.PROJECT_IDX) AS "ActivityDescription/ProjectIdentifier",
               ORG_ID as "ActivityDescription/ActivityConductingOrganizationText",
               (SELECT MONLOC_ID from T_WQX_MONLOC M WHERE M.MONLOC_IDX = T_WQX_ACTIVITY.MONLOC_IDX)  AS "ActivityDescription/MonitoringLocationIdentifier", 
               ACT_COMMENT as "ActivityDescription/ActivityCommentText",
			   --SAMPLE BIO
	           rtrim(BIO_ASSEMBLAGE_SAMPLED) AS "BiologicalActivityDescription/AssemblageSampledName", 
	           rtrim(BIO_DURATION_MSR) AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/CollectionDuration/MeasureValue", 
	           rtrim(BIO_DURATION_MSR_UNIT) AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/CollectionDuration/MeasureUnitCode", 
	           rtrim(BIO_REACH_LEN_MSR) AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachLengthMeasure/MeasureValue", 
	           rtrim(BIO_REACH_LEN_MSR_UNIT) AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachLengthMeasure/MeasureUnitCode", 
	           rtrim(BIO_REACH_WID_MSR) AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachWidthMeasure/MeasureValue", 
	           rtrim(BIO_REACH_WID_MSR_UNIT) AS "BiologicalActivityDescription/BiologicalHabitatCollectionInformation/ReachWidthMeasure/MeasureUnitCode", 

			   --SAMPLE DESCRIPTION
			   case when T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX is not null then SCL.SAMP_COLL_METHOD_ID else null end as "SampleDescription/SampleCollectionMethod/MethodIdentifier", 
			   case when T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX is not null then SCL.SAMP_COLL_METHOD_CTX else null end as "SampleDescription/SampleCollectionMethod/MethodIdentifierContext", 
			   case when T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX is not null then SCL.SAMP_COLL_METHOD_NAME else null end as "SampleDescription/SampleCollectionMethod/MethodName", 
               rtrim(SAMP_COLL_EQUIP) AS "SampleDescription/SampleCollectionEquipmentName",
               rtrim(SAMP_COLL_EQUIP_COMMENT) AS "SampleDescription/SampleCollectionEquipmentCommentText",

					--RESULT
    				(SELECT rtrim(DATA_LOGGER_LINE) AS "ResultDescription/DataLoggerLineName",
    				case when RESULT_MSR ='ND' then 'Not Detected' 
    				     when RESULT_MSR = 'NR' then 'Not Reported'
    				     when RESULT_MSR = 'PAQL' then 'Present Above Quantification Limit'
    				     when RESULT_MSR = 'PBQL' then 'Present Below Quantification Limit'
    				     when RESULT_MSR = 'DNQ' then 'Detected Not Quantified' 
    				     else rtrim(RESULT_DETECT_CONDITION) END AS "ResultDescription/ResultDetectionConditionText", 
    				rtrim(CHAR_NAME) AS "ResultDescription/CharacteristicName",
    				rtrim(METHOD_SPECIATION_NAME) as "ResultDescription/MethodSpeciationName",
    				rtrim(RESULT_SAMP_FRACTION) AS "ResultDescription/ResultSampleFractionText",
					case when RESULT_MSR in ('ND', 'NR', 'PAQL', 'PBQL', 'DNQ') then null else rtrim(RESULT_MSR) END AS "ResultDescription/ResultMeasure/ResultMeasureValue",
					rtrim(RESULT_MSR_UNIT) AS "ResultDescription/ResultMeasure/MeasureUnitCode",
					rtrim(RESULT_MSR_QUAL) AS "ResultDescription/ResultMeasure/MeasureQualifierCode",
                    coalesce(nullif(RESULT_STATUS,''),'Final') AS "ResultDescription/ResultStatusIdentifier",
                    rtrim(STATISTIC_BASE_CODE) AS "ResultDescription/StatisticalBaseCode",
                    coalesce(nullif(RESULT_VALUE_TYPE,''),'Actual') AS "ResultDescription/ResultValueTypeName",
                    RTRIM(WEIGHT_BASIS) AS "ResultDescription/ResultWeightBasisText",
                    rtrim(TIME_BASIS) AS "ResultDescription/ResultTimeBasisText",
                    rtrim(TEMP_BASIS) AS "ResultDescription/ResultTemperatureBasisText",
					rtrim(PARTICLESIZE_BASIS) AS "ResultDescription/ResultParticleSizeBasisText",
					rtrim(PRECISION_VALUE) AS "ResultDescription/DataQuality/PrecisionValue",
					rtrim(BIAS_VALUE) AS "ResultDescription/DataQuality/BiasValue",
					rtrim(CONFIDENCE_INTERVAL_VALUE) AS "ResultDescription/DataQuality/ConfidenceIntervalValue",
					rtrim(UPPER_CONFIDENCE_LIMIT) AS "ResultDescription/DataQuality/UpperConfidenceLimitValue",
					rtrim(LOWER_CONFIDENCE_LIMIT) AS "ResultDescription/DataQuality/LowerConfidenceLimitValue",
					rtrim(RESULT_COMMENT) AS "ResultDescription/ResultCommentText",
					rtrim(DEPTH_HEIGHT_MSR) AS "ResultDescription/ResultDepthHeightMeasure/MeasureValue",
					rtrim(DEPTH_HEIGHT_MSR_UNIT) AS "ResultDescription/ResultDepthHeightMeasure/MeasureUnitCode",
					rtrim(DEPTHALTITUDEREFPOINT) AS "ResultDescription/ResultDepthAltitudeReferencePointText",
					rtrim(RESULT_SAMP_POINT) AS "ResultDescription/ResultSamplingPointName",
					
					case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_INTENT_NAME) else null end as "BiologicalResultDescription/BiologicalIntentName",
					case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_INDIVIDUAL_ID) else null end AS "BiologicalResultDescription/BiologicalIndividualIdentifier",
					case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_SUBJECT_TAXONOMY) else null end as "BiologicalResultDescription/SubjectTaxonomicName",
					case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_UNIDENTIFIED_SPECIES_ID) else null end AS "BiologicalResultDescription/UnidentifiedSpeciesIdentifier",
					case when nullif(BIO_SUBJECT_TAXONOMY,'') is not null then rtrim(BIO_SAMPLE_TISSUE_ANATOMY) else null end as "BiologicalResultDescription/SampleTissueAnatomyName",
					
					rtrim(AM.ANALYTIC_METHOD_ID) as "ResultAnalyticalMethod/MethodIdentifier",
					rtrim(AM.ANALYTIC_METHOD_CTX) as "ResultAnalyticalMethod/MethodIdentifierContext",
					rtrim(AM.ANALYTIC_METHOD_NAME) AS "ResultAnalyticalMethod/MethodName",
					null AS "ResultAnalyticalMethod/MethodQualifierTypeName",
					rtrim(AM.ANALYTIC_METHOD_DESC) AS "ResultAnalyticalMethod/MethodDescriptionText",
					rtrim(LL.LAB_NAME) AS "ResultLabInformation/LaboratoryName",
 				    LEFT(CONVERT(VARCHAR, LAB_ANALYSIS_START_DT, 120), 10) as "ResultLabInformation/AnalysisStartDate", 
					RIGHT(CONVERT(VARCHAR, LAB_ANALYSIS_START_DT, 120), 8) AS "ResultLabInformation/AnalysisStartTime/Time" , 
					CASE WHEN LAB_ANALYSIS_START_DT IS NOT NULL THEN 'CST' ELSE NULL END AS "ResultLabInformation/AnalysisStartTime/TimeZoneCode", 
 				    LEFT(CONVERT(VARCHAR, LAB_ANALYSIS_END_DT, 120), 10) as "ResultLabInformation/AnalysisEndDate", 
					RIGHT(CONVERT(VARCHAR, LAB_ANALYSIS_END_DT, 120), 8) AS "ResultLabInformation/AnalysisEndTime/Time", 
				    CASE WHEN LAB_ANALYSIS_END_DT IS NOT NULL THEN 'CST' ELSE NULL END AS "ResultLabInformation/AnalysisEndTime/TimeZoneCode",
					rtrim(RESULT_LAB_COMMENT_CODE) AS "ResultLabInformation/ResultLaboratoryCommentCode",
					--DETECTION LIMIT HANDLING
					case when (RESULT_MSR in ('ND','NR','PAQL','PBQL','DNQ') or nullif(R.DETECTION_LIMIT,'') is not null or nullif(R.LAB_REPORTING_LEVEL,'') is not null or nullif(R.PQL,'') is not null or nullif(R.LOWER_QUANT_LIMIT,'') is not null or nullif(R.UPPER_QUANT_LIMIT,'') is not null) then 
						 case when nullif(R.DETECTION_LIMIT_TYPE,'') is not null then rtrim(R.DETECTION_LIMIT_TYPE) 
						      when nullif(DETECTION_LIMIT,'') is not null then 'Method Detection Level'
						      when nullif(LAB_REPORTING_LEVEL,'') is not null then 'Laboratory Reporting Level'
						      when nullif(PQL,'') is not null then 'Practical Quantitation Limit'
						      when nullif(LOWER_QUANT_LIMIT,'') is not null then 'Lower Quantitation Limit'
						      when nullif(UPPER_QUANT_LIMIT,'') is not null then 'Upper Quantitation Limit'
							  else  'Estimated Detection Level' end
					end AS "ResultLabInformation/ResultDetectionQuantitationLimit/DetectionQuantitationLimitTypeName",
					case when (RESULT_MSR in ('ND','NR','PAQL','PBQL','DNQ') or nullif(R.DETECTION_LIMIT,'') is not null or nullif(R.LAB_REPORTING_LEVEL,'') is not null or nullif(R.PQL,'') is not null or nullif(R.LOWER_QUANT_LIMIT,'') is not null or nullif(R.UPPER_QUANT_LIMIT,'') is not null) then 
						case when nullif(DETECTION_LIMIT,'') is not null then DETECTION_LIMIT 
						      when nullif(LAB_REPORTING_LEVEL,'') is not null then LAB_REPORTING_LEVEL
						      when nullif(PQL,'') is not null then PQL
						      when nullif(LOWER_QUANT_LIMIT,'') is not null then LOWER_QUANT_LIMIT
						      when nullif(UPPER_QUANT_LIMIT,'') is not null then UPPER_QUANT_LIMIT					     
							  else '0' end
					end AS "ResultLabInformation/ResultDetectionQuantitationLimit/DetectionQuantitationLimitMeasure/MeasureValue",
					case when (RESULT_MSR in ('ND','NR','PAQL','PBQL','DNQ') or nullif(R.DETECTION_LIMIT,'') is not null or nullif(R.LAB_REPORTING_LEVEL,'') is not null or nullif(R.PQL,'') is not null or nullif(R.LOWER_QUANT_LIMIT,'') is not null or nullif(R.UPPER_QUANT_LIMIT,'') is not null) then 
						case when nullif(RESULT_MSR_UNIT,'') is not null then RESULT_MSR_UNIT ELSE 
							(select isnull(rc.DEFAULT_UNIT,'None') from T_WQX_REF_CHARACTERISTIC rc where rc.CHAR_NAME = R.CHAR_NAME) end end AS "ResultLabInformation/ResultDetectionQuantitationLimit/DetectionQuantitationLimitMeasure/MeasureUnitCode"
    				FROM T_WQX_RESULT R 
					LEFT JOIN T_WQX_REF_ANAL_METHOD AM on R.ANALYTIC_METHOD_IDX = AM.ANALYTIC_METHOD_IDX
					LEFT JOIN T_WQX_REF_LAB LL on R.LAB_IDX = LL.LAB_IDX
    				where R.ACTIVITY_IDX = T_WQX_ACTIVITY.ACTIVITY_IDX 
--					and (RESULT_MSR not in ('ND','NR','PAQL','PBQL','DNQ') or DETECTION_LIMIT is not null)
					for xml path('Result'),type ) 
			   from T_WQX_ACTIVITY
			   left join T_WQX_REF_SAMP_COL_METHOD SCL on T_WQX_ACTIVITY.SAMP_COLL_METHOD_IDX = SCL.SAMP_COLL_METHOD_IDX
			   WHERE WQX_SUBMIT_STATUS='U' 
			   and WQX_IND = 1
			   and T_WQX_ACTIVITY.ACT_IND = 1
			   and ACTIVITY_IDX = @RecordIDX
			   for xml path('Activity')
			)
	END


	-- *************************************************************************
	-- ***************** COMBINE ***********************************************
	-- *************************************************************************
	set @strWQX = '<?xml version="1.0" encoding="UTF-8"?>
	<Document Id="UI_' + convert(varchar, getdate(), 112) + '" xmlns="http://www.exchangenetwork.net/schema/v1.0/ExchangeNetworkDocument.xsd">
		<Header>
			<Author>Doug Timms</Author>
			<Organization>EPA</Organization>
			<Title>WQX</Title>
			<CreationTime>' + LEFT(CONVERT(varchar, getdate(), 120), 10) + 'T' + RIGHT(convert(varchar, getdate(), 120), 8) + '</CreationTime>
			<ContactInfo>doug.timms@open-environment.org</ContactInfo>
		</Header>
		<Payload Operation="Update-Insert">
	<WQX xmlns="http://www.exchangenetwork.net/schema/wqx/2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.exchangenetwork.net/schema/wqx/2 
	http://www.exchangenetwork.net/schema/WQX/2/index.xsd">
		<Organization>' + @strOrg + isnull(@strProj,'') + isnull(@strMon,'') + isnull(@strBioIndex,'') + isnull(@strActivity,'') + isnull(@strActGrp,'') + '</Organization></WQX></Payload></Document>'
	
	select @strWQX;

	--IF DEBUG MODE, WRITE TO TRANSACTION LOG
	select @logLevel = (select SETTING_VALUE from T_OE_APP_SETTINGS where SETTING_NAME = 'Log Level');
	if @logLevel='DEBUG' 
	BEGIN
		insert into T_WQX_TRANSACTION_LOG(TABLE_CD, TABLE_IDX, SUBMIT_DT, SUBMIT_TYPE, RESPONSE_TXT) values ('',0,GetDate(), 'I', @strWQX);
	END
END

GO










-- ****************************************************************************************************************************************
-- ************************* [WQX DELETE]*********************************************************************************
-- ****************************************************************************************************************************************


CREATE PROCEDURE [dbo].[GenWQXXML_Single_Delete]
  @TypeText varchar(4),
  @RecordIDX int
AS
BEGIN
	/*
	DESCRIPTION: RETURNS WQX XML FILE CONTAINING A SINGLE DELETED RECORD
	TypeText can be MLOC, PROJ, IDX, or ACT

	CHANGE LOG: 12/26/2014 DOUG TIMMS, OPEN-ENVIRONMENT.ORG
	*/
	SET NOCOUNT ON;

	DECLARE @strWQX varchar(max);       --output XML
	DECLARE @logLevel varchar(20);
	DECLARE @orgID varchar(30);         --Org ID for the deleted record
	DECLARE @delString varchar(200);    --XML snippet for deleted record

	--**********************************************************
    -- GET ORGANIZATION and set XML snippet based on record IDX
	--**********************************************************
	if (@TypeText='PROJ') 
		BEGIN
		SELECT @orgID = ORG_ID from T_WQX_PROJECT where PROJECT_IDX = @RecordIDX; 
		SET @delString = '<ProjectIdentifier>' + convert(varchar, @RecordIDX) + '</ProjectIdentifier>';
		END
	else if (@TypeText='MLOC')
		BEGIN
		SELECT @orgID = ORG_ID from T_WQX_MONLOC where MONLOC_IDX = @RecordIDX; 
		SET @delString = '<MonitoringLocationIdentifier>' + convert(varchar, @RecordIDX) + '</MonitoringLocationIdentifier>';
		END
    else if (@TypeText='ACT')
		BEGIN
		SELECT @orgID = ORG_ID from T_WQX_ACTIVITY where ACTIVITY_IDX = @RecordIDX; 
		SET @delString = '<ActivityIdentifier>' + convert(varchar, @RecordIDX) + '</ActivityIdentifier>';
		END
    else if (@TypeText='IDX')
		BEGIN
		SELECT @orgID = ORG_ID from T_WQX_BIO_HABITAT_INDEX where BIO_HABITAT_INDEX_IDX = @RecordIDX; 
		SET @delString = '<IndexIdentifier>' + convert(varchar, @RecordIDX) + '</IndexIdentifier>';
		END


	-- *************************************************************************
	-- ***************** COMBINE ***********************************************
	-- *************************************************************************
	set @strWQX = '<?xml version="1.0" encoding="UTF-8"?>
	<Document Id="UI_' + convert(varchar, getdate(), 112) + '" xmlns="http://www.exchangenetwork.net/schema/v1.0/ExchangeNetworkDocument.xsd">
		<Header>
			<Author>Open Waters Software</Author>
			<Organization>open-environment.org</Organization>
			<Title>WQX</Title>
			<CreationTime>' + LEFT(CONVERT(varchar, getdate(), 120), 10) + 'T' + RIGHT(convert(varchar, getdate(), 120), 8) + '</CreationTime>
			<ContactInfo>doug.timms@open-environment.org</ContactInfo>
		</Header>
		<Payload Operation="Delete">
	<WQXDelete xmlns="http://www.exchangenetwork.net/schema/wqx/2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.exchangenetwork.net/schema/wqx/2 
	http://www.exchangenetwork.net/schema/WQX/2/index.xsd">
		<OrganizationDelete><OrganizationIdentifier>' + @orgID + '<OrganizationIdentifier>' + @delString + '</OrganizationDelete></WQXDelete></Payload></Document>';
	
	select @strWQX;

	--IF DEBUG MODE, WRITE TO TRANSACTION LOG
	select @logLevel = (select SETTING_VALUE from T_OE_APP_SETTINGS where SETTING_NAME = 'Log Level');
	if @logLevel='DEBUG' 
	BEGIN
		insert into T_WQX_TRANSACTION_LOG(TABLE_CD, TABLE_IDX, SUBMIT_DT, SUBMIT_TYPE, RESPONSE_TXT) values ('',0,GetDate(), 'I', @strWQX);
	END
END


GO



CREATE PROCEDURE [dbo].[ImportActivityFromTemp]
  @UserID varchar(25),
  @WQXInd varchar(1),
  @ActivityReplaceInd varchar(1)
AS
BEGIN
	/*
	DESCRIPTION: COPIES DATA FROM TEMP ACTIVITY AND RESULT TABLES INTO PERMANENT TABLES
	CHANGE LOG: 3/14/2015 DOUG TIMMS, OPEN-ENVIRONMENT.ORG
	5/2/2015 DOUG TIMMS: added ability to update matching activity

	@ActivityReplaceInd: "R": delete existing activity and replace with new one (*recommended*)
						 "U": update existing activity (appending results if found)  (*not recommended)						 
	*/
	SET NOCOUNT ON;

	DECLARE @WQXIndBool bit;
	if @WQXInd='Y' 
		set @WQXIndBool=1;
	else
		set @WQXIndBool=0;


    --delete matching activities 
	if @ActivityReplaceInd='R'
	BEGIN
		delete from T_WQX_ACTIVITY where ACTIVITY_ID in (select ACTIVITY_ID from T_WQX_IMPORT_TEMP_SAMPLE where UPPER(USER_ID)= UPPER(@UserID));
	END


	--insert and update activity case
    merge into T_WQX_ACTIVITY A
    USING T_WQX_IMPORT_TEMP_SAMPLE T
    ON A.ACTIVITY_ID = T.ACTIVITY_ID and T.IMPORT_STATUS_CD = 'P' and UPPER(USER_ID) = UPPER('KAP')
    when MATCHED then 
	    UPDATE SET A.PROJECT_IDX = T.PROJECT_IDX, A.MONLOC_IDX = T.MONLOC_IDX, A.ACT_TYPE = T.ACT_TYPE, A.ACT_MEDIA = T.ACT_MEDIA, A.ACT_SUBMEDIA = T.ACT_SUBMEDIA, 
		A.ACT_START_DT = T.ACT_START_DT, A.ACT_END_DT = T.ACT_END_DT, A.ACT_TIME_ZONE = T.ACT_TIME_ZONE, A.RELATIVE_DEPTH_NAME = T.RELATIVE_DEPTH_NAME, 
		A.ACT_DEPTHHEIGHT_MSR = T.ACT_DEPTHHEIGHT_MSR, A.ACT_DEPTHHEIGHT_MSR_UNIT = T.ACT_DEPTHHEIGHT_MSR_UNIT, A.TOP_DEPTHHEIGHT_MSR = T.TOP_DEPTHHEIGHT_MSR, 
		A.TOP_DEPTHHEIGHT_MSR_UNIT = T.TOP_DEPTHHEIGHT_MSR_UNIT, A.BOT_DEPTHHEIGHT_MSR = T.BOT_DEPTHHEIGHT_MSR, A.BOT_DEPTHHEIGHT_MSR_UNIT = T.BOT_DEPTHHEIGHT_MSR_UNIT, 
		A.DEPTH_REF_POINT = T.DEPTH_REF_POINT, A.ACT_COMMENT = T.ACT_COMMENT, A.BIO_ASSEMBLAGE_SAMPLED = T.BIO_ASSEMBLAGE_SAMPLED, A.BIO_DURATION_MSR = T.BIO_DURATION_MSR, 
		A.BIO_DURATION_MSR_UNIT = T.BIO_DURATION_MSR_UNIT, A.BIO_SAMP_COMPONENT = T.BIO_SAMP_COMPONENT, A.BIO_SAMP_COMPONENT_SEQ = T.BIO_SAMP_COMPONENT_SEQ, 
		A.BIO_REACH_LEN_MSR = T.BIO_REACH_LEN_MSR, A.BIO_REACH_LEN_MSR_UNIT = T.BIO_REACH_LEN_MSR_UNIT, A.BIO_REACH_WID_MSR = T.BIO_REACH_WID_MSR, A.BIO_REACH_WID_MSR_UNIT = T.BIO_REACH_WID_MSR_UNIT, 
		A.BIO_PASS_COUNT = T.BIO_PASS_COUNT, A.BIO_NET_TYPE = T.BIO_NET_TYPE, A.BIO_NET_AREA_MSR = T.BIO_NET_AREA_MSR, A.BIO_NET_AREA_MSR_UNIT = T.BIO_NET_AREA_MSR_UNIT, 
		A.BIO_NET_MESHSIZE_MSR = T.BIO_NET_MESHSIZE_MSR, A.BIO_MESHSIZE_MSR_UNIT = T.BIO_MESHSIZE_MSR_UNIT, A.BIO_BOAT_SPEED_MSR = T.BIO_BOAT_SPEED_MSR, 
		A.BIO_BOAT_SPEED_MSR_UNIT = T.BIO_BOAT_SPEED_MSR_UNIT, A.BIO_CURR_SPEED_MSR = T.BIO_CURR_SPEED_MSR, A.BIO_CURR_SPEED_MSR_UNIT = T.BIO_CURR_SPEED_MSR_UNIT, 
		A.BIO_TOXICITY_TEST_TYPE = T.BIO_TOXICITY_TEST_TYPE, A.SAMP_COLL_METHOD_IDX = T.SAMP_COLL_METHOD_IDX, A.SAMP_COLL_EQUIP = T.SAMP_COLL_EQUIP, 
		A.SAMP_COLL_EQUIP_COMMENT = T.SAMP_COLL_EQUIP_COMMENT, A.SAMP_PREP_IDX = T.SAMP_PREP_IDX, A.SAMP_PREP_CONT_TYPE = T.SAMP_PREP_CONT_TYPE, A.SAMP_PREP_CONT_COLOR = T.SAMP_PREP_CONT_COLOR,
		A.SAMP_PREP_CHEM_PRESERV = T.SAMP_PREP_CHEM_PRESERV, A.SAMP_PREP_THERM_PRESERV = T.SAMP_PREP_THERM_PRESERV, A.SAMP_PREP_STORAGE_DESC = T.SAMP_PREP_STORAGE_DESC,
		A.UPDATE_DT = GetDate(), A.UPDATE_USERID = @UserID, A.ACT_IND = 1, A.WQX_IND = @WQXIndBool, A.WQX_SUBMIT_STATUS = 'U', A.TEMP_SAMPLE_IDX = T.TEMP_SAMPLE_IDX
    when NOT MATCHED then 
		INSERT (ORG_ID, PROJECT_IDX, MONLOC_IDX, ACTIVITY_ID, ACT_TYPE, ACT_MEDIA, ACT_SUBMEDIA, ACT_START_DT, ACT_END_DT, ACT_TIME_ZONE, RELATIVE_DEPTH_NAME, ACT_DEPTHHEIGHT_MSR, ACT_DEPTHHEIGHT_MSR_UNIT, 
		TOP_DEPTHHEIGHT_MSR, TOP_DEPTHHEIGHT_MSR_UNIT, BOT_DEPTHHEIGHT_MSR, BOT_DEPTHHEIGHT_MSR_UNIT, DEPTH_REF_POINT, ACT_COMMENT, BIO_ASSEMBLAGE_SAMPLED, BIO_DURATION_MSR, 
		BIO_DURATION_MSR_UNIT, BIO_SAMP_COMPONENT, BIO_SAMP_COMPONENT_SEQ, BIO_REACH_LEN_MSR, BIO_REACH_LEN_MSR_UNIT, BIO_REACH_WID_MSR, BIO_REACH_WID_MSR_UNIT, BIO_PASS_COUNT,
		BIO_NET_TYPE, BIO_NET_AREA_MSR, BIO_NET_AREA_MSR_UNIT, BIO_NET_MESHSIZE_MSR, BIO_MESHSIZE_MSR_UNIT, BIO_BOAT_SPEED_MSR, BIO_BOAT_SPEED_MSR_UNIT, BIO_CURR_SPEED_MSR, 
		BIO_CURR_SPEED_MSR_UNIT, BIO_TOXICITY_TEST_TYPE, SAMP_COLL_METHOD_IDX, SAMP_COLL_EQUIP, SAMP_COLL_EQUIP_COMMENT, SAMP_PREP_IDX, SAMP_PREP_CONT_TYPE, SAMP_PREP_CONT_COLOR,
		SAMP_PREP_CHEM_PRESERV, SAMP_PREP_THERM_PRESERV, SAMP_PREP_STORAGE_DESC, CREATE_DT, CREATE_USERID, ACT_IND, WQX_IND, WQX_SUBMIT_STATUS, TEMP_SAMPLE_IDX)
		VALUES (T.ORG_ID, T.PROJECT_IDX, T.MONLOC_IDX, T.ACTIVITY_ID, T.ACT_TYPE, T.ACT_MEDIA, T.ACT_SUBMEDIA, T.ACT_START_DT, T.ACT_END_DT, T.ACT_TIME_ZONE, T.RELATIVE_DEPTH_NAME, 
		T.ACT_DEPTHHEIGHT_MSR, T.ACT_DEPTHHEIGHT_MSR_UNIT, T.TOP_DEPTHHEIGHT_MSR, T.TOP_DEPTHHEIGHT_MSR_UNIT, T.BOT_DEPTHHEIGHT_MSR, T.BOT_DEPTHHEIGHT_MSR_UNIT, T.DEPTH_REF_POINT, 
		T.ACT_COMMENT, T.BIO_ASSEMBLAGE_SAMPLED, T.BIO_DURATION_MSR, T.BIO_DURATION_MSR_UNIT, T.BIO_SAMP_COMPONENT, T.BIO_SAMP_COMPONENT_SEQ, T.BIO_REACH_LEN_MSR, T.BIO_REACH_LEN_MSR_UNIT, 
		T.BIO_REACH_WID_MSR, T.BIO_REACH_WID_MSR_UNIT, T.BIO_PASS_COUNT, T.BIO_NET_TYPE, T.BIO_NET_AREA_MSR, T.BIO_NET_AREA_MSR_UNIT, T.BIO_NET_MESHSIZE_MSR, T.BIO_MESHSIZE_MSR_UNIT, 
		T.BIO_BOAT_SPEED_MSR, T.BIO_BOAT_SPEED_MSR_UNIT, T.BIO_CURR_SPEED_MSR,  T.BIO_CURR_SPEED_MSR_UNIT, T.BIO_TOXICITY_TEST_TYPE, T.SAMP_COLL_METHOD_IDX, T.SAMP_COLL_EQUIP, 
		T.SAMP_COLL_EQUIP_COMMENT, T.SAMP_PREP_IDX, T.SAMP_PREP_CONT_TYPE, T.SAMP_PREP_CONT_COLOR, T.SAMP_PREP_CHEM_PRESERV, T.SAMP_PREP_THERM_PRESERV, T.SAMP_PREP_STORAGE_DESC, 
		GetDate(), @UserID, 1, @WQXIndBool, 'U', T.TEMP_SAMPLE_IDX);



	--insert result
	insert into T_WQX_RESULT (ACTIVITY_IDX,	DATA_LOGGER_LINE, RESULT_DETECT_CONDITION, CHAR_NAME, METHOD_SPECIATION_NAME, RESULT_SAMP_FRACTION, RESULT_MSR, RESULT_MSR_UNIT, RESULT_MSR_QUAL, 
	RESULT_STATUS, STATISTIC_BASE_CODE, RESULT_VALUE_TYPE, WEIGHT_BASIS, TIME_BASIS, TEMP_BASIS, PARTICLESIZE_BASIS, PRECISION_VALUE, BIAS_VALUE, 
	CONFIDENCE_INTERVAL_VALUE, UPPER_CONFIDENCE_LIMIT, LOWER_CONFIDENCE_LIMIT, RESULT_COMMENT, DEPTH_HEIGHT_MSR, DEPTH_HEIGHT_MSR_UNIT, DEPTHALTITUDEREFPOINT, 
	BIO_INTENT_NAME, BIO_INDIVIDUAL_ID, BIO_SUBJECT_TAXONOMY, BIO_UNIDENTIFIED_SPECIES_ID, BIO_SAMPLE_TISSUE_ANATOMY, GRP_SUMM_COUNT_WEIGHT_MSR, GRP_SUMM_COUNT_WEIGHT_MSR_UNIT, 
	TAX_DTL_CELL_FORM, TAX_DTL_CELL_SHAPE, TAX_DTL_HABIT, TAX_DTL_VOLTINISM, TAX_DTL_POLL_TOLERANCE, TAX_DTL_POLL_TOLERANCE_SCALE, TAX_DTL_TROPHIC_LEVEL, 
	TAX_DTL_FUNC_FEEDING_GROUP1, TAX_DTL_FUNC_FEEDING_GROUP2, TAX_DTL_FUNC_FEEDING_GROUP3, [FREQ_CLASS_CODE], [FREQ_CLASS_UNIT], [FREQ_CLASS_UPPER], [FREQ_CLASS_LOWER], 
	ANALYTIC_METHOD_IDX, LAB_IDX, LAB_ANALYSIS_START_DT, 
	LAB_ANALYSIS_END_DT, LAB_ANALYSIS_TIMEZONE, RESULT_LAB_COMMENT_CODE, DETECTION_LIMIT, LAB_REPORTING_LEVEL, PQL, LOWER_QUANT_LIMIT, UPPER_QUANT_LIMIT,
	DETECTION_LIMIT_UNIT, LAB_SAMP_PREP_IDX, LAB_SAMP_PREP_START_DT, LAB_SAMP_PREP_END_DT, DILUTION_FACTOR
	)
	select A.ACTIVITY_IDX, R.DATA_LOGGER_LINE, R.RESULT_DETECT_CONDITION, R.CHAR_NAME, R.METHOD_SPECIATION_NAME, R.RESULT_SAMP_FRACTION, R.RESULT_MSR, R.RESULT_MSR_UNIT, R.RESULT_MSR_QUAL, 
	R.RESULT_STATUS, R.STATISTIC_BASE_CODE, R.RESULT_VALUE_TYPE, R.WEIGHT_BASIS, R.TIME_BASIS, R.TEMP_BASIS, R.PARTICLESIZE_BASIS, R.PRECISION_VALUE, R.BIAS_VALUE, 
	R.CONFIDENCE_INTERVAL_VALUE, R.UPPER_CONFIDENCE_LIMIT, R.LOWER_CONFIDENCE_LIMIT, R.RESULT_COMMENT, R.DEPTH_HEIGHT_MSR, R.DEPTH_HEIGHT_MSR_UNIT, R.DEPTHALTITUDEREFPOINT, 
	R.BIO_INTENT_NAME, R.BIO_INDIVIDUAL_ID, R.BIO_SUBJECT_TAXONOMY, R.BIO_UNIDENTIFIED_SPECIES_ID, R.BIO_SAMPLE_TISSUE_ANATOMY, R.GRP_SUMM_COUNT_WEIGHT_MSR, R.GRP_SUMM_COUNT_WEIGHT_MSR_UNIT, 
	R.TAX_DTL_CELL_FORM, r.TAX_DTL_CELL_SHAPE, r.TAX_DTL_HABIT, r.TAX_DTL_VOLTINISM, r.TAX_DTL_POLL_TOLERANCE, r.TAX_DTL_POLL_TOLERANCE_SCALE, r.TAX_DTL_TROPHIC_LEVEL, 
	r.TAX_DTL_FUNC_FEEDING_GROUP1, r.TAX_DTL_FUNC_FEEDING_GROUP2, r.TAX_DTL_FUNC_FEEDING_GROUP3, r.FREQ_CLASS_CODE, r.FREQ_CLASS_UNIT, r.FREQ_CLASS_UPPER, r.FREQ_CLASS_LOWER, 
	r.ANALYTIC_METHOD_IDX, r.LAB_IDX, r.LAB_ANALYSIS_START_DT, 
	r.LAB_ANALYSIS_END_DT, r.LAB_ANALYSIS_TIMEZONE, r.RESULT_LAB_COMMENT_CODE, r.METHOD_DETECTION_LEVEL, r.LAB_REPORTING_LEVEL, r.PQL, r.LOWER_QUANT_LIMIT, r.UPPER_QUANT_LIMIT,
	r.DETECTION_LIMIT_UNIT, r.LAB_SAMP_PREP_IDX, r.LAB_SAMP_PREP_START_DT, r.LAB_SAMP_PREP_END_DT, r.DILUTION_FACTOR
	from T_WQX_IMPORT_TEMP_RESULT R, T_WQX_ACTIVITY A, T_WQX_IMPORT_TEMP_SAMPLE S
	where R.TEMP_SAMPLE_IDX = S.TEMP_SAMPLE_IDX 
	and S.TEMP_SAMPLE_IDX = A.TEMP_SAMPLE_IDX
	and R.IMPORT_STATUS_CD = 'P'
	and UPPER(S.USER_ID) = UPPER(@UserID);


	--insert characteristics into the org reference list if they do not yet exist
	DECLARE @OrgID varchar(30);
	select top 1 @OrgID = ORG_ID from T_WQX_IMPORT_TEMP_SAMPLE where UPPER(USER_ID) = UPPER(@UserID)

	insert into T_WQX_REF_CHAR_ORG (CHAR_NAME, ORG_ID, CREATE_USERID, CREATE_DT)
	select distinct R.char_name , @OrgID, 'SYSTEM', GetDate()
	from T_WQX_ACTIVITY A, T_WQX_RESULT R
	left join T_WQX_REF_CHAR_ORG O on R.CHAR_NAME = O.CHAR_NAME  and O.ORG_ID = @OrgID
	where R.ACTIVITY_IDX = A.ACTIVITY_IDX
	and A.ORG_ID = @OrgID
	and O.CHAR_NAME is null;


	--insert taxa into the org reference list if they do not yet exist
	insert into T_WQX_REF_TAXA_ORG ([BIO_SUBJECT_TAXONOMY], ORG_ID, CREATE_USERID, CREATE_DT)
	select distinct R.[BIO_SUBJECT_TAXONOMY] , @OrgID, 'SYSTEM', GetDate()
	from T_WQX_ACTIVITY A, T_WQX_RESULT R
	left join T_WQX_REF_TAXA_ORG O on R.[BIO_SUBJECT_TAXONOMY]= O.[BIO_SUBJECT_TAXONOMY]  and O.ORG_ID = @OrgID
	where R.ACTIVITY_IDX = A.ACTIVITY_IDX
	and A.ORG_ID = @OrgID
	and O.[BIO_SUBJECT_TAXONOMY] is null
	and NULLIF(R.BIO_SUBJECT_TAXONOMY,'') is not null;


	--update the entry type column for all imported sample
	UPDATE T_WQX_ACTIVITY set ENTRY_TYPE = 'C' where ENTRY_TYPE IS NULL;
	
	UPDATE T_WQX_ACTIVITY set ENTRY_TYPE = 'H' where ORG_ID = @OrgID and CREATE_DT > GetDate()-1 and
	(select count(*) from T_WQX_RESULT R where R.ACTIVITY_IDX = T_WQX_ACTIVITY.ACTIVITY_IDX and CHAR_NAME like '%RBP%') > 0;
	
	UPDATE T_WQX_ACTIVITY set ENTRY_TYPE = 'T' where ORG_ID = @OrgID and CREATE_DT > GetDate()-1 and
	(select count(*) from T_WQX_RESULT R where R.ACTIVITY_IDX = T_WQX_ACTIVITY.ACTIVITY_IDX and len(BIO_SUBJECT_TAXONOMY) > 0) > 0


	--DELETE TEMP DATA
	DELETE FROM T_WQX_IMPORT_TEMP_SAMPLE where UPPER(USER_ID) = UPPER(@UserID);



END


GO