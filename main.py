import os
import discord
import json
from discord.ext import commands
import pymysql  
from models import Employee, Vehicle, Customer, Maintenance, Rental, PaymentMethod, Invoice, RentalOffice, Feedback
from database import Database
from enum import Enum
 

class AvailabilityStatus(Enum):
    UNAVAILABLE = 0
    AVAILABLE = 1
    MAINTENANCE = 2

TOKEN = os.environ.get("DISCORD_TOKEN")
if not TOKEN:
    print("Error: DISCORD_TOKEN is not set in environment variables")
    exit(1)

intents = discord.Intents.default()
intents.message_content = True
intents.messages = True
intents.guilds = True

bot = commands.Bot(command_prefix='!', intents=intents)



@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name} - {bot.user.id}')
    if(Database.connect):
        print("successfuly connected to database") 
        if Database.create_procedures():
            print("Stored procedures created successfully.")
        else:
            print("Failed to create stored procedures.")
    else:
        print("failed to connect")


@bot.event
async def on_message(message):
    if message.author == bot.user:
        return
    await bot.process_commands(message)
    
def handle_model_operation(ctx, model_class, model_data):
    try:
        model_obj = model_class(**model_data)
        if model_obj.add(): 
            ctx.send(f"{model_class.__name__} added successfully!")
        else:
            ctx.send(f"Failed to add {model_class.__name__}. Please try again later.")
    except (json.JSONDecodeError, pymysql.Error) as e:
            ctx.send(f"Error: {type(e).__name__} - {e}")
        
