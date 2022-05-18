import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eventgroup.g.dart';

@JsonSerializable()
@immutable
class EventGroup {
  final String id;
  final String name;

  EventGroup({required this.id, required this.name});

  EventGroup copyWith({String? id, String? name}) {
    return EventGroup(id: id ?? this.id, name: name ?? this.name);
  }

  factory EventGroup.fromJson(Map<String, dynamic> json) =>
      _$EventGroupFromJson(json);
  Map<String, dynamic> toJson() => _$EventGroupToJson(this);
}

final InvalidEventGroup = EventGroup(id: "", name: "");
