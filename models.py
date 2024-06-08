import pymysql
from database import Database
from datetime import datetime

class Vehicle:
    def __init__(self, vehicleID=None,vehicleInfo=None, manufacturer=None, model=None, year=None, vehicleType=None,tier=None, miles=None,wear=None, rentalOfficeID=None, availabilityStatus=None,vehicleTypeID=None,vehicleTypeDescription=None,conditionID=None):
        self.vehicleID = vehicleID
        self.vehicleInfo = vehicleInfo
        self.manufacturer = manufacturer
        self.model = model
        self.year = year
        self.miles=miles
        self.tier=tier
        self.wear=wear
        self.vehicleType = vehicleType
        self.rentalOfficeID = rentalOfficeID
        self.availabilityStatus = availabilityStatus
        self.vehicleTypeID=vehicleTypeID
        self.vehicleTypeDescription=vehicleTypeDescription
        self.conditionID=conditionID
       
    def add_vehicle(self):
       
        vehicle_type_exists = self._check_vechicle_type_exists()
        print("checking vehicle type exsits")
        if not vehicle_type_exists:
            print("vehicle type does not exsit")
            self.vehicleTypeID = self._generate_new_vechicle_type_id()
            query_condition = """
            INSERT INTO VehicleType (`idVehicle type`,type, description)
            VALUES (%s, %s, %s);
            """
            values_condition = (self.vehicleTypeID,self.vehicleType,self.vehicleTypeDescription) 
            if not Database.execute(query_condition, values_condition):
                print("Failed to insert VehicleType")
                return False 
            print("successfuly insert VehicleType")
            
        else:
            print("vehicle type exsits")
          
            self.vehicleTypeID= self.get_vehicle_type_id() 
            
            print(f"vehicle type id {self.vehicleTypeID}")
        vehicle_info_exists = self._check_vehicle_info_exists()
        print(f"vehicle info id {self.vehicleTypeID}")
        
        print("checking vehicle info exsits")
        if not vehicle_info_exists:
                print("vehicle info does not exsit")
                self.vehicleInfo = self._generate_new_vehicle_info_id()
                query_condition = """
                INSERT INTO VehicleInfo (
                `idVehicle Information`, 
                Manufacturer, 
                Model,
                `Year`,
                Tier, 
                VehicleTypeID) 
                VALUES (%s, %s, %s, %s, %s, %s);
                """
                values_condition = (
                    self.vehicleInfo, 
                    self.manufacturer, 
                    self.model, 
                    self.year, 
                    self.tier, 
                    self.vehicleTypeID  
                )                
                print(f"inserting: {self.vehicleInfo}+{self.manufacturer}+{self.model}+{self.year}+{self.vehicleTypeID}")
                if not Database.execute(query_condition, values_condition):
                    print("Failed to insert VehicleInfo")
                    return False  
                print("sucessfuly to insert VehicleInfo")
                print(f"vehicle info id {self.vehicleInfo}")
        else:
            print("vehicle info exsits")
            self.vehicleInfo= self.get_vehicle_info_id()
            print(f"vehicle info id {self.vehicleInfo}")
            
       
        condition_exists = self._check_vehicle_condition_exists()
        if not condition_exists:
            self.conditionID=self._generate_new_conditions_id()
            print("Inserting new vehicle condition")
            query_condition = """
            INSERT INTO VehicleCondition (`idVehicle Conditions`, Miles, Wear)
            VALUES (%s, %s, %s);
            """
            values_condition = (self.conditionID,  self.miles, self.wear) 
            if not Database.execute(query_condition, values_condition):
                print("Failed to insert vehicle condition")
                return False  
        else:
            print("vehicle condition exsits")
            self.conditionID= self.get_vehicle_condition_id()
            print(f"vehicle condition id {self.conditionID}")
        
        self.availabilityStatus=1
        
        print("Inserting vehicle into main table")
        self.vehicleID=self._generate_new_vechicle_id()
        print(f"Vehicle id: {self.vehicleID}") 
        print(f"Vehicle concdition id: {self.conditionID}") 
        print(f"Vehicle info id: {self.vehicleInfo}") 
        query = """
        CALL AddVehicle(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)  
        """
        values = (
            self.vehicleID, 
            self.vehicleInfo,
            self.conditionID, 
            None,  
            self.availabilityStatus, 
            None, 
            None, 
            None, 
            None, 
            None, 
            None
        )
        print(f"Inserting {values}")
       
        return Database.execute(query, values)
        

    
    def get_vehicle_type_id(self):
        """Fetches or creates a VehicleType ID."""
        try:
           
            with Database.connect() as connection:
                with connection.cursor() as cursor:
                    query_check = """
                    SELECT `idVehicle type` 
                    FROM VehicleType
                    WHERE `type` = %s;
                    """
                    values_check = (self.vehicleType,)
                    cursor.execute(query_check, values_check)
                    result = cursor.fetchone()

                    if result:
                        return result['idVehicle type'] 
                    else:
                       
                        query_insert = """
                        INSERT INTO VehicleType (`type`) 
                        VALUES (%s) 
                        RETURNING `idVehicle type`;
                        """
                        cursor.execute(query_insert, values_check)
                        connection.commit()
                        new_id = cursor.fetchone()
                        return new_id['idVehicle type']
        except Exception as e:
            print(f"An error occurred: {e}")

            
    def get_vehicle_condition_id(self):  
        """Fetches the existing VehicleCondition ID if it matches the miles and wear, or returns None."""
        print("Getting existing ID for condition")
        try:
            with Database.connect() as connection:
                with connection.cursor() as cursor:
                    query_check = """
                    SELECT `idVehicle Conditions`  
                    FROM VehicleCondition
                    WHERE Miles = %s AND Wear = %s
                    """
                    values_check = (self.miles, self.wear) 
                    cursor.execute(query_check, values_check)
                    result = cursor.fetchone()

                    if result:
                        return result['idVehicle Conditions']  
        except pymysql.Error as e:
            print(f"Database error in get_vehicle_condition_id: {e}")
            return None  

    def get_vehicle_info_id(self):
        """Fetches or creates a VehicleInfo ID."""
        try:
           
            with Database.connect() as connection:
                with connection.cursor() as cursor:
                    query_check = """
                    SELECT `idVehicle Information`
                    FROM VehicleInfo
                    WHERE `Manufacturer` = %s AND `Model` = %s AND `Year` = %s AND `Tier` = %s
                    """
                    values_check = (self.manufacturer, self.model, self.year, self.tier) 
                    cursor.execute(query_check, values_check)
                    result = cursor.fetchone()

                    if result:
                        return result['idVehicle Information']  
                    else:
                       
                        query_insert = """
                        INSERT INTO VehicleInfo (`Manufacturer`, `Model`, `Year`, `Tier`)
                        VALUES (%s, %s, %s, %s)
                        RETURNING `idVehicle Information`;
                        """
                        cursor.execute(query_insert, values_check)
                        connection.commit()
                        new_id = cursor.fetchone()
                        return new_id['idVehicle Information']
        except pymysql.Error as e:
            print(f"Database error in get_vehicle_info_id: {e}")
            
            return None  

    

    def _check_vechicle_type_exists(self):
        """Fetches or creates a VehicleType ID."""
        try:
          
            with Database.connect() as connection:
                with connection.cursor() as cursor:
                    query_check = """
                    SELECT COUNT(*) as count
                    FROM VehicleType
                    WHERE type = %s AND description = %s;
                    """
                    values_check = (
                        self.vehicleType, self.vehicleTypeDescription
                    )
                    cursor.execute(query_check, values_check)
                    result = cursor.fetchone()
    
                    if result is None:
                        print("Did not find existing VehicleType")
                        return False  
                    print("Found existing VehicleType")
                    return result["count"] > 0  
    
        except pymysql.Error as e:
            print(f"Database error in _check_vehicle_info_exists: {e}")
            return False 


    
    def _check_vehicle_info_exists(self):
         
        try:
            
            with Database.connect() as connection:
                with connection.cursor() as cursor:
                    query_check = """
                    SELECT COUNT(*) as count
                    FROM VehicleInfo
                    WHERE Manufacturer = %s AND Model = %s AND Year = %s AND Tier = %s AND VehicleTypeID = %s;
                    """
                    values_check = (
                        self.manufacturer, self.model, self.year, self.tier, self.vehicleTypeID
                    )
                    cursor.execute(query_check, values_check)
                    result = cursor.fetchone()

                    if result is None:
                        print("Did not find existing vehicle info")
                        return False 
                    print("Found existing vehicle info")
                    return result["count"] > 0  
                    
        except pymysql.Error as e:
            print(f"Database error in _check_vehicle_info_exists: {e}")
            return False 
    

    def _check_vehicle_condition_exists(self):
        query = """
        SELECT COUNT(*) as count
        FROM VehicleCondition
        WHERE Miles = %s AND Wear = %s;
        """
        values = (self.miles, self.wear)
        result = Database.fetch_one(query, values)
        return result["count"] > 0

    def _generate_new_vehicle_info_id(self):
        query = """
        SELECT COUNT(*) as count FROM VehicleInfo;
        """
        result = Database.fetch_one(query)
        print(f"last vehicle info id : {result}")
        if result is None:
            print("No existing vehicle info found")
            return "info1"  

        return f"info{result['count'] + 1}"  
        
    def _generate_new_conditions_id(self):
        print("counting conditions")
        query = """
        SELECT COUNT(*) as count FROM VehicleCondition;
        """
        result = Database.fetch_one(query)
        print(f"last VehicleCondition id : {result}")
        if result is None:
            print("No existing VehicleCondition found")
            return "con1"  
        return f"con{result['count'] + 1}" 


    def _generate_new_vechicle_type_id(self):
        query = """
            SELECT COUNT(*) as count FROM VehicleType;
            """
        result = Database.fetch_one(query)
        print(f"last VehicleType id : {result}")
        if result is None:
            print("No existing VehicleType found")
            return "type1"  
        return f"type{result['count'] + 1}"  
    def _generate_new_vechicle_id(self):
        query = """
            SELECT COUNT(*) as count FROM Vehicle;
            """
        result = Database.fetch_one(query)
        print(f"last Vehicle id : {result}")
        if result is None:
            print("No existing Vehicle found")
            return "Vehicle1"  
        return f"Vehicle{result['count'] + 1}"  
        
    def update_availability(self):
        query = """
        CALL UpdateVehicleAvailability(%s, %s)
        """
        values = (self.vehicleID, self.availabilityStatus)
        return Database.execute(query, values)

    @staticmethod
    def get_available_vehicles() -> list:
        """Fetches available vehicles and their details."""

        with Database.connect() as connection:
            with connection.cursor() as cursor:
                cursor.callproc('ListAvailableVehicles')
                result = cursor.fetchall()

        vehicles = [
            Vehicle(
                vehicleID=row['VehicleID'],
                manufacturer=row['Manufacturer'],
                model=row['Model'],
                year=row['Year'],
                vehicleType=row['VehicleType'],
                tier=row['Tier']
            )
            for row in result
        ]
        return vehicles
    @staticmethod
    def list_all_vehicle():
        with Database.connect() as connection:
            with connection.cursor() as cursor:
                cursor.callproc('ListAllVehicles')
                result = cursor.fetchall()
        print(result)
        vehicles = [
            Vehicle(
                vehicleID=row['idVehicle'],
                manufacturer=row['Manufacturer'],
                model=row['Model'],
                year=row['Year'],
                vehicleType=row['VehicleType'],
                tier=row['Tier'],
                availabilityStatus=row['Availability Status']
            )
            for row in result
        ]
        return vehicles


