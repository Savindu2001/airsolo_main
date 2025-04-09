class Config {
  static const String baseUrl = 'http://127.0.0.1:3000'; 

  // Auth REST API Endpoints
  static const String loginEndpoint = '$baseUrl/api/users/login';
  static const String registerEndpoint = '$baseUrl/api/users/register';
  static const String socialLoginEndpoint = '$baseUrl/api/users/social-login';
  static const String forgotPassword = '$baseUrl/api/users/forgot-password';
  static const String verifyEmail = '$baseUrl/api/users/send-verification-email';

  // Hostel REST API Endpoints
  static const String getHostelsEndpoint = '$baseUrl/api/hostels';
  static const String getHostelByIdEndpoint = '$baseUrl/api/hostels/';

  // Taxi REST API Endpoints
  static const String getTaxisEndpoint = '$baseUrl/api/taxis';
  static const String getTaxiByIdEndpoint = '$baseUrl/api/taxis/';
}
