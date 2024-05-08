class CarMateUser {
  String id;
  String username;
  String email;
  List<dynamic> roles;
  String? photoId;

  CarMateUser(
      {required this.id,
      required this.username,
      required this.email,
      required this.roles,
      this.photoId});

  factory CarMateUser.fromJson(Map<String, dynamic> json) {
    return CarMateUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: json['roles'],
      photoId: json['photoId'],
    );
  }
}
