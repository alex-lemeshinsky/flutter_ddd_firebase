import 'package:bloc/bloc.dart';
import 'package:flutter_ddd_firebase/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const _Initial()) {
    on<_AuthCheckRequested>(_onAuthcheckRequested);
    on<_SignedOut>(_onSignedOut);
  }

  void _onAuthcheckRequested(_AuthCheckRequested event, Emitter emit) async {
    final userOprion = await _authFacade.getSignedInUser();

    userOprion.fold(
      () => emit(const AuthState.unauthenticated()),
      (a) => emit(const AuthState.authenticated()),
    );
  }

  void _onSignedOut(_SignedOut event, Emitter emit) async {
    await _authFacade.signOut();
    emit(const AuthState.authenticated());
  }
}
