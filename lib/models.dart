class Member {
  String? id;
  late String name;
  late String index;
  String? subIndex;
  String? imageUrl;
  String? description;
  List<MemberDate>? dates;

  Member(this.name) {
    parseName();
  }

  Member.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    name = json["name"] ?? "";
    parseName();
    description = json["desc"] ?? "";

    // parse any images
    final images = Member.parseList(json, "Images");
    imageUrl = (images.isNotEmpty) ? images[0] : "";

    dates = [];
    final dateList = Member.parseList(json, "Dates");
    if (dateList.isEmpty) return;
    dates = dateList
        .map((row) {
          final item = MemberDate.fromListEntry(row);
          return item;
        })
        .cast<MemberDate>()
        .where((date) => date.day != null)
        .toList();
    dates!.sort();
  }

  static List<String> parseList(Map<String, dynamic> json, String name) {
    final lists = json["checklists"]
            ?.where((list) => list["name"] == name)
            ?.map((list) => list['checkItems']
                .map((item) => item["name"])
                .cast<String>()
                .toList())
            ?.toList() ??
        [];
    if (lists.isEmpty) return [];

    return lists[0];
  }

  get isBroken =>
      (imageUrl?.isEmpty ?? true) ||
      (imageUrl!.startsWith('https://trello.com'));

  void parseName() {
    if (name.isEmpty) return;
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
    if (name.isEmpty) return [];

    final start = 'A'.codeUnitAt(0);
    final alphabet =
        String.fromCharCodes(Iterable.generate(26, (x) => start + x));

    return name
        .replaceAll(RegExp(r"\s+"), " ")
        .split(" ")
        .map((word) => word.trim().substring(0, 1))
        .where(alphabet.contains)
        .toList();
  }

  static List<Member> formList(List<dynamic> json) =>
      json.map((item) => Member.fromJson(item)).toList();

  static Member? forToday(List<Member> members) {
    if (members.isEmpty) return null;
    final theDay = DateTime.utc(1994, DateTime.january, 8);
    final counter = theDay.difference(DateTime.now()).inDays;
    final index = counter % members.length;
    return members[index];
  }
}

class MemberDate implements Comparable<MemberDate> {
  int? year;
  int? month;
  int? day;
  String? description;

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
