import 'package:auto_route/auto_route.dart';
import 'package:flutter_ddd_firebase/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_ddd_firebase/presentation/splash/splash_page.dart';
import 'package:flutter_ddd_firebase/presentation/notes/notes_overview/notes_overview_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: "/", page: SplashRoute.page),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: NotesOverviewRoute.page),
      ];
}
