class User {
  final int? id;
  final String? name;
  final String email;
  final String? photoUrl;
  final String? token;

  User({this.id, this.name, required this.email, this.token, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'token': token};
  }
}
