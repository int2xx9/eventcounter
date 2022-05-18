// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventsJson _$EventsJsonFromJson(Map<String, dynamic> json) => _EventsJson(
      eventGroups: (json['eventGroups'] as List<dynamic>)
          .map((e) => EventGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => Event.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$EventsJsonToJson(_EventsJson instance) =>
    <String, dynamic>{
      'eventGroups': instance.eventGroups,
      'events': instance.events,
    };
