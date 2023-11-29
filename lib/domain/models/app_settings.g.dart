// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      const TimeOfDayJsonConverter()
          .fromJson(json['defaultWorkTime'] as Map<String, dynamic>),
      const TimeOfDayJsonConverter()
          .fromJson(json['addTime'] as Map<String, dynamic>),
      (json['defaultSkips'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, TimeInterval.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'defaultWorkTime':
          const TimeOfDayJsonConverter().toJson(instance.defaultWorkTime),
      'addTime': const TimeOfDayJsonConverter().toJson(instance.addTime),
      'defaultSkips': instance.defaultSkips,
    };
