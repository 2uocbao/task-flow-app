import 'package:dio/dio.dart';
import 'package:taskflow/src/data/api/api.dart';

class Repository {
  final _api = Api();

  Future<Response> getUserDetail() async {
<<<<<<< HEAD
    return await _api.get('/users');
=======
    return await _api.get('/users/email');
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  Future<void> updateToken({Map requestData = const {}}) async {
    await _api.put('/users/fcm_token', requestData: requestData);
  }

<<<<<<< HEAD
  Future<void> removeToken() async {
    await _api.delete('/users/remove_fcm_token');
  }

  Future<Response> searchUser(
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/users/searchs', requestParam: queryParam);
=======
  Future<Response> searchUser(String userId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.search('/users/$userId', requestParam: queryParam);
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  Future<Response> getUser(String userId) async {
    return await _api.search('/users/$userId/mentions');
  }

<<<<<<< HEAD
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
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  Future<Response> updateTask(String taskId,
      {Map requestData = const {}}) async {
    return await _api.put('/tasks/$taskId', requestData: requestData);
  }

<<<<<<< HEAD
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
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

//COMMENT
  Future<Response> getComments(String taskId,
      {Map<String, dynamic> queryParam = const {}}) async {
    return await _api.get('/tasks/$taskId/comments', queryParam: queryParam);
  }

<<<<<<< HEAD
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
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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

<<<<<<< HEAD
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
=======
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

  Future<Response> haveUnRead(String userId) async {
    return await _api.get('/users/$userId/notifications/unread');
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

//CONTACT
  Future<Response> addContact({Map requestData = const {}}) async {
    return await _api.post('/contacts', requestData: requestData);
  }

<<<<<<< HEAD
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
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        requestParam: queryParam);
  }
}
