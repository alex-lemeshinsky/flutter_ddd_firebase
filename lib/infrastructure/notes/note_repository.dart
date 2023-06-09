import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ddd_firebase/domain/notes/i_note_repository.dart';
import 'package:flutter_ddd_firebase/domain/notes/note_failure.dart';
import 'package:flutter_ddd_firebase/domain/notes/note.dart';
import 'package:flutter_ddd_firebase/infrastructure/core/firestore_helpers.dart';
import 'package:flutter_ddd_firebase/infrastructure/notes/note_dtos.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains("permission-denied") ?? false) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpecter());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains("permission-denied") ?? false) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpecter());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains("permission-denied") ?? false) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message?.contains("not-found") ?? false) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpecter());
      }
    }
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy("serverTimeStamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs
                .map((doc) => NoteDto.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (error, stackTrace) {
        if (error is PlatformException &&
            (error.message?.contains("permission-denied") ?? false)) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          return left(const NoteFailure.unexpecter());
        }
      },
    );
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy("serverTimeStamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) => NoteDto.fromFirestore(doc).toDomain(),
          ),
        )
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(
            notes
                .where(
                  (note) =>
                      note.todos.getOrCrash().any((todoItem) => !todoItem.done),
                )
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith(
      (error, stackTrace) {
        if (error is PlatformException &&
            (error.message?.contains("permission-denied") ?? false)) {
          return left(const NoteFailure.insufficientPermission());
        } else {
          return left(const NoteFailure.unexpecter());
        }
      },
    );
  }
}
