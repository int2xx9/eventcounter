import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
@immutable
class Event {
  final String id;
  final String? summary;
  final DateTime recordedAt;

  Event({required this.id, this.summary = null, required this.recordedAt});

  Event copyWith(
      {String? id = null,
      String? summary = null,
      DateTime? recordedAt = null}) {
    return Event(
        id: id ?? this.id,
        summary: summary ?? this.summary,
        recordedAt: recordedAt ?? this.recordedAt);
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

final InvalidEvent = Event(id: "", recordedAt: DateTime(0));