@bot.command(name="add_vehicle", help="Adds a new vehicle to the fleet (JSON format)")
async def add_vehicle(ctx, *, vehicle_info: str):
    try:
        vehicle_data = json.loads(vehicle_info)

        
        required_fields = ["manufacturer", "model", "year", "vehicleType","tier", "miles", "wear", "rentalOfficeID","vehicleTypeDescription"]
        for field in required_fields:
            if field not in vehicle_data:
                raise ValueError(f"Missing required field: {field}")

        vehicle = Vehicle(**vehicle_data)
        if vehicle.add_vehicle():
                embed = discord.Embed(title="New Vehicle Added", color=discord.Color.orange())
                embed.add_field(name="Vehicle ID", value=vehicle.vehicleID, inline=False)
                embed.add_field(name="Manufacturer", value=vehicle.manufacturer, inline=True)
                embed.add_field(name="Model", value=vehicle.model, inline=True)
                embed.add_field(name="Year", value=vehicle.year, inline=True)
                embed.add_field(name="Vehicle Type", value=vehicle.vehicleType, inline=True)
                embed.add_field(name="Tier", value=vehicle.tier, inline=True)
                embed.add_field(name="Miles", value=vehicle.miles, inline=True)
                embed.add_field(name="Wear", value=vehicle.wear, inline=True)
                embed.add_field(name="Rental Office ID", value=vehicle.rentalOfficeID, inline=False)
                embed.add_field(name="Vehicle Type Description", value=vehicle.vehicleTypeDescription, inline=False)
                await ctx.send(embed=embed)
        else:
            await ctx.send(f"Failed to add vehicle. Please check the data and try again.")
    except (json.JSONDecodeError, pymysql.Error, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")



@bot.command(name="update_vehicle_availability", help="Updates vehicle availability (JSON format)")
async def update_vehicle_availability(ctx, *, vehicle_info: str):
    try:
        vehicle_data = json.loads(vehicle_info)

       
        required_fields = ["vehicleID", "availabilityStatus"] 
        for field in required_fields:
            if field not in vehicle_data:
                raise ValueError(f"Missing required field: {field}")
            if not vehicle_data[field]:  
                raise ValueError(f"Field '{field}' cannot be empty")

        vehicle_id = vehicle_data["vehicleID"]

        
        try:
            new_status = AvailabilityStatus[vehicle_data["availabilityStatus"].upper()]
        except KeyError:
            raise ValueError("Invalid availabilityStatus. Please choose from: available, unavailable, maintenance")

        
        vehicle = Vehicle(vehicleID=vehicle_id, availabilityStatus=new_status.value)
        if vehicle.update_availability():
            
            embed = discord.Embed(title="Vehicle Availability Updated", color=discord.Color.green())
            embed.add_field(name="Vehicle ID", value=vehicle.vehicleID, inline=True)
            embed.add_field(name="New Availability Status", value=new_status.name, inline=True) 
            await ctx.send(embed=embed)
        else:
            await ctx.send(f"Failed to update availability for vehicle {vehicle_id}. Please try again later.")
    

    except (json.JSONDecodeError, pymysql.Error, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")
        

@bot.command(name="list_available_vehicles", help="Lists all available vehicles")
async def list_available_vehicles(ctx):
    vehicles = Vehicle.get_available_vehicles()

    if vehicles:
    
        embed = discord.Embed(title="Available Vehicles", color=discord.Color.green())  

      
        for vehicle in vehicles:
      
            embed.add_field(
                name=f"{vehicle.manufacturer} {vehicle.model} ({vehicle.year})",
                value=f"ID: {vehicle.vehicleID}\nType: {vehicle.vehicleType}\nTier: {vehicle.tier}",
                inline=False 
            )

        await ctx.send(embed=embed)  
    else:
        await ctx.send("No available vehicles found.")

@bot.command(name="list_all_vehicles", help="Lists all vehicles in the fleet")
async def list_all_vehicles(ctx):
    vehicles = Vehicle.list_all_vehicle() 
    if vehicles:
        embed = discord.Embed(title="All Vehicles in Fleet", color=discord.Color.blue())
        for vehicle in vehicles:  
             
            embed.add_field(
                name=f"{vehicle.manufacturer} {vehicle.model} ({vehicle.year})",
                value=f"ID: {vehicle.vehicleID}\nType: {vehicle.vehicleType}\nTier: {vehicle.tier}\nAvailability Status: {AvailabilityStatus(vehicle.availabilityStatus).name}",  
                inline=False
            )
        await ctx.send(embed=embed)
    else:
        await ctx.send("No vehicles found or an error occurred.")

@bot.command(name="register_customer", help="Registers a new customer in the system")
async def register_customer(ctx, *, customer_info: str):
    try:
        customer_data = json.loads(customer_info)
        required_fields = [
            "email", 
            "password", 
            "name", 
            "address",
            "method_type", 
            "account_holder", 
            "account_number", 
            "expiration_date", 
            "security_code", 
            "billing_address", 
            "bank_name"
        ]  
         
        for field in required_fields:
            if field not in customer_data:
                raise ValueError(f"Missing required field: {field}")
            if not customer_data[field]:  
                raise ValueError(f"Field '{field}' cannot be empty")


        
        customer = Customer(**customer_data)
        response = customer.register() 
        

       
        if response == "this email is already taken and account already exist!":
            await ctx.send(response)
        elif not response:
            await ctx.send("Failed to register customer due to an unexpected database error.")
        else:
            
            embed = discord.Embed(title="Customer Registered Successfully!", color=discord.Color.green())
            embed.add_field(name="Customer ID", value=customer.customerID, inline=False)
            embed.add_field(name="Name", value=customer.name, inline=True)
            embed.add_field(name="Email", value=customer.email, inline=True)
            embed.add_field(name="Address", value=customer.address, inline=False)
            
            await ctx.send(embed=embed)

    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e: 
        await ctx.send(f"An unexpected error occurred: {e}")
        

@bot.command(name="customer_rental_history", help="Retrieves the rental history of a specific customer")
async def customer_rental_history(ctx,*, customer_info: str):
    try:
        customer_data = json.loads(customer_info)
        required_fields = [
            "customerID"
        ]  

        for field in required_fields:
            if field not in customer_data:
                raise ValueError(f"Missing required field: {field}")
            if not customer_data[field]:  
                raise ValueError(f"Field '{field}' cannot be empty")
        customer = Customer(**customer_data)
        rental_history = customer.get_rental_history()
        
        if rental_history:
            embed = discord.Embed(title=f"Rental History for Customer {customer.customerID}", color=discord.Color.blue())

            for rental in rental_history:
                    embed.add_field(
                        name=f"Booking ID: {rental['BookingID']}",
                        value=f"""
                        Vehicle ID: {rental['VehicleID']}
                        Manufacturer: {rental['Manufacturer']}
                        Model: {rental['Model']}
                        Start Time: {rental['StartTime']}
                        End Time: {rental['EndTime']}
                        Rental Office: {rental['RentalOffice']}
                                    """,
                        inline=False
                    )
            await ctx.send(embed=embed)
        else:
            await ctx.send(f"No rental history found for customer {customer.customerID}.")

    except (json.JSONDecodeError, ValueError) as e:
          await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e: 
          await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="record_vehicle_maintenance", help="Records maintenance performed on a vehicle")
async def record_vehicle_maintenance(ctx, *,maintenance_info: str):
    try:
        maintenance_data =json.loads(maintenance_info)
        
        required_fields = [
            "maintenanceID"
        ]  
       
        for field in required_fields:
            if field not in maintenance_data:
                raise ValueError(f"Missing required field: {field}")
            if not maintenance_data[field]:  
                raise ValueError(f"Field '{field}' cannot be empty")
        maintenance = Maintenance(**maintenance_data)
        response = maintenance.record()
        if response:
            embed = discord.Embed(title="Maintenance Completed", color=discord.Color.green())
            embed.add_field(name="Maintenance ID", value=maintenance_data["maintenanceID"], inline=False)
    
            await ctx.send(embed=embed)
        else:
            embed = discord.Embed(title="Maintenance Record Failed", color=discord.Color.red())
            embed.add_field(name="Error", value="Failed to record vehicle maintenance. Please try again later.", inline=False)
            await ctx.send(embed=embed)

    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e:  
        await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="assign_vehicle", help="Assigns a vehicle to a customer for a rental period (JSON format)")
