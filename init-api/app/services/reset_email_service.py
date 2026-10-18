import base64
import smtplib
import ssl
import threading
import time
from email.message import EmailMessage
from email.utils import formataddr, formatdate, make_msgid

import httpx

from app.config.settings import settings


class EmailDeliveryError(Exception):
    """Sanitized error: never attach provider responses or credentials."""


MESSAGES = {
    "ru": ("Не потратил — восстановление пароля", "Код для сброса пароля: {code}\n\nОн действует 10 минут и используется один раз. Никому не сообщайте код. Если вы не запрашивали сброс, просто проигнорируйте письмо. Ваш пароль не изменится."),
    "en": ("Not Spent — reset your password", "Your password reset code: {code}\n\nIt expires in 10 minutes and can be used once. Do not share it. If you did not request this, ignore this email. Your password will not change."),
    "es": ("Not Spent — restablecer contraseña", "Código para restablecer la contraseña: {code}\n\nCaduca en 10 minutos y solo se usa una vez. No lo compartas. Si no lo solicitaste, ignora este correo. Tu contraseña no cambiará."),
    "pt": ("Not Spent — redefinir senha", "Código para redefinir a senha: {code}\n\nExpira em 10 minutos e só pode ser usado uma vez. Não compartilhe. Se não solicitou, ignore este email. Sua senha não mudará."),
    "fr": ("Not Spent — réinitialiser le mot de passe", "Code de réinitialisation : {code}\n\nIl expire dans 10 minutes et est à usage unique. Ne le partagez pas. Si vous n’avez rien demandé, ignorez ce message. Votre mot de passe ne changera pas."),
    "de": ("Not Spent — Passwort zurücksetzen", "Dein Code zum Zurücksetzen: {code}\n\nEr ist 10 Minuten gültig und nur einmal nutzbar. Nicht weitergeben. Falls du dies nicht angefordert hast, ignoriere diese E-Mail. Dein Passwort bleibt unverändert."),
    "zh": ("Not Spent — 重置密码", "密码重置验证码：{code}\n\n验证码10分钟内有效，仅可使用一次。请勿透露给他人。如果并非你本人请求，请忽略此邮件，你的密码不会改变。"),
    "hi": ("Not Spent — पासवर्ड रीसेट", "पासवर्ड रीसेट कोड: {code}\n\nयह 10 मिनट तक मान्य है और केवल एक बार इस्तेमाल हो सकता है। इसे साझा न करें। अगर आपने अनुरोध नहीं किया, तो इस ईमेल को अनदेखा करें। आपका पासवर्ड नहीं बदलेगा।"),
    "ar": ("Not Spent — إعادة تعيين كلمة المرور", "رمز إعادة تعيين كلمة المرور: {code}\n\nصالح لمدة 10 دقائق ولمرة واحدة فقط. لا تشاركه. إن لم تطلب ذلك، تجاهل الرسالة ولن تتغير كلمة مرورك."),
}


class ResetEmailService:
    def __init__(self):
        self._token = None
        self._expires = 0
        self._lock = threading.Lock()

    @property
    def configured(self):
        if not settings.password_reset_enabled:
            return False
        if settings.password_reset_provider == "smtp":
            return bool(settings.smtp_host.strip() and settings.smtp_username
                        and settings.smtp_password.get_secret_value()
                        and settings.smtp_sender_email == settings.smtp_username)
        return bool(settings.gmail_client_id
                    and settings.gmail_client_secret.get_secret_value()
                    and settings.gmail_refresh_token.get_secret_value())

    def _access_token(self, client, refresh=False):
        with self._lock:
            if not refresh and self._token and time.monotonic() < self._expires:
                return self._token
            response = client.post("https://oauth2.googleapis.com/token", data={
                "client_id": settings.gmail_client_id,
                "client_secret": settings.gmail_client_secret.get_secret_value(),
                "refresh_token": settings.gmail_refresh_token.get_secret_value(),
                "grant_type": "refresh_token",
            })
            if response.status_code != 200:
                raise EmailDeliveryError("oauth")
            data = response.json()
            token = data.get("access_token")
            if not isinstance(token, str) or not token:
                raise EmailDeliveryError("oauth")
            self._token = token
            self._expires = time.monotonic() + max(0, int(data.get("expires_in", 3600)) - 60)
            return token

    def send_reset(self, recipient, code, language):
        if not self.configured:
            raise EmailDeliveryError("configuration")
        subject, body = MESSAGES.get(language, MESSAGES["en"])
        message = EmailMessage()
        sender = (settings.smtp_sender_email if settings.password_reset_provider == "smtp"
                  else settings.gmail_sender_email)
        message["From"] = formataddr(("Not Spent", str(sender)))
        message["To"] = recipient
        message["Subject"] = subject
        message["Content-Language"] = language
        message["Date"] = formatdate(localtime=False, usegmt=True)
        message["Message-ID"] = make_msgid(domain=str(sender).rsplit("@", 1)[1])
        message.set_content(body.format(code=code))
        if settings.password_reset_provider == "smtp":
            self._send_smtp(message, str(sender), recipient)
            return
        raw = base64.urlsafe_b64encode(message.as_bytes()).decode("ascii")
        with httpx.Client(timeout=15, follow_redirects=False) as client:
            for attempt in range(2):
                token = self._access_token(client, refresh=attempt == 1)
                response = client.post("https://gmail.googleapis.com/gmail/v1/users/me/messages/send",
                    headers={"Authorization": f"Bearer {token}"}, json={"raw": raw})
                if response.status_code == 401 and attempt == 0:
                    continue
                if response.status_code != 200:
                    # Do not retry uncertain deliveries or include the MIME body.
                    raise EmailDeliveryError("send")
                return


    def _send_smtp(self, message, sender, recipient):
        client = None
        try:
            context = ssl.create_default_context()
            if settings.smtp_security == "ssl":
                client = smtplib.SMTP_SSL(settings.smtp_host.strip(), settings.smtp_port,
                                          timeout=15, context=context)
            else:
                client = smtplib.SMTP(settings.smtp_host.strip(), settings.smtp_port, timeout=15)
                client.ehlo()
                # No plaintext credentials or unencrypted fallback if TLS fails.
                client.starttls(context=context)
                client.ehlo()
            client.login(str(settings.smtp_username), settings.smtp_password.get_secret_value())
            refused = client.send_message(message, from_addr=sender, to_addrs=[recipient])
            if refused:
                raise EmailDeliveryError("smtp_recipient")
            # A successful SMTP response means acceptance, not inbox delivery.
            # Never retry an uncertain send or expose provider replies in logs.
        except (smtplib.SMTPException, OSError):
            raise EmailDeliveryError("smtp") from None
        finally:
            if client is not None:
                # Avoid treating a failed QUIT after acceptance as a failed send.
                client.close()


reset_email_service = ResetEmailService()
