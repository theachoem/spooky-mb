// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:spooky/utils/helpers/app_helper.dart';

void main() {
  group('AppHelper#shouldDelete', () {
    test('it should not delete when no moveToBinAt params', () {
      bool shouldDelete = AppHelper.shouldDelete(movedToBinAt: null);
      expect(shouldDelete, false);
    });

    test("it should not delete when just recently moved to bin < 5 days", () {
      // move to bin      current date       should delete
      //  1/1/2020          1/5/2020           1/6/2020
      DateTime movedToBinAt = DateTime(2020, 1, 1);
      DateTime currentDate = DateTime(2020, 1, 5);

      bool shouldDelete = AppHelper.shouldDelete(
        movedToBinAt: movedToBinAt,
        currentDate: currentDate,
        deletedIn: Duration(days: 5),
      );

      expect(shouldDelete, false);
    });

    test("it should delete when delete for long time >= 5 days", () {
      // move to bin      current date       should delete
      //  1/1/2020          1/6/2020           1/6/2020
      DateTime movedToBinAt = DateTime(2020, 1, 1);
      DateTime currentDate = DateTime(2020, 1, 6);

      bool shouldDelete = AppHelper.shouldDelete(
        movedToBinAt: movedToBinAt,
        currentDate: currentDate,
        deletedIn: Duration(days: 5),
      );

      expect(shouldDelete, false);
    });

    test("it should not delete when delete for long time > 5 days", () {
      // move to bin      should delete       current date
      //  1/1/2020          1/6/2020           1/7/2020
      DateTime movedToBinAt = DateTime(2020, 1, 1);
      DateTime currentDate = DateTime(2020, 1, 7);

      bool shouldDelete = AppHelper.shouldDelete(
        movedToBinAt: movedToBinAt,
        currentDate: currentDate,
        deletedIn: Duration(days: 5),
      );

      expect(shouldDelete, true);
    });

    test("it should delete false when just recently moved to bin < 10 days", () {
      // move to bin      current date       should delete
      //  1/1/2020          1/6/2020           1/6/2020
      DateTime currentDate = DateTime(2020, 1, 6);
      DateTime movedToBinAt = DateTime(2020, 1, 1);

      bool shouldDelete = AppHelper.shouldDelete(
        movedToBinAt: movedToBinAt,
        currentDate: currentDate,
        deletedIn: Duration(days: 5),
      );

      expect(shouldDelete, false);
    });
  });

  group('DateTime.isAfter', () {
    test('it return true if current date is after centain date', () {
      // move to bin      current date       should delete
      //  1/1/2020          1/5/2020           1/6/2020
      DateTime currentDate = DateTime(2020, 1, 5);
      DateTime movedToBinAt = DateTime(2020, 1, 1);
      DateTime shouldDeleteAt = movedToBinAt.add(Duration(days: 5));
      bool shouldDelete = currentDate.isAfter(currentDate);

      expect(shouldDeleteAt, DateTime(2020, 1, 1 + 5));
      expect(currentDate.isAfter(movedToBinAt), true);
      expect(currentDate.isAfter(shouldDeleteAt), false);
      expect(shouldDelete, false);
    });
  });
}
