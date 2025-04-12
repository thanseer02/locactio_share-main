
import 'package:CyberTrace/providers/base_provider.dart';

class ToggleViewModel extends BaseProvider {
  bool _isToggleTap = false;
  bool get isToggleTap => _isToggleTap;
  set isToggleTap(bool value) {
    _isToggleTap = value;
    notifyListeners();
  }
}
