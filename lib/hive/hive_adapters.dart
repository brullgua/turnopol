import 'package:hive_ce/hive_ce.dart';

import '../models/event_model.dart';
import '../models/task_model.dart';

class HiveAdapters {
  HiveAdapters._();

  static const int _taskTypeId = 0;
  static const int _eventTypeId = 1;

  /// Register adapters once to avoid duplicate type errors.
  static void register() {
    if (!Hive.isAdapterRegistered(_taskTypeId)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(_eventTypeId)) {
      Hive.registerAdapter(EventModelAdapter());
    }
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = HiveAdapters._taskTypeId;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return TaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      dueDate: fields[3] as DateTime,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }
}

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = HiveAdapters._eventTypeId;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return EventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      notes: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      isAllDay: fields[5] as bool,
      reminder: Reminder(
        isEnabled: fields[6] as bool,
        minutesBefore: fields[7] as int,
      ),
      repeatFrequency: RepeatFrequency.values[fields[8] as int],
      colorOption: ColorOption.values[fields[9] as int],
      location: fields[10] as String,
      attendees: fields[11] as String,
      url: fields[12] as String,
      calendar: fields[13] as String,
      pathFile: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.isAllDay)
      ..writeByte(6)
      ..write(obj.reminder.isEnabled)
      ..writeByte(7)
      ..write(obj.reminder.minutesBefore)
      ..writeByte(8)
      ..write(obj.repeatFrequency.index)
      ..writeByte(9)
      ..write(obj.colorOption.index)
      ..writeByte(10)
      ..write(obj.location)
      ..writeByte(11)
      ..write(obj.attendees)
      ..writeByte(12)
      ..write(obj.url)
      ..writeByte(13)
      ..write(obj.calendar)
      ..writeByte(14)
      ..write(obj.pathFile);
  }
}
