import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/components/base_view/base_view.dart';
import 'package:movie_app/data/providers/auth_repository_provider.dart';
import 'package:movie_app/data/providers/secure_storage_provider.dart';
import 'package:movie_app/router/app_router.dart';
import 'package:movie_app/screens/setting/setting_view_model.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SettingViewModel(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
    secureStorageManager: ref.watch(secureStorageProvider),
  ),
);

@RoutePage()
class SettingScreen extends BaseView {
  const SettingScreen({super.key});

  @override
  BaseViewState<SettingScreen, SettingViewModel> createState() =>
      _SettingScreenState();
}

class _SettingScreenState
    extends BaseViewState<SettingScreen, SettingViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await viewModel.logout();
          if (!mounted) return;
          context.router.replace(const LoginRoute());
        },
        child: const Text(TextConstants.logOut),
      ),
    );
  }

  @override
  String get screenName => SettingRoute.name;

  @override
  SettingViewModel get viewModel => ref.read(_provider.notifier);
}
