// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/hive_models/companyhivemodel.dart';


class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  late List<CompanyHiveModel> companies=[];
  final _companyBox = Hive.openBox<CompanyHiveModel>('companies');

  @override
  void initState() {
    super.initState();
    _loadCompaniesFromHive();
  }

  Future<void> _loadCompaniesFromHive() async {
    final box = await _companyBox;
    setState(() {
      companies = box.values.toList();
    });
  }

  Future<void> _deleteCompanyFromHive(String symbol) async {
    final box = await _companyBox;
    box.delete(symbol);
    _loadCompaniesFromHive(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Company Name')),
            DataColumn(label: Text('Price')),

            DataColumn(label: Text('Delete')),
          ],
          rows: companies.map((company) {
            return DataRow(cells: [
              DataCell(Text("${company.name} (${company.currency})")),
              DataCell(Text("${company.price} ")),
              
              DataCell(IconButton(
                onPressed: () {
                  _deleteCompanyFromHive(company.symbol);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              )),
            ]);
          }).toList(),
        ),
      ),
//       ListView.builder(
//   itemCount: companies.length,
//   itemBuilder: (context, index) {
//     final company = companies[index];
//     return Card(
//       elevation: 4, // Add shadow for a material design look
//       margin: EdgeInsets.symmetric(horizontal: 16), // Adjust the spacing
//       // Add rounded corners to the Card
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       // Wrap the ListTile in a Padding widget to add space around it
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListTile(
//           contentPadding: EdgeInsets.symmetric(vertical: 8),
//           title: Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               company.name,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               "Stock Price ${company.price} ${company.currency}",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.green
//               ),
//             ),
//           ),
//           trailing: IconButton(
//             onPressed: () {
//               _deleteCompanyFromHive(company.symbol);
//             },
//             icon: Icon(
//               Icons.delete,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ),
//     );
//   },
// )

    );
  }
}