class Customer:
    def __init__(self, 
         customerID=None, 
         email=None, 
         password=None, 
         name=None, 
         account_type="Customer",
         account_status=1,
         payment_method_id=None, 
         method_type=None, 
         account_holder=None,
         account_number=None, 
         expiration_date=None, 
         security_code=None,
         billing_address=None, 
         bank_name=None, 
         address=None):

        self.customerID = customerID
        self.email = email
        self.password = password
        self.name = name
        self.account_type = account_type
        self.account_status = account_status
        self.payment_method_id = payment_method_id
        self.method_type = method_type
        self.account_holder = account_holder
        self.account_number = account_number
        self.expiration_date = expiration_date
        self.security_code = security_code
        self.billing_address = billing_address
        self.bank_name = bank_name
        self.address = address

    def register(self):
        customer_exists = self._check_Customer_exists()
        if not  customer_exists:
            self.customerID=self._generate_new_Customer_id()
            self.payment_method_id=self._generate_new_payment_id()
            print("Inserting new vehicle condition")
            query = """
            CALL RegisterCustomer(%s, %s, %s, %s,%s,%s, %s, %s, %s,%s,%s, %s, %s, %s,%s)
            """
            values = (
                self.customerID,
                self.email,
                self.password,
                self.name,
                self.account_type,
                self.account_status,
                self.payment_method_id,
                self.method_type,
                self.account_holder,
                self.account_number,
                self.expiration_date,
                self.security_code,
                self.billing_address,
                self.bank_name,
                self.address
            )
    
            return Database.execute(query, values)
        else:
            exsit="this email is already taken and account already exist!"
            return exsit
    def get_rental_history(self):
        query = """
        CALL CustomerRentalHistory(%s)
        """
        values = (self.customerID)
        return Database.fetch_all(query, values)

    def update_contact(self):
        customerExsits=self._check_Customer_exists()
        if customerExsits:
            query = """
            CALL UpdateCustomerContact(%s, %s, %s)
            """
            values = (self.customerID, self.email,self.address,)
            return Database.execute(query, values)
        return "customer not found"
        
    def _check_Customer_exists(self):
        query = """
        SELECT COUNT(*) as count
        FROM customer
        WHERE `customer id` = %s
        """
        values = (self.customerID) 
        result = Database.fetch_one(query, values)
        if result:
            return result["count"] > 0
        return 

    def _generate_new_Customer_id(self):
        query = """
        SELECT COUNT(*) as count FROM customer;
        """
        result = Database.fetch_one(query)
        print(f"last customer id : {result}")
        if result is None:
            print("No existing customer info found")
            return "customer1"  

        return f"customer{result['count'] + 1}"  
        
    def _generate_new_payment_id(self):
        query = """
        SELECT COUNT(*) as count FROM `Payment Method`;
        """
        result = Database.fetch_one(query)
        print(f"last payment id : {result}")
        if result is None:
            print("No existing payment info found")
            return "payment1"  

        return f"payment{result['count'] + 1}" 


