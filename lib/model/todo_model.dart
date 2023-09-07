class TodoModel {
  final int? id;
  final String? title;
  final String? description;
  final String? initialDate;
  final String? endDate;
  final String? startdate;
  final String? enddate;

  TodoModel(
      {this.id,
      this.title,
      this.description,
      this.initialDate,
      this.endDate,
      this.startdate,
      this.enddate});

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        initialDate = res['initialDate'],
        endDate = res['endDate'],
        startdate = res['startdate'],
        enddate = res['enddate'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'initialDate': initialDate,
      'endDate': endDate,
      'startdate': startdate,
      'enddate': enddate
    };
  }
}
