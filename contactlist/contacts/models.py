from django.shortcuts import render
from django.db import models

# Create your views here.

class Contact(models.Model):
    name = models.CharField(max_length = 100)
    phone = models.CharField(max_length=15)
    email = models.EmailField(max_length=100, blank=True, null=True) #allows the django database to 
    
    def __str__(self):
        return self.name
    