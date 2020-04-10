
class User {

  final String uid;
  final String email;
  final String name;
  final String role;
  final String token;

  User({this.uid,this.email, this.name,this.role, this.token});

  factory User.fromMap(Map data) {
    data = data ?? { };
    return User(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      token: data['token'] ?? '',
    );
  }
}