import 'package:localstorage/localstorage.dart';

class Storage{
  static LocalStorage _storage;

  final String boxName;

  Storage(this.boxName){
    _storage = LocalStorage('scrappy_storage');
  }

  Future<dynamic> get() async {
    if(!await _storage.ready) throw('impossibile connettersi al DB');
    dynamic item = await _storage.getItem(boxName);
    return item;
  }

  Future<void> set(dynamic value) async {
    if(!await _storage.ready) throw('impossibile connettersi al DB');
    await _storage.setItem(boxName, value);
  }

}