from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()
from emailsystem.apps.index.views import send_mail

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'emailsystem.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    url(r'^send_mail/', send_mail),
)
