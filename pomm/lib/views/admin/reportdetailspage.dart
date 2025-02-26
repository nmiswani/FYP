import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportDetailsPage extends StatelessWidget {
  const ReportDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Sales Report",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Title for bar chart visualization
            Text(
              "Sales",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Shown in the bar chart below:",
              style: GoogleFonts.poppins(
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Bar chart visualization (dummy data)
            AspectRatio(
              aspectRatio: 1.5, // Adjust chart size
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  groupsSpace: 4,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        y: 50,
                        colors: Colors.accents,
                        width: 20,
                      )
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        y: 70,
                        colors: Colors.accents,
                        width: 20,
                      )
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                        y: 40,
                        colors: Colors.accents,
                        width: 20,
                      )
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(
                        y: 20,
                        colors: Colors.accents,
                        width: 20,
                      )
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(
                        y: 40,
                        colors: Colors.accents,
                        width: 20,
                      )
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Summary section in a card
            Card(
              color: const Color.fromARGB(248, 214, 227, 216),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Summary:",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "The sales have been steady with some fluctuations. "
                      "The highest sales were recorded with a total of RM2000. "
                      "Overall, there has been pattern of sales growth.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Print Button
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                margin: const EdgeInsets.only(top: 6),
                child: ElevatedButton(
                  onPressed: () {
                    // Dummy print action (replace with actual functionality)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Printing Report...")),
                    );
                    // Simulate a print action (use a package for real printing functionality)
                    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Print",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
