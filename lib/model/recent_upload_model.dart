class RecentUploadModel {
  bool? success;
  String? message;
  Data? data;

  RecentUploadModel({this.success, this.message, this.data});

  factory RecentUploadModel.fromJson(Map<String, dynamic> json) =>
      RecentUploadModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? pageNumber;
  int? count;
  int? totalCount;
  String? updatedBy;
  int? totalPages;
  List<Session>? sessions;

  Data({
    this.pageNumber,
    this.count,
    this.totalCount,
    this.updatedBy,
    this.totalPages,
    this.sessions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pageNumber: json["pageNumber"],
    count: json["count"],
    totalCount: json["totalCount"],
    updatedBy: json["updatedBy"],
    totalPages: json["totalPages"],
    sessions: json["sessions"] == null
        ? []
        : List<Session>.from(json["sessions"]!.map((x) => Session.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "count": count,
    "totalCount": totalCount,
    "updatedBy": updatedBy,
    "totalPages": totalPages,
    "sessions": sessions == null
        ? []
        : List<dynamic>.from(sessions!.map((x) => x.toJson())),
  };
}

class Session {
  String? sessionId;
  String? fileName;
  int? totalRows;
  int? insertedCount;
  int? updatedCount;
  int? skippedCount;
  String? updatedAt;

  Session({
    this.sessionId,
    this.fileName,
    this.totalRows,
    this.insertedCount,
    this.updatedCount,
    this.skippedCount,
    this.updatedAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    sessionId: json["sessionId"],
    fileName: json["fileName"],
    totalRows: json["totalRows"],
    insertedCount: json["insertedCount"],
    updatedCount: json["updatedCount"],
    skippedCount: json["skippedCount"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "fileName": fileName,
    "totalRows": totalRows,
    "insertedCount": insertedCount,
    "updatedCount": updatedCount,
    "skippedCount": skippedCount,
    "updatedAt": updatedAt,
  };
}
