import 'dart:convert';
import 'package:test/test.dart';
import 'package:ccw/models.dart';

void main() {
  group('Name', () {
    test("Member search index", () {
      final member =
          Member("Niel & Jean Immelman with Emily Rachel and Timothy");
      expect(member.capitals, ['N', 'J', 'I', 'E', 'R', 'T']);

      member.name = "Thomas     and his sister Sarah-Jayne";
      expect(member.capitals, ['T', 'S']);

      member.name = "Renier + family du Plessis";
      expect(member.capitals, ['R', 'P']);
    });
    test("Member name parsing", () {
      final member =
          Member("Niel & Jean Immelman with Emily Rachel and Timothy");
      expect(member.title, "Niel & Jean Immelman");
      expect(member.index, "Niel & Jean Immelman");
      expect(member.subIndex, "Emily Rachel and Timothy");

      final neelan = Member("Neelan Philip");
      expect(neelan.title, "Neelan Philip");
      expect(neelan.index, "Neelan Philip");
      expect(neelan.subIndex, null);
    });
  });
  group('Parsing', () {
    test('Can parse Trello feed with dates list and images list', () {
      final raw = json.decode(trelloFeedWithLists);
      final members = Member.formList(raw);

      expect(members.length, 5);

      final card = members[0];

      expect(card.name, "Scott & Mary Vander Molen");

      expect(
        card.description!.startsWith("Images and Dates"),
        true,
      );

      expect(
        card.imageUrl,
        "https://res.cloudinary.com/kiekies/image/upload/v1629136168/ccw/vandermolen.jpg",
      );

      expect(card.dates!.length, 2);
      expect(card.dates![1].description, "Mary's birthday");
      expect(card.dates![1].day, 15);
      expect(card.dates![1].month, 6);
      expect(card.dates![1].year, 1977);

      // no dates
      final noDateCard = members[2];
      expect(noDateCard.dates!.length, 0);
    });
  });
}

const trelloFeedWithLists = '''
[
  {
    "id": "60a155d9c6e68511bb20549e",
    "name": "Scott & Mary Vander Molen",
    "desc": "Images and Dates",
    "checklists": [
      {
        "name": "Dates",
        "id": "60a155e595f7b63961562dcc",
        "checkItems": [
          {
            "id": "60a15601d190c90f6c621644",
            "name": "1977-06-15: Mary's birthday",
            "nameData": null,
            "pos": 16841,
            "state": "incomplete",
            "due": null,
            "idMember": null,
            "idChecklist": "60a155e595f7b63961562dcc"
          },
          {
            "id": "60a15626ea81202bf36a53a0",
            "name": "2019-05-11:  Scott & Mary's anniversary",
            "nameData": null,
            "pos": 34244,
            "state": "incomplete",
            "due": null,
            "idMember": null,
            "idChecklist": "60a155e595f7b63961562dcc"
          }
        ]
      },
      {
        "name": "Images",
        "id": "611aa6169967aa83561d21a8",
        "checkItems": [
          {
            "id": "611aad13c1ed3882408638a7",
            "name": "https://res.cloudinary.com/kiekies/image/upload/v1629136168/ccw/vandermolen.jpg",
            "nameData": null,
            "pos": 33862,
            "state": "incomplete",
            "due": null,
            "idMember": null,
            "idChecklist": "611aa6169967aa83561d21a8"
          }
        ]
      }
    ]
  },
  {
    "id": "5e2dd2dede99c769aa703cc3",
    "name": "Fay Bijker with Damian & Donna",
    "desc": "Images and empty Dates",
    "checklists": [
      {
        "name": "Dates",
        "id": "611c9a6369070838e5da561d",
        "checkItems": []
      },
      {
        "name": "Images",
        "id": "611c9a69229162157c17702f",
        "checkItems": [
          {
            "id": "611c9a6ec6d71e3985a3a2cd",
            "name": "https://res.cloudinary.com/kiekies/image/upload/v1629264205/ccw/bppzfu9wqzlojycbfzvg.jpg",
            "nameData": null,
            "pos": 16690,
            "state": "incomplete",
            "due": null,
            "idMember": null,
            "idChecklist": "611c9a69229162157c17702f"
          }
        ]
      }
    ]
  },
  {
    "id": "5e1767d103a3c359579cdd6e",
    "name": "Leon & Carmen Davids with Riley",
    "desc": "No Dates or Images",
    "checklists": []
  },
  {
    "id": "60807b9a401f0d25ec375397",
    "name": "Dave & Sue Rousseau",
    "desc": "Images with No Dates",
    "checklists": [
      {
        "name": "Images",
        "id": "611c9a69229162157c17702f",
        "checkItems": [
          {
            "id": "611c9a6ec6d71e3985a3a2cd",
            "name": "https://res.cloudinary.com/kiekies/image/upload/v1629264205/ccw/bppzfu9wqzlojycbfzvg.jpg",
            "nameData": null,
            "pos": 16690,
            "state": "incomplete",
            "due": null,
            "idMember": null,
            "idChecklist": "611c9a69229162157c17702f"
          }
        ]
      }
    ]
  },
  {
    "id": "5e176bb73168431aa52b128a",
    "name": "Dave and Sherrin Drew with Nate, Mercy, Bill, Libby and Faith",
    "desc": "Dates and no Images",
    "checklists": [
      {
        "name": "Dates",
        "id": "600c0334d86c1c8fefe79d3c",
        "checkItems": [
          {
            "id": "600c0353c1827826a14b5fda",
            "name": "1981-10-04: Sherrin's birthday",
            "nameData": {
              "emoji": {}
            },
            "pos": 16940,
            "state": "incomplete",
            "due": null,
            "idMember": null,
            "idChecklist": "600c0334d86c1c8fefe79d3c"
          }
        ]
      }
    ]
  }
]
''';
