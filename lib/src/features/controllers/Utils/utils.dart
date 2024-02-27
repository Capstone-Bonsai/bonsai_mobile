String validatePassword(String password) {
  if (password.length < 6) {
    return "Mật khẩu phải trên 6 kí tự";
  }
  
  bool hasUppercase = false;
  for (int i = 0; i < password.length; i++) {
    if (password[i].toUpperCase() == password[i]) {
      hasUppercase = true;
      break;
    }
  }
  if (!hasUppercase) {
    return "Mật khẩu phải có ít nhất một kí tự viết hoa";
  }
  
  bool hasNumber = false;
  for (int i = 0; i < password.length; i++) {
    if (int.tryParse(password[i]) != null) {
      hasNumber = true;
      break;
    }
  }
  if (!hasNumber) {
    return "Mật khẩu phải có ít nhất một số";
  }

  bool hasSpecialChar = false;
  RegExp specialCharRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
  if (specialCharRegex.hasMatch(password)) {
    hasSpecialChar = true;
  }
  if (!hasSpecialChar) {
    return "Mật khẩu phải có ít nhất một kí tự đặc biệt";
  }

  return "Đúng";
}