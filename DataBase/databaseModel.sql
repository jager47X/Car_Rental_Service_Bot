-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema RentalCarSystemDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema RentalCarSystemDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `RentalCarSystemDB` DEFAULT CHARACTER SET utf8mb3 ;
USE `RentalCarSystemDB` ;

-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`User` (
  `UserID` VARCHAR(10) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `UserID_UNIQUE` (`UserID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Account` (
  `UserID` VARCHAR(10) NOT NULL,
  `account_type` VARCHAR(45) NOT NULL,
  `account_status` TINYINT NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `UserID_UNIQUE` (`UserID` ASC) VISIBLE,
  CONSTRAINT `UserID`
    FOREIGN KEY (`UserID`)
    REFERENCES `RentalCarSystemDB`.`User` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`VehicleType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`VehicleType` (
  `idVehicle type` VARCHAR(10) NOT NULL,
  `type` VARCHAR(10) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idVehicle type`),
  UNIQUE INDEX `idVehecle type_UNIQUE` (`idVehicle type` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Service Center`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Service Center` (
  `Service Center ID` VARCHAR(10) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `specialized vehicle type` VARCHAR(10) NULL DEFAULT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Service Center ID`),
  INDEX `FK_specialized vehicle type_idx` (`specialized vehicle type` ASC) VISIBLE,
  CONSTRAINT `FK_specialized vehicle type`
    FOREIGN KEY (`specialized vehicle type`)
    REFERENCES `RentalCarSystemDB`.`VehicleType` (`idVehicle type`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Auto Parts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Auto Parts` (
  `idAuto Parts` VARCHAR(10) NOT NULL,
  `Part Name` VARCHAR(45) NOT NULL,
  `Manufacturer` VARCHAR(45) NOT NULL,
  `Model` VARCHAR(45) NOT NULL,
  `Quantity in Stock` INT NOT NULL,
  `Price` INT NOT NULL,
  `Date Added` TIMESTAMP NOT NULL,
  `assinged service center` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`idAuto Parts`),
  INDEX `FK_service_cetner_ap_idx` (`assinged service center` ASC) VISIBLE,
  CONSTRAINT `FK_service_cetner_ap`
    FOREIGN KEY (`assinged service center`)
    REFERENCES `RentalCarSystemDB`.`Service Center` (`Service Center ID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Payroll`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Payroll` (
  `idPayroll` VARCHAR(10) NOT NULL,
  `Processing Date` VARCHAR(45) NOT NULL,
  `Total Amount` INT NOT NULL,
  PRIMARY KEY (`idPayroll`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Employee` (
  `Employee ID` VARCHAR(10) NOT NULL,
  `payroll` VARCHAR(10) NOT NULL,
  `workplace` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Employee ID`),
  UNIQUE INDEX `Employee ID_UNIQUE` (`Employee ID` ASC) VISIBLE,
  INDEX `FK_payroll_idx` (`payroll` ASC) VISIBLE,
  CONSTRAINT `FK_payroll`
    FOREIGN KEY (`payroll`)
    REFERENCES `RentalCarSystemDB`.`Payroll` (`idPayroll`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_userID`
    FOREIGN KEY (`Employee ID`)
    REFERENCES `RentalCarSystemDB`.`Account` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Back Desk Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Back Desk Employee` (
  `idBack Desk Employee` VARCHAR(10) NOT NULL,
  `avairability` TINYINT NOT NULL,
  `processed maintenance request` INT NULL DEFAULT NULL,
  `processed new vehicle request` INT NULL DEFAULT NULL,
  `processed feedbacks` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idBack Desk Employee`),
  UNIQUE INDEX `idBack Desk Employee_UNIQUE` (`idBack Desk Employee` ASC) VISIBLE,
  CONSTRAINT `employee_id_backdesk`
    FOREIGN KEY (`idBack Desk Employee`)
    REFERENCES `RentalCarSystemDB`.`Employee` (`Employee ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Payment Method`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Payment Method` (
  `idPayment Method` VARCHAR(10) NOT NULL,
  `methodType` VARCHAR(10) NOT NULL,
  `AccountHolder` VARCHAR(45) NOT NULL,
  `Account Number` BIGINT NOT NULL,
  `Expiration Date` DATE NOT NULL,
  `Security Code` INT NOT NULL,
  `Billing Address` VARCHAR(45) NOT NULL,
  `Bank Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPayment Method`),
  UNIQUE INDEX `idPayment Method_UNIQUE` (`idPayment Method` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`customer` (
  `customer id` VARCHAR(10) NOT NULL,
  `payment_method` VARCHAR(10) NOT NULL,
  `address` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`customer id`),
  UNIQUE INDEX `customer id_UNIQUE` (`customer id` ASC) VISIBLE,
  INDEX `FK_payment_method_idx` (`payment_method` ASC) VISIBLE,
  CONSTRAINT `FK_payment_method`
    FOREIGN KEY (`payment_method`)
    REFERENCES `RentalCarSystemDB`.`Payment Method` (`idPayment Method`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_user_ID`
    FOREIGN KEY (`customer id`)
    REFERENCES `RentalCarSystemDB`.`Account` (`UserID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Front Desk Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Front Desk Employee` (
  `idFront Desk Employee` VARCHAR(10) NOT NULL,
  `availability` TINYINT NOT NULL,
  `processed rental requests` INT NOT NULL,
  PRIMARY KEY (`idFront Desk Employee`),
  UNIQUE INDEX `idFront Desk Employee_UNIQUE` (`idFront Desk Employee` ASC) VISIBLE,
  CONSTRAINT `employee_ID_Front_desk`
    FOREIGN KEY (`idFront Desk Employee`)
    REFERENCES `RentalCarSystemDB`.`Employee` (`Employee ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`RentalOffice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`RentalOffice` (
  `RentalOffice ID` VARCHAR(10) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`RentalOffice ID`),
  UNIQUE INDEX `Rental Office ID_UNIQUE` (`RentalOffice ID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Maintenance Schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Maintenance Schedule` (
  `idMaintenance Schedule` VARCHAR(10) NOT NULL,
  `Service Center ID` VARCHAR(45) NOT NULL,
  `Start Date` DATETIME NOT NULL,
  `End Date` DATETIME NOT NULL,
  PRIMARY KEY (`idMaintenance Schedule`),
  INDEX `service center_ms` (`Service Center ID` ASC) VISIBLE,
  CONSTRAINT `service center_ms`
    FOREIGN KEY (`Service Center ID`)
    REFERENCES `RentalCarSystemDB`.`Service Center` (`Service Center ID`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Technician`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Technician` (
  `Technician ID` VARCHAR(10) NOT NULL,
  `specialized vehicle type` VARCHAR(10) NULL DEFAULT NULL,
  `availability` TINYINT NOT NULL,
  PRIMARY KEY (`Technician ID`),
  UNIQUE INDEX `Technician ID_UNIQUE` (`Technician ID` ASC) VISIBLE,
  INDEX `FK_spType_idx` (`specialized vehicle type` ASC) VISIBLE,
  CONSTRAINT `employee_id_tech`
    FOREIGN KEY (`Technician ID`)
    REFERENCES `RentalCarSystemDB`.`Employee` (`Employee ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_spType`
    FOREIGN KEY (`specialized vehicle type`)
    REFERENCES `RentalCarSystemDB`.`VehicleType` (`idVehicle type`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`VehicleCondition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`VehicleCondition` (
  `idVehicle Conditions` VARCHAR(10) NOT NULL,
  `Miles` VARCHAR(45) NOT NULL,
  `Wear` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idVehicle Conditions`),
  UNIQUE INDEX `idVehicle Conditions_UNIQUE` (`idVehicle Conditions` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`VehicleInfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`VehicleInfo` (
  `idVehicle Information` VARCHAR(10) NOT NULL,
  `Manufacturer` VARCHAR(45) NOT NULL,
  `Model` VARCHAR(45) NOT NULL,
  `Year` VARCHAR(45) NOT NULL,
  `Tier` INT NOT NULL,
  `VehicleTypeID` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idVehicle Information`),
  UNIQUE INDEX `idVehicle Information_UNIQUE` (`idVehicle Information` ASC) VISIBLE,
  INDEX `vehicle_type_idx` (`VehicleTypeID` ASC) VISIBLE,
  CONSTRAINT `vehicle_type`
    FOREIGN KEY (`VehicleTypeID`)
    REFERENCES `RentalCarSystemDB`.`VehicleType` (`idVehicle type`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Vehicle` (
  `idVehicle` VARCHAR(10) NOT NULL,
  `Vehicle Information` VARCHAR(10) NOT NULL,
  `Vehicle condition` VARCHAR(10) NOT NULL,
  `Booking infomaiton ID` VARCHAR(10) NULL DEFAULT NULL,
  `Availability Status` TINYINT NOT NULL,
  `RentalOfficeID` VARCHAR(10) NULL DEFAULT NULL,
  `Assigned Service Center ID` VARCHAR(10) NULL DEFAULT NULL,
  `Assigned customer ID` VARCHAR(10) NULL DEFAULT NULL,
  `Assigned front desk employee ID` VARCHAR(10) NULL DEFAULT NULL,
  `assgined technician ID` VARCHAR(10) NULL DEFAULT NULL,
  `maintenance schedule` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`idVehicle`),
  UNIQUE INDEX `idVehicle_UNIQUE` (`idVehicle` ASC) VISIBLE,
  INDEX `UserID_idx` (`Assigned customer ID` ASC) VISIBLE,
  INDEX `Service centerID_idx` (`Assigned Service Center ID` ASC) VISIBLE,
  INDEX `rental office_idx` (`RentalOfficeID` ASC) VISIBLE,
  INDEX `vehicle info_idx` (`Vehicle Information` ASC) VISIBLE,
  INDEX `Vehicle condition_idx` (`Vehicle condition` ASC) INVISIBLE,
  INDEX `FK_front desk employee_idx` (`Assigned front desk employee ID` ASC) VISIBLE,
  INDEX `FK_technician_idx` (`assgined technician ID` ASC) VISIBLE,
  INDEX `FK_maintenance schedule_idx` (`maintenance schedule` ASC) VISIBLE,
  INDEX `FK_booking_infomation_idx` (`Booking infomaiton ID` ASC) VISIBLE,
  CONSTRAINT `customerId_V`
    FOREIGN KEY (`Assigned customer ID`)
    REFERENCES `RentalCarSystemDB`.`customer` (`customer id`)
    ON UPDATE CASCADE,
  CONSTRAINT `FK_booking_infomation`
    FOREIGN KEY (`Booking infomaiton ID`)
    REFERENCES `RentalCarSystemDB`.`Booking Information` (`idBooking Information`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_front desk employee_V`
    FOREIGN KEY (`Assigned front desk employee ID`)
    REFERENCES `RentalCarSystemDB`.`Front Desk Employee` (`idFront Desk Employee`)
    ON UPDATE CASCADE,
  CONSTRAINT `FK_maintenance schedule`
    FOREIGN KEY (`maintenance schedule`)
    REFERENCES `RentalCarSystemDB`.`Maintenance Schedule` (`idMaintenance Schedule`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_technician_V`
    FOREIGN KEY (`assgined technician ID`)
    REFERENCES `RentalCarSystemDB`.`Technician` (`Technician ID`)
    ON UPDATE CASCADE,
  CONSTRAINT `rental office_V`
    FOREIGN KEY (`RentalOfficeID`)
    REFERENCES `RentalCarSystemDB`.`RentalOffice` (`RentalOffice ID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `Service centerID_V`
    FOREIGN KEY (`Assigned Service Center ID`)
    REFERENCES `RentalCarSystemDB`.`Service Center` (`Service Center ID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `Vehicle condition_V`
    FOREIGN KEY (`Vehicle condition`)
    REFERENCES `RentalCarSystemDB`.`VehicleCondition` (`idVehicle Conditions`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `vehicle info_V`
    FOREIGN KEY (`Vehicle Information`)
    REFERENCES `RentalCarSystemDB`.`VehicleInfo` (`idVehicle Information`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Booking Information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Booking Information` (
  `idBooking Information` VARCHAR(10) NOT NULL,
  `customer ID` VARCHAR(10) NULL DEFAULT NULL,
  `Vehicle ID` VARCHAR(10) NULL DEFAULT NULL,
  `Rental Office ID` VARCHAR(10) NOT NULL,
  `Start time` DATETIME NOT NULL,
  `End time` DATETIME NOT NULL,
  `assigned front desk employee` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`idBooking Information`),
  INDEX `Fk_assgined_front_idx` (`assigned front desk employee` ASC) VISIBLE,
  INDEX `customer id_B` (`customer ID` ASC) VISIBLE,
  INDEX `rental office id_B` (`Rental Office ID` ASC) VISIBLE,
  INDEX `vehicle id_B` (`Vehicle ID` ASC) VISIBLE,
  CONSTRAINT `customer id_B`
    FOREIGN KEY (`customer ID`)
    REFERENCES `RentalCarSystemDB`.`customer` (`customer id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `Fk_assgined_front`
    FOREIGN KEY (`assigned front desk employee`)
    REFERENCES `RentalCarSystemDB`.`Front Desk Employee` (`idFront Desk Employee`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `rental office id_B`
    FOREIGN KEY (`Rental Office ID`)
    REFERENCES `RentalCarSystemDB`.`RentalOffice` (`RentalOffice ID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `vehicle id_B`
    FOREIGN KEY (`Vehicle ID`)
    REFERENCES `RentalCarSystemDB`.`Vehicle` (`idVehicle`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Feedback` (
  `idFeedback` VARCHAR(10) NOT NULL,
  `Rental Session ID` VARCHAR(10) NOT NULL,
  `Rating` INT NOT NULL,
  `Date Submitted` DATE NOT NULL,
  `Comments` TEXT NULL DEFAULT NULL,
  `processed by` VARCHAR(10) NOT NULL,
  `submitted by` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idFeedback`),
  INDEX `FK_backdesk_idx` (`processed by` ASC) VISIBLE,
  INDEX `FK_customer_fb_idx` (`submitted by` ASC) VISIBLE,
  INDEX `FK_session_id_idx` (`Rental Session ID` ASC) VISIBLE,
  CONSTRAINT `FK_backdesk_fb`
    FOREIGN KEY (`processed by`)
    REFERENCES `RentalCarSystemDB`.`Back Desk Employee` (`idBack Desk Employee`),
  CONSTRAINT `FK_customer_fb`
    FOREIGN KEY (`submitted by`)
    REFERENCES `RentalCarSystemDB`.`customer` (`customer id`),
  CONSTRAINT `FK_session_id`
    FOREIGN KEY (`Rental Session ID`)
    REFERENCES `RentalCarSystemDB`.`Booking Information` (`idBooking Information`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Maintenance Request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Maintenance Request` (
  `idMaintenance Request` VARCHAR(10) NOT NULL,
  `vehicle id` VARCHAR(10) NOT NULL,
  `Service Centerid` VARCHAR(10) NULL DEFAULT NULL,
  `Request Date` TIMESTAMP NOT NULL,
  `processed by` VARCHAR(10) NOT NULL,
  `Maintenance schedule` VARCHAR(10) NULL DEFAULT NULL,
  `descrption` LONGTEXT NULL DEFAULT NULL,
  `status` VARCHAR(45) NOT NULL,
  `date submitted` DATE NULL DEFAULT NULL,
  `serviced by` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`idMaintenance Request`),
  UNIQUE INDEX `Service Center ID_UNIQUE` (`Service Centerid` ASC) VISIBLE,
  INDEX `FK_backdesk_MR_idx` (`processed by` ASC) VISIBLE,
  INDEX `FK_maintenance_SC_idx` (`Maintenance schedule` ASC) VISIBLE,
  INDEX `FK_tech_idx` (`serviced by` ASC) VISIBLE,
  INDEX `FK_vehicle` (`vehicle id` ASC) VISIBLE,
  CONSTRAINT `FK_backdesk_MR`
    FOREIGN KEY (`processed by`)
    REFERENCES `RentalCarSystemDB`.`Back Desk Employee` (`idBack Desk Employee`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_maintenance_SC`
    FOREIGN KEY (`Maintenance schedule`)
    REFERENCES `RentalCarSystemDB`.`Maintenance Schedule` (`idMaintenance Schedule`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_SC`
    FOREIGN KEY (`Service Centerid`)
    REFERENCES `RentalCarSystemDB`.`Service Center` (`Service Center ID`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `FK_tech`
    FOREIGN KEY (`serviced by`)
    REFERENCES `RentalCarSystemDB`.`Technician` (`Technician ID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_vehicle`
    FOREIGN KEY (`vehicle id`)
    REFERENCES `RentalCarSystemDB`.`Vehicle` (`idVehicle`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`New Vehicle Request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`New Vehicle Request` (
  `idNew Vehicle Request` VARCHAR(10) NOT NULL,
  `Vehicle Category` INT NOT NULL,
  `Preferred Manufacturer` VARCHAR(45) NULL DEFAULT NULL,
  `Preferred Model` VARCHAR(45) NULL DEFAULT NULL,
  `Status` VARCHAR(10) NOT NULL,
  `Date Submitted` DATE NOT NULL,
  `Preferred Year` INT NULL DEFAULT NULL,
  `processed by` VARCHAR(10) NOT NULL,
  `submitted by` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idNew Vehicle Request`),
  UNIQUE INDEX `idNew Vehicle Request_UNIQUE` (`idNew Vehicle Request` ASC) INVISIBLE,
  INDEX `FK_backdesk_idx` (`processed by` ASC) VISIBLE,
  INDEX `FL_customer_NVR_idx` (`submitted by` ASC) VISIBLE,
  CONSTRAINT `FK_backdesk_NVR`
    FOREIGN KEY (`processed by`)
    REFERENCES `RentalCarSystemDB`.`Back Desk Employee` (`idBack Desk Employee`)
    ON UPDATE CASCADE,
  CONSTRAINT `FL_customer_NVR`
    FOREIGN KEY (`submitted by`)
    REFERENCES `RentalCarSystemDB`.`customer` (`customer id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Office Manager`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Office Manager` (
  `idOffice Manager` VARCHAR(10) NOT NULL,
  `tasks managed` INT NULL DEFAULT NULL,
  `avairability` TINYINT NOT NULL,
  PRIMARY KEY (`idOffice Manager`),
  CONSTRAINT `id_om`
    FOREIGN KEY (`idOffice Manager`)
    REFERENCES `RentalCarSystemDB`.`Employee` (`Employee ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Rental Car Request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Rental Car Request` (
  `Request ID` VARCHAR(10) NOT NULL,
  `customerID` VARCHAR(45) NOT NULL,
  `preferred vehicle` VARCHAR(10) NOT NULL,
  `Pickup time` DATETIME NOT NULL,
  `Return time` DATETIME NOT NULL,
  `Pickup Rental Office ID` VARCHAR(45) NOT NULL,
  `Return Rental Office ID` VARCHAR(45) NOT NULL,
  `Status` VARCHAR(10) NOT NULL,
  `Date Submitted` DATE NOT NULL,
  `processed by` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Request ID`),
  UNIQUE INDEX `UserID_UNIQUE` (`customerID` ASC) VISIBLE,
  INDEX `pick up rental office_idx` (`Pickup Rental Office ID` ASC) INVISIBLE,
  INDEX `return rental office_idx` (`Return Rental Office ID` ASC) VISIBLE,
  INDEX `FK_process_front_idx` (`processed by` ASC) VISIBLE,
  INDEX `preffered_vehicle_infomation_R_idx` (`preferred vehicle` ASC) VISIBLE,
  CONSTRAINT `customer_RCR`
    FOREIGN KEY (`customerID`)
    REFERENCES `RentalCarSystemDB`.`customer` (`customer id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_process_front`
    FOREIGN KEY (`processed by`)
    REFERENCES `RentalCarSystemDB`.`Front Desk Employee` (`idFront Desk Employee`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `pick up rental office_RCR`
    FOREIGN KEY (`Pickup Rental Office ID`)
    REFERENCES `RentalCarSystemDB`.`RentalOffice` (`RentalOffice ID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `preffered_vehicle_infomation_R`
    FOREIGN KEY (`preferred vehicle`)
    REFERENCES `RentalCarSystemDB`.`Vehicle` (`idVehicle`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `return rental office_RCR`
    FOREIGN KEY (`Return Rental Office ID`)
    REFERENCES `RentalCarSystemDB`.`RentalOffice` (`RentalOffice ID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Task`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Task` (
  `idTask` VARCHAR(10) NOT NULL,
  `task assigned by` VARCHAR(10) NULL DEFAULT NULL,
  `task process by` VARCHAR(10) NULL DEFAULT NULL,
  `task` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTask`),
  INDEX `manager_task_idx` (`task assigned by` ASC) VISIBLE,
  INDEX `employee_task_idx` (`task process by` ASC) VISIBLE,
  CONSTRAINT `employee_task`
    FOREIGN KEY (`task process by`)
    REFERENCES `RentalCarSystemDB`.`Employee` (`Employee ID`),
  CONSTRAINT `manager_task`
    FOREIGN KEY (`task assigned by`)
    REFERENCES `RentalCarSystemDB`.`Office Manager` (`idOffice Manager`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `RentalCarSystemDB`.`Transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `RentalCarSystemDB`.`Transaction` (
  `paymentid` VARCHAR(10) NOT NULL,
  `transaction` VARCHAR(45) NOT NULL,
  `Amount` VARCHAR(45) NOT NULL,
  `Date` DATE NOT NULL,
  `Payment method` VARCHAR(45) NULL DEFAULT NULL,
  `customer_id` VARCHAR(10) NULL DEFAULT NULL,
  `back_end_employee_id` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`paymentid`),
  INDEX `FK_payment_method_idx` (`Payment method` ASC) VISIBLE,
  INDEX `FK_customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `FK_back_desk_employee_id_idx` (`back_end_employee_id` ASC) VISIBLE,
  CONSTRAINT `FK_back_desk_employee_id`
    FOREIGN KEY (`back_end_employee_id`)
    REFERENCES `RentalCarSystemDB`.`Back Desk Employee` (`idBack Desk Employee`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `RentalCarSystemDB`.`customer` (`customer id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_payment_method_T`
    FOREIGN KEY (`Payment method`)
    REFERENCES `RentalCarSystemDB`.`Payment Method` (`idPayment Method`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `RentalCarSystemDB` ;

-- -----------------------------------------------------
-- procedure AddRentalOffice
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `AddRentalOffice`(
        IN officeID VARCHAR(10),
        IN address VARCHAR(255),
        IN name VARCHAR(45)
    )
BEGIN
        INSERT INTO `RentalOffice` (`RentalOffice ID`, address, name)
        VALUES (officeID, address, name);
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddVehicle
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `AddVehicle`(
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
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AssignEmployeeToOffice
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `AssignEmployeeToOffice`(
    IN employee_id VARCHAR(10),
    IN office_id VARCHAR(10)
)
BEGIN
    UPDATE Employee
    SET workplace = office_id
    WHERE `Employee ID` = employee_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AssignVehicle
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `AssignVehicle`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CustomerRentalHistory
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `CustomerRentalHistory`(IN customer_id VARCHAR(10))
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
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GenerateInvoice
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `GenerateInvoice`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ListAllVehicles
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `ListAllVehicles`()
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
  END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ListAvailableVehicles
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `ListAvailableVehicles`()
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
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ListCustomerFeedback
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `ListCustomerFeedback`()
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RecordVehicleMaintenance
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `RecordVehicleMaintenance`(
        IN maintenance_id VARCHAR(10)
    )
BEGIN
        UPDATE `Maintenance Request`  
        SET status = 'completed'
        WHERE `idMaintenance Request` = maintenance_id 
          AND (status = 'pending' OR status = 'in progress'); 
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RegisterCustomer
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `RegisterCustomer`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ScheduleMaintenance
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `ScheduleMaintenance`(
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
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateCustomerContact
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `UpdateCustomerContact`(
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
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateVehicleAvailability
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `UpdateVehicleAvailability`(
        IN vehicle_id VARCHAR(50),
        IN new_status tinyint
    )
BEGIN
        UPDATE Vehicle  -- Use the correct table name
        SET `Availability Status` = new_status  
        WHERE idVehicle = vehicle_id;
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure addPaymentMethod
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `addPaymentMethod`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure assign_employee_to_office
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `assign_employee_to_office`(
    IN employee_id VARCHAR(10),
    IN office_id VARCHAR(10)
)
BEGIN
    UPDATE Employee
    SET workplace = office_id
    WHERE `Employee ID` = employee_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure customer_RentalHistory
-- -----------------------------------------------------

DELIMITER $$
USE `RentalCarSystemDB`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `customer_RentalHistory`(IN customer_id VARCHAR(10))
BEGIN
        SELECT 
            bi.idBookingInformation AS BookingID,
            v.idVehicle AS VehicleID,
            vi.Manufacturer,
            vi.Model,
            bi.`Start time` AS StartTime,
            bi.`End time` AS EndTime,
            bi.location AS PickupLocation,
            ro.name AS RentalOffice
        FROM BookingInformation bi
        JOIN Vehicle v ON bi.`Vehicle ID` = v.idVehicle
        JOIN VehicleInformation vi ON v.`Vehicle Information` = vi.idVehicleInformation
        JOIN RentalOffice ro ON bi.`Rental Office ID` = ro.`Rental Office ID`
        WHERE bi.`customer ID` = customer_id;
    END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
