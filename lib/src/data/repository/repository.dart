import 'package:dio/dio.dart';
import 'package:taskflow/src/data/api/api.dart';

class Repository {
  final _api = Api();

  Future<Response> getUserDetail() async {
    return await _api.get('/users');
  }

  Future<void> updateToken({Map requestData = const {}}) async {
    await _api.put('/users/fcm_token', requestData: requestData);
  }

  Future<void> removeToken() async {
    await _api.delete('/users/remove_fcm_token');
  }

  Future<Response> searchUser(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/users/searchs', requestParam: queryParam);
  }

  Future<Response> getUser(String userId) async {
    return await _api.search('/users/$userId/mentions');
  }

  Future<Response> getUserByEmail(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.getUserTest('/users/tests', queryParam: queryParam);
  }

//Custom
  Future<Response> getHome({Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/home', queryParam: queryParam);
  }

  Future<Response> getTaskDetailCustom(String taskId) async {
    return await _api.get('/tasks/$taskId/task_detail');
  }

//TASK
  Future<Response> createTask(String teamId,
      {Map requestData = const {}}) async {
    return await _api.post('/teams/$teamId/tasks', requestData: requestData);
  }

  Future<Response> getTasks(String teamId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/teams/$teamId/tasks', queryParam: queryParam);
  }

  Future<Response> getTaskDetail(String taskId) async {
    return await _api.get('/tasks/$taskId/task_detail');
  }

  Future<Response> updateTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId', requestData: requestData);
  }

  Future<Response> updateStatusTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId/status', requestData: requestData);
  }

  Future<Response> updatePriorityTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId/priority', requestData: requestData);
  }

  Future<Response> deleteTask(String taskId) async {
    return await _api.delete('/tasks/$taskId');
  }

  Future<Response> searchTask(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/tasks/searchs', requestParam: queryParam);
  }

//Task Assignment
  Future<Response> createAssign(String taskId,
      {Map requestData = const {}}) async {
    return await _api.post('/tasks/$taskId/task_assignments',
        requestData: requestData);
  }

  Future<Response> getAssignment(String taskId) async {
    return await _api.get('/tasks/$taskId/task_assignments');
  }

  Future<Response> removeAssign(String taskId, String taskAssignId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId/task_assignments/$taskAssignId',
        requestData: requestData);
  }

//COMMENT
  Future<Response> getComments(String taskId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/tasks/$taskId/comments', queryParam: queryParam);
  }

  Future<Response> addComment(String taskId,
      {Map requestData = const {}}) async {
    return await _api.post('/tasks/$taskId/comments', requestData: requestData);
  }

  Future<Response> updateComment(int commentId,
      {Map requestData = const {}}) async {
    return await _api.put('/comments/$commentId', requestData: requestData);
  }

  Future<Response> deleteComment(int commentId) async {
    return await _api.delete('/comments/$commentId');
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

  Future<void> downloadFile(String taskId, String reportId, String filename,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.downloadFile(
        '/tasks/$taskId/reports/$reportId/download', filename,
        queryParam: queryParam);
  }

  Future<Response> deleteReport(String taskId, String reportId) async {
    return await _api.delete('/tasks/$taskId/reports/$reportId');
  }

//NOTIFICATION
  Future<Response> getNotification(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/notifications', queryParam: queryParam);
  }

  Future<Response> updateAllNotiStatus() async {
    return await _api.put('/notifications');
  }

  Future<Response> updateStatusNotifi(String notificationId) async {
    return await _api.put('/notifications/$notificationId');
  }

  Future<Response> haveUnRead() async {
    return await _api.get('/notifications/unread');
  }

//CONTACT
  Future<Response> addContact({Map requestData = const {}}) async {
    return await _api.post('/contacts', requestData: requestData);
  }

  Future<Response> updateContact(String contactId,
      {Map requestData = const {}}) async {
    return await _api.put('/contacts/$contactId', requestData: requestData);
  }

  Future<Response> deleteContact(String contactId) async {
    return await _api.delete('/contacts/$contactId');
  }

  Future<Response> getContacts(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/contacts', queryParam: queryParam);
  }

  Future<Response> searchContact(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/contacts/searchs', requestParam: queryParam);
  }

//TEAM
  Future<Response> createTeam({Map requestData = const {}}) async {
    return await _api.post('/teams', requestData: requestData);
  }

  Future<Response> updateTeam(String teamId,
      {Map requestData = const {}}) async {
    return await _api.put('/teams/$teamId', requestData: requestData);
  }

  Future<Response> getTeams() async {
    return await _api.get('/teams');
  }

  Future<Response> deleteTeam(String teamId) async {
    return await _api.delete('/teams/$teamId');
  }

  Future<Response> searchTeam(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/teams/searchs', requestParam: queryParam);
  }

//TEAM_MEMBER
  Future<Response> addMemberToTeam(String teamId,
      {Map requestData = const {}}) async {
    return await _api.post('/teams/$teamId/team_members',
        requestData: requestData);
  }

  Future<Response> removeMember(String teamId, String teamMemberId,
      {Map requestData = const {}}) async {
    return await _api.put('/teams/$teamId/team_members/$teamMemberId',
        requestData: requestData);
  }

  Future<Response> leaveTeam(String teamId,
      {Map requestData = const {}}) async {
    return await _api.put('/teams/$teamId/team_members',
        requestData: requestData);
  }

  Future<Response> getTeamMember(String teamId) async {
    return await _api.get('/teams/$teamId/team_members');
  }

  Future<Response> searchTeamMember(String teamId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/teams/$teamId/team_members/searchs',
        requestParam: queryParam);
  }

  Future<Response> searchForAdd(String teamId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/teams/$teamId/available-users/searchs',
        requestParam: queryParam);
  }
}
