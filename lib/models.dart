class Member {
  String name;
  String imageUrl;
  String description;
  DateTime due;

  Member.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    description = json["desc"];
    final utc = json["due"];
    due = (utc == null) ? null : DateTime.parse(utc);
    final attachments = json["attachments"].map((entry) {
      return entry["url"].toString();
    }).toList();
    imageUrl = attachments.isEmpty ? null : attachments[0];
  }

  static List<Member> formList(List<dynamic> json) {
    // print(json.length);
    return json.map((item) {
      return Member.fromJson(item);
    }).toList();
  }

  static Member forToday(List<Member> members) {
    if (members.isEmpty) return null;
    final theDay = new DateTime.utc(1994, DateTime.january, 8);
    final counter = theDay.difference(DateTime.now()).inDays;
    final index = counter % members.length;
    return members[index];
  }
}
