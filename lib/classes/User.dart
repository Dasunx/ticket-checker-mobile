class User {
  String userId;
  String name;
  String role;
  String email;
  String token;

  User(this.userId, this.email, this.name, this.role, this.token);
  User.w();
  Map<String, dynamic> userToJson() => {
        'userId': userId,
        'email': email,
        'name': name,
        'role': role,
        'token': token,
      };

  User.userFromJson(Map<String, dynamic> json)
      : userId = json['user']['_id'],
        email = json['user']['email'],
        name = json['user']['name'],
        role = json['user']['role'],
        token = json['token'];

  User.managerFromJson(Map<String, dynamic> json)
      : userId = json['_id'],
        email = json['email'],
        name = json['name'],
        role = json['role'];
}
