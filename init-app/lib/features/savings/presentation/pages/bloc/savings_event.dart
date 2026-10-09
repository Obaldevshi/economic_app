part of 'savings_bloc.dart';

sealed class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class AllocateSavingsGoal extends SavingsEvent {
  const AllocateSavingsGoal(this.id, this.request);
  final int id;
  final GoalAllocationRequest request;
  @override
  List<Object?> get props => [id, request];
}

class LoadWeeklyReceipt extends SavingsEvent {
  const LoadWeeklyReceipt();
}

class LoadSavingsDashboard extends SavingsEvent {
  const LoadSavingsDashboard();
}

class LoadImpulseItems extends SavingsEvent {
  const LoadImpulseItems({this.withSettings = false});

  final bool withSettings;

  @override
  List<Object?> get props => [withSettings];
}

class LoadSavingHistory extends SavingsEvent {
  const LoadSavingHistory({this.page = 1, this.append = false});
  final int page;
  final bool append;

  @override
  List<Object?> get props => [page, append];
}

class CreateSavingEvent extends SavingsEvent {
  const CreateSavingEvent(this.request);
  final SavingEventRequest request;

  @override
  List<Object?> get props => [request];
}

class UpdateSavingEvent extends SavingsEvent {
  const UpdateSavingEvent(this.id, this.request);
  final int id;
  final SavingEventRequest request;

  @override
  List<Object?> get props => [id, request];
}

class SaveImpulseItem extends SavingsEvent {
  const SaveImpulseItem(this.request, {this.id});
  final int? id;
  final ImpulseItemRequest request;

  @override
  List<Object?> get props => [id, request];
}

class DeleteImpulseItem extends SavingsEvent {
  const DeleteImpulseItem(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}

class DeleteSavingEvent extends SavingsEvent {
  const DeleteSavingEvent(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}

class CreateSavingsGoal extends SavingsEvent {
  const CreateSavingsGoal(this.request);
  final SavingsGoalRequest request;

  @override
  List<Object?> get props => [request];
}

class UpdateSavingsSettings extends SavingsEvent {
  const UpdateSavingsSettings(this.request);
  final SavingsSettingsRequest request;

  @override
  List<Object?> get props => [request];
}

class UpdateSavingsGoal extends SavingsEvent {
  const UpdateSavingsGoal(this.id, this.request);
  final int id;
  final SavingsGoalRequest request;

  @override
  List<Object?> get props => [id, request];
}
