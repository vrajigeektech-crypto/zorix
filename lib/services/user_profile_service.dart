import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      displayName: map['displayName'],
      email: map['email'],
      photoURL: map['photoURL'],
      phoneNumber: map['phoneNumber'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfileService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _collectionName = 'users';

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<void> createOrUpdateUserProfile({
    required String uid,
    String? displayName,
    String? email,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      final now = DateTime.now();
      final DocumentReference docRef = _firestore.collection(_collectionName).doc(uid);
      
      final UserProfile userProfile = UserProfile(
        uid: uid,
        displayName: displayName,
        email: email,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(userProfile.toMap(), SetOptions(merge: true));
      print('User profile saved to Firestore for user: $uid');
    } catch (e) {
      print('Error saving user profile to Firestore: $e');
      rethrow;
    }
  }

  Future<void> updateProfileField({
    required String uid,
    required String field,
    required dynamic value,
  }) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(uid)
          .update({
            field: value,
            'updatedAt': FieldValue.serverTimestamp(),
          });
      print('Updated $field for user: $uid');
    } catch (e) {
      print('Error updating profile field $field: $e');
      rethrow;
    }
  }

  Future<void> syncFromFirebaseAuth() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      print('No authenticated user found');
      return;
    }

    try {
      await createOrUpdateUserProfile(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
      );
      print('User profile synced from Firebase Auth to Firestore');
    } catch (e) {
      print('Error syncing user profile: $e');
    }
  }

  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection(_collectionName).doc(uid).delete();
      print('User profile deleted from Firestore for user: $uid');
    } catch (e) {
      print('Error deleting user profile: $e');
      rethrow;
    }
  }

  Stream<UserProfile?> getUserProfileStream(String uid) {
    return _firestore
        .collection(_collectionName)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
