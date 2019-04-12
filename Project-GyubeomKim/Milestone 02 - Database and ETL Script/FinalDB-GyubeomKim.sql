--*************************************************************************--
-- Title: Final Project - Creating database
-- Author: GyubeomKim
-- Desc: This file is used to create a database for the Final
-- Change Log: When,Who,What
--           : 2018-07-20,GyubeomKim,zip -> zipcode
--           : 2018-07-20,GyubeomKim, address2 added as NULL
-- 2018-07-23,GyubeomKim,Created File
--**************************************************************************--
-- Step 1: Create the Lab database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyFinalProjectDB_GyubeomKim')
 Begin 
  Alter Database [MyFinalProjectDB_GyubeomKim] set Single_user With Rollback Immediate;
  Drop Database MyFinalProjectDB_GyubeomKim;
 End
go

Create Database MyFinalProjectDB_GyubeomKim;
go

Use MyFinalProjectDB_GyubeomKim;
go

-- 1) Create the tables --------------------------------------------------------
Create Table Clinics
 (ClinicID int NOT NULL Constraint pkClinicID Primary Key IDENTITY
 ,ClinicName nVarchar(100) NOT NULL UNIQUE
 ,ClinicPhoneNumber nVarchar(100) NULL
 ,ClinicAddress1 nVarchar(100) NOT NULL
 ,ClinicAddress2 nVarchar(100) NULL
 ,ClinicCity nVarchar(100) NOT NULL
 ,ClinicState nChar(2) NOT NULL
 ,ClinicZipCode nChar(10) NOT NULL
 );
Go

Create Table Patients
 (PatientID int NOT NULL Constraint pkPatientID Primary Key IDENTITY
 ,PatientFirstName nVarchar(100) NOT NULL
 ,PatientLastName nVarchar(100) NOT NULL
 ,PatientPhoneNumber nVarchar(100) NULL
 ,PatientAddress1 nVarchar(100) NOT NULL
 ,PatientAddress2 nVarchar(100) NULL
 ,PatientCity nVarchar(100) NOT NULL
 ,PatientState nChar(2) NOT NULL
 ,PatientZipCode nChar(10) NOT NULL
 );
Go

Create Table Doctors
 (DoctorID int NOT NULL Constraint pkDoctorID Primary Key IDENTITY
 ,DoctorFirstName nVarchar(100) NOT NULL
 ,DoctorLastName nVarchar(100) NOT NULL
 ,DoctorPhoneNumber nVarchar(100) NULL
 ,DoctorAddress1 nVarchar(100) NOT NULL
 ,DoctorAddress2 nVarchar(100) NULL
 ,DoctorCity nVarchar(100) NOT NULL
 ,DoctorState nChar(2) NOT NULL
 ,DoctorZipCode nChar(10) NOT NULL
 );
Go

Create Table Appointments
 (AppointmentID int NOT NULL Constraint pkAppointmentID Primary Key IDENTITY
 ,ClinicID int NOT NULL
 ,PatientID int NOT NULL
 ,DoctorID int NOT NULL
 ,AppointmentDateAndTime datetime NOT NULL
 );
Go

-- 2) Create the constraints ---------------------------------------------------
--Clinics--
Alter Table Clinics
    Add Constraint ckClinicZipcode
	 Check (ClinicZipcode Like '[0-9][0-9][0-9][0-9][0-9]%'
	    OR  ClinicZipcode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]');
Go

