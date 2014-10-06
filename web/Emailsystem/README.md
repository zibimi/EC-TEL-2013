Email Service
========================
Send Your Mail Freely 

Environment 
-------
django > 1.5  

python > 2.6

others refer to the requirement.txt


testrun 
--------

when you have installed all packages required just use:  
python manage.py runserver 0.0.0.0:<port> to start the service 



configuraiton 
-------------------

you must register mailgun/sendgrid account   

when you have had these accouts , you can get usefull info from the service provider 

edit  setting.py in your project:   

    vi settings.py   


then change the   

   SENDGRID_USER = "xxxx"   
   SENDGRID_PASSWORD = "xxxx"   
   MAILGUN_ACCESS_KEY = 'key-417d89915284b69a8c7aee6d03e5d6d0'   
   MAILGUN_SERVER_NAME = 'sandbox61b015c00c55431894a1d64bfdf0d01d.mailgun.org'   

to your <strong> own </strong>

decide which email-provider we choose




switch provider
------------------
 
now we support to providers : sendgrid and mailgun , both are perfect and free 

we default use sendgrid and can change to mailgun by manual when we access the web 

we provide there choices :
    auto     -- use sendgrid by default , and change to mailgun when something wrong is happened
	sendgrid -- use sendgrid 
	mailgun  -- use mailgun 



multimail support 
-------------------------

we default support multimail when we fill in the to / bcc / cc 

just use ',' to separate


example :
   admin@gmail.com, test@gmail.com, jone@gmail.com ...



<h1> enjoy it </h1>




