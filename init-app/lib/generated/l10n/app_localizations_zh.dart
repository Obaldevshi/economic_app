// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String projectionPeriod(int years) {
    return '$years 年';
  }

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get financialSettings => '财务设置';

  @override
  String get financialRegion => '财务地区';

  @override
  String get recordCurrency => '记账货币';

  @override
  String get displayCurrency => '显示货币';

  @override
  String get currencyLedgerHint => '切换记账货币会打开独立账本。原有记录和目标保留原币种。查看等值金额请使用显示货币。';

  @override
  String get regionalDefaultsHint => '地区提供货币、初始参考价格和利率参考值。价格仅添加到空账本，您的修改会被保留。';

  @override
  String get applyRegionDefaults => '应用地区设置';

  @override
  String get conversionHint =>
      '按俄罗斯央行最近公布的官方汇率换算，不修改原始记录。这不是银行买卖价或汇率预测；存款利率、税费和手续费不会换算。';

  @override
  String get rateReferenceHint => '利率是可编辑的情景假设，不是收益承诺。参考来源和时期列在下方。';

  @override
  String get rateNeedsInput => '该地区暂无已核实参考值：初始利率为0%。请填写您的存款条件。';

  @override
  String exchangeRateDate(String date) {
    return '俄罗斯央行汇率 · $date';
  }

  @override
  String get currencyChanged => '记账货币已改变。请刷新后重试。';

  @override
  String get starterPricesHint => '默认价格是可编辑的初始估值，并非统计平均价格。请按自己的消费修改。';

  @override
  String get widgetEmptyHint => '在消费冲动中选择最多三个收藏，点击后确认节省。';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get coinLanguageHint => '标志中的货币符号仅为地区联想。更改语言不会换算金额，也不会改变记录的货币。';

  @override
  String get appName => '没花掉';

  @override
  String get appTagline => '小小选择，更多积蓄。';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get loginSubtitle => '登录以继续';

  @override
  String get createAccount => '创建账户';

  @override
  String get registerSubtitle => '填写信息以开始使用';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get email => '电子邮箱';

  @override
  String get emailHint => '输入电子邮箱';

  @override
  String get password => '密码';

  @override
  String get passwordHint => '输入密码';

  @override
  String get createPasswordHint => '设置密码';

  @override
  String get firstName => '名字';

  @override
  String get firstNameHint => '输入名字';

  @override
  String get lastName => '姓氏';

  @override
  String get lastNameHint => '输入姓氏';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get dontHaveAccount => '还没有账户？';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get signUp => '注册';

  @override
  String get signIn => '登录';

  @override
  String get or => '或';

  @override
  String get createAccountButton => '创建账户';

  @override
  String get accountCreatedSuccessfully => '账户已创建';

  @override
  String get home => '节省';

  @override
  String get homeWelcome => '设计系统';

  @override
  String get homeDescription => '浏览颜色、排版和组件，实时切换主题和语言。';

  @override
  String get homeFeatureCategories => '管理分类和分页';

  @override
  String get homeFeatureProfile => '个人资料、主题和语言';

  @override
  String get homeUiKitTitle => '界面组件库';

  @override
  String get homeUiKitSubtitle => '设计系统';

  @override
  String get homeUiKitDescription => '轻量界面、样式和组件，运行流畅。';

  @override
  String get homeSectionAppearance => '外观';

  @override
  String get homeSectionColors => '颜色';

  @override
  String get homeSectionTypography => '排版';

  @override
  String get homeSectionComponents => '组件';

  @override
  String get homeSectionTokens => '设计变量';

  @override
  String get colorPrimary => '主色';

  @override
  String get colorPrimaryLight => '浅主色';

  @override
  String get colorPrimaryDark => '深主色';

  @override
  String get colorSecondary => '辅助色';

  @override
  String get colorSuccess => '成功';

  @override
  String get colorWarning => '警告';

  @override
  String get colorError => '错误';

  @override
  String get colorSurface => '界面底色';

  @override
  String get colorBackground => '背景';

  @override
  String get homeShowDialog => '显示对话框';

  @override
  String get homeDialogDemoTitle => '对话框示例';

  @override
  String get homeDialogDemoContent => '界面组件库的确认对话框。';

  @override
  String get homeFontFamily => '字体系列';

  @override
  String get homeFontRegular => '常规';

  @override
  String get homeFontMedium => '中等';

  @override
  String get homeFontBold => '粗体';

  @override
  String get homeSpacing => '间距';

  @override
  String get homeRadius => '圆角半径';

  @override
  String get homeGlassTokens => '界面层';

  @override
  String get homeDemoInputLabel => '示例输入框';

  @override
  String get homeDemoInputHint => '输入内容…';

  @override
  String get homeToggleLoading => '切换加载状态';

  @override
  String get homeGlassOnLight => '默认';

  @override
  String get homeGlassPanel => '面板';

  @override
  String get homeGlassOnGradient => '强调色';

  @override
  String get homeTypographySample => '小小选择，大大改变';

  @override
  String get categories => '分类';

  @override
  String get profile => '个人资料';

  @override
  String get profileSectionAccount => '账户';

  @override
  String get addCategory => '添加分类';

  @override
  String get editCategory => '编辑分类';

  @override
  String get deleteCategory => '删除分类';

  @override
  String get categoryName => '分类名称';

  @override
  String get categoryNameRequired => '请输入分类名称';

  @override
  String get categoryNameTooShort => '名称太短';

  @override
  String get updateCategory => '更新分类';

  @override
  String get deleteCategoryConfirmation => '确定删除此分类？';

  @override
  String get categoryDeletedSuccessfully => '分类已删除';

  @override
  String get categoryUpdatedSuccessfully => '分类已更新';

  @override
  String get noCategoriesYet => '暂无分类';

  @override
  String get noCategoriesFound => '未找到分类';

  @override
  String get addFirstCategory => '添加第一个分类';

  @override
  String get tryDifferentSearch => '尝试其他搜索词';

  @override
  String get searchCategories => '搜索分类';

  @override
  String get addNewCategoryTooltip => '添加分类';

  @override
  String get editProfile => '编辑资料';

  @override
  String get updatePersonalInfo => '更新个人信息';

  @override
  String get personalInformation => '个人信息';

  @override
  String get saveChanges => '保存更改';

  @override
  String get changePassword => '修改密码';

  @override
  String get changePasswordTitle => '修改密码';

  @override
  String get changePasswordButton => '更新密码';

  @override
  String get security => '安全';

  @override
  String get logout => '退出登录';

  @override
  String get logoutConfirmation => '确定退出登录？';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get error => '错误';

  @override
  String get loading => '加载中';

  @override
  String get retry => '重试';

  @override
  String get version => '版本';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get enterCurrentPassword => '输入当前密码';

  @override
  String get enterNewPassword => '输入新密码';

  @override
  String get confirmYourNewPassword => '再次输入新密码';

  @override
  String get currentPasswordRequired => '请输入当前密码';

  @override
  String get newPasswordRequired => '请输入新密码';

  @override
  String get passwordChangedSuccessfully => '密码已修改';

  @override
  String get profileUpdatedSuccessfully => '资料已更新';

  @override
  String get accountDeletedSuccessfully => '账户已删除';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountConfirmation => '确定删除账户？';

  @override
  String get deleteAccountDescription => '永久删除账户及全部数据';

  @override
  String get deleteAccountWarning => '此操作不可撤销，全部数据将永久删除。';

  @override
  String get dangerZone => '危险操作';

  @override
  String get manageAccount => '管理账户';

  @override
  String get emailRequired => '请输入电子邮箱';

  @override
  String get emailInvalid => '请输入有效邮箱';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String passwordTooShort(int minLength) {
    return '密码至少需要 $minLength 个字符';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return '新密码至少需要 $minLength 个字符';
  }

  @override
  String fieldRequired(String fieldName) {
    return '请填写$fieldName';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName至少需要 $minLength 个字符';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName只能包含文字';
  }

  @override
  String numberRequired(Object fieldName) {
    return '请填写$fieldName';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName必须为有效数字';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName必须大于零';
  }

  @override
  String get passwordsDontMatch => '两次密码不一致';

  @override
  String get last7Days => '近7天';

  @override
  String get last30Days => '近30天';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get past => '过去';

  @override
  String get ok => '确定';

  @override
  String get offlineBanner => '无网络连接';

  @override
  String get loadMore => '加载更多';

  @override
  String get appearance => '外观';

  @override
  String get appearanceDescription => '浅色、深色或跟随系统';

  @override
  String get language => '语言';

  @override
  String get languageDescription => '界面语言';

  @override
  String get languageSystem => '跟随系统（无符号）';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get errorBadRequest => '请求无效';

  @override
  String get errorUnauthorized => '请登录';

  @override
  String get errorAccessDenied => '访问被拒绝';

  @override
  String get errorNotFound => '未找到';

  @override
  String get errorTimeout => '请求超时';

  @override
  String get errorValidation => '输入验证错误';

  @override
  String get errorTooManyRequests => '请求过于频繁';

  @override
  String get errorServer => '服务器错误';

  @override
  String get errorBadGateway => '网关错误';

  @override
  String get errorServiceUnavailable => '服务不可用';

  @override
  String get errorGatewayTimeout => '网关超时';

  @override
  String get errorClient => '客户端错误';

  @override
  String get errorRequestCancelled => '请求已取消';

  @override
  String get errorInvalidCredentials => '登录信息错误';

  @override
  String get errorResourceExists => '该资源已存在';

  @override
  String get savingsTagline => '每一次克制冲动消费，都在积累未来';

  @override
  String get recordSaving => '我没花这笔钱';

  @override
  String get savedToday => '今日节省';

  @override
  String get savedThisMonth => '本月';

  @override
  String get savedTotal => '累计记录的节省';

  @override
  String get investedTotal => '实际存下';

  @override
  String get monthlyPace => '每月节省速度';

  @override
  String get futureProjection => '未来积蓄';

  @override
  String get yearsAtCurrentPace => '年，按当前速度';

  @override
  String get interestIncome => '利息收益';

  @override
  String get contributions => '你的投入';

  @override
  String get savingsDynamics => '每月节省';

  @override
  String get recentSavings => '最近的选择';

  @override
  String get noSavingsYet => '尚未记录节省';

  @override
  String get habits => '消费冲动';

  @override
  String get habitsDescription => '编辑你想避免的消费价格和快捷入口';

  @override
  String get history => '历史记录';

  @override
  String get historyDescription => '每个为未来积累的小选择';

  @override
  String get goals => '目标';

  @override
  String get addGoal => '添加目标';

  @override
  String get goalName => '目标名称';

  @override
  String get targetAmount => '目标金额';

  @override
  String get noGoalsYet => '添加目标以查看进度';

  @override
  String get impulseItem => '你放弃了哪笔消费？';

  @override
  String get amount => '金额';

  @override
  String get actuallySetAside => '我确实存下了这笔钱';

  @override
  String get actuallySetAsideDescription => '区分潜在节省与实际资金';

  @override
  String get noteOptional => '备注（可选）';

  @override
  String get record => '记录';

  @override
  String get editHabit => '编辑消费冲动';

  @override
  String get addHabit => '添加消费冲动';

  @override
  String get habitName => '消费名称';

  @override
  String get defaultPrice => '通常价格';

  @override
  String get timesPerWeek => '每周次数';

  @override
  String get frequencyZeroHint => '0 表示每月一次';

  @override
  String get oncePerMonth => '每月一次';

  @override
  String get chooseIcon => '图标';

  @override
  String get deleteHabitConfirmation => '删除此消费快捷入口？历史记录会保留。';

  @override
  String get deleteSavingConfirmation => '删除此节省记录？';

  @override
  String get noHabits => '暂无消费快捷入口';

  @override
  String get noHistory => '你的节省记录将显示在这里';

  @override
  String get weekShort => '周';

  @override
  String get rateAndHorizon => '利率和期限';

  @override
  String get annualRate => '存款年利率';

  @override
  String get projectionYears => '预测年数';

  @override
  String get apply => '应用';

  @override
  String get noData => '数据还不够';

  @override
  String get quickChoices => '快捷选择';

  @override
  String get quickChoicesDescription => '选择你刚刚放弃的消费';

  @override
  String get recordThisSaving => '没花掉';

  @override
  String get annualPotential => '年度潜力';

  @override
  String get weeklyPotential => '典型一周';

  @override
  String get savingsBreakdown => '你的资金如何积累';

  @override
  String get topSavingsSources => '主要节省来源';

  @override
  String get currentPace => '当前速度';

  @override
  String get decisionCount => '为未来作出的选择';

  @override
  String get allSavings => '全部选择';

  @override
  String get realSavings => '实际存下';

  @override
  String get potentialSavings => '尚未存下';

  @override
  String get compoundEffect => '复利效应';

  @override
  String get projectionExplanation =>
      '这是情景预测，不是账户余额：假设每笔记录的节省都被存下，延续过去90天的速度，并按月复利。利率是假设值，收益不保证。';

  @override
  String get impulseAnnualHint => '按所选放弃频率';

  @override
  String projectionScenario(int years, String rate) {
    return '按年利率 $rate%、每月存入，$years 年后的情景。假设所有节省都被存下，收益不保证。';
  }

  @override
  String projectionAfterYears(int years) {
    return '$years 年后（含利息）';
  }

  @override
  String get oneSkippedPurchase => '一次放弃消费';

  @override
  String get regularlySkippedPurchases => '定期放弃消费';

  @override
  String get editImpulse => '自定义';

  @override
  String get historyOverview => '选择一览';

  @override
  String get noFilteredHistory => '已加载记录中没有此类选择';

  @override
  String get loadMoreHistory => '显示更多';

  @override
  String historyLoadedCount(int count, int total) {
    return '已加载 $count 条，共 $total 条选择';
  }

  @override
  String get projectionTableTitle => '逐年金额';

  @override
  String get projectionTableYear => '年份';

  @override
  String get projectionTableTotal => '总额';

  @override
  String get habitPaused => '已暂停 · 不计入总潜力';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get editSaving => '编辑记录';

  @override
  String get moneyFormatError => '请输入最多10位整数、2位小数的金额';

  @override
  String get frequencyRangeError => '请输入0到50之间的整数';

  @override
  String get habitActive => '计入此习惯';

  @override
  String get habitActiveDescription => '暂停后不计入快捷选择和总潜力，历史保留';

  @override
  String get editGoal => '编辑目标';

  @override
  String get goalReached => '目标金额已存下';

  @override
  String goalRemaining(String amount) {
    return '还需存下：$amount';
  }

  @override
  String get goalProgressExplanation => '进度只计算分配给此目标的资金。同一笔钱不会重复计入多个目标。';

  @override
  String get rateFormatError => '请输入0到100%的利率，最多两位小数';

  @override
  String get savingRecordedMessage => '选择已记录';

  @override
  String get savingUpdatedMessage => '记录已更新';

  @override
  String get habitSavedMessage => '习惯已保存';

  @override
  String get goalSavedMessage => '目标已保存';

  @override
  String get settingsSavedMessage => '预测已更新';

  @override
  String get entryDeletedMessage => '记录已删除';

  @override
  String get changesSavedMessage => '更改已保存';

  @override
  String get savingsSummaryUnavailable => '总计暂不可用，历史记录仍保留';

  @override
  String get savingsDataLoadFailed => '无法加载数据，请检查网络后重试。';

  @override
  String get refresh => '刷新';

  @override
  String get monthlyAmounts => '每月金额';

  @override
  String get customSaving => '其他选择';

  @override
  String get customSavingHint => '单次记录，不会创建新习惯。';

  @override
  String oneDecisionProjection(int years, String amount) {
    return '放弃一次消费：$years 年后为 $amount。';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return '假设现在存下这笔钱，年利率 $rate%，按月复利且不再追加。这是假设情景，不是收益承诺。';
  }

  @override
  String get impulseIconCoffee => '咖啡';

  @override
  String get impulseIconRestaurant => '咖啡馆和餐馆';

  @override
  String get impulseIconDelivery => '外卖';

  @override
  String get impulseIconSmoking => '香烟';

  @override
  String get impulseIconTaxi => '出租车';

  @override
  String get impulseIconShopping => '购物';

  @override
  String get impulseIconSubscription => '订阅';

  @override
  String get impulseIconOther => '其他';

  @override
  String get scenarioComparison => '如果我减少购买次数呢？';

  @override
  String scenarioPrice(String amount, String rate) {
    return '价格：$amount · 假设利率：$rate%';
  }

  @override
  String get scenarioBaseline => '现在';

  @override
  String get scenarioModerate => '适度方案';

  @override
  String get scenarioMinimal => '最少方案';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name：每周购买 $count 次';
  }

  @override
  String get scenarioOwnMoney => '投入金额';

  @override
  String get scenarioAssumptions =>
      '与当前频率相比的差额。每年按52周，节省的钱在每月月底存入，按月复利。不计初始资金、税费或通胀，收益不保证。此计算不会创建历史记录。';

  @override
  String get allocateGoal => '分配资金';

  @override
  String get allocatedAmount => '已分配给此目标的总额';

  @override
  String unallocatedMoney(String amount) {
    return '可用于目标的资金：$amount';
  }

  @override
  String allocationCapacity(String amount) {
    return '此目标最多可分配 $amount';
  }

  @override
  String get allocationInvalid => '请输入不小于0的金额，最多两位小数';

  @override
  String get allocationTooLarge => '可用资金不足，或超过目标金额';

  @override
  String get goalBelowAllocation => '请先释放超出的分配金额';

  @override
  String get releaseAllocationsFirst => '这笔资金已分配给目标，请先减少分配额。';

  @override
  String get releaseGoalMoney => '释放此目标的资金';

  @override
  String get allocationHint => '设置分配总额，而非追加存款。设为0会将资金退回可用余额。不会执行银行转账。';

  @override
  String get allocationSaved => '资金已分配';

  @override
  String get savingReceipt => '放弃消费凭条';

  @override
  String get weeklyReceipt => '我近7天的选择';

  @override
  String get receiptPurchaseNotMade => '未进行的消费';

  @override
  String get receiptPrivateDecision => '为自己作出的选择';

  @override
  String get receiptFooter => '放弃消费的个人记录，不是银行账单或税务票据。';

  @override
  String get receiptHideName => '隐藏消费名称';

  @override
  String get receiptExport => '保存／分享PNG';

  @override
  String get receiptExportFailed => '导出凭条失败，请重试。';

  @override
  String get favoriteActions => '我的三个快捷选择';

  @override
  String get favoriteActionsHint =>
      '在习惯菜单中选择添加到收藏。最多三个操作将显示在此处和手机小组件中。添加方式：长按主屏幕 → 小组件 → 没花掉。';

  @override
  String get addFavorite => '添加到收藏／小组件';

  @override
  String get removeFavorite => '从收藏移除';

  @override
  String get favoriteLimit => '已有三个收藏，请先移除一个。';

  @override
  String get widgetItemUnavailable => '此项目已删除、已暂停，或不属于当前账户';
}
