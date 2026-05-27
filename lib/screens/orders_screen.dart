import 'package:apartment_project/controller/order_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../model/order_history_model.dart';
import '../theme/app_colors.dart';
import '../utils/helpers.dart';
import '../widgets/custom_searchfilter.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "All Orders",
          style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w500),
        ),
      ),

      body: Column(
        children: [
          CustomSearchFilter(
            hintText: "Search...",
            showCalendar: true,
            showFilter: true,
            filterItems: [
              "All",
              "Enquiry",
              "Need analysis",
              "Proposal & Price Quote",
              "Negotiation & Review",
              "Close Won",
              "Closed loss",
            ],

            onSearchChanged: (value) {},

            onDateTap: () async {
              DateTimeRange? pickedDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                initialDateRange: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(const Duration(days: 7)),
                ),
              );

              if (pickedDate != null) {
                print(pickedDate.start);
                print(pickedDate.end);
              }
            },

            onFilterChanged: (value) {},
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Obx(() {
              /// LOADING
              if (controller.isLoading.value /*&& controller.orderList.isEmpty*/) {
                return const Center(child: CircularProgressIndicator());
              }

              /// EMPTY
              if (controller.orderList.isEmpty) {
                return const Center(child: Text("No Orders Found"));
              }

              return RefreshIndicator(
                onRefresh: controller.refreshOrders,
                child: ListView.separated(
                  controller: controller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(14),

                  itemCount:
                      controller.orderList.length +
                      (controller.isPaginationLoading.value ? 1 : 0),

                  separatorBuilder: (_, __) => const SizedBox(height: 12),

                  itemBuilder: (context, index) {
                    /// PAGINATION LOADER
                    if (index == controller.orderList.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final booking = controller.orderList[index];

                    return ApartmentOrderCard(booking: booking);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ApartmentOrderCard extends StatelessWidget {
  final Booking booking;

  const ApartmentOrderCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.orderStatus);
    final statusBgColor = _getStatusBgColor(booking.orderStatus);
    final statusText = _getStatusText(booking.orderStatus);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              order.imageUrl,
              height: 84,
              width: 84,
              fit: BoxFit.cover,
            ),
          ),*/
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.18)),
            ),
            child: Icon(Icons.apartment_rounded, size: 40, color: statusColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.orderId ?? "",
                  style: const TextStyle(
                    color: Color(0xff0B4F9C),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  booking.customerDetails?.brandOrCompanyName ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  booking.apartmentDetails?.apartmentName ??
                      booking.apartmentName ??
                      "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff4B5563),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xff64748B),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking.apartmentDetails?.location ?? "-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff334155),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: Color(0xff64748B),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        //  "${Helpers().formatDate(booking.fromDate.toString())}-${Helpers().formatDate(booking.toDate.toString())}",
                        Helpers().formatDateRange(
                          booking.fromDate.toString(),
                          booking.toDate.toString(),
                        ),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff334155),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          SizedBox(
            width: 88,
            height: 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  "${booking.daysOfApartment ?? 0} Days",
                  style: const TextStyle(
                    color: Color(0xff334155),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 13),

                Text(
                  "₹${booking.totalAmount ?? 0}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(int? status) {
    switch (status) {
      case 1:
        return "Enquiry";
      case 2:
        return "Need Analysis";
      case 3:
        return "Proposal & Price Quote";
      case 4:
        return "Negotiation & Review";
      case 5:
        return "Close Won";
      case 6:
        return "Closed Loss";
      default:
        return "All";
    }
  }

  /*Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return const Color(0xff16A34A);
      case OrderStatus.pending:
        return const Color(0xffF97316);
      case OrderStatus.rejected:
        return const Color(0xffEF4444);
    }
  }*/
  Color _getStatusColor(int? status) {
    switch (status) {
      case 1:
        return const Color(0xff6B7280);
      case 2:
        return const Color(0xff2563EB);
      case 3:
        return const Color(0xff7C3AED);
      case 4:
        return const Color(0xffEA580C);
      case 5:
        return const Color(0xff16A34A);
      case 6:
        return const Color(0xffDC2626);
      default:
        return Colors.grey;
    }
  }

  /*Color _getStatusBgColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.approved:
        return const Color(0xffEAFBF1);
      case OrderStatus.pending:
        return const Color(0xffFFF3E7);
      case OrderStatus.rejected:
        return const Color(0xffFEECEC);
    }
  }*/
  Color _getStatusBgColor(int? status) {
    switch (status) {
      case 1:
        return const Color(0xffF3F4F6);
      case 2:
        return const Color(0xffDBEAFE);
      case 3:
        return const Color(0xffEDE9FE);
      case 4:
        return const Color(0xffFFEDD5);
      case 5:
        return const Color(0xffDCFCE7);
      case 6:
        return const Color(0xffFEE2E2);
      default:
        return Colors.grey.shade100;
    }
  }
}

class ApartmentOrder {
  final String orderId;
  final String companyName;
  final String apartmentName;
  final String location;
  final String dateRange;
  final String days;
  final String amount;
  final OrderStatus status;

  ApartmentOrder({
    required this.orderId,
    required this.companyName,
    required this.apartmentName,
    required this.location,
    required this.dateRange,
    required this.days,
    required this.amount,
    required this.status,
  });
}

enum OrderStatus {
  all,
  enquiry,
  needAnalysis,
  proposalPriceQuote,
  negotiationReview,
  closeWon,
  closedLoss,
}

OrderStatus getOrderStatus(int? status) {
  switch (status) {
    case 1:
      return OrderStatus.enquiry;
    case 2:
      return OrderStatus.needAnalysis;
    case 3:
      return OrderStatus.proposalPriceQuote;
    case 4:
      return OrderStatus.negotiationReview;
    case 5:
      return OrderStatus.closeWon;
    case 6:
      return OrderStatus.closedLoss;
    default:
      return OrderStatus.all;
  }
}
