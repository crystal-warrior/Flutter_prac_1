import '../../../../core/models/user.dart';
import 'shared_preferences_data_source.dart';
import 'secure_storage_data_source.dart';

class LocalAuthDataSource {

  final Map<String, User> _usersCache = {};
  final SharedPreferencesDataSource _sharedPrefs;
  final SecureStorageDataSource _secureStorage;

  LocalAuthDataSource(this._sharedPrefs, this._secureStorage);

  Future<User?> authenticate(String login, String password) async {

    final savedPassword = await _secureStorage.getPassword(login);
    

    if (savedPassword == null) {
      print('Пароль не найден в SecureStorage для пользователя: $login');
      return null;
    }
    
    if (savedPassword != password) {
      print('Пароль не совпадает для пользователя: $login');
      return null;
    }

    final isRegistered = await _sharedPrefs.isUserRegistered(login);
    if (!isRegistered) {
      print('Пользователь $login не зарегистрирован');
      return null;
    }

    final userData = await _sharedPrefs.getUserData(login);

    final user = User(
      login: login,
      password: password,
      phone: userData['phone'],
      email: userData['email'],
      region: userData['region'],
      city: userData['city'],
      address: userData['address'],
    );
    

    _usersCache[login] = user.copyWith(password: '');
    
    print('✅ Пользователь $login успешно аутентифицирован');
    return user;
  }

  Future<void> register(User user) async {

    await _sharedPrefs.saveUserData(
      user.login,
      user.phone,
      user.email,
      user.region,
      user.city,
      user.address,
    );
    

    _usersCache[user.login] = user.copyWith(password: '');
  }

  Future<User?> getCurrentUser() async {

    return null;
  }
}