class Maintenance:
    def __init__(self, maintenanceID=None, vehicleID=None,  startDate=None,EndDate=None, serviceCenterID=None, StartDate=None, endDate=None):
        self.maintenanceID = maintenanceID
        self.vehicleID = vehicleID
        self.serviceCenterID = serviceCenterID
        self.StartDate = StartDate
        self.EndDate=EndDate

    def record(self):
        query = """
        CALL RecordVehicleMaintenance(%s)
        """
        values = (self.maintenanceID,)  
        return Database.execute(query, values)

    def schedule(self):
        self.maintenanceID=self._generate_new_maintenance_id()
        query = """
        CALL ScheduleMaintenance(%s, %s, %s, %s, %s)
        """
        values = (self.maintenanceID, self.vehicleID, self.serviceCenterID, self.StartDate, self.EndDate)
        return Database.execute(query, values)
        
    def _generate_new_maintenance_id(self):
        query = """
        SELECT COUNT(*) as count FROM `Maintenance Schedule`;
        """
        result = Database.fetch_one(query)
        print(f"last payment id : {result}")
        if result is None:
            print("No existing payment info found")
            return "sche1"  

        return f"sche{result['count'] + 1}"  


class Rental:
    def __init__(self, requestID=None, customerID=None, preferred_vehicle=None, PickupTime=None, ReturnTime=None, PickupAt=None, ReturnAt=None, status=None, date_submitted=None, front_desk_employee_id=None, bookingID=None):
        self.bookingID=bookingID
        self.requestID = requestID
        self.customerID = customerID
        self.preferred_vehicle = preferred_vehicle
        self.PickupTime = PickupTime
        self.ReturnTime = ReturnTime
        self.PickupAt = PickupAt
        self.ReturnAt = ReturnAt
        self.status = status
        self.date_submitted = datetime.now().date()
        self.front_desk_employee_id = front_desk_employee_id
    def assign(self):

        self.requestID=self._generate_request_id()
        self.bookingID=self._generate_booking_id()
        query = """
        CALL AssignVehicle(%s, %s, %s, %s, %s,%s, %s, %s, %s, %s,%s)
        """
        values = (
            self.bookingID,
            self.requestID,   
            self.customerID,
            self.preferred_vehicle,
            self.PickupTime, 
            self.ReturnTime,
            self.PickupAt,
            self.ReturnAt,
            self.status,
            self.date_submitted,
            self.front_desk_employee_id,
        )
        return Database.execute(query, values)

    def _generate_request_id(self):
        query = """
        SELECT COUNT(*) as count FROM `New Vehicle Request`;
        """
        result = Database.fetch_one(query)
        print(f"last newreq id : {result}")
        if result is None:
            print("No existing newreq info found")
            return "newreq1"  
    
        return f"newreq{result['count'] + 1}"  

    def _generate_booking_id(self):
        query = """
        SELECT COUNT(*) as count FROM `New Vehicle Request`;
        """
        result = Database.fetch_one(query)
        print(f"last booking id : {result}")
        if result is None:
            print("No existing booking info found")
            return "booking1"  
    
        return f"booking{result['count'] + 1}"  

