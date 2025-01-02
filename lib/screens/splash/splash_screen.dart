import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/data/providers/auth_repository_provider.dart';
import 'package:movie_app/data/providers/secure_storage_provider.dart';
import 'package:movie_app/resources/gen/assets.gen.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/splash/splash_view_model.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SplashViewModel(
    ref: ref,
    secureStorageManager: ref.watch(secureStorageProvider),
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

/// Screen code: A_01
@RoutePage()
class SplashScreen extends BaseView {
  const SplashScreen({super.key});

  @override
  BaseViewState<SplashScreen, SplashViewModel> createState() =>
      _SplashViewState();
}

class _SplashViewState extends BaseViewState<SplashScreen, SplashViewModel> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      if (_auth.currentUser != null) {
        await context.router.replace(const MainRoute());
      } else {
        await context.router.replace(const LoginRoute());
      }
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Assets.images.logoMv.image(
        width: 250,
        height: 250,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  SplashViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => SplashRoute.name;
}
