# db_compare

**this is just a demo**

1. the script is used to compare the record counts between different databases.
2. thanks to activerecord ,it makes possible to compare regardless the type of database.
3. thanks more to ruby, it makes possible to create dynamic class according to the table name which need to be compare, so all
   i need to do is just write them into config file.

so this script helps me to make sure the data integration bewteen database , and i don't have to write huge amount of sql to sync
up. 

but the limitation is also obvious , the tables should have similar structure and some same columns, so that it can process 
in one time. 

just as i commented in the header, this is just demo for basic usage, it need more enhancement to be a common data base compare 
tool
