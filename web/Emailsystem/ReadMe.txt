Hi,
I finished the ‘Email Engine’ with using python and Django. I have a little problem for my own server (Godaddy), so I used my friend server to host. I will fix it as soon as possible. Here is the link: http://203.195.147.116:8090/

1.Environment:
  django > 1.5  
  python > 2.6

2.Local Set Up:
  2.1 Python environment set up:
    sudo apt-get install python python-pip python-mysqldb
  2.2 Install Django and other relevant 
    sudo pip install django  sendgrid-django pycurl flup importlib iniparse  mandrill smtpapi django-mailgun 
  2.3 UnZip my code
    tar xvvzf emailsyste.rar.gz
  2.4 Run 
    python manage.py runserver 0.0.0.0:8000
  2.5 
    Open http://127.0.0.1:8000 

3.Test run:
  When you have installed all packages required just use:  
  python manage.py runserver 0.0.0.0:<port> to start the service 

4.Configuration:
  You must register mailgun/sendgrid account   
  When you have hada these accouts , you can get usefull info from the service provider 
  Edit setting.py in your project:   
    vi settings.py   
  Then change the   
    SENDGRID_USER = "xxxx"   
    SENDGRID_PASSWORD = "xxxx"   
    MAILGUN_ACCESS_KEY = 'key-417d89915284b69a8c7aee6d03e5d6d0'   
    MAILGUN_SERVER_NAME = 'sandbox61b015c00c55431894a1d64bfdf0d01d.mailgun.org'   
  To your own
  Decide which email-provider we choose

5.Switch provider
  Now we support to providers: sendgrid and maligun, both are perfect and free 
  I default use sendgrid and can change to mailgun by manual when we access the web 
  I provide these choices:
    auto -- use sendgrid by default , and change to mailgun when something wrong is happened
    sendgrid -- use sendgrid 
    mailgun -- use mailgun 

6.Multi-mail support 
  We default support multimail when we fill in the to / bcc / cc, just use ',' to separate
  Example:
    admin@gmail.com, test@gmail.com, jone@gmail.com ...

Thanks

