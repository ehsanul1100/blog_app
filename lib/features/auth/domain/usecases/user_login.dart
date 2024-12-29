import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParameters> {
  final AuthRepository authRepository;
  const UserLogin({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserLoginParameters params) async {
    return await authRepository.logInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParameters {
  final String email;
  final String password;

  UserLoginParameters({required this.email, required this.password});
}
