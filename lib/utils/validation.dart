bool validateUsername(String? username) {
  if (username == null || username.isEmpty) {
    return false;
  }
  if (username.length < 6) {
    return false;
  }
  // if (username.startsWith(RegExp(r'[0-9]'))) {
  //   return false;
  // }
  // if (username.contains(RegExp(r'[^a-zA-Z0-9\.]'))) {
  //   return false;
  // }
  return true;
}

bool validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return false;
  }
  if (password.length < 6) {
    return false;
  }
  if (password.contains(RegExp(r'[^a-zA-Z0-9\\_]'))) {
    return false;
  }

  return true;
}

bool validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return false;
  }
  if (!email.contains('@')) {
    return false;
  }
  if (!email.contains('.')) {
    return false;
  }
  if (email.startsWith('@')) {
    return false;
  }
  if (email.endsWith('.')) {
    return false;
  }
  return true;
}

//TODO: regex VN
bool validateName(String? name) {
  if (name == null || name.isEmpty) {
    return false;
  }
  if (name.contains(RegExp(r'[^a-zA-Z\\ ]'))) {
    return false;
  }
  if (name.contains(RegExp(r'[0-9]'))) {
    return false;
  }
  if (name.startsWith(' ')) {
    return false;
  }
  if (name.endsWith(' ')) {
    return false;
  }
  if (name.contains('  ')) {
    return false;
  }
  return true;
}

bool validateRoomName(String? name) {
  if (name == null || name.isEmpty) {
    return false;
  }
  if (name.contains(RegExp(r'[^a-zA-Z0-9\\_]'))) {
    return false;
  }
  if (name.startsWith(RegExp(r'[0-9]'))) {
    return false;
  }
  if (name.contains(' ')) {
    return false;
  }
  return true;
}
