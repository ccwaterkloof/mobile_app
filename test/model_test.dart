import 'dart:convert';
import 'package:test/test.dart';
import 'package:ccw/models.dart';

void main() {
  group('member model', () {
    test('Can parse Trello feed', () {
      final raw = json.decode(trelloFeed);
      List<Member> members = Member.formList(raw);

      expect(members.length, 3);

      expect(members[1].name, "Matthew Gardner");
      expect(members[0].description, "Wisdom and energy for homeschooling");
      expect(members[1].due.day, 3);
      expect(members[0].imageUrl,
          "https://trello-attachments.s3.amazonaws.com/5e0daf8369a1586343589db1/5e0db025853ff51f97e044c6/9e74c962216987431c09940fa81033da/hill.jpg");
    });
  });
}

final trelloFeed = '''
[{ "id": "5e0db025853ff51f97e044c6", "name": "David & Adele Hill with Hannah, Nathan, James, Sarah and Mia", "desc": "Wisdom and energy for homeschooling", "due": null, "attachments": [{"url": "https://trello-attachments.s3.amazonaws.com/5e0daf8369a1586343589db1/5e0db025853ff51f97e044c6/9e74c962216987431c09940fa81033da/hill.jpg","id": "5e0db4ea1452e019370aa262"} ]},{ "id": "5e0db5bc47c7258bc54a1d16", "name": "Matthew Gardner", "desc": "", "due": "2020-01-03T10:00:00.000Z", "attachments": [{"url": "https://trello-attachments.s3.amazonaws.com/5e0daf8369a1586343589db1/5e0db5bc47c7258bc54a1d16/f510b3490d83077affaa7790375ffd33/matthew.jpg","id": "5e0db5c85eddb05f8b6876b9"} ]},{ "id": "5e0e1ada33de17493717a6bc", "name": "Adrian & Lynne Smith with Emma", "desc": "", "due": null, "attachments": []}]
''';
