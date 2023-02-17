class ComplaintModel {
  final String uuid;
  String details;
  final Map files;
  final String date;
  final String status;
  final String userId;
  final String processId;

  ComplaintModel(this.uuid, this.userId, this.details, this.files, this.date,
      this.status, this.processId);

  ComplaintModel.toJson(var json)
      : uuid = json["uuid"],
        userId = json["userId"],
        details = json["details"],
        date = json["date"],
        status = json["status"],
        processId = json["processId"],
        files = json["files"];

  setDetails(text) => details = text;

  toJson() => {
    "uuid": uuid,
    "userId": userId,
    "details": details,
    "date": date,
    "files": files,
    "status": status,
    "processId": processId
  };
}
