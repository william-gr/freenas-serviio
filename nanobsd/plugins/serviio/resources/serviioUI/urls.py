from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('',
     url(r'^plugins/serviio/', include('serviioUI.freenas.urls')),
)
