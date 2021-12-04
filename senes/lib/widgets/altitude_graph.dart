//@dart=2.10
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senes/helpers/route_point.dart';

class AltitudeChart extends StatelessWidget {
  AltitudeChart(this.points, {Key key}) : super(key: key);
  List<RoutePoint> points;

  @override
  Widget build(BuildContext context) {
    Series<RoutePoint, int> altitude = Series<RoutePoint, int>(
        id: "Altitude",
        domainFn: (RoutePoint point, _) =>
            (point.time.millisecondsSinceEpoch -
                points.first.time.millisecondsSinceEpoch) ~/
            1000,
        measureFn: (RoutePoint point, _) => point.altitude,
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        data: points);

    return LineChart(
      [altitude],
      behaviors: [
        ChartTitle('Time(s)',
            behaviorPosition: BehaviorPosition.bottom,
            titleStyleSpec: const TextStyleSpec(fontSize: 13)),
        ChartTitle(
          'Elevation(m)',
          behaviorPosition: BehaviorPosition.start,
          titleStyleSpec: const TextStyleSpec(fontSize: 13),
        )
      ],
      primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(zeroBound: false)),
    );
  }
}
