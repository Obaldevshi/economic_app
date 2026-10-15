'use strict';
(() => {
  // Public copy needs no account, cookies, analytics, or application runtime.
  const toggle = document.getElementById('language');
  if (!toggle) return;
  function setLanguage(language) {
    document.documentElement.lang = language;
    document.querySelectorAll('[data-language]').forEach(section => {
      section.hidden = section.dataset.language !== language;
    });
    toggle.hidden = false;
    toggle.textContent = language === 'ru' ? 'English' : 'Русский';
    toggle.lang = language === 'ru' ? 'en' : 'ru';
    toggle.setAttribute('aria-label', language === 'ru' ? 'Read in English' : 'Читать на русском');
    document.querySelectorAll('a[data-public-link]').forEach(link => {
      const destination = new URL(link.href);
      destination.searchParams.set('lang', language);
      link.href = destination.href;
    });
    const title = document.querySelector(`meta[name="title-${language}"]`);
    if (title) document.title = title.content;
  }
  const requested = new URL(window.location.href).searchParams.get('lang');
  setLanguage(requested === 'en' ? 'en' : 'ru');
  toggle.addEventListener('click', () => {
    const language = document.documentElement.lang === 'ru' ? 'en' : 'ru';
    setLanguage(language);
    // Never store a language selection in the authenticated app's settings.
    // replaceState keeps the back button free of language-switch entries.
    try {
      const address = new URL(window.location.href);
      address.searchParams.set('lang', language);
      window.history.replaceState(null, '', address);
    } catch (_) { /* Copy remains readable even when history is unavailable. */ }
  });
})();
