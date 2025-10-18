import 'package:flutter_test/flutter_test.dart';
import 'package:google_map_service/data/repositories/google_map_service.dart';

void main() {
  test('adds one to input values', () {
    final map = GoogleMapService('<API_KEY>');
    expect(map.queryAutocomplete('indore'), {});
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
  });
}
