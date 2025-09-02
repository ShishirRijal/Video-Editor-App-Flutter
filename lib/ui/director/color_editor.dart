import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_video_editor_app/service/director_service.dart';
import 'package:flutter_video_editor_app/service_locator.dart';
import 'package:flutter_video_editor_app/ui/director/params.dart';
import 'package:flutter_video_editor_app/model/model.dart';

class ColorEditor extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: directorService.editingColor$,
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<String?> editingColor) {
        if (editingColor.data == null) return Container();
        return Container(
          height: Params.getTimelineHeight(context),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            border: Border(top: BorderSide(width: 2, color: Colors.blue)),
          ),
          child: ColorForm(),
        );
      },
    );
  }
}

class ColorForm extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    int fontColor = 0;
    if (directorService.editingColor == 'fontColor') {
      fontColor = directorService.editingTextAsset?.fontColor ?? 0;
    } else if (directorService.editingColor == 'boxcolor') {
      fontColor = directorService.editingTextAsset?.boxcolor ?? 0;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 150,
          child: Container(
            // height:
            //     (MediaQuery.of(context).orientation == Orientation.landscape)
            //     ? 116
            //     : 300,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: ColorPicker(
              pickerColor: Color(fontColor),
              paletteType: PaletteType.hsv,
              enableAlpha: true,
              colorPickerWidth: 240,
              pickerAreaHeightPercent: 0.8,
              onColorChanged: (color) {
                final editingTextAsset = directorService.editingTextAsset;
                if (editingTextAsset == null) return;
                Asset newAsset = Asset.clone(editingTextAsset);
                if (directorService.editingColor == 'fontColor') {
                  newAsset.fontColor = color.value;
                } else if (directorService.editingColor == 'boxcolor') {
                  newAsset.boxcolor = color.value;
                }
                directorService.editingTextAsset = newAsset;
              },
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                directorService.editingColor = null;
              },
              child: Text('CANCEL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('SELECT'),
              onPressed: () {
                directorService.editingColor = null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
