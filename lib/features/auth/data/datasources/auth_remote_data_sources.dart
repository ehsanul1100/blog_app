import 'package:blog_app/core/error/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<String> logInWithEmailPassword(
      {required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});
  @override
  Future<String> logInWithEmailPassword(
      {required String email, required String password}) {
        // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailPassword(
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
      }
      return response.user!.uid;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
