import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/utils/validation_functions.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_bloc.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_event.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_state.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/app_export.dart';

class CreateNewTaskDialog extends StatefulWidget {
  const CreateNewTaskDialog({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<CreateNewTaskBloc>(
      create: (context) => CreateNewTaskBloc(CreateNewTaskState()),
      child: const CreateNewTaskDialog(),
    );
  }

  @override
  State<CreateNewTaskDialog> createState() => _CreateNewTaskDialogState();
}

class _CreateNewTaskDialogState extends State<CreateNewTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _focusTitle = FocusNode();

  final _focusDescription = FocusNode();

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _dueAtController =
      TextEditingController(text: DateTime.now().format(pattern: D_M_Y_HH_mm));

  String priority = 'LOW';

  @override
  void dispose() {
    _focusTitle.dispose();
    _focusDescription.dispose();
    super.dispose();
  }

=======
import 'package:taskflow/src/widgets/custom_text_button.dart';
import 'package:taskflow/src/utils/app_export.dart';

class CreateNewTaskDialog extends StatelessWidget {
  CreateNewTaskDialog({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<CreateNewTaskBloc>(
      create: (context) => CreateNewTaskBloc(
        CreateNewTaskState(),
      )..add(CreateNewTaskInitialEvent()),
      child: CreateNewTaskDialog(),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateNewTaskBloc, CreateNewTaskState>(
      listener: (context, state) {
        if (state is CreateNewTaskSuccessState) {
<<<<<<< HEAD
          NavigatorService.goBack(signals: true);
        } else if (state is CreateNewTaskErrorState) {
          NavigatorService.goBack(signals: false);
=======
          if (state.isSuccess) {
            NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
          }
        } else if (state is CreateNewTaskErrorState) {
          NavigatorService.showErrorAndGoBack("lbl_error".tr());
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadiusStyle.customBorderT5,
              ),
              child: Column(
                children: [
                  _buildAppBar(context),
<<<<<<< HEAD
                  SizedBox(
                    height: 10.h,
                  ),
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                  _buildTaskNameInput(context),
                  SizedBox(
                    height: 5.h,
                  ),
<<<<<<< HEAD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'lbl_due_at'.tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          _buildDueAtInput(context),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'lbl_by_priority'.tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          _buildDropPriority(context),
                        ],
                      ),
=======
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "lbl_due_at".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDueAtInput(context),
                      _buildDropPriority(context),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
<<<<<<< HEAD
                      'lbl_description'.tr(),
=======
                      "lbl_description".tr(),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  _buildTaskDescriptionInput(context),
                  SizedBox(
<<<<<<< HEAD
                    height: 10.h,
=======
                    height: 5.h,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                  ),
                  _buildCreateButton(context),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
<<<<<<< HEAD
      leading: CustomIconButton(
        height: 30.h,
        width: 35.w,
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 30.sp,
        ),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: Text(
        'lbl_create_new_task'.tr(),
=======
      leading: Transform.rotate(
        angle: 50 * 3.1415926535 / 70,
        child: CustomIconButton(
          onTap: () {
            NavigatorService.goBack();
          },
          child: Icon(
            Icons.add,
            color: Colors.red,
            size: 30.sp,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        "lbl_create_new_task".tr(),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildTaskNameInput(BuildContext context) {
<<<<<<< HEAD
    return CustomTextFormField(
      controller: _titleController,
      focusNode: _focusTitle,
      hintText: 'lbl_name_task'.tr(),
      hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(),
      contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 15.h),
      onFieldSubmitted: (_) {
        if (_formKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(_focusDescription);
        }
      },
      validator: (value) {
        if (!isText(value) || value!.isEmpty) {
          return 'err_please_enter_valid_text'.tr();
        }
        return null;
=======
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        TextEditingController?>(
      selector: (state) => state.taskNameInputController,
      builder: (context, state) {
        return CustomTextFormField(
          controller: state,
          hintText: "lbl_name_task".tr(),
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(),
          contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 15.h),
          validator: (value) {
            if (!isText(value) || value!.isEmpty) {
              return "err_please_enter_valid_text".tr();
            }
            return null;
          },
        );
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      },
    );
  }

  Widget _buildTaskDescriptionInput(BuildContext context) {
<<<<<<< HEAD
    return CustomTextFormField(
      controller: _descriptionController,
      focusNode: _focusDescription,
      hintText: 'lbl_description'.tr(),
      hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(),
      textInputAction: TextInputAction.done,
      maxLines: 1,
      contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
      validator: (value) {
        if (!isText(value)) {
          return 'err_please_enter_valid_text'.tr();
        }
        return null;
=======
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        TextEditingController?>(
      selector: (state) => state.taskDescriptionInputController,
      builder: (context, state) {
        return CustomTextFormField(
          controller: state,
          hintText: "lbl_description".tr(),
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          textInputAction: TextInputAction.done,
          maxLines: 1,
          contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
        );
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      },
    );
  }

  Widget _buildDueAtInput(BuildContext context) {
<<<<<<< HEAD
    return CustomTextFormField(
      autofocus: false,
      readOnly: true,
      width: 155.w,
      controller: _dueAtController,
      alignment: Alignment.centerLeft,
      contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 5.h),
      onTap: () {
        onTapDueAtInput(context);
=======
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        TextEditingController?>(
      selector: (state) => state.taskDueAtInputController,
      builder: (context, state) {
        return CustomTextFormField(
          autofocus: false,
          readOnly: true,
          width: 155.w,
          controller: state,
          alignment: Alignment.centerLeft,
          contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 5.h),
          onTap: () {
            onTapDueAtInput(context);
          },
        );
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      },
    );
  }

  Widget _buildDropPriority(BuildContext context) {
    List<String> trans =
        Utils().priorityItems.map((priority) => priority.tr()).toList();
    int indexPriority;
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        CreateNewTaskState>(
      selector: (state) => state,
      builder: (context, state) {
        return CustomDropdownButton(
          textStyle: Theme.of(context).textTheme.bodyMedium,
          items: trans,
<<<<<<< HEAD
          value: priority.tr(),
          onChanged: (value) {
            indexPriority = trans.indexOf(value!);
            setState(() {
              priority = Utils().priorityItems[indexPriority];
            });
=======
          value: state.priority!.tr(),
          onChanged: (value) {
            indexPriority = trans.indexOf(value!);
            String? priority = Utils().priorityItems[indexPriority];
            context
                .read<CreateNewTaskBloc>()
                .add(ChangePriorityEvent(priority));
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          },
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomTextButton(
<<<<<<< HEAD
            height: 30.h,
            text: 'bt_create_task'.tr(),
            buttonTextStyle: Theme.of(context).textTheme.titleLarge,
            buttonStyle: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.circleBorder5,
=======
            text: "bt_create".tr(),
            buttonTextStyle: Theme.of(context).textTheme.titleLarge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadiusStyle.circleBorder30,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            ),
            onPressed: () {
              onTapCreate(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> onTapDueAtInput(BuildContext context) async {
<<<<<<< HEAD
=======
    var initialState = BlocProvider.of<CreateNewTaskBloc>(context).state;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime.now(),
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
<<<<<<< HEAD
        setState(() {
          _dueAtController.text = dateTime!.format(pattern: D_M_Y_HH_mm);
        });
=======
        initialState.taskDueAtInputController?.text =
            dateTime.format(pattern: D_M_Y_HH_mm);
        // ignore: use_build_context_synchronously
        context.read<CreateNewTaskBloc>().add(ChangeDateEvent(date: dateTime));
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      }
    }
  }

<<<<<<< HEAD
  void onTapCreate(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CreateNewTaskBloc>().add(
            CreateNewTaskEvent(
              title: _titleController.text,
              description: _descriptionController.text,
              priority: priority,
              dueAt: _dueAtController.text,
            ),
=======
  onTapCreate(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CreateNewTaskBloc>().add(
            CreateTaskEvent(),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          );
    }
  }
}
