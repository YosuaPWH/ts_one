import 'package:flutter/material.dart';
import 'package:ts_one/presentation/shared_components/card_user.dart';
import 'package:ts_one/presentation/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _filterDateTime;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Assessment History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDateRangePicker(
                            locale: const Locale('en'),
                            cancelText: 'Cancel',
                            context: context,
                            currentDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2100),
                            saveText: 'OK')
                        .then((value) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("${value!.start} dan ${value.end}"),
                                ),
                              ),
                            });
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(TsOneColor.onPrimary),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(TsOneColor.primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: TsOneColor.primary),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Filter",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                cursorColor: TsOneColor.primary,
                decoration: InputDecoration(
                  fillColor: TsOneColor.onPrimary,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: TsOneColor.primary),
                  ),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                    color: TsOneColor.onSecondary,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(10),
                    width: 32,
                    child: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return const CardUser();
                },
                itemCount: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
