#!/bin/bash

# 🏷️ Projektname und Appname abfragen
echo "🔧 Projektname (z. B. myproject):"
read -rp "▶️ " PROJECT_NAME

echo "🔧 App-Name (z. B. core):"
read -rp "▶️ " APP_NAME

# 📁 Verzeichnis anlegen und wechseln
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit 1

# 🐍 Virtuelle Umgebung
echo "🐍 Erstelle virtuelle Umgebung (.venv)..."
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

# 📦 Python-Pakete
echo "📦 Installiere Python-Abhängigkeiten..."
pip install django django-ninja django-jazzmin djangorestframework djangorestframework-simplejwt python-decouple

# 🚀 Django-Projekt & App
django-admin startproject "$PROJECT_NAME" .
python manage.py startapp "$APP_NAME"

# 🔧 settings.py anpassen
SETTINGS_FILE="${PROJECT_NAME}/settings.py"
sed -i '' "s/'django.contrib.staticfiles'/'django.contrib.staticfiles',\\
    'jazzmin',\\
    'rest_framework',\\
    '${APP_NAME}'/" "$SETTINGS_FILE"

cat <<EOF >> "$SETTINGS_FILE"

from decouple import config

SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)

STATIC_URL = '/static/'
STATICFILES_DIRS = [ BASE_DIR / 'static' ]
STATIC_ROOT = BASE_DIR / 'staticfiles'

LOGIN_URL = '/login/'
LOGIN_REDIRECT_URL = '/'
LOGOUT_REDIRECT_URL = '/login/'

TEMPLATES[0]['DIRS'] = [BASE_DIR / '${APP_NAME}' / 'templates']
EOF

# 📄 .env-Datei
echo "📄 Erstelle .env..."
echo "SECRET_KEY=$(openssl rand -base64 32)" > .env
echo "DEBUG=True" >> .env

# 📄 Templates & Templatetags
mkdir -p "$APP_NAME/templates"
mkdir -p "$APP_NAME/templatetags"

cat <<EOF > "$APP_NAME/templatetags/__init__.py"
# Templatetags init
EOF

cat <<EOF > "$APP_NAME/templatetags/form_tags.py"
from django import template
register = template.Library()

@register.filter(name='add_class')
def add_class(value, arg):
    return value.as_widget(attrs={'class': arg})
EOF

# 📄 base.html mit Bootstrap via CDN
cat <<EOF > "$APP_NAME/templates/base.html"
<!doctype html>
<html lang="de">
<head>
  <meta charset="utf-8">
  <title>{% block title %}${PROJECT_NAME}{% endblock %}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-light bg-light px-3">
    <a class="navbar-brand" href="#">${PROJECT_NAME}</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        {% if user.is_authenticated %}
          <li class="nav-item"><a class="nav-link" href="{% url 'logout' %}">Logout</a></li>
        {% endif %}
      </ul>
    </div>
  </nav>
  <div class="container mt-4">
    {% block content %}{% endblock %}
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoHkI6tztD9Gq6nICpJwE1lK5Nq8EuzMdUOY6Ck+4hnXWvN" crossorigin="anonymous"></script>
</body>
</html>
EOF

# 📄 login.html mit Card, Glassy Style
cat <<EOF > "$APP_NAME/templates/login.html"
{% extends "base.html" %}
{% load form_tags %}
{% block title %}Login{% endblock %}
{% block content %}
<div class="d-flex justify-content-center align-items-center" style="min-height: 80vh;">
  <div class="card shadow-lg p-4" style="backdrop-filter: blur(10px); background: rgba(255,255,255,0.6); border-radius: 1rem; width: 100%; max-width: 400px;">
    <div class="card-body">
      <h3 class="card-title text-center mb-4">Login</h3>
      <form method="post">
        {% csrf_token %}
        <div class="mb-3">
          <label for="id_username" class="form-label">Benutzername</label>
          {{ form.username|add_class:"form-control" }}
        </div>
        <div class="mb-3">
          <label for="id_password" class="form-label">Passwort</label>
          {{ form.password|add_class:"form-control" }}
        </div>
        <button type="submit" class="btn btn-primary w-100">Einloggen</button>
      </form>
    </div>
  </div>
</div>
{% endblock %}
EOF

# 📄 index.html nach Login
cat <<EOF > "$APP_NAME/templates/index.html"
{% extends "base.html" %}
{% block title %}Dashboard{% endblock %}
{% block content %}
<h1>Willkommen, {{ user.username }}!</h1>
<p>Dies ist deine Startseite nach dem Login.</p>
{% endblock %}
EOF

# 📄 views.py
cat <<EOF > "$APP_NAME/views.py"
from django.contrib.auth.decorators import login_required
from django.shortcuts import render

@login_required
def index(request):
    return render(request, "index.html")
EOF

# 📄 app/urls.py
cat <<EOF > "$APP_NAME/urls.py"
from django.urls import path
from .views import index

urlpatterns = [
    path('', index, name='index'),
]
EOF

# 📄 project/urls.py
cat <<EOF > "$PROJECT_NAME/urls.py"
from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('${APP_NAME}.urls')),
    path('login/', auth_views.LoginView.as_view(template_name='login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='login'), name='logout'),
]
EOF

# 🛠 Migration & Superuser
python manage.py migrate
echo "🧑‍💻 Lege Superuser admin/admin an..."
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell

# 📦 Git-Tipp
echo
echo "✅ Projekt '${PROJECT_NAME}' mit App '${APP_NAME}' erfolgreich erstellt."
echo "👉 Starte mit: source .venv/bin/activate && python manage.py runserver"
echo "📦 Git-Tipp: git init && git add . && git commit -m 'Initial commit: ${PROJECT_NAME}'"
