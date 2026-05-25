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

  OrderData({
    this.pageNumber,
    this.count,
    this.totalCount,
    this.totalPages,
    this.bookings,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    pageNumber: json["pageNumber"],
    count: json["count"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    bookings: json["bookings"] == null
        ? []
        : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "count": count,
    "totalCount": totalCount,
    "totalPages": totalPages,
    "bookings": bookings == null
        ? []
        : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class Booking {
  String? id;
  String? orderId;
  String? apartmentId;
  String? eventId;
  ApartmentDetails? apartmentDetails;
  EventDetails? eventDetails;
  DateTime? fromDate;
  DateTime? toDate;
  int? daysOfEvent;
  int? daysOfApartment;
  int? promoterRequired;
  int? promoterCount;
  List<Promoter>? promoters;
  CustomerDetails? customerDetails;
  int? discountType;
  int? discountPercentage;
  dynamic negotiationAmount;
  int? sqfet;
  int? apartmentAmount;
  int? sqfetAmount;
  int? eventAmount;
  int? promoterTotal;
  int? subTotal;
  int? discountAmount;
  int? taxableAmount;
  int? gstAmount;
  int? totalAmount;
  int? orderStatus;
  String? additionalNotes;
  String? closeLossReason;
  dynamic poDocument;
  OrderNote? orderNote;
  List<OrderHistory>? orderHistory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? apartmentName;
  String? eventName;

  Booking({
    this.id,
    this.orderId,
    this.apartmentId,
    this.eventId,
    this.apartmentDetails,
    this.eventDetails,
    this.fromDate,
    this.toDate,
    this.daysOfEvent,
    this.daysOfApartment,
    this.promoterRequired,
    this.promoterCount,
    this.promoters,
    this.customerDetails,
    this.discountType,
    this.discountPercentage,
    this.negotiationAmount,
    this.sqfet,
    this.apartmentAmount,
    this.sqfetAmount,
    this.eventAmount,
    this.promoterTotal,
    this.subTotal,
    this.discountAmount,
    this.taxableAmount,
    this.gstAmount,
    this.totalAmount,
    this.orderStatus,
    this.additionalNotes,
    this.closeLossReason,
    this.poDocument,
    this.orderNote,
    this.orderHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.apartmentName,
    this.eventName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["_id"],
    orderId: json["orderId"],
    apartmentId: json["apartmentId"],
    eventId: json["eventId"],
    apartmentDetails: json["apartmentDetails"] == null
        ? null
        : ApartmentDetails.fromJson(json["apartmentDetails"]),
    eventDetails: json["eventDetails"] == null
        ? null
        : EventDetails.fromJson(json["eventDetails"]),
    fromDate: json["fromDate"] == null
        ? null
        : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    daysOfEvent: json["daysOfEvent"],
    daysOfApartment: json["daysOfApartment"],
    promoterRequired: json["promoterRequired"],
    promoterCount: json["promoterCount"],
    promoters: json["promoters"] == null
        ? []
        : List<Promoter>.from(
            json["promoters"]!.map((x) => Promoter.fromJson(x)),
          ),
    customerDetails: json["customerDetails"] == null
        ? null
        : CustomerDetails.fromJson(json["customerDetails"]),
    discountType: json["discountType"],
    discountPercentage: json["discountPercentage"],
    negotiationAmount: json["negotiationAmount"],
    sqfet: json["sqfet"],
    apartmentAmount: json["apartmentAmount"],
    sqfetAmount: json["sqfetAmount"],
    eventAmount: json["eventAmount"],
    promoterTotal: json["promoterTotal"],
    subTotal: json["subTotal"],
    discountAmount: json["discountAmount"],
    taxableAmount: json["taxableAmount"],
    gstAmount: json["gstAmount"],
    totalAmount: json["totalAmount"],
    orderStatus: json["orderStatus"],
    additionalNotes: json["additionalNotes"],
    closeLossReason: json["closeLossReason"],
    poDocument: json["poDocument"],
    orderNote: json["orderNote"] == null
        ? null
        : OrderNote.fromJson(json["orderNote"]),
    orderHistory: json["orderHistory"] == null
        ? []
        : List<OrderHistory>.from(
            json["orderHistory"]!.map((x) => OrderHistory.fromJson(x)),
          ),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    apartmentName: json["apartmentName"],
    eventName: json["eventName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "orderId": orderId,
    "apartmentId": apartmentId,
    "eventId": eventId,
    "apartmentDetails": apartmentDetails?.toJson(),
    "eventDetails": eventDetails?.toJson(),
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "daysOfEvent": daysOfEvent,
    "daysOfApartment": daysOfApartment,
    "promoterRequired": promoterRequired,
    "promoterCount": promoterCount,
    "promoters": promoters == null
        ? []
        : List<dynamic>.from(promoters!.map((x) => x.toJson())),
    "customerDetails": customerDetails?.toJson(),
    "discountType": discountType,
    "discountPercentage": discountPercentage,
    "negotiationAmount": negotiationAmount,
    "sqfet": sqfet,
    "apartmentAmount": apartmentAmount,
    "sqfetAmount": sqfetAmount,
    "eventAmount": eventAmount,
    "promoterTotal": promoterTotal,
    "subTotal": subTotal,
    "discountAmount": discountAmount,
    "taxableAmount": taxableAmount,
    "gstAmount": gstAmount,
    "totalAmount": totalAmount,
    "orderStatus": orderStatus,
    "additionalNotes": additionalNotes,
    "closeLossReason": closeLossReason,
    "poDocument": poDocument,
    "orderNote": orderNote?.toJson(),
    "orderHistory": orderHistory == null
        ? []
        : List<dynamic>.from(orderHistory!.map((x) => x.toJson())),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "apartmentName": apartmentName,
    "eventName": eventName,
  };
}

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

class CustomerDetails {
  String? brandOrCompanyName;
  String? contactPersonName;
  String? contactPersonPhoneNumber;
  String? email;
  String? additionalNotes;
  String? customerId;

  CustomerDetails({
    this.brandOrCompanyName,
    this.contactPersonName,
    this.contactPersonPhoneNumber,
    this.email,
    this.additionalNotes,
    this.customerId,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        brandOrCompanyName: json["brandOrCompanyName"],
        contactPersonName: json["contactPersonName"],
        contactPersonPhoneNumber: json["contactPersonPhoneNumber"],
        email: json["email"],
        additionalNotes: json["additionalNotes"],
        customerId: json["_customerId"],
      );

  Map<String, dynamic> toJson() => {
    "brandOrCompanyName": brandOrCompanyName,
    "contactPersonName": contactPersonName,
    "contactPersonPhoneNumber": contactPersonPhoneNumber,
    "email": email,
    "additionalNotes": additionalNotes,
    "_customerId": customerId,
  };
}

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

class OrderHistory {
  dynamic fromStatus;
  int? toStatus;
  String? changedBy;
  DateTime? changedAt;
  String? remarks;
  String? additionalNotes;
  dynamic negotiationAmount;
  PoDocument? poDocument;

  OrderHistory({
    this.fromStatus,
    this.toStatus,
    this.changedBy,
    this.changedAt,
    this.remarks,
    this.additionalNotes,
    this.negotiationAmount,
    this.poDocument,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    fromStatus: json["fromStatus"],
    toStatus: json["toStatus"],
    changedBy: json["changedBy"],
    changedAt: json["changedAt"] == null
        ? null
        : DateTime.parse(json["changedAt"]),
    remarks: json["remarks"],
    additionalNotes: json["additionalNotes"],
    negotiationAmount: json["negotiationAmount"],
    poDocument: json["poDocument"] == null
        ? null
        : PoDocument.fromJson(json["poDocument"]),
  );

  Map<String, dynamic> toJson() => {
    "fromStatus": fromStatus,
    "toStatus": toStatus,
    "changedBy": changedBy,
    "changedAt": changedAt?.toIso8601String(),
    "remarks": remarks,
    "additionalNotes": additionalNotes,
    "negotiationAmount": negotiationAmount,
    "poDocument": poDocument?.toJson(),
  };
}

class PoDocument {
  DateTime? uploadedAt;

  PoDocument({this.uploadedAt});

  factory PoDocument.fromJson(Map<String, dynamic> json) => PoDocument(
    uploadedAt: json["uploadedAt"] == null
        ? null
        : DateTime.parse(json["uploadedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "uploadedAt": uploadedAt?.toIso8601String(),
  };
}

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
