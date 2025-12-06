class User {
  final String login;
  final String password;
  final String? phone;
  final String? email;
  final String? region;

  const User({
    required this.login,
    required this.password,
    this.phone,
    this.email,
    this.region,
  });

  User copyWith({
    String? login,
    String? password,
    String? phone,
    String? email,
    String? region,
  }) {
    return User(
      login: login ?? this.login,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      region: region ?? this.region,
    );
  }

  bool get hasContactInfo => phone != null || email != null;

  @override
  bool operator ==(Object other) =>
      other is User &&
          login == other.login &&
          password == other.password &&
          phone == other.phone &&
          email == other.email &&
          region == other.region;

  @override
  int get hashCode => Object.hash(login, password, phone, email, region);
}