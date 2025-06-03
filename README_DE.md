
# 🚀 Django Projekt-Setup Script

Dieses Bash-Skript automatisiert die Initialisierung eines Django-Projekts mit einer App-Struktur, grundlegender Benutzerverwaltung (Login/Logout), Templating mit Bootstrap, Admin-Oberfläche via Jazzmin und einem initialen `index.html`. Ziel ist es, eine sofort einsatzfähige Projektbasis für die Entwicklung von Django-Anwendungen bereitzustellen.

---

## 🛠 Script Berechtigung

Bevor man das `setup.sh` script ausführen kann, muss man die korrekten Berechtigungen setzen:

```bash
chmod +x setup.sh
```

Dadurch wird das Script ausführbar. Das Script wird ausgeführt durch:

```bash
./setup.sh
```

---

## 📁 Projektstruktur

Nach Ausführung des Skripts ergibt sich folgende Struktur:

```
/<projektname>
├── .venv/                      # Virtuelle Umgebung
├── .env                        # Umgebungsvariablen (SECRET_KEY, DEBUG)
├── manage.py
├── <projektname>/             # Django-Projektverzeichnis
│   ├── settings.py            # Django-Konfiguration (angepasst)
│   ├── urls.py                # Haupt-URL-Konfiguration
├── <appname>/                 # Django-App
│   ├── templates/
│   │   ├── base.html          # Basislayout mit Bootstrap
│   │   ├── login.html         # Login-Seite im Glassy Style
│   │   └── index.html         # Dashboard nach Login
│   ├── views.py               # View-Funktion für das Dashboard
│   ├── urls.py                # App-eigene URL-Konfiguration
│   ├── templatetags/
│   │   ├── __init__.py
│   │   └── form_tags.py       # Filter zur CSS-Klassen-Erweiterung von Formularfeldern
```

---

## 🧩 Installierte Pakete & Funktionen

| Paket | Zweck |
|-------|-------|
| `Django` | Basisframework für Webentwicklung |
| `django-ninja` | Moderne API-Unterstützung mit Pydantic |
| `django-jazzmin` | Ersetzt das Admin-UI durch ein modernes Dashboard |
| `djangorestframework` | REST API Unterstützung (noch nicht aktiviert) |
| `djangorestframework-simplejwt` | Token-basierte Authentifizierung mit JWT |
| `python-decouple` | Trennt sensible Konfigurationswerte aus `settings.py` |

---

## 🔐 Authentifizierung

### 🔸 Login/Logout
- Nutzt das Standard-`auth`-System von Django.
- Implementiert `LoginView` & `LogoutView` mit angepasstem `login.html`-Template.
- Authentifizierte Nutzer werden nach Login auf die `index`-Seite weitergeleitet.

### 🔸 Zugriffsschutz
- `@login_required` schützt Views (z. B. das Dashboard).
- `LOGIN_URL`, `LOGIN_REDIRECT_URL` und `LOGOUT_REDIRECT_URL` sind in den Einstellungen vorkonfiguriert.

### 🔸 Admin-Login
- Beim Setup wird automatisch ein Superuser `admin` mit Passwort `admin` erstellt.

---

## 🌐 URLs

```text
/           →  Index-Seite nach Login
/login/     →  Login-Seite
/logout/    →  Logout mit Redirect zum Login
/admin/     →  Django Admin (Jazzmin UI)
```

---

## 🛠 Templating mit Bootstrap

- `base.html` enthält das Grundlayout mit Bootstrap 5 via CDN.
- `login.html` verwendet einen "Glassy Card Style" mit Schatten und `backdrop-filter`.
- Die Custom Template Tags (`add_class`) erlauben einfaches Styling von Formularfeldern.

---

## ⚙️ Konfiguration

### `.env`

Die Datei `.env` enthält:
```env
SECRET_KEY=...
DEBUG=True
```

Diese wird in `settings.py` mittels `python-decouple` eingebunden:
```python
from decouple import config
SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
```

---

## 🧪 Erste Schritte nach Ausführung

```bash
cd <projektname>
source .venv/bin/activate
python manage.py runserver
```

Admin Login:
- Benutzername: `admin`
- Passwort: `admin`

---

## ✅ Zusätzliche Hinweise

- Die REST API ist vorbereitet, aber noch nicht konfiguriert (`django-ninja` & `drf`).
- Weitere Apps können einfach mit `python manage.py startapp neue_app` ergänzt werden.
- Templates werden im App-Ordner zentral verwaltet: `<appname>/templates/`.

---

## 📦 Git Setup

```bash
git init
git add .
git commit -m "Initial commit: <projektname>"
```

---

## 🧩 Je nach Projekttyp:

- Einbindung von JWT-Login via `simplejwt`
- Integration von `django-ninja` API-Endpunkten
- CI/CD für automatisiertes Deployment
- User-Management-Views (Registrierung, Passwort-Reset)

---
