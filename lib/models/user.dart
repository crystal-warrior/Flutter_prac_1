
class User {
  final String login;

  const User({required this.login});

  @override
  bool operator ==(Object other) => other is User && login == other.login;

  @override
  int get hashCode => login.hashCode;
}