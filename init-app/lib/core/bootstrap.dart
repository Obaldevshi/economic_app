import 'package:mobile_template/app/app.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> bootstrap({required String envFileName}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: envFileName);
  await configureDependencies();
  await initializeDateFormatting();
  runApp(const MobileTemplateApp());
}
