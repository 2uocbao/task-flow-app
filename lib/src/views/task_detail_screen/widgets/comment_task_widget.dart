import 'package:easy_localization/easy_localization.dart';
<<<<<<< HEAD
import 'package:extended_text_field/extended_text_field.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';

class CommentTaskWidget extends StatefulWidget {
  final CommentData commentData;
=======
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/widgets/custom_circle_avatar.dart';

// ignore: must_be_immutable
class CommentTaskWidget extends StatefulWidget {
  CommentData commentData;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  final String taskId;

  final VoidCallback onEditStarted;

  final Function(int id) isUpdateComment;

  final Function(String username) requestFocus;

<<<<<<< HEAD
  const CommentTaskWidget({
    super.key,
    required this.commentData,
=======
  CommentTaskWidget(
    this.commentData, {
    super.key,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    required this.taskId,
    required this.onEditStarted,
    required this.isUpdateComment,
    required this.requestFocus,
  });

  @override
  State<CommentTaskWidget> createState() => CommentTaskWidgetState();
}

class CommentTaskWidgetState extends State<CommentTaskWidget> {
  final FocusNode _commentFocusNode = FocusNode();
  late final TextEditingController _commentController;
  late String originalContent = '';

  @override
  void initState() {
    super.initState();
    originalContent = widget.commentData.text!;
    _commentController = TextEditingController(text: originalContent);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void resetText() async {
    setState(() {
      _commentFocusNode.unfocus();
      _commentController.text = originalContent;
    });
  }

<<<<<<< HEAD
  void unfoCusComment() async {
    setState(() {
      _commentFocusNode.unfocus();
    });
  }

=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  void _onEditButtonPressed(int id) async {
    FocusScope.of(context).requestFocus(_commentFocusNode);
    widget.onEditStarted();
    widget.isUpdateComment(id);
  }

  String getCurrentComment() {
    setState(() {
      originalContent = _commentController.text;
    });
    return _commentController.text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
<<<<<<< HEAD
          SizedBox(width: 5.w),
          CustomCircleAvatar(imagePath: widget.commentData.image!, size: 40),
          SizedBox(width: 5.w),
=======
          SizedBox(
            width: 5.w,
          ),
          CustomCircleAvatar(imagePath: widget.commentData.image!, size: 40),
          SizedBox(
            width: 5.w,
          ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                SizedBox(height: 5.h),
=======
                SizedBox(
                  height: 5.h,
                ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        Text(
                          widget.commentData.username!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          formatDateAndTime(
                            date: widget.commentData.createdAt!,
                          ),
=======
                        Text(widget.commentData.username!,
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          formatDateAndTime(
                              date: widget.commentData.createdAt!),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
<<<<<<< HEAD
                    Transform.rotate(
                      angle: 90 * 3.1415926535 / 180,
                      child: CustomIconButton(
                        child: Icon(
                          Icons.keyboard_control_sharp,
                          size: 25.sp,
                        ),
                        onTap: () {
                          final RenderBox button =
                              context.findRenderObject() as RenderBox;
                          final RenderBox overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          final Offset buttonPosition = button
                              .localToGlobal(Offset.zero, ancestor: overlay);
                          final Size buttonSize = button.size;
                          final Size overlaySize = overlay.size;

                          final RelativeRect position = RelativeRect.fromLTRB(
                            buttonPosition.dx + buttonSize.width,
                            buttonPosition.dy + 30.h,
                            overlaySize.width -
                                (buttonPosition.dx + buttonSize.width),
                            overlaySize.height -
                                (buttonPosition.dy + buttonSize.height),
                          );
                          if (widget.commentData.creatorId ==
                              PrefUtils().getUser()!.id) {
                            _buildShowMyMenuComments(context, position);
                          } else {
                            showMenu(
                              context: context,
                              position: position,
                              items: [
                                PopupMenuItem(
                                  child: Text(
                                    "bt_reply".tr(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  onTap: () {
                                    widget.requestFocus(
                                        widget.commentData.creatorId!);
                                  },
                                ),
                              ],
                            );
                          }
                        },
=======
                    CustomIconButton(
                      child: Transform.rotate(
                        angle: 90 * 3.1415926535 / 180,
                        child: CustomIconButton(
                          child: Icon(
                            Icons.keyboard_control_sharp,
                            size: 25.sp,
                          ),
                          onTap: () {
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;
                            final Offset buttonPosition = button
                                .localToGlobal(Offset.zero, ancestor: overlay);
                            final Size buttonSize = button.size;
                            final Size overlaySize = overlay.size;

                            final RelativeRect position = RelativeRect.fromLTRB(
                              buttonPosition.dx + buttonSize.width,
                              buttonPosition.dy + 30.h,
                              overlaySize.width -
                                  (buttonPosition.dx + buttonSize.width),
                              overlaySize.height -
                                  (buttonPosition.dy + buttonSize.height),
                            );
                            if (widget.commentData.creatorId ==
                                PrefUtils().getUser()!.id) {
                              _buildShowMyMenuComments(context, position);
                            } else {
                              showMenu(
                                context: context,
                                position: position,
                                items: [
                                  PopupMenuItem(
                                    child: Text(
                                      "bt_reply".tr(),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    onTap: () {
                                      widget.requestFocus(
                                          widget.commentData.creatorId!);
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD
                SizedBox(height: 5.h),
                SizedBox(
                  child: ExtendedTextField(
                    controller: _commentController,
                    specialTextSpanBuilder: MentionTextSpanBuilder(),
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodySmall,
                    focusNode: _commentFocusNode,
                    readOnly: PrefUtils().getUser()!.id! !=
                        widget.commentData.creatorId,
=======
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  child: CustomTextFormField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    readOnly: PrefUtils().getUser()!.id! !=
                        widget.commentData.creatorId,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadiusStyle.circleBorder5,
                    ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                    onTap: () {
                      if (PrefUtils().getUser()!.id! ==
                          widget.commentData.creatorId) {
                        _onEditButtonPressed(widget.commentData.id!);
                      }
                    },
<<<<<<< HEAD
                    onChanged: (value) {
                      widget.commentData.text = value;
                    },
                  ),
                ),
                // SizedBox(
                //   child: CustomTextFormField(
                //     controller: _commentController,
                //     focusNode: _commentFocusNode,
                //     textStyle: Theme.of(context).textTheme.bodySmall,
                //     readOnly: PrefUtils().getUser()!.id! !=
                //         widget.commentData.creatorId,
                //     boxDecoration: BoxDecoration(
                //       borderRadius: BorderRadiusStyle.circleBorder5,
                //     ),
                //     onTap: () {
                //       if (PrefUtils().getUser()!.id! ==
                //           widget.commentData.creatorId) {
                //         _onEditButtonPressed(widget.commentData.id!);
                //       }
                //     },
                //     onChange: (value) {
                //       widget.commentData.text = value;
                //     },
                //   ),
                // ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
          SizedBox(width: 5.h),
=======
                    onChange: (value) {
                      widget.commentData.text = value;
                    },
                  ),
                  // child: ExtendedTextField(
                  //   controller: _commentController,
                  //   specialTextSpanBuilder: MySpecialTextSpanBuilder(),
                  //   maxLines: null,
                  // ),
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5.h,
          ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        ],
      ),
    );
  }

<<<<<<< HEAD
  Future _buildShowMyMenuComments(BuildContext context, RelativeRect position) {
=======
  _buildShowMyMenuComments(BuildContext context, RelativeRect position) {
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    return showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: Text(
            "bt_edit".tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            _onEditButtonPressed(widget.commentData.id!);
          },
        ),
        PopupMenuItem(
          child: Text(
            "bt_delete".tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ConfirmDeleteDialog.builder(
                  context,
                  CustomId(
                    commentId: widget.commentData.id.toString(),
                    taskId: widget.taskId,
<<<<<<< HEAD
                    type: 'COMMENT',
                    title: 'lbl_title_delete_comment'.tr(),
                    subTitle: 'lbl_subtitle_delete_comment'.tr(),
=======
                    type: 'Comment',
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                  ),
                ),
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.zero,
              ),
            );
          },
        ),
      ],
    );
  }
}

<<<<<<< HEAD
class MentionTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    if (flag.startsWith('@')) {
      return MentionText(flag, textStyle ?? const TextStyle(), onTap);
    }
    return null;
  }
}

class MentionText extends SpecialText {
  MentionText(String startFlag, TextStyle textStyle,
      SpecialTextGestureTapCallback? onTap)
      : super(startFlag, ' ', textStyle);

  @override
  InlineSpan finishText() {
    final mentionText = toString();
    return TextSpan(
      text: mentionText,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }
}
=======
// class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
//   @override
//   SpecialText? createSpecialText(String flag,
//       {TextStyle? textStyle,
//       SpecialTextGestureTapCallback? onTap,
//       required int index}) {
//     if (flag == '@') {
//       return MentionText(textStyle!, onTap!);
//     }
//     return null;
//   }
// }

// class MentionText extends SpecialText {
//   static const String startKey = '@';
//   static const String endKey = ' ';

//   MentionText(TextStyle textStyle, SpecialTextGestureTapCallback onTap)
//       : super(startKey, endKey, textStyle, onTap: onTap);

//   @override
//   InlineSpan finishText() {
//     final mention = toString(); // ví dụ: @nguyenvana

//     return SpecialTextSpan(
//       text: mention,
//       style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//       // recognizer: TapGestureRecognizer()..onTap = () => onTap?.call(mention),
//       recognizer: TapGestureRecognizer()
//         ..onTap = () {
//           if (onTap != null) {
//             onTap!(mention);
//           }
//         },
//     );
//   }
// }
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
