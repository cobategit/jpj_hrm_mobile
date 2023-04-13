import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';

class AllNavigation {
  static popNav(context, isParams, params) {
    Navigator.of(context).pop(isParams ? params : null);
  }

  static pushNav(context, child, func) {
    Navigator.of(context).push(AnimationFadeTransisi(child)).then(func);
  }

  static pushReplaceNav(context, child, func) {
    Navigator.of(context)
        .pushReplacement(AnimationFadeTransisi(child))
        .then(func);
  }

  static pushRemoveUntilNav(context, child, func) {
    Navigator.of(context)
        .pushAndRemoveUntil(AnimationFadeTransisi(child), (route) => false)
        .then(func);
  }
}
