"""
Django settings for emailsystem project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'n$-vq$54%=^lu6blb&m6ca18f3&0f9i(m0g^_7v*j*^--za0y4'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'emailsystem.apps.index',
    'emailsystem.apps.mailgun',
    'emailsystem.apps.sendgrid',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    #'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'emailsystem.urls'

WSGI_APPLICATION = 'emailsystem.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/


DEFAULT_CONTENT_TYPE = 'text/html'
DEFAULT_CHARSET = 'utf-8'

STATIC_URL = '/st/'
LOGIN_URL = '/'


MEDIA_ROOT = BASE_DIR + '/emailsystem/media/'
MEDIA_URL = '/media/'


STATIC_DIR1 = BASE_DIR + '/emailsystem/static/'
STATICFILES_DIRS = (
    STATIC_DIR1,
)

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
#     'django.template.loaders.eggs.Loader',
)


TEMPLATE_DIR = BASE_DIR + '/emailsystem/template'
# TEMPLATE_DIRS
TEMPLATE_DIRS = (
    TEMPLATE_DIR,
)



EMAIL_BACKEND_SENDGRID = "sgbackend.SendGridBackend"
EMAIL_BACKEND_MAILGUN = 'django_mailgun.MailgunBackend'

EMAIL_BACKEND = EMAIL_BACKEND_SENDGRID

SENDGRID_USER = "goldenhunter"
SENDGRID_PASSWORD = "5460trlove"


MAILGUN_ACCESS_KEY = 'key-417d89915284b69a8c7aee6d03e5d6d0'
MAILGUN_SERVER_NAME = 'sandbox61b015c00c55431894a1d64bfdf0d01d.mailgun.org'
    



