import 'dart:io';

import 'package:unlimited_things_dart/unlimited_things_dart.dart';

import '../core/generators/locale_keys_generator.dart';
import '../core/processes/dart_format.dart';

void main() async {
  final toSave = Directory.current.getFolderFromList(
    ['lib', 'core', 'localization'],
  ).getFile('translations_keys.dart');
  LocaleKeysGeneratorAutoSave.fromAssetsFile(
    toSave: toSave,
    file: Directory.current
        .getFolderFromList(['assets', 'locale']).getFile('ru.json'),
  ).generateFile();
  await runDartFormat([toSave]);
  exit(0);
}