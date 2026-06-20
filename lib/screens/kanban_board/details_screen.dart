import 'dart:ui';
import 'package:apartment_project/screens/kanban_board/pipeline_history_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/order_details_model.dart';
import '../../utils/snackbar.dart';
import '../../viewmodel/order_details_viewmodel.dart';
import '../../viewmodel/order_viewmodel.dart';
import '../kanban_board_screen.dart';
import 'comments_tab_screen.dart';
import 'overview_tab_screen.dart';

class DealDetailsSheet extends ConsumerStatefulWidget {
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
  ConsumerState<DealDetailsSheet> createState() => _DealDetailsSheetState();
}

class _DealDetailsSheetState extends ConsumerState<DealDetailsSheet> {
  final TextEditingController commentController = TextEditingController();
  int selectedTab = 0;
  late String _currentStageId;
  bool _isMovingStage = false;

  /*KanbanStage get currentStage {
    return widget.stages.firstWhere((stage) => stage.id == widget.deal.stageId);
  }*/
  KanbanStage get currentStage {
    return widget.stages.firstWhere(
      (stage) => stage.id == _currentStageId,
      orElse: () => widget.stages.first,
    );
  }

  KanbanStage? get nextStage {
    final currentIndex = widget.stages.indexWhere(
      (stage) => stage.id == _currentStageId,
    );

    if (currentIndex == -1) return null;
    if (currentIndex >= widget.stages.length - 1) return null;

    return widget.stages[currentIndex + 1];
  }

  //late final currentStageIndex = int.parse(widget.deal.stageId) - 1;

  @override
  void initState() {
    super.initState();
    _currentStageId = widget.deal.stageId;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _moveToNextStage() async {
    final next = nextStage;

    if (next == null) {
      AppToast.showError("Already in final stage");
      return;
    }

    setState(() => _isMovingStage = true);

    try {
      await ref
          .read(orderViewModelProvider.notifier)
          .updateOrderStatus(
            orderId: widget.deal.id,
            status: int.parse(next.id),
          );

      setState(() {
        _currentStageId = next.id;
      });

      await ref
          .read(orderDetailsProvider(widget.deal.id).notifier)
          .getOrderDetails(widget.deal.id);

      AppToast.showSuccess("Moved to ${next.title}");
    } catch (e) {
      AppToast.showError("Unable to move stage");
    } finally {
      if (mounted) {
        setState(() => _isMovingStage = false);
      }
    }
  }

  Widget _selectedTabBody(OrderDetails details) {
    if (selectedTab == 0) {
      return OverviewTab(deal: widget.deal, details: details);
    }

    if (selectedTab == 1) {
      return CommentsTab(
        controller: commentController,
        deal: widget.deal,
        details: details,
        stage: currentStage,
      );
    }

    return PipelineHistoryTab(deal: widget.deal, details: details);
  }

  @override
  Widget build(BuildContext context) {
    final stage = currentStage;
    final detailsState = ref.watch(orderDetailsProvider(widget.deal.id));
    final details = detailsState.details;
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        if (detailsState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (details == null) {
          return const Center(child: Text("No data found"));
        }
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

              SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xff4B5563),
                        ),
                      ),
                    ),

                    const Text(
                      "Order Details",
                      style: TextStyle(
                        color: Color(0xff111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
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
                    _TopDealCard(
                      deal: widget.deal,
                      stage: stage,
                      details: details,
                      nextStage: nextStage,
                      isMovingStage: _isMovingStage,
                      onMoveNextStage: _moveToNextStage,
                    ),

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

                    _selectedTabBody(details),

                    const SizedBox(height: 10),
                  ],
                ),
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
  final KanbanStage? nextStage;
  final OrderDetails details;
  final bool isMovingStage;
  final VoidCallback onMoveNextStage;

  const _TopDealCard({
    required this.deal,
    required this.stage,
    required this.details,
    required this.nextStage,
    required this.isMovingStage,
    required this.onMoveNextStage,
  });

  @override
  Widget build(BuildContext context) {
    final hasNextStage = nextStage != null;
    final currentStatus = details.orderStatus ?? int.tryParse(stage.id) ?? 1;

    final isEnquiryStage = currentStatus == 1;

    final isUpdated =
        details.createdAt != null &&
        details.updatedAt != null &&
        !details.createdAt!.isAtSameMomentAs(details.updatedAt!);

    final showUpdatedOn = !isEnquiryStage && isUpdated;

    final dateLabel = showUpdatedOn ? "Updated On" : "Created On";

    final dateValue = showUpdatedOn ? details.updatedAt : details.createdAt;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xffF71920),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(width: 14),

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
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      details.apartmentDetails?.apartmentName ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFE4E4),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        stage.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xffE30613),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order ID",
                    style: TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    details.orderId ?? "-",
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    dateLabel,
                    style: TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatDate(dateValue),
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (hasNextStage) ...[
            const SizedBox(height: 16),

            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xffE5E7EB),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 43,
              child: ElevatedButton(
                onPressed: isMovingStage ? null : onMoveNextStage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE30613),
                  disabledBackgroundColor: const Color(
                    0xffE30613,
                  ).withOpacity(0.55),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: isMovingStage
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        children: [
                          const Spacer(),

                          const Text(
                            "Move to ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          Text(
                            nextStage!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ),
            ),
          ],
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
