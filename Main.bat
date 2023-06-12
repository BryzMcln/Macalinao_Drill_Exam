@echo off
setlocal enabledelayedexpansion
start "API" cmd /k "python apii.py"

rem starting menu...
:main
cls
curl http://127.0.0.1:5000/

choice /c 12345 /N 

rem Choice of the user
if %ERRORLEVEL% == 1 (
    goto adding
)
if %ERRORLEVEL% == 2 (
    goto reading
)
if %ERRORLEVEL% == 3 (
    goto updating
)
if %ERRORLEVEL% == 4 (
    goto deleting
)
if %ERRORLEVEL% == 5 (
    goto :end
)
goto :end

rem Add on the table
:adding
cls
echo =========================
echo Enter the following:
echo =========================
set /p "comp=Company name: "
set /p "fst_nm=First name: "
set /p "lst_nm=Last name: "
set /p "job_t=Job title: "
set /p "addrs=Address: "
set /p "cty=City name: "
echo =========================

rem error handling... 
if "%comp%"=="" (
    echo Company name shouldn't be empty
    pause
    goto adding
)
if "%fst_nm%"=="" (
    echo It needs a First name
    pause
    goto adding 
)
if "%lst_nm%"=="" (
    echo It needs a Last name
    pause
    goto adding
)

set "json_dt={\"company\":\"%comp%\",\"first_name\":\"%fst_nm%\",\"last_name\":\"%lst_nm%\",\"job_title\":\"%job_t%\",\"address\":\"%addrs%\",\"city\":\"%cty%\"}"

curl --fail -X POST -H "Content-Type: application/json" -d "%json_dt%" http://127.0.0.1:5000/customers
if %ERRORLEVEL% NEQ 0 (
    echo An error occurred while adding the customer.
    pause
    goto add_ask
)

:add_ask
cls
echo ===============================
echo Do you want to continue adding?
echo Yes (1)
echo No (2)
echo ===============================

choice /c 12 /N
if %ERRORLEVEL% == 1 goto adding
if %ERRORLEVEL% == 2 goto main

rem View on the table
:reading
cls
echo =============================
echo SELECT THE FOLLOWING OPITONS
echo =============================
echo (1) Search a Customer
echo (2) Retrieve All Customers
echo (3) Display Customers Orders
echo (4) Back 
echo =============================
choice /c 1234 /N 

if %ERRORLEVEL% == 1 (
	goto :searching
)
if %ERRORLEVEL% == 2 (
	goto :show
)
if %ERRORLEVEL% == 3 (
	goto :order
)
if %ERRORLEVEL% == 4 (
	goto :main
)

rem Show all the and choose and format
:show 
cls
echo =========================
echo WHAT FORMAT DO YOU PREFER?
echo =========================
echo (1) XML
echo (2) JSON
echo (3) CANCEL
echo =========================
choice /c 123 /N 

if %ERRORLEVEL% == 1 (
    cls
    curl  -X GET http://127.0.0.1:5000/customers?format=xml
    pause
	goto reading
)
if %ERRORLEVEL% == 2 (
    cls
    curl  -X GET http://127.0.0.1:5000/customers
    pause
	goto reading
)
if %ERRORLEVEL% == 3 (
    goto :reading
)

rem Search a specific ID
:searching
cls
echo ============================
echo Enter ID to search
set /p "search_id=Customer ID: "
echo ============================

if "%search_id%"=="" (
    echo Customer ID can't be null/empty, try again.
    pause
    goto searching
)
echo =========================

rem if the input is valid
set /a valid_search=%search_id%
if %search_id% EQU %valid_search% (
    goto :frmt_srch
) else (
    echo Customer ID is Invalid
)

rem showing the search in a format chosen by the user
:frmt_srch
cls
echo =========================
echo WHAT FORMAT DO YOU PREFER?
echo =========================
echo (1) XML
echo (2) JSON
echo (3) CANCEL
echo =========================
choice /c 123 /N 
if %ERRORLEVEL% == 1 (
    curl  -X GET http://127.0.0.1:5000/customers/%search_id%?format=xml
    pause
	goto reading
)
if %ERRORLEVEL% == 2 (
    curl  -X GET http://127.0.0.1:5000/customers/%search_id%
    pause
	goto reading
)
if %ERRORLEVEL% == 3 (
    goto :searching
)

