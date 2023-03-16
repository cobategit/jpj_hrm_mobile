class Profile {
  final String name;
  final String token;
  final String department;

  const Profile({
    required this.name,
    required this.token,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'department': department,
      'token': token,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'tb_profile{name:$name, department: $department}, token: $token';
  }
}