async def assign_vehicle(ctx, *, rental_info: str):
    try:
        rental_data = json.loads(rental_info)

        
        required_fields = [
            "customerID",
            "preferred_vehicle",
            "PickupTime",
            "ReturnTime",
            "PickupAt",
            "ReturnAt",
            "front_desk_employee_id"
        ]

        for field in required_fields:
            if field not in rental_data:
                raise ValueError(f"Missing required field: {field}")
            if not rental_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")

       
        rental = Rental(**rental_data)
        response = rental.assign()
        if  response:
            
            embed = discord.Embed(title="Vehicle Assigned Successfully", color=discord.Color.green())
            embed.add_field(name="Vehicle ID", value=rental.preferred_vehicle, inline=True)
            embed.add_field(name="Customer ID", value=rental.customerID, inline=True)
            embed.add_field(name="Pickup Time", value=rental.PickupTime, inline=False)
            embed.add_field(name="Return Time", value=rental.ReturnTime, inline=False)
            await ctx.send(embed=embed)
        else:
            embed = discord.Embed(title="Vehicle Assignment Failed", color=discord.Color.red())
            embed.add_field(name="Error", value="Failed to assign the vehicle. Please check the data and try again.", inline=False)
            await ctx.send(embed=embed)

    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e:  
        await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="add_payment_method", help="Adds a payment method for a customer")
