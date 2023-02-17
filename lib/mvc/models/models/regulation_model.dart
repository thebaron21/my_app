class RegulationModel {
  final String id;
  final String title;
  final String content;

  RegulationModel.toJson(var json, id)
      : id = id,
        title = json["title"],
        content = json["content"];

  toJson() => {"id": id, "title": title, "content": content};
}

class RegulationRep {
  // List<RegulationModel> regulations;
  // RegulationRep.toModel(var json) :
  //     regulations = (json as List).map((e) => RegulationModel.toJson(e, id)).toList();

}
