// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String projectionPeriod(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '# ans',
      one: '# an',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get financialSettings => 'Réglages financiers';

  @override
  String get financialRegion => 'Région financière';

  @override
  String get recordCurrency => 'Devise des écritures';

  @override
  String get displayCurrency => 'Devise d’affichage';

  @override
  String get currencyLedgerHint =>
      'La devise des écritures ouvre un registre distinct. Les écritures et objectifs existants gardent leur devise. Utilisez la devise d’affichage pour les équivalents.';

  @override
  String get regionalDefaultsHint =>
      'La région propose une devise, des prix de départ et un taux indicatif. Les prix sont ajoutés uniquement à un registre vide ; vos modifications sont conservées.';

  @override
  String get applyRegionDefaults => 'Appliquer les réglages régionaux';

  @override
  String get conversionHint =>
      'Conversion au dernier taux officiel de la Banque de Russie. Les écritures ne changent pas. Ce n’est ni un taux commercial ni une prévision ; intérêts, impôts et frais ne sont pas convertis.';

  @override
  String get rateReferenceHint =>
      'Le taux est un scénario modifiable, pas un rendement garanti. La source et la période figurent ci-dessous.';

  @override
  String get rateNeedsInput =>
      'Aucune référence vérifiée : taux initial de 0 %. Saisissez les conditions de votre dépôt.';

  @override
  String exchangeRateDate(String date) {
    return 'Taux Banque de Russie · $date';
  }

  @override
  String get currencyChanged =>
      'La devise des écritures a changé. Actualisez puis réessayez.';

  @override
  String get starterPricesHint =>
      'Les prix sont des estimations de départ modifiables, pas des moyennes statistiques. Adaptez-les à vos achats.';

  @override
  String get widgetEmptyHint =>
      'Choisissez jusqu\'à trois favoris dans Impulsions. Touchez pour confirmer une économie.';

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get coinLanguageHint =>
      'Le symbole du logo est une association régionale. La langue ne convertit pas les montants et ne change pas la devise de vos données.';

  @override
  String get appName => 'Pas dépensé';

  @override
  String get appTagline => 'Petits choix. Plus d\'économies.';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get loginSubtitle => 'Connectez-vous pour continuer';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get registerSubtitle => 'Renseignez vos informations pour commencer';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Inscription';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'Saisissez votre e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Saisissez votre mot de passe';

  @override
  String get createPasswordHint => 'Créez un mot de passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstNameHint => 'Saisissez votre prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get lastNameHint => 'Saisissez votre nom';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get dontHaveAccount => 'Pas encore de compte ?';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get signUp => 'Inscrivez-vous';

  @override
  String get signIn => 'Se connecter';

  @override
  String get or => 'ou';

  @override
  String get createAccountButton => 'Créer un compte';

  @override
  String get accountCreatedSuccessfully => 'Compte créé';

  @override
  String get home => 'Économies';

  @override
  String get homeWelcome => 'Système de design';

  @override
  String get homeDescription =>
      'Explorez couleurs, typographie et composants. Changez de thème et de langue en direct.';

  @override
  String get homeFeatureCategories => 'Gérez les catégories et la pagination';

  @override
  String get homeFeatureProfile => 'Profil, thème et langue';

  @override
  String get homeUiKitTitle => 'Kit d\'interface';

  @override
  String get homeUiKitSubtitle => 'Système de design';

  @override
  String get homeUiKitDescription =>
      'Surfaces, styles et composants légers pour une interface fluide.';

  @override
  String get homeSectionAppearance => 'Apparence';

  @override
  String get homeSectionColors => 'Couleurs';

  @override
  String get homeSectionTypography => 'Typographie';

  @override
  String get homeSectionComponents => 'Composants';

  @override
  String get homeSectionTokens => 'Variables de design';

  @override
  String get colorPrimary => 'Principale';

  @override
  String get colorPrimaryLight => 'Principale claire';

  @override
  String get colorPrimaryDark => 'Principale foncée';

  @override
  String get colorSecondary => 'Secondaire';

  @override
  String get colorSuccess => 'Succès';

  @override
  String get colorWarning => 'Avertissement';

  @override
  String get colorError => 'Erreur';

  @override
  String get colorSurface => 'Surface';

  @override
  String get colorBackground => 'Fond';

  @override
  String get homeShowDialog => 'Afficher le dialogue';

  @override
  String get homeDialogDemoTitle => 'Exemple de dialogue';

  @override
  String get homeDialogDemoContent =>
      'Dialogue de confirmation du kit d\'interface.';

  @override
  String get homeFontFamily => 'Famille de police';

  @override
  String get homeFontRegular => 'Normal';

  @override
  String get homeFontMedium => 'Moyen';

  @override
  String get homeFontBold => 'Gras';

  @override
  String get homeSpacing => 'Espacement';

  @override
  String get homeRadius => 'Rayon des coins';

  @override
  String get homeGlassTokens => 'Surfaces';

  @override
  String get homeDemoInputLabel => 'Champ d\'exemple';

  @override
  String get homeDemoInputHint => 'Saisissez du texte…';

  @override
  String get homeToggleLoading => 'Basculer le chargement';

  @override
  String get homeGlassOnLight => 'Par défaut';

  @override
  String get homeGlassPanel => 'Panneau';

  @override
  String get homeGlassOnGradient => 'Accent';

  @override
  String get homeTypographySample => 'Petits choix, grands changements';

  @override
  String get categories => 'Catégories';

  @override
  String get profile => 'Profil';

  @override
  String get profileSectionAccount => 'Compte';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get categoryNameRequired => 'Le nom de la catégorie est requis';

  @override
  String get categoryNameTooShort => 'Le nom est trop court';

  @override
  String get updateCategory => 'Mettre à jour la catégorie';

  @override
  String get deleteCategoryConfirmation => 'Supprimer cette catégorie ?';

  @override
  String get categoryDeletedSuccessfully => 'Catégorie supprimée';

  @override
  String get categoryUpdatedSuccessfully => 'Catégorie mise à jour';

  @override
  String get noCategoriesYet => 'Pas encore de catégories';

  @override
  String get noCategoriesFound => 'Aucune catégorie trouvée';

  @override
  String get addFirstCategory => 'Ajoutez votre première catégorie';

  @override
  String get tryDifferentSearch => 'Essayez une autre recherche';

  @override
  String get searchCategories => 'Rechercher des catégories';

  @override
  String get addNewCategoryTooltip => 'Ajouter une catégorie';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get updatePersonalInfo =>
      'Mettez à jour vos informations personnelles';

  @override
  String get personalInformation => 'Informations personnelles';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get changePasswordButton => 'Mettre à jour le mot de passe';

  @override
  String get security => 'Sécurité';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutConfirmation => 'Se déconnecter ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get error => 'Erreur';

  @override
  String get loading => 'Chargement';

  @override
  String get retry => 'Réessayer';

  @override
  String get version => 'Version';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get enterCurrentPassword => 'Saisissez le mot de passe actuel';

  @override
  String get enterNewPassword => 'Saisissez le nouveau mot de passe';

  @override
  String get confirmYourNewPassword => 'Confirmez le nouveau mot de passe';

  @override
  String get currentPasswordRequired => 'Le mot de passe actuel est requis';

  @override
  String get newPasswordRequired => 'Le nouveau mot de passe est requis';

  @override
  String get passwordChangedSuccessfully => 'Mot de passe modifié';

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour';

  @override
  String get accountDeletedSuccessfully => 'Compte supprimé';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmation => 'Supprimer votre compte ?';

  @override
  String get deleteAccountDescription =>
      'Supprimez définitivement votre compte et toutes vos données';

  @override
  String get deleteAccountWarning =>
      'Cette action est irréversible. Toutes vos données seront définitivement supprimées.';

  @override
  String get dangerZone => 'Zone à risque';

  @override
  String get manageAccount => 'Gérez votre compte';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String passwordTooShort(int minLength) {
    return 'Le mot de passe doit contenir au moins $minLength caractères';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'Le nouveau mot de passe doit contenir au moins $minLength caractères';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName est requis';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName doit contenir au moins $minLength caractères';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName ne doit contenir que des lettres';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName est requis';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName doit être un nombre valide';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName doit être supérieur à zéro';
  }

  @override
  String get passwordsDontMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get last7Days => '7 derniers jours';

  @override
  String get last30Days => '30 derniers jours';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get past => 'Passé';

  @override
  String get ok => 'OK';

  @override
  String get offlineBanner => 'Pas de connexion Internet';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearanceDescription => 'Thème clair, sombre ou système';

  @override
  String get language => 'Langue';

  @override
  String get languageDescription => 'Langue de l\'interface';

  @override
  String get languageSystem => 'Système (sans symbole)';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get errorBadRequest => 'Requête incorrecte';

  @override
  String get errorUnauthorized => 'Connexion requise';

  @override
  String get errorAccessDenied => 'Accès refusé';

  @override
  String get errorNotFound => 'Introuvable';

  @override
  String get errorTimeout => 'Délai de requête dépassé';

  @override
  String get errorValidation => 'Erreur de validation';

  @override
  String get errorTooManyRequests => 'Trop de requêtes';

  @override
  String get errorServer => 'Erreur du serveur';

  @override
  String get errorBadGateway => 'Erreur de passerelle';

  @override
  String get errorServiceUnavailable => 'Service indisponible';

  @override
  String get errorGatewayTimeout => 'Délai de passerelle dépassé';

  @override
  String get errorClient => 'Erreur du client';

  @override
  String get errorRequestCancelled => 'Requête annulée';

  @override
  String get errorInvalidCredentials => 'Identifiants incorrects';

  @override
  String get errorResourceExists => 'La ressource existe déjà';

  @override
  String get savingsTagline =>
      'Chaque achat impulsif évité construit votre avenir';

  @override
  String get recordSaving => 'Je n\'ai pas dépensé';

  @override
  String get savedToday => 'Économisé aujourd\'hui';

  @override
  String get savedThisMonth => 'Ce mois-ci';

  @override
  String get savedTotal => 'Total économisé enregistré';

  @override
  String get investedTotal => 'Réellement mis de côté';

  @override
  String get monthlyPace => 'Rythme mensuel';

  @override
  String get futureProjection => 'Économies futures';

  @override
  String get yearsAtCurrentPace => 'ans au rythme actuel';

  @override
  String get interestIncome => 'Intérêts';

  @override
  String get contributions => 'Vos versements';

  @override
  String get savingsDynamics => 'Économies par mois';

  @override
  String get recentSavings => 'Choix récents';

  @override
  String get noSavingsYet => 'Aucune économie enregistrée';

  @override
  String get habits => 'Impulsions';

  @override
  String get habitsDescription =>
      'Modifiez les prix et raccourcis des achats à éviter';

  @override
  String get history => 'Historique';

  @override
  String get historyDescription =>
      'Chaque petit choix en faveur de votre avenir';

  @override
  String get goals => 'Objectifs';

  @override
  String get addGoal => 'Ajouter un objectif';

  @override
  String get goalName => 'Nom de l\'objectif';

  @override
  String get targetAmount => 'Montant cible';

  @override
  String get noGoalsYet => 'Ajoutez un objectif pour suivre vos progrès';

  @override
  String get impulseItem => 'Quel achat avez-vous évité ?';

  @override
  String get amount => 'Montant';

  @override
  String get actuallySetAside => 'J\'ai réellement mis cet argent de côté';

  @override
  String get actuallySetAsideDescription =>
      'Distingue les économies potentielles du capital réel';

  @override
  String get noteOptional => 'Note (facultatif)';

  @override
  String get record => 'Enregistrer';

  @override
  String get editHabit => 'Modifier l\'impulsion';

  @override
  String get addHabit => 'Ajouter une impulsion';

  @override
  String get habitName => 'Nom de l\'impulsion';

  @override
  String get defaultPrice => 'Prix habituel';

  @override
  String get timesPerWeek => 'Fois par semaine';

  @override
  String get frequencyZeroHint => '0 signifie une fois par mois';

  @override
  String get oncePerMonth => 'une fois par mois';

  @override
  String get chooseIcon => 'Icône';

  @override
  String get deleteHabitConfirmation =>
      'Supprimer ce raccourci ? L\'historique sera conservé.';

  @override
  String get deleteSavingConfirmation => 'Supprimer cette entrée d\'économie ?';

  @override
  String get noHabits => 'Pas encore de raccourcis';

  @override
  String get noHistory => 'Votre historique d\'économies apparaîtra ici';

  @override
  String get weekShort => 'semaine';

  @override
  String get rateAndHorizon => 'Taux et durée';

  @override
  String get annualRate => 'Taux annuel du dépôt';

  @override
  String get projectionYears => 'Années de projection';

  @override
  String get apply => 'Appliquer';

  @override
  String get noData => 'Pas encore assez de données';

  @override
  String get quickChoices => 'Choix rapide';

  @override
  String get quickChoicesDescription =>
      'Choisissez l\'achat que vous venez d\'éviter';

  @override
  String get recordThisSaving => 'Pas dépensé';

  @override
  String get annualPotential => 'Potentiel annuel';

  @override
  String get weeklyPotential => 'Semaine habituelle';

  @override
  String get savingsBreakdown => 'Comment se construit votre capital';

  @override
  String get topSavingsSources => 'Vos principales sources d\'économies';

  @override
  String get currentPace => 'Rythme actuel';

  @override
  String get decisionCount => 'Choix pour votre avenir';

  @override
  String get allSavings => 'Tous les choix';

  @override
  String get realSavings => 'Réellement mis de côté';

  @override
  String get potentialSavings => 'Pas encore mis de côté';

  @override
  String get compoundEffect => 'Effet des intérêts composés';

  @override
  String get projectionExplanation =>
      'C\'est un scénario, pas un solde : toutes les économies enregistrées sont mises de côté, le rythme des 90 derniers jours continue et les intérêts sont capitalisés chaque mois. Le taux est hypothétique ; les rendements ne sont pas garantis.';

  @override
  String get impulseAnnualHint => 'Selon la fréquence d\'évitement choisie';

  @override
  String projectionScenario(int years, String rate) {
    return 'Après $years ans à $rate% par an avec des versements mensuels. Toutes les économies sont supposées mises de côté ; les rendements ne sont pas garantis.';
  }

  @override
  String projectionAfterYears(int years) {
    return 'Après $years ans avec intérêts';
  }

  @override
  String get oneSkippedPurchase => 'Un achat évité';

  @override
  String get regularlySkippedPurchases => 'Achats régulièrement évités';

  @override
  String get editImpulse => 'Personnaliser';

  @override
  String get historyOverview => 'Vos choix en un coup d\'œil';

  @override
  String get noFilteredHistory =>
      'Aucun choix de ce groupe parmi les entrées chargées';

  @override
  String get loadMoreHistory => 'Afficher plus';

  @override
  String historyLoadedCount(int count, int total) {
    return '$count choix chargés sur $total';
  }

  @override
  String get projectionTableTitle => 'Montants année par année';

  @override
  String get projectionTableYear => 'Année';

  @override
  String get projectionTableTotal => 'Total';

  @override
  String get habitPaused => 'En pause · exclu du potentiel total';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get editSaving => 'Modifier l\'entrée';

  @override
  String get moneyFormatError =>
      'Saisissez jusqu\'à 10 chiffres et 2 décimales';

  @override
  String get frequencyRangeError => 'Saisissez un entier entre 0 et 50';

  @override
  String get habitActive => 'Inclure cette habitude';

  @override
  String get habitActiveDescription =>
      'La pause l\'exclut des choix rapides et du potentiel total ; l\'historique est conservé';

  @override
  String get editGoal => 'Modifier l\'objectif';

  @override
  String get goalReached => 'Le montant cible est mis de côté';

  @override
  String goalRemaining(String amount) {
    return 'Reste à mettre de côté : $amount';
  }

  @override
  String get goalProgressExplanation =>
      'La progression compte uniquement l\'argent affecté à cet objectif. Un même montant n\'est pas compté pour plusieurs objectifs.';

  @override
  String get rateFormatError =>
      'Saisissez un taux de 0 à 100% avec au plus deux décimales';

  @override
  String get savingRecordedMessage => 'Choix enregistré';

  @override
  String get savingUpdatedMessage => 'Entrée mise à jour';

  @override
  String get habitSavedMessage => 'Habitude enregistrée';

  @override
  String get goalSavedMessage => 'Objectif enregistré';

  @override
  String get settingsSavedMessage => 'Projection mise à jour';

  @override
  String get entryDeletedMessage => 'Entrée supprimée';

  @override
  String get changesSavedMessage => 'Modifications enregistrées';

  @override
  String get savingsSummaryUnavailable =>
      'Les totaux sont indisponibles ; votre historique est conservé';

  @override
  String get savingsDataLoadFailed =>
      'Impossible de charger vos données. Vérifiez la connexion et réessayez.';

  @override
  String get refresh => 'Actualiser';

  @override
  String get monthlyAmounts => 'Montants mensuels';

  @override
  String get customSaving => 'Un autre choix';

  @override
  String get customSavingHint =>
      'Entrée ponctuelle : aucune nouvelle habitude ne sera créée.';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'Un achat évité : $amount dans $years ans.';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'Si vous mettez ce montant de côté maintenant à $rate% par an, avec capitalisation mensuelle et sans autre versement. C\'est un scénario hypothétique, pas un rendement promis.';
  }

  @override
  String get impulseIconCoffee => 'Café';

  @override
  String get impulseIconRestaurant => 'Cafés et restaurants';

  @override
  String get impulseIconDelivery => 'Livraison de repas';

  @override
  String get impulseIconSmoking => 'Cigarettes';

  @override
  String get impulseIconTaxi => 'Taxi';

  @override
  String get impulseIconShopping => 'Shopping';

  @override
  String get impulseIconSubscription => 'Abonnements';

  @override
  String get impulseIconOther => 'Autre';

  @override
  String get scenarioComparison => 'Et si j\'achetais moins souvent ?';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'Prix : $amount · taux hypothétique : $rate%';
  }

  @override
  String get scenarioBaseline => 'Actuellement';

  @override
  String get scenarioModerate => 'Option modérée';

  @override
  String get scenarioMinimal => 'Option minimale';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name : $count achats par semaine';
  }

  @override
  String get scenarioOwnMoney => 'Versements';

  @override
  String get scenarioAssumptions =>
      'Différence par rapport à la fréquence actuelle. 52 semaines par an ; toutes les économies sont versées en fin de mois avec capitalisation mensuelle. Sans capital initial, impôts ni inflation ; les rendements ne sont pas garantis. Ce calcul ne crée aucune entrée.';

  @override
  String get allocateGoal => 'Affecter de l\'argent';

  @override
  String get allocatedAmount => 'Total affecté à cet objectif';

  @override
  String unallocatedMoney(String amount) {
    return 'Disponible pour les objectifs : $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'Vous pouvez affecter jusqu\'à $amount à cet objectif';
  }

  @override
  String get allocationInvalid =>
      'Saisissez un montant positif ou nul avec au plus deux décimales';

  @override
  String get allocationTooLarge =>
      'Fonds disponibles insuffisants ou montant cible dépassé';

  @override
  String get goalBelowAllocation =>
      'Libérez d\'abord l\'affectation excédentaire';

  @override
  String get releaseAllocationsFirst =>
      'Ces fonds sont affectés à des objectifs. Réduisez d\'abord les affectations.';

  @override
  String get releaseGoalMoney => 'Libérer l\'argent de cet objectif';

  @override
  String get allocationHint =>
      'Définissez le total affecté, pas un versement supplémentaire. 0 remet l\'argent dans le solde disponible. Aucun virement bancaire n\'est effectué.';

  @override
  String get allocationSaved => 'Argent affecté';

  @override
  String get savingReceipt => 'Reçu d\'achat évité';

  @override
  String get weeklyReceipt => 'Mes choix sur 7 jours';

  @override
  String get receiptPurchaseNotMade => 'Achat non effectué';

  @override
  String get receiptPrivateDecision => 'Un choix pour moi';

  @override
  String get receiptFooter =>
      'Trace personnelle d\'un achat évité. Ce n\'est ni un relevé bancaire ni un reçu fiscal.';

  @override
  String get receiptHideName => 'Masquer le nom de l\'achat';

  @override
  String get receiptExport => 'Enregistrer / partager PNG';

  @override
  String get receiptExportFailed =>
      'Impossible d\'exporter le reçu. Réessayez.';

  @override
  String get favoriteActions => 'Mes trois choix rapides';

  @override
  String get favoriteActionsHint =>
      'Choisissez Ajouter aux favoris dans le menu d\'une habitude. Jusqu\'à trois actions apparaîtront ici et dans le widget du téléphone. Pour l\'ajouter, maintenez l\'écran d\'accueil → Widgets → Pas dépensé.';

  @override
  String get addFavorite => 'Ajouter aux favoris / widget';

  @override
  String get removeFavorite => 'Retirer des favoris';

  @override
  String get favoriteLimit =>
      'Vous avez déjà trois favoris. Retirez-en un d\'abord.';

  @override
  String get widgetItemUnavailable =>
      'Cet élément est supprimé, en pause ou indisponible pour ce compte';
}
