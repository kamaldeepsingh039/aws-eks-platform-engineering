
import logging
import os
import sys

import psycopg2
from flask import Flask, redirect, render_template_string, request, url_for


# --------------------------------------------------
# Flask application
# --------------------------------------------------

app = Flask(__name__)


# --------------------------------------------------
# Application logging
# --------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
    stream=sys.stdout,
    force=True,
)

logger = logging.getLogger(__name__)


# --------------------------------------------------
# PostgreSQL connection
# --------------------------------------------------

def get_db_connection():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=int(os.environ.get("DB_PORT", "5432")),
        dbname=os.environ.get("DB_NAME", "postgres"),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        connect_timeout=3,
       sslmode=os.environ.get("DB_SSLMODE", "require"),
    )


# --------------------------------------------------
# Liveness and startup probes
# --------------------------------------------------

@app.route("/health")
def health():
    return "OK", 200


# --------------------------------------------------
# Readiness probe
# --------------------------------------------------

@app.route("/ready")
def ready():
    try:
        conn = get_db_connection()

        try:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1")
        finally:
            conn.close()

        return "Ready", 200

    except (psycopg2.Error, KeyError, ValueError) as error:
        logger.error(
            "operation=readiness_check status=failed error_type=%s",
            type(error).__name__,
        )
        return "Database unavailable", 503


# --------------------------------------------------
# Homepage - retrieve saved tasks
# --------------------------------------------------

@app.route("/", methods=["GET"])
def home():
    try:
        conn = get_db_connection()

        try:
            with conn.cursor() as cursor:
                cursor.execute(
                    "SELECT id, task_name FROM tasks ORDER BY id DESC"
                )
                tasks = cursor.fetchall()
        finally:
            conn.close()

    except (psycopg2.Error, KeyError, ValueError) as error:
        logger.error(
            "operation=list_tasks status=failed error_type=%s",
            type(error).__name__,
        )
        return "Database unavailable", 503

    return render_template_string(
        """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport"
                  content="width=device-width, initial-scale=1">
            <title>EKS Task Manager</title>
        </head>
        <body>
            <h1>AWS EKS Task Manager</h1>
            <p>Flask | Gunicorn | Kubernetes | PostgreSQL</p>

            <h2>Add a Task</h2>

            <form action="{{ url_for('add_task') }}" method="POST">
                <input
                    type="text"
                    name="task_name"
                    maxlength="200"
                    required
                >
                <button type="submit">Add Task</button>
            </form>

            <h2>Saved Tasks</h2>

            <ul>
                {% for task in tasks %}
                    <li>{{ task[1] }}</li>
                {% else %}
                    <li>No tasks yet.</li>
                {% endfor %}
            </ul>
        </body>
        </html>
        """,
        tasks=tasks,
    )


# --------------------------------------------------
# Create new task
# --------------------------------------------------

@app.route("/tasks", methods=["POST"])
def add_task():
    task_name = request.form.get("task_name", "").strip()

    if not task_name or len(task_name) > 200:
        logger.warning(
            "operation=create_task status=rejected reason=invalid_input"
        )
        return "Task must contain 1 to 200 characters", 400

    try:
        conn = get_db_connection()

        try:
            with conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO tasks (task_name) VALUES (%s)",
                        (task_name,),
                    )
        finally:
            conn.close()

    except (psycopg2.Error, KeyError, ValueError) as error:
        logger.error(
            "operation=create_task status=failed error_type=%s",
            type(error).__name__,
        )
        return "Unable to save task", 503

    logger.info(
        "operation=create_task status=success"
    )

    return redirect(url_for("home"), code=303)
