class CarMateUser {
  String id;
  String username;
  String email;
  List<dynamic> roles;
  bool isEmailConfirmed;
  bool isGoogleAuth;
  String? photoId;

  CarMateUser(
      {required this.id,
      required this.username,
      required this.email,
      required this.roles,
      required this.isEmailConfirmed,
      required this.isGoogleAuth,
      this.photoId});

  factory CarMateUser.fromJson(Map<String, dynamic> json) {
    return CarMateUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: json['roles'],
      isEmailConfirmed: json['isEmailConfirmed'],
      isGoogleAuth: json['isGoogleAuth'],
      photoId: json['photoId'],
    );
  }
}
