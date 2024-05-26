import 'package:expanse_tracker/app/app.router.dart';
import 'package:expanse_tracker/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends BaseViewModel {
  final _apiService = ApiService();
  final _navigationService = NavigationService();
  String? signupErrorMessage;

  Future<void> signup(String username, String email, String password) async {
    setBusy(true);

    if (await _apiService.signup(username, email, password)) {
      _navigationService.clearStackAndShow(Routes.loginView);
    }
    setBusy(false);
  }
}
