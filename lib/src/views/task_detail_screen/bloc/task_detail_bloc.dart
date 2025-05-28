import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/launch_url.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/comment_task_widget.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  TaskDetailBloc(super.initialState) {
    on<FetchDetailEvent>(_onFetchTaskDetail);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<FetchCommentEvent>(_onFetchComments);
    on<FetchReportEvent>(_onFetchReports);
    on<UpdateCommentEvent>(_onUpdateComment);
    on<UpdateStartAtTaskEvent>(_onUpdateStartAtTask);
    on<UpdateDueAtTaskEvent>(_onUpdateDueAtTask);
    on<AddCommentEvent>(_onAddComment);
    on<AttachmentsEvent>(_onAttachment);
    on<AttachmentsURLEvent>(_onAttachmentUrl);
    on<DownloadFileEvent>(_onDownload);
    on<OpenUrlEvent>(_openUrl);
    on<OpenFileEvent>(_openFile);
    on<AssignTaskEvent>(_onAssign);
    on<RemoveAssignEvent>(_onRemoveAssign);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<UpdatePriorityEvent>(_onUpdatePriority);
    // on<SearchContactEvent>(_onSearchContact);
  }

  final _repository = Repository();
  int currentPage = 0;

  final logger = Logger();

  _onFetchTaskDetail(
    FetchDetailEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    await _repository.getTaskDetail(PrefUtils().getUser()!.id!, event.id).then(
      (value) async {
        ResponseData<TaskData> taskData =
            ResponseData.fromJson(value.data, TaskData.fromJson);
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
              taskData: taskData.data,
            ),
          ),
        );
      },
    ).onError((error, stackTrace) {});
    add(FetchReportEvent(taskId: event.id));
  }

  _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    final currentTask = state.taskDetailModel.taskData;
    var requestData = TaskData(
      creatorId: PrefUtils().getUser()!.id,
      title: event.title,
      description: event.description,
      priority: event.priority,
      status: event.status,
      dueAt: currentTask.dueAt,
      startDate: currentTask.startDate,
    );
    await _repository
        .updateTask(event.id, requestData: requestData.toJson())
        .then((value) async {
      if (value.statusCode == 200) {
        ResponseData<TaskData> responseData =
            ResponseData.fromJson(value.data, TaskData.fromJson);
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
                taskData: state.taskDetailModel.taskData.copyWith(
              title: responseData.data!.title,
              description: responseData.data!.description,
              priority: responseData.data!.priority,
              status: responseData.data!.status,
              startDate: responseData.data!.startDate,
              dueAt: responseData.data!.dueAt,
            )),
          ),
        );
      }
    });
  }

  _onUpdateComment(
    UpdateCommentEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    var requestData = CommentData(text: event.text);
    await _repository
        .updateComment(PrefUtils().getUser()!.id!, event.commentId,
            requestData: requestData.toJson())
        .then((value) async {
      if (value.statusCode == 200) {
        ResponseData<CommentData> responseData =
            ResponseData.fromJson(value.data, CommentData.fromJson);
        final updateComment = state.taskDetailModel.commentDatas.map((comment) {
          if (comment.id == responseData.data?.id) {
            return comment.copyWith(
              id: comment.id,
              text: responseData.data?.text,
              updatedAt: responseData.data?.updatedAt,
            );
          }
          return comment;
        }).toList();
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
              commentDatas: updateComment,
            ),
          ),
        );
      }
    });
  }

  _onFetchComments(
    FetchCommentEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    if (state.hasMoreComment) {
      return;
    } else {
      Map<String, dynamic> queryParam = <String, dynamic>{
        'page': currentPage,
        'size': 10,
      };
      final Map<int, GlobalKey<CommentTaskWidgetState>> mapkey = {};
      await _repository.getComments(event.taskId, queryParam: queryParam).then(
        (value) async {
          ResponseList<CommentData> listComments =
              ResponseList.fromJson(value.data, CommentData.fromJson);

          for (var comment in listComments.data!) {
            mapkey[comment.id!] = GlobalKey();
          }

          emit(
            state.copyWith(
              taskDetailModel: state.taskDetailModel.copyWith(
                commentDatas: [
                  ...state.taskDetailModel.commentDatas,
                  ...?listComments.data,
                ],
                commentKeys: {
                  ...(state.taskDetailModel.commentKeys),
                  ...mapkey,
                },
              ),
              hasMoreComment: listComments.pagination!.currentPage! ==
                  listComments.pagination!.totalPages! - 1,
            ),
          );
        },
      ).onError((error, staceTrack) {});
      currentPage++;
    }
  }

  _onFetchReports(
    FetchReportEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    await _repository.getReports(event.taskId).then((value) async {
      List<ReportData>? reportFile = [...state.taskDetailModel.reportOfFile];
      List<ReportData>? reportPhoto = [...state.taskDetailModel.reportOfPhoto];
      List<ReportData>? reportLink = [...state.taskDetailModel.reportOfLink];
      ResponseList<ReportData> listReports =
          ResponseList.fromJson(value.data, ReportData.fromJson);
      List<ReportData>? reportData = listReports.data;
      if (reportData!.isNotEmpty) {
        for (ReportData report in reportData) {
          if (report.type == 'PHOTO') {
            reportPhoto.add(report);
          } else if (report.type == 'URL') {
            reportLink.add(report);
          } else {
            reportFile.add(report);
          }
        }
      }
      emit(
        state.copyWith(
          taskDetailModel: state.taskDetailModel.copyWith(
            reportOfFile: reportFile,
            reportOfPhoto: reportPhoto,
            reportOfLink: reportLink,
          ),
        ),
      );
    }).onError((error, stackTrace) {});
    add(FetchCommentEvent(taskId: event.taskId));
  }

  _onUpdateStartAtTask(
    UpdateStartAtTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    String startAt = event.dateTime.format(pattern: D_M_Y_HH_mm);
    final currentTask = state.taskDetailModel.taskData;
    final updatedTask = currentTask.copyWith(startDate: startAt);
    emit(
      state.copyWith(
        taskDetailModel: state.taskDetailModel.copyWith(
          taskData: updatedTask,
        ),
      ),
    );
  }

  _onUpdateDueAtTask(
    UpdateDueAtTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    String dueAt = event.dateTime.format(pattern: D_M_Y_HH_mm);

    final currentTask = state.taskDetailModel.taskData;
    final updatedTask = currentTask.copyWith(dueAt: dueAt);

    emit(
      state.copyWith(
        taskDetailModel: state.taskDetailModel.copyWith(
          taskData: updatedTask,
        ),
      ),
    );
  }

  _onAddComment(
    AddCommentEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    var requestData = CommentData(
      text: event.content,
      mentionId: event.mentionId,
    );
    UserData userData = PrefUtils().getUser()!;
    await _repository
        .addComment(
            state.taskDetailModel.taskData.id!, PrefUtils().getUser()!.id!,
            requestData: requestData.toJson())
        .then((value) async {
      ResponseData<CommentData> responseData =
          ResponseData.fromJson(value.data, CommentData.fromJson);
      emit(
        state.copyWith(
          taskDetailModel: state.taskDetailModel.copyWith(
            commentDatas: [
              responseData.data!.copyWith(
                id: responseData.data!.id,
                username: userData.firstName! + userData.lastName!,
                creatorId: userData.id,
                image: userData.imagePath,
              ),
              ...state.taskDetailModel.commentDatas
            ],
            commentKeys: {
              ...(state.taskDetailModel.commentKeys),
              responseData.data!.id!: GlobalKey(),
            },
          ),
        ),
      );
      emit(AddCommentSuccess(taskDetailModel: state.taskDetailModel));
    });
  }

  _onAttachment(
    AttachmentsEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    File file = event.file;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: basename(file.path),
      ),
      'userId': PrefUtils().getUser()!.id,
      'taskId': state.taskDetailModel.taskData.id,
    });

    await _repository.addReportsFile(formData).then((value) async {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
            arguments:
                TaskDetailArguments(taskId: state.taskDetailModel.taskData.id));
      }
    });
  }

  _onAttachmentUrl(
    AttachmentsURLEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    ReportData reportData = ReportData();
    await _repository
        .addReportUrl(
            requestData: reportData.toJson(PrefUtils().getUser()!.id!,
                state.taskDetailModel.taskData.id!, event.url))
        .then((value) async {
      if (value.statusCode == 200) {
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
            arguments:
                TaskDetailArguments(taskId: state.taskDetailModel.taskData.id));
      }
    });
  }

  _onDownload(
    DownloadFileEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    Map<String, dynamic> queryParam = {
      'reportId': event.reportId,
      'taskId': state.taskDetailModel.taskData.id,
      'userId': PrefUtils().getUser()!.id,
    };
    await _repository
        .downloadFile(PrefUtils().getUser()!.id!,
            state.taskDetailModel.taskData.id!, event.reportId, event.fileName,
            queryParam: queryParam)
        .then((value) {});
  }

  _openUrl(
    OpenUrlEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    LaunchUrl().openUrl(event.url);
  }

  _openFile(
    OpenFileEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    Api()
        .checkFileExists(
            '/storage/emulated/0/DCIM/MyFolder/${event.reportData.filename}')
        .then((value) async {
      if (value) {
        await OpenFilex.open(
            '/storage/emulated/0/DCIM/MyFolder/${event.reportData.filename}');
      } else {
        add(DownloadFileEvent(
            fileName: event.reportData.filename!,
            reportId: event.reportData.id!));
        Api()
            .checkFileExists(
                '/storage/emulated/0/DCIM/MyFolder/${event.reportData.filename}')
            .then((value) async {
          if (value) {
            OpenFilex.open(
                '/storage/emulated/0/DCIM/MyFolder/${event.reportData.filename}');
          }
        });
      }
    });
  }

  _onAssign(
    AssignTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    Map<String, dynamic> requestData = {
      'user_id': PrefUtils().getUser()!.id,
      'toUser_id': event.toUserId,
    };
    logger.i(event.toUserId);
    await _repository
        .assignTask(state.taskDetailModel.taskData.id!,
            requestData: requestData)
        .then((value) async {
      if (value.statusCode == 200) {
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
              taskData: state.taskDetailModel.taskData.copyWith(
                assignTo: event.toUserId,
                usernameAssigner: event.assigerName,
                imageAssigner: event.pathImage,
              ),
            ),
          ),
        );
        logger.i(state.taskDetailModel.taskData.assignTo);
      }
    });
  }

  _onRemoveAssign(
    RemoveAssignEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    Map<String, dynamic> requestData = {
      'user_id': PrefUtils().getUser()!.id,
      'toUser_id': state.taskDetailModel.taskData.assignTo,
    };
    await _repository
        .removeAssignTask(state.taskDetailModel.taskData.id!,
            requestData: requestData)
        .then((value) {
      if (value.statusCode == 200) {
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
              taskData: state.taskDetailModel.taskData.copyWith(assignTo: null),
            ),
          ),
        );
      }
    });
  }

  _onUpdatePriority(
    UpdatePriorityEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    final currentTask = state.taskDetailModel.taskData;
    var requestData = TaskData(
      priority: event.priority,
    );
    await _repository
        .updatePriorityTask(PrefUtils().getUser()!.id!, currentTask.id!,
            requestData: requestData.toJson())
        .then((value) async {
      if (value.statusCode == 200) {
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
              taskData: state.taskDetailModel.taskData.copyWith(
                priority: event.priority,
              ),
            ),
          ),
        );
      }
    });
  }

  _onUpdateStatus(
    UpdateStatusEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    final currentTask = state.taskDetailModel.taskData;
    var requestData = TaskData(
      status: event.status,
    );
    await _repository
        .updateStatusTask(PrefUtils().getUser()!.id!, currentTask.id!,
            requestData: requestData.toJson())
        .then((value) async {
      if (value.statusCode == 200) {
        emit(
          state.copyWith(
            taskDetailModel: state.taskDetailModel.copyWith(
              taskData: state.taskDetailModel.taskData.copyWith(
                status: event.status,
              ),
            ),
          ),
        );
      }
    });
  }
  // _onSearchContact(
  //   SearchContactEvent event,
  //   Emitter<TaskDetailState> emit,
  // ) async {
  //   Map<String, dynamic> queryParam = {
  //     'search': event.keySearch,
  //   };
  //   await _repository
  //       .searchContact(PrefUtils().getUser()!.id!, queryParam: queryParam)
  //       .then(
  //     (value) async {
  //       ResponseList<UserData> contactResult =
  //           ResponseList.fromJson(value.data, UserData.fromJson);
  //       emit(
  //         state.copyWith(
  //           contactResult: contactResult.data,
  //         ),
  //       );
  //     },
  //   );
  // }
}
