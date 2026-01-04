import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String notes;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final Reminder reminder;
  final RepeatFrequency repeatFrequency;
  final ColorOption colorOption;
  final String location;
  final String attendees;
  final String url;
  final String calendar;
  final String pathFile;

  EventModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    this.reminder = const Reminder(isEnabled: false, minutesBefore: 10),
    this.repeatFrequency = RepeatFrequency.none,
    this.colorOption = ColorOption.blue,
    this.location = '',
    this.attendees = '',
    this.url = '',
    this.calendar = 'Default',
    this.pathFile = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isAllDay': isAllDay,
      'reminder': {
        'isEnabled': reminder.isEnabled,
        'minutesBefore': reminder.minutesBefore,
      },
      'repeatFrequency': repeatFrequency.name,
      'colorOption': colorOption.name,
      'location': location,
      'attendees': attendees,
      'url': url,
      'calendar': calendar,
      'pathFile': pathFile,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      notes: map['notes'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      isAllDay: map['isAllDay'],
      reminder: Reminder(
        isEnabled: map['reminder']['isEnabled'],
        minutesBefore: map['reminder']['minutesBefore'],
      ),
      repeatFrequency: RepeatFrequency.values.firstWhere(
        (e) => e.name == map['repeatFrequency'],
        orElse: () => RepeatFrequency.none,
      ),
      colorOption: ColorOption.values.firstWhere(
        (e) => e.name == map['colorOption'],
        orElse: () => ColorOption.blue,
      ),
      location: map['location'],
      attendees: map['attendees'],
      url: map['url'],
      calendar: map['calendar'],
      pathFile: map['pathFile'],
    );
  }
}


class Reminder {
  final bool isEnabled;
  final int minutesBefore;

  const Reminder({
    this.isEnabled = false,
    this.minutesBefore = 10,
  });
}

enum RepeatFrequency {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}
extension RepeatFrequencyExtension on RepeatFrequency {
  String get name {
    switch (this) {
      case RepeatFrequency.none:
        return 'None';
      case RepeatFrequency.daily:
        return 'Daily';
      case RepeatFrequency.weekly:
        return 'Weekly';
      case RepeatFrequency.monthly:
        return 'Monthly';
      case RepeatFrequency.yearly:
        return 'Yearly';
    }
  }
}

enum ReminderTime {
  atTime,
  fiveMinutesBefore,
  tenMinutesBefore,
  fifteenMinutesBefore,
  thirtyMinutesBefore,
  oneHourBefore,
  twoHoursBefore,
  oneDayBefore,
  twoDaysBefore,
  oneWeekBefore,
}
extension ReminderTimeExtension on ReminderTime {
  int get minutesBefore {
    switch (this) {
      case ReminderTime.atTime:
        return 0;
      case ReminderTime.fiveMinutesBefore:
        return 5;
      case ReminderTime.tenMinutesBefore:
        return 10;
      case ReminderTime.fifteenMinutesBefore:
        return 15;
      case ReminderTime.thirtyMinutesBefore:
        return 30;
      case ReminderTime.oneHourBefore:
        return 60;
      case ReminderTime.twoHoursBefore:
        return 120;
      case ReminderTime.oneDayBefore:
        return 1440;
      case ReminderTime.twoDaysBefore:
        return 2880;
      case ReminderTime.oneWeekBefore:
        return 10080;
    }
  }
}

enum ColorOption {
  red,
  blue,
  green,
  yellow,
  orange,
  purple,
  pink,
  teal,
}

extension ColorOptionExtension on ColorOption {
  Color get name {
    switch (this) {
      case ColorOption.red:
        return Colors.red;
      case ColorOption.blue:
        return Colors.blue;
      case ColorOption.green:
        return Colors.green;
      case ColorOption.yellow:
        return Colors.yellow;
      case ColorOption.orange:
        return Colors.orange;
      case ColorOption.purple:
        return Colors.purple;
      case ColorOption.pink:
        return Colors.pink;
      case ColorOption.teal:
        return Colors.teal;
    }
  }
}