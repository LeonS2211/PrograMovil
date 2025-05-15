class User {
  int? id;
  String username;
  String password;
  String? email;
  String? image;
  String? fullname;
  String? resetKey;

  User({
    this.id,
    required this.username,
    required this.password,
    this.email,
    this.image,
    this.fullname,
    this.resetKey,
  });

  // Método para crear una instancia desde un mapa (JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      image: json['image'],
      fullname: json['fullname'],
      resetKey: json['reset_key'],
    );
  }

  // Método para convertir la instancia a un mapa (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'image': image,
      'fullname': fullname,
      'reset_key': resetKey,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, fullname: $fullname, password: $password)';
  }
}
