import 'package:localstorage/localstorage.dart';

class Storage<E>{
  static LocalStorage _storage;

  final String boxName;

  Storage(this.boxName){
    _storage = LocalStorage('scrappy_storage');
  }

  Future<E> get() async {
    if(!await _storage.ready) throw('impossibile connettersi al DB');
    E item = await _storage.getItem(boxName) as E;
    print([boxName,item]);
    return item;
  }

  Future<void> set(E value) async {
    if(!await _storage.ready) throw('impossibile connettersi al DB');
    await _storage.setItem(boxName, value);

  }

}