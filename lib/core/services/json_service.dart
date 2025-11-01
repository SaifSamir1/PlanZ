// lib/core/services/json_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class JsonService {
  // ============================================
  // Load Event Types from JSON
  // ============================================
  static Future<Map<String, dynamic>> loadEventTypes() async {
    final String response = await rootBundle.loadString(
      'assets/json/event_types_collection.json',
    );
    return json.decode(response);
  }

  // ============================================
  // Load Services from JSON
  // ============================================
  static Future<Map<String, dynamic>> loadServices() async {
    final String response = await rootBundle.loadString(
      'assets/json/service_collection.json',
    );
    return json.decode(response);
  }
  static Future<Map<String, dynamic>> getEventTypes() async {
    final String response = await rootBundle
        .loadString('assets/json/event_types_collection.json');
    final data = json.decode(response);
    return data as Map<String, dynamic>;
  }

  static Future<List<Map<String, dynamic>>> getAllEventTypes() async {
    final data = await getEventTypes();
    final eventTypes = data['eventTypes'] as List;
    return eventTypes.map((e) => e as Map<String, dynamic>).toList();
  }

  // ✅ NEW: Load all services from JSON
  static Future<List<Map<String, dynamic>>> getAllServices() async {
    try {
      final String response = await rootBundle
          .loadString('assets/json/service_collection.json');
      final data = json.decode(response);
      
      if (data['services'] != null) {
        final services = data['services'] as List;
        return services.map((e) => e as Map<String, dynamic>).toList();
      }
      
      return [];
    } catch (e) {
      print('Error loading services: $e');
      return [];
    }
  }

  // ✅ NEW: Get service by ID
  static Future<Map<String, dynamic>?> getServiceById(String serviceId) async {
    try {
      final services = await getAllServices();
      return services.firstWhere(
        (service) => service['serviceId'] == serviceId,
        orElse: () => {},
      );
    } catch (e) {
      print('Error getting service by ID: $e');
      return null;
    }
  }

  // ✅ NEW: Get keywords for a service
  static Future<List<String>> getServiceKeywords(String serviceId) async {
    try {
      final service = await getServiceById(serviceId);
      if (service != null && service['keywords'] != null) {
        final keywords = service['keywords'] as List;
        return keywords.map((k) => k.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Error getting service keywords: $e');
      return [];
    }
  }
 
  // ============================================
  // Get Event Type by ID
  // ============================================
  static Future<Map<String, dynamic>?> getEventTypeById(
    String eventTypeId,
  ) async {
    final eventTypes = await getAllEventTypes();
    
    try {
      return eventTypes.firstWhere(
        (e) => e['eventTypeId'] == eventTypeId,
      );
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // Get Services for Event Type
  // ============================================
  static Future<List<Map<String, dynamic>>> getServicesForEventType(
    String eventTypeId,
  ) async {
    final eventType = await getEventTypeById(eventTypeId);
    
    if (eventType == null || eventType['services'] == null) {
      return [];
    }
    
    return List<Map<String, dynamic>>.from(eventType['services']);
  }

  // ============================================
  // Get Required Services for Event Type
  // ============================================
  static Future<List<Map<String, dynamic>>> getRequiredServices(
    String eventTypeId,
  ) async {
    final services = await getServicesForEventType(eventTypeId);
    return services.where((s) => s['required'] == true).toList();
  }

  // ============================================
  // Get Optional Services for Event Type
  // ============================================
  static Future<List<Map<String, dynamic>>> getOptionalServices(
    String eventTypeId,
  ) async {
    final services = await getServicesForEventType(eventTypeId);
    return services.where((s) => s['required'] != true).toList();
  }

  // ============================================
  // Get Estimated Budget for Event Type
  // ============================================
  static Future<Map<String, dynamic>?> getEstimatedBudget(
    String eventTypeId,
  ) async {
    final eventType = await getEventTypeById(eventTypeId);
    return eventType?['estimatedBudget'];
  }
  
}
