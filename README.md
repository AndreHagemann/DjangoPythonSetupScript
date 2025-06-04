
# 🚀 Django Project Setup Script

This Bash script automates the initialization of a Django project with an app structure, basic user authentication (login/logout), templating using Bootstrap, an admin interface via Jazzmin, and an initial `index.html`. The goal is to provide a ready-to-use project foundation for Django development.

---

## 🛠 Script Permissions

Before running the `setup.sh` script, ensure it has the correct permissions:

```bash
chmod +x setup.sh
```

This makes the script executable. You can then run it using:

```bash
./setup.sh
```

---

## 📁 Project Structure

After running the script, the following structure is generated:

```
/<projectname>
├── .venv/                      # Virtual environment
├── .env                        # Environment variables (SECRET_KEY, DEBUG)
├── manage.py
├── <projectname>/             # Django project directory
│   ├── settings.py            # Django configuration (modified)
│   ├── urls.py                # Main URL configuration
├── <appname>/                 # Django app
│   ├── templates/
│   │   ├── base.html          # Base layout with Bootstrap
│   │   ├── login.html         # Login page with glassy style
│   │   └── index.html         # Dashboard after login
│   ├── views.py               # View function for the dashboard
│   ├── urls.py                # App-specific URL configuration
│   ├── templatetags/
│   │   ├── __init__.py
│   │   └── form_tags.py       # Filter to add CSS classes to form fields
```

---

## 🧩 Installed Packages & Features

| Package | Purpose |
|--------|---------|
| `Django` | Core framework for web development |
| `django-ninja` | Modern API support using Pydantic |
| `django-jazzmin` | Replaces Django Admin UI with a modern dashboard |
| `djangorestframework` | REST API support (not yet enabled) |
| `djangorestframework-simplejwt` | Token-based authentication via JWT |
| `python-decouple` | Separates sensitive config values from `settings.py` |

---

## 🔐 Authentication

### 🔸 Login/Logout
- Uses Django's standard `auth` system.
- Implements `LoginView` & `LogoutView` with a custom `login.html` template.
- Authenticated users are redirected to the `index` page after login.

### 🔸 Access Protection
- Views like the dashboard are protected with `@login_required`.
- `LOGIN_URL`, `LOGIN_REDIRECT_URL`, and `LOGOUT_REDIRECT_URL` are preconfigured.

### 🔸 Admin Login
- A superuser `admin` with password `admin` is created automatically during setup.

---

## 🌐 URLs

```text
/           →  Index page after login
/login/     →  Login page
/logout/    →  Logout with redirect to login
/admin/     →  Django admin (Jazzmin UI)
```

---

## 🛠 Templating with Bootstrap

- `base.html` includes the base layout with Bootstrap 5 via CDN.
- `login.html` uses a "glassy card style" with shadow and `backdrop-filter`.
- The custom template tag (`add_class`) allows easy styling of form fields.

---

## ⚙️ Configuration

### jazzmin
be sure to set the jazzmin entry in settings.py above django.contrib.admin

### `.env`

The `.env` file contains:
```env
SECRET_KEY=...
DEBUG=True
```

It's loaded in `settings.py` via `python-decouple`:
```python
from decouple import config
SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
```

---

## 🧪 Getting Started After Setup

```bash
cd <projectname>
source .venv/bin/activate
python manage.py runserver
```

Admin login:
- Username: `admin`
- Password: `admin`

---

## ✅ Additional Notes

- REST API is prepared but not yet configured (`django-ninja` & `drf`).
- Additional apps can be added via `python manage.py startapp new_app`.
- Templates are stored centrally within the app: `<appname>/templates/`.

---

## 📦 Git Setup

```bash
git init
git add .
git commit -m "Initial commit: <projectname>"
```

---

## 🧩 Depending on the Project Type

- Integrate JWT login using `simplejwt`
- Add `django-ninja` API endpoints
- CI/CD for automated deployment
- User management views (registration, password reset)

---
