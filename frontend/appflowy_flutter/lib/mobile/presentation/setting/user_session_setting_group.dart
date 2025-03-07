import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/startup/startup.dart';
import 'package:appflowy/user/application/auth/auth_service.dart';
import 'package:appflowy/user/application/sign_in_bloc.dart';
import 'package:appflowy/user/presentation/screens/sign_in_screen/widgets/sign_in_or_logout_button.dart';
import 'package:appflowy/user/presentation/screens/sign_in_screen/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSessionSettingGroup extends StatelessWidget {
  const UserSessionSettingGroup({
    super.key,
    required this.showThirdPartyLogin,
  });

  final bool showThirdPartyLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showThirdPartyLogin) ...[
          BlocProvider(
            create: (context) => getIt<SignInBloc>(),
            child: BlocConsumer<SignInBloc, SignInState>(
              listener: (context, state) {
                state.successOrFail.fold(
                  () => null,
                  (result) => result.fold(
                    (l) {},
                    (r) async => await runAppFlowy(),
                  ),
                );
              },
              builder: (context, state) {
                return const ThirdPartySignInButtons();
              },
            ),
          ),
          const VSpace(8),
        ],
        MobileSignInOrLogoutButton(
          labelText: LocaleKeys.settings_menu_logout.tr(),
          onPressed: () async {
            await getIt<AuthService>().signOut();
            runAppFlowy();
          },
        ),
      ],
    );
  }
}
