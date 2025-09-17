
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:provider/provider.dart';

class UserTypeHelper {

  static bool isFreelancer() {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
    profileProvider.getUserInfo(true);

    String? userType = profileProvider.userInfoModel!.userType;
    if (userType == 'freelancer') {
      return true;
    }else {
      return false;
    }
  }

}