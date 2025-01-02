import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:movie_app/components/base_view/base_view_mixin.dart';
import 'package:movie_app/components/base_view/base_view_model.dart';
import 'package:movie_app/components/dialog/dialog_provider.dart';
import 'package:movie_app/components/loading/loading_view_model.dart';
import 'package:movie_app/data/models/api/responses/base_response_error/base_response_error.dart';
import 'package:movie_app/utilities/constants/app_constants.dart';
import 'package:movie_app/utilities/constants/text_constants.dart';

abstract class BaseView extends ConsumerStatefulWidget {
  const BaseView({
    super.key,
  });
}

abstract class BaseViewState<View extends BaseView,
        ViewModel extends BaseViewModel> extends ConsumerState<View>
    with BaseViewMixin {
  ViewModel get viewModel;

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  final logger = Logger();

  @mustCallSuper
  void onInitState() {
    logger.d('Init State: $runtimeType');
  }

  @mustCallSuper
  void onDispose() {
    logger.d('Dispose: $runtimeType');
  }

  @override
  void initState() {
    super.initState();
    onInitState();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView(context);

  void nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  Future<void> handleError(
    Object error, {
    void Function()? onButtonTapped,
  }) async {
    String? errorMessage;

    if (error is DioException) {
      final response = error.response;

      if (response != null) {
        try {
          if (response.data is Map<String, dynamic>) {
            errorMessage = response.data['message'];
          } else {
            final errorJson = jsonDecode(response.data);
            errorMessage = BaseResponseError.fromJson(errorJson).message;
          }
        } catch (_) {
          errorMessage = error.response?.statusMessage;
        }
      }
    }

    if (error is FirebaseAuthException) {
      try {
        final errorCode = error.code;
        switch (errorCode) {
          case AppConstants.userNotFound:
            errorMessage = TextConstants.userNotFound;
            break;
          case AppConstants.wrongPassword:
            errorMessage = TextConstants.wrongPassword;
            break;
          case AppConstants.emailAlreadyInUse:
            errorMessage = TextConstants.emailAlreadyInUse;
            break;
          default:
            errorMessage = TextConstants.loginFailed;
        }
      } catch (_) {
        errorMessage = TextConstants.unknowFirebaseError;
      }
    }

    if (errorMessage != null) {
      await ref.read(alertDialogProvider).showAlertDialog(
            context: context,
            title: errorMessage,
            onClosed: onButtonTapped,
          );
    }
  }

  Future<void> onLoading(Future<dynamic> Function() future) async {
    try {
      await loading.whileLoading(context, future);
    } catch (e) {
      handleError(e);
    }
  }
}
