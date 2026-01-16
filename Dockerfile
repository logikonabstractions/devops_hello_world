FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# non-root user
RUN adduser --disabled-password --gecos "" --uid 10001 appuser
USER appuser
# make sure appuser is owner
COPY --chown=appuser:appuser app ./app
EXPOSE 8000

#
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/', timeout=2).read()" || exit 1


CMD ["gunicorn", "-b", "0.0.0.0:8000", "app.main:app"]
