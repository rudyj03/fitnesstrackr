// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {

  static const TextStyle valueInput = TextStyle(
    color: Color(0xFF0098C7),
    fontWeight: FontWeight.w500,
  );

  static const TextStyle title = TextStyle(
    color: Color(0xFF164F8F),
    fontWeight: FontWeight.w800,
    fontFamily: "Calbri",
    fontFeatures: [FontFeature.enable('smcp')],
    fontSize: 25
  );

  static const TextStyle fieldLabel = TextStyle(
    color: CupertinoColors.black,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle selectedValue = TextStyle(
    color: CupertinoColors.inactiveGray,
  );


  static const Color fieldDivider = Color(0xFF29BCE9);
  static const Color pickerBackground = Color(0xFFFFFFFF);
  static const Color durationBackground = Color(0xFFFFFFFF);
  
  static const Color navigationBackground = Color(0xFF93E0FF);

  static const Color scaffoldBackground = Color(0xFFD1E4EB);
  static const Color tabBackground = Color(0xFFD1E4EB);
  
  static const Color submitButton = CupertinoColors.systemBlue;
}