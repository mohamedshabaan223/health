class EndPoints {
  static String baseUrl = "http://10.0.2.2:5282/Api/V1/";
  static String login = "Account/Login";
  static String register = "Account/Register";
  static String getAllDoctors = "Doctors/GetAllDoctors";
  static String getFemaleDoctors = "Doctors/GetAllDoctors?Gender=0";
  static String getMaleDoctors = "Doctors/GetAllDoctors?Gender=1";
}

class ApiKey {
  static String status = 'status';
  static String errorMessage = 'ErrorMessage';
  static String email = 'email';
  static String password = 'password';
  static String token = 'token';
  static String id = 'id';
  static String message = 'message';
  static String username = 'username';
  static String phone = 'phone';
  static String doctorId = 'id';
  static String doctorName = 'doctorName';
  static String doctorSpeciality = 'specializationName';
  static String doctorPhone = 'phone';
}
