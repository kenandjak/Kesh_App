import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../application/usecases/get_user_details.dart';

class ProfileController extends ChangeNotifier {
  final GetUserDetails _getUserDetails;

  ProfileController(this._getUserDetails);

  bool isLoading = false;
  String? errorMessage;

  UserDetailsOutput? userDetails;

  String get fullName => userDetails?.fullName ?? '';
  String get shortName => userDetails?.shortName ?? '';
  String get email => userDetails?.email ?? '';
  String get cpf => userDetails?.cpf ?? '';
  String get phone => userDetails?.phone ?? '';
  String get walletId => userDetails?.walletId ?? '';
  String? get profilePicture => userDetails?.profilePicture;
  String get memberSince {
    final date = userDetails?.createdAt;

    if (date == null) return 'Não informado';

    return DateFormat('MMMM \'de\' yyyy', 'pt_BR').format(date);
  }

  double get balance => userDetails?.balance ?? 0.0;

  String get initials => userDetails?.initials ?? '';

  String get currentDateFormatted {
    final now = DateTime.now();
    final formatter = DateFormat("EEEE, d 'DE' MMMM", 'pt_BR');

    return formatter.format(now).toUpperCase();
  }

  Future<void> loadProfile(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      userDetails = await _getUserDetails.execute(userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
