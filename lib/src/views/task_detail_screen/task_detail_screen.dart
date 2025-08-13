import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/report/report_data.dart';
<<<<<<< HEAD
import 'package:taskflow/src/data/model/task/assign_data.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/progress_dialog_utils.dart';
import 'package:taskflow/src/utils/validation_functions.dart';
=======
import 'package:taskflow/src/data/model/task/task_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
<<<<<<< HEAD
=======
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_model.dart';
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/views/task_detail_screen/widgets/assign_custom_field.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/comment_task_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/detail_assign_dialog.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/report_item_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/report_photo_widget.dart';
import 'package:taskflow/src/views/task_detail_screen/widgets/report_url_dialog.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});
  static Widget builder(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as TaskDetailArguments;
    return BlocProvider<TaskDetailBloc>(
      create: (context) => TaskDetailBloc(
        TaskDetailState(),
      )..add(FetchDetailEvent(id: arg.taskId!)),
      child: const TaskDetailScreen(),
    );
  }

  @override
  State<TaskDetailScreen> createState() => TaskDetailScreenState();
}

class TaskDetailScreenState extends State<TaskDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusAddComments = FocusNode();
  final FocusNode _focusDescription = FocusNode();
  final FocusNode _focusTitle = FocusNode();
  final GlobalKey<AssignCustomFieldState> _assignGlobal = GlobalKey();
  final GlobalKey<FlutterMentionsState> _mentionKey =
      GlobalKey<FlutterMentionsState>();
  late List<Map<String, dynamic>> mentionData = [];

  bool _showOptionUpdate = false;
  bool _showOptionAddFile = false;
  bool readOnly = false;
  bool isUpdateComment = false;
  bool isHandleAddMember = false;

  late String originalStatus;
  late String originalPriority;
  late String originalDescription;
  late TextEditingController _description;
  late String originalTitle;
  late TextEditingController _title;
  late int _editingCommentId;

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

  void _requestFocusAddComment(String id) async {
    final controller = _mentionKey.currentState?.controller;
    String diplay = mentionData.firstWhere((e) => e['id'] == id)['display'];
    final mentionText = '@$diplay ';

    final text = controller!.text;
    final selection = controller.selection;

    if (selection.start >= 0 && selection.end >= 0) {
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        mentionText,
      );

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.start + mentionText.length),
      );
    } else {
      controller.text += mentionText;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
    _focusAddComments.requestFocus();
  }

  void _sendComment() {
    final text = _mentionKey.currentState?.controller?.markupText ?? ' ';
    logger.i('Current text $text');
    if (text.isNotEmpty) {
      final pattern = RegExp(r'@\[\_\_(.*?)\_\_\]\(\_\_(.*?)\_\_\)');
      final matches = pattern.firstMatch(text);
      String? id;
      String? display;
      if (matches != null) {
        id = matches.group(1);
        display = matches.group(2);
        context.read<TaskDetailBloc>().add(AddCommentEvent(
            '@$display ${text.substring(text.indexOf(')') + 1)}', id!));
      } else {
        context.read<TaskDetailBloc>().add(AddCommentEvent(text, id));
      }
      _focusAddComments.unfocus();
      _mentionKey.currentState?.controller?.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as TaskDetailArguments;
    return Portal(
      child: SafeArea(
        child: BlocBuilder<TaskDetailBloc, TaskDetailState>(
          builder: (context, state) {
            if (state is FetchTaskLoading) {
              ProgressDialogUtils.showProgressDialog();
            } else if (state is TaskDetailErrorState) {
              return Scaffold(
                  appBar: CustomAppBar(
                    leading: CustomIconButton(
                      height: 30.h,
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 25.sp,
                      ),
                      onTap: () {
                        NavigatorService.pushNamedAndRemoveUtil(
                            AppRoutes.homeScreen);
                      },
                    ),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.error),
                      SizedBox(height: 5.h),
                      CustomTextButton(
                        text: 'bt_reload'.tr(),
                        onPressed: () {
                          context
                              .read<TaskDetailBloc>()
                              .add(FetchDetailEvent(id: arg.taskId!));
                        },
                      ),
                    ],
                  ));
            } else if (state is FetchTaskSuccess) {
              originalStatus = state.taskData.status!;
              originalPriority = state.taskData.priority!;
              originalDescription = state.taskData.description ?? '';
              _description = TextEditingController(text: originalDescription);
              originalTitle = state.taskData.title ?? '';
              _title = TextEditingController(text: originalTitle);
              mentionData = state.mentionData;
              readOnly = state.taskData.creatorId == PrefUtils().getUser()!.id;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  _mentionKey.currentState?.controller!.clear();
                  if (isUpdateComment) {
                    state.commentKeys[_editingCommentId]?.currentState
                        ?.resetText();
                  }
                  setState(() {
                    isUpdateComment = false;
                    isHandleAddMember = false;
                    _showOptionUpdate = false;
                    _showOptionAddFile = false;
                  });

                  FocusManager.instance.primaryFocus?.unfocus();
                  _assignGlobal.currentState?.reset();
                },
                child: Form(
                  key: _formKey,
                  child: Scaffold(
                    appBar: _buildAppBar(context, state.taskData),
                    body: _buildBody(context, state),
                  ),
                ),
              );
            }
            return const SizedBox();
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
        if (readOnly) ...{
          CustomIconButton(
            width: 40.w,
            height: 30.h,
            child: Icon(
              Icons.delete_forever,
              size: 25.sp,
            ),
            onTap: () {
              onTapToConfirmDelete(context, taskData);
            },
          )
        },
      ],
    );
  }
  Widget _buildBody(BuildContext context, FetchTaskSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDisplayTitle(context, state.taskData.title!),
        Expanded(
          child: Container(
            height: double.maxFinite,
            margin:
                EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h, bottom: 5.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriorityAndStatus(context, state.taskData),
                  SizedBox(height: 5.h),
                  _buildLable('lbl_description'.tr(), Icons.description),
                  _buildDescription(context),
                  SizedBox(height: 5.h),
                  _buildDateTask(context, state.taskData),
                  SizedBox(height: 5.h),
                  _buildLable('lbl_member'.tr(), Icons.account_box_outlined),
                  _buildAssign(context, state.listAssigns),
                  isHandleAddMember
                      ? AssignCustomField(
                          key: _assignGlobal,
                          assignTo: (userId, name, image) {
                            context.read<TaskDetailBloc>().add(AssignTaskEvent(
                                toUserId: userId,
                                assigerName: name,
                                pathImage: image));
                          },
                        )
                      : const SizedBox(),
                  _buildAttachments(context),
                  _buildDisplayDropAttchments(context, state, state.taskData),
                  Text("lbl_comments".tr(),
                      style: Theme.of(context).textTheme.bodyMedium),
                  _buildDisplayComments(context, state),
                ],
              ),
            ),
          ),
        ),
        if (_showOptionUpdate) ...{
          _buildOptionUpdate(context, isUpdateComment, state)
        },
        _showOptionAddFile == false
            ? _buildAddComment(context, state.taskData)
            : _buildOptionAddFile(context),
        SizedBox(height: 5.h),
      ],
    );
  }
  Widget _buildLable(String lable, IconData icon) {
    return Row(children: [
      Icon(icon, size: 15.sp),
      Text(lable, style: Theme.of(context).textTheme.bodyMedium)
    ]);
  }

  Widget _buildDisplayTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: CustomTextFormField(
        textStyle: Theme.of(context).textTheme.headlineMedium,
        controller: _title
          ..selection = TextSelection.collapsed(offset: _title.text.length),
        textInputType: TextInputType.multiline,
        borderDecoration: InputBorder.none,
        textInputAction: TextInputAction.done,
        focusNode: _focusTitle,
        readOnly: !readOnly,
        validator: (value) {
          if (!isText(value) || value!.isEmpty) {
            return "err_please_enter_valid_text".tr();
          }
          return null;
        },
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
            ? _buildDrop(context, Utils().statusItems, taskData, 140.w, false)
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
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
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
    return CustomTextFormField(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      controller: _description
        ..selection = TextSelection.collapsed(offset: _description.text.length),
      textInputType: TextInputType.multiline,
      borderDecoration: InputBorder.none,
      textInputAction: TextInputAction.none,
      focusNode: _focusDescription,
      readOnly: !readOnly,
      validator: (value) {
        if (!isText(value)) {
          return "err_please_enter_valid_text".tr();
        }
        return null;
      },
      onTap: () {
        if (readOnly) {
          _onTextFieldInteracted();
          _focusDescription.requestFocus();
        }
      },
      onChange: (value) {
        _onTextFieldInteracted();
      },
    );
  }

  Widget _buildAssign(BuildContext context, List<AssignData> assignData) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 35.h,
            width: double.maxFinite,
            child: GestureDetector(
              onTap: () async {
                if (readOnly) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => BlocProvider.value(
                      value: context.read<TaskDetailBloc>(),
                      child: const DetailAssignDialog(),
                    ),
                  );
                }
              },
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: assignData.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: CustomCircleAvatar(
                      imagePath: assignData.first.image!,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const Spacer(),
        !readOnly
            ? const SizedBox()
            : CustomIconButton(
                height: 35.h,
                width: 40.w,
                onTap: () {
                  setState(() {
                    isHandleAddMember = !isHandleAddMember;
                  });
                },
                child: !isHandleAddMember
                    ? Icon(
                        Icons.person_add_outlined,
                        size: 30.sp,
                      )
                    : Icon(
                        Icons.check,
                        size: 30.sp,
                      ),
              )
      ],
    );
  }

  Widget _buildDateTask(BuildContext context, TaskData taskData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStartDate(context, taskData),
        _buildEndDate(context, taskData),
      ],
    );
  }

  Widget _buildStartDate(BuildContext context, TaskData taskData) {
    return SizedBox(
      width: 100.w,
      child: CustomTextFormField(
        autofocus: true,
        readOnly: true,
        alignment: Alignment.center,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        hintText: "lbl_startDate".tr(),
        controller: taskData.startDate != null
            ? TextEditingController(
                text: DateTime.tryParse(taskData.startDate!)!
                    .format(pattern: D_M_Y))
            : null,
        contentPadding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
        onTap: () {
          if (readOnly) {
            onTapStartAt(context, taskData);
            _onTextFieldInteracted();
          }
        },
      ),
    );
  }

  Future<void> onTapStartAt(BuildContext context, TaskData taskData) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: taskData.startDate != null
            ? DateTime.tryParse(taskData.startDate!)
            : DateTime.tryParse(taskData.dueAt!)!,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime(1970),
        lastDate: DateTime.tryParse(taskData.dueAt!)!);
    if (dateTime != null) {
      // ignore: use_build_context_synchronously
      context.read<TaskDetailBloc>().add(UpdateStartAtTaskEvent(dateTime));
    }
  }

  Widget _buildEndDate(BuildContext context, TaskData taskData) {
    return SizedBox(
      width: 140.w,
      child: CustomTextFormField(
        autofocus: true,
        readOnly: true,
        alignment: Alignment.center,
        controller: TextEditingController(text: taskData.dueAt),
        contentPadding: EdgeInsets.fromLTRB(5.w, 5.h, 0.w, 5.h),
        onTap: () {
          if (readOnly) {
            onTapDateInput(context, taskData);
            _onTextFieldInteracted();
          }
        },
      ),
    );
  }

  Future<void> onTapDateInput(BuildContext context, TaskData taskData) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: taskData.startDate == null
            ? DateTime(1970)
            : DateTime.tryParse(taskData.startDate!)!,
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
          Icon(Icons.attachment_outlined, size: 15.sp),
          SizedBox(width: 5.w),
          Text("lbl_attachments".tr()),
          const Spacer(),
          Icon(Icons.add, size: 20.sp),
        ],
      ),
    );
  }
  Widget _buildDisplayDropAttchments(
      BuildContext context, FetchTaskSuccess state, TaskData taskData) {
    return Column(
      children: [
        if (state.reportOfPhoto.isNotEmpty) ...{
          _buildCustomDropAttach(context, Icons.photo, 'lbl_attach_photos'.tr(),
              taskData, state.reportOfPhoto)
        },
        if (state.reportOfLink.isNotEmpty) ...{
          _buildCustomDropAttach(context, Icons.link_rounded,
              'lbl_attach_link'.tr(), taskData, state.reportOfLink)
        },
        if (state.reportOfFile.isNotEmpty) ...{
          _buildCustomDropAttach(context, Icons.file_present,
              'lbl_attach_files'.tr(), taskData, state.reportOfFile)
        },
      ],
    );
  }

  Widget _buildCustomDropAttach(BuildContext context, IconData icons,
      String title, TaskData taskData, List<ReportData> reportData) {
    return Column(
      children: [
        ExpansionTile(
          title: Row(
            children: [
              Icon(icons, size: 20.sp),
              SizedBox(width: 5.w),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          children: title == 'lbl_attach_photos'.tr()
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
      ],
    );
  }

  Widget _buildOptionUpdate(
      BuildContext context, bool isUpdateTask, FetchTaskSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomIconButton(
          child: Icon(Icons.done, color: Colors.green, size: 25.sp),
          onTap: () async {
            if (!isUpdateTask) {
              if (_formKey.currentState!.validate()) {
                context.read<TaskDetailBloc>().add(
                      UpdateTaskEvent(
                        id: state.taskData.id!,
                        description: _description.text,
                        title: _title.text,
                        status: originalStatus,
                        priority: originalPriority,
                      ),
                    );
              }
            } else {
              context.read<TaskDetailBloc>().add(
                    UpdateCommentEvent(
                      commentId: _editingCommentId,
                      text: (state.commentKeys[_editingCommentId]!.currentState!
                          .getCurrentComment()),
                    ),
                  );
              setState(() {
                state.commentKeys[_editingCommentId]?.currentState
                    ?.unfoCusComment();
              });
            }
            setState(() {
              isUpdateComment = false;
              _showOptionUpdate = false;
            });
          },
        ),
        SizedBox(width: 10.w),
        Transform.rotate(
          angle: 90 * 3.1415926535 / 75,
          child: CustomIconButton(
            onTap: () {
              setState(() {
                if (isUpdateComment == true) {
                  state.commentKeys[_editingCommentId]?.currentState
                      ?.resetText();
                }
                isUpdateComment = false;
                _showOptionUpdate = false;
                _description = TextEditingController(text: originalDescription);
              });
            },
            child: Icon(Icons.add, color: Colors.red, size: 25.sp),
          ),
        ),
        SizedBox(width: 10.w)
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
              SizedBox(width: 10.w),
              Icon(Icons.file_present_outlined, size: 40.sp),
              SizedBox(width: 10.w),
              Text('File', style: Theme.of(context).textTheme.bodyMedium)
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
              SizedBox(width: 10.w),
              Icon(Icons.link_rounded, size: 40.sp),
              SizedBox(width: 10.w),
              Text('Link', style: Theme.of(context).textTheme.bodyMedium)
            ],
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (dialogContext) {
                  return BlocProvider.value(
                    value: context.read<TaskDetailBloc>(),
                    child: AlertDialog(
                      content: ReportUrlDialog.builder(dialogContext, (value) {
                        dialogContext
                            .read<TaskDetailBloc>()
                            .add(AttachmentsURLEvent(url: value));
                      }),
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

  void onTapToConfirmDelete(BuildContext context, TaskData taskData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ConfirmDeleteDialog.builder(
          NavigatorService.navigatorKey.currentContext!,
          CustomId(
            taskId: taskData.id!,
            type: 'TASK',
            title: 'lbl_title_delete_task'.tr(),
            subTitle: 'lbl_subtitle_delete_task'.tr(),
          ),
        ),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
      ),
    );
  }
  Widget _buildDisplayComments(BuildContext context, FetchTaskSuccess state) {
    return ListView.builder(
      itemCount: state.commentDatas.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final model = state.commentDatas[index];
        if (model.creatorId == PrefUtils().getUser()!.id!) {
          return CommentTaskWidget(
            key: state.commentKeys[model.id],
            commentData: model,
            onEditStarted: _onTextFieldInteracted,
            isUpdateComment: PrefUtils().getUser()!.id! == model.creatorId
                ? _onIsUpdateComment
                // ignore: avoid_types_as_parameter_names
                : (int) {},
            taskId: state.taskData.id!,
            requestFocus: _requestFocusAddComment,
          );
        }
        return CommentTaskWidget(
          commentData: model,
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
        SizedBox(width: 10.w),
        CustomCircleAvatar(
            imagePath: PrefUtils().getUser()!.imagePath!, size: 30),
        SizedBox(width: 5.w),
        Expanded(
          child: BlocListener<TaskDetailBloc, TaskDetailState>(
            listener: (context, state) {
              if (state is FetchTaskSuccess) {
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
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadiusStyle.circleBorder10)),
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
                    return Container(
                        color: Theme.of(context).colorScheme.surface,
                        height: 50.h,
                        width: 100.w,
                        child: Row(
                          children: [
                            CustomCircleAvatar(
                                imagePath: data['image'], size: 25),
                            SizedBox(width: 10.w),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(data['name']),
                            )
                          ],
                        ));
                  },
                ),
              ],
              onSearchChanged: (trigger, value) async {},
              onChanged: (val) {},
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: _sendComment,
          child: Icon(Icons.send, size: 20.sp, color: Colors.blue),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  void checkItemMentionExist(Map<String, String?> newItem) {
    final alreadyExist = mentionData.any((item) => item['id'] == newItem['id']);
    if (!alreadyExist) {
      mentionData.add(newItem);
    }
  }
}
