import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/order_details_model.dart';
import '../kanban_board_screen.dart';

class OverviewTab extends StatelessWidget {
  final KanbanDeal deal;
  final OrderDetails details;

  const OverviewTab({super.key, required this.deal, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailsSection(
          icon: Icons.apartment_rounded,
          iconColor: const Color(0xff2563EB),
          iconBgColor: const Color(0xffEAF2FF),
          title: "Apartment Details",
          rows: [
            DetailRow(
              "Apartment Name",
              details.apartmentDetails?.apartmentName ?? "-",
            ),
            DetailRow("Location", details.apartmentDetails?.location ?? "-"),
            //   DetailRow("Type", deal.apartmentType),
            DetailRow("Total Units", details.sqfet.toString()),
          ],
        ),

        const SizedBox(height: 12),

        DetailsSection(
          icon: Icons.calendar_month_outlined,
          iconColor: const Color(0xffF97316),
          iconBgColor: const Color(0xffFFF0E5),
          title: "Event Details",
          rows: [
            DetailRow("Event Type", details.eventDetails?.eventName ?? "-"),
            DetailRow("Event Date", details.fromDate == null && details.toDate == null
                ? "-"
                : "${formatDate(details.fromDate)} - ${formatDate(details.toDate)}"),
            //  DetailRow("Time", deal.eventTime),
            DetailRow("Expected Guests", details.promoterCount.toString()),
            //  DetailRow("Setup Style", deal.setupStyle),
          ],
        ),

        const SizedBox(height: 12),

        DetailsSection(
          icon: Icons.person_outline_rounded,
          iconColor: const Color(0xff16A34A),
          iconBgColor: const Color(0xffEAFBEF),
          title: "Customer Details",
          rows: [
            DetailRow("Contact Person", details.customerDetails?.contactPersonName ?? "-"),
            DetailRow("Phone", details.customerDetails!.contactPersonPhoneNumber ?? "-"),
            DetailRow("Email", details.customerDetails!.email ?? "-"),
            DetailRow("Company", details.customerDetails!.brandOrCompanyName ?? "-"),
          ],
        ),
      ],
    );
  }
}

class DetailsSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final List<DetailRow> rows;

  const DetailsSection({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff111827),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...rows.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 42,
                    child: Text(
                      row.label,
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 58,
                    child: Text(
                      row.value.isEmpty ? "-" : row.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
