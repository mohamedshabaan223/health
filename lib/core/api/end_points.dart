class EndPoints {
  static String baseUrl = "http://10.0.2.2:5282/Api/";
  static String login = "V1/Account/Login";
  static String register = "V1/Account/Register";
  static String getAllDoctors = "V1/Doctors/GetAllDoctors";
  static String payment = "Payment/Pay";
  static String paymentConfirm = "Payment/payment-success";
  static String allSpecialities = "V1/Specialization/GetAllSpecializations";
  static String getAllMessages = "V1/Chat/GetMessage";
  static String sendMessage = "V1/Chat/SendMessage";
  static String getUserProfile = "V1/Profile/GetUserProfile";
  static String updateUserProfile = "V1/Profile/UpdateUserProfile";
  static String getAllChats = "V1/Chat/GetAllChats";
  static String addFavoriteDoctor = "V1/Doctors/AddFavoriteDR";
  static String removeFavoriteDoctor = "V1/Doctors/RemoveFavoriteDR";
  static String getAllFavoriteDoctors = "V1/Doctors/GetAllDoctors";
  static String deleteAccount = 'V1/Account/DeleteAccount';
}

class ApiKey {
  static String status = 'status';
  static String errorMessage = 'ErrorMessage';
  static String email = 'email';
  static String password = 'password';
  static String token = 'token';
  static String message = 'message';
  static String username = 'userName';
  static String phone = 'phone';
  static String doctorId = 'id';
  static String doctorName = 'doctorName';
  static String doctorSpeciality = 'specializationName';
  static String doctorPhone = 'phone';
}
