from rest_framework import viewsets
from .models import Contact
from .serializers import ContactSerializer


class ContactViewSet(viewers.ModelViewSet):
    queryset = Contact.objects.all()
    serializer_class = ContactSerializer

    