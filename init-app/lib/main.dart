import 'package:mobile_template/core/bootstrap.dart';

Future<void> main() async {
  await bootstrap(envFileName: 'assets/env/.env');
}
