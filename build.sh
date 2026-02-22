#!/usr/bin/env bash
set -o errexit

pip install -r requirements.txt
python manage.py collectstatic --no-input
python manage.py migrate
python manage.py shell -c "
from django.db import connection

with connection.cursor() as cursor:
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS librarian (
            librarian_id SERIAL PRIMARY KEY,
            name VARCHAR(50) NOT NULL,
            email VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(100) NOT NULL
        );
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            user_id SERIAL PRIMARY KEY,
            roll_no VARCHAR(20) UNIQUE NOT NULL,
            name VARCHAR(50) NOT NULL,
            batch VARCHAR(10),
            faculty VARCHAR(10),
            email VARCHAR(50) UNIQUE
        );
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS author (
            author_id SERIAL PRIMARY KEY,
            author_name VARCHAR(100) NOT NULL
        );
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS books (
            book_id SERIAL PRIMARY KEY,
            book_number VARCHAR(50) UNIQUE,
            title VARCHAR(100) NOT NULL,
            total_copies INT NOT NULL CHECK (total_copies >= 0),
            available_copies INT NOT NULL CHECK (available_copies >= 0),
            author_id INT,
            CONSTRAINT fk_author
                FOREIGN KEY (author_id)
                REFERENCES author(author_id)
                ON DELETE SET NULL
        );
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS semester (
            semester_id SERIAL PRIMARY KEY,
            semester_no INT NOT NULL,
            batch VARCHAR(10),
            faculty VARCHAR(10)
        );
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS book_semester (
            book_id INT,
            semester_id INT,
            PRIMARY KEY (book_id, semester_id),
            CONSTRAINT fk_book
                FOREIGN KEY (book_id)
                REFERENCES books(book_id)
                ON DELETE CASCADE,
            CONSTRAINT fk_semester
                FOREIGN KEY (semester_id)
                REFERENCES semester(semester_id)
                ON DELETE CASCADE
        );
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS issued_book (
            issue_id SERIAL PRIMARY KEY,
            issue_date DATE NOT NULL,
            return_date DATE,
            status VARCHAR(10),
            user_id INT,
            book_id INT,
            CONSTRAINT fk_user
                FOREIGN KEY (user_id)
                REFERENCES users(user_id)
                ON DELETE CASCADE,
            CONSTRAINT fk_issued_book
                FOREIGN KEY (book_id)
                REFERENCES books(book_id)
                ON DELETE CASCADE
        );
    ''')
    cursor.execute('''
        INSERT INTO librarian (name, email, password)
        VALUES ('Admin', 'admin@gmail.com', 'admin1234')
        ON CONFLICT (email) DO NOTHING;
    ''')
    cursor.execute('''
        INSERT INTO librarian (name, email, password)
        VALUES ('Bipin', 'bipin123@gmail.com', 'bipin123')
        ON CONFLICT (email) DO NOTHING;
    ''')
    print('All tables created and seed data inserted successfully!')
"