import 'package:get_it/get_it.dart';
import 'package:madad_advice/models/langs.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => Langs());
}
