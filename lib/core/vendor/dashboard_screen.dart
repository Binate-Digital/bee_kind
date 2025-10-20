import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:bee_kind/widgets/popular_products.dart';
import 'package:bee_kind/widgets/sales_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();
  late List<SalesData> weeklySalesData;

  @override
  void initState() {
    super.initState();
    _generateWeeklyData();
  }

  // ================== Month Navigation ==================
  void goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      _generateWeeklyData();
    });
  }

  void goToNextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      _generateWeeklyData();
    });
  }

  // ================== Generate Weekly Sales ==================
  void _generateWeeklyData() {
    final lastDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    );
    final totalDays = lastDayOfMonth.day;
    final weeks = (totalDays / 7).ceil();

    weeklySalesData = List.generate(weeks, (index) {
      final startDay = 1 + (index * 7);
      final endDay = (startDay + 6) > totalDays ? totalDays : (startDay + 6);

      final startDate = DateTime(
        _selectedMonth.year,
        _selectedMonth.month,
        startDay,
      );
      final endDate = DateTime(
        _selectedMonth.year,
        _selectedMonth.month,
        endDay,
      );

      final startLabel = DateFormat('MMM d').format(startDate);
      final endLabel = DateFormat('d').format(endDate);

      return SalesData(
        label: "Week ${index + 1}\n$startLabel–$endLabel",
        sales: (1000 + index * 300).toDouble(),
      );
    });
  }

  // ================== Generate Daily Sales (Accurate Date Range) ==================
  List<DailySalesData> _generateDailySalesData(DateTime start, DateTime end) {
    final days = <DailySalesData>[];
    final totalDays = end.difference(start).inDays + 1;

    for (int i = 0; i < totalDays; i++) {
      final current = start.add(Duration(days: i));
      final label =
          "${DateFormat('E').format(current)}\n${DateFormat('MMM d').format(current)}"; // 👈 e.g. Mon\nOct 1
      final sales = 500 + (current.day * 25) % 400; // mock pattern
      days.add(DailySalesData(label: label, sales: sales.toDouble()));
    }
    return days;
  }

  // ================== Parse Week Range (e.g. "Week 1\nOct 1–7") ==================
  List<DateTime> _extractDateRange(String weekLabel) {
    final parts = weekLabel.split('\n');
    if (parts.length < 2) return [];

    final rangePart = parts[1]; // e.g. "Oct 1–7"
    final monthName = rangePart.split(' ')[0]; // "Oct"

    final numbers = RegExp(
      r'\d+',
    ).allMatches(rangePart).map((m) => int.parse(m[0]!)).toList();

    if (numbers.isEmpty) return [];

    final startDay = numbers.first;
    final endDay = numbers.length > 1 ? numbers[1] : numbers[0];

    final year = _selectedMonth.year;
    final month = DateFormat('MMM').parse(monthName).month;

    final start = DateTime(year, month, startDay);
    final end = DateTime(year, month, endDay);
    return [start, end];
  }

  // ================== Show Daily Sales Modal ==================
  void _showDailySales(BuildContext context, SalesData weekData) {
    final dateRange = _extractDateRange(weekData.label);
    if (dateRange.isEmpty) return;

    final start = dateRange.first;
    final end = dateRange.last;

    final dailyData = _generateDailySalesData(start, end);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sales: ${DateFormat('MMM d').format(start)} – ${DateFormat('MMM d').format(end)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelRotation: -30,
                  labelStyle: const TextStyle(fontSize: 11),
                  majorGridLines: const MajorGridLines(width: 0.2),
                  axisLine: const AxisLine(width: 1),
                  majorTickLines: const MajorTickLines(size: 4),
                  labelIntersectAction: AxisLabelIntersectAction
                      .multipleRows, // ✅ stack labels if needed
                  labelPlacement: LabelPlacement.onTicks,
                  maximumLabels: 70, // ✅ allows more labels
                  arrangeByIndex: true,
                ),

                primaryYAxis: NumericAxis(
                  isVisible: true,
                  labelFormat: '\${value}',
                  axisLine: const AxisLine(width: 1),
                  majorGridLines: const MajorGridLines(width: 0.4),
                  majorTickLines: const MajorTickLines(size: 4),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<DailySalesData, String>>[
                  ColumnSeries<DailySalesData, String>(
                    dataSource: dailyData,
                    xValueMapper: (DailySalesData data, _) => data.label,
                    yValueMapper: (DailySalesData data, _) => data.sales,
                    borderRadius: BorderRadius.circular(8),
                    spacing: 0.4,
                    pointColorMapper: (_, __) => AppColors.yellow2,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      textStyle: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================== Helper: Add top padding to Y-axis ==================
  double getChartMaxY(List<SalesData> data) {
    final max = data.map((e) => e.sales).reduce((a, b) => a > b ? a : b);
    return max + (max * 0.2);
  }

  // ================== Build Chart UI ==================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          20,
          0,
          MediaQuery.of(context).viewInsets.bottom +
              20, // 👈 keeps clear of nav bar
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Month Navigation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: goToPreviousMonth,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: AppColors.yellow2,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedMonth),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: goToNextMonth,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 25,
                      color: AppColors.yellow2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Weekly Sales Chart
              SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelRotation: -35,
                  labelStyle: const TextStyle(fontSize: 12),
                  majorGridLines: const MajorGridLines(width: 0.5),
                  axisLine: const AxisLine(width: 1),
                  majorTickLines: const MajorTickLines(size: 4),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: true,
                  labelFormat: '\${value}',
                  majorGridLines: const MajorGridLines(width: 0.4),
                  axisLine: const AxisLine(width: 1),
                  maximum: getChartMaxY(weeklySalesData),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),

                series: <CartesianSeries<SalesData, String>>[
                  ColumnSeries<SalesData, String>(
                    dataSource: weeklySalesData,
                    xValueMapper: (SalesData data, _) => data.label,
                    yValueMapper: (SalesData data, _) => data.sales,
                    borderRadius: BorderRadius.circular(8),
                    spacing: 0.3,
                    pointColorMapper: (_, __) => AppColors.yellow2,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.outer,
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPointTap: (ChartPointDetails details) {
                      final selectedWeek = weeklySalesData[details.pointIndex!];
                      _showDailySales(context, selectedWeek);
                    },
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SalesInfo(heading: "Total Sales", text: "\$1250.00"),
                  SalesInfo(heading: "Revenue", text: "\$1250.00"),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SalesInfo(heading: "Pending Orders", text: "145"),
                  SalesInfo(heading: "Completed Orders", text: "523"),
                ],
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    CustomText(
                      text: "Popular Products",
                      fontSize: 18.sp,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                itemCount: 3,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Products();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== Data Models ==================
class SalesData {
  final String label;
  final double sales;
  SalesData({required this.label, required this.sales});
}

class DailySalesData {
  final String label;
  final double sales;
  DailySalesData({required this.label, required this.sales});
}