async def add_payment_method(ctx, *,payment_info: str):
    try:
        
        payment_data = json.loads(payment_info)
        
        required_fields = [
            "accountHolder",
            "methodType",
            "accountNumber",
            "expiration",
            "BillingAddress",
            "BankName",
            "securityCode"
        ]
   

        for field in required_fields:
            if field not in  payment_data:
                raise ValueError(f"Missing required field: {field}")
            if not  payment_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")
                
        payment_method = PaymentMethod(**payment_data)  
        if payment_method.add():
            
            embed = discord.Embed(title="Payment Method Added Successfully", color=discord.Color.green())
            embed.add_field(name="Account Holder", value=payment_method.accountHolder, inline=True)
            embed.add_field(name="Method Type", value=payment_method.methodType, inline=True)
            embed.add_field(name="Account Number", value=payment_method.accountNumber, inline=False)  
            embed.add_field(name="Expiration Date", value=payment_method.expiration, inline=True)
            embed.add_field(name="Billing Address", value=payment_method.BillingAddress, inline=False)
            embed.add_field(name="Bank Name", value=payment_method.BankName, inline=True)
            embed.add_field(name="Security Code", value="***", inline=True) 
            await ctx.send(embed=embed)
        else:
            embed = discord.Embed(title="Error Adding Payment Method", color=discord.Color.red())
            embed.add_field(name="Error Message", value="Failed to add payment method. Please try again later.", inline=False)
            await ctx.send(embed=embed)
            
    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e:  
        await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="generate_invoice", help="Generates an invoice for a rental period")
async def generate_invoice(ctx, *,invoice_info: str):
    try:
        invoice_data = json.loads(invoice_info)

        
        
        required_fields = [
            "description",
            "amount",
            "payment_date",
            "payment_method",
            "customer_id",
            "back_end_employee_id"
        ]
       

        for field in required_fields:
            if field not in  invoice_data:
                raise ValueError(f"Missing required field: {field}")
            if not  invoice_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")


        
        invoice = Invoice(**invoice_data)
        response = invoice.generate()
        if invoice.generate():

            embed = discord.Embed(title="Invoice Generated Successfully", color=discord.Color.green())
            embed.add_field(name="Invoice ID", value=invoice.invoiceID, inline=False)
            embed.add_field(name="Description", value=invoice.description, inline=False)
            embed.add_field(name="Amount", value=invoice.amount, inline=True)
            embed.add_field(name="Payment Date", value=invoice.payment_date, inline=True)
            embed.add_field(name="Payment Method", value=invoice.payment_method, inline=True)
            embed.add_field(name="Customer ID", value=invoice.customer_id, inline=True)
            embed.add_field(name="Processed By", value=invoice.back_end_employee_id, inline=True)
            

            await ctx.send(embed=embed)

        else:
            embed = discord.Embed(title="Invoice Generation Failed", color=discord.Color.red())
            embed.add_field(name="Error", value="Failed to generate invoice. Please try again later.", inline=False)
            await ctx.send(embed=embed)
        
            
    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e: 
        await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="update_customer_contact", help="Updates the contact information of a customer (JSON format)")
async def update_customer_contact(ctx, *, customer_info: str):
    try:
        customer_data = json.loads(customer_info)


        required_fields = ["customerID", "email", "address"]  
        for field in required_fields:
            if field not in customer_data:
                raise ValueError(f"Missing required field: {field}")
            if not customer_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")


        customer = Customer(**customer_data)
        response = customer.update_contact() 
        if response == "customer not found":
            embed = discord.Embed(title="Error Updating Customer", description="Customer not found. Please check the customerID and try again.", color=discord.Color.red())
        elif response:
            embed = discord.Embed(title="Customer Contact Updated", color=discord.Color.green())
            embed.add_field(name="Customer ID", value=customer_data['customerID'], inline=False)
            embed.add_field(name="Email", value=customer_data['email'], inline=True)
            embed.add_field(name="Address", value=customer_data['address'], inline=True)
        else:
            embed = discord.Embed(title="Error Updating Customer", description="Failed to update customer contact information. Please try again later.", color=discord.Color.red())

        await ctx.send(embed=embed)


    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e:
        await ctx.send(f"An unexpected error occurred: {e}")
    

