abstract class LanguageDisplay {
  final String kAppName = 'Bảo chat';
  final String kUsername;
  final String kPassword;
  final String kName;
  final String kLogin;
  final String kRegister;
  final String kInvalidUsername;
  final String kInvalidPassword;
  final String kCancel;
  final String kIncorrectLoginInfo;
  final String kPleaseRetryLogin;
  final String kInvalidName;
  final String kEmail;
  final String kInvalidEmail;
  final String kRegisterSuccess;
  final String kEmailExists;
  final String kUsernameExists;
  final String kRetry;
  final String kUnknown;
  final String kInvalidRoomName;
  final String kInvite;

  final String kRoomNameExist;
  final String kTeamNameExist;

  final String invalidTeamName;

  LanguageDisplay(
      {required this.kUsername,
      required this.kInvite,
      required this.kPassword,
      required this.kName,
      required this.kLogin,
      required this.kRegister,
      required this.kInvalidUsername,
      required this.kInvalidPassword,
      required this.kCancel,
      required this.kIncorrectLoginInfo,
      required this.kPleaseRetryLogin,
      required this.kInvalidName,
      required this.kEmail,
      required this.kInvalidEmail,
      required this.kRegisterSuccess,
      required this.kEmailExists,
      required this.kUsernameExists,
      required this.kRetry,
      required this.kUnknown,
      required this.kInvalidRoomName,
      required this.kRoomNameExist,
      required this.kTeamNameExist,
      required this.invalidTeamName});
}

class EnglishDisplay extends LanguageDisplay {
  EnglishDisplay()
      : super(
            kUsername: 'Username',
            kPassword: 'Password',
            kName: 'Name',
            kLogin: 'Login',
            kRegister: 'Register',
            kInvalidUsername: 'Invalid username',
            kInvalidPassword: 'Invalid password',
            kCancel: 'Cancel',
            kIncorrectLoginInfo: 'Incorrect login information',
            kPleaseRetryLogin: 'Please retry login',
            kInvalidName: 'Name just contain alphabet chacters',
            kEmail: 'Email',
            kInvalidEmail: 'Invalid email',
            kRegisterSuccess: 'Register success',
            kEmailExists: 'Email already exists',
            kUsernameExists: 'Username already exists',
            kRetry: 'Please retry',
            kUnknown: 'Unknown',
            kInvite: 'Invite',
            kInvalidRoomName:
                'Room name just contain alphabet chacters and underscore',
            kRoomNameExist: 'Room name already exists',
            kTeamNameExist: 'Team name already exists',
            invalidTeamName:
                'Team name just contain alphabet chacters and underscore');
}

class VietNameseDisplay extends LanguageDisplay {
  VietNameseDisplay()
      : super(
            kUsername: 'Tên đăng nhập',
            kPassword: 'Mật khẩu',
            kName: 'Tên',
            kLogin: 'Đăng nhập',
            kRegister: 'Đăng ký',
            kInvalidUsername: 'Tên đăng nhập không hợp lệ',
            kInvalidPassword: 'Mật khẩu không hợp lệ',
            kCancel: 'Hủy',
            kIncorrectLoginInfo: 'Thông tin đăng nhập không chính xác',
            kPleaseRetryLogin: 'Vui lòng thử lại',
            kInvalidName: 'Tên chỉ chứa các ký tự chữ cái',
            kEmail: 'Email',
            kInvalidEmail: 'Email không hợp lệ',
            kRegisterSuccess: 'Đăng ký thành công',
            kEmailExists: 'Email đã tồn tại',
            kUsernameExists: 'Tên đăng nhập đã tồn tại',
            kRetry: 'Vui lòng thử lại',
            kUnknown: 'Không xác định',
            kInvite: 'Mời',
            kInvalidRoomName:
                'Tên phòng chỉ chứa các ký tự chữ cái và gạch dưới',
            kRoomNameExist: 'Tên phòng đã tồn tại',
            kTeamNameExist: 'Tên nhóm đã tồn tại',
            invalidTeamName:
                'Tên nhóm chỉ chứa các ký tự chữ cái và gạch dưới');
}
