import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kanban_board_screen.dart';

class PipelineHistoryTab extends StatelessWidget {
  final KanbanDeal deal;

  const PipelineHistoryTab({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final timeline = <Map<String, dynamic>>[];

    timeline.add({
      "title": "Enquiry",
      "date": deal.createdAt,
      "user": deal.createdBy,
      "created": true,
    });

    for (final history in deal.orderHistory) {
      timeline.add({
        "title": history.toStatusText,
        "date": history.changedAt,
        "user": history.changedBy,
        "created": false,
      });
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timeline.length,
      itemBuilder: (context, index) {
        final item = timeline[index];

        return TimelineItem(
          icon: index == timeline.length - 1 ? Icons.sync : Icons.check_circle,
          iconColor: index == timeline.length - 1
              ? Colors.orange
              : Colors.green,

          title: item["title"],

          titleBg: (index == timeline.length - 1 ? Colors.orange : Colors.green)
              .withOpacity(.12),

          titleColor: index == timeline.length - 1
              ? Colors.orange
              : Colors.green,

          date: item["date"] ?? "",

          subtitle: item["created"]
              ? "Created by ${item["user"]}"
              : "Moved by ${item["user"]}",

          showLine: index != timeline.length - 1,
        );
      },
    );
  }
}

class TimelineItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleBg;
  final Color titleColor;
  final String date;
  final String subtitle;
  final bool showLine;

  const TimelineItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleBg,
    required this.titleColor,
    required this.date,
    required this.subtitle,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),

                if (showLine)
                  Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: const Color(0xffD1D5DB),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 18),
              decoration: showLine
                  ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffE5E7EB)),
                ),
              )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: titleBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  if (date.isNotEmpty)
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}