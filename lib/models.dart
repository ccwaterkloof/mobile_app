class Member {
  String id;
  String name;
  String index;
  String subIndex;
  String imageUrl;
  String description;
  List<MemberDate> dates;

  Member(this.name) {
    parseName();
  }

  Member.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    name = json["name"] ?? "";
    parseName();
    description = json["desc"] ?? "";
    final attachments = json["attachments"]
            ?.map((entry) => entry["url"].toString())
            ?.toList() ??
        [];
    imageUrl = attachments.isEmpty ? "" : attachments[0];

    // parse any dates
    dates = [];
    final lists =
        json["checklists"]?.map((list) => list["checkItems"])?.toList();
    if (lists?.isEmpty ?? true) return;
    if (lists[0]?.isEmpty ?? true) return;
    dates = lists[0]
        .map((row) {
          final item = MemberDate.fromListEntry(row["name"]);
          return item;
        })
        .cast<MemberDate>()
        .where((date) => date?.day != null)
        .toList();
    dates.sort();
  }

  void parseName() {
    if (name?.isEmpty ?? true) return;
    final parts = name.split(" with ");
    index = parts[0].trim();
    if (parts.length > 1) {
      subIndex = parts[1].trim();
    }
  }

  String get title {
    if (subIndex?.isNotEmpty ?? false) return index;
    return name;
  }

  List<String> get capitals {
    if (name == null) return [];

    final start = 'A'.codeUnitAt(0);
    final alphabet =
        String.fromCharCodes(new Iterable.generate(26, (x) => start + x));

    return name
        .replaceAll(new RegExp(r"\s+"), " ")
        .split(" ")
        .map((word) => word.trim().substring(0, 1))
        .where(alphabet.contains)
        .toList();
  }

  static List<Member> formList(List<dynamic> json) =>
      json.map((item) => Member.fromJson(item)).toList();

  static Member forToday(List<Member> members) {
    if (members?.isEmpty ?? true) return null;
    final theDay = new DateTime.utc(1994, DateTime.january, 8);
    final counter = theDay.difference(DateTime.now()).inDays;
    final index = counter % members.length;
    return members[index];
  }
}

class MemberDate implements Comparable<MemberDate> {
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

  String get date {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "$day ${names[month ?? 0]}";
  }

  int get sortWeight => ((month ?? 0) * 100) + (day ?? 0);

  @override
  int compareTo(other) {
    if (sortWeight > other.sortWeight) return 1;
    if (sortWeight < other.sortWeight) return -1;
    return 0;
  }

  /// don't want the whole equality operator and hasCode overrides
  bool isSameAs(MemberDate other) =>
      description == other.description &&
      day == other.day &&
      month == other.month &&
      year == other.year;
}
