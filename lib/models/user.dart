class UserFields {
  static const tableName = 'users';

  static const id = '_id';
  static const email = 'email';
  static const password = 'password';
  static const fullName = 'full_name';

  static const values = [id, email, password, fullName];
}

class UserModel {
  int? id;
  final String email;
  final String password;
  final String fullName;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.email: email,
        UserFields.password: password,
        UserFields.fullName: fullName,
      };

  static UserModel fromJson(Map<String, Object?> json) => UserModel(
        id: json[UserFields.id] as int?,
        email: json[UserFields.email] as String,
        password: json[UserFields.password] as String,
        fullName: json[UserFields.fullName] as String,
      );

  UserModel copy({
    int? id,
    String? email,
    String? password,
    String? fullName,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
      );
}