class PaymentMethod:
    def __init__(self, paymentID=None, customerID=None, methodType=None, accountNumber=None, expiration=None,BillingAddress=None,BankName=None,securityCode=None,accountHolder=None):
        self.paymentID = paymentID
        self.accountHolder = accountHolder
        self.methodType = methodType
        self.accountNumber = accountNumber
        self.expiration = expiration
        self.BillingAddress = BillingAddress
        self.BankName =BankName
        self.securityCode=securityCode

        
    def add(self):
        self.paymentID=self._generate_payment_id()
        query = """
        CALL AddPaymentMethod(%s, %s, %s, %s, %s,%s,%s,%s)
        """
        values = (self.paymentID,  self.methodType,self.accountHolder, self.accountNumber, self.expiration,self.securityCode,self.BillingAddress,self.BankName,)
        return Database.execute(query, values)
 
    def _generate_payment_id(self):
        query = """
        SELECT COUNT(*) as count FROM `Payment Method`;
        """
        result = Database.fetch_one(query)
        print(f"last Payment Method id : {result}")
        if result is None:
            print("No existing Payment Method found")
            return "payment1"  
    
        return f"payment{result['count'] + 1}"  

class Invoice:
    def __init__(self, invoiceID=None,description=None, amount=None, payment_date=None,payment_method=None,customer_id=None,back_end_employee_id=None):
        self.invoiceID = invoiceID
        self.description = description
        self.amount = amount
        self.payment_date = payment_date
        self.payment_method=payment_method
        self.customer_id=customer_id
        self.back_end_employee_id=back_end_employee_id
        

    def generate(self):
        self.invoiceID=self._generate_Invoice_id()
        query = """
        CALL GenerateInvoice(%s, %s, %s, %s, %s, %s, %s)
        """
        values = (self.invoiceID, self.description, self.amount, self.payment_date,self.payment_method,self.customer_id,self.back_end_employee_id,)
        return Database.execute(query, values)

    def _generate_Invoice_id(self):
        query = """
        SELECT COUNT(*) as count FROM `Transaction`;
        """
        result = Database.fetch_one(query)
        print(f"last Payment Method id : {result}")
        if result is None:
            print("No existing Payment Method found")
            return "trans1" 

        return f"trans{result['count'] + 1}" 


