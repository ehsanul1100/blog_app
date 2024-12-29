import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<UserModel> logInWithEmailPassword(
      {required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

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
}
