import os
import platform
import pwd

from django.utils.translation import ugettext_lazy as _

from dojango import forms
from serviioUI.freenas import models, utils


class ServiioForm(forms.ModelForm):

    class Meta:
        model = models.Serviio
        #widgets = {
        #    'admin_pw': forms.widgets.PasswordInput(),
        #}
        exclude = (
            'enable',
            )

    def __init__(self, *args, **kwargs):
        self.jail = kwargs.pop('jail')
        super(ServiioForm, self).__init__(*args, **kwargs)

        #if self.instance.admin_pw:
        #    self.fields['admin_pw'].required = False

    def save(self, *args, **kwargs):
        obj = super(ServiioForm, self).save(*args, **kwargs)

        rcconf = os.path.join(utils.serviio_etc_path, "rc.conf")
        with open(rcconf, "w") as f:
            if obj.enable:
                f.write('serviio_enable="YES"\n')

            #serviio_flags = ""
            #for value in advanced_settings.values():
            #    serviio_flags += value + " "
            #f.write('serviio_flags="%s"\n' % (serviio_flags, ))

        os.system(os.path.join(utils.serviio_pbi_path, "tweak-rcconf"))
