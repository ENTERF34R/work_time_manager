import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataAccessor {
  Directory? _cacheDir;

  Future<String?> loadData(String filename) async {
    if (_cacheDir == null) {
      await _init();
    }

    if (_cacheDir == null) {
      return null;
    }

    File file = File("${_cacheDir!.path}/$filename");
    if (!await file.exists()) {
      return null;
    }

    try {
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveData(String filename, String data) async {
    if (_cacheDir == null) {
      await _init();
    }

    if (_cacheDir == null) {
      return false;
    }

    File file = File("${_cacheDir!.path}/$filename");

    try {
      if (await file.exists()) {
        file.delete();
      }

      await file.writeAsString(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future _init() async {
    _cacheDir = await getApplicationCacheDirectory();
  }
}