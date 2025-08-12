import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';
import 'package:taskflow/src/data/model/task/task_data.dart';

// ignore: must_be_immutable
class TaskItemWidget extends StatelessWidget {
  final TaskData _taskData;

  VoidCallback onTapToTask;

  TaskItemWidget(this._taskData, {super.key, required this.onTapToTask});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapToTask.call();
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.h, bottom: 5.h, right: 10.h),
<<<<<<< HEAD
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.w,
=======
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadiusStyle.circleBorder10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
<<<<<<< HEAD
            SizedBox(
              child: Text(
                _taskData.title!,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
=======
            Padding(
              padding: EdgeInsets.only(right: 20.w, left: 5.w),
              child: SizedBox(
                child: Text(
                  _taskData.title!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              child: Text(
<<<<<<< HEAD
                _taskData.priority!.tr(),
=======
                _taskData.status!.tr(),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(date: _taskData.dueAt!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 15.sp,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      _taskData.reportCount!.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 15.sp,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      _taskData.commentCount!.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
