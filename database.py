import os
import pymysql


class Database:
    @staticmethod
    def connect():
        """
        Establishes a connection to the database using environment variables for the connection parameters.
        """
        try:
            host = os.environ.get("DB_HOST")
            user = os.environ.get("DB_USER")
            password = os.environ.get("DB_PASSWORD")
            database = os.environ.get("DB_NAME")
            print(f"Connecting to database at {host} with user {user}")

            connection = pymysql.connect(
                host=host,
                user=user,
                password=password,
                database=database,
                cursorclass=pymysql.cursors.DictCursor,
                connect_timeout=10
            )
            return connection
        except Exception as e:
            print(f"Error connecting to database: {e}")
            return None

    @staticmethod
    def execute(query, values=None):
        """
        Executes a query that modifies the database (INSERT, UPDATE, DELETE).
        """
        with Database.connect() as connection:
            try:
                with connection.cursor() as cursor:
                    cursor.execute(query, (*values,)) 
                connection.commit()
                return True
            except pymysql.Error as e:  
                print(f"Database execution error: {e}")
                return False
    @staticmethod
    def fetch_all(query, values=None):
        """
        Executes a query that retrieves data from the database (SELECT).
        """
        connection = Database.connect()
        if not connection:
            return None
        try:
            with connection.cursor() as cursor:
                cursor.execute(query, values)
                result = cursor.fetchall()
            return result
        except Exception as e:
            print(f"Database fetch error: {e}")
            return None
        finally:
            connection.close()

    @staticmethod
    def fetch_one(query, values=None):
        """
        Executes a query that retrieves a single row from the database (SELECT).
        """
        connection = Database.connect()
        if not connection:
            return None
        try:
            with connection.cursor() as cursor:
                cursor.execute(query, values)
                result = cursor.fetchone()
            return result
        except Exception as e:
            print(f"Database fetch error: {e}")
            return None
        finally:
            connection.close()


    @staticmethod
    def create_procedures():
        procedures = [
            ("AddVehicle", Database.ADD_VEHICLE_PROCEDURE),
            ("UpdateVehicleAvailability", Database.UPDATEVEHICLE_AVAILABILITY),
            ("ListAvailableVehicles", Database.LISTAVAILABLE_VEHICLES),
            ("RegisterCustomer",Database.REGISTERCUSTOMER),
            ("AssignVehicle", Database.ASSIGN_VEHICLE_PROCEDURE),
            ("CustomerRentalHistory", Database.CUSTOMER_RENTAL_HISTORY),
            ("ScheduleMaintenance", Database.SCHEDULE_MAINTENANCE_PROCEDURE),
            ("AssignEmployeeToOffice", Database.ASSIGN_EMPLOYEE_TO_OFFICE_PROCEDURE),
            ("ListCustomerFeedback", Database.LIST_CUSTOMER_FEEDBACK_PROCEDURE),
            ("AddRentalOffice", Database.ADD_RENTAL_OFFICE_PROCEDURE),
            ("ListAllVehicles", Database.LIST_ALL_VEHICLES_PROCEDURE),
            ("RecordVehicleMaintenance", Database.RECORD_VEHICLE_MAINTENANCE),
            ("AddPaymentMethod", Database.ADD_PAYMENT_METHOD_PROCEDURE),
            ("GenerateInvoice", Database.GENERATE_INVOICE_PROCEDURE),
            ("UpdateCustomerContact", Database.UPDATECONTRACT),
            ("AddRentalOffice", Database.ADD_RENTAL_OFFICE_PROCEDURE)
        ]

        connection = Database.connect()
        if not connection:
            print("Failed to connect to database")
            return False
        try:
            with connection.cursor() as cursor:
                for proc_name, proc_body in procedures:
                    
                    cursor.execute("SHOW PROCEDURE STATUS WHERE Name = %s", (proc_name,))
                    exists = cursor.fetchone() is not None

                    if exists:
                        print(f"Dropping existing procedure: {proc_name}")
                        try:
                            cursor.execute(f"DROP PROCEDURE {proc_name}")
                        except pymysql.Error as drop_error:
                            print(f"Error dropping procedure {proc_name}: {drop_error}")
                            return False

                   
                    print(f"Creating procedure: {proc_name}")
                    try:
                        cursor.execute(proc_body)
                    except pymysql.Error as create_error:
                        print(f"Error creating procedure {proc_name}: {create_error}")
                        return False

            connection.commit()
        except pymysql.Error as e:
            print(f"General error during procedure creation: {e}")
            return False

        print("Successfully updated/created stored procedures.")
        return True


   
    ADD_VEHICLE_PROCEDURE = """
    CREATE PROCEDURE AddVehicle(
        IN vehicleID VARCHAR(10),
        IN vehicleInfo VARCHAR(10),
        IN vehicleCondition VARCHAR(10),
        IN bookingInfoID VARCHAR(10), 
        IN availabilityStatus TINYINT, 
        IN rentalOfficeID VARCHAR(10),
        IN assignedServiceCenterID VARCHAR(10),
        IN assignedCustomerID VARCHAR(10),
        IN assignedFrontDeskEmployeeID VARCHAR(10),
        IN assignedTechnicianID VARCHAR(10),
        IN maintenanceSchedule VARCHAR(10)
    )
    BEGIN
        -- Insert into Vehicle table directly
        INSERT INTO Vehicle (idVehicle, `Vehicle Information`, `Vehicle condition`, `Booking infomaiton ID`, `Availability Status`, `RentalOfficeID`, `Assigned Service Center ID`, `Assigned customer ID`, `Assigned front desk employee ID`, `assgined technician ID`, `maintenance schedule`)
        VALUES (vehicleID, vehicleInfo, vehicleCondition, bookingInfoID, availabilityStatus, rentalOfficeID, assignedServiceCenterID, assignedCustomerID, assignedFrontDeskEmployeeID, assignedTechnicianID, maintenanceSchedule);
    END;
    """

    RECORD_VEHICLE_MAINTENANCE="""
    CREATE PROCEDURE RecordVehicleMaintenance(
        IN maintenance_id VARCHAR(10)
    )
    BEGIN
        UPDATE `Maintenance Request`  
        SET status = 'completed'
        WHERE `idMaintenance Request` = maintenance_id 
          AND (status = 'pending' OR status = 'in progress'); 
    END
    """

    ADD_RENTAL_OFFICE_PROCEDURE = """
    

    CREATE PROCEDURE AddRentalOffice(
        IN officeID VARCHAR(10),
        IN address VARCHAR(255),
        IN name VARCHAR(45)
    )
    BEGIN
        INSERT INTO `RentalOffice` (`RentalOffice ID`, address, name)
        VALUES (officeID, address, name);
    END
    """

    LIST_ALL_VEHICLES_PROCEDURE = """
   
    CREATE PROCEDURE ListAllVehicles()
  BEGIN
    SELECT 
        v.idVehicle,
        vi.Manufacturer,  
        vi.Model,          
        vi.Year,
        vi.Tier,
        v.`Availability Status`,  
        vt.type AS VehicleType  
    FROM Vehicle v
    JOIN VehicleInfo vi ON v.`Vehicle Information` = vi.`idVehicle Information`
    JOIN VehicleType vt ON vi.`VehicleTypeID` = vt.`idVehicle type`
    ORDER BY vi.Manufacturer, vi.Model;
  END
    """

    SCHEDULE_MAINTENANCE_PROCEDURE = """

CREATE PROCEDURE ScheduleMaintenance(
    IN maintenanceID VARCHAR(10),
    IN vehicleID VARCHAR(10),
    IN serviceCenterID VARCHAR(10),
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    INSERT INTO `MaintenanceSchedule` (`idMaintenance Schedule`, VehicleID, `Service Center ID`, StartDate, EndDate) -- Use the correct column names
    VALUES (maintenanceID, vehicleID, serviceCenterID, startDate, endDate);

    SELECT m.`idMaintenance Schedule` AS MaintenanceID, m.StartDate, m.EndDate, s.name AS ServiceCenter  -- Use the correct column names
    FROM `MaintenanceSchedule` m
    JOIN `Service Center` s ON m.`Service Center ID` = s.`Service Center ID`
    WHERE m.`idMaintenance Schedule` = maintenanceID; 
END
    """

    ASSIGN_EMPLOYEE_TO_OFFICE_PROCEDURE = """
  CREATE PROCEDURE AssignEmployeeToOffice(
    IN employeeID VARCHAR(10),
    IN officeID VARCHAR(10)
)
BEGIN
    UPDATE `Employee`
    SET workplace = officeID
    WHERE `Employee ID` = employeeID;

    SELECT e.`Employee ID`, e.name, r.name AS RentalOffice 
    FROM `Employee` e
    JOIN `Rental Office` r ON e.workplace = r.`Rental Office ID` -- Corrected join condition
    WHERE e.`Employee ID` = employeeID;
END
    """



        
    LIST_CUSTOMER_FEEDBACK_PROCEDURE = """

   CREATE PROCEDURE ListCustomerFeedback()
BEGIN
    SELECT 
        f.idFeedback,
        f.`Rental Session ID`,
        f.Rating,
        f.`Date Submitted`,
        f.Comments,
        f.`processed by`,
        f.`submitted by`
    FROM Feedback f
    ORDER BY f.`Date Submitted` DESC;
END
    """
    
   
    UPDATEVEHICLE_AVAILABILITY= """
    CREATE PROCEDURE UpdateVehicleAvailability (
        IN vehicle_id VARCHAR(50),
        IN new_status tinyint
    )
    BEGIN
        UPDATE Vehicle  -- Use the correct table name
        SET `Availability Status` = new_status  
        WHERE idVehicle = vehicle_id;
    END
    """
    LISTAVAILABLE_VEHICLES="""
      CREATE PROCEDURE ListAvailableVehicles()
    BEGIN
        SELECT 
            V.idVehicle AS VehicleID, 
            VI.Manufacturer, 
            VI.Model, 
            VI.Year, 
            VI.Tier,
            VT.type AS VehicleType,
            VC.Miles AS VehicleMiles, 
            VC.Wear AS VehicleWear, 
            V.`Availability Status` AS AvailabilityStatus
        FROM 
            RentalCarSystemDB.Vehicle V
            JOIN RentalCarSystemDB.`VehicleInfo` VI ON V.`Vehicle Information` = VI.`idVehicle Information`
            JOIN RentalCarSystemDB.`VehicleType` VT ON VI.VehicleTypeID = VT.`idVehicle type`
            JOIN RentalCarSystemDB.`VehicleCondition` VC ON V.`Vehicle condition` = VC.`idVehicle Conditions`
        WHERE 
            V.`Availability Status` = 1;
    END 
    """



    CUSTOMER_RENTAL_HISTORY="""
    CREATE PROCEDURE CustomerRentalHistory(IN customer_id VARCHAR(10))
    BEGIN
        SELECT 
            bi.`idBooking Information` AS BookingID,
            v.idVehicle AS VehicleID,
            vi.Manufacturer,
            vi.Model,
            bi.`Start time` AS StartTime,
            bi.`End time` AS EndTime,
            ro.name AS RentalOffice
        FROM `Booking Information` bi
        JOIN Vehicle v ON bi.`Vehicle ID` = v.idVehicle
        JOIN VehicleInfo vi ON v.`Vehicle Information` = vi.`idVehicle Information`
        JOIN RentalOffice ro ON bi.`Rental Office ID` = ro.`RentalOffice ID`
        WHERE bi.`customer ID` = customer_id;
    END
    """
    
    ASSIGN_VEHICLE_PROCEDURE="""

 CREATE PROCEDURE AssignVehicle(
    IN bookingID VARCHAR(10),
    IN requestID VARCHAR(10),
    IN customerID VARCHAR(10),
    IN preferredVehicle VARCHAR(10),
    IN PickupTime DATETIME,
    IN ReturnTime DATETIME,
    IN PickupAt VARCHAR(45),
    IN ReturnAt VARCHAR(45),
    IN Status VARCHAR(10),
    IN DateSubmitted DATE,
    IN frontID VARCHAR(10)
)
BEGIN
    DECLARE approvedVehicle VARCHAR(10) DEFAULT NULL;

    START TRANSACTION;
   
    SELECT idVehicle INTO approvedVehicle
    FROM Vehicle 
    WHERE idVehicle = preferredVehicle AND `Availability Status` = 1 
    FOR UPDATE; 

    
    UPDATE `Vehicle` 
    SET `Assigned customer ID` = customerID,
        `Assigned front desk employee ID` = frontID, 
        `Availability Status` = 0
    WHERE `idVehicle` = preferredVehicle; 

  
    IF approvedVehicle IS NOT NULL THEN
        -- Update the rental car request with the approved vehicle
        UPDATE `Rental Car Request`
        SET `approved vehicle` = approvedVehicle, Status = 'Approved'
        WHERE `Request ID` = requestID;

       
        INSERT INTO `Booking Information` (
            `idBooking Information`, `customer ID`, `Vehicle ID`, `Rental Office ID`,
            `Start time`, `End time`, `assigned front desk employee`
        )
        VALUES (
            bookingID, customerID, approvedVehicle, PickupAt,
            PickupTime, ReturnTime, frontID
        );
    ELSE
       
        UPDATE `Rental Car Request`
        SET Status = 'Denied'
        WHERE `Request ID` = requestID;
    END IF;

    COMMIT; 
END


"""

    ADD_PAYMENT_METHOD_PROCEDURE="""
    CREATE PROCEDURE addPaymentMethod(
    IN payment_method_id VARCHAR(10),
    IN method_type VARCHAR(10),
    IN account_holder VARCHAR(45),
    IN account_number BIGINT,
    IN expiration_date DATE,
    IN security_code INT,
    IN billing_address VARCHAR(45),
    IN bank_name VARCHAR(45)
)
BEGIN
    INSERT INTO `Payment Method` (
        `idPayment Method`, `methodType`, `AccountHolder`,
        `Account Number`, `Expiration Date`, `Security Code`,
        `Billing Address`, `Bank Name`
    ) VALUES (
        payment_method_id, method_type, account_holder,
        account_number, expiration_date, security_code,
        billing_address, bank_name
    );
END """

    REGISTERCUSTOMER="""
CREATE PROCEDURE RegisterCustomer(
    IN customer_id VARCHAR(10),
    IN email VARCHAR(45),
    IN password VARCHAR(45),
    IN name VARCHAR(45),
    IN account_type VARCHAR(45), 
    IN account_status TINYINT,
    IN payment_method_id VARCHAR(10),
    IN method_type VARCHAR(10),
    IN account_holder VARCHAR(45),
    IN account_number BIGINT,
    IN expiration_date DATE,
    IN security_code INT,
    IN billing_address VARCHAR(45),
    IN bank_name VARCHAR(45),
    IN address VARCHAR(45)
)
BEGIN

    INSERT INTO User (UserID, email, password, name)
    VALUES (customer_id, email, password, name);

    INSERT INTO Account (UserID, account_type, account_status)
    VALUES (customer_id, account_type, account_status);

    INSERT INTO `Payment Method` (
        `idPayment Method`, `methodType`, `AccountHolder`,
        `Account Number`, `Expiration Date`, `Security Code`,
        `Billing Address`, `Bank Name`
    ) VALUES (
        payment_method_id, method_type, account_holder,
        account_number, expiration_date, security_code,
        billing_address, bank_name
    );


    INSERT INTO customer (
        `customer id`, payment_method, address
    ) VALUES (
        customer_id, payment_method_id, address
    );
END """

    SCHEDULE_MAINTENANCE_PROCEDURE="""
CREATE PROCEDURE ScheduleMaintenance(
    IN vehicleID VARCHAR(10),
    IN schedule_id VARCHAR(10),
    IN service_center_id VARCHAR(10),
    IN start_date DATETIME,
    IN end_date DATETIME
)
BEGIN
    INSERT INTO `Maintenance Schedule` (
        `idMaintenance Schedule`, `Service Center ID`, `Start Date`, `End Date`
    ) VALUES (
        schedule_id, service_center_id, start_date, end_date
    );
    UPDATE Vehicle
    SET `maintenance schedule` = schedule_id
    WHERE `idVehicle` = vehicleID;
    
END 
"""
    
    ASSIGN_EMPLOYEE_TO_OFFICE_PROCEDURE="""
CREATE PROCEDURE AssignEmployeeToOffice(
    IN employee_id VARCHAR(10),
    IN office_id VARCHAR(10)
)
BEGIN
    UPDATE Employee
    SET workplace = office_id
    WHERE `Employee ID` = employee_id;
END """

    UPDATECONTRACT="""
    
    CREATE PROCEDURE UpdateCustomerContact(
        IN customer_id VARCHAR(10),
        IN email VARCHAR(45),
        IN address VARCHAR(45)
    )
    BEGIN
        
        UPDATE User
        SET email = email
        WHERE UserID = customer_id;

        UPDATE customer
        SET address = address
        WHERE `customer id` = customer_id;
    END
"""

    GENERATE_INVOICE_PROCEDURE="""
     CREATE PROCEDURE GenerateInvoice(
    IN paymentID VARCHAR(10),
    IN transactionType VARCHAR(45),   
    IN amount VARCHAR(45),
    IN payment_date DATE,
    IN payment_method VARCHAR(10),   
    IN customer_id VARCHAR(10),
    IN back_end_employee_id VARCHAR(10)
)
BEGIN
    
    DECLARE existingPaymentMethod VARCHAR(10) DEFAULT NULL;

    SELECT payment_method INTO existingPaymentMethod
    FROM customer
    WHERE `customer id` = customer_id;

    IF existingPaymentMethod = payment_method THEN
        
        INSERT INTO `Transaction` (
            paymentid,
            transaction,
            Amount,
            `Date`,
            `Payment method`,
            customer_id,
            back_end_employee_id
        ) VALUES (
            paymentID,
            transactionType,
            amount,
            payment_date,
            payment_method,
            customer_id,
            back_end_employee_id
        );
    ELSE
        SIGNAL SQLSTATE '45000'   
        SET MESSAGE_TEXT = 'Payment method does not match the customer''s registered payment method.';
    END IF;
END
"""


