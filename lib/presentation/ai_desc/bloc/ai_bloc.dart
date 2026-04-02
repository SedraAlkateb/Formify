import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/data/services/gemini_prompt_builder_service.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/usecase/get_ai_usecase.dart';
import 'package:meta/meta.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  GetAiUsecase _getAiUsecase;
  Map<int ,String > aiAnswers={} ;
  int index=0;
  AiBloc(this._getAiUsecase) : super(AiInitial()) {
    on<GetAiDesEvent>(_onGetAiDesc);
  }
  Future<void> _onGetAiDesc(
      GetAiDesEvent event,
      Emitter<AiState> emit,
      ) async {
    emit(GetAiDescLoading(index: event.index));
    final prompt = GeminiPromptBuilderService.buildQuestionAnalysisPrompt(
      surveyTitle: event.title,
      questionWithAnswers: event.question,
    );
    if (prompt == null) return;

    final result = await _getAiUsecase.execute(prompt);
    print(result);

    result.fold(
          (failure) {
        emit(GetAiDescError(failure: failure,index: event.index));
      },
          (analysis) {
            index=event.index;
            aiAnswers[event.index]=result.fold((l) => "يوجد خطأ بالبيانات", (r) => r,);
        emit(GetAiDescSuccess(aiAnswers: aiAnswers, index: event.index));
      },
    );
  }
}
