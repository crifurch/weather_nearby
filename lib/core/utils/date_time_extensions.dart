DateTime fromSecondsSinceEpochUtc(int seconds) => DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

int? toSecondsSinceEpochUtc(DateTime? dt) => dt == null ? null : dt.toUtc().millisecondsSinceEpoch ~/ 1000;
