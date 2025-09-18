import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit() : super(const CreateEventInitial());

  String? _selectedEventTypeId;
  double? _budget;

  String? get selectedEventTypeId => _selectedEventTypeId;
  double? get budget => _budget;

  bool isEventTypeSelected(String eventTypeId) {
    return _selectedEventTypeId == eventTypeId;
  }

  void selectEventType(String eventTypeId) {
    _selectedEventTypeId = eventTypeId;
    emit(CreateEventSelectionChanged(
      selectedEventTypeId: _selectedEventTypeId,
      budget: _budget,
    ));
  }

  void updateBudget(double budget) {
    _budget = budget;
    emit(CreateEventSelectionChanged(
      selectedEventTypeId: _selectedEventTypeId,
      budget: _budget,
    ));
  }

  void validateAndContinue() {
    if (_selectedEventTypeId == null) {
      emit(const CreateEventValidationError(
        message: 'Please select an event type',
      ));
      return;
    }

    emit(CreateEventSuccess(
      selectedEventTypeId: _selectedEventTypeId!,
      budget: _budget ?? 0.0,
    ));
  }

  void reset() {
    _selectedEventTypeId = null;
    _budget = null;
    emit(const CreateEventInitial());
  }
}
