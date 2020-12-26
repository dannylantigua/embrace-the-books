# productDatabase.xml
Under WEB-INF
products go under the product path. e.g. workerscomp

The artifact type is loosely related to a folder (e.g. tdf is definitions folder).

#workersCompCommons.xml
Looked up using page id that was referenced in the productDatabase.xml

This has multiple page ids

Elements cannot be directly under the page id, but must be  nested inside a page element.

#framework.properties
transaction_file_manager_mode=dynamic

Change it to cached in production, leave at dynamic for development.

pass it in as VM argument (-D)

client_debug=true 

Leave as true for devlopment, change to false in prod.



