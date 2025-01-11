import 'auth_repository.dart';
import 'tab_repository.dart';

class Repository {
  final AuthRepository authApi;
  final TabRepository tabApi;

  Repository({
    required this.authApi,
    required this.tabApi,
  });
}