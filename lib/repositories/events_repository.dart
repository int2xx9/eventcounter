import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';

import '../models/event.dart';
import '../models/eventgroup.dart';

part 'events_repository.g.dart';

final eventsRepositoryProvider = Provider((ref) => EventsRepository(ref));

@JsonSerializable()
@immutable
class _EventsJson {
  final List<EventGroup> eventGroups;
  final Map<String, List<Event>> events;

  _EventsJson({required this.eventGroups, required this.events});

  factory _EventsJson.fromJson(Map<String, dynamic> json) =>
      _$EventsJsonFromJson(json);
  Map<String, dynamic> toJson() => _$EventsJsonToJson(this);
}

class EventsRepository {
  final Ref ref;
  final Lock _lock;

  EventsRepository(this.ref) : _lock = Lock();

  Future<String> get _docDirPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<String> get _eventsPath async => "${await _docDirPath}/events.json";

  Future<List<EventGroup>> getEventGroups() async {
    final file = File(await _eventsPath);
    if (!file.existsSync()) {
      return [];
    }
    final eventsJson =
        _EventsJson.fromJson(json.decode(await file.readAsString()));
    return eventsJson.eventGroups;
  }

  Future<List<Event>> getEvents(String groupId) async {
    final file = File(await _eventsPath);
    if (!file.existsSync()) {
      return [];
    }
    final eventsJson =
        _EventsJson.fromJson(json.decode(await file.readAsString()));
    return Future.value(eventsJson.events[groupId]);
  }

  Future<void> saveEventGroups(List<EventGroup> eventGroups) async {
    await _lock.synchronized(() async {
      final file = File(await _eventsPath);
      var eventsJson = _EventsJson(eventGroups: [], events: {});
      if (await file.exists()) {
        eventsJson =
            _EventsJson.fromJson(json.decode(await file.readAsString()));
      }

      eventsJson =
          _EventsJson(eventGroups: eventGroups, events: eventsJson.events);
      eventsJson = _cleanupOrphanEvents(eventsJson);
      final newJson = json.encode(eventsJson.toJson());
      await File(await _eventsPath).writeAsString(newJson);
    });
  }

  Future<void> saveEvents(String groupId, List<Event> events) async {
    await _lock.synchronized(() async {
      final file = File(await _eventsPath);
      var eventsJson = _EventsJson(eventGroups: [], events: {});
      if (await file.exists()) {
        eventsJson =
            _EventsJson.fromJson(json.decode(await file.readAsString()));
      }

      final jsonEvents = Map.of(eventsJson.events);
      jsonEvents.removeWhere((key, value) => key == groupId);
      jsonEvents[groupId] = events;

      eventsJson =
          _EventsJson(eventGroups: eventsJson.eventGroups, events: jsonEvents);
      eventsJson = _cleanupOrphanEvents(eventsJson);
      final newJson = json.encode(eventsJson.toJson());
      await File(await _eventsPath).writeAsString(newJson);
    });
  }

  _EventsJson _cleanupOrphanEvents(_EventsJson eventsJson) {
    final Map<String, List<Event>> newEvents = {};
    for (final groupId in eventsJson.eventGroups.map((group) => group.id)) {
      final event = eventsJson.events[groupId];
      if (event == null) {
        continue;
      }
      newEvents[groupId] = event;
    }
    return _EventsJson(eventGroups: eventsJson.eventGroups, events: newEvents);
  }
}
