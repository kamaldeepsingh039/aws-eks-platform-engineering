FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN python -m pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim AS runtime
WORKDIR /app

COPY --from=builder /install /usr/local

COPY app.py init_db.py ./

RUN useradd --create-home appuser

RUN python -m pip uninstall -y pip

USER appuser

EXPOSE 5000

CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "app:app" ]
