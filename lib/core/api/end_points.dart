class EndPoints {
  static String baseUrl = "http://medicalservicesproject.runasp.net";
  static String getAllDoctors = "/Api/V1/Doctors/GetAllDoctors";
  static String allSpecialities =
      "/Api/V1/Specialization/GetAllSpecializations";
  static String getAllMessages = "/Api/V1/Chat/GetMessage";
  static String sendMessage = "/Api/V1/Chat/SendMessage";
  static String getUserProfile = "/Api/V1/Profile/GetUserProfile";
  static String updateUserProfile = "/Api/V1/Profile/UpdateUserProfile";
  static String getAllChats = "/Api/V1/Chat/GetAllChats";
  static String addFavoriteDoctor = "/Api/V1/Doctors/AddFavoriteDR";
  static String removeFavoriteDoctor = "/Api/V1/Doctors/RemoveFavoriteDR";
  static String deleteAccount = '/Api/V1/Account/DeleteAccount';
  static String doctorUpdateProfile = '/Api/V1/Profile/UpdateDoctorProfile';
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
