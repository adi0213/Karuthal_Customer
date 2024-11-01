//const String baseUrl = 'http://104.237.9.211:8007/karuthal/api/v1';
const String baseUrl = 'http://localhost:8007/karuthal/api/v1';

String loginUrl() {
  return '$baseUrl/usermanagement/login';
}

String registerCustomerUrl() {
  return '$baseUrl/persona/regcustomer';
}

String getServicesUrl() {
  return '$baseUrl/metadata/services';
}

String getCreateBookingRequestUrl() {
  return '$baseUrl/bookingrequest/create';
}

String getSignupUrl() {
  return '$baseUrl/persona/signup';
}

String getOtpVerifyUrl() {
  return '$baseUrl/email/verify-otp';
}

String getResetPasswordUrl() {
  return '$baseUrl/usermanagement/users/resetpassword';
}

String getEnrollPatientUrl() {
  return '$baseUrl/persona/enrollpatient';
}
