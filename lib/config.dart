class Config {
  static const String baseUrl = 'http://127.0.0.1:3000'; 
  static const String googleClientId = '785691024956-sl7fp2jktgtsoh854fr1a5nc9au179e4.apps.googleusercontent.com';
  

  // Auth REST API Endpoints
  static const String loginEndpoint = '$baseUrl/api/users/login';
  static const String registerEndpoint = '$baseUrl/api/users/register';
  static const String socialLoginEndpoint = '$baseUrl/api/users/social-login';
  static const String forgotPassword = '$baseUrl/api/users/forgot-password';
  static const String verifyEmail = '$baseUrl/api/users/verify-email';
  static const String verifyEmailCheck = '$baseUrl/api/users/verify-email/check';
  static const String resetPassword = '$baseUrl/api/users/reset-password';

  // Hostel REST API Endpoints
  static const String getHostelsEndpoint = '$baseUrl/api/hostels';
  static const String getHostelByIdEndpoint = '$baseUrl/api/hostels/';

  // Taxi REST API Endpoints
  static const String getTaxisEndpoint = '$baseUrl/api/taxis';
  static const String getTaxiByIdEndpoint = '$baseUrl/api/taxis/';

  // City REST API Endpoints
  static const String cityEndpoint = '$baseUrl/api/city';

  // Information REST API Endpoints
  static const String informationEndpoint = '$baseUrl/api/information';
}
