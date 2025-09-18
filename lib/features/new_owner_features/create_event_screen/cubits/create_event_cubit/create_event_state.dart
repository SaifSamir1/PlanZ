// lib/features/events/cubits/create_event_state.dart
import 'package:equatable/equatable.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object?> get props => [];
}

class CreateEventInitial extends CreateEventState {
  const CreateEventInitial();
}

class CreateEventSelectionChanged extends CreateEventState {
  final String? selectedEventTypeId;
  final double? budget;

  const CreateEventSelectionChanged({
    this.selectedEventTypeId,
    this.budget,
  });

  @override
  List<Object?> get props => [selectedEventTypeId, budget];

  CreateEventSelectionChanged copyWith({
    String? selectedEventTypeId,
    double? budget,
  }) {
    return CreateEventSelectionChanged(
      selectedEventTypeId: selectedEventTypeId ?? this.selectedEventTypeId,
      budget: budget ?? this.budget,
    );
  }
}

class CreateEventValidationError extends CreateEventState {
  final String message;

  const CreateEventValidationError({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateEventSuccess extends CreateEventState {
  final String selectedEventTypeId;
  final double budget;

  const CreateEventSuccess({
    required this.selectedEventTypeId,
    required this.budget,
  });

  @override
  List<Object> get props => [selectedEventTypeId, budget];
}
