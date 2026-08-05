import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../storage/preferences_service.dart';

@singleton
class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit(this._preferences) : super(const Locale('en')) {
    _loadPersistedLocale();
  }

  static const String localeKey = 'locale';

  final PreferencesService _preferences;

  Future<void> _loadPersistedLocale() async {
    final String? saved = await _preferences.getString(localeKey);
    if (saved != null && saved.isNotEmpty) {
      emit(Locale(saved));
    }
  }

  Future<void> setLocale(Locale locale) async {
    emit(locale);
    await _preferences.setString(localeKey, locale.languageCode);
  }
}
