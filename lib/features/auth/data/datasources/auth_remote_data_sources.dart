import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as sb;

abstract interface class AuthRemoteDataSource {
  sb.User? get currentUser;
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<UserModel> logInWithEmailPassword(
      {required String email, required String password});
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final sb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  @override
  sb.User? get currentUser => firebaseAuth.currentUser;
  AuthRemoteDataSourceImpl(
      {required this.firebaseAuth, required this.firebaseFirestore});
  @override
  Future<UserModel> logInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const ServerException(
          message: "User Login failed",
        );
      } else {
        final userDoc = await firebaseFirestore
            .collection('users')
            .doc(response.user!.uid)
            .get();
        if (!userDoc.exists) {
          throw const ServerException(
            message: "User data not found",
          );
        }
        final userData = userDoc.data()!;
        return UserModel.fromJson(userData);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const ServerException(
          message: "User creation failed",
        );
      } else {
        await firebaseFirestore
            .collection('users')
            .doc(response.user!.uid)
            .set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return UserModel.fromJson({
        'uid': response.user!.uid,
        'email': response.user!.email,
        'name': name,
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser != null) {
        final userDoc = await firebaseFirestore
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        if (!userDoc.exists) {
          throw const ServerException(
            message: "User data not found",
          );
        }
        final userData = userDoc.data()!;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