@bot.command(name="add_rental_office", help="Adds a new rental office location")
async def add_rental_office(ctx,*, office_info: str):
    try:
        office_data = json.loads(office_info)

        required_fields = [ "address", "name"]  
        for field in required_fields:
            if field not in office_data:
                raise ValueError(f"Missing required field: {field}")
            if not office_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")

        
        rental_office = RentalOffice(**office_data)
        
        response = rental_office.add()
        if rental_office.add():
            embed = discord.Embed(title="Rental Office Added Successfully", color=discord.Color.green())
            embed.add_field(name="Office ID", value=rental_office.officeID, inline=False)
            embed.add_field(name="Name", value=rental_office.name, inline=True)
            embed.add_field(name="Address", value=rental_office.address, inline=False)
            await ctx.send(embed=embed)
        else:
            embed = discord.Embed(title="Error Adding Rental Office", color=discord.Color.red())
            embed.add_field(name="Error Message", value="Failed to add rental office. Please try again later.", inline=False)
            await ctx.send(embed=embed)
    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")
    
    except Exception as e:
        await ctx.send(f"An unexpected error occurred: {e}")

        
    

@bot.command(name="schedule_maintenance", help="Schedules maintenance for a vehicle")
async def schedule_maintenance(ctx,*, maintenance_info: str):
    try:
        maintenance_data = json.loads(maintenance_info)
        
        required_fields = [
            "vehicleID",
            "serviceCenterID",
            "StartDate",
            "EndDate"
        ]
    
        for field in required_fields:
            if field not in maintenance_data:
                raise ValueError(f"Missing required field: {field}")
            if not maintenance_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")
        
        maintenance = Maintenance(**maintenance_data)
        response = maintenance.schedule()
        if response:
            embed = discord.Embed(title="Maintenance Scheduled Successfully", color=discord.Color.green())
            for field in required_fields:
                embed.add_field(name=field.capitalize(), value=maintenance_data[field], inline=True)

            await ctx.send(embed=embed)
        else:
            embed = discord.Embed(title="Failed to Schedule Maintenance", color=discord.Color.red())
            embed.add_field(name="Error", value="Failed to schedule maintenance. Please check the data and try again later.", inline=False)
            await ctx.send(embed=embed)

    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")

    except Exception as e: 
        await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="assign_employee_to_office", help="Assigns an employee to a rental office")
async def assign_employee_to_office(ctx, *, employee_info: str):
    try:
        employee_data = json.loads(employee_info)

        
        required_fields = ["employeeID", "officeID"]
        for field in required_fields:
            if field not in employee_data:
                raise ValueError(f"Missing required field: {field}")
            if not employee_data[field]:
                raise ValueError(f"Field '{field}' cannot be empty")


       
        employee = Employee(**employee_data)
        success, error_message = employee.assign_to_office()
        if success:
            embed = discord.Embed(title="Employee Assigned Successfully", color=discord.Color.green())
            for field in required_fields:
                embed.add_field(name=field.capitalize(), value=employee_data[field], inline=True)
            await ctx.send(embed=embed)
        else:
            embed = discord.Embed(title="Employee Assignment Failed", color=discord.Color.red())
            embed.add_field(name="Error Message", value=error_message, inline=False)
            await ctx.send(embed=embed)

    except (json.JSONDecodeError, ValueError) as e:
        await ctx.send(f"Error: {type(e).__name__} - {e}")
    except Exception as e:  
        await ctx.send(f"An unexpected error occurred: {e}")

@bot.command(name="list_customer_feedback", help="Lists all customer feedback")
async def list_customer_feedback(ctx):
    feedbacks = Feedback.get_all_feedback()

    if feedbacks:
       
        for feedback in feedbacks:
            embed = discord.Embed(
                title=f"Feedback ID: {feedback['idFeedback']}",
                description=f"Session ID: {feedback['Rental Session ID']}",
                color=discord.Color.blue()  
            )

            embed.add_field(name="Rating (out of 5)", value=feedback['Rating'], inline=True)
            embed.add_field(name="Submitted Date", value=feedback['Date Submitted'], inline=True)
            embed.add_field(name="Comments", value=feedback['Comments'], inline=False)
            embed.add_field(name="Processed By", value=feedback['processed by'], inline=True)
            embed.add_field(name="Submitted By", value=feedback['submitted by'], inline=True)
            

            await ctx.send(embed=embed)
    else:
        await ctx.send("No feedbacks found.")
        
   
     

bot.run(TOKEN)
