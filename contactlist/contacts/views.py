# contacts/views.py
from rest_framework import viewsets, status
from rest_framework.filters import SearchFilter
from django.db.models import Q
from .models import Contact
from .serializers import ContactSerializer
from rest_framework.response import Response

class ContactViewSet(viewsets.ModelViewSet):
    queryset = Contact.objects.all()
    serializer_class = ContactSerializer
    filter_backends = [SearchFilter]
    search_fields = ['name', 'phone'] 

    # for editing the contact
    def update(self, request, pk=None):
        try:
            contact = Contact.objects.get(pk=pk)
        except Contact.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
        serializer = ContactSerializer(contact, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    # searching by filtering mechanism
    def get_queryset(self):
        queryset = super().get_queryset()
        search_query = self.request.query_params.get('search', None)
        if search_query:
            # Using Q to combine multiple conditions for name and phone
            queryset = queryset.filter(
                Q(name__icontains=search_query) | Q(phone__icontains=search_query)
            )
        return queryset