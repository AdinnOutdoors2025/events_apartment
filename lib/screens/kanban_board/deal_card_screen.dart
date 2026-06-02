import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../kanban_board_screen.dart';

class DealCard extends StatelessWidget {
  final KanbanDeal deal;
  final KanbanStage stage;
  final VoidCallback onTap;
  final bool isDragging;
  final ValueChanged<Offset>? onDragUpdate;

  const DealCard({
    super.key,
    required this.deal,
    required this.stage,
    required this.onTap,
    this.isDragging = false,
    this.onDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<KanbanDeal>(
      data: deal,
      onDragUpdate: (details) {
        onDragUpdate?.call(details.globalPosition);
      },

      feedback: SizedBox(width: 280, child: _cardContent()),

      childWhenDragging: Opacity(opacity: 0.3, child: _cardContent()),

      child: _cardContent(),
    );
  }

  Widget _cardContent() {
    return Material(
      color: Colors.white,
      elevation: isDragging ? 12 : 0,
      shadowColor: Colors.black.withOpacity(0.12),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xffE5E7EB)),
            boxShadow: [
              if (!isDragging)
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      deal.orderId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                deal.companyName,
                style: const TextStyle(
                  color: Color(0xff374151),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.currency_rupee_rounded, size: 14),
                  Text(
                    deal.value.replaceAll("₹", ""),
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12),
                  const SizedBox(width: 5),
                  Text(
                    deal.createdAt,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 12,
                    child: Text(
                      (deal.ownerName.isNotEmpty
                              ? deal.ownerName.substring(0, 1)
                              : "A")
                          .toUpperCase(),
                      style: TextStyle(
                        color: stage.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