rem View the Orders
:order
echo ============================
echo Enter ID in orders
set /p "orders_id=Customer ID: "
echo ============================
if "%orders_id%"=="" (
    echo Customer ID can't be null/empty, try again.
    pause
    goto searching
)
echo =========================
set /a valid_order=%orders_id%
if %orders_id% EQU %valid_order% (
    goto frmt_ord
) else (
    echo Customer ID is Invalid
    pause
    goto order
)
rem Format of Orders
:frmt_ord
cls
echo =========================
echo WHAT FORMAT DO YOU PREFER?
echo =========================
echo (1) XML
echo (2) JSON
echo (3) CANCEL
echo =========================
choice /c 123 /N 
if %ERRORLEVEL% == 1 (
    curl  -X GET http://127.0.0.1:5000/customers/%orders_id%/orders?format=xml
    pause
	goto reading
)
if %ERRORLEVEL% == 2 (
    curl  -X GET http://127.0.0.1:5000/customers/%orders_id%/orders
    pause
	goto reading
)
if %ERRORLEVEL% == 3 (
    goto :order
)

rem Update something on the Table
:updating
cls
echo ============================
echo Enter ID to update
set /p "update_id=Customer ID: "
echo ============================
if "%update_id%"=="" (
    echo Customer ID can't be null/empty, try again.
    pause
    goto updating
)
echo =========================
set /a valid_up_id=%update_id%
if %update_id% EQU %valid_up_id% (
    goto verified_up
) else (
    echo Customer ID is Invalid
    pause
    goto updating
)

:verified_up
curl -X GET http://127.0.0.1:5000/customers/%update_id%
echo ============================
echo Do you want to update these?
echo Yes (1)
echo No (2)
echo ============================
choice /c 12 /n
if %ERRORLEVEL% == 1 goto detail_update
if %ERRORLEVEL% == 2 goto updating

:detail_update
echo ============================
echo Enter the Following Details:
echo ============================
set /p "comp=Company name: "
set /p "fst_nm=First name: "
set /p "lst_nm=Last name: "
set /p "job_t=Job title: "
set /p "addrs=Address: "
set /p "cty=City name: "
echo ===========================

if "%comp%"=="" (
    echo Company name shouldn't be empty
    pause
    goto detail_update
)
if "%fst_nm%"=="" (
    echo It needs a First name
    pause
    goto detail_update
)
if "%lst_nm%"=="" (
    echo It needs a Last name 
    pause
    goto detail_update
)

set "json_dt={\"company\":\"%comp%\",\"first_name\":\"%fst_nm%\",\"last_name\":\"%lst_nm%\",\"job_title\":\"%job_t%\",\"address\":\"%addrs%\",\"city\":\"%cty%\"}"

curl --fail -X PUT -H "Content-Type: application/json" -d "%json_dt%" http://127.0.0.1:5000/customers/%update_id%
if %ERRORLEVEL% NEQ 0 (
    echo An error occurred while updating the customer.
    pause
    goto update_ask
)
pause
goto update_ask

:update_ask
cls
echo =================================
echo Do you want to continue updating?
echo Yes (1)
echo No (2)
echo =================================
choice /c 12 /n
if %ERRORLEVEL% == 1 goto updating
if %ERRORLEVEL% == 2 goto main

rem Delete something on the table
:deleting
cls
echo ===========================
echo Enter the ID to delete
set /p "delete_id=Customer ID: "
echo ===========================
if "%delete_id%"=="" (
    echo Customer ID can't be null/empty, try again.
    pause
    goto deleting
)
set /a valid_deletion=%delete_id%
if %delete_id% EQU %valid_deletion% (
    goto del1
    
) else (
    echo Customer ID is Invalid.
    pause
    goto deleting
)

:del1
curl -X GET http://127.0.0.1:5000/customers/%delete_id%
echo ========================
echo Do you want to delete it?
echo Yes (1)
echo No (2)
echo ========================
choice /c 12 /N 
if %ERRORLEVEL% == 1 goto del2
if %ERRORLEVEL% == 2 goto deleting

:del2
curl -X DELETE http://127.0.0.1:5000/customers/%delete_id%
pause
cls
echo ========================
echo Do you want to continue?
echo Yes (1)
echo No (2)
echo ========================
choice /c 12 /N
if %ERRORLEVEL% == 1 goto deleting
if %ERRORLEVEL% == 2 goto main

:end
cls
echo You can now close the API window...
echo Thanks, See yah!
pause