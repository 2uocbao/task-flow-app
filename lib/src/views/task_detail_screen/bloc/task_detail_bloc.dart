import 'package:easy_localization/easy_localization.dart';
import 'package:open_filex/open_filex.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/response/response_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/task/assign_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/data/model/task/task_detail_custom.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/launch_url.dart';
import 'package:taskflow/src/utils/network_info.dart/network_info.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/comment_task_widget.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  TaskDetailBloc(super.initialState) {
    on<FetchDetailEvent>(_onFetchTaskDetail);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<FetchCommentEvent>(_onFetchComments);
    on<UpdateCommentEvent>(_onUpdateComment);
    on<UpdateStartAtTaskEvent>(_onUpdateStartAtTask);
    on<UpdateDueAtTaskEvent>(_onUpdateDueAtTask);
    on<OpenUrlEvent>(_openUrl);
    on<OpenFileEvent>(_openFile);
    on<AssignTaskEvent>(_onAssign);
    on<RemoveAssignEvent>(_onRemoveAssign);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<UpdatePriorityEvent>(_onUpdatePriority);
    on<DownloadFileEvent>(_onDownload);
    on<AttachmentsURLEvent>(_onAttachmentUrl);
    on<AddCommentEvent>(_onAddComment);
    on<ReloadComments>(_onReloadComments);
  }

  final _repository = Repository();

  int currentPage = 0;

  final logger = Logger();

  Future<void> _onFetchTaskDetail(
    FetchDetailEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      await _repository.getTaskDetail(event.id).then(
        (value) async {
          if (value.statusCode == 200) {
            List<dynamic> dataList = value.data['data'];
            ResponseList<TaskDetailCustom> taskDetailCustom =
                ResponseList.fromJson(value.data, TaskDetailCustom.fromJson);
            TaskDetailCustom taskDetailCustom2 =
                TaskDetailCustom.fromJson(dataList.first);

            TaskData taskData = taskDetailCustom2.taskData!;
            List<AssignData> listAssigns = taskDetailCustom2.listAssigns ?? [];
            List<ReportData> listReports = taskDetailCustom2.listReports ?? [];
            List<CommentData> listComments =
                taskDetailCustom2.listComments ?? [];
            List<Map<String, dynamic>> mentionDatas = [];

            final Map<int, GlobalKey<CommentTaskWidgetState>> commentKeys = {};
            final Map<int, LayerLink> mapLayerLinkComments = {};
            for (var comment in listComments) {
              commentKeys[comment.id!] = GlobalKey();
              mapLayerLinkComments[comment.id!] = LayerLink();
            }

            List<ReportData> reportOfPhotos = [];
            List<ReportData> reportOfFile = [];
            List<ReportData> reportOfLink = [];

            for (var element in listAssigns) {
              if (element.assignerId != PrefUtils().getUser()!.id) {
                mentionDatas.add(element.toJson());
              }
            }

            for (var report in listReports) {
              if (report.type == 'PHOTO') {
                reportOfPhotos.add(report);
              } else if (report.type == 'FILE') {
                reportOfFile.add(report);
              } else if (report.type == 'URL') {
                reportOfLink.add(report);
              } else {
                continue;
              }
            }

            emit(FetchTaskSuccess(
              hasMoreComment: taskDetailCustom.pagination!.currentPage! ==
                  taskDetailCustom.pagination!.totalPages! - 1,
              taskData: taskData,
              listAssigns: listAssigns,
              reportOfPhoto: reportOfPhotos,
              reportOfFile: reportOfFile,
              reportOfLink: reportOfLink,
              commentDatas: listComments,
              mentionData: mentionDatas,
              commentKeys: commentKeys,
              mapLayerLink: mapLayerLinkComments,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        },
      );
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;
        var requestData = TaskData(
          creatorId: PrefUtils().getUser()!.id,
          title: event.title,
          description: event.description,
          priority: event.priority,
          status: event.status,
          dueAt: successState.taskData.dueAt,
        );
        await _repository
            .updateTask(event.id, requestData: requestData.toJson())
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseData<TaskData> responseData =
                ResponseData.fromJson(value.data, TaskData.fromJson);

            TaskData taskData = successState.taskData.copyWith(
              title: responseData.data!.title,
              description: responseData.data!.description,
              priority: responseData.data!.priority,
              status: responseData.data!.status,
              startDate: responseData.data!.startDate,
              dueAt: responseData.data!.dueAt,
            );
            emit(successState.copyWith(
              taskData: taskData,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateComment(
    UpdateCommentEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;
        var requestData = {
          'text': event.text,
        };
        await _repository
            .updateComment(event.commentId, requestData: requestData)
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseData<CommentData> responseData =
                ResponseData.fromJson(value.data, CommentData.fromJson);
            final updateComment = successState.commentDatas.map((comment) {
              if (comment.id == responseData.data?.id) {
                return comment.copyWith(
                  id: comment.id,
                  text: responseData.data?.text,
                  updatedAt: responseData.data?.updatedAt,
                );
              }
              return comment;
            }).toList();
            emit(successState.copyWith(
              commentDatas: updateComment,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
        logger.i('error here');
      }
    }
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      UserData currentUser = PrefUtils().getUser()!;
      final successState = state as FetchTaskSuccess;
      var requestData = {
        'text': event.content,
      };
      await _repository
          .addComment(successState.taskData.id!, requestData: requestData)
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseData<CommentData> responseData =
              ResponseData.fromJson(value.data, CommentData.fromJson);
          CommentData commentData = responseData.data!;
          commentData = commentData.copyWith(
              creatorId: currentUser.id,
              image: currentUser.imagePath,
              username: '${currentUser.firstName} ${currentUser.lastName!}');
          emit(successState.copyWith(
            commentDatas: [commentData, ...successState.commentDatas],
            commentKeys: {
              ...successState.commentKeys,
              commentData.id!: GlobalKey()
            },
            mapLayerLink: {
              ...successState.mapLayerLink,
              commentData.id!: LayerLink()
            },
          ));
        } else {
          emit(TaskDetailErrorState('lbl_error'.tr()));
        }
      });
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onFetchComments(
    FetchCommentEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;
        if (successState.hasMoreComment) {
          return;
        } else {
          Map<String, dynamic> queryParam = <String, dynamic>{
            'page': currentPage,
            'size': 10,
          };
          final Map<int, GlobalKey<CommentTaskWidgetState>> mapkey = {};
          await _repository
              .getComments(event.taskId, queryParam: queryParam)
              .then(
            (value) async {
              if (value.statusCode == 200) {
                ResponseList<CommentData> listComments =
                    ResponseList.fromJson(value.data, CommentData.fromJson);
                for (var comment in listComments.data!) {
                  mapkey[comment.id!] = GlobalKey();
                }
                final commentDatas = [
                  ...successState.commentDatas,
                  ...?listComments.data,
                ];
                final commentKeys = {
                  ...(successState.commentKeys),
                  ...mapkey,
                };
                final hasMoreComment = listComments.pagination!.currentPage! ==
                    listComments.pagination!.totalPages! - 1;

                emit(successState.copyWith(
                  hasMoreComment: hasMoreComment,
                  commentDatas: commentDatas,
                  commentKeys: commentKeys,
                ));
              } else {
                emit(TaskDetailErrorState('lbl_error'.tr()));
                logger.i('error here');
              }
            },
          ).onError((error, staceTrack) {});
          currentPage++;
        }
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
        logger.i('error here with: $e');
      }
    }
  }

  Future<void> _onUpdateStartAtTask(
    UpdateStartAtTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    if (state is FetchTaskSuccess) {
      final successState = state as FetchTaskSuccess;
      var requestData = TaskData(
          creatorId: PrefUtils().getUser()!.id,
          title: successState.taskData.title,
          description: successState.taskData.description,
          priority: successState.taskData.priority,
          status: successState.taskData.status,
          dueAt: successState.taskData.dueAt,
          startDate: event.dateTime.toString());
      await _repository
          .updateTask(successState.taskData.id!,
              requestData: requestData.toJson())
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseData<TaskData> responseData =
              ResponseData.fromJson(value.data, TaskData.fromJson);

          TaskData taskData = successState.taskData.copyWith(
            title: responseData.data!.title,
            description: responseData.data!.description,
            priority: responseData.data!.priority,
            status: responseData.data!.status,
            startDate: responseData.data!.startDate,
            dueAt: responseData.data!.dueAt,
          );
          emit(successState.copyWith(
            taskData: taskData,
          ));
        } else {
          emit(TaskDetailErrorState('lbl_error'.tr()));
        }
      });
    }
  }

  Future<void> _onUpdateDueAtTask(
    UpdateDueAtTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    if (state is FetchTaskSuccess) {
      final successState = state as FetchTaskSuccess;
      logger.i(event.dateTime.toString());
      var requestData = TaskData(
          creatorId: PrefUtils().getUser()!.id,
          title: successState.taskData.title,
          description: successState.taskData.description,
          priority: successState.taskData.priority,
          status: successState.taskData.status,
          dueAt: event.dateTime.toString(),
          startDate: successState.taskData.startDate);
      await _repository
          .updateTask(successState.taskData.id!,
              requestData: requestData.toJson())
          .then((value) async {
        if (value.statusCode == 200) {
          ResponseData<TaskData> responseData =
              ResponseData.fromJson(value.data, TaskData.fromJson);

          TaskData taskData = successState.taskData.copyWith(
            title: responseData.data!.title,
            description: responseData.data!.description,
            priority: responseData.data!.priority,
            status: responseData.data!.status,
            startDate: responseData.data!.startDate,
            dueAt: responseData.data!.dueAt,
          );
          emit(successState.copyWith(
            taskData: taskData,
          ));
        } else {
          emit(TaskDetailErrorState('lbl_error'.tr()));
        }
      });
    }
  }

  Future<void> _onAttachmentUrl(
    AttachmentsURLEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;

        ReportData reportData = ReportData();
        await _repository
            .addReportUrl(
                requestData: reportData.toJson(PrefUtils().getUser()!.id!,
                    successState.taskData.id!, event.url))
            .then((value) async {
          if (value.statusCode == 200) {
            NavigatorService.pushNamedAndRemoveUtil(AppRoutes.taskDetailScreen,
                arguments:
                    TaskDetailArguments(taskId: successState.taskData.id));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onDownload(
    DownloadFileEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;

        Map<String, dynamic> queryParam = {
          'reportId': event.reportId,
          'taskId': successState.taskData.id,
          'userId': PrefUtils().getUser()!.id,
        };
        await _repository
            .downloadFile(
                successState.taskData.id!, event.reportId, event.fileName,
                queryParam: queryParam)
            .then((value) {});
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _openUrl(
    OpenUrlEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      LaunchUrl().openUrl(event.url);
    } catch (e) {
      emit(TaskDetailErrorState('lbl_error'.tr()));
    }
  }

  Future<void> _openFile(
    OpenFileEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
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
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onAssign(
    AssignTaskEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;

        Map<String, dynamic> requestData = {
          'to_userId': event.toUserId,
        };

        await _repository
            .createAssign(successState.taskData.id!, requestData: requestData)
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseData<AssignData> responseData =
                ResponseData.fromJson(value.data, AssignData.fromJson);
            AssignData assignData = responseData.data!;
            assignData.image = event.pathImage;
            assignData.name = event.assigerName;
            assignData.mention =
                event.assigerName.toLowerCase().replaceAll(' ', '');
            final afterAssign = [...successState.listAssigns, assignData];
            final newMentionData = List.of(successState.mentionData)
              ..add(assignData.toJson());
            emit(successState.copyWith(
              listAssigns: afterAssign,
              mentionData: newMentionData,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onRemoveAssign(
    RemoveAssignEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;
        Map<String, dynamic> requestData = {
          'to_userId': null,
        };
        await _repository
            .removeAssign(successState.taskData.id!, event.assignId,
                requestData: requestData)
            .then((value) {
          if (value.statusCode == 200) {
            final afterRemove = List.of(successState.listAssigns)
              ..removeWhere(
                (element) => element.id == event.assignId,
              );
            final mentionAfterRemove = List.of(successState.mentionData)
              ..removeWhere(
                (element) => AssignData.fromJson(element).id == event.assignId,
              );
            emit(successState.copyWith(
              listAssigns: afterRemove,
              mentionData: mentionAfterRemove,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdatePriority(
    UpdatePriorityEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;

        final currentTask = successState.taskData;
        var requestData = TaskData(
          priority: event.priority,
        );
        await _repository
            .updatePriorityTask(currentTask.id!,
                requestData: requestData.toJson())
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseData<TaskData> responseData =
                ResponseData.fromJson(value.data, TaskData.fromJson);
            final taskAfter = successState.taskData.copyWith(
              priority: responseData.data!.priority,
            );
            emit(successState.copyWith(
              taskData: taskAfter,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onUpdateStatus(
    UpdateStatusEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    try {
      if (state is FetchTaskSuccess) {
        final successState = state as FetchTaskSuccess;
        final currentTask = successState.taskData;
        var requestData = TaskData(
          status: event.status,
        );
        await _repository
            .updateStatusTask(currentTask.id!,
                requestData: requestData.toJson())
            .then((value) async {
          if (value.statusCode == 200) {
            ResponseData<TaskData> responseData =
                ResponseData.fromJson(value.data, TaskData.fromJson);
            final taskAfter = successState.taskData.copyWith(
              status: responseData.data!.status,
            );
            emit(successState.copyWith(
              taskData: taskAfter,
            ));
          } else {
            emit(TaskDetailErrorState('lbl_error'.tr()));
          }
        });
      }
    } catch (e) {
      if (e is NoInternetException) {
        emit(TaskDetailErrorState('error_no_internet'.tr()));
      } else {
        emit(TaskDetailErrorState('lbl_error'.tr()));
      }
    }
  }

  Future<void> _onReloadComments(
    ReloadComments event,
    Emitter<TaskDetailState> emit,
  ) async {
    final successState = state as FetchTaskSuccess;
    emit(successState);
    // try {
    //   final Map<int, GlobalKey<CommentTaskWidgetState>> mapkey = {};
    //   await _repository.getComments(event.taskId).then((value) {
    //     if (value.statusCode == 200) {
    //       ResponseList<CommentData> listComments =
    //           ResponseList.fromJson(value.data, CommentData.fromJson);
    //       for (var comment in listComments.data!) {
    //         mapkey[comment.id!] = GlobalKey();
    //       }
    //       final commentDatas = [
    //         ...successState.commentDatas,
    //         ...?listComments.data,
    //       ];
    //       final commentKeys = {
    //         ...(successState.commentKeys),
    //         ...mapkey,
    //       };
    //       final hasMoreComment = listComments.pagination!.currentPage! ==
    //           listComments.pagination!.totalPages! - 1;

    //       emit(successState.copyWith(
    //         hasMoreComment: hasMoreComment,
    //         commentDatas: commentDatas,
    //         commentKeys: commentKeys,
    //       ));
    //     }
    //   });
    // } catch (e) {
    //   if (e is NoInternetException) {
    //     emit(TaskDetailErrorState('error_no_internet'.tr()));
    //   } else {
    //     emit(TaskDetailErrorState('lbl_error'.tr()));
    //   }
    // }
  }
}
