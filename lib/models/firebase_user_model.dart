class FirebaseUser {
  final int id;
  final String firebaseName;
  final String firebaseEmail;
  final String firebaseUid;
  final DateTime timestamp;
  final String? avatar;

  FirebaseUser({
    required this.id,
    required this.firebaseName,
    required this.firebaseEmail,
    required this.firebaseUid,
    required this.timestamp,
    this.avatar,
  });

  factory FirebaseUser.fromJson(Map<String, dynamic> json) {
    return FirebaseUser(
      id: json['id'],
      firebaseName: json['firebase_name'],
      firebaseEmail: json['firebase_email'],
      firebaseUid: json['firebase_uid'],
      timestamp: DateTime.parse(json['timestamp']),
      avatar: json['avatar'],
    );
  }

  factory FirebaseUser.error() {
    return FirebaseUser(
      id: 0,
      firebaseName: '',
      firebaseEmail: '',
      firebaseUid: '',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_name': firebaseName,
      'firebase_email': firebaseEmail,
      'firebase_uid': firebaseUid,
      'timestamp': timestamp.toIso8601String(),
      'avatar': avatar,
    };
  }
}
