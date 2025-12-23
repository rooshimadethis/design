class UserProfile {
  final int id;
  final String name;
  final String avatarMedium;
  final String avatarLarge;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatarMedium,
    required this.avatarLarge,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'] ?? {};
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? 'Guest',
      avatarMedium: avatar['medium'] ?? '',
      avatarLarge: avatar['large'] ?? '',
    );
  }
}
