import 'package:get_storage/get_storage.dart';

class ALocalStorage{

  static final ALocalStorage _instance = ALocalStorage._internel();

  factory ALocalStorage(){
    return _instance;
  }

  ALocalStorage._internel();


  final _storage = GetStorage();


  //Generic Method to Save Data
  Future<void> saveDate<A>(String key, A value) async {
    await _storage.write(key, value);
  }

  //Generic Method to read data
  A? readDate<A>(String key){
    return _storage.read<A>(key);
  }

  //Generic Method to remove Data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  //Clear All Data
  Future<void> clearAll() async {
    await _storage.erase();
  }

}