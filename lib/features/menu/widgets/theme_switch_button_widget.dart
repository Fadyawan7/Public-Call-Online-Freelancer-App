import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ThemeSwitchButtonWidget extends StatefulWidget {
  final bool fromWebBar;
  const ThemeSwitchButtonWidget({super.key, this.fromWebBar = true});

  @override
  State<ThemeSwitchButtonWidget> createState() => _ThemeSwitchButtonWidgetState();
}

class _ThemeSwitchButtonWidgetState extends State<ThemeSwitchButtonWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (profileProvider.userInfoModel != null) {
        authProvider.updateAvailabilityStatus(!profileProvider.userInfoModel!.temporaryDisabled!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProfileProvider>(
      builder: (context, authProvider, profileProvider, _) {
        final bool isAvailable = authProvider.isAvailable;

        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Theme Switch Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                                  Switch.adaptive(
                    value: isAvailable,
                    onChanged: (bool value) {
                      // When switch is enabled (true) = Available, so temporaryDisabled should be false
                      // When switch is disabled (false) = Busy, so temporaryDisabled should be true
                      authProvider.disableAccount(temporaryDisabled: !value);
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.red,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
