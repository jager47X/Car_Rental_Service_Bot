-- File: inserts.sql
-- Author: Yuto Mori
-- Date: 5/18
-- Description: This file contains sample data inserts for the RentalCarSystemDB database.

-- Context: 
-- This script inserts sample data into all tables of the RentalCarSystemDB database to facilitate testing and demonstration of the database system.

USE RentalCarSystemDB;

-- Inserting data into the User table
INSERT INTO `RentalCarSystemDB`.`User` (`UserID`, `email`, `password`, `name`) VALUES
('user001', 'user001@example.com', 'password001', 'John Doe'),
('user002', 'user002@example.com', 'password002', 'Jane Smith'),
('user003', 'user003@example.com', 'password003', 'Alice Johnson'),
('user004', 'user004@example.com', 'password004', 'Bob Brown'),
('user005', 'user005@example.com', 'password005', 'Emma Lee'),
('user006', 'user006@example.com', 'password006', 'David Wilson'),
('user007', 'user007@example.com', 'password007', 'Sophia Garcia'),
('user008', 'user008@example.com', 'password008', 'Liam Martinez'),
('user009', 'user009@example.com', 'password009', 'Olivia Robinson'),
('user010', 'user010@example.com', 'password010', 'William Lopez'),
('user011', 'user011@example.com', 'password011', 'Ava Hill'),
('user012', 'user012@example.com', 'password012', 'Michael Young'),
('user013', 'user013@example.com', 'password013', 'Antonia Dennis'),
('user014', 'user014@example.com', 'password014', 'Rufino Tashi'),
('user015', 'user015@example.com', 'password015', 'Ellinor Verica');

-- Inserting data into the Account table (12 entries)
INSERT INTO `RentalCarSystemDB`.`Account` (`UserID`, `account_type`, `account_status`) VALUES
('user001', 'Customer', 1),
('user002', 'Customer', 1),
('user003', 'Customer', 1),
('user004', 'Employe', 1),
('user005', 'Employee', 1),
('user006', 'Employee', 1),
('user007', 'Employee', 1),
('user008', 'Employee', 1),
('user009', 'Employee', 1),
('user010', 'Employee', 1),
('user011', 'Employee', 1),
('user012', 'Employee', 1),
('user013', 'Employee', 1),
('user014', 'Employee', 1),
('user015', 'Employee', 1);

INSERT INTO `RentalCarSystemDB`.`Payment Method` (`idPayment Method`, `methodType`, `AccountHolder`, `Account Number`, `Expiration Date`, `Security Code`, `Billing Address`, `Bank Name`) VALUES
('payment001', 'Credit', 'John Doe', 1234567890, '2025-12-31', 123, '123 Street, City', 'Bank of RentalCars'),
('payment002', 'Debit', 'Jane Smith', 9876543210, '2026-10-31', 456, '456 Avenue, Town', 'Car Rentals Inc.'),
('payment003', 'Credit', 'Alice Johnson', 1357924680, '2025-08-31', 789, '789 Road, Village', 'Rent-A-Car Bank');

-- Inserting data into the Customer table
INSERT INTO `RentalCarSystemDB`.`customer` (`customer id`, `payment_method`, `address`) VALUES
('user001', 'payment001', '123 Main Street'),
('user002', 'payment002', '456 Elm Street'),
('user003', 'payment003', '789 Oak Street');

-- Inserting data into the Payroll table
INSERT INTO `RentalCarSystemDB`.`Payroll` (`idPayroll`, `Processing Date`, `Total Amount`) VALUES
('payroll001', '2024-05-10', 3000),
('payroll002', '2024-05-10', 3200),
('payroll003', '2024-05-10', 3500);

-- Inserting data into the Rental Office table
INSERT INTO `RentalCarSystemDB`.`Rental Office` (`Rental Office ID`, `address`, `name`) VALUES
('office001', '123 Rental Street', 'LA Rental Office'),
('office002', '456 Lease Avenue', 'SF Rental Office'),
('office003', '789 Hire Road', 'NYC Rental Office');

-- Inserting data into the Vehicle type table
INSERT INTO `RentalCarSystemDB`.`Vehicle type` (`idVehecle type`, `type`, `description`) VALUES
('type001', 'SUV', 'Sport Utility Vehicle'),
('type002', 'SEDAN', 'Sedan Car'),
('type003', 'TRUCK', 'Pickup Truck');


-- Inserting data into the Service Center table
INSERT INTO `RentalCarSystemDB`.`Service Center` (`Service Center ID`, `address`, `specialized vehicle type`,`name`) VALUES
('center001', '10 Main Street', 'type001','NYC service center'),
('center002', '20 Elm Street', 'type002','SF service center'),
('center003', '30 Oak Street', 'type003','LA service center');


