import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase/application/auth/bloc/auth_bloc.dart';
import 'package:flutter_ddd_firebase/application/notes/note_actor/note_actor_bloc.dart';
import 'package:flutter_ddd_firebase/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter_ddd_firebase/injection.dart';
import 'package:flutter_ddd_firebase/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:flutter_ddd_firebase/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:flutter_ddd_firebase/presentation/routes/router.dart';

@RoutePage()
class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.wathcAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                unauthenticated: (_) => context.replaceRoute(
                  const SignInRoute(),
                ),
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, noteActorState) {
              noteActorState.maybeMap(
                orElse: () {},
                deleteFailure: (state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: Text(
                        state.failure.map(
                          unexpecter: (_) => "Unexpected error",
                          insufficientPermission: (_) =>
                              "Insufficient permissions",
                          unableToUpdate: (_) => "Unable to update",
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Notes"),
            leading: IconButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context)
                    .add(const AuthEvent.signedOut());
              },
              icon: const Icon(Icons.exit_to_app),
            ),
            actions: const [UncompletedSwitch()],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: navigate to NoteFormPage
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
