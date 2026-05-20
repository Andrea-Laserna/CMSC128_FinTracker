import 'package:flutter/material.dart';
import '../analytics/financial_insight_service.dart';
import '../analytics/widgets/analytics_bottom_sheet.dart';
import '../database/db_helper.dart';
import 'builders/designs/colors.dart';
import 'expense_model.dart';
import 'summary_helpers/category_style.dart';
import 'summary_helpers/summary_budget_service.dart';
import 'summary_helpers/summary_calculator.dart';
import 'summary_helpers/summary_date_utils.dart';
import 'summary_helpers/summary_enums.dart';
import 'summary_helpers/summary_periods.dart';
import 'summary_widgets/analyze_spending_button.dart';
import 'summary_widgets/chart_mode_toggle.dart';
import 'summary_widgets/comparison_chip.dart';
import 'summary_widgets/expense_bar_chart.dart';
import 'summary_widgets/expense_legend.dart';
import 'summary_widgets/expense_pie_chart.dart';
import 'summary_widgets/expense_tile.dart';
import 'summary_widgets/period_dropdown.dart';
import 'summary_widgets/summary_mode_toggle.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  List<Expense> _expenses = [];
  bool _isLoading = true;

  bool _isAnalyzing = false;
  final _service = FinancialInsightService();

  late DateTime _selectedWeek;
  late DateTime _selectedMonth;

  List<DateTime> _availableWeeks = [];
  List<DateTime> _availableMonths = [];

  SummaryMode _summaryMode = SummaryMode.weekly;
  ChartMode _chartMode = ChartMode.pie;

  double _periodBudget = 0.0;

  @override
  void initState() {
    super.initState();

    final now = SummaryDateUtils.cleanDate(DateTime.now());
    _selectedWeek = SummaryDateUtils.getStartOfWeek(now);
    _selectedMonth = DateTime(now.year, now.month, 1);

    loadExpensesFromDB();
  }

  Future<void> loadExpensesFromDB() async {
    final db = DBHelper();
    final data = await db.getAllExpenses();
    final periods = SummaryPeriods.generate(data);

    if (!mounted) return;
    setState(() {
      _expenses = data;
      _availableWeeks = periods.weeks;
      _availableMonths = periods.months;
      _isLoading = false;
    });

    await _loadBudgetFromPrefs();
  }

  Future<void> _loadBudgetFromPrefs() async {
    final convertedBudget = await SummaryBudgetService.getConvertedBudget(
      summaryMode: _summaryMode,
      start: _getCurrentPeriodStart(),
      end: _getCurrentPeriodEnd(),
    );

    if (!mounted) return;
    setState(() => _periodBudget = convertedBudget);
  }

  Future<void> _analyzeMyStanding() async {
    if (_isAnalyzing) return;
    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(milliseconds: 300));
    final result = _service.detectBudgetRisk(_expenses);

    if (!mounted) return;
    setState(() => _isAnalyzing = false);
    await AnalyticsBottomSheet.show(context, result);
  }

  DateTime _getCurrentPeriodStart() {
    return _summaryMode == SummaryMode.weekly ? _selectedWeek : _selectedMonth;
  }

  DateTime _getCurrentPeriodEnd() {
    if (_summaryMode == SummaryMode.weekly) {
      return SummaryDateUtils.getEndOfWeek(_selectedWeek);
    }
    return SummaryDateUtils.getEndOfMonth(_selectedMonth);
  }

  DateTime _getPreviousPeriodStart() {
    if (_summaryMode == SummaryMode.weekly) {
      return _selectedWeek.subtract(const Duration(days: 7));
    }
    return DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
  }

  DateTime _getPreviousPeriodEnd() {
    final previousStart = _getPreviousPeriodStart();
    if (_summaryMode == SummaryMode.weekly) {
      return SummaryDateUtils.getEndOfWeek(previousStart);
    }
    return SummaryDateUtils.getEndOfMonth(previousStart);
  }

  Future<void> _changeSummaryMode(SummaryMode mode) async {
    setState(() => _summaryMode = mode);
    await _loadBudgetFromPrefs();
  }

  void _changePeriod(DateTime newPeriod) {
    setState(() {
      if (_summaryMode == SummaryMode.weekly) {
        _selectedWeek = newPeriod;
      } else {
        _selectedMonth = newPeriod;
      }
    });
  }

  Widget _buildSavingsCard(double amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Savings',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colorNavy,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '₱${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: colorBodyText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final summary = SummaryCalculator.calculate(
      expenses: _expenses,
      start: _getCurrentPeriodStart(),
      end: _getCurrentPeriodEnd(),
      previousStart: _getPreviousPeriodStart(),
      previousEnd: _getPreviousPeriodEnd(),
    );

    final isDataEmpty = summary.chartCategories.isEmpty;
    // (monthly budget/days in month) x days in week
    final savings = (_periodBudget - summary.total) < 0
      ? 0.0
      : (_periodBudget - summary.total).toDouble();

    return Scaffold(
      backgroundColor: colorPageBg,
      appBar: AppBar(
        backgroundColor: colorPageBg,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          _summaryMode == SummaryMode.weekly
              ? 'Weekly Expense'
              : 'Monthly Expense',
          style: TextStyle(
            color: colorNavy,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryModeToggle(
              selectedMode: _summaryMode,
              onChanged: _changeSummaryMode,
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSavingsCard(savings)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChartModeToggle(
                          selectedMode: _chartMode,
                          onChanged: (mode) => setState(() => _chartMode = mode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (_chartMode == ChartMode.pie)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ExpensePieChart(
                        categories: summary.chartCategories,
                               total: summary.chartTotal,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ExpenseBarChart(
                        expenses: _expenses,
                        start: summary.start,
                        end: summary.end,
                        periodBudget: _periodBudget,
                        summaryMode: _summaryMode,
                      ),
                    ),

                  const SizedBox(height: 16),
                  ComparisonChip(
                    currentTotal: summary.expenseTotal,
                    previousTotal: summary.previousExpenseTotal,
                    summaryMode: _summaryMode,
                  ),
                  const SizedBox(height: 14),
                  ExpenseLegend(
                    categories: summary.categories,
                           total: summary.chartTotal,
                  ),
                  const SizedBox(height: 18),
                  PeriodDropdown(
                    summaryMode: _summaryMode,
                    availableWeeks: _availableWeeks,
                    availableMonths: _availableMonths,
                    selectedWeek: _selectedWeek,
                    selectedMonth: _selectedMonth,
                    onChanged: _changePeriod,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: colorNavy.withOpacity(0.10),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 14),
                  AnalyzeSpendingButton(
                    isAnalyzing: _isAnalyzing,
                    isDisabled: _expenses.isEmpty,
                    onTap: _analyzeMyStanding,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Breakdown',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202124),
                  ),
                ),
                Text(
                  _summaryMode == SummaryMode.weekly
                      ? 'This week'
                      : 'This month',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...summary.categories.map(
              (category) => ExpenseTile(
                color: category.color,
                title: category.name,
                amount: category.amount,
                icon: CategoryStyle.getIcon(category.name),
                transactions: SummaryCalculator.transactionCountForCategory(
                  expenses: _expenses,
                  category: category.name,
                  start: summary.start,
                  end: summary.end,
                ),
              ),
            ),

            if (isDataEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    _summaryMode == SummaryMode.weekly
                        ? 'No expenses recorded for this week.'
                        : 'No expenses recorded for this month.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
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
