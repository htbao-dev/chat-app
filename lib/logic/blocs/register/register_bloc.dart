import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepo;
  RegisterBloc({required this.authRepo}) : super(RegisterInitial()) {
    on<RegisterSubmited>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authRepo.registerWithUsernameAndPassword(
          event.username,
          event.name,
          event.email,
          event.password,
        );
        emit(RegisterSuccess());
      } on ServerException catch (e) {
        if (e.statusCode == RequestStatusCode.timeout) {
          emit(RegisterError(
            status: RegisterStatus.retry,
          ));
        } else if (e.statusCode == RequestStatusCode.badRequest) {
          if (e.message == RegisterStatus.usernameExists) {
            emit(RegisterError(status: RegisterStatus.usernameExists));
          } else if (e.message == RegisterStatus.emailExists) {
            emit(RegisterError(status: RegisterStatus.emailExists));
          } else {
            emit(RegisterError(status: RegisterStatus.registerFailed));
          }
        } else if (e.statusCode == RequestStatusCode.tooManyRequest) {
          emit(RegisterError(status: RegisterStatus.retry));
        } else {
          //TODO: handle other error
          emit(RegisterError(status: RegisterStatus.registerFailed));
        }
      } catch (e, s) {
        print('$e\n$s');
      }
    });
  }
}
