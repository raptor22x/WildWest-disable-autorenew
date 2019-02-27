# WildWest-disable-autorenew
Disables Auto-renew on the specified domains provided in a separate file.

Since GoDaddy has deprecated the SOAP API for any domains under the WildWest Resellers account, I have created this small script
to process a batch number of domains that need to have the auto-renew option to be disabled.

Simply run the script and provide the filename or path to the file which contains one domain per line.

example: ./disable_ww_autorenew.sh domainList.txt


If any of the domains have an issue, it will write the error to a log file named after the domain. 
