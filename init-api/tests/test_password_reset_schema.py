import unittest

from pydantic import ValidationError

from app.schemas.password_reset import PasswordResetConfirm, PasswordResetRequest


class PasswordResetSchemaTests(unittest.TestCase):
    def test_six_ascii_digits_are_required(self):
        for code in ["12345", "1234567", "abcdef", "１２３４５６", "123456\n"]:
            with self.subTest(code=code), self.assertRaises(ValidationError):
                PasswordResetConfirm(email="test@example.com", code=code,
                                     new_password="test-password")

    def test_bcrypt_utf8_byte_boundary(self):
        PasswordResetConfirm(email="test@example.com", code="123456",
                             new_password="я" * 36)
        with self.assertRaises(ValidationError):
            PasswordResetConfirm(email="test@example.com", code="123456",
                                 new_password="я" * 37)

    def test_bad_email_and_unknown_language_are_rejected(self):
        with self.assertRaises(ValidationError):
            PasswordResetRequest(email="not-an-address")
        with self.assertRaises(ValidationError):
            PasswordResetRequest(email="test@example.com", language="unknown")

    def test_supported_locales_and_plus_addressing(self):
        for language in ["ru", "en", "es", "pt", "fr", "de", "zh", "hi", "ar"]:
            request = PasswordResetRequest(email="test+recovery@example.com", language=language)
            self.assertEqual(request.language, language)


if __name__ == "__main__":
    unittest.main()
