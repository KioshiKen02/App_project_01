class ApiConfig {
  static const String baseUrl = 'http://172.16.42.112:8081';
  static const String updateProfile = '$baseUrl/auth/update-profile';
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String health = '$baseUrl/health';
  static const String getAllUsers = '$baseUrl/auth/users';
  static const String uploadUsers = '$baseUrl/auth/upload_users';

}