fatecsp-alp
===========

Contains programs of discipline Algorithm and Logic Programming (Banin's Teacher) from Analysis and System Development of FATEC-SP

#T1 - Product Generator
## Description
Two programs need to be created inside one, they will basically:
* Request input from user to create N products and save it into one text file (user will tell how much products he wants).
* Requests from user to generate Z random sells, using products from file previously created, and save all into one other file.

### Product and Sells Files
Product and sells files are basically CSV (comma-separated value).
* Product content
  * Product Code
  * Product Description
  * Product Price

* Sell content
  * Product Code
  * Datetime of sell
  * Quantity
  * Total price

## Program Files
* DateTimeUtils.pas - Contains functions to handle with time and gets random time information. They are: 
  * function IsLeapYear(year : integer) : boolean; - This function verifies if given year is a bissext year (or leap year).
  * function IsMonth(number : integer) : boolean; - This function verifies if number given is between 1 and 12, including 1 and 12.
  * function GenerateRandomDay (month : integer) : integer; - This function receives one month and gets one random day of given month.
  * function GetsQuantityOfDays (month: integer; year: integer); - This function retrieves the quantity of days of given month of given year.
  * function RequestMonthNumber (message: string) : integer; - This function print message into console and returns one integer that represents one month. This integer can be only between 1 and 12, including 1 and 12. While user don't input a valid month number, this function stays in loop.

* ProductHandler.pas - Contains user interface to handle with products. The following functions are inside this file:
  * DisplaySelectedMenu - This procedure receives one number of menu and shows menu associated to given number.
  * ShowConsultProduct - Shows menu to consult products (NOT IMPLEMENTED YET)
  * ShowDeleteProduct - Shows menu to delete product (NOT IMPLEMENTED YET)
  * ShowProductMenu - This is the main menu of product screen, it's shows to user options to consult, register, delete or come back to main menu.
  * ShowRegisterProduct - Show menu to user register new product (NOT IMPLEMENTED YET)
* ProductUtils.pas - Contains struct of Product and all utilities functions to handle with products. They are:
  * function ParseProduct(productInfo : SplitedText) : Product; - This function receive of string and parse it into record of Product (code, description and price)
  * function GetsProducts(filePath : String[255]) : Products; - This function gets all product lines from given file.

  * function LineIsValid(line : String[255]): boolean; - Verify, accordinaly to Product File business rule, if a line is not comment.

  * procedure PrintProducts(productsArray : Products); - Receives an array of Products and print it all, exposing code, description and price.

* StringUtils.pas - Contains functions to handle with strings. They are:
  * function StrToReal (s: String): Real; - This function receives one string that contains one real number and returns the real number in type Real.
  * function Split(textToSplit : String[255]; separatorChar : char) : SplitedText; - This function has two parameters, one string and one separator char. This breaks the string into one array of strings using the separator char. For example, if string is "1234;Any Text;12.5" and separator char is ';', the return will be an array with the following contents (just remember that they all are strings)
:
     1. "1234"
     2. "Any Text"
     3. "12.5"
  * function StringIsEmpty(textToVerify : String[255]) : boolean; - Verify if an given string is empty. This is very usefull for array of strings where you don't know what position has string assigned or not.
  * function StringStartsWith(stringToVerify: string[255]; startChar : char) : boolean; - Verify if given string starts with given character.

* TestGenerator.pas - This is the main file of project, it's executes all code to generate tests.
