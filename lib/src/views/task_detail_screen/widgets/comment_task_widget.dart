import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
import 'package:taskflow/src/widgets/custom_circle_avatar.dart';

// ignore: must_be_immutable
class CommentTaskWidget extends StatefulWidget {
  CommentData commentData;

  final String taskId;

  final VoidCallback onEditStarted;

  final Function(int id) isUpdateComment;

  final Function(String username) requestFocus;

  CommentTaskWidget(
    this.commentData, {
    super.key,
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
          SizedBox(
            width: 5.w,
          ),
          CustomCircleAvatar(imagePath: widget.commentData.image!, size: 40),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.commentData.username!,
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          formatDateAndTime(
                              date: widget.commentData.createdAt!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
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
                      ),
                    ),
                  ],
                ),
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
                    onTap: () {
                      if (PrefUtils().getUser()!.id! ==
                          widget.commentData.creatorId) {
                        _onEditButtonPressed(widget.commentData.id!);
                      }
                    },
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
        ],
      ),
    );
  }

  _buildShowMyMenuComments(BuildContext context, RelativeRect position) {
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
                    type: 'Comment',
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
