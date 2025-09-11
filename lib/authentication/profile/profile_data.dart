class ProfileData {
  final String? lifestyle;
  final List<String> activities;

  const ProfileData({
    this.lifestyle,
    this.activities = const [],
  });

  ProfileData copyWith({
    String? lifestyle,
    List<String>? activities,
  }) {
    return ProfileData(
      lifestyle: lifestyle ?? this.lifestyle,
      activities: activities ?? this.activities,
    );
  }
}
