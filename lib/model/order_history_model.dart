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

  // ApartmentDetails? apartmentDetails;
  // EventDetails? eventDetails;
  DateTime? fromDate;
  DateTime? toDate;
  int? daysOfEvent;

  // List<DailySchedule>? dailySchedule;
  // int? promoterRequired;
  // int? promoterCount;
  // List<Promoter>? promoters;
  CustomerDetails? customerDetails;

  // int? discountType;
  // int? discountPercentage;
  // int? finalAmount;
  // int? sqfet;
  // int? apartmentAmount;
  //int? sqfetAmount;
  // int? eventAmount;
  // int? promoterTotal;
  // int? subTotal;
  // int? discountAmount;
  // int? taxableAmount;
  // int? gstAmount;
  int? totalAmount;
  int? orderStatus;

  // String? additionalNotes;
  // String? closeLossReason;
  //  dynamic poDocument;
  //Document? document;
  //Document? voiceNote;
  //OrderNote? orderNote;
  //bool? isMailSent;
  //dynamic mailSentAt;
  String? createdBy;
  String? updatedBy;

  //List<OrderHistory>? orderHistory;
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

/*
class OrderHistory {
  final int? fromStatus;
  final String? fromStatusText;
  final int? toStatus;
  final String? toStatusText;
  final String? changedBy;
  final String? changedAt;
  final String? additionalNotes;
  final DocumentModel? poDocument;
  final DocumentModel? statusDocument;
  final DocumentModel? voiceDocument;

  OrderHistory({
    this.fromStatus,
    this.fromStatusText,
    this.toStatus,
    this.toStatusText,
    this.changedBy,
    this.changedAt,
    this.additionalNotes,
    this.poDocument,
    this.statusDocument,
    this.voiceDocument,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      fromStatus: json['fromStatus'],
      fromStatusText: json['fromStatusText'],
      toStatus: json['toStatus'],
      toStatusText: json['toStatusText'],
      changedBy: json['changedBy'],
      changedAt: json['changedAt'],
      additionalNotes: json['additionalNotes'],
      poDocument: json['poDocument'] != null
          ? DocumentModel.fromJson(json['poDocument'])
          : null,
      statusDocument: json['statusDocument'] != null
          ? DocumentModel.fromJson(json['statusDocument'])
          : null,
      voiceDocument: json['voiceDocument'] != null
          ? DocumentModel.fromJson(json['voiceDocument'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromStatus': fromStatus,
      'fromStatusText': fromStatusText,
      'toStatus': toStatus,
      'toStatusText': toStatusText,
      'changedBy': changedBy,
      'changedAt': changedAt,
      'additionalNotes': additionalNotes,
      'poDocument': poDocument?.toJson(),
      'statusDocument': statusDocument?.toJson(),
      'voiceDocument': voiceDocument?.toJson(),
    };
  }
}
*/

/*class DocumentModel {
  final String? uploadedAt;

  DocumentModel({this.uploadedAt});

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(uploadedAt: json['uploadedAt']);
  }

  Map<String, dynamic> toJson() {
    return {'uploadedAt': uploadedAt};
  }
}*/

/*
class ApartmentDetails {
  String? id;
  String? apartmentName;
  String? city;
  String? location;
  int? perDayRent;
  String? contactPersonPhone;

  ApartmentDetails({
    this.id,
    this.apartmentName,
    this.city,
    this.location,
    this.perDayRent,
    this.contactPersonPhone,
  });

  factory ApartmentDetails.fromJson(Map<String, dynamic> json) =>
      ApartmentDetails(
        id: json["_id"],
        apartmentName: json["apartmentName"],
        city: json["city"],
        location: json["location"],
        perDayRent: json["perDayRent"],
        contactPersonPhone: json["contactPersonPhone"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "apartmentName": apartmentName,
    "city": city,
    "location": location,
    "perDayRent": perDayRent,
    "contactPersonPhone": contactPersonPhone,
  };
}
*/

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
class DailySchedule {
  int? days;
  String? fromTime;
  String? toTime;
  String? notes;

  DailySchedule({this.days, this.fromTime, this.toTime, this.notes});

  factory DailySchedule.fromJson(Map<String, dynamic> json) => DailySchedule(
    days: json["days"],
    fromTime: json["fromTime"],
    toTime: json["toTime"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "days": days,
    "fromTime": fromTime,
    "toTime": toTime,
    "notes": notes,
  };
}
*/

/*
class Document {
  DateTime? uploadedAt;

  Document({this.uploadedAt});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    uploadedAt: json["uploadedAt"] == null
        ? null
        : DateTime.parse(json["uploadedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "uploadedAt": uploadedAt?.toIso8601String(),
  };
}
*/

/*
class EventDetails {
  String? id;
  String? eventName;
  int? amount;

  EventDetails({this.id, this.eventName, this.amount});

  factory EventDetails.fromJson(Map<String, dynamic> json) => EventDetails(
    id: json["_id"],
    eventName: json["eventName"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "eventName": eventName,
    "amount": amount,
  };
}
*/

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

/*
class Promoter {
  String? promoterGender;
  int? promoterPerDayCharge;
  List<String>? promoterLanguage;
  List<String>? promoterLookAndAppearance;
  int? promoterAmount;
  String? promoterId;

  Promoter({
    this.promoterGender,
    this.promoterPerDayCharge,
    this.promoterLanguage,
    this.promoterLookAndAppearance,
    this.promoterAmount,
    this.promoterId,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) => Promoter(
    promoterGender: json["promoterGender"],
    promoterPerDayCharge: json["promoterPerDayCharge"],
    promoterLanguage: json["promoterLanguage"] == null
        ? []
        : List<String>.from(json["promoterLanguage"]!.map((x) => x)),
    promoterLookAndAppearance: json["promoterLookAndAppearance"] == null
        ? []
        : List<String>.from(json["promoterLookAndAppearance"]!.map((x) => x)),
    promoterAmount: json["promoterAmount"],
    promoterId: json["_promoterId"],
  );

  Map<String, dynamic> toJson() => {
    "promoterGender": promoterGender,
    "promoterPerDayCharge": promoterPerDayCharge,
    "promoterLanguage": promoterLanguage == null
        ? []
        : List<dynamic>.from(promoterLanguage!.map((x) => x)),
    "promoterLookAndAppearance": promoterLookAndAppearance == null
        ? []
        : List<dynamic>.from(promoterLookAndAppearance!.map((x) => x)),
    "promoterAmount": promoterAmount,
    "_promoterId": promoterId,
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
