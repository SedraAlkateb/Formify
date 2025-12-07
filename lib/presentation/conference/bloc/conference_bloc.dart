import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'conference_event.dart';
part 'conference_state.dart';

class ConferenceBloc extends Bloc<ConferenceEvent, ConferenceState> {
  ConferenceBloc() : super(ConferenceInitial()) {
    on<ConferenceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
