abstract class LoginRepository {
  Future login(String email, String senha);
  Future register(String userName ,String email, String senha);
}