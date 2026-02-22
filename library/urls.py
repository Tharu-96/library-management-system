from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.librarian_login, name='librarian_login'),
    path('add-student/', views.add_student, name='add_student'),
    path('search-student/', views.search_student, name='search_student'),
    path('remove-student/', views.remove_student, name='remove_student'),
    path('add-book/', views.add_book, name='add_book'),
    path('search-book/', views.search_book, name='search_book'),
    path('issue-book/', views.issue_book, name='issue_book'),
    path('return-book/', views.return_book, name='return_book'),
    path('dashboard-stats/', views.dashboard_stats, name='dashboard_stats'),
]