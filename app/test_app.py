from unittest.mock import patch
import unittest

from app import app


class FlaskAppTests(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_health_returns_200(self):
        response = self.client.get("/health")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_data(as_text=True), "OK")

    def test_empty_task_is_rejected(self):
        response = self.client.post(
            "/tasks",
            data={"task_name": "   "},
        )

        self.assertEqual(response.status_code, 400)

    def test_task_over_200_characters_is_rejected(self):
        response = self.client.post(
            "/tasks",
            data={"task_name": "A" * 201},
        )

        self.assertEqual(response.status_code, 400)


    @patch("app.get_db_connection", side_effect=KeyError("DB_HOST"))
    def test_readiness_when_database_unavailable(self, mock_connection):
        response = self.client.get("/ready")
        self.assertEqual(response.status_code, 503)
        mock_connection.assert_called_once()

    @patch("app.get_db_connection", side_effect=KeyError("DB_HOST"))
    def test_home_when_database_unavailable(self, mock_connection):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 503)
        mock_connection.assert_called_once()