import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (l) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l.map(
                      cancelledByUser: (_) => "Cancelled by user",
                      serverError: (_) => "Server error",
                      emailAlreadyInUse: (_) => "Email is already in use",
                      invalidEmailAndPasswordCombination: (_) =>
                          "Invalid email or password",
                    ),
                  ),
                ),
              );
            },
            (r) => null,
          ),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessaged
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              const Text(
                "📝",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 130),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (value) => BlocProvider.of<SignInFormBloc>(context)
                    .add(SignInFormEvent.emailChanged(value)),
                validator: (_) => BlocProvider.of<SignInFormBloc>(context)
                    .state
                    .emailAddress
                    .value
                    .fold(
                      (l) => l.maybeMap(
                        invalidEmail: (_) => "Invalid Email",
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Password",
                ),
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => BlocProvider.of<SignInFormBloc>(context)
                    .add(SignInFormEvent.passwordChanged(value)),
                validator: (_) => BlocProvider.of<SignInFormBloc>(context)
                    .state
                    .password
                    .value
                    .fold(
                      (l) => l.maybeMap(
                        shortPassword: (_) => "Short Password",
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        BlocProvider.of<SignInFormBloc>(context).add(
                          const SignInFormEvent
                              .signInWithEmailAndPasswordPressed(),
                        );
                      },
                      child: const Text("SIGN IN"),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        BlocProvider.of<SignInFormBloc>(context).add(
                          const SignInFormEvent
                              .registerWithEmailAndPasswordPressed(),
                        );
                      },
                      child: const Text("REGISTER"),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<SignInFormBloc>(context).add(
                    const SignInFormEvent.signInWithGooglePressed(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                child: const Text(
                  "SIGN IN WITH GOOGLE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
