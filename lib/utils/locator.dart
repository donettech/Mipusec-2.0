import 'package:get_it/get_it.dart';
import 'package:mipusec2/services/api.dart';
import 'package:mipusec2/services/file_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => FileService());
}
