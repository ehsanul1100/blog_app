part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  await _initFirebase();

  // Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  // serviceLocator.registerLazySingleton(
  //   () => Hive.box(name: 'blogs'),
  // );

  // serviceLocator.registerFactory(() => InternetConnection());
  // serviceLocator.registerFactory<ConnectionChecker>(
  //   () => ConnectionCheckerImpl(
  //     serviceLocator(),
  //   ),
  // );
}

Future<void> _initFirebase() async {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(
    () => firebaseFirestore,
  );

  //core

  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: serviceLocator(),
      firebaseFirestore: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      authRepository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}
// Compare this snippet from lib/features/auth/data/repositories/auth_repository.dart:

void _initBlog() {
  //data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        firebaseFirestore: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDatasource>(
      () => BlogLocalDatasourceImpl(serviceLocator()),
    )
    //repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(serviceLocator()),
    )
    //usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    //bloc
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
