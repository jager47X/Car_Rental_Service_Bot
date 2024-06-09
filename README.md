# Car Rental System Discord Bot

## Summary
This Discord bot is designed to manage a car rental system with various functionalities such as adding vehicles, updating availability, registering customers, and more. It utilizes an SQL database for data management and provides a seamless interaction experience via Discord commands.


This repository contains the following documents and files:
- **List of Commands**: Detailed command list for interacting with the bot.
- **Software Document for SQL**: Comprehensive documentation on the SQL database design and functionalities.

## Project Summary

The Car Rental System is designed to revolutionize and improve traditional car rental operations, enhancing efficiency and functionality. The system offers the following features:
- Efficient handling of vehicle inventory, customer reservations, and administrative tasks.
- Dynamic pricing strategies influenced by vehicle popularity and demand.
- Enhanced user experience with a friendly interface and quick response times.
- Optimized vehicle maintenance and downtime using data analytics.
- Personalized customer suggestions to improve satisfaction and upsell opportunities.

Key functional and non-functional database requirements ensure the system's performance, security, and scalability.

## Features

- Add and update vehicle information
- Register new customers and update their contact info
- Assign vehicles to customers and manage rentals
- View lists of available vehicles, all vehicles, and customer rental history
- Record and schedule vehicle maintenance
- Add new rental offices and assign employees
- Handle customer feedback and generate rental invoices

## Commands

The bot supports a variety of commands to manage the car rental system. For a detailed list of commands, refer to the **List of Commands** document provided.

### 1. Add New Vehicle
```
Command: !add_vehicle {"manufacturer":"Toyota", "model":"Camry SE", "year":"2022", "vehicleType":"SEDAN", "tier":2, "miles":1000, "wear":"new", "rentalOfficeID":"office001", "vehicleTypeDescription":"4 door sedan"}
Description: Adds a new vehicle to the fleet with the provided details.
```

### 2. Update Vehicle Availability
```
Command: !update_vehicle_availability {"vehicleID":"vehicle2", "availabilityStatus":"available"}
Description: Updates the availability status of a vehicle to available.
```

### 3. View List of Available Vehicles
```
Command: !list_available_vehicles
Description: Lists all available vehicles for rental.
```

### 4. Register New Customer
```
Command: !register_customer {"email":"yutomori@email.com", "password":"securepassword123", "name":"Yuto Mori", "address":"456 Oak Ave.", "method_type":"debit", "account_holder":"Yuto Mori", "account_number":9876543210987654, "expiration_date":"2026-06-30", "security_code":456, "billing_address":"456 Oak Ave.", "bank_name":"Japan Bank"}
Description: Registers a new customer in the system.
```

### 5. View Customer Rental History
```
Command: !customer_rental_history {"customerID":"customer4"}
Description: Shows the rental history of a specific customer.
```

### 6. Record Vehicle Maintenance
```
Command: !record_vehicle_maintenance {"maintenanceID":"mr001"}
Description: Records maintenance performed on a vehicle.
```

### 7. Assign Vehicle to Customer
```
Command: !assign_vehicle {"customerID":"user001", "preferred_vehicle":"vehicle1", "PickupTime":"2024-06-01 10:00:00", "ReturnTime":"2024-06-03 14:00:00", "PickupAt":"office002", "ReturnAt":"office001", "front_desk_employee_id":"user004"}
Description: Assigns a vehicle to a customer for a rental period.
```

### 8. Add Payment Method
```
Command: !add_payment_method {"accountHolder":"John Doe", "methodType":"Credit Card", "accountNumber":"1234567890", "expiration":"2025-12-31", "BillingAddress":"NYC times 333 square st", "BankName":"NYC BANK", "securityCode":777}
Description: Adds a payment method for a customer.
```

### 9. Generate Rental Invoice
```
Command: !generate_invoice {"description":"Rental of Toyota Camry", "amount":350, "payment_date":"2024-04-20", "payment_method":"payment5", "customer_id":"customer5", "back_end_employee_id":"user005"}
Description: Generates a rental invoice for a transaction.
```

### 10. Update Customer Contact Info
```
Command: !update_customer_contact {"customerID":"customer5", "email":"newemail2@example.com", "address":"555 New Street, Anytown CA 12345"}
Description: Updates the contact information of a customer.
```

### 11. Add New Rental Office
```
Command: !add_rental_office {"address":"222 Main St, New York, NY", "name":"New York Office"}
Description: Adds a new rental office location.
```

### 12. View List of All Vehicles
```
Command: !list_all_vehicles
Description: Lists all vehicles in the fleet.
```

### 13. Schedule Maintenance
```
Command: !schedule_maintenance {"vehicleID":"Vehicle3", "serviceCenterID":"center001", "StartDate":"2024-06-01", "EndDate":"2024-06-07"}
Description: Schedules maintenance for a vehicle.
```

### 14. Assign Employee to Office
```
Command: !assign_employee_to_office {"employeeID":"user004", "officeID":"office003"}
Description: Assigns an employee to a rental office.
```

### 15. View List of Customer Feedback
```
Command: !list_customer_feedback
Description: Lists feedback given by customers.
```

## Installation

1. Clone the repository:


2. Install the required dependencies:
```
pip install -r requirements.txt
```

3. Set up the SQL database using the provided schema in Database file and ensure it is accessible by the bot.

4. Configure the bot token and database connection in a `Secrets` file:
```
DISCORD_TOKEN=<your-discord-bot-token>
DA_PASSWORD=<your-database-password>
DB_USER=<your-database-username>
DB_NAME=<your-database-schemaname>
DB_HOST=<your-database-IP adress>
```

5. Run the bot:
```
python bot.py
```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes. Make sure to update the documentation as needed.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
