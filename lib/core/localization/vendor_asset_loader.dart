import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Custom asset loader that loads main, vendor-specific, attendee-specific, and event owner-specific translation files
/// and merges them together for use in the app
class MultiRoleAssetLoader extends AssetLoader {
  const MultiRoleAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    // Load main translation file (e.g., en.json, ar.json)
    final mainFile = '$path/${locale.languageCode}.json';
    final mainData = await _loadJsonFile(mainFile);

    // Load vendor-specific translation file (e.g., en_vendor.json, ar_vendor.json)
    final vendorFile = '$path/${locale.languageCode}_vendor.json';
    final vendorData = await _loadJsonFile(vendorFile);

    // Load attendee-specific translation file (e.g., en_attendee.json, ar_attendee.json)
    final attendeeFile = '$path/${locale.languageCode}_attendee.json';
    final attendeeData = await _loadJsonFile(attendeeFile);

    // Load attendee extended translation file (e.g., en_attendee_extended.json, ar_attendee_extended.json)
    final attendeeExtendedFile =
        '$path/${locale.languageCode}_attendee_extended.json';
    final attendeeExtendedData = await _loadJsonFile(attendeeExtendedFile);

    // Load event owner-specific translation file (e.g., en_event_owner.json, ar_event_owner.json)
    final eventOwnerFile = '$path/${locale.languageCode}_event_owner.json';
    final eventOwnerData = await _loadJsonFile(eventOwnerFile);

    // Merge all data into main data
    final mergedData = {...mainData};
    _deepMerge(mergedData, vendorData);
    _deepMerge(mergedData, attendeeData);
    _deepMerge(mergedData, attendeeExtendedData);
    _deepMerge(mergedData, eventOwnerData);

    return mergedData;
  }

  /// Load a JSON file from assets
  Future<Map<String, dynamic>> _loadJsonFile(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      return data;
    } catch (e) {
      // If file doesn't exist or can't be loaded, return empty map
      return {};
    }
  }

  /// Deep merge two maps, with source values overwriting target values
  void _deepMerge(Map<String, dynamic> target, Map<String, dynamic> source) {
    source.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          target[key] is Map<String, dynamic>) {
        _deepMerge(target[key] as Map<String, dynamic>, value);
      } else {
        target[key] = value;
      }
    });
  }
}
