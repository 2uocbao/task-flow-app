import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/comment/comment_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';

class CommentTaskWidget extends StatefulWidget {
  final CommentData commentData;

  final String taskId;

  final Function(CommentData comment) requestFocusBox;

  const CommentTaskWidget({
    super.key,
    required this.commentData,
    required this.taskId,
    required this.requestFocusBox,
  });

  @override
  State<CommentTaskWidget> createState() => CommentTaskWidgetState();
}

class CommentTaskWidgetState extends State<CommentTaskWidget> {
  late bool isEdit = false;
  final logger = Logger();

  String makeTextController(String contentDisplay) {
    final pattern = RegExp(r'@\[\_\_(.*?)\_\_\]\(\_\_(.*?)\_\_\)');
    final matches = pattern.allMatches(contentDisplay);
    String? display = contentDisplay;
    for (var element in matches) {
      display = display!.replaceFirst(pattern, '@${element.group(2)!}');
    }
    return display!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 0.5.h,
          color: Theme.of(context).highlightColor,
        ),
        Row(
          children: [
            SizedBox(width: 5.w),
            CustomCircleAvatar(imagePath: widget.commentData.image!, size: 35),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.commentData.username!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    formatDateAndTime(
                      date: widget.commentData.createdAt!,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  HighlightedText(
                      text: makeTextController(widget.commentData.text!))
                ],
              ),
            ),
            isEdit
                ? SizedBox()
                : Transform.rotate(
                    angle: 90 * 3.1415926535 / 180,
                    child: CustomIconButton(
                      onTap: onTap,
                      child: Icon(
                        Icons.keyboard_control_sharp,
                        size: 25.sp,
                      ),
                    ),
                  ),
          ],
        )
      ],
    );
  }

  void onTap() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition =
        button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;
    final Size overlaySize = overlay.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx + buttonSize.width,
      buttonPosition.dy + 30.h,
      overlaySize.width - (buttonPosition.dx + buttonSize.width),
      overlaySize.height - (buttonPosition.dy + buttonSize.height),
    );
    if (widget.commentData.creatorId == PrefUtils().getUser()!.id) {
      _buildShowMyMenuComments(context, position);
    } else {
      showMenu(
        context: context,
        position: position,
        items: [
          PopupMenuItem(
            child: Text(
              "bt_reply".tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              // widget.requestFocus(widget.commentData.creatorId!);
            },
          ),
        ],
      );
    }
  }

  Future _buildShowMyMenuComments(BuildContext context, RelativeRect position) {
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
            widget.requestFocusBox(widget.commentData);
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
                    type: 'COMMENT',
                    title: 'lbl_title_delete_comment'.tr(),
                    subTitle: 'lbl_subtitle_delete_comment'.tr(),
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

class HighlightedText extends StatelessWidget {
  final String text;

  const HighlightedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');

    return Text.rich(
      TextSpan(
        children: words.map((word) {
          final isMention = word.startsWith('@');
          return TextSpan(
            text: "$word ",
            style: TextStyle(
              color: isMention
                  ? Colors.blue
                  : Theme.of(context)
                      .primaryTextTheme
                      .bodySmall!
                      .backgroundColor,
              fontWeight: isMention ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }
}
