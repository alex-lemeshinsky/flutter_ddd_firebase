// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase/domain/notes/i_note_repository.dart';
import 'package:flutter_ddd_firebase/domain/notes/note.dart';
import 'package:flutter_ddd_firebase/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  StreamSubscription<Either<NoteFailure, KtList<Note>>>?
      _noteStreamSubscription;

  NoteWatcherBloc(this._noteRepository) : super(const _Initial()) {
    on<_WatchAllStarted>(onWatchAllStarted);
    on<_WatchUncompletedStarted>(onWatchUncompletedStarted);
    on<_NotesReceived>(onNotesReceived);
  }

  void onWatchAllStarted(_WatchAllStarted event, Emitter emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchAll().listen(
          (event) => add(NoteWatcherEvent.notesReceived(event)),
        );
  }

  void onWatchUncompletedStarted(
    _WatchUncompletedStarted event,
    Emitter emit,
  ) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchUncompleted().listen(
          (event) => add(NoteWatcherEvent.notesReceived(event)),
        );
  }

  void onNotesReceived(_NotesReceived event, Emitter emit) {
    emit(
      event.failureOrNotes.fold(
        (l) => NoteWatcherState.loadFailure(l),
        (r) => NoteWatcherState.loadSuccess(r),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
