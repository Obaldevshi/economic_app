// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get financialSettings => 'Finanzeinstellungen';

  @override
  String get financialRegion => 'Finanzregion';

  @override
  String get recordCurrency => 'Buchungswährung';

  @override
  String get displayCurrency => 'Anzeigewährung';

  @override
  String get currencyLedgerHint =>
      'Die Buchungswährung wechselt zu einem eigenen Journal. Bestehende Buchungen und Ziele behalten ihre Währung. Für Gegenwerte die Anzeigewährung nutzen.';

  @override
  String get regionalDefaultsHint =>
      'Die Region schlägt Währung, Startpreise und einen Referenzzins vor. Preise werden nur in einem leeren Journal ergänzt; Änderungen bleiben erhalten.';

  @override
  String get applyRegionDefaults => 'Regionale Einstellungen anwenden';

  @override
  String get conversionHint =>
      'Umrechnung zum letzten offiziellen Kurs der Bank von Russland. Buchungen bleiben unverändert. Kein Handelskurs oder Kursausblick; Zinsen, Steuern und Gebühren werden nicht umgerechnet.';

  @override
  String get rateReferenceHint =>
      'Der Zins ist ein anpassbares Szenario, keine Renditezusage. Quelle und Zeitraum stehen unten.';

  @override
  String get rateNeedsInput =>
      'Keine geprüfte Referenz: Startzins 0 %. Trage die Konditionen deiner Einlage ein.';

  @override
  String exchangeRateDate(String date) {
    return 'Kurs Bank von Russland · $date';
  }

  @override
  String get currencyChanged =>
      'Die Buchungswährung hat sich geändert. Aktualisieren und erneut versuchen.';

  @override
  String get starterPricesHint =>
      'Die Preise sind anpassbare Startschätzungen, keine statistischen Durchschnittswerte. Passe sie an deine Käufe an.';

  @override
  String get widgetEmptyHint =>
      'Wähle bis zu drei Favoriten unter Impulskäufe. Tippe, um eine Ersparnis zu bestätigen.';

  @override
  String get chooseLanguage => 'Sprache wählen';

  @override
  String get coinLanguageHint =>
      'Das Währungszeichen im Logo ist eine regionale Zuordnung. Die Sprache rechnet Beträge nicht um und ändert die Währung deiner Einträge nicht.';

  @override
  String get appName => 'Nicht ausgegeben';

  @override
  String get appTagline => 'Kleine Entscheidungen. Mehr Ersparnis.';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get loginSubtitle => 'Melde dich an, um fortzufahren';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get registerSubtitle => 'Gib deine Daten ein, um zu starten';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get emailHint => 'E-Mail eingeben';

  @override
  String get password => 'Passwort';

  @override
  String get passwordHint => 'Passwort eingeben';

  @override
  String get createPasswordHint => 'Passwort erstellen';

  @override
  String get firstName => 'Vorname';

  @override
  String get firstNameHint => 'Vornamen eingeben';

  @override
  String get lastName => 'Nachname';

  @override
  String get lastNameHint => 'Nachnamen eingeben';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get dontHaveAccount => 'Noch kein Konto?';

  @override
  String get alreadyHaveAccount => 'Schon ein Konto?';

  @override
  String get signUp => 'Registrieren';

  @override
  String get signIn => 'Anmelden';

  @override
  String get or => 'oder';

  @override
  String get createAccountButton => 'Konto erstellen';

  @override
  String get accountCreatedSuccessfully => 'Konto erstellt';

  @override
  String get home => 'Ersparnisse';

  @override
  String get homeWelcome => 'Designsystem';

  @override
  String get homeDescription =>
      'Entdecke Farben, Schrift und Komponenten. Ändere Design und Sprache direkt.';

  @override
  String get homeFeatureCategories => 'Kategorien und Seiten verwalten';

  @override
  String get homeFeatureProfile => 'Profil, Design und Sprache';

  @override
  String get homeUiKitTitle => 'UI-Baukasten';

  @override
  String get homeUiKitSubtitle => 'Designsystem';

  @override
  String get homeUiKitDescription =>
      'Leichte Oberflächen, Stile und Komponenten für flüssige Bedienung.';

  @override
  String get homeSectionAppearance => 'Darstellung';

  @override
  String get homeSectionColors => 'Farben';

  @override
  String get homeSectionTypography => 'Typografie';

  @override
  String get homeSectionComponents => 'Komponenten';

  @override
  String get homeSectionTokens => 'Designvariablen';

  @override
  String get colorPrimary => 'Primär';

  @override
  String get colorPrimaryLight => 'Primär hell';

  @override
  String get colorPrimaryDark => 'Primär dunkel';

  @override
  String get colorSecondary => 'Sekundär';

  @override
  String get colorSuccess => 'Erfolg';

  @override
  String get colorWarning => 'Warnung';

  @override
  String get colorError => 'Fehler';

  @override
  String get colorSurface => 'Oberfläche';

  @override
  String get colorBackground => 'Hintergrund';

  @override
  String get homeShowDialog => 'Dialog anzeigen';

  @override
  String get homeDialogDemoTitle => 'Dialogbeispiel';

  @override
  String get homeDialogDemoContent =>
      'Bestätigungsdialog aus dem UI-Baukasten.';

  @override
  String get homeFontFamily => 'Schriftfamilie';

  @override
  String get homeFontRegular => 'Normal';

  @override
  String get homeFontMedium => 'Mittel';

  @override
  String get homeFontBold => 'Fett';

  @override
  String get homeSpacing => 'Abstände';

  @override
  String get homeRadius => 'Eckenradius';

  @override
  String get homeGlassTokens => 'Oberflächen';

  @override
  String get homeDemoInputLabel => 'Beispieleingabe';

  @override
  String get homeDemoInputHint => 'Schreib etwas…';

  @override
  String get homeToggleLoading => 'Laden umschalten';

  @override
  String get homeGlassOnLight => 'Standard';

  @override
  String get homeGlassPanel => 'Bereich';

  @override
  String get homeGlassOnGradient => 'Akzent';

  @override
  String get homeTypographySample =>
      'Kleine Entscheidungen, große Veränderungen';

  @override
  String get categories => 'Kategorien';

  @override
  String get profile => 'Profil';

  @override
  String get profileSectionAccount => 'Konto';

  @override
  String get addCategory => 'Kategorie hinzufügen';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get deleteCategory => 'Kategorie löschen';

  @override
  String get categoryName => 'Kategoriename';

  @override
  String get categoryNameRequired => 'Kategoriename erforderlich';

  @override
  String get categoryNameTooShort => 'Name zu kurz';

  @override
  String get updateCategory => 'Kategorie aktualisieren';

  @override
  String get deleteCategoryConfirmation => 'Diese Kategorie löschen?';

  @override
  String get categoryDeletedSuccessfully => 'Kategorie gelöscht';

  @override
  String get categoryUpdatedSuccessfully => 'Kategorie aktualisiert';

  @override
  String get noCategoriesYet => 'Noch keine Kategorien';

  @override
  String get noCategoriesFound => 'Keine Kategorien gefunden';

  @override
  String get addFirstCategory => 'Erste Kategorie hinzufügen';

  @override
  String get tryDifferentSearch => 'Andere Suche versuchen';

  @override
  String get searchCategories => 'Kategorien suchen';

  @override
  String get addNewCategoryTooltip => 'Kategorie hinzufügen';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get updatePersonalInfo => 'Persönliche Angaben aktualisieren';

  @override
  String get personalInformation => 'Persönliche Angaben';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get changePasswordTitle => 'Passwort ändern';

  @override
  String get changePasswordButton => 'Passwort aktualisieren';

  @override
  String get security => 'Sicherheit';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutConfirmation => 'Abmelden?';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get error => 'Fehler';

  @override
  String get loading => 'Laden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get version => 'Version';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get enterCurrentPassword => 'Aktuelles Passwort eingeben';

  @override
  String get enterNewPassword => 'Neues Passwort eingeben';

  @override
  String get confirmYourNewPassword => 'Neues Passwort bestätigen';

  @override
  String get currentPasswordRequired => 'Aktuelles Passwort erforderlich';

  @override
  String get newPasswordRequired => 'Neues Passwort erforderlich';

  @override
  String get passwordChangedSuccessfully => 'Passwort geändert';

  @override
  String get profileUpdatedSuccessfully => 'Profil aktualisiert';

  @override
  String get accountDeletedSuccessfully => 'Konto gelöscht';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountConfirmation => 'Dein Konto löschen?';

  @override
  String get deleteAccountDescription =>
      'Konto und alle Daten dauerhaft löschen';

  @override
  String get deleteAccountWarning =>
      'Dies kann nicht rückgängig gemacht werden. Alle Daten werden dauerhaft gelöscht.';

  @override
  String get dangerZone => 'Gefahrenbereich';

  @override
  String get manageAccount => 'Konto verwalten';

  @override
  String get emailRequired => 'E-Mail erforderlich';

  @override
  String get emailInvalid => 'Gültige E-Mail eingeben';

  @override
  String get passwordRequired => 'Passwort erforderlich';

  @override
  String passwordTooShort(int minLength) {
    return 'Das Passwort muss mindestens $minLength Zeichen haben';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'Das neue Passwort muss mindestens $minLength Zeichen haben';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName ist erforderlich';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName muss mindestens $minLength Zeichen haben';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName darf nur Buchstaben enthalten';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName ist erforderlich';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName muss eine gültige Zahl sein';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName muss größer als null sein';
  }

  @override
  String get passwordsDontMatch => 'Passwörter stimmen nicht überein';

  @override
  String get last7Days => 'Letzte 7 Tage';

  @override
  String get last30Days => 'Letzte 30 Tage';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get past => 'Vergangenheit';

  @override
  String get ok => 'OK';

  @override
  String get offlineBanner => 'Keine Internetverbindung';

  @override
  String get loadMore => 'Mehr laden';

  @override
  String get appearance => 'Darstellung';

  @override
  String get appearanceDescription => 'Hell, dunkel oder Systemeinstellung';

  @override
  String get language => 'Sprache';

  @override
  String get languageDescription => 'Sprache der Oberfläche';

  @override
  String get languageSystem => 'System (ohne Symbol)';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get errorBadRequest => 'Ungültige Anfrage';

  @override
  String get errorUnauthorized => 'Anmeldung erforderlich';

  @override
  String get errorAccessDenied => 'Zugriff verweigert';

  @override
  String get errorNotFound => 'Nicht gefunden';

  @override
  String get errorTimeout => 'Zeitüberschreitung';

  @override
  String get errorValidation => 'Validierungsfehler';

  @override
  String get errorTooManyRequests => 'Zu viele Anfragen';

  @override
  String get errorServer => 'Serverfehler';

  @override
  String get errorBadGateway => 'Gatewayfehler';

  @override
  String get errorServiceUnavailable => 'Dienst nicht verfügbar';

  @override
  String get errorGatewayTimeout => 'Gateway-Zeitüberschreitung';

  @override
  String get errorClient => 'Clientfehler';

  @override
  String get errorRequestCancelled => 'Anfrage abgebrochen';

  @override
  String get errorInvalidCredentials => 'Ungültige Anmeldedaten';

  @override
  String get errorResourceExists => 'Ressource bereits vorhanden';

  @override
  String get savingsTagline =>
      'Jeder vermiedene Impulskauf stärkt deine Zukunft';

  @override
  String get recordSaving => 'Nicht ausgegeben';

  @override
  String get savedToday => 'Heute gespart';

  @override
  String get savedThisMonth => 'Diesen Monat';

  @override
  String get savedTotal => 'Insgesamt erfasst gespart';

  @override
  String get investedTotal => 'Tatsächlich zurückgelegt';

  @override
  String get monthlyPace => 'Monatliches Tempo';

  @override
  String get futureProjection => 'Künftige Ersparnisse';

  @override
  String get yearsAtCurrentPace => 'Jahre bei aktuellem Tempo';

  @override
  String get interestIncome => 'Zinsertrag';

  @override
  String get contributions => 'Deine Einzahlungen';

  @override
  String get savingsDynamics => 'Ersparnisse pro Monat';

  @override
  String get recentSavings => 'Letzte Entscheidungen';

  @override
  String get noSavingsYet => 'Noch keine Ersparnisse erfasst';

  @override
  String get habits => 'Impulskäufe';

  @override
  String get habitsDescription =>
      'Preise und Schnellaktionen für Käufe anpassen, die du vermeiden möchtest';

  @override
  String get history => 'Verlauf';

  @override
  String get historyDescription => 'Jede kleine Entscheidung für deine Zukunft';

  @override
  String get goals => 'Ziele';

  @override
  String get addGoal => 'Ziel hinzufügen';

  @override
  String get goalName => 'Zielname';

  @override
  String get targetAmount => 'Zielbetrag';

  @override
  String get noGoalsYet =>
      'Füge ein Ziel hinzu, um deinen Fortschritt zu sehen';

  @override
  String get impulseItem => 'Was hast du nicht gekauft?';

  @override
  String get amount => 'Betrag';

  @override
  String get actuallySetAside => 'Ich habe dieses Geld wirklich zurückgelegt';

  @override
  String get actuallySetAsideDescription =>
      'Trennt mögliche Ersparnisse von echtem Kapital';

  @override
  String get noteOptional => 'Notiz (optional)';

  @override
  String get record => 'Erfassen';

  @override
  String get editHabit => 'Impulskauf bearbeiten';

  @override
  String get addHabit => 'Impulskauf hinzufügen';

  @override
  String get habitName => 'Name des Impulskaufs';

  @override
  String get defaultPrice => 'Üblicher Preis';

  @override
  String get timesPerWeek => 'Mal pro Woche';

  @override
  String get frequencyZeroHint => '0 bedeutet einmal pro Monat';

  @override
  String get oncePerMonth => 'einmal pro Monat';

  @override
  String get chooseIcon => 'Symbol';

  @override
  String get deleteHabitConfirmation =>
      'Diesen Schnellzugriff löschen? Der Verlauf bleibt erhalten.';

  @override
  String get deleteSavingConfirmation => 'Diesen Spar-Eintrag löschen?';

  @override
  String get noHabits => 'Noch keine Impuls-Schnellaktionen';

  @override
  String get noHistory => 'Hier erscheint dein Sparverlauf';

  @override
  String get weekShort => 'Woche';

  @override
  String get rateAndHorizon => 'Zinssatz und Zeitraum';

  @override
  String get annualRate => 'Jährlicher Einlagenzins';

  @override
  String get projectionYears => 'Prognosejahre';

  @override
  String get apply => 'Übernehmen';

  @override
  String get noData => 'Noch nicht genügend Daten';

  @override
  String get quickChoices => 'Schnelle Wahl';

  @override
  String get quickChoicesDescription => 'Wähle den gerade vermiedenen Kauf';

  @override
  String get recordThisSaving => 'Nicht ausgegeben';

  @override
  String get annualPotential => 'Jährliches Potenzial';

  @override
  String get weeklyPotential => 'Typische Woche';

  @override
  String get savingsBreakdown => 'So entsteht dein Kapital';

  @override
  String get topSavingsSources => 'Deine stärksten Sparquellen';

  @override
  String get currentPace => 'Aktuelles Tempo';

  @override
  String get decisionCount => 'Entscheidungen für deine Zukunft';

  @override
  String get allSavings => 'Alle Entscheidungen';

  @override
  String get realSavings => 'Tatsächlich zurückgelegt';

  @override
  String get potentialSavings => 'Noch nicht zurückgelegt';

  @override
  String get compoundEffect => 'Zinseszinseffekt';

  @override
  String get projectionExplanation =>
      'Ein Szenario, kein Kontostand: Alle erfassten Ersparnisse werden zurückgelegt, das Tempo der letzten 90 Tage bleibt gleich und Zinsen werden monatlich gutgeschrieben. Der Zinssatz ist hypothetisch; Erträge sind nicht garantiert.';

  @override
  String get impulseAnnualHint => 'Bei deiner gewählten Verzichtshäufigkeit';

  @override
  String projectionScenario(int years, String rate) {
    return 'Nach $years Jahren bei $rate% pro Jahr mit monatlichen Einzahlungen. Alle Ersparnisse werden zurückgelegt; Erträge sind nicht garantiert.';
  }

  @override
  String projectionAfterYears(int years) {
    return 'Nach $years Jahren mit Zinsen';
  }

  @override
  String get oneSkippedPurchase => 'Ein vermiedener Kauf';

  @override
  String get regularlySkippedPurchases => 'Regelmäßiger Verzicht';

  @override
  String get editImpulse => 'Anpassen';

  @override
  String get historyOverview => 'Deine Entscheidungen im Überblick';

  @override
  String get noFilteredHistory =>
      'Keine Entscheidungen dieser Gruppe in den geladenen Einträgen';

  @override
  String get loadMoreHistory => 'Mehr anzeigen';

  @override
  String historyLoadedCount(int count, int total) {
    return '$count von $total Entscheidungen geladen';
  }

  @override
  String get projectionTableTitle => 'Beträge nach Jahren';

  @override
  String get projectionTableYear => 'Jahr';

  @override
  String get projectionTableTotal => 'Gesamt';

  @override
  String get habitPaused => 'Pausiert · nicht im Gesamtpotenzial';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get editSaving => 'Eintrag bearbeiten';

  @override
  String get moneyFormatError =>
      'Betrag mit bis zu 10 Ziffern und 2 Nachkommastellen eingeben';

  @override
  String get frequencyRangeError => 'Ganze Zahl zwischen 0 und 50 eingeben';

  @override
  String get habitActive => 'Diese Gewohnheit einbeziehen';

  @override
  String get habitActiveDescription =>
      'Pausieren entfernt die Gewohnheit aus Schnellwahl und Gesamtpotenzial; der Verlauf bleibt';

  @override
  String get editGoal => 'Ziel bearbeiten';

  @override
  String get goalReached => 'Der Zielbetrag ist zurückgelegt';

  @override
  String goalRemaining(String amount) {
    return 'Noch zurückzulegen: $amount';
  }

  @override
  String get goalProgressExplanation =>
      'Nur diesem Ziel zugewiesenes Geld zählt. Derselbe Betrag zählt nicht für mehrere Ziele.';

  @override
  String get rateFormatError =>
      'Zinssatz von 0 bis 100% mit bis zu zwei Nachkommastellen eingeben';

  @override
  String get savingRecordedMessage => 'Entscheidung erfasst';

  @override
  String get savingUpdatedMessage => 'Eintrag aktualisiert';

  @override
  String get habitSavedMessage => 'Gewohnheit gespeichert';

  @override
  String get goalSavedMessage => 'Ziel gespeichert';

  @override
  String get settingsSavedMessage => 'Prognose aktualisiert';

  @override
  String get entryDeletedMessage => 'Eintrag gelöscht';

  @override
  String get changesSavedMessage => 'Änderungen gespeichert';

  @override
  String get savingsSummaryUnavailable =>
      'Gesamtsummen nicht verfügbar; dein Verlauf bleibt erhalten';

  @override
  String get savingsDataLoadFailed =>
      'Daten konnten nicht geladen werden. Verbindung prüfen und erneut versuchen.';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get monthlyAmounts => 'Monatliche Beträge';

  @override
  String get customSaving => 'Andere Entscheidung';

  @override
  String get customSavingHint =>
      'Einmaliger Eintrag: Es wird keine neue Gewohnheit erstellt.';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'Ein vermiedener Kauf: $amount in $years Jahren.';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'Wenn du diesen Betrag jetzt bei $rate% pro Jahr mit monatlichem Zinseszins und ohne weitere Einzahlungen zurücklegst. Ein hypothetisches Szenario, kein versprochener Ertrag.';
  }

  @override
  String get impulseIconCoffee => 'Kaffee';

  @override
  String get impulseIconRestaurant => 'Cafés und Restaurants';

  @override
  String get impulseIconDelivery => 'Essenslieferung';

  @override
  String get impulseIconSmoking => 'Zigaretten';

  @override
  String get impulseIconTaxi => 'Taxi';

  @override
  String get impulseIconShopping => 'Shopping';

  @override
  String get impulseIconSubscription => 'Abonnements';

  @override
  String get impulseIconOther => 'Sonstiges';

  @override
  String get scenarioComparison => 'Was wäre, wenn ich seltener kaufe?';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'Preis: $amount · hypothetischer Zinssatz: $rate%';
  }

  @override
  String get scenarioBaseline => 'Jetzt';

  @override
  String get scenarioModerate => 'Moderate Variante';

  @override
  String get scenarioMinimal => 'Minimale Variante';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name: $count Käufe pro Woche';
  }

  @override
  String get scenarioOwnMoney => 'Einzahlungen';

  @override
  String get scenarioAssumptions =>
      'Differenz zur aktuellen Häufigkeit. 52 Wochen pro Jahr; alle Ersparnisse werden am Monatsende mit monatlichem Zinseszins eingezahlt. Ohne Startkapital, Steuern oder Inflation; Erträge sind nicht garantiert. Die Berechnung erstellt keine Einträge.';

  @override
  String get allocateGoal => 'Geld zuweisen';

  @override
  String get allocatedAmount => 'Diesem Ziel insgesamt zugewiesen';

  @override
  String unallocatedMoney(String amount) {
    return 'Für Ziele verfügbar: $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'Du kannst diesem Ziel bis zu $amount zuweisen';
  }

  @override
  String get allocationInvalid =>
      'Betrag ab 0 mit bis zu zwei Nachkommastellen eingeben';

  @override
  String get allocationTooLarge =>
      'Nicht genügend verfügbares Geld oder Zielbetrag überschritten';

  @override
  String get goalBelowAllocation => 'Zuerst überzählige Zuweisung freigeben';

  @override
  String get releaseAllocationsFirst =>
      'Dieses Geld ist Zielen zugewiesen. Reduziere zuerst die Zuweisungen.';

  @override
  String get releaseGoalMoney => 'Geld dieses Ziels freigeben';

  @override
  String get allocationHint =>
      'Lege die gesamte Zuweisung fest, keine zusätzliche Einzahlung. 0 gibt das Geld wieder frei. Es erfolgt keine Banküberweisung.';

  @override
  String get allocationSaved => 'Geld zugewiesen';

  @override
  String get savingReceipt => 'Beleg für vermiedenen Kauf';

  @override
  String get weeklyReceipt => 'Meine Entscheidungen in 7 Tagen';

  @override
  String get receiptPurchaseNotMade => 'Kauf nicht getätigt';

  @override
  String get receiptPrivateDecision => 'Eine Entscheidung für mich';

  @override
  String get receiptFooter =>
      'Persönlicher Nachweis eines vermiedenen Kaufs. Kein Kontoauszug und kein steuerlicher Beleg.';

  @override
  String get receiptHideName => 'Kaufnamen verbergen';

  @override
  String get receiptExport => 'PNG speichern / teilen';

  @override
  String get receiptExportFailed =>
      'Beleg konnte nicht exportiert werden. Erneut versuchen.';

  @override
  String get favoriteActions => 'Meine drei Schnellentscheidungen';

  @override
  String get favoriteActionsHint =>
      'Wähle Zu Favoriten hinzufügen im Menü einer Gewohnheit. Bis zu drei Aktionen erscheinen hier und im Handy-Widget. Zum Hinzufügen Startbildschirm gedrückt halten → Widgets → Nicht ausgegeben.';

  @override
  String get addFavorite => 'Zu Favoriten / Widget hinzufügen';

  @override
  String get removeFavorite => 'Aus Favoriten entfernen';

  @override
  String get favoriteLimit =>
      'Du hast bereits drei Favoriten. Entferne zuerst einen.';

  @override
  String get widgetItemUnavailable =>
      'Dieser Eintrag ist gelöscht, pausiert oder für dieses Konto nicht verfügbar';
}
