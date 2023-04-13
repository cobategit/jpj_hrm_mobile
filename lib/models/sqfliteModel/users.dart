class Users {
  final String email;
  final String password;
  final String token;

  const Users({
    required this.email,
    required this.password,
    required this.token,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'token': token,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'tb_users{email: $email, password: $password, token: $token}';
  }
}
