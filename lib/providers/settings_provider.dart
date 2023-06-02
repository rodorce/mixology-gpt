import 'package:flutter/material.dart';
import 'package:mixology_cbi/models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings(
      backgroundColor: Colors.transparent,
      textColor: Colors.black,
      imageUrl:
          'https://thumbs.bfldr.com/at/oyrrxi-9ne680-14uvq?expiry=1686250068&fit=bounds&height=800&sig=MmE3OTdhYTgzOTI0YzhmZGQ1NTE3NjQ5MDJmNjdiMzYwZjE2Nzk4Yw%3D%3D&width=1100');

  Settings get settings => _settings;

  void updateSettings(Settings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}
