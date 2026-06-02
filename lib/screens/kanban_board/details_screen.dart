import 'dart:ui';
import 'package:apartment_project/screens/kanban_board/pipeline_history_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/snackbar.dart';
import '../../viewmodel/order_viewmodel.dart';
import '../kanban_board_screen.dart';
import 'comments_tab_screen.dart';
import 'overview_tab_screen.dart';

class DealDetailsSheet extends StatefulWidget {
  final KanbanDeal deal;
  final List<KanbanStage> stages;
  final Future<void> Function(KanbanDeal, String) onMoveStage;

  const DealDetailsSheet({
    super.key,
    required this.deal,
    required this.stages,
    required this.onMoveStage,
  });

  @override
  State<DealDetailsSheet> createState() => _DealDetailsSheetState();
}

class _DealDetailsSheetState extends State<DealDetailsSheet> {
  final TextEditingController commentController = TextEditingController();
  int selectedTab = 0;

  KanbanStage get currentStage {
    return widget.stages.firstWhere((stage) => stage.id == widget.deal.stageId);
  }

  late final currentStageIndex = int.parse(widget.deal.stageId) - 1;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _openMoveStageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xffD1D5DB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    const Text(
                      "Move Deal To",
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ...widget.stages.map((stage) {
                  final isCurrent = stage.id == widget.deal.stageId;

                  return GestureDetector(
                    onTap: isCurrent
                        ? null
                        : () {
                            widget.onMoveStage(widget.deal, stage.id);
                            Navigator.pop(sheetContext);
                            Navigator.pop(context);
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrent
                              ? stage.color.withOpacity(0.45)
                              : const Color(0xffE5E7EB),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 7, backgroundColor: stage.color),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              stage.title,
                              style: const TextStyle(
                                color: Color(0xff111827),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          if (isCurrent)
                            Text(
                              "Current",
                              style: TextStyle(
                                color: stage.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color(0xff9CA3AF),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _selectedTabBody() {
    if (selectedTab == 0) {
      return OverviewTab(deal: widget.deal);
    }

    if (selectedTab == 1) {
      return CommentsTab(controller: commentController, deal: widget.deal);
    }

    return PipelineHistoryTab(deal: widget.deal);
  }

  @override
  Widget build(BuildContext context) {
    final stage = currentStage;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Container(
                height: 4,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xffD1D5DB),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xff4B5563),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Deal Details",
                          style: TextStyle(
                            color: Color(0xff111827),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Color(0xff4B5563),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  children: [
                    _TopDealCard(deal: widget.deal, stage: stage),

                    const SizedBox(height: 16),

                    _TabsHeader(
                      selectedIndex: selectedTab,
                      onChanged: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    _selectedTabBody(),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              _BottomActions(
                onEdit: () {},
                onMoveStage: () => _openMoveStageSheet(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopDealCard extends StatelessWidget {
  final KanbanDeal deal;
  final KanbanStage stage;

  const _TopDealCard({required this.deal, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              color: const Color(0xffEF1D1D),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.companyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  deal.apartmentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff2196F3),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    stage.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
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

class _TabsHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _TabsHeader({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Overview", "Comments", "Pipeline History"];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffE5E7EB))),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xffE30613)
                          : const Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 3,
                    width: isSelected ? 90 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xffE30613),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onMoveStage;

  const _BottomActions({required this.onEdit, required this.onMoveStage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text("Edit"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xffE30613),
                  side: const BorderSide(color: Color(0xffE30613), width: 1.4),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: onMoveStage,
                icon: const Icon(Icons.swap_horiz_rounded, size: 22),
                label: const Text("Move Stage"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE30613),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0xffE30613).withOpacity(0.25),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
