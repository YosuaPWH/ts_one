import 'package:flutter/material.dart';
import 'package:ts_one/presentation/routes.dart';

import '../../shared_components/search_component.dart';
import '../../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hi, Pilot",
                  style: tsOneTextTheme.headlineLarge,
                ),
                const Icon(
                  Icons.notifications,
                  color: Colors.black,
                )
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Good Morning',
                style: tsOneTextTheme.labelMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: TsOneColor.onSecondary,
                    size: 32,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sunday',
                        style: tsOneTextTheme.labelSmall,
                      ),
                      Text(
                        '18 June 2023',
                        style: tsOneTextTheme.labelSmall,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SearchComponent(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assessment',
                    style: tsOneTextTheme.headlineLarge,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, NamedRoute.newAssessmentCandidate);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: TsOneColor.primary,
                    ),
                    label: const Text('New Assessment'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: TsOneColor.primary),
                      backgroundColor: TsOneColor.onPrimary,
                    ),
                  )
                ],
              ),
            )

            // DONT REMOVE - PILOT HOME
            // Padding(
            //   padding: const EdgeInsets.only(top: 20, bottom: 10),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       'Need Confirmations',
            //       style: tsOneTextTheme.headlineSmall,
            //     ),
            //   ),
            // ),
            // Card(
            //   color: TsOneColor.primary,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15)),
            //   child: const Padding(
            //     padding: EdgeInsets.all(15),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Date',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             ),
            //             Text(
            //               'Instructor ',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             ),
            //             Text(
            //               'Assessment ID',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             )
            //           ],
            //         ),
            //         Column(
            //           children: [
            //             Text(
            //               ':',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             ),
            //             Text(
            //               ':',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             ),
            //             Text(
            //               ':',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             )
            //           ],
            //         ),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               '31 January 2023',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             ),
            //             Text(
            //               'John Doe',
            //               style: TextStyle(color: TsOneColor.secondary),
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //             Text(
            //               '201412',
            //               style: TextStyle(color: TsOneColor.secondary),
            //             )
            //           ],
            //         ),
            //         Icon(
            //           Icons.chevron_right,
            //           color: TsOneColor.secondary,
            //           size: 48,
            //         )
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
