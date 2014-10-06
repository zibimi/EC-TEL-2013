#!/usr/bin/env python
# coding:utf-8

from django.shortcuts import render
from django.shortcuts import render_to_response
# Create your views here.
from django.http import HttpResponseRedirect
from django.core.mail import send_mail
from django.core.mail import EmailMultiAlternatives
from emailsystem.settings import *
from emailsystem import settings
from django.test.utils import override_settings


# example_project






def home(request):
    """index page ."""
    return render_to_response('index.html', {})



def send_email_using_sendgrid(request):
    """send emails """
    
    subject = request.POST.get("subject", default="EmailService")
    name = request.POST.get("name", default="")
    cc = request.POST.get("cc", default="")
    bcc = request.POST.get("bcc", default="")
    to = request.POST.get("to", default="")
    sender = request.POST.get("from", default="")
    text = request.POST.get("comments", default="")
    
    mail = EmailMultiAlternatives(
            subject=subject,
            body=text,
            from_email="%s<%s>" % (name, sender),
            to=to.split(','),
            cc=cc.split(','),
            bcc=bcc.split(','),
            headers={"Reply-To": "%s" % sender}
            )
    mail.send()

    
@override_settings(EMAIL_BACKEND=EMAIL_BACKEND_MAILGUN)
def send_email_using_mailgun(request):
    """send emails """
    subject = request.POST.get("subject", default="EmailService")
    name = request.POST.get("name", default="")
    cc = request.POST.get("cc", default="")
    bcc = request.POST.get("bcc", default="")
    to = request.POST.get("to", default="")
    sender = request.POST.get("from", default="")
    text = request.POST.get("comments", default="")
    
    mail = EmailMultiAlternatives(
            subject=subject,
            body=text,
            from_email="%s<%s>" % (name, sender),
            to=to.split(','),
            cc=cc.split(','),
            bcc=bcc.split(','),
            headers={"Reply-To": "%s" % sender}
            )
    mail.send()
    
    
    
def send_mail(request):
    """ """
    try:
        if request.method == 'POST' :
            a = request.POST.get("type", default="auto")
            if (a == 'auto' or a == 'sendgrid'):
                try:
                    send_email_using_sendgrid(request)
                except:
                    send_email_using_mailgun(request)   
            else :
                send_email_using_mailgun(request)  
            
            return render_to_response('status.html', {})
        else :
            raise Exception("Opertaion forbbiden")
    except Exception, e:
        return render_to_response('status.html', { "msg":"%s" % e})
    
    
    