-- Inserting data into the Employee table
INSERT INTO `RentalCarSystemDB`.`Employee` (`Employee ID`, `payroll`, `workplace`) VALUES
('user004', 'payroll001',  'office001'),
('user005', 'payroll001',  'office001'),
('user006', 'payroll003',  'office001'),
('user007', 'payroll001',  'office002'),
('user008', 'payroll001',  'office002'),
('user009', 'payroll003',  'office002'),
('user010', 'payroll001',  'office003'),
('user011', 'payroll001',  'office003'),
('user012', 'payroll003',  'office003'),
('user013', 'payroll002',  'center001'),
('user014', 'payroll002',  'center002'),
('user015', 'payroll002',  'center003');

-- Inserting data into the Office Manager table
INSERT INTO `RentalCarSystemDB`.`Office Manager` (`idOffice Manager`, `tasks managed`, `avairability`) VALUES
('user006', 10, 1),
('user009', 12, 1),
('user012', 15, 1);

-- Inserting data into the Front Desk Employee table
INSERT INTO `RentalCarSystemDB`.`Front Desk Employee` (`idFront Desk Employee`, `availability`, `processed rental requests`) VALUES
('user004', 1, '1'),
('user007', 1, '2'),
('user010', 1, '3');



-- Inserting data into the Back Desk Employee table
INSERT INTO `RentalCarSystemDB`.`Back Desk Employee` (`idBack Desk Employee`, `avairability`,`processed maintenance request`, `processed new vehicle request`,`processed feedbacks`) VALUES
('user005',1,3, 1, 0),
('user008',1, 2,2, 1),
('user011', 1,1,3, 2);


INSERT INTO `RentalCarSystemDB`.`Technician` (`Technician ID`, `specialized vehicle type`, `availability`) VALUES
('user013', 'type001', 1),
('user014', 'type002', 1),
('user015', 'type003', 1);

-- Inserting data into the Task table
INSERT INTO `RentalCarSystemDB`.`Task` (`idTask`, `task assigned by`, `task process by`, `task`) VALUES
('task001', 'user006', 'user004', 'Manage Front Desk Operations'),
('task002', 'user009', 'user007', 'Handle Customer new car request'),
('task003', 'user012', 'user010', 'Manage Front Desk Operations');


-- Inserting data into the Vehicle Information table
INSERT INTO `RentalCarSystemDB`.`Vehicle Information` (`idVehicle Information`, `Manufacturer`, `Model`, `Year`, `Tier`, `vehicle type`) VALUES
('vehicle001', 'Toyota', 'RAV4', '2022', 1, 'type002'),
('vehicle002', 'Honda', 'Civic', '2023', 1, 'type001'),
('vehicle003', 'Ford', 'F-150', '2021', 1, 'type003');


-- Inserting data into the Vehicle Conditions table
INSERT INTO `RentalCarSystemDB`.`Vehicle Conditions` (`idVehicle Conditions`, `Miles`, `Vehicle wear`) VALUES
('con001', '50000', 'Minor'),
('con002', '60000', 'Moderate'),
('con003', '70000', 'Severe');



-- Inserting data into the New Vehicle Request table
INSERT INTO `RentalCarSystemDB`.`New Vehicle Request` (`idNew Vehicle Request`, `Vehicle Category`, `Preferred Manufacturer`, `Preferred Model`, `Status`, `Date Submitted`, `processed by`, `submitted by`) VALUES
('newreq001', 1, 'Toyota', 'Corolla', 'Approved', '2024-05-10', 'user005', 'user001'),
('newreq002', 2, 'Honda', 'Civic', 'Pending', '2024-05-11', 'user008', 'user002'),
('newreq003', 3, 'Ford', 'Fusion', 'Approved', '2024-05-12', 'user011', 'user003');


-- Inserting data into the Transaction table
INSERT INTO `RentalCarSystemDB`.`Transaction` (`paymentid`, `transaction`, `Amount`, `Date`, `Payment method`, `customer_id`, `back_end_employee_id`) VALUES
('trans001', 'Rental Payment', '100', '2024-05-11', 'payment001', 'user001', 'user005'),
('trans002', 'Rental Payment', '150', '2024-05-12', 'payment002', 'user002', 'user008'),
('trans003', 'Rental Payment', '200', '2024-05-13', 'payment003', 'user003', 'user011');



-- Inserting data into the Maintenance Schedule table
INSERT INTO `RentalCarSystemDB`.`Maintenance Schedule` (`idMaintenance Schedule`, `Service Center ID`, `Start Date`, `End Date`) VALUES
('sche001', 'center001', '2024-05-10 08:00:00', '2024-05-10 09:00:00'),
('sche002', 'center002', '2024-05-10 09:00:00', '2024-05-10 10:00:00'),
('sche003', 'center003', '2024-05-10 10:00:00', '2024-05-10 11:00:00');


