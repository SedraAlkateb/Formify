part of 'ai_bloc.dart';

@immutable
sealed class AiState extends Equatable{}

final class AiInitial extends AiState {
  @override
  List<Object?> get props =>[];
}
final class GetAiDescLoading extends AiState {
  final int index;
  GetAiDescLoading({required this.index});
  @override
  List<Object?> get props =>[index];
}

final class GetAiDescSuccess extends AiState {
 final Map<int ,String > aiAnswers ;
 final int index;
  GetAiDescSuccess ({required this.aiAnswers, required this.index});

  @override
  List<Object?> get props =>[aiAnswers];
}

final class GetAiDescError extends AiState {
  final Failure failure;
  final int index;
  @override
  List<Object?> get props =>[index,failure];
  GetAiDescError({required this.failure,required this.index});

}