class RentalOffice:
    def __init__(self, officeID=None, address=None,name=None):
        self.officeID = officeID
        self.address = address
        self.name = name

    def add(self):
        self.officeID=self._generate_Office_id()
        query = """
        CALL AddRentalOffice(%s, %s, %s)
        """
        values = (self.officeID, self.address, self.name,)
        return Database.execute(query, values)
    def _generate_Office_id(self):
        query = """
        SELECT COUNT(*) as count FROM `RentalOffice`;
        """
        result = Database.fetch_one(query)
        print(f"last office id : {result}")
        if result is None:
            print("No existing Payment Method found")
            return "office1"  
    
        return f"office{result['count'] + 1}"  

class Feedback:
    def __init__(self,feedBackID=None,sessionID=None,rating=None,date=None,comments=None,processedBy=None,submittedBy=None):
        self.feedBackID = feedBackID
        self.sessionID = sessionID
        self.rating = rating
        self.date = date
        self.comments = comments
        self.processedBy = processedBy
        self.submittedBy = submittedBy
        
    @staticmethod
    def get_all_feedback():
        query = """
        CALL ListCustomerFeedback()
        """
        return Database.fetch_all(query)
        
class Employee:
    def __init__(self, officeID=None, employeeID=None, payroll=None):
        self.officeID = officeID
        self.employeeID = employeeID
        self.payroll = payroll
        
    def assign_to_office(self):
        """Assigns the employee to a rental office and returns the result with optional error details."""

        query = """
        CALL AssignEmployeeToOffice(%s, %s)
        """
        values = (self.employeeID, self.officeID)

        success = Database.execute(query, values)
        if not success:
            return False, "Failed to assign employee to office."

       
        with Database.connect() as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT workplace FROM Employee WHERE `Employee ID` = %s", (self.employeeID,))
                result = cursor.fetchone()

                if result is None:  
                    return False, "Employee not found."
                elif result["workplace"] != self.officeID:  
                    return False, "Failed to update employee's workplace in the database."

        return True, None
        
    

