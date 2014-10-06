from django.conf.urls import patterns, include, url

from django.contrib import admin
import emailsystem
from emailsystem.apps.index import urls

admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'emailsystem.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^$', 'emailsystem.apps.index.views.home', name='home'),
    url(r'^api/', include(emailsystem.apps.index.urls)),
)
