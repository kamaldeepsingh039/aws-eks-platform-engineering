
from app import get_db_connection


def initialize_database():
    conn = get_db_connection()

    try:
        with conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    CREATE TABLE IF NOT EXISTS tasks (
                        id SERIAL PRIMARY KEY,
                        task_name VARCHAR(200) NOT NULL,
                        created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
                    )
                """)

        print("Database table initialized successfully")

    finally:
        conn.close()


if __name__ == "__main__":
    initialize_database()
