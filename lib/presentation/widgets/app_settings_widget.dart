import 'package:flutter/material.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

import '../../domain/models/app_settings.dart';

class AppSettingsWidget extends StatefulWidget {
  final AppSettings _appSettings;

  const AppSettingsWidget({super.key, required AppSettings appSettings})
      : _appSettings = appSettings;

  @override
  State<StatefulWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  TextEditingController workTimeTextController = TextEditingController();
  TextEditingController addTimeTextController = TextEditingController();
  TextEditingController defaultSkipsTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    workTimeTextController.text =
        widget._appSettings.defaultWorkTime.toString();
    addTimeTextController.text = widget._appSettings.addTime.toString();
    defaultSkipsTextController.text =
        widget._appSettings.defaultSkips.toString();

    return ItemContainer(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Рабочее время:"),
              SizedBox(
                  height: 30,
                  width: 200,
                  child: TextFormField(controller: workTimeTextController))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Добавочное время"),
              SizedBox(
                  height: 30,
                  width: 200,
                  child: TextFormField(controller: addTimeTextController))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Нерабочее время"),
              SizedBox(
                  height: 30,
                  width: 200,
                  child: TextFormField(controller: defaultSkipsTextController))
            ],
          )
        ],
      ),
    ));
  }
}
