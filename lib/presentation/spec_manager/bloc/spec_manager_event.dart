part of 'spec_manager_bloc.dart';

@immutable
sealed class SpecManagerEvent extends Equatable{}
class GetAllSpecsEvent extends SpecManagerEvent{

  @override
  List<Object?> get props => [];
}
class CreateSpecEvent extends SpecManagerEvent {
  final String name;
  final List<SpecModel> spec;
  CreateSpecEvent(this.name,this.spec);
  @override
  List<Object?> get props =>[name,spec];
}
