# syntax=docker/dockerfile:1

FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1 \
PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates tini && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m mylistuser
WORKDIR /app
RUN mkdir -p /app/staticfiles && chown -R mylistuser:mylistuser /app

COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

COPY . /app
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R mylistuser:mylistuser /app
USER mylistuser
RUN python manage.py collectstatic --noinput || true

EXPOSE 8000
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["gunicorn", "mylist.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "60"]