import 'package:dio/dio.dart';
import 'package:taskflow/src/data/api/api.dart';

class Repository {
  final _api = Api();

  Future<Response> getUserDetail() async {
    return await _api.get('/users/email');
  }

  Future<void> updateToken({Map requestData = const {}}) async {
    await _api.put('/users/fcm_token', requestData: requestData);
  }

  Future<Response> searchUser(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/users/$userId', requestParam: queryParam);
  }

  Future<Response> getUser(String userId) async {
    return await _api.search('/users/$userId/mentions');
  }

//TASK
  Future<Response> createTask({Map requestData = const {}}) async {
    return await _api.post('/tasks', requestData: requestData);
  }

  Future<Response> getTasks(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/users/$userId/tasks', queryParam: queryParam);
  }

  Future<Response> getTaskDetail(String userId, String taskId) async {
    return await _api.get('/users/$userId/tasks/$taskId');
  }

  Future<Response> updateTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId', requestData: requestData);
  }

  Future<Response> updateStatusTask(String userId, String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/users/$userId/tasks/$taskId/status',
        requestData: requestData);
  }

  Future<Response> updatePriorityTask(String userId, String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/users/$userId/tasks/$taskId/priority',
        requestData: requestData);
  }

  Future<Response> deleteTask(String taskId, String userId) async {
    return await _api.delete('/users/$userId/tasks/$taskId');
  }

  Future<Response> assignTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId/assignees', requestData: requestData);
  }

  Future<Response> removeAssignTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.post('/tasks/$taskId/assignees',
        requestData: requestData);
  }

  Future<Response> searchTask(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/users/$userId/tasks/searchWith',
        requestParam: queryParam);
  }

//COMMENT
  Future<Response> getComments(String taskId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/tasks/$taskId/comments', queryParam: queryParam);
  }

  Future<Response> addComment(String taskId, String userId,
      {Map requestData = const {}}) async {
    return await _api.post('/users/$userId/tasks/$taskId/comments',
        requestData: requestData);
  }

  Future<Response> updateComment(String userId, int commentId,
      {Map requestData = const {}}) async {
    return await _api.put('/users/$userId/comments/$commentId',
        requestData: requestData);
  }

  Future<Response> deleteComment(String userId, int commentId) async {
    return await _api.delete('/users/$userId/comments/$commentId');
  }

//REPORT
  Future<Response> addReportsFile(FormData formData) async {
    return await _api.addFile('/reports', formData);
  }

  Future<Response> addReportUrl({Map requestData = const {}}) async {
    return await _api.post('/reports/url', requestData: requestData);
  }

  Future<Response> getReports(String taskId) async {
    return await _api.get('/tasks/$taskId/reports');
  }

  Future<void> downloadFile(
      String userId, String taskId, String reportId, String filename,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.downloadFile(
        '/users/$userId/tasks/$taskId/reports/$reportId/download', filename,
        queryParam: queryParam);
  }

  Future<Response> deleteReport(
      String userId, String taskId, String reportId) async {
    return await _api.delete('/users/$userId/tasks/$taskId/reports/$reportId');
  }

//NOTIFICATION
  Future<Response> getNotification(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/users/$userId/notifications',
        queryParam: queryParam);
  }

  Future<Response> updateAllNotiStatus(String userId) async {
    return await _api.put('/users/$userId/notifications');
  }

  Future<Response> updateStatusNotifi(
      String userId, String notificationId) async {
    return await _api.put('/users/$userId/notifications/$notificationId');
  }

//CONTACT
  Future<Response> addContact({Map requestData = const {}}) async {
    return await _api.post('/contacts', requestData: requestData);
  }

  Future<Response> updateContact(String userId, String contactId,
      {Map requestData = const {}}) async {
    return await _api.put('/users/$userId/contacts/$contactId',
        requestData: requestData);
  }

  Future<Response> deleteContact(String userId, String contactId) async {
    return await _api.delete('/users/$userId/contacts/$contactId');
  }

  Future<Response> getContacts(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/users/$userId/contacts', queryParam: queryParam);
  }

  Future<Response> searchContact(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/users/$userId/contacts/searchWith',
        requestParam: queryParam);
  }
}
