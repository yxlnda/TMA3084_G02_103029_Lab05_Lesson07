import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Car {
  final String make;
  final int model;
  final int price;

  Car({required this.make, required this.model, required this.price});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataTableExample(),
    );
  }
}

class DataTableExample extends StatefulWidget {
  const DataTableExample({super.key});

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  List<Car> cars = [
    Car(make: 'Honda', model: 2021, price: 35000),
    Car(make: 'Toyota', model: 2011, price: 6000),
    Car(make: 'BMW', model: 2010, price: 9000),
  ];

  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(
    Comparable<T> Function(Car car) getField,
    int columnIndex,
    bool ascending,
  ) {
    cars.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);

      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Data Table')),
      body: Center(
        child: DataTable(
          border: TableBorder.all(color: Colors.black),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade400),
          columns: [
            DataColumn(
              label: const Text(
                'Car Make',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                _sort<String>((car) => car.make, columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text(
                'Model',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                _sort<num>((car) => car.model, columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              numeric: true,
              onSort: (columnIndex, ascending) {
                _sort<num>((car) => car.price, columnIndex, ascending);
              },
            ),
          ],
          rows: cars.map((car) {
            return DataRow(
              cells: [
                DataCell(Text(car.make)),
                DataCell(Text(car.model.toString())),
                DataCell(Text(car.price.toString())),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
