class ShopModel {
  final int? id;
  final String? username;
  final String? email;
  final String? access_token;

  ShopModel({
    this.id,
    this.username,
    this.email,
    this.access_token,
  });

  // Factory constructor to create a ShopModel instance from a map
  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] ?? 0,
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      access_token: map['access_token'] ?? "",
    );
  }

  // Method to convert a ShopModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'access_token': access_token,
    };
  }
}


