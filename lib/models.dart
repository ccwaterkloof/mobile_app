class Member {
  String name;
  String imageUrl;
  String description;
  List<MemberDate> dates;

  Member.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    description = json["desc"];
    final utc = json["due"];
    final attachments = json["attachments"].map((entry) {
      return entry["url"].toString();
    }).toList();
    imageUrl = attachments.isEmpty ? null : attachments[0];

    // parse any dates
    dates = [];
    final lists = json["checklists"].map((list) {
      return list["checkItems"];
    }).toList();
    if (lists?.isEmpty ?? true) return;
    if (lists[0]?.isEmpty ?? true) return;
    dates = lists[0]
        .map((row) {
          final item = MemberDate.fromListEntry(row["name"]);
          return item;
        })
        .cast<MemberDate>()
        .toList();
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

class MemberDate {
  int year;
  int month;
  int day;
  String description;

  MemberDate.fromListEntry(String entry) {
    final parts = entry.split(":");
    if (parts.length != 2) return;
    final dateParts = parts[0].split("-");
    if (dateParts.length != 3) return;
    description = parts[1].trim();
    year = int.tryParse(dateParts[0]);
    month = int.tryParse(dateParts[1]);
    day = int.tryParse(dateParts[2]);
  }
}
