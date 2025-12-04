import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc() : super(SurveyInitial()) {
    on<SurveyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