Alter Table Clinics
    Add Constraint ckClinicPhoneNumber
	 Check (ClinicPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go
--Patients--
Alter Table Patients
    Add Constraint ckPatientZipcode
	 Check (PatientZipcode Like '[0-9][0-9][0-9][0-9][0-9]%'
	    OR  PatientZipcode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]');
Go

Alter Table Patients
    Add Constraint ckPatientPhoneNumber
	 Check (PatientPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go
--Doctors--
Alter Table Doctors
    Add Constraint ckDoctorZipcode
	 Check (DoctorZipcode Like '[0-9][0-9][0-9][0-9][0-9]%'
	    OR  DoctorZipcode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]');
Go

Alter Table Doctors
    Add Constraint ckDoctorPhoneNumber
	 Check (DoctorPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go
--Appointments--
Alter Table Appointments
    Add Constraint fkAppointmentsToClnics Foreign Key (ClinicID)
        References Clinics(ClinicID);
Go
Alter Table Appointments
    Add Constraint fkAppointmentsToPatients Foreign Key (PatientID)
        References Patients(PatientID);
Go

Alter Table Appointments
    Add Constraint fkAppointmentsToDoctors Foreign Key (DoctorID)
        References Doctors(DoctorID);
Go

Alter Table Appointments
    Add Constraint ckAppointmentDateAndTime
        Check (AppointmentDateAndTime > getdate());
Go

-- 3) Create the views ---------------------------------------------------------
Create View vClinics
 As
  Select ClinicID
        ,ClinicName
        ,ClinicPhoneNumber
	    ,ClinicAddress1
	    ,ClinicAddress2
        ,ClinicCity
	    ,ClinicState
	    ,ClinicZipCode
 From Clinics
Go

Create View vPatients
 As
  Select PatientID
        ,PatientFirstName
        ,PatientLastName
	    ,PatientPhoneNumber
	    ,PatientAddress1
        ,PatientAddress2
	    ,PatientCity
        ,PatientState
	    ,PatientZipCode
 From Patients
Go

Create View vDoctors
 As
 Select DoctorID
       ,DoctorFirstName
       ,DoctorLastName
       ,DoctorPhoneNumber
       ,DoctorAddress1
       ,DoctorAddress2
       ,DoctorCity
       ,DoctorState
       ,DoctorZipCode
 From Doctors
Go

Create View vAppointments
 As
 Select AppointmentID
       ,ClinicID
       ,PatientID
       ,DoctorID
       ,AppointmentDateAndTime
 From Appointments
Go
--Reporting View--
Create View vAppointmentsByPatientsDoctorsAndClinics
 As
 Select A.AppointmentID
	   ,A.AppointmentDateAndTime
	   ,P.PatientID
       ,P.PatientFirstName
       ,P.PatientLastName
       ,P.PatientPhoneNumber
       ,P.PatientAddress1
       ,P.PatientAddress2
       ,P.PatientCity
       ,P.PatientState
       ,P.PatientZipCode
	   ,D.DoctorID
       ,D.DoctorFirstName
       ,D.DoctorLastName
       ,D.DoctorPhoneNumber
       ,D.DoctorAddress1
       ,D.DoctorAddress2
       ,D.DoctorCity
       ,D.DoctorState
       ,D.DoctorZipCode
	   ,C.ClinicID
       ,C.ClinicName
       ,C.ClinicPhoneNumber
       ,C.ClinicAddress1
       ,C.ClinicAddress2
       ,C.ClinicCity
       ,C.ClinicState
       ,C.ClinicZipCode
	   From Appointments as A
	   Join Patients as P
		On A.PatientID = P.PatientID
	   Join Doctors as D
		On A.DoctorID = D.DoctorID
	   Join Clinics as C
		On A.ClinicID = C.ClinicID
Go

-- 4) Create the stored procedures ---------------------------------------------
--Insert--
Create Procedure pInsClinics
 (@ClinicID int Output
 ,@ClinicName nVarchar(100) 
 ,@ClinicPhoneNumber nVarchar(100) 
 ,@ClinicAddress1 nVarchar(100)
 ,@ClinicAddress2 nVarchar(100) 
 ,@ClinicCity nVarchar(100)
 ,@ClinicState nChar(2)
 ,@ClinicZipCode nChar(10)
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for inserting Clinics
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Clinics 
	  (ClinicName
      ,ClinicPhoneNumber
	  ,ClinicAddress1
	  ,ClinicAddress2
	  ,ClinicCity
	  ,ClinicState
	  ,ClinicZipCode
    ) 
    Values 
	  (@ClinicName
      ,@ClinicPhoneNumber
	  ,@ClinicAddress1
	  ,@ClinicAddress2
	  ,@ClinicCity
	  ,@ClinicState
	  ,@ClinicZipCode
    );
   Set @ClinicID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsPatients
 (@PatientID int Output
 ,@PatientFirstName nVarchar(100)
 ,@PatientLastName nVarchar(100)
 ,@PatientPhoneNumber nVarchar(100) 
 ,@PatientAddress1 nVarchar(100)
 ,@PatientAddress2 nVarchar(100) 
 ,@PatientCity nVarchar(100)
 ,@PatientState nChar(2)
 ,@PatientZipCode nChar(10)
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for inserting Patients
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Patients 
	  (PatientFirstName
      ,PatientLastName
	  ,PatientPhoneNumber
	  ,PatientAddress1
	  ,PatientAddress2
	  ,PatientCity
	  ,PatientState
      ,PatientZipCode
      ) 
    Values 
	  (@PatientFirstName
     ,@PatientLastName
	 ,@PatientPhoneNumber
	 ,@PatientAddress1
	 ,@PatientAddress2
	 ,@PatientCity
	 ,@PatientState
     ,@PatientZipCode
    );
   Set @PatientID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsDoctors
 (@DoctorID int Output
 ,@DoctorFirstName nVarchar(100)
 ,@DoctorLastName nVarchar(100)
 ,@DoctorPhoneNumber nVarchar(100) 
 ,@DoctorAddress1 nVarchar(100)
 ,@DoctorAddress2 nVarchar(100) 
 ,@DoctorCity nVarchar(100)
 ,@DoctorState nChar(2)
 ,@DoctorZipCode nChar(10)
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for inserting Doctors
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Doctors 
	  (DoctorFirstName
      ,DoctorLastName
	  ,DoctorPhoneNumber
	  ,DoctorAddress1
	  ,DoctorAddress2
	  ,DoctorCity
	  ,DoctorState
    ,DoctorZipCode
    ) 
    Values 
	  (@DoctorFirstName
      ,@DoctorLastName
	  ,@DoctorPhoneNumber
	  ,@DoctorAddress1
	  ,@DoctorAddress2
	  ,@DoctorCity
	  ,@DoctorState
    ,@DoctorZipCode
    );
   Set @DoctorID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsAppointments
 (@AppointmentID int Output
 ,@ClinicID int
 ,@PatientID int
 ,@DoctorID int
 ,@AppointmentDateAndTime datetime
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for inserting Appointments
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Appointments
	  (ClinicID
      ,PatientID
      ,DoctorID
      ,AppointmentDateAndTime
      ) 
    Values 
	  (@ClinicID
    ,@PatientID
	  ,@DoctorID
    ,@AppointmentDateAndTime
    );
   Set @AppointmentID = @@IDENTITY
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

--Update--
Create Procedure pUpdClinics
 (@ClinicID int
 ,@ClinicName nVarchar(100) 
 ,@ClinicPhoneNumber nVarchar(100) 
 ,@ClinicAddress1 nVarchar(100)
 ,@ClinicAddress2 nVarchar(100) 
 ,@ClinicCity nVarchar(100)
 ,@ClinicState nChar(2)
 ,@ClinicZipCode nChar(10)
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for updating Clinics
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
   Update Clinics 
    Set ClinicName = @ClinicName
       ,ClinicPhoneNumber = @ClinicPhoneNumber
	   ,ClinicAddress1 = @ClinicAddress1
	   ,ClinicAddress2 = @ClinicAddress2
	   ,ClinicCity = @ClinicCity
	   ,ClinicState = @ClinicState
	   ,ClinicZipCode = @ClinicZipCode
   Where ClinicID = @ClinicID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdPatients
 (@PatientID int
 ,@PatientFirstName nVarchar(100)
 ,@PatientLastName nVarchar(100)
 ,@PatientPhoneNumber nVarchar(100) 
 ,@PatientAddress1 nVarchar(100)
 ,@PatientAddress2 nVarchar(100) 
 ,@PatientCity nVarchar(100)
 ,@PatientState nChar(2)
 ,@PatientZipCode nChar(10)
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for updating Patients
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
   Update Patients 
    Set PatientFirstName = @PatientFirstName
       ,PatientLastName = @PatientLastName
	   ,PatientPhoneNumber = @PatientPhoneNumber
	   ,PatientAddress1 = @PatientAddress1
	   ,PatientAddress2 = @PatientAddress2
	   ,PatientCity = @PatientCity
	   ,PatientState = @PatientState
       ,PatientZipCode = @PatientZipCode
   Where PatientID = @PatientID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdDoctors
 (@DoctorID int
 ,@DoctorFirstName nVarchar(100)
 ,@DoctorLastName nVarchar(100)
 ,@DoctorPhoneNumber nVarchar(100) 
 ,@DoctorAddress1 nVarchar(100)
 ,@DoctorAddress2 nVarchar(100) 
 ,@DoctorCity nVarchar(100)
 ,@DoctorState nChar(2)
 ,@DoctorZipCode nChar(10)
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for updating Doctors
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
   Update Doctors 
    Set DoctorFirstName = @DoctorFirstName
       ,DoctorLastName = @DoctorLastName
	   ,DoctorPhoneNumber = @DoctorPhoneNumber
	   ,DoctorAddress1 = @DoctorAddress1
	   ,DoctorAddress2 = @DoctorAddress2
	   ,DoctorCity = @DoctorCity
	   ,DoctorState = @DoctorState
       ,DoctorZipCode = @DoctorZipCode
   Where DoctorID = @DoctorID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdAppointments
 (@AppointmentID int
 ,@ClinicID int
 ,@PatientID int
 ,@DoctorID int
 ,@AppointmentDateAndTime datetime
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for updating Appointments
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
   Update Appointments 
    Set ClinicID = @ClinicID
       ,PatientID = @PatientID
	   ,DoctorID = @DoctorID
       ,AppointmentDateAndTime = @AppointmentDateAndTime
   Where AppointmentID = @AppointmentID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

--Delete--
Create Procedure pDelAppointments
 (@AppointmentID int
 ,@ClinicID int
 ,@PatientID int
 ,@DoctorID int
 )
/* Author: <GyubeomKim>
** Desc: Stored Procedures for deleting Appointments
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
   Delete 
    From Appointments 
     Where AppointmentID = @AppointmentID;
  Delete 
    From Clinics 
     Where ClinicID = @ClinicID; 
  Delete 
    From Patients 
     Where PatientID = @PatientID;
  Delete 
    From Doctors 
     Where DoctorID = @DoctorID; 	      	  
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelClinics
 (@ClinicID int)
/* Author: <GyubeomKim>
** Desc: Stored Procedures for deleting Clinics
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
  Delete 
    From Clinics 
     Where ClinicID = @ClinicID; 	      	  
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go 

Create Procedure pDelPatients
 (@PatientID int)
/* Author: <GyubeomKim>
** Desc: Stored Procedures for deleting Patients
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
  Delete 
    From Patients 
     Where PatientID = @PatientID;	      	  
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go 

Create Procedure pDelDoctors
 (@DoctorID int)
/* Author: <GyubeomKim>
** Desc: Stored Procedures for deleting Appointments
** Change Log: When,Who,What
** <2018-07-23>,<GyubeomKim>,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
  Delete 
    From Doctors 
     Where DoctorID = @DoctorID; 	      	  
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go  

-- 5) Set the permissions ------------------------------------------------------
Begin
 --Clinics--
 Deny Select, Insert, Update, Delete On [dbo].[Clinics] To Public;
 Grant Select On [dbo].[vClinics] To Public;
 Grant Execute On [dbo].[pInsClinics] To Public;
 Grant Execute On [dbo].[pUpdClinics] To Public;
 Grant Execute On [dbo].[pDelClinics] To Public;
 --Patients--
 Deny Select, Insert, Update, Delete On [dbo].[Patients] To Public;
 Grant Select On [dbo].[vPatients] To Public;
 Grant Execute On [dbo].[pInsPatients] To Public;
 Grant Execute On [dbo].[pUpdPatients] To Public;
 Grant Execute On [dbo].[pDelPatients] To Public;
 --Doctors--
 Deny Select, Insert, Update, Delete On [dbo].[Doctors] To Public;
 Grant Select On [dbo].[vDoctors] To Public;
 Grant Execute On [dbo].[pInsDoctors] To Public;
 Grant Execute On [dbo].[pUpdDoctors] To Public;
 Grant Execute On [dbo].[pDelDoctors] To Public;
 --Appointments--
 Deny Select, Insert, Update, Delete On [dbo].[Appointments] To Public;
 Grant Select On [dbo].[vAppointments] To Public;
 Grant Execute On [dbo].[pInsAppointments] To Public;
 Grant Execute On [dbo].[pUpdAppointments] To Public;
 Grant Execute On [dbo].[pDelAppointments] To Public;
 --vAppointmentsByPatientsDoctorsAndClinics--
 Grant Select On [dbo].[vAppointmentsByPatientsDoctorsAndClinics] To Public;
End
Go

-- 6) Test the views and stored procedures -------------------------------------
Declare @Status int
       ,@NewClinicID int
       ,@NewPatientID int
       ,@NewDoctorID int
       ,@NewAppointmentID int;
 
 --Insert--
 --Clinics--
 Exec @Status = pInsClinics
      @ClinicID = @NewClinicID Output
     ,@ClinicName = 'Healthy Life'
     ,@ClinicPhoneNumber = '206-123-1234'
     ,@ClinicAddress1 = '4115 Rosevelt Way NE'
     ,@ClinicAddress2 = ''
     ,@ClinicCity = 'Seattle'
     ,@ClinicState = 'WA'
     ,@ClinicZipCode = '98105'
 Select Case @Status
    When +1 Then 'Clinic Insert was successful!'
    When -1 Then 'Clinic Insert failed! Common Issues: Duplicate Data'
    End as [Status];
    --Select * From vClinics;
 --Patients--
 Exec @Status = pInsPatients
      @PatientID = @NewPatientID Output
	 ,@PatientFirstName = 'Matt'
     ,@PatientLastName = 'Choi'
     ,@PatientPhoneNumber = '217-111-2222'
     ,@PatientAddress1 = '393 Robson st'
     ,@PatientAddress2 = ''
     ,@PatientCity = 'Seattle'
     ,@PatientState = 'WA'
     ,@PatientZipCode = '98101'
 Select Case @Status
    When +1 Then 'Patient Insert was successful!'
    When -1 Then 'Patient Insert failed! Common Issues: Duplicate Data'
    End as [Status];
    --Select * From vPatients;
 --Doctors--
 Exec @Status = pInsDoctors
	  @DoctorID = @NewDoctorID Output
	 ,@DoctorFirstName = 'Brad'
     ,@DoctorLastName = 'Kim'
     ,@DoctorPhoneNumber = '718-490-2222'
     ,@DoctorAddress1 = '3123 University Way st'
     ,@DoctorAddress2 = ''
     ,@DoctorCity = 'Seattle'
     ,@DoctorState = 'WA'
     ,@DoctorZipCode = '98123'
 Select Case @Status
    When +1 Then 'Doctor Insert was successful!'
    When -1 Then 'Doctor Insert failed! Common Issues: Duplicate Data'
    End as [Status];
    --Select * From vDoctors;
 --Appointments--
 Exec @Status = pInsAppointments
	  @AppointmentID = @NewAppointmentID Output
	 ,@ClinicID = @NewClinicID
     ,@PatientID = @NewPatientID
     ,@DoctorID = @NewDoctorID
     ,@AppointmentDateAndTime = '2020/08/17 2:00 PM'
 Select Case @Status
    When +1 Then 'Appointment Insert was successful!'
    When -1 Then 'Appointment Insert failed! Common Issues: Duplicate Data'
    End as [Status];
    --Select * From vAppointments;    
  --Show current result after inserting--
 Select * From vClinics;
 Select * From vPatients;
 Select * From vDoctors;
 Select * From vAppointments;
  Select * From vAppointmentsByPatientsDoctorsAndClinics;
 --Update--
 --Clinics--
 Exec @Status = pUpdClinics
      @ClinicID = @NewClinicID
     ,@ClinicName = 'Healthy Life'
     ,@ClinicPhoneNumber = '206-494-7777'
     ,@ClinicAddress1 = '4115 Rosevelt Way NE'
     ,@ClinicAddress2 = ''
     ,@ClinicCity = 'Seattle'
     ,@ClinicState = 'WA'
     ,@ClinicZipCode = '98106'
 Select Case @Status
   When +1 Then 'Clinic Update was successful!'
   When -1 Then 'Clinic Update failed! Common Issues: Duplicate Data or Foreign Key'
   End as [Status];
   Set @NewClinicID = @@IDENTITY;
   --Select * From vClinics;
 --Patients--
  Exec @Status = pUpdPatients
	   @PatientID = @NewPatientID
      ,@PatientFirstName = 'Matt'
      ,@PatientLastName = 'Choi'
      ,@PatientPhoneNumber = '215-131-3333'
      ,@PatientAddress1 = '383 Babe st'
      ,@PatientAddress2 = ''
      ,@PatientCity = 'Bellevue'
      ,@PatientState = 'WA'
      ,@PatientZipCode = '98112'
 Select Case @Status
   When +1 Then 'Patient Update was successful!'
   When -1 Then 'Patient Update failed! Common Issues: Duplicate Data or Foreign Key'
   End as [Status];
   Set @NewPatientID = @@IDENTITY;
   --Select * From vPatients;
 --Doctors--
 Exec @Status = pUpdDoctors
	  @DoctorID = @NewDoctorID
	 ,@DoctorFirstName = 'Brad'
     ,@DoctorLastName = 'Park'
     ,@DoctorPhoneNumber = '718-490-2323'
     ,@DoctorAddress1 = '3123 University Way st'
     ,@DoctorAddress2 = ''
     ,@DoctorCity = 'Seattle'
     ,@DoctorState = 'WA'
     ,@DoctorZipCode = '98105'
 Select Case @Status
   When +1 Then 'Doctor Update was successful!'
   When -1 Then 'Doctor Update failed! Common Issues: Duplicate Data or Foreign Key'
   End as [Status];
   Set @NewDoctorID = @@IDENTITY;
   --Select * From vDoctors;
 --Appointments--
 Exec @Status = pUpdAppointments
	  @AppointmentID = @NewAppointmentID
     ,@ClinicID = @NewClinicID
     ,@PatientID = @NewPatientID
     ,@DoctorID = @NewDoctorID
     ,@AppointmentDateAndTime = '2019/08/17 3:00 PM'
 Select Case @Status
   When +1 Then 'Appointment Update was successful!'
   When -1 Then 'Appointment Update failed! Common Issues: Duplicate Data or Foreign Key'
   End as [Status];
   Set @NewAppointmentID = @@IDENTITY;
   --Select * From vAppointments;
 --Show current result after updating--
 Select * From vClinics;
 Select * From vPatients;
 Select * From vDoctors;
 Select * From vAppointments;
 Select * From vAppointmentsByPatientsDoctorsAndClinics;
 --Delete--
 --Appointments -> Clinics -> Patients -> Doctors (To avoid Error)
 --Appointments--
 Exec @Status = pDelAppointments
      @AppointmentID = @NewAppointmentID
     ,@ClinicID = @NewClinicID
     ,@PatientID = @NewPatientID
     ,@DoctorID = @NewDoctorID
 Select Case @Status
   When +1 Then 'Appointment Delete was successful!'
   When -1 Then 'Appointment Delete failed! Common Issues: Foreign Key Violation'
   End as [Status];
   --Select * From vAppointments;
 --Clinics--
 Exec @Status = pDelClinics
      @ClinicID = @NewClinicID
 Select Case @Status
   When +1 Then 'Clinic Delete was successful!'
   When -1 Then 'Clinic Delete failed! Common Issues: Foreign Key Violation'
   End as [Status];
   --Select * From vClinics; 
 --Patients--
 Exec @Status = pDelPatients
      @PatientID = @NewPatientID
 Select Case @Status
   When +1 Then 'Patient Delete was successful!'
   When -1 Then 'Patient Delete failed! Common Issues: Foreign Key Violation'
   End as [Status];
   --Select * From vPatients; 
 --Doctors--
 Exec @Status = pDelDoctors
      @DoctorID = @NewDoctorID
 Select Case @Status
   When +1 Then 'Doctor Delete was successful!'
   When -1 Then 'Doctor Delete failed! Common Issues: Foreign Key Violation'
   End as [Status];
   --Select * From vDoctors;
 --Show current result after deleting--
 Select * From vClinics;
 Select * From vPatients;
 Select * From vDoctors;
 Select * From vAppointments;
 Select * From vAppointmentsByPatientsDoctorsAndClinics;
Go