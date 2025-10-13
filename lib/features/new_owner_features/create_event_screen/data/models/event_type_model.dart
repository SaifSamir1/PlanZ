// lib/features/events/data/models/event_type_model.dart




// ✅ الخلاصة:
// تم إنشاء 5 Models كاملة:

// ✅ ServiceModel - للـ Services الثابتة

// ✅ EventTypeModel - للـ Event Types الـ 6

// ✅ VendorPackageModel - للـ Packages اللي الـ Vendor بينزلها

// ✅ UserEventModel - للـ Events اللي الـ Event Owner بينشئها

// ✅ VendorOrderModel - للـ Orders اللي بتوصل للـ Vendor


import 'package:equatable/equatable.dart';

class EventTypeModel extends Equatable {
  final String eventTypeId;
  final String eventTypeName;
  final String eventTypeNameAr;
  final String icon;
  final String description;
  final String descriptionAr;
  final int popularityRank;
  final bool isActive;
  final List<EventServiceConfig> services;
  final EstimatedBudget estimatedBudget;
  final List<CommonQuestion> commonQuestions;
  final List<String> tips;
  final List<String> tipsAr;

  const EventTypeModel({
    required this.eventTypeId,
    required this.eventTypeName,
    required this.eventTypeNameAr,
    required this.icon,
    required this.description,
    required this.descriptionAr,
    required this.popularityRank,
    required this.isActive,
    required this.services,
    required this.estimatedBudget,
    required this.commonQuestions,
    required this.tips,
    required this.tipsAr,
  });

  // From JSON
  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
      eventTypeId: json['eventTypeId'] as String,
      eventTypeName: json['eventTypeName'] as String,
      eventTypeNameAr: json['eventTypeNameAr'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
      popularityRank: json['popularityRank'] as int,
      isActive: json['isActive'] as bool,
      services: (json['services'] as List)
          .map((service) => EventServiceConfig.fromJson(service as Map<String, dynamic>))
          .toList(),
      estimatedBudget: EstimatedBudget.fromJson(json['estimatedBudget'] as Map<String, dynamic>),
      commonQuestions: (json['commonQuestions'] as List)
          .map((q) => CommonQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      tips: List<String>.from(json['tips'] as List),
      tipsAr: List<String>.from(json['tipsAr'] as List),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'eventTypeId': eventTypeId,
      'eventTypeName': eventTypeName,
      'eventTypeNameAr': eventTypeNameAr,
      'icon': icon,
      'description': description,
      'descriptionAr': descriptionAr,
      'popularityRank': popularityRank,
      'isActive': isActive,
      'services': services.map((s) => s.toJson()).toList(),
      'estimatedBudget': estimatedBudget.toJson(),
      'commonQuestions': commonQuestions.map((q) => q.toJson()).toList(),
      'tips': tips,
      'tipsAr': tipsAr,
    };
  }

  // Get required services only
  List<EventServiceConfig> get requiredServices {
    return services.where((service) => service.required).toList();
  }

  // Get optional services only
  List<EventServiceConfig> get optionalServices {
    return services.where((service) => !service.required).toList();
  }

  @override
  List<Object?> get props => [
        eventTypeId,
        eventTypeName,
        eventTypeNameAr,
        icon,
        description,
        descriptionAr,
        popularityRank,
        isActive,
        services,
        estimatedBudget,
        commonQuestions,
        tips,
        tipsAr,
      ];
}

// Event Service Configuration Model
class EventServiceConfig extends Equatable {
  final String serviceId;
  final String serviceName;
  final String serviceNameAr;
  final bool required;
  final int priority;
  final double suggestedBudgetPercentage;
  final double minBudgetPercentage;
  final double maxBudgetPercentage;
  final String description;
  final String descriptionAr;

  const EventServiceConfig({
    required this.serviceId,
    required this.serviceName,
    required this.serviceNameAr,
    required this.required,
    required this.priority,
    required this.suggestedBudgetPercentage,
    required this.minBudgetPercentage,
    required this.maxBudgetPercentage,
    required this.description,
    required this.descriptionAr,
  });

  factory EventServiceConfig.fromJson(Map<String, dynamic> json) {
    return EventServiceConfig(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      serviceNameAr: json['serviceNameAr'] as String,
      required: json['required'] as bool,
      priority: json['priority'] as int,
      suggestedBudgetPercentage: (json['suggestedBudgetPercentage'] as num).toDouble(),
      minBudgetPercentage: (json['minBudgetPercentage'] as num).toDouble(),
      maxBudgetPercentage: (json['maxBudgetPercentage'] as num).toDouble(),
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceNameAr': serviceNameAr,
      'required': required,
      'priority': priority,
      'suggestedBudgetPercentage': suggestedBudgetPercentage,
      'minBudgetPercentage': minBudgetPercentage,
      'maxBudgetPercentage': maxBudgetPercentage,
      'description': description,
      'descriptionAr': descriptionAr,
    };
  }

  @override
  List<Object?> get props => [
        serviceId,
        serviceName,
        serviceNameAr,
        required,
        priority,
        suggestedBudgetPercentage,
        minBudgetPercentage,
        maxBudgetPercentage,
        description,
        descriptionAr,
      ];
}

// Estimated Budget Model
class EstimatedBudget extends Equatable {
  final double min;
  final double max;
  final double average;
  final String currency;
  final String note;

  const EstimatedBudget({
    required this.min,
    required this.max,
    required this.average,
    required this.currency,
    required this.note,
  });

  factory EstimatedBudget.fromJson(Map<String, dynamic> json) {
    return EstimatedBudget(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      average: (json['average'] as num).toDouble(),
      currency: json['currency'] as String,
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'average': average,
      'currency': currency,
      'note': note,
    };
  }

  @override
  List<Object?> get props => [min, max, average, currency, note];
}

// Common Question Model
class CommonQuestion extends Equatable {
  final String questionId;
  final String question;
  final String questionAr;
  final String type; // number, text, select, multiselect
  final bool required;
  final int? min;
  final int? max;
  final String? placeholder;
  final List<String>? options;
  final List<String>? optionsAr;

  const CommonQuestion({
    required this.questionId,
    required this.question,
    required this.questionAr,
    required this.type,
    required this.required,
    this.min,
    this.max,
    this.placeholder,
    this.options,
    this.optionsAr,
  });

  factory CommonQuestion.fromJson(Map<String, dynamic> json) {
    return CommonQuestion(
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      questionAr: json['questionAr'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      min: json['min'] as int?,
      max: json['max'] as int?,
      placeholder: json['placeholder'] as String?,
      options: json['options'] != null ? List<String>.from(json['options'] as List) : null,
      optionsAr: json['optionsAr'] != null ? List<String>.from(json['optionsAr'] as List) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'questionAr': questionAr,
      'type': type,
      'required': required,
      if (min != null) 'min': min,
      if (max != null) 'max': max,
      if (placeholder != null) 'placeholder': placeholder,
      if (options != null) 'options': options,
      if (optionsAr != null) 'optionsAr': optionsAr,
    };
  }

  @override
  List<Object?> get props => [
        questionId,
        question,
        questionAr,
        type,
        required,
        min,
        max,
        placeholder,
        options,
        optionsAr,
      ];
}
