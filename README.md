# Macalinao_Drill_Exam
This is my project it is a very simple Python-based database management system. It allows users to perform CRUD operations (Create, Read, Update, Delete) on the database using a Flask-based API.
Before using this code, make sure that the following are installed on your computer:
1.	Python (version 3.10.11 or higher) - Download Python
2.	MySQL Workbench - Download MySQL Workbench
3.	Flask (installed via "pip install Flask-MySQLdb") Files

This project consists of the following files:
1.	apii.py - This Python file connects to the MySQL Workbench server. Before using, ensure you update the hostname and password in apii.py to match your MySQL Workbench settings.
2.	api_unittest.py - This file contains unit tests for apii.py to ensure its functionality.
3.	northwindbackup.sql - This is the Northwind database file. Import this file into MySQL Workbench by following these steps:
-	Open MySQL Workbench and connect to your server.
-	Select "Server" from the top menu, then "Data Import".
-	Choose "Import from Self-Contained File" and select the northwindbackup.sql file.
-	Click "Start Import".
4.	Main.bat - Run this batch file to interact with the Northwind database. It provides options to read, add, delete, or update data in the database
5.  requirements.txt - this file shows requirements of pip install you need.

Usage:
1.	Make sure that you have the necessary things installed (Python, MySQL Workbench, and Flask).
2.	Import the Northwind database by following the steps mentioned above.
3.	Update the apii.py file with your MySQL Workbench server details
4.	Open a command prompt or terminal and navigate to the project directory.
5.	Run the command python apii.py to start the Flask server.
6.	Open a web browser and navigate to http://localhost:5000 to access the API interface.
7.	Use the Main.bat file to perform CRUD operations on the Northwind database. Simply open the file and follow the instructions provided.
8.	If you're using the api_unittest.py make sure to change the the IDs and other detail. 

Have fun using it bruv!
