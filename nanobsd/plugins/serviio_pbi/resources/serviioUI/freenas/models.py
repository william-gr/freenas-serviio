from django.db import models


class Serviio(models.Model):
    """
    Django model describing every tunable setting for serviio
    """

    enable = models.BooleanField(default=False)
