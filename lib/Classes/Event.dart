import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
    String title;
    String description;
    String rules;
    int startDate;
    int endDate;
    String coverPhotoUrl;

    Event({
        this.title,
        this.description,
        this.rules,
        this.startDate,
        this.endDate,
        this.coverPhotoUrl,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json["title"],
        description: json["description"],
        rules: json["rules"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        coverPhotoUrl: json["cover_photo_url"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "rules": rules,
        "start_date": startDate,
        "end_date": endDate,
        "cover_photo_url": coverPhotoUrl,
    };
}
