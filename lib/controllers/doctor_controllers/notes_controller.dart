import 'package:get/get.dart';
import 'package:patient_app/models/note_model.dart';
import 'package:patient_app/utils/api_urls.dart';
import '../../services/api_service.dart';
import 'dart:developer';

class NoteController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;
  RxBool isLoadingNotes = false.obs;
  RxString errorMessage = ''.obs;
  RxList<NoteModel> notesList = <NoteModel>[].obs;

  Future<NoteModel?> createNote({
    required String patientId,
    required String diagnosis,
    required String note,
    required String icdCode,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Map<String, dynamic> requestBody = {
        'patientId': patientId,
        'diagnosis': diagnosis,
        'note': note,
        'icdCode': icdCode,
      };

      log('Creating note with body: $requestBody');

      final response = await _apiService.post(
        ApiUrls.createNoteApi,
        data: requestBody,
      );

      log('Create note response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final noteData = response.data['data'];

        if (noteData['doctorId'] is String) {
          noteData['doctorId'] = {
            '_id': noteData['doctorId'],
            'fullName': '',
            'profileImage': '',
          };
        }

        final newNote = NoteModel.fromJson(noteData);
        notesList.insert(0, newNote);
        return newNote;
      } else {
        errorMessage.value = response.data?['message'] ?? 'Failed to create note';
        log('Create note failed: ${errorMessage.value}');
        return null;
      }
    } catch (e, stackTrace) {
      log('Error creating note: $e');
      log('StackTrace: $stackTrace');

      if (e.toString().contains('500')) {
        errorMessage.value = 'Server error. Please check if all fields are valid and try again.';
      } else if (e.toString().contains('401')) {
        errorMessage.value = 'Authentication failed. Please login again.';
      } else {
        errorMessage.value = 'An error occurred: ${e.toString()}';
      }

      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<NoteModel?> updateNote({
    required String noteId,
    required String diagnosis,
    required String note,
    required String icdCode,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Map<String, dynamic> requestBody = {
        'diagnosis': diagnosis,
        'note': note,
        'icdCode': icdCode,
      };

      log('Updating note with body: $requestBody');

      final response = await _apiService.put(
        '${ApiUrls.updateNoteApi}/$noteId',
        data: requestBody,
      );

      log('Update note response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final noteData = response.data['data'];

        if (noteData['doctorId'] is String) {
          noteData['doctorId'] = {
            '_id': noteData['doctorId'],
            'fullName': '',
            'profileImage': '',
          };
        }

        final updatedNote = NoteModel.fromJson(noteData);

        final index = notesList.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          notesList[index] = updatedNote;
        }

        return updatedNote;
      } else {
        errorMessage.value = response.data?['message'] ?? 'Failed to update note';
        log('Update note failed: ${errorMessage.value}');
        return null;
      }
    } catch (e, stackTrace) {
      log('Error updating note: $e');
      log('StackTrace: $stackTrace');

      if (e.toString().contains('500')) {
        errorMessage.value = 'Server error. Please check if all fields are valid and try again.';
      } else if (e.toString().contains('401')) {
        errorMessage.value = 'Authentication failed. Please login again.';
      } else {
        errorMessage.value = 'An error occurred: ${e.toString()}';
      }

      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteNote({
    required String noteId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.delete(
        '${ApiUrls.deleteNoteApi}/$noteId',
      );

      if (response.data != null && response.data['success'] == true) {
        notesList.removeWhere((note) => note.id == noteId);
        return true;
      } else {
        errorMessage.value = response.data?['message'] ?? 'Failed to delete note';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNotes({
    required String patientId,
  }) async {
    try {
      isLoadingNotes.value = true;
      errorMessage.value = '';

      final response = await _apiService.get(
        '${ApiUrls.getNotesApi}$patientId',
      );

      if (response.data != null && response.data['success'] == true) {
        final List<dynamic> notesData = response.data['data'];

        notesList.value = notesData.map((json) {
          if (json['doctorId'] is String) {
            json['doctorId'] = {
              '_id': json['doctorId'],
              'fullName': '',
              'profileImage': '',
            };
          }
          return NoteModel.fromJson(json);
        }).toList();
      } else {
        errorMessage.value = response.data?['message'] ?? 'Failed to load notes';
        notesList.clear();
      }
    } catch (e, stackTrace) {
      log('Error getting notes: $e');
      log('StackTrace: $stackTrace');
      errorMessage.value = 'An error occurred: ${e.toString()}';
      notesList.clear();
    } finally {
      isLoadingNotes.value = false;
    }
  }

  void resetForm() {
    errorMessage.value = '';
  }
}