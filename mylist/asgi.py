"""
ASGI config for mylist project.
"""

import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mylist.settings')

application = get_asgi_application()

# Vercel expects `app` or `handler`
app = application
