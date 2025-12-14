import '../../../../core/models/user.dart';
import 'shared_preferences_data_source.dart';

class LocalAuthDataSource {

  final Map<String, User> _usersCache = {};
  final SharedPreferencesDataSource _sharedPrefs;

  LocalAuthDataSource(this._sharedPrefs);

  Future<User?> authenticate(String login, String password) async {
    // Проверяем, зарегистрирован ли пользователь
    final isRegistered = await _sharedPrefs.isUserRegistered(login);
    if (!isRegistered) {
      print('Пользователь $login не зарегистрирован');
      return null;
    }

    // Получаем данные пользователя
    final userData = await _sharedPrefs.getUserData(login);
    
    // Проверяем пароль через fallback механизм (если есть)
    // В будущем здесь можно добавить проверку через токен или другой механизм
    // Сейчас просто проверяем, что пользователь зарегистрирован
    // Пароль проверяется на уровне приложения при вводе

    final user = User(
      login: login,
      password: password, // Пароль передается, но не сохраняется
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


