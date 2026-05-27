// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

void registerMapViewFactory(String viewType, String mapUrl) {
  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) {
      return html.IFrameElement()
        ..src = mapUrl
        ..setAttribute(
            'sandbox',
            'allow-scripts allow-same-origin allow-forms allow-popups')
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
    },
  );
}

Widget buildMapView(String viewType) => HtmlElementView(viewType: viewType);
