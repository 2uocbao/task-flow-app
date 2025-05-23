import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/utils.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_model.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/assign_custom_field.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/comment_task_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/detail_assign_dialog.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/report_item_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/report_photo_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/report_url_dialog.dart';
import 'package:taskflow/src/widgets/custom_circle_avatar.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});
  static Widget builder(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as TaskDetailArguments;
    return BlocProvider<TaskDetailBloc>(
      create: (context) => TaskDetailBloc(
        TaskDetailState(taskDetailModel: TaskDetailModel(taskData: TaskData())),
      )..add(FetchDetailEvent(id: arg.taskId!)),
      child: const TaskDetailScreen(),
    );
  }

  @override
  State<TaskDetailScreen> createState() => TaskDetailScreenState();
}

class TaskDetailScreenState extends State<TaskDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusAddComments = FocusNode();
  final FocusNode _focusDescription = FocusNode();
  final FocusNode _focusTitle = FocusNode();
  final GlobalKey<AssignCustomFieldState> _assignGlobal = GlobalKey();
  final GlobalKey<FlutterMentionsState> _mentionKey =
      GlobalKey<FlutterMentionsState>();
  List<Map<String, dynamic>> get mentionData => [];

  bool _showOptionUpdate = false;
  bool _showOptionAddFile = false;
  bool readOnly = false;
  bool isUpdateComment = false;

  late String originalStatus;
  late String originalPriority;
  late String originalDescription;
  late TextEditingController _description;
  late String originalTitle;
  late TextEditingController _title;
  int? _editingCommentId;
  late TextEditingController _commentController;

  late bool isSelected;

  final logger = Logger();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextFieldInteracted() async {
    if (!_showOptionUpdate) {
      setState(() {
        _showOptionUpdate = true;
        _description = TextEditingController(text: originalDescription);
        _title = TextEditingController(text: originalTitle);
      });
    }
  }

  void _onIsUpdateComment(int id) async {
    if (!isUpdateComment) {
      setState(() {
        isUpdateComment = true;
        _editingCommentId = id;
      });
    }
  }

  void _requestFocusAddComment(String text) async {
    _commentController = TextEditingController(text: text);
    _focusAddComments.requestFocus();
  }

  // void _candelUpdateComment(TaskDetailState state) async {
  //   setState(() {
  //     isUpdateComment = false;
  //   });
  //   state.taskDetailModel.commentKeys[_editingCommentId]?.currentState
  //       ?.resetText();
  // }

  void _sendComment() {
    final text = _mentionKey.currentState?.controller?.markupText ?? '';
    if (text.isNotEmpty) {
      context.read<TaskDetailBloc>().add(AddCommentEvent(text));
      _mentionKey.currentState?.controller?.clear();
    }
    _focusAddComments.requestFocus();
  }

  void _removeAssignCallBack() async {
    context.read<TaskDetailBloc>().add(RemoveAssignEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: SafeArea(
        child: BlocBuilder<TaskDetailBloc, TaskDetailState>(
          builder: (context, state) {
            if (state.taskDetailModel.taskData.id == null) {
              return Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Theme.of(context).colorScheme.surface,
              );
            } else {
              final taskData = state.taskDetailModel.taskData;
              originalStatus = taskData.status!;
              originalPriority = taskData.priority!;
              originalDescription = taskData.description ?? '';
              _description = TextEditingController(text: originalDescription);
              originalTitle = taskData.title ?? '';
              _title = TextEditingController(text: originalTitle);
              // _commentController = TextEditingController(text: '');
              readOnly = taskData.creatorId == PrefUtils().getUser()!.id;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _assignGlobal.currentState?.reset();
                },
                child: Scaffold(
                  appBar: _buildAppBar(context, taskData),
                  body: _buildBody(context, taskData, state.taskDetailModel),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, TaskData taskData) {
    return CustomAppBar(
      leading: CustomIconButton(
        height: 30.h,
        child: Icon(
          Icons.arrow_back_outlined,
          size: 25.sp,
        ),
        onTap: () {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
        },
      ),
      actions: [
        readOnly
            ? CustomIconButton(
                width: 40.w,
                height: 30.h,
                child: Icon(
                  Icons.delete_forever,
                  size: 25.w,
                ),
                onTap: () {
                  onTapToConfirmDelete(context, taskData);
                },
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildBody(BuildContext context, TaskData taskData,
      TaskDetailModel taskDetailModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDisplayTitle(context, taskData.title!),
        Expanded(
          child: SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  _buildPriorityAndStatus(context, taskData),
                  SizedBox(height: 5.h),
                  _buildLineSpace(),
                  SizedBox(height: 5.h),
                  Row(children: [
                    SizedBox(width: 10.w),
                    Icon(Icons.description, size: 15.w),
                    Text("lbl_description".tr(),
                        style: Theme.of(context).textTheme.bodyMedium)
                  ]),
                  _buildDescription(context),
                  _buildLineSpace(),
                  _buildDateTask(context, taskData),
                  _buildLineSpace(),
                  _buildAssign(context, taskData),
                  _buildLineSpace(),
                  _buildAttachments(context),
                  _buildLineSpace(),
                  _buildDisplayDrop(context, taskDetailModel, taskData),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.h),
                    child: Text("lbl_comments".tr(),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  _buildDisplayComments(context, taskDetailModel),
                ],
              ),
            ),
          ),
        ),
        if (_showOptionUpdate)
          _buildOptionUpdate(context, isUpdateComment, taskDetailModel),
        _showOptionAddFile == false
            ? _buildAddComment(context, taskData)
            : _buildOptionAddFile(context),
      ],
    );
  }

  Widget _buildLineSpace() {
    return Container(
      // color: LightCodeColors().blueGray100,
      height: 1.h,
    );
  }

  Widget _buildDisplayTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
      child: CustomTextFormField(
        textStyle: Theme.of(context).textTheme.headlineMedium,
        controller: _title
          ..selection = TextSelection.collapsed(offset: _title.text.length),
        textInputType: TextInputType.multiline,
        borderDecoration: InputBorder.none,
        textInputAction: TextInputAction.none,
        focusNode: _focusTitle,
        readOnly: !readOnly,
        onTap: () {
          if (readOnly) {
            _onTextFieldInteracted();
            _focusTitle.requestFocus();
          }
        },
        onChange: (value) {
          _onTextFieldInteracted();
        },
      ),
    );
  }

  Widget _buildPriorityAndStatus(BuildContext context, TaskData taskData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 20.w,
        ),
        readOnly
            ? _buildDrop(context, Utils().priorityItems, taskData, 100.w, true)
            : _buildShowPriority(context, taskData),
        SizedBox(
          width: 5.w,
        ),
        readOnly
            ? _buildDrop(context, Utils().statusItems, taskData, 120.w, false)
            : _buildDrop(
                context,
                [
                  ...Utils().statusForAssigner,
                  if (!Utils().statusForAssigner.contains(taskData.status))
                    taskData.status!
                ],
                taskData,
                120.w,
                false),
        SizedBox(width: 5.w)
      ],
    );
  }

  Widget _buildShowPriority(BuildContext context, TaskData taskData) {
    return Container(
      margin: EdgeInsets.only(
        right: 15.w,
        bottom: 5.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.circleBorder5,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.h),
        child: Text(
          taskData.priority!.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildDrop(BuildContext context, List<String> items, TaskData taskData,
      double width, bool isPriority) {
    List<String> trans = items.map((items) => items.tr()).toList();
    int indexTrans;
    return CustomDropdownButton(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      width: width,
      items: trans,
      value: isPriority ? originalPriority.tr() : originalStatus.tr(),
      onChanged: (value) async {
        if (value != null) {
          indexTrans = trans.indexOf(value);
          String? valueItems = items[indexTrans];
          isPriority
              ? context.read<TaskDetailBloc>().add(
                    UpdatePriorityEvent(valueItems),
                  )
              : context.read<TaskDetailBloc>().add(
                    UpdateStatusEvent(valueItems),
                  );
        }
      },
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      child: CustomTextFormField(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        controller: _description
          ..selection =
              TextSelection.collapsed(offset: _description.text.length),
        textInputType: TextInputType.multiline,
        borderDecoration: InputBorder.none,
        textInputAction: TextInputAction.none,
        focusNode: _focusDescription,
        readOnly: !readOnly,
        onTap: () {
          if (readOnly) {
            _onTextFieldInteracted();
            _focusDescription.requestFocus();
          }
        },
        onChange: (value) {
          _onTextFieldInteracted();
        },
      ),
    );
  }

  Widget _buildAssign(BuildContext context, TaskData taskData) {
    return taskData.assignTo == null
        ? AssignCustomField(
            key: _assignGlobal,
            assignTo: (userId) {
              context
                  .read<TaskDetailBloc>()
                  .add(AssignTaskEvent(toUserId: userId));
            },
          )
        : _buildHaveAssignee(context, taskData);
  }

  Widget _buildHaveAssignee(BuildContext context, TaskData taskData) {
    return GestureDetector(
      onTap: () async {
        if (taskData.assignTo == PrefUtils().getUser()!.id) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: DetailAssignDialog(
                removeAssign: _removeAssignCallBack,
                imageAssigner: taskData.imageAssigner!,
                usernameAssigner: taskData.usernameAssigner!,
              ),
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
            ),
          );
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Row(
          children: [
            ClipOval(
              clipBehavior: Clip.hardEdge,
              child: CustomImageView(
                height: 40.sp,
                width: 40.sp,
                imagePath: taskData.imageAssigner,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateTask(BuildContext context, TaskData taskData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStartDate(context, taskData),
          _buildEndDate(context, taskData),
        ],
      ),
    );
  }

  Widget _buildStartDate(BuildContext context, TaskData taskData) {
    DateTime? dateTime = DateTime.tryParse(taskData.createdAt!);
    return SizedBox(
      width: 110.w,
      child: CustomTextFormField(
        autofocus: true,
        readOnly: true,
        alignment: Alignment.centerLeft,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        hintText: "Start date",
        controller:
            TextEditingController(text: dateTime!.format(pattern: D_M_Y)),
        contentPadding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
      ),
    );
  }

  Widget _buildEndDate(BuildContext context, TaskData taskData) {
    return SizedBox(
      width: 150.w,
      child: CustomTextFormField(
        autofocus: true,
        readOnly: true,
        alignment: Alignment.centerLeft,
        controller: TextEditingController(text: taskData.dueAt),
        contentPadding: EdgeInsets.fromLTRB(5.w, 5.h, 0.w, 5.h),
        onTap: () {
          if (readOnly) {
            onTapDateInput(context);
            _onTextFieldInteracted();
          }
        },
      ),
    );
  }

  Future<void> onTapDateInput(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime(DateTime.now().year + 2));

    if (dateTime != null) {
      TimeOfDay? timeOfDay = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly,
      );
      if (timeOfDay != null) {
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
        // ignore: use_build_context_synchronously
        context.read<TaskDetailBloc>().add(UpdateDueAtTaskEvent(dateTime));
      }
    }
  }

  Widget _buildAttachments(BuildContext context) {
    return CustomIconButton(
      height: 30.h,
      width: double.maxFinite,
      decoration: null,
      onTap: () async {
        setState(() {
          _showOptionAddFile = true;
        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          Icon(
            Icons.attachment_outlined,
            size: 20.sp,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text("lbl_attachments".tr()),
          const Spacer(),
          Icon(
            Icons.add,
            size: 20.sp,
          ),
          SizedBox(
            width: 5.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayDrop(BuildContext context,
      TaskDetailModel taskDetailModel, TaskData taskData) {
    return Column(
      children: [
        taskDetailModel.reportOfPhoto.isNotEmpty
            ? _buildCustomDropAttach(
                context,
                Icons.photo,
                "lbl_attach_photos".tr(),
                taskData,
                taskDetailModel.reportOfPhoto)
            : const SizedBox(),
        taskDetailModel.reportOfLink.isNotEmpty
            ? _buildCustomDropAttach(context, Icons.link_rounded,
                "lbl_attach_link".tr(), taskData, taskDetailModel.reportOfLink)
            : const SizedBox(),
        taskDetailModel.reportOfFile.isNotEmpty
            ? _buildCustomDropAttach(
                context,
                Icons.file_present,
                "lbl_attach_files"..tr(),
                taskData,
                taskDetailModel.reportOfFile,
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildCustomDropAttach(BuildContext context, IconData icons,
      String type, TaskData taskData, List<ReportData> reportData) {
    return Column(
      children: [
        ExpansionTile(
          title: Row(
            children: [
              Icon(
                icons,
                size: 20.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                type.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          children: type == 'Photos'
              ? [
                  ReportPhotoWidget(
                    reportData,
                    taskData,
                    // requestFocus: _requestFocusAddComment,
                  )
                ]
              : reportData.map((report) {
                  return ReportItemWidget(
                    report,
                    taskData,
                    // requestFocus: _requestFocusAddComment,
                  );
                }).toList(),
        ),
        _buildLineSpace(),
      ],
    );
  }

  // Widget _buildCustomBottomBody(BuildContext context, TaskData taskData) {
  //   return SizedBox(
  //     height: 40.h,
  //     child: Row(
  //       children: [
  //         SizedBox(
  //           width: 10.w,
  //         ),
  //         CustomCircleAvatar(
  //             imagePath: PrefUtils().getUser()!.imagePath!, size: 40),
  //         SizedBox(
  //           width: 5.w,
  //         ),
  //         Expanded(
  //           child: SizedBox(
  //             height: 30.h,
  //             child: BlocListener<TaskDetailBloc, TaskDetailState>(
  //               listener: (context, state) {
  //                 if (state is AddCommentSuccess) {
  //                   _commentController.clear();
  //                   _focusAddComments.unfocus();
  //                   context
  //                       .read<TaskDetailBloc>()
  //                       .add(FetchCommentEvent(taskId: taskData.id!));
  //                 }
  //               },
  //               child: CustomTextFormField(
  //                   hintText: "lbl_add_comment".tr(),
  //                   controller: _commentController,
  //                   boxDecoration: BoxDecoration(
  //                     borderRadius: BorderRadiusStyle.circleBorder10,
  //                   ),
  //                   focusNode: _focusAddComments,
  //                   onChange: (value) {
  //                     if (taskData.assignTo != null) {
  //                       final cursorPosition =
  //                           _commentController.selection.baseOffset;
  //                       if (cursorPosition > 0 &&
  //                           value[cursorPosition - 1] == '@') {
  //                       } else {
  //                         // _removeOverlay();
  //                       }
  //                     }
  //                   },
  //                   suffix: GestureDetector(
  //                     onTap: () {
  //                       if (_commentController.text.isNotEmpty) {
  //                         context
  //                             .read<TaskDetailBloc>()
  //                             .add(AddCommentEvent(_commentController.text));
  //                       }
  //                     },
  //                     child: Icon(
  //                       Icons.send,
  //                       size: 20.sp,
  //                     ),
  //                   )),
  //             ),
  //           ),
  //         ),
  //         CustomIconButton(
  //           child: Icon(
  //             Icons.attach_file_outlined,
  //             size: 20.sp,
  //           ),
  //           onTap: () {
  //             setState(() {
  //               _showOptionAddFile = true;
  //             });
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOptionUpdate(BuildContext context, bool isUpdateTask,
      TaskDetailModel taskDetailModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconButton(
          child: Icon(
            Icons.done,
            color: Colors.green,
            size: 25.sp,
          ),
          onTap: () async {
            !isUpdateTask
                ? context.read<TaskDetailBloc>().add(
                      UpdateTaskEvent(
                        id: taskDetailModel.taskData.id!,
                        description: _description.text,
                        title: _title.text,
                        status: originalStatus,
                        priority: originalPriority,
                      ),
                    )
                : context.read<TaskDetailBloc>().add(
                      UpdateCommentEvent(
                        commentId: _editingCommentId!,
                        text: (taskDetailModel
                            .commentKeys[_editingCommentId]!.currentState!
                            .getCurrentComment()),
                      ),
                    );
            setState(() {
              isUpdateComment = false;
              _showOptionUpdate = false;
            });
          },
        ),
        SizedBox(
          width: 10.w,
        ),
        Transform.rotate(
          angle: 90 * 3.1415926535 / 75,
          child: CustomIconButton(
            onTap: () {
              setState(() {
                if (isUpdateComment == true) {
                  taskDetailModel.commentKeys[_editingCommentId]?.currentState
                      ?.resetText();
                }
                isUpdateComment = false;
                _showOptionUpdate = false;
                _description = TextEditingController(text: originalDescription);
              });
            },
            child: Icon(
              Icons.add,
              color: Colors.red,
              size: 25.sp,
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }

  Widget _buildOptionAddFile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomIconButton(
          height: 50.h,
          width: double.maxFinite,
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Icon(
                Icons.file_present_outlined,
                size: 40.sp,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'File',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
          onTap: () async {
            setState(() {
              _showOptionAddFile = false;
            });
            await pickFile();
          },
        ),
        CustomIconButton(
          height: 50.h,
          width: double.maxFinite,
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Icon(
                Icons.link_rounded,
                size: 40.sp,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Link',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (dialogContext) {
                  return BlocProvider.value(
                    value: context.read<TaskDetailBloc>(),
                    child: AlertDialog(
                      content: ReportUrlDialog.builder(
                        dialogContext,
                        (value) {
                          dialogContext
                              .read<TaskDetailBloc>()
                              .add(AttachmentsURLEvent(url: value));
                        },
                      ),
                      contentPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.zero,
                    ),
                  );
                });
          },
        ),
      ],
    );
  }

  onTapToConfirmDelete(BuildContext context, TaskData taskData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ConfirmDeleteDialog.builder(
          NavigatorService.navigatorKey.currentContext!,
          CustomId(
            taskId: taskData.id!,
            type: 'Task',
          ),
        ),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDisplayComments(
      BuildContext context, TaskDetailModel taskDetailModel) {
    return ListView.builder(
      itemCount: taskDetailModel.commentDatas.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final model = taskDetailModel.commentDatas[index];
        if (model.creatorId == PrefUtils().getUser()!.id!) {
          return CommentTaskWidget(
            key: taskDetailModel.commentKeys[model.id],
            model,
            onEditStarted: _onTextFieldInteracted,
            isUpdateComment: PrefUtils().getUser()!.id! == model.creatorId
                ? _onIsUpdateComment
                // ignore: avoid_types_as_parameter_names
                : (int) {},
            taskId: taskDetailModel.taskData.id!,
            requestFocus: _requestFocusAddComment,
          );
        }
        return CommentTaskWidget(
          model,
          taskId: '',
          onEditStarted: () {},
          isUpdateComment: (id) {},
          requestFocus: _requestFocusAddComment,
        );
      },
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      if (!mounted) return;
      if (result.files.single.path != null) {
        File file = File(result.files.single.path!);
        // ignore: use_build_context_synchronously
        context.read<TaskDetailBloc>().add(AttachmentsEvent(file: file));
      }
    }
  }

  Widget _buildAddComment(BuildContext context, TaskData taskData) {
    return Row(
      children: [
        SizedBox(
          width: 10.w,
        ),
        CustomCircleAvatar(
            imagePath: PrefUtils().getUser()!.imagePath!, size: 30),
        SizedBox(
          width: 5.w,
        ),
        Expanded(
          child: BlocListener<TaskDetailBloc, TaskDetailState>(
            listener: (context, state) {
              if (state is AddCommentSuccess) {
                _commentController.clear();
                _focusAddComments.unfocus();
                context
                    .read<TaskDetailBloc>()
                    .add(FetchCommentEvent(taskId: taskData.id!));
              }
            },
            child: FlutterMentions(
              key: _mentionKey,
              focusNode: _focusAddComments,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "lbl_add_comment".tr(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // circleBorder10
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              suggestionPosition: SuggestionPosition.Top,
              mentions: [
                Mention(
                  trigger: '@',
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w500),
                  data: mentionData,
                  matchAll: false,
                  suggestionBuilder: (data) {
                    // return ListTile(

                    //   title: Text(data['full_name']),
                    // );

                    return Container(
                        color: Theme.of(context).colorScheme.surface,
                        height: 50.h,
                        width: 100.w,
                        child: Row(
                          children: [
                            CustomCircleAvatar(
                                imagePath: PrefUtils().getUser()!.imagePath!,
                                size: 25),
                            SizedBox(width: 10.w),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(data['full_name']),
                            )
                          ],
                        ));
                  },
                ),
              ],
              onChanged: (val) {
                // Gọi API kiểm tra @ nếu cần thêm
              },
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: _sendComment,
          child: Icon(
            Icons.send,
            size: 20.sp,
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
      ],
    );
  }
}
