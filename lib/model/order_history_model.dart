class OrderHistoryModel {
  bool? success;
  String? message;
  OrderData? data;

  OrderHistoryModel({this.success, this.message, this.data});

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : OrderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class OrderData {
  int? pageNumber;
  int? count;
  int? totalCount;
  int? totalPages;
  List<Booking>? bookings;
  StatusCounts? statusCounts;

  OrderData({
    this.pageNumber,
    this.count,
    this.totalCount,
    this.totalPages,
    this.bookings,
    this.statusCounts,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    pageNumber: json["pageNumber"],
    count: json["count"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    bookings: json["bookings"] == null
        ? []
        : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
    statusCounts: json["statusCounts"] == null
        ? null
        : StatusCounts.fromJson(json["statusCounts"]),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "count": count,
    "totalCount": totalCount,
    "totalPages": totalPages,
    "bookings": bookings == null
        ? []
        : List<dynamic>.from(bookings!.map((x) => x.toJson())),
    "statusCounts": statusCounts?.toJson(),
  };
}

class Booking {
  String? id;
  String? orderId;
  String? apartmentId;
  String? eventId;

  DateTime? fromDate;
  DateTime? toDate;
  int? daysOfEvent;

  CustomerDetails? customerDetails;

  int? totalAmount;
  int? orderStatus;

  String? createdBy;
  String? updatedBy;

  DateTime? createdAt;
  DateTime? updatedAt;

  //int? v;
  String? orderStatusText;
  String? apartmentName;
  String? eventName;

  Booking({
    this.id,
    this.orderId,
    this.apartmentId,
    this.eventId,
    this.fromDate,
    this.toDate,
    this.daysOfEvent,
    this.customerDetails,
    this.totalAmount,
    this.orderStatus,
    // this.additionalNotes,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.orderStatusText,
    this.apartmentName,
    this.eventName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["_id"],
    orderId: json["orderId"],
    apartmentId: json["apartmentId"],
    eventId: json["eventId"],

    fromDate: json["fromDate"] == null
        ? null
        : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    daysOfEvent: json["daysOfEvent"],

    customerDetails: json["customerDetails"] == null
        ? null
        : CustomerDetails.fromJson(json["customerDetails"]),

    totalAmount: json["totalAmount"],
    orderStatus: json["orderStatus"],
    // additionalNotes: json["additionalNotes"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],

    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    orderStatusText: json["orderStatusText"],
    apartmentName: json["apartmentName"],
    eventName: json["eventName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "orderId": orderId,
    "apartmentId": apartmentId,
    "eventId": eventId,

    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "daysOfEvent": daysOfEvent,

    "customerDetails": customerDetails?.toJson(),
    "totalAmount": totalAmount,
    "orderStatus": orderStatus,

    // "additionalNotes": additionalNotes,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),

    "orderStatusText": orderStatusText,
    "apartmentName": apartmentName,
    "eventName": eventName,
  };
}

class CustomerDetails {
  int? customerType;
  int? gstNumber;
  String? designation;
  String? brandOrCompanyName;
  String? contactPersonName;
  String? contactPersonPhoneNumber;
  String? email;
  String? additionalNotes;
  String? customerId;

  CustomerDetails({
    this.customerType,
    this.gstNumber,
    this.designation,
    this.brandOrCompanyName,
    this.contactPersonName,
    this.contactPersonPhoneNumber,
    this.email,
    this.additionalNotes,
    this.customerId,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        customerType: json["customerType"],
        gstNumber: json["gstNumber"],
        designation: json["designation"],
        brandOrCompanyName: json["brandOrCompanyName"],
        contactPersonName: json["contactPersonName"],
        contactPersonPhoneNumber: json["contactPersonPhoneNumber"],
        email: json["email"],
        additionalNotes: json["additionalNotes"],
        customerId: json["_customerId"],
      );

  Map<String, dynamic> toJson() => {
    "customerType": customerType,
    "gstNumber": gstNumber,
    "designation": designation,
    "brandOrCompanyName": brandOrCompanyName,
    "contactPersonName": contactPersonName,
    "contactPersonPhoneNumber": contactPersonPhoneNumber,
    "email": email,
    "additionalNotes": additionalNotes,
    "_customerId": customerId,
  };
}

/*
class OrderNote {
  String? text;
  List<dynamic>? files;

  OrderNote({this.text, this.files});

  factory OrderNote.fromJson(Map<String, dynamic> json) => OrderNote(
    text: json["text"],
    files: json["files"] == null
        ? []
        : List<dynamic>.from(json["files"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
  };
}
*/

class StatusCounts {
  CloseWon? enquiry;
  CloseWon? needAnalysis;
  CloseWon? proposalPriceQuote;
  CloseWon? negotiationReview;
  CloseWon? closeWon;
  CloseWon? closedLoss;

  StatusCounts({
    this.enquiry,
    this.needAnalysis,
    this.proposalPriceQuote,
    this.negotiationReview,
    this.closeWon,
    this.closedLoss,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
    enquiry: json["Enquiry"] == null
        ? null
        : CloseWon.fromJson(json["Enquiry"]),
    needAnalysis: json["Need Analysis"] == null
        ? null
        : CloseWon.fromJson(json["Need Analysis"]),
    proposalPriceQuote: json["Proposal & Price Quote"] == null
        ? null
        : CloseWon.fromJson(json["Proposal & Price Quote"]),
    negotiationReview: json["Negotiation & Review"] == null
        ? null
        : CloseWon.fromJson(json["Negotiation & Review"]),
    closeWon: json["Close Won"] == null
        ? null
        : CloseWon.fromJson(json["Close Won"]),
    closedLoss: json["Closed Loss"] == null
        ? null
        : CloseWon.fromJson(json["Closed Loss"]),
  );

  Map<String, dynamic> toJson() => {
    "Enquiry": enquiry?.toJson(),
    "Need Analysis": needAnalysis?.toJson(),
    "Proposal & Price Quote": proposalPriceQuote?.toJson(),
    "Negotiation & Review": negotiationReview?.toJson(),
    "Close Won": closeWon?.toJson(),
    "Closed Loss": closedLoss?.toJson(),
  };
}

class CloseWon {
  int? count;
  int? totalAmount;

  CloseWon({this.count, this.totalAmount});

  factory CloseWon.fromJson(Map<String, dynamic> json) =>
      CloseWon(count: json["count"], totalAmount: json["totalAmount"]);

  Map<String, dynamic> toJson() => {"count": count, "totalAmount": totalAmount};
}
