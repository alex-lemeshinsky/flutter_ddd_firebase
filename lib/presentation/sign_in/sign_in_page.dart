import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:flutter_ddd_firebase/injection.dart';

import 'widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign in")),
      body: BlocProvider(
        create: (_) => getIt<SignInFormBloc>(),
        child: const SignInForm(),
      ),
    );
  }
}
