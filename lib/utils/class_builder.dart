import 'package:mipusec2/screens/advertisements.dart';
import 'package:mipusec2/screens/examination.dart';
import 'package:mipusec2/screens/home.dart';
import 'package:mipusec2/screens/notice.dart';
import 'package:mipusec2/screens/results.dart';
import 'package:mipusec2/screens/syllabus.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor;
}

class ClassBuilder {
  static void registerClasses() {
    register<HomePage>(() => HomePage());
    register<ExaminationPage>(() => ExaminationPage());
    register<NoticePage>(() => NoticePage());
    register<SyllabusPage>(() => SyllabusPage());
    register<ResultsPage>(() => ResultsPage());
    register<AdvertisementPage>(() => AdvertisementPage());
  }

  static dynamic fromString(String type) {
    return _constructors[type]();
  }
}
