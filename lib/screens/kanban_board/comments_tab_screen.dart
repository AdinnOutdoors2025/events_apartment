import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/snackbar.dart';
import '../../viewmodel/order_viewmodel.dart';
import '../kanban_board_screen.dart';

class CommentsTab extends ConsumerWidget {
  final TextEditingController controller;
  final KanbanDeal deal;

  const CommentsTab({super.key, required this.controller, required this.deal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Comment",
                style: TextStyle(
                  color: Color(0xff111827),
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: controller,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Type your comment here...",
                  hintStyle: const TextStyle(
                    color: Color(0xff9CA3AF),
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffD1D5DB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffE30613)),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: const Color(0xffD1D5DB)),
                    ),
                    child: const Icon(
                      Icons.attach_file_rounded,
                      color: Color(0xff4B5563),
                    ),
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: () async {
                      if (controller.text.trim().isEmpty) {
                        AppToast.showError("Please enter comment");
                        return;
                      }
                      await ref
                          .read(orderViewModelProvider.notifier)
                          .updateOrderStatus(
                            orderId: deal.id,
                            status: int.parse(deal.stageId), // current status
                            additionalNotes: controller.text.trim(),
                          );

                      controller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE30613),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      "Post Comment",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Builder(
            builder: (context) {
                final commentHistory = deal.orderHistory.where((history) {
                return history.additionalNotes?.trim().isNotEmpty ?? false;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Comments History",
                    style: TextStyle(
                      color: Color(0xff111827),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (commentHistory.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "No comments found",
                          style: TextStyle(
                            color: Color(0xff6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  ...commentHistory.map((history) {
                    final initials = history.changedBy?.isNotEmpty == true
                        ? history.changedBy!
                              .split(" ")
                              .take(2)
                              .map((e) => e[0])
                              .join()
                              .toUpperCase()
                        : "NA";

                    return CommentItem(
                      initials: initials,
                      name: history.changedBy ?? "-",
                      time: history.changedAt ?? "-",
                      comment: history.additionalNotes ?? "",
                      color: const Color(0xffDBEAFE),
                      textColor: const Color(0xff2563EB),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  final String initials;
  final String name;
  final String time;
  final String comment;
  final Color color;
  final Color textColor;

  const CommentItem({
    super.key,
    required this.initials,
    required this.name,
    required this.time,
    required this.comment,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 14, top: 4),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffE5E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Text(
              initials,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w900),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  comment,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xffE5E7EB)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.035),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