INSERT INTO `RentalCarSystemDB`.`Auto Parts` (`idAuto Parts`, `Part Name`, `Manufacturer`, `Model`,`Quantity in Stock`, `Price`, `Date Added`, `assinged service center`) VALUES
('part001', 'Brake Pad', 'Toyota', 'Camry', 50, 25, '2023-05-01 10:00:00', 'center001'),
('part002', 'Air Filter', 'Honda', 'Civic', 30, 15, '2023-05-01 10:00:00', 'center002'),
('part003', 'Oil Filter', 'Ford', 'Focus', 20, 10, '2023-05-01 10:00:00', 'center003');




-- Inserting data into the Vehicle table
INSERT INTO `RentalCarSystemDB`.`Vehicle` (`idVehicle`, `Vechile Information`, `Vehicle condition`, `Booking infomaiton ID`, `Availability Status`, `Rental Office ID`, `Assigned Service Center ID`, `Assigned customer ID`, `Assigned front desk employee ID`, `assgined technician ID`, `maintenance schedule`) VALUES
('vehicle001', 'vehicle001', 'con001', NULL, 1, NULL, 'center001', NULL, NULL, 'user013', 'sche001'),
('vehicle002', 'vehicle002', 'con002', NULL, 1, NULL, 'center002', NULL, NULL, 'user014', 'sche002'),
('vehicle003', 'vehicle003', 'con003', NULL, 1, NULL, 'center003', NULL, NULL, 'user015', 'sche003');



-- Inserting data into the Rental Car Request table
INSERT INTO `RentalCarSystemDB`.`Rental Car Request` (`Request ID`, `customerID`, `preferred vehicle`, `Pickup time`, `Return time`, `Pickup Rental Office ID`, `Return Rental Office ID`, `Status`, `Date Submitted`, `processed by`) VALUES
('req001', 'user001', 'vehicle001', '2024-05-15 09:00:00', '2024-05-18 09:00:00', 'office001', 'office002', 'Pending', '2024-05-10', 'user004'),
('req002', 'user002', 'vehicle002', '2024-05-16 10:00:00', '2024-05-19 10:00:00', 'office002', 'office003', 'Approved', '2024-05-11', 'user007'),
('req003', 'user003', 'vehicle003', '2024-05-17 11:00:00', '2024-05-20 11:00:00', 'office003', 'office001', 'Pending', '2024-05-12', 'user010');

-- Inserting data into the Booking Information table
INSERT INTO `RentalCarSystemDB`.`Booking Information` (`idBooking Information`, `customer ID`, `Vehicle ID`, `Rental Office ID`, `Start time`, `End time`, `location`, `assigned front desk employee`) VALUES
('booking001', 'user001', 'vehicle001', 'office001', '2024-05-11 09:00:00', '2024-05-11 18:00:00', 'LA Rental Office', 'user004'),
('booking002', 'user002', 'vehicle002','office002', '2024-05-11 10:00:00', '2024-05-11 19:00:00', 'SF Rental Office', 'user007'),
('booking003', 'user003', 'vehicle003', 'office003', '2024-05-11 11:00:00', '2024-05-11 20:00:00', 'NYC Rental Office', 'user010');




-- Inserting data into the maintenance request table
INSERT INTO `RentalCarSystemDB`.`Maintenance Request` 
(`idMaintenance Request`, `vehicle id`, `Service Centerid`, `Request Date`, `processed by`, `Maintenance schedule`, `descrption`, `status`, `date submitted`, `serviced by`) 
VALUES 
('mr001', 'vehicle001', 'center001', '2023-05-01 10:00:00', 'user005', 'sche001', 'Oil change required', 'Pending', '2023-05-01', 'user013'),
('mr002', 'vehicle002', 'center002', '2023-05-02 11:00:00', 'user008', 'sche002', 'Brake pads replacement', 'In Progress', '2023-05-02', 'user014'),
('mr003', 'vehicle003', 'center003', '2023-05-03 12:00:00', 'user011', 'sche003', 'Engine checkup', 'Completed', '2023-05-03', 'user015');



-- Inserting data into the feedback table
INSERT INTO `RentalCarSystemDB`.`Feedback` (`idFeedback`, `Rental Session ID`, `Rating`, `Date Submitted`, `Comments`, `processed by`, `submitted by`) VALUES
('fb001', 'booking001', 3,  '2024-05-10', 'clean!','user005', 'user001'),
('fb002', 'booking002', 4,  '2024-05-11', 'fun!','user008', 'user002'),
('fb003', 'booking003', 5,  '2024-05-12', 'awesome!','user011', 'user003');



