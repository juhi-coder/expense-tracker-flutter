import 'package:expanse_tracker/app/app.router.dart';
import 'package:expanse_tracker/services/api_service.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = NavigationService();
  final _apiService = ApiService();

  Future<void> login(String email, String password) async {
    setBusy(true);

    if (await _apiService.login(email, password)) {
      _navigationService.clearStackAndShow(Routes.expenseView);
    }
    setBusy(false);
  }
}
