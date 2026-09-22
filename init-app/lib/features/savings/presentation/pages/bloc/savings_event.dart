part of 'savings_bloc.dart';

sealed class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavingsDashboard extends SavingsEvent {
  const LoadSavingsDashboard();
}

class LoadImpulseItems extends SavingsEvent {
  const LoadImpulseItems();
}

class LoadSavingHistory extends SavingsEvent {
  const LoadSavingHistory({this.page = 1});
  final int page;

  @override
  List<Object?> get props => [page];
}

class CreateSavingEvent extends SavingsEvent {
  const CreateSavingEvent(this.request);
  final SavingEventRequest request;

  @override
  List<Object?> get props => [request];
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
