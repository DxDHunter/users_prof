class User {
  final String id;
  final String lastName;
  final String firstName;
  final String email;
  final String password;
  final String? imageUrl;
  final String? qrCodeUrl;
  final String role;
  final String updatedAt;

  User({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.password,
    this.imageUrl,
    this.qrCodeUrl,
    this.role = 'admin',
    String? updatedAt,
  }): updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  // Convertir en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'qrCodeUrl': qrCodeUrl,
      'role' : role,
      'updatedAt': updatedAt
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),  // Convertit 'id' en String s’il est en int
      lastName: map['lastName'] ?? '',  // Assure une chaîne non nulle
      firstName: map['firstName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      imageUrl: map['imageUrl']?.toString(),
      qrCodeUrl: map['qrCodeUrl']?.toString(),
      role: map['role']?.toString() ?? 'user',
      updatedAt: map['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }


  // Créer un objet User à partir d'un JSON (comme une réponse du serveur)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
      qrCodeUrl: json['qrCodeUrl'],
      role: json['role'] ?? 'user',
      updatedAt: json['updatedAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  // Méthode copyWith pour créer une copie de User avec des valeurs modifiées
  User copyWith({
    String? id,
    String? lastName,
    String? firstName,
    String? email,
    String? password,
    String? imageUrl,
    String? qrCodeUrl,
    String? role,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      role: role ?? this.role,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
