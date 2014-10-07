Email Service
========================
Create a service that accepts the necessary information and sends emails. It should provide an abstraction between two different email service providers. If one of the services goes down, your service can quickly failover to a different provider without affecting your customers.

Environment 
-------
django > 1.5  
python > 2.6
others refer to the requirement.txt

Local Set Up:
---------------------
Python environment set up:

   sudo apt-get install python python-pip python-mysqldb
  
Install Django and other relevant

    sudo pip install django  sendgrid-django pycurl flup importlib iniparse  mandrill smtpapi django-mailgun
    
UnZip my code

    tar xvvzf emailsyste.rar.gz
Run 

    python manage.py runserver 0.0.0.0:8000
    
Open http://127.0.0.1:8000 


Testrun 
--------
When you have installed all packages required just use: 
python manage.py runserver 0.0.0.0:<port> to start the service 



Configuraiton 
-------------------
You must register mailgun/sendgrid account, when you have had these accouts , you can get usefull info from the service provider 

edit  setting.py in your project:   

    vi settings.py   

then change the   


   SENDGRID_USER = "xxxx" 
   SENDGRID_PASSWORD = "xxxx"   
   MAILGUN_ACCESS_KEY = 'key-417d89915284b69a8c7aee6d03e5d6d0'   
   MAILGUN_SERVER_NAME = 'sandbox61b015c00c55431894a1d64bfdf0d01d.mailgun.org'   

to your <strong> own </strong> Decide which email-provider we choose


Switch provider
------------------
Now we support to providers : sendgrid and mailgun , both are perfect and free 
I default use sendgrid and can change to mailgun by manual when we access the web 
I provide there choices :
    auto     -- use sendgrid by default , and change to mailgun when something wrong is happened
    sendgrid -- use sendgrid 
    mailgun  -- use mailgun 


Multimail support 
-------------------------
I default support multimail when we fill in the to / bcc / cc, Just use ',' to separate
example :
   admin@gmail.com, test@gmail.com, jone@gmail.com ...


<h1> enjoy it </h1>




