from django.urls import path
from . import views

urlpatterns = [
    # 1. This maps the root URL (/) to the login view so it shows first
    path('', views.librarian_login, name='index'), 

    # 2. Authentication
    path('login/', views.librarian_login, name='librarian_login'),

    # 3. Student Management
    path('add-student/', views.add_student, name='add_student'),
    path('search-student/', views.search_student, name='search_student'),
    path('remove-student/', views.remove_student, name='remove_student'),

    # 4. Book Management
    path('add-book/', views.add_book, name='add_book'),
    path('search-book/', views.search_book, name='search_book'),

    # 5. Transactions
    path('issue-book/', views.issue_book, name='issue_book'),
    path('return-book/', views.return_book, name='return_book'),

    # 6. Statistics
    path('dashboard-stats/', views.dashboard_stats, name='dashboard_stats'),
]