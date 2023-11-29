import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:work_time_manager/domain/converters/time_of_day_json_converter.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';

part 'time_interval.g.dart';

@JsonSerializable(converters: [TimeOfDayJsonConverter()])
class TimeInterval {
  TimeOfDay start;
  TimeOfDay end;

  TimeInterval(this.start, this.end) {
    TimeOfDay diff = end - start;
    if (diff.hour < 0) {
      throw Exception("End can't be before start");
    }
  }

  TimeOfDay toTimeOfDay() {
    return end - start;
  }

  /*
    1) Сортируем массив интервалов
    2) x = первый интервал
    3) Если интервал x последний - переходим к п. 8:
    4) Проверяем пересекаются ли интервал x и следующий интервал
    5) Если пересекаются - объединяем их и x = итоговый интервал
    6) Если не пересекаются - x = следующий за x интервал
    7) Возвращаемся в п. 3
    8) Теперь все интервалы - непересекающиеся
    9) Обрезаем или удаляем интервалы, не попадающие в основной
    10) Считаем суммы интервалов
    11) Переводим основной интервал в TimeOfDay
    12) Вычитаем сумму интервалов из основного
  */
  TimeOfDay remove({List<TimeInterval>? intervals}) {
    if (intervals != null && intervals.isNotEmpty) {
      List<TimeInterval> i = List<TimeInterval>.from(intervals);
      i.sort((a, b) => (a.start.toInt().compareTo(b.start.toInt())));
      int counter = 0;
      TimeInterval? interv;
      while (counter < i.length - 1) {
        interv = TimeInterval._combine(i[counter], i[counter + 1]);
        if (interv != null) {
          i.removeRange(counter, counter + 2);
          i.insert(0, interv);
        } else {
          counter++;
        }
      }
      counter = 0;
      while (counter < i.length) {
        if (i[counter].end <= start) {
          i.removeAt(counter);
          continue;
        } else if (i[counter].start < start) {
          i[counter].start = start;
        } else if (i[counter].start >= end) {
          i.removeAt(counter);
          continue;
        } else if (i[counter].end > end) {
          i[counter].end = end;
        }

        counter++;
      }

      TimeOfDay skip = const TimeOfDay(hour: 0, minute: 0);
      for (var element in i) {
        skip += element.toTimeOfDay();
      }

      return toTimeOfDay() - skip;
    } else {
      return toTimeOfDay();
    }
  }

  static TimeInterval? _combine(TimeInterval a, TimeInterval b) {
    if (a.end >= b.start && a.end < b.end) {
      return TimeInterval(a.start, b.end);
    } else if (b.end >= a.start && b.end < a.end) {
      return TimeInterval(b.start, a.end);
    } else if (a.start <= b.start && a.end >= b.end) {
      return a;
    } else if (b.start <= a.start && b.end >= b.end) {
      return b;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return ("${start.hour}:${start.minute} - ${end.hour}:${end.minute}");
  }

  factory TimeInterval.fromJson(Map<String, dynamic> json) =>
      _$TimeIntervalFromJson(json);

  Map<String, dynamic> toJson() => _$TimeIntervalToJson(this);
}
