part of 'ai_bloc.dart';

@immutable
sealed class AiEvent extends Equatable {}
class GetAiDesEvent extends AiEvent {
  final String title;
  final int index;
  final QuestionsStatisticsModel question;
  GetAiDesEvent({required this.question,required this.title,required this.index});

  @override
  List<Object?> get props => [title,question];
}