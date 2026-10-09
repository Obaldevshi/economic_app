// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get financialSettings => 'Ajustes financieros';

  @override
  String get financialRegion => 'Región financiera';

  @override
  String get recordCurrency => 'Moneda de registro';

  @override
  String get displayCurrency => 'Moneda de visualización';

  @override
  String get currencyLedgerHint =>
      'La moneda de registro cambia a un libro separado. Los registros y objetivos existentes conservan su moneda. Usa la moneda de visualización para ver equivalencias.';

  @override
  String get regionalDefaultsHint =>
      'La región sugiere moneda, precios iniciales y un tipo de referencia. Solo se añaden precios a un libro vacío; tus cambios se conservan.';

  @override
  String get applyRegionDefaults => 'Aplicar ajustes regionales';

  @override
  String get conversionHint =>
      'Conversión con el último tipo oficial del Banco de Rusia. No modifica registros. No es un tipo comercial ni una previsión; no convierte intereses, impuestos o comisiones.';

  @override
  String get rateReferenceHint =>
      'El interés es un escenario editable, no una rentabilidad garantizada. La fuente y el período figuran abajo.';

  @override
  String get rateNeedsInput =>
      'Sin referencia verificada: tipo inicial del 0 %. Introduce las condiciones de tu depósito.';

  @override
  String exchangeRateDate(String date) {
    return 'Tipo del Banco de Rusia · $date';
  }

  @override
  String get currencyChanged =>
      'La moneda de registro cambió. Actualiza e inténtalo de nuevo.';

  @override
  String get starterPricesHint =>
      'Los precios son estimaciones iniciales editables, no promedios estadísticos. Ajústalos a tus compras.';

  @override
  String get widgetEmptyHint =>
      'Elige hasta tres favoritos en Impulsos. Toca para confirmar el ahorro.';

  @override
  String get chooseLanguage => 'Elegir idioma';

  @override
  String get coinLanguageHint =>
      'El símbolo del logo es una asociación regional. El idioma no convierte importes ni cambia la moneda de tus registros.';

  @override
  String get appName => 'No gastado';

  @override
  String get appTagline => 'Pequeñas decisiones. Más ahorro.';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get loginSubtitle => 'Inicia sesión para continuar';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Completa los datos para empezar';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'Introduce tu correo';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Introduce tu contraseña';

  @override
  String get createPasswordHint => 'Crea una contraseña';

  @override
  String get firstName => 'Nombre';

  @override
  String get firstNameHint => 'Introduce tu nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get lastNameHint => 'Introduce tu apellido';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get dontHaveAccount => '¿No tienes cuenta?';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get signUp => 'Regístrate';

  @override
  String get signIn => 'Entrar';

  @override
  String get or => 'o';

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get accountCreatedSuccessfully => 'Cuenta creada';

  @override
  String get home => 'Ahorro';

  @override
  String get homeWelcome => 'Sistema de diseño';

  @override
  String get homeDescription =>
      'Explora colores, tipografía y componentes. Cambia tema e idioma al instante.';

  @override
  String get homeFeatureCategories => 'Gestiona categorías y páginas';

  @override
  String get homeFeatureProfile => 'Perfil, tema e idioma';

  @override
  String get homeUiKitTitle => 'Kit de interfaz';

  @override
  String get homeUiKitSubtitle => 'Sistema de diseño';

  @override
  String get homeUiKitDescription =>
      'Superficies, estilos y componentes ligeros para un uso fluido.';

  @override
  String get homeSectionAppearance => 'Apariencia';

  @override
  String get homeSectionColors => 'Colores';

  @override
  String get homeSectionTypography => 'Tipografía';

  @override
  String get homeSectionComponents => 'Componentes';

  @override
  String get homeSectionTokens => 'Variables de diseño';

  @override
  String get colorPrimary => 'Principal';

  @override
  String get colorPrimaryLight => 'Principal claro';

  @override
  String get colorPrimaryDark => 'Principal oscuro';

  @override
  String get colorSecondary => 'Secundario';

  @override
  String get colorSuccess => 'Éxito';

  @override
  String get colorWarning => 'Advertencia';

  @override
  String get colorError => 'Error';

  @override
  String get colorSurface => 'Superficie';

  @override
  String get colorBackground => 'Fondo';

  @override
  String get homeShowDialog => 'Mostrar diálogo';

  @override
  String get homeDialogDemoTitle => 'Ejemplo de diálogo';

  @override
  String get homeDialogDemoContent =>
      'Diálogo de confirmación del kit de interfaz.';

  @override
  String get homeFontFamily => 'Familia de fuente';

  @override
  String get homeFontRegular => 'Normal';

  @override
  String get homeFontMedium => 'Medio';

  @override
  String get homeFontBold => 'Negrita';

  @override
  String get homeSpacing => 'Espaciado';

  @override
  String get homeRadius => 'Radio del borde';

  @override
  String get homeGlassTokens => 'Superficies';

  @override
  String get homeDemoInputLabel => 'Campo de ejemplo';

  @override
  String get homeDemoInputHint => 'Escribe algo…';

  @override
  String get homeToggleLoading => 'Alternar carga';

  @override
  String get homeGlassOnLight => 'Predeterminado';

  @override
  String get homeGlassPanel => 'Panel';

  @override
  String get homeGlassOnGradient => 'Acento';

  @override
  String get homeTypographySample => 'Pequeñas decisiones, grandes cambios';

  @override
  String get categories => 'Categorías';

  @override
  String get profile => 'Perfil';

  @override
  String get profileSectionAccount => 'Cuenta';

  @override
  String get addCategory => 'Añadir categoría';

  @override
  String get editCategory => 'Editar categoría';

  @override
  String get deleteCategory => 'Eliminar categoría';

  @override
  String get categoryName => 'Nombre de categoría';

  @override
  String get categoryNameRequired => 'Introduce el nombre de la categoría';

  @override
  String get categoryNameTooShort => 'El nombre es demasiado corto';

  @override
  String get updateCategory => 'Actualizar categoría';

  @override
  String get deleteCategoryConfirmation => '¿Eliminar esta categoría?';

  @override
  String get categoryDeletedSuccessfully => 'Categoría eliminada';

  @override
  String get categoryUpdatedSuccessfully => 'Categoría actualizada';

  @override
  String get noCategoriesYet => 'Aún no hay categorías';

  @override
  String get noCategoriesFound => 'No se encontraron categorías';

  @override
  String get addFirstCategory => 'Añade tu primera categoría';

  @override
  String get tryDifferentSearch => 'Prueba otra búsqueda';

  @override
  String get searchCategories => 'Buscar categorías';

  @override
  String get addNewCategoryTooltip => 'Añadir categoría';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get updatePersonalInfo => 'Actualiza tus datos personales';

  @override
  String get personalInformation => 'Datos personales';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get changePasswordButton => 'Actualizar contraseña';

  @override
  String get security => 'Seguridad';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirmation => '¿Cerrar sesión?';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Cargando';

  @override
  String get retry => 'Reintentar';

  @override
  String get version => 'Versión';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get enterCurrentPassword => 'Introduce la contraseña actual';

  @override
  String get enterNewPassword => 'Introduce la nueva contraseña';

  @override
  String get confirmYourNewPassword => 'Confirma la nueva contraseña';

  @override
  String get currentPasswordRequired => 'La contraseña actual es obligatoria';

  @override
  String get newPasswordRequired => 'La nueva contraseña es obligatoria';

  @override
  String get passwordChangedSuccessfully => 'Contraseña cambiada';

  @override
  String get profileUpdatedSuccessfully => 'Perfil actualizado';

  @override
  String get accountDeletedSuccessfully => 'Cuenta eliminada';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmation => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountDescription =>
      'Elimina permanentemente tu cuenta y todos tus datos';

  @override
  String get deleteAccountWarning =>
      'Esta acción no se puede deshacer. Todos tus datos se eliminarán permanentemente.';

  @override
  String get dangerZone => 'Zona de riesgo';

  @override
  String get manageAccount => 'Gestiona tu cuenta';

  @override
  String get emailRequired => 'El correo es obligatorio';

  @override
  String get emailInvalid => 'Introduce un correo válido';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String passwordTooShort(int minLength) {
    return 'La contraseña debe tener al menos $minLength caracteres';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'La nueva contraseña debe tener al menos $minLength caracteres';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName es obligatorio';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName debe tener al menos $minLength caracteres';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName solo debe contener letras';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName es obligatorio';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName debe ser un número válido';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName debe ser mayor que cero';
  }

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get last7Days => 'Últimos 7 días';

  @override
  String get last30Days => 'Últimos 30 días';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get past => 'Anteriores';

  @override
  String get ok => 'Aceptar';

  @override
  String get offlineBanner => 'Sin conexión a internet';

  @override
  String get loadMore => 'Cargar más';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appearanceDescription => 'Tema claro, oscuro o del sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'Idioma de la interfaz';

  @override
  String get languageSystem => 'Sistema (sin símbolo)';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get errorBadRequest => 'Solicitud incorrecta';

  @override
  String get errorUnauthorized => 'Inicia sesión';

  @override
  String get errorAccessDenied => 'Acceso denegado';

  @override
  String get errorNotFound => 'No encontrado';

  @override
  String get errorTimeout => 'Tiempo de espera agotado';

  @override
  String get errorValidation => 'Error de validación';

  @override
  String get errorTooManyRequests => 'Demasiadas solicitudes';

  @override
  String get errorServer => 'Error del servidor';

  @override
  String get errorBadGateway => 'Error de pasarela';

  @override
  String get errorServiceUnavailable => 'Servicio no disponible';

  @override
  String get errorGatewayTimeout => 'Tiempo de pasarela agotado';

  @override
  String get errorClient => 'Error del cliente';

  @override
  String get errorRequestCancelled => 'Solicitud cancelada';

  @override
  String get errorInvalidCredentials => 'Datos de acceso incorrectos';

  @override
  String get errorResourceExists => 'El recurso ya existe';

  @override
  String get savingsTagline =>
      'Cada compra impulsiva que evitas construye tu futuro';

  @override
  String get recordSaving => 'No lo gasté';

  @override
  String get savedToday => 'Ahorrado hoy';

  @override
  String get savedThisMonth => 'Este mes';

  @override
  String get savedTotal => 'Ahorro registrado total';

  @override
  String get investedTotal => 'Realmente apartado';

  @override
  String get monthlyPace => 'Ritmo mensual';

  @override
  String get futureProjection => 'Ahorro futuro';

  @override
  String get yearsAtCurrentPace => 'años al ritmo actual';

  @override
  String get interestIncome => 'Intereses';

  @override
  String get contributions => 'Tus aportaciones';

  @override
  String get savingsDynamics => 'Ahorro por mes';

  @override
  String get recentSavings => 'Decisiones recientes';

  @override
  String get noSavingsYet => 'Aún no has registrado ahorro';

  @override
  String get habits => 'Impulsos';

  @override
  String get habitsDescription =>
      'Edita precios y accesos para las compras que quieres evitar';

  @override
  String get history => 'Historial';

  @override
  String get historyDescription =>
      'Cada pequeña decisión que construyó tu futuro';

  @override
  String get goals => 'Objetivos';

  @override
  String get addGoal => 'Añadir objetivo';

  @override
  String get goalName => 'Nombre del objetivo';

  @override
  String get targetAmount => 'Importe objetivo';

  @override
  String get noGoalsYet => 'Añade un objetivo para ver tu progreso';

  @override
  String get impulseItem => '¿Qué compra evitaste?';

  @override
  String get amount => 'Importe';

  @override
  String get actuallySetAside => 'Realmente aparté este dinero';

  @override
  String get actuallySetAsideDescription =>
      'Distingue el ahorro potencial del capital real';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get record => 'Registrar';

  @override
  String get editHabit => 'Editar impulso';

  @override
  String get addHabit => 'Añadir impulso';

  @override
  String get habitName => 'Nombre del impulso';

  @override
  String get defaultPrice => 'Precio habitual';

  @override
  String get timesPerWeek => 'Veces por semana';

  @override
  String get frequencyZeroHint => '0 significa una vez al mes';

  @override
  String get oncePerMonth => 'una vez al mes';

  @override
  String get chooseIcon => 'Icono';

  @override
  String get deleteHabitConfirmation =>
      '¿Eliminar este acceso? El historial se conserva.';

  @override
  String get deleteSavingConfirmation => '¿Eliminar este registro de ahorro?';

  @override
  String get noHabits => 'Aún no hay accesos de impulsos';

  @override
  String get noHistory => 'Aquí aparecerá tu historial de ahorro';

  @override
  String get weekShort => 'semana';

  @override
  String get rateAndHorizon => 'Tasa y plazo';

  @override
  String get annualRate => 'Tasa anual del depósito';

  @override
  String get projectionYears => 'Años del pronóstico';

  @override
  String get apply => 'Aplicar';

  @override
  String get noData => 'Aún no hay suficientes datos';

  @override
  String get quickChoices => 'Elección rápida';

  @override
  String get quickChoicesDescription => 'Elige la compra que acabas de evitar';

  @override
  String get recordThisSaving => 'No gasté';

  @override
  String get annualPotential => 'Potencial anual';

  @override
  String get weeklyPotential => 'Semana habitual';

  @override
  String get savingsBreakdown => 'Cómo se forma tu capital';

  @override
  String get topSavingsSources => 'Tus mayores fuentes de ahorro';

  @override
  String get currentPace => 'Ritmo actual';

  @override
  String get decisionCount => 'Decisiones para tu futuro';

  @override
  String get allSavings => 'Todas las decisiones';

  @override
  String get realSavings => 'Realmente apartado';

  @override
  String get potentialSavings => 'Aún no apartado';

  @override
  String get compoundEffect => 'Efecto del interés compuesto';

  @override
  String get projectionExplanation =>
      'Es un escenario, no un saldo: todo el ahorro registrado se aparta, se mantiene el ritmo de los últimos 90 días y los intereses se capitalizan mensualmente. La tasa es hipotética; no se garantizan rendimientos.';

  @override
  String get impulseAnnualHint =>
      'Según la frecuencia elegida de compras evitadas';

  @override
  String projectionScenario(int years, String rate) {
    return 'Tras $years años al $rate% anual con aportaciones mensuales. Se supone que apartas todo el ahorro; no se garantizan rendimientos.';
  }

  @override
  String projectionAfterYears(int years) {
    return 'Tras $years años con intereses';
  }

  @override
  String get oneSkippedPurchase => 'Una compra evitada';

  @override
  String get regularlySkippedPurchases => 'Compras evitadas regularmente';

  @override
  String get editImpulse => 'Personalizar';

  @override
  String get historyOverview => 'Tus decisiones de un vistazo';

  @override
  String get noFilteredHistory =>
      'No hay decisiones de este grupo entre los registros cargados';

  @override
  String get loadMoreHistory => 'Mostrar más';

  @override
  String historyLoadedCount(int count, int total) {
    return 'Cargadas $count de $total decisiones';
  }

  @override
  String get projectionTableTitle => 'Importes año a año';

  @override
  String get projectionTableYear => 'Año';

  @override
  String get projectionTableTotal => 'Total';

  @override
  String get habitPaused => 'En pausa · no cuenta en el potencial total';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get editSaving => 'Editar registro';

  @override
  String get moneyFormatError => 'Introduce hasta 10 dígitos y 2 decimales';

  @override
  String get frequencyRangeError => 'Introduce un entero entre 0 y 50';

  @override
  String get habitActive => 'Incluir este hábito';

  @override
  String get habitActiveDescription =>
      'Pausarlo lo excluye de elecciones rápidas y potencial total; el historial se conserva';

  @override
  String get editGoal => 'Editar objetivo';

  @override
  String get goalReached => 'El importe objetivo está apartado';

  @override
  String goalRemaining(String amount) {
    return 'Falta por apartar: $amount';
  }

  @override
  String get goalProgressExplanation =>
      'El progreso solo cuenta el dinero asignado a este objetivo. Una misma cantidad no cuenta en varios objetivos.';

  @override
  String get rateFormatError =>
      'Introduce una tasa entre 0 y 100% con hasta dos decimales';

  @override
  String get savingRecordedMessage => 'Decisión registrada';

  @override
  String get savingUpdatedMessage => 'Registro actualizado';

  @override
  String get habitSavedMessage => 'Hábito guardado';

  @override
  String get goalSavedMessage => 'Objetivo guardado';

  @override
  String get settingsSavedMessage => 'Pronóstico actualizado';

  @override
  String get entryDeletedMessage => 'Registro eliminado';

  @override
  String get changesSavedMessage => 'Cambios guardados';

  @override
  String get savingsSummaryUnavailable =>
      'El total no está disponible; el historial sigue aquí';

  @override
  String get savingsDataLoadFailed =>
      'No se pudieron cargar los datos. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get refresh => 'Actualizar';

  @override
  String get monthlyAmounts => 'Importes mensuales';

  @override
  String get customSaving => 'Otra decisión';

  @override
  String get customSavingHint =>
      'Registro único: no se creará un hábito nuevo.';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'Una compra evitada: $amount en $years años.';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'Si apartas este importe ahora al $rate% anual con capitalización mensual y sin más aportaciones. Es un escenario hipotético, no un rendimiento prometido.';
  }

  @override
  String get impulseIconCoffee => 'Café';

  @override
  String get impulseIconRestaurant => 'Cafés y restaurantes';

  @override
  String get impulseIconDelivery => 'Comida a domicilio';

  @override
  String get impulseIconSmoking => 'Cigarrillos';

  @override
  String get impulseIconTaxi => 'Taxi';

  @override
  String get impulseIconShopping => 'Compras';

  @override
  String get impulseIconSubscription => 'Suscripciones';

  @override
  String get impulseIconOther => 'Otros';

  @override
  String get scenarioComparison => '¿Y si comprara menos veces?';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'Precio: $amount · tasa hipotética: $rate%';
  }

  @override
  String get scenarioBaseline => 'Ahora';

  @override
  String get scenarioModerate => 'Opción moderada';

  @override
  String get scenarioMinimal => 'Opción mínima';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name: $count compras por semana';
  }

  @override
  String get scenarioOwnMoney => 'Aportaciones';

  @override
  String get scenarioAssumptions =>
      'Diferencia respecto a la frecuencia actual. 52 semanas al año; todo el ahorro se deposita al final de cada mes con capitalización mensual. Sin capital inicial, impuestos ni inflación; no se garantizan rendimientos. Este cálculo no crea registros.';

  @override
  String get allocateGoal => 'Asignar dinero';

  @override
  String get allocatedAmount => 'Total asignado a este objetivo';

  @override
  String unallocatedMoney(String amount) {
    return 'Disponible para objetivos: $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'Puedes asignar hasta $amount a este objetivo';
  }

  @override
  String get allocationInvalid =>
      'Introduce un importe de 0 o más con hasta dos decimales';

  @override
  String get allocationTooLarge =>
      'No hay suficiente dinero disponible o se supera el objetivo';

  @override
  String get goalBelowAllocation => 'Libera primero el importe asignado de más';

  @override
  String get releaseAllocationsFirst =>
      'Estos fondos están asignados a objetivos. Reduce primero las asignaciones.';

  @override
  String get releaseGoalMoney => 'Liberar el dinero del objetivo';

  @override
  String get allocationHint =>
      'Establece el total asignado, no un ingreso adicional. 0 devuelve el dinero al saldo disponible. No se realiza ninguna transferencia bancaria.';

  @override
  String get allocationSaved => 'Dinero asignado';

  @override
  String get savingReceipt => 'Recibo de compra evitada';

  @override
  String get weeklyReceipt => 'Mis decisiones de 7 días';

  @override
  String get receiptPurchaseNotMade => 'Compra no realizada';

  @override
  String get receiptPrivateDecision => 'Una decisión para mí';

  @override
  String get receiptFooter =>
      'Registro personal de una compra evitada. No es un extracto bancario ni un recibo fiscal.';

  @override
  String get receiptHideName => 'Ocultar nombre de compra';

  @override
  String get receiptExport => 'Guardar / compartir PNG';

  @override
  String get receiptExportFailed =>
      'No se pudo exportar el recibo. Inténtalo de nuevo.';

  @override
  String get favoriteActions => 'Mis tres decisiones rápidas';

  @override
  String get favoriteActionsHint =>
      'Elige Añadir a favoritos en el menú de un hábito. Hasta tres acciones aparecerán aquí y en el widget del teléfono. Para añadirlo, mantén pulsada la pantalla de inicio → Widgets → No gastado.';

  @override
  String get addFavorite => 'Añadir a favoritos / widget';

  @override
  String get removeFavorite => 'Quitar de favoritos';

  @override
  String get favoriteLimit => 'Ya tienes tres favoritos. Quita uno primero.';

  @override
  String get widgetItemUnavailable =>
      'Este elemento fue eliminado, pausado o no está disponible para esta cuenta';
}
