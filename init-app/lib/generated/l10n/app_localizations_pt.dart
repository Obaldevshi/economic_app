// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get lastNameOptional => 'Sobrenome (opcional)';

  @override
  String get lightPalette => 'Paleta clara';

  @override
  String get darkPalette => 'Paleta escura';

  @override
  String get customColor => 'Cor personalizada · HEX';

  @override
  String get colorHue => 'Matiz';

  @override
  String get resetPalette => 'Restaurar paleta';

  @override
  String get invalidColor => 'Digite 6 caracteres: 0–9, A–F';

  @override
  String get pinCreate => 'Criar um PIN';

  @override
  String get pinEnter => 'Digite seu PIN';

  @override
  String get pinHint =>
      'Quatro dígitos bloqueiam este dispositivo. A senha continua necessária para entrar e sincronizar.';

  @override
  String get pinConfirm => 'Confirme o PIN';

  @override
  String get pinFourDigits => 'PIN · 4 dígitos';

  @override
  String get pinMismatch => 'Os PINs não coincidem. Recomece.';

  @override
  String get pinIncorrect => 'PIN incorreto';

  @override
  String pinWait(int seconds) {
    return 'Tente em $seconds s.';
  }

  @override
  String get pinStorageError =>
      'Não foi possível ler ou salvar o PIN. Entre com a senha.';

  @override
  String get pinLater => 'Depois / cancelar';

  @override
  String get pinUsePassword => 'Entrar com senha';

  @override
  String get pinSettings => 'Definir / alterar PIN';

  @override
  String get pinRemove => 'Desativar PIN';

  @override
  String get pinVerifyFirst => 'Confirme primeiro o PIN atual';

  @override
  String get continueAction => 'Continuar';

  @override
  String get offlineStorageError =>
      'Não foi possível salvar dados. Verifique o espaço disponível.';

  @override
  String get offlineAvailable =>
      'Offline: dados baixados disponíveis. Novos registros ficam neste dispositivo.';

  @override
  String get syncConflict =>
      'Alterações não sincronizadas. O registro no servidor mudou ou precisa de revisão.';

  @override
  String get syncLogin =>
      'Entre novamente para sincronizar. Seus registros locais estão salvos.';

  @override
  String syncPending(int count) {
    return 'Aguardando sincronização: $count';
  }

  @override
  String get syncInProgress => 'Sincronizando…';

  @override
  String get syncNow => 'Sincronizar';

  @override
  String get syncKeepLocal => 'Manter minha versão';

  @override
  String get syncOverwriteWarning =>
      'Sua versão substituirá este registro no servidor. Continuar?';

  @override
  String get syncKeepServer => 'Remover da fila';

  @override
  String get syncDiscardWarning =>
      'Remover a operação com erro e seus registros locais dependentes? Os registros do servidor não são apagados. As alterações locais canceladas serão perdidas.';

  @override
  String get offlineInitialData =>
      'Conecte-se uma vez para baixar o diário desta conta.';

  @override
  String get syncBeforeCurrency =>
      'Sincronize e conecte-se antes de alterar a moeda.';

  @override
  String get localAccountChanged => 'A conta mudou. Reabra esta tela.';

  @override
  String get savedOnDevice => 'Salvo neste dispositivo';

  @override
  String get impulseIconAlcohol => 'Álcool';

  @override
  String get impulseIconSnacks => 'Lanches e doces';

  @override
  String get impulseIconBakery => 'Padaria';

  @override
  String get impulseIconSoda => 'Refrigerantes';

  @override
  String get impulseIconEnergyDrink => 'Energéticos';

  @override
  String get impulseIconFastFood => 'Fast-food';

  @override
  String get impulseIconCinema => 'Cinema';

  @override
  String get impulseIconGames => 'Jogos e compras digitais';

  @override
  String get impulseIconClothes => 'Roupas';

  @override
  String get impulseIconCosmetics => 'Cosméticos';

  @override
  String get impulseIconGadgets => 'Dispositivos';

  @override
  String get impulseIconGifts => 'Presentes';

  @override
  String get impulseIconHobbies => 'Livros e hobbies';

  @override
  String projectionPeriod(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anos',
      one: '$years ano',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get financialSettings => 'Configurações financeiras';

  @override
  String get financialRegion => 'Região financeira';

  @override
  String get recordCurrency => 'Moeda dos registros';

  @override
  String get displayCurrency => 'Moeda de exibição';

  @override
  String get currencyLedgerHint =>
      'A moeda dos registros muda para um livro separado. Registros e metas existentes mantêm a moeda. Use a moeda de exibição para ver equivalentes.';

  @override
  String get regionalDefaultsHint =>
      'A região sugere moeda, preços iniciais e taxa de referência. Preços só são adicionados a um livro vazio; suas edições são preservadas.';

  @override
  String get applyRegionDefaults => 'Aplicar configurações regionais';

  @override
  String get conversionHint =>
      'Conversão pela última taxa oficial do Banco da Rússia. Os registros não mudam. Não é uma taxa comercial ou previsão; juros, impostos e tarifas não são convertidos.';

  @override
  String get rateReferenceHint =>
      'Os juros são um cenário editável, não uma promessa de retorno. Fonte e período aparecem abaixo.';

  @override
  String get rateNeedsInput =>
      'Sem referência verificada: taxa inicial de 0%. Informe as condições do seu depósito.';

  @override
  String exchangeRateDate(String date) {
    return 'Taxa do Banco da Rússia · $date';
  }

  @override
  String get currencyChanged =>
      'A moeda dos registros mudou. Atualize e tente novamente.';

  @override
  String get starterPricesHint =>
      'Os preços são estimativas iniciais editáveis, não médias estatísticas. Ajuste-os às suas compras.';

  @override
  String get widgetEmptyHint =>
      'Escolha até três favoritos em Impulsos. Toque para confirmar uma economia.';

  @override
  String get chooseLanguage => 'Escolher idioma';

  @override
  String get coinLanguageHint =>
      'O símbolo do logo é uma associação regional. O idioma não converte valores nem altera a moeda dos seus registros.';

  @override
  String get appName => 'Não gastei';

  @override
  String get appTagline => 'Pequenas escolhas. Mais economia.';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String get loginSubtitle => 'Entre para continuar';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get registerSubtitle => 'Preencha os dados para começar';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Cadastrar';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'Digite seu e-mail';

  @override
  String get password => 'Senha';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get createPasswordHint => 'Crie uma senha';

  @override
  String get firstName => 'Nome';

  @override
  String get firstNameHint => 'Digite seu nome';

  @override
  String get lastName => 'Sobrenome';

  @override
  String get lastNameHint => 'Digite seu sobrenome';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get signUp => 'Cadastre-se';

  @override
  String get signIn => 'Entrar';

  @override
  String get or => 'ou';

  @override
  String get createAccountButton => 'Criar conta';

  @override
  String get accountCreatedSuccessfully => 'Conta criada';

  @override
  String get home => 'Economia';

  @override
  String get homeWelcome => 'Sistema de design';

  @override
  String get homeDescription =>
      'Explore cores, tipografia e componentes. Altere o tema e o idioma na hora.';

  @override
  String get homeFeatureCategories => 'Gerencie categorias e paginação';

  @override
  String get homeFeatureProfile => 'Perfil, tema e idioma';

  @override
  String get homeUiKitTitle => 'Kit de interface';

  @override
  String get homeUiKitSubtitle => 'Sistema de design';

  @override
  String get homeUiKitDescription =>
      'Superfícies, estilos e componentes leves para uso fluido.';

  @override
  String get homeSectionAppearance => 'Aparência';

  @override
  String get homeSectionColors => 'Cores';

  @override
  String get homeSectionTypography => 'Tipografia';

  @override
  String get homeSectionComponents => 'Componentes';

  @override
  String get homeSectionTokens => 'Variáveis de design';

  @override
  String get colorPrimary => 'Principal';

  @override
  String get colorPrimaryLight => 'Principal claro';

  @override
  String get colorPrimaryDark => 'Principal escuro';

  @override
  String get colorSecondary => 'Secundário';

  @override
  String get colorSuccess => 'Sucesso';

  @override
  String get colorWarning => 'Aviso';

  @override
  String get colorError => 'Erro';

  @override
  String get colorSurface => 'Superfície';

  @override
  String get colorBackground => 'Fundo';

  @override
  String get homeShowDialog => 'Mostrar diálogo';

  @override
  String get homeDialogDemoTitle => 'Exemplo de diálogo';

  @override
  String get homeDialogDemoContent =>
      'Diálogo de confirmação do kit de interface.';

  @override
  String get homeFontFamily => 'Família da fonte';

  @override
  String get homeFontRegular => 'Normal';

  @override
  String get homeFontMedium => 'Médio';

  @override
  String get homeFontBold => 'Negrito';

  @override
  String get homeSpacing => 'Espaçamento';

  @override
  String get homeRadius => 'Raio da borda';

  @override
  String get homeGlassTokens => 'Superfícies';

  @override
  String get homeDemoInputLabel => 'Campo de exemplo';

  @override
  String get homeDemoInputHint => 'Digite algo…';

  @override
  String get homeToggleLoading => 'Alternar carregamento';

  @override
  String get homeGlassOnLight => 'Padrão';

  @override
  String get homeGlassPanel => 'Painel';

  @override
  String get homeGlassOnGradient => 'Destaque';

  @override
  String get homeTypographySample => 'Pequenas escolhas, grandes mudanças';

  @override
  String get categories => 'Categorias';

  @override
  String get profile => 'Perfil';

  @override
  String get profileSectionAccount => 'Conta';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get editCategory => 'Editar categoria';

  @override
  String get deleteCategory => 'Excluir categoria';

  @override
  String get categoryName => 'Nome da categoria';

  @override
  String get categoryNameRequired => 'Informe o nome da categoria';

  @override
  String get categoryNameTooShort => 'O nome é muito curto';

  @override
  String get updateCategory => 'Atualizar categoria';

  @override
  String get deleteCategoryConfirmation => 'Excluir esta categoria?';

  @override
  String get categoryDeletedSuccessfully => 'Categoria excluída';

  @override
  String get categoryUpdatedSuccessfully => 'Categoria atualizada';

  @override
  String get noCategoriesYet => 'Ainda não há categorias';

  @override
  String get noCategoriesFound => 'Nenhuma categoria encontrada';

  @override
  String get addFirstCategory => 'Adicione sua primeira categoria';

  @override
  String get tryDifferentSearch => 'Tente outra busca';

  @override
  String get searchCategories => 'Buscar categorias';

  @override
  String get addNewCategoryTooltip => 'Adicionar categoria';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get updatePersonalInfo => 'Atualize seus dados pessoais';

  @override
  String get personalInformation => 'Dados pessoais';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get changePassword => 'Alterar senha';

  @override
  String get changePasswordTitle => 'Alterar senha';

  @override
  String get changePasswordButton => 'Atualizar senha';

  @override
  String get security => 'Segurança';

  @override
  String get logout => 'Sair';

  @override
  String get logoutConfirmation => 'Sair da conta?';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get error => 'Erro';

  @override
  String get loading => 'Carregando';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get version => 'Versão';

  @override
  String get currentPassword => 'Senha atual';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get confirmNewPassword => 'Confirmar nova senha';

  @override
  String get enterCurrentPassword => 'Digite a senha atual';

  @override
  String get enterNewPassword => 'Digite a nova senha';

  @override
  String get confirmYourNewPassword => 'Confirme a nova senha';

  @override
  String get currentPasswordRequired => 'A senha atual é obrigatória';

  @override
  String get newPasswordRequired => 'A nova senha é obrigatória';

  @override
  String get passwordChangedSuccessfully => 'Senha alterada';

  @override
  String get profileUpdatedSuccessfully => 'Perfil atualizado';

  @override
  String get accountDeletedSuccessfully => 'Conta excluída';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountConfirmation => 'Excluir sua conta?';

  @override
  String get deleteAccountDescription =>
      'Exclua permanentemente sua conta e todos os dados';

  @override
  String get deleteAccountWarning =>
      'Esta ação não pode ser desfeita. Todos os seus dados serão excluídos permanentemente.';

  @override
  String get dangerZone => 'Zona de risco';

  @override
  String get manageAccount => 'Gerencie sua conta';

  @override
  String get emailRequired => 'O e-mail é obrigatório';

  @override
  String get emailInvalid => 'Digite um e-mail válido';

  @override
  String get passwordRequired => 'A senha é obrigatória';

  @override
  String passwordTooShort(int minLength) {
    return 'A senha deve ter pelo menos $minLength caracteres';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'A nova senha deve ter pelo menos $minLength caracteres';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName é obrigatório';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName deve ter pelo menos $minLength caracteres';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName deve conter apenas letras';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName é obrigatório';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName deve ser um número válido';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName deve ser maior que zero';
  }

  @override
  String get passwordsDontMatch => 'As senhas não coincidem';

  @override
  String get last7Days => 'Últimos 7 dias';

  @override
  String get last30Days => 'Últimos 30 dias';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get past => 'Anteriores';

  @override
  String get ok => 'OK';

  @override
  String get offlineBanner => 'Sem conexão com a internet';

  @override
  String get loadMore => 'Carregar mais';

  @override
  String get appearance => 'Aparência';

  @override
  String get appearanceDescription => 'Tema claro, escuro ou do sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'Idioma da interface';

  @override
  String get languageSystem => 'Sistema (sem símbolo)';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get errorBadRequest => 'Solicitação inválida';

  @override
  String get errorUnauthorized => 'Entre na conta';

  @override
  String get errorAccessDenied => 'Acesso negado';

  @override
  String get errorNotFound => 'Não encontrado';

  @override
  String get errorTimeout => 'Tempo de solicitação esgotado';

  @override
  String get errorValidation => 'Erro de validação';

  @override
  String get errorTooManyRequests => 'Muitas solicitações';

  @override
  String get errorServer => 'Erro do servidor';

  @override
  String get errorBadGateway => 'Erro de gateway';

  @override
  String get errorServiceUnavailable => 'Serviço indisponível';

  @override
  String get errorGatewayTimeout => 'Tempo de gateway esgotado';

  @override
  String get errorClient => 'Erro do cliente';

  @override
  String get errorRequestCancelled => 'Solicitação cancelada';

  @override
  String get errorInvalidCredentials => 'Dados de acesso inválidos';

  @override
  String get errorResourceExists => 'O recurso já existe';

  @override
  String get savingsTagline =>
      'Cada compra por impulso evitada constrói seu futuro';

  @override
  String get recordSaving => 'Não gastei';

  @override
  String get savedToday => 'Economizado hoje';

  @override
  String get savedThisMonth => 'Neste mês';

  @override
  String get savedTotal => 'Total economizado registrado';

  @override
  String get investedTotal => 'Realmente guardado';

  @override
  String get monthlyPace => 'Ritmo mensal';

  @override
  String get futureProjection => 'Economia futura';

  @override
  String get yearsAtCurrentPace => 'anos no ritmo atual';

  @override
  String get interestIncome => 'Rendimento de juros';

  @override
  String get contributions => 'Seus aportes';

  @override
  String get savingsDynamics => 'Economia por mês';

  @override
  String get recentSavings => 'Escolhas recentes';

  @override
  String get noSavingsYet => 'Nenhuma economia registrada';

  @override
  String get habits => 'Impulsos';

  @override
  String get habitsDescription =>
      'Edite preços e atalhos das compras que deseja evitar';

  @override
  String get history => 'Histórico';

  @override
  String get historyDescription => 'Cada pequena escolha a favor do seu futuro';

  @override
  String get goals => 'Metas';

  @override
  String get addGoal => 'Adicionar meta';

  @override
  String get goalName => 'Nome da meta';

  @override
  String get targetAmount => 'Valor da meta';

  @override
  String get noGoalsYet => 'Adicione uma meta para acompanhar o progresso';

  @override
  String get impulseItem => 'Qual compra você evitou?';

  @override
  String get amount => 'Valor';

  @override
  String get actuallySetAside => 'Realmente guardei este dinheiro';

  @override
  String get actuallySetAsideDescription =>
      'Separa economia potencial de capital real';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get record => 'Registrar';

  @override
  String get editHabit => 'Editar impulso';

  @override
  String get addHabit => 'Adicionar impulso';

  @override
  String get habitName => 'Nome do impulso';

  @override
  String get defaultPrice => 'Preço habitual';

  @override
  String get timesPerWeek => 'Vezes por semana';

  @override
  String get frequencyZeroHint => '0 significa uma vez por mês';

  @override
  String get oncePerMonth => 'uma vez por mês';

  @override
  String get chooseIcon => 'Ícone';

  @override
  String get deleteHabitConfirmation =>
      'Excluir este atalho? O histórico será mantido.';

  @override
  String get deleteSavingConfirmation => 'Excluir este registro de economia?';

  @override
  String get noHabits => 'Ainda não há atalhos de impulsos';

  @override
  String get noHistory => 'Seu histórico de economia aparecerá aqui';

  @override
  String get weekShort => 'semana';

  @override
  String get rateAndHorizon => 'Taxa e prazo';

  @override
  String get annualRate => 'Taxa anual do depósito';

  @override
  String get projectionYears => 'Anos da projeção';

  @override
  String get apply => 'Aplicar';

  @override
  String get noData => 'Ainda não há dados suficientes';

  @override
  String get quickChoices => 'Escolha rápida';

  @override
  String get quickChoicesDescription => 'Escolha a compra que acabou de evitar';

  @override
  String get recordThisSaving => 'Não gastei';

  @override
  String get annualPotential => 'Potencial anual';

  @override
  String get weeklyPotential => 'Semana habitual';

  @override
  String get savingsBreakdown => 'Como seu capital se forma';

  @override
  String get topSavingsSources => 'Suas maiores fontes de economia';

  @override
  String get currentPace => 'Ritmo atual';

  @override
  String get decisionCount => 'Escolhas para o seu futuro';

  @override
  String get allSavings => 'Todas as escolhas';

  @override
  String get realSavings => 'Realmente guardado';

  @override
  String get potentialSavings => 'Ainda não guardado';

  @override
  String get compoundEffect => 'Efeito dos juros compostos';

  @override
  String get projectionExplanation =>
      'É um cenário, não um saldo: toda a economia registrada é guardada, o ritmo dos últimos 90 dias continua e os juros são compostos mensalmente. A taxa é hipotética; retornos não são garantidos.';

  @override
  String get impulseAnnualHint => 'Na frequência escolhida de compras evitadas';

  @override
  String projectionScenario(int years, String rate) {
    return 'Após $years anos a $rate% ao ano com aportes mensais. Supõe que você guarde toda a economia; retornos não são garantidos.';
  }

  @override
  String projectionAfterYears(int years) {
    return 'Após $years anos com juros';
  }

  @override
  String get oneSkippedPurchase => 'Uma compra evitada';

  @override
  String get regularlySkippedPurchases => 'Compras evitadas regularmente';

  @override
  String get editImpulse => 'Personalizar';

  @override
  String get historyOverview => 'Suas escolhas em resumo';

  @override
  String get noFilteredHistory =>
      'Nenhuma escolha deste grupo nos registros carregados';

  @override
  String get loadMoreHistory => 'Mostrar mais';

  @override
  String historyLoadedCount(int count, int total) {
    return '$count de $total escolhas carregadas';
  }

  @override
  String get projectionTableTitle => 'Valores ano a ano';

  @override
  String get projectionTableYear => 'Ano';

  @override
  String get projectionTableTotal => 'Total';

  @override
  String get habitPaused => 'Pausado · fora do potencial total';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get editSaving => 'Editar registro';

  @override
  String get moneyFormatError => 'Digite até 10 dígitos e 2 casas decimais';

  @override
  String get frequencyRangeError => 'Digite um inteiro de 0 a 50';

  @override
  String get habitActive => 'Incluir este hábito';

  @override
  String get habitActiveDescription =>
      'Pausar remove das escolhas rápidas e do potencial total; o histórico é mantido';

  @override
  String get editGoal => 'Editar meta';

  @override
  String get goalReached => 'O valor da meta está guardado';

  @override
  String goalRemaining(String amount) {
    return 'Falta guardar: $amount';
  }

  @override
  String get goalProgressExplanation =>
      'O progresso conta apenas o dinheiro alocado nesta meta. O mesmo valor não conta para várias metas.';

  @override
  String get rateFormatError =>
      'Digite uma taxa de 0 a 100% com até duas casas decimais';

  @override
  String get savingRecordedMessage => 'Escolha registrada';

  @override
  String get savingUpdatedMessage => 'Registro atualizado';

  @override
  String get habitSavedMessage => 'Hábito salvo';

  @override
  String get goalSavedMessage => 'Meta salva';

  @override
  String get settingsSavedMessage => 'Projeção atualizada';

  @override
  String get entryDeletedMessage => 'Registro excluído';

  @override
  String get changesSavedMessage => 'Alterações salvas';

  @override
  String get savingsSummaryUnavailable =>
      'Os totais estão indisponíveis; seu histórico continua aqui';

  @override
  String get savingsDataLoadFailed =>
      'Não foi possível carregar seus dados. Verifique a conexão e tente novamente.';

  @override
  String get refresh => 'Atualizar';

  @override
  String get monthlyAmounts => 'Valores mensais';

  @override
  String get customSaving => 'Outra escolha';

  @override
  String get customSavingHint =>
      'Registro avulso: nenhum hábito novo será criado.';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'Uma compra evitada: $amount em $years anos.';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'Se guardar este valor agora a $rate% ao ano com juros compostos mensais e sem novos aportes. É um cenário hipotético, não uma promessa de retorno.';
  }

  @override
  String get impulseIconCoffee => 'Café';

  @override
  String get impulseIconRestaurant => 'Cafés e restaurantes';

  @override
  String get impulseIconDelivery => 'Entrega de comida';

  @override
  String get impulseIconSmoking => 'Cigarros';

  @override
  String get impulseIconTaxi => 'Táxi';

  @override
  String get impulseIconShopping => 'Compras';

  @override
  String get impulseIconSubscription => 'Assinaturas';

  @override
  String get impulseIconOther => 'Outros';

  @override
  String get scenarioComparison => 'E se eu comprasse menos vezes?';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'Preço: $amount · taxa hipotética: $rate%';
  }

  @override
  String get scenarioBaseline => 'Agora';

  @override
  String get scenarioModerate => 'Opção moderada';

  @override
  String get scenarioMinimal => 'Opção mínima';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name: $count compras por semana';
  }

  @override
  String get scenarioOwnMoney => 'Aportes';

  @override
  String get scenarioAssumptions =>
      'Diferença da frequência atual. 52 semanas por ano; toda a economia é depositada no fim de cada mês com juros compostos mensais. Sem capital inicial, impostos ou inflação; retornos não são garantidos. Este cálculo não cria registros.';

  @override
  String get allocateGoal => 'Alocar dinheiro';

  @override
  String get allocatedAmount => 'Total alocado nesta meta';

  @override
  String unallocatedMoney(String amount) {
    return 'Disponível para metas: $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'Você pode alocar até $amount nesta meta';
  }

  @override
  String get allocationInvalid =>
      'Digite um valor de 0 ou mais com até duas casas decimais';

  @override
  String get allocationTooLarge =>
      'Saldo disponível insuficiente ou valor da meta excedido';

  @override
  String get goalBelowAllocation => 'Libere primeiro a alocação excedente';

  @override
  String get releaseAllocationsFirst =>
      'Estes fundos estão alocados em metas. Reduza as alocações primeiro.';

  @override
  String get releaseGoalMoney => 'Liberar o dinheiro desta meta';

  @override
  String get allocationHint =>
      'Defina a alocação total, não um depósito adicional. 0 devolve o dinheiro ao saldo disponível. Nenhuma transferência bancária é feita.';

  @override
  String get allocationSaved => 'Dinheiro alocado';

  @override
  String get savingReceipt => 'Recibo de compra evitada';

  @override
  String get weeklyReceipt => 'Minhas decisões em 7 dias';

  @override
  String get receiptPurchaseNotMade => 'Compra não realizada';

  @override
  String get receiptPrivateDecision => 'Uma decisão para mim';

  @override
  String get receiptFooter =>
      'Registro pessoal de uma compra evitada. Não é extrato bancário nem nota fiscal.';

  @override
  String get receiptHideName => 'Ocultar nome da compra';

  @override
  String get receiptExport => 'Salvar / compartilhar PNG';

  @override
  String get receiptExportFailed =>
      'Não foi possível exportar o recibo. Tente novamente.';

  @override
  String get favoriteActions => 'Minhas três decisões rápidas';

  @override
  String get favoriteActionsHint =>
      'Escolha Adicionar aos favoritos no menu de um hábito. Até três ações aparecerão aqui e no widget do celular. Para adicioná-lo, segure a tela inicial → Widgets → Não gastei.';

  @override
  String get addFavorite => 'Adicionar aos favoritos / widget';

  @override
  String get removeFavorite => 'Remover dos favoritos';

  @override
  String get favoriteLimit => 'Você já tem três favoritos. Remova um primeiro.';

  @override
  String get widgetItemUnavailable =>
      'Este item foi excluído, pausado ou não está disponível nesta conta';

  @override
  String get spentTab => 'Gastei';

  @override
  String get forecastTab => 'Projeção';

  @override
  String get homeActualHint =>
      'As expectativas ficam em Projeção. Aqui estão suas decisões: poupança registrada não significa dinheiro já separado.';

  @override
  String get recordSpent => 'Registrar compra';

  @override
  String get openForecast => 'Ver projeção';

  @override
  String get spentIntro =>
      'Só compras por impulso, não despesas diárias. Observe seus hábitos sem se culpar. A poupança e as metas não mudam.';

  @override
  String get spentPrincipal => 'Gasto por impulso';

  @override
  String get spentHistory => 'Histórico de compras por impulso';

  @override
  String get noSpentYet =>
      'Ainda não há compras. Se o impulso vencer, você pode registrar aqui com tranquilidade.';

  @override
  String get spentOpportunity => 'Possível oportunidade perdida';

  @override
  String get spentMissedInterest => 'Juros potenciais não recebidos';

  @override
  String spentPossibleTotal(String amount) {
    return 'Capital + juros: $amount';
  }

  @override
  String spentAssumptions(String rate) {
    return 'Cenário a partir de hoje: separar agora todo o valor a $rate% ao ano, com capitalização mensal, sem novos aportes, impostos ou inflação. Não é uma dívida real nem renda garantida. A compra em si não representa juros perdidos.';
  }

  @override
  String get spentFormHint =>
      'Registre apenas uma compra por impulso opcional. Não é uma economia nem uma retirada das suas metas.';

  @override
  String get deleteSpentConfirm =>
      'Excluir esta compra? A poupança registrada e as metas não mudarão.';

  @override
  String spentLoadedCount(int count, int total) {
    return 'Carregadas $count de $total compras';
  }

  @override
  String spentMissedLine(String amount, int years) {
    return 'Juros possíveis em $years a: $amount';
  }

  @override
  String get spentRecordedMessage => 'Compra registrada';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get resetPasswordTitle => 'Redefinir senha';

  @override
  String get resetPasswordDescription =>
      'Recupere o acesso com um código por email. É preciso internet.';

  @override
  String get sendResetCode => 'Enviar código';

  @override
  String resetCodeNotice(String email) {
    return 'Se $email estiver cadastrado, receberá um código. Confira também o spam. Expira em 10 minutos; após reenviar, use o código mais recente.';
  }

  @override
  String get resetCodeLabel => 'Código do email';

  @override
  String get resetCodeHint => '6 dígitos';

  @override
  String get resetCodeFormat => 'Digite o código de seis dígitos do email';

  @override
  String get resetPasswordSubmit => 'Definir nova senha';

  @override
  String get resetPasswordSuccess => 'Senha alterada';

  @override
  String get resetPasswordSuccessHint =>
      'Entre com sua nova senha. As sessões anteriores do servidor foram revogadas; a poupança e seu diário local foram preservados.';

  @override
  String get resetResendCode => 'Reenviar código';

  @override
  String resetResendCountdown(int seconds) {
    return 'Reenviar em $seconds s';
  }

  @override
  String get resetChangeEmail => 'Alterar email';

  @override
  String get resetBackLogin => 'Voltar para entrar';

  @override
  String get resetCodeInvalid =>
      'Código incorreto, expirado ou já usado. Após cinco erros, solicite um novo.';

  @override
  String get resetMailUnavailable =>
      'Emails de recuperação indisponíveis. Tente mais tarde ou contate mnyvault@gmail.com.';

  @override
  String get resetTooManyRequests =>
      'Muitas tentativas. Tente novamente mais tarde.';

  @override
  String get resetPasswordByteLimit =>
      'A senha deve ter no máximo 72 bytes UTF-8. Caracteres não latinos podem exigir uma senha mais curta.';
}
