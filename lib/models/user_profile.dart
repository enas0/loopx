class UserProfile {
  final String name;
  final String bio;
  final String education;
  final String experience;
  final String projects;
  final List<String> skills;

  UserProfile({
    required this.name,
    required this.bio,
    required this.education,
    required this.experience,
    required this.projects,
    required this.skills,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      education: map['education'] ?? '',
      experience: map['experience'] ?? '',
      projects: map['projects'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'education': education,
      'experience': experience,
      'projects': projects,
      'skills': skills,
      'updatedAt': DateTime.now(),
    };
  }
}
