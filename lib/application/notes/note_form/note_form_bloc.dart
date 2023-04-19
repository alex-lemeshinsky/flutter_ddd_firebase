import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase/domain/notes/i_note_repository.dart';
import 'package:flutter_ddd_firebase/domain/notes/note.dart';
import 'package:flutter_ddd_firebase/domain/notes/note_failure.dart';
import 'package:flutter_ddd_firebase/domain/notes/value_objects.dart';
import 'package:flutter_ddd_firebase/presentation/notes/note_form/misc/todo_item_presentaion_classes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<_Initialized>(_onInitialized);
    on<_BodyChanged>(_onBodyChanged);
    on<_ColorChanged>(_onColorChanged);
    on<_TodosChanged>(_onTodosChanged);
    on<_Saved>(_onSaved);
  }

  void _onInitialized(_Initialized event, Emitter emit) {
    emit(
      event.initialNoteOption.fold(
        () => state,
        (initialNote) => state.copyWith(note: initialNote, isEditing: true),
      ),
    );
  }

  void _onBodyChanged(_BodyChanged event, Emitter emit) {
    emit(
      state.copyWith(
        note: state.note.copyWith(body: NoteBody(event.bodyStr)),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  void _onColorChanged(_ColorChanged event, Emitter emit) {
    emit(
      state.copyWith(
        note: state.note.copyWith(color: NoteColor(event.color)),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  void _onTodosChanged(_TodosChanged event, Emitter emit) {
    emit(
      state.copyWith(
        note: state.note.copyWith(
          todos: List3(event.items.map((p0) => p0.toDomain())),
        ),
        saveFailureOrSuccessOption: none(),
      ),
    );
  }

  void _onSaved(_Saved event, Emitter emit) async {
    late Either<NoteFailure, Unit> failureOrSuccess;

    emit(state.copyWith(isSaving: true, saveFailureOrSuccessOption: none()));

    if (state.note.failureOption.isNone()) {
      failureOrSuccess = state.isEditing
          ? await _noteRepository.update(state.note)
          : await _noteRepository.create(state.note);
    }

    emit(
      state.copyWith(
        isSaving: false,
        showErrorMessages: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
