import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../theme/app_theme.dart';
import '../widgets/neo_brutalist_container.dart';
import '../widgets/neo_brutalist_button.dart';
import '../models/budget_model.dart';
import '../models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  BudgetSettings _settings = BudgetSettings();
  List<TransactionModel> _transactions = [];
  final ImagePicker _picker = ImagePicker();
  double _milestone = 0.0;
  bool _milestoneHit = false;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('budget_settings');
    final transactionsJson = prefs.getStringList('budget_transactions');
    final profileJson = prefs.getString('user_profile');
    final milestoneHitStr = prefs.getBool('milestone_hit') ?? false;

    if (mounted) {
      setState(() {
        if (settingsJson != null) {
          _settings = BudgetSettings.fromJson(json.decode(settingsJson));
        }
        if (transactionsJson != null) {
          _transactions = transactionsJson.map((t) => TransactionModel.fromJson(json.decode(t))).toList();
        }
        if (profileJson != null && profileJson.isNotEmpty) {
          final profile = UserProfileModel.fromJson(json.decode(profileJson));
          _milestone = profile.budgetMilestone;
        }
        _milestoneHit = milestoneHitStr;
      });
      _checkMilestone();
    }
  }

  Future<void> _checkMilestone() async {
    if (_milestone > 0 && _currentBalance >= _milestone && !_milestoneHit) {
      _milestoneHit = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('milestone_hit', true);
      if (mounted) {
        _showGraffitiCongrats();
      }
    }
  }

  void _showGraffitiCongrats() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Transform.rotate(
            angle: -0.1,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFFF005C),
                border: Border.all(color: Colors.black, width: 6),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MILESTONE\\nHIT!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            const Shadow(color: Colors.black, offset: Offset(4, 4)),
                          ],
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'YOU REACHED ${_settings.currencySymbol}${_milestone.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('budget_settings', json.encode(_settings.toJson()));
    
    final tJson = _transactions.map((t) => json.encode(t.toJson())).toList();
    await prefs.setStringList('budget_transactions', tJson);
  }

  double get _totalSpent {
    return _transactions.where((t) => t.isExpense).fold(0.0, (sum, t) => sum + t.amount);
  }
  
  double get _totalIncome {
    return _transactions.where((t) => !t.isExpense).fold(0.0, (sum, t) => sum + t.amount);
  }

  double get _currentBalance {
    return _totalIncome - _totalSpent;
  }

  void _showSettingsDialog() {
    final budgetController = TextEditingController(text: _settings.monthlyBudget.toString());
    final dailyLimitController = TextEditingController(text: _settings.dailyLimit.toString());
    final monthlyLimitController = TextEditingController(text: _settings.monthlyLimit.toString());
    final currencyController = TextEditingController(text: _settings.currencySymbol);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.background,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
          title: Text('BUDGET SETTINGS', style: Theme.of(context).textTheme.headlineMedium),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currencyController,
                  decoration: const InputDecoration(labelText: 'Currency Symbol (e.g. ₹)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monthly Budget Goal', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dailyLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Daily Spending Limit', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: monthlyLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monthly Spending Limit', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            NeoBrutalistButton(
              onPressed: () {
                setState(() {
                  _settings.currencySymbol = currencyController.text;
                  _settings.monthlyBudget = double.tryParse(budgetController.text) ?? _settings.monthlyBudget;
                  _settings.dailyLimit = double.tryParse(dailyLimitController.text) ?? _settings.dailyLimit;
                  _settings.monthlyLimit = double.tryParse(monthlyLimitController.text) ?? _settings.monthlyLimit;
                });
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            )
          ],
        );
      },
    );
  }

  void _showTransactionDialog(bool isExpense) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    XFile? pickedPhoto;
    Uint8List? photoBytes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.background,
              shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
              title: Text(isExpense ? 'LOG EXPENSE' : 'LOG INCOME', 
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isExpense ? AppTheme.accent : AppTheme.primary
                )),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Amount (${_settings.currencySymbol})', 
                        border: const OutlineInputBorder()
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Note (Why was it spent/earned?)', 
                        border: OutlineInputBorder()
                      ),
                    ),
                    if (isExpense) ...[
                      const SizedBox(height: 16),
                      if (photoBytes != null) ...[
                        Image.memory(photoBytes!, height: 100, fit: BoxFit.cover),
                        const SizedBox(height: 8),
                      ],
                      OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Attach Photo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () async {
                          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            final bytes = await image.readAsBytes();
                            setDialogState(() {
                              pickedPhoto = image;
                              photoBytes = bytes;
                            });
                          }
                        },
                      ),
                    ]
                  ],
                ),
              ),
              actions: [
                NeoBrutalistButton(
                  backgroundColor: isExpense ? AppTheme.accent : AppTheme.primary,
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      setState(() {
                        _transactions.insert(0, TransactionModel(
                          id: DateTime.now().toString(),
                          amount: amount,
                          isExpense: isExpense,
                          note: noteController.text,
                          timestamp: DateTime.now(),
                          photoPath: pickedPhoto?.path,
                        ));
                      });
                        _saveBudget();
                        _checkMilestone();
                        Navigator.pop(context);
                    }
                  },
                  child: const Center(child: Text('ADD')),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showPhotoDialog(String note, String photoPath) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.background,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 3)),
          title: Text('RECEIPT', style: Theme.of(context).textTheme.headlineMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(note),
              const SizedBox(height: 16),
              // On web, path acts as a url to the blob object.
              Image.network(photoPath, fit: BoxFit.contain),
            ],
          ),
          actions: [
            NeoBrutalistButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isNegative = _currentBalance < 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'BUDGET',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),
          // Current Balance Card
          NeoBrutalistContainer(
            backgroundColor: isNegative ? AppTheme.accent : AppTheme.primary,
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT BALANCE',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_currentBalance < 0 ? '-' : ''}${_settings.currencySymbol}${_currentBalance.abs().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.black,
                              fontSize: 36,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: NeoBrutalistButton(
                  backgroundColor: AppTheme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  onPressed: () => _showTransactionDialog(true),
                  child: const Center(child: Text('- EXPENSE')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: NeoBrutalistButton(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  onPressed: () => _showTransactionDialog(false),
                  child: const Center(child: Text('+ INCOME')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),



          Text(
            'RECENT ACTIVITY',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),

          if (_transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text("NO TRANSACTIONS YET.")),
            ),

          for (var t in _transactions)
            GestureDetector(
              onTap: t.photoPath != null ? () => _showPhotoDialog(t.note, t.photoPath!) : null,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: NeoBrutalistContainer(
                  backgroundColor: AppTheme.surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.note.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM d, yyyy - h:mm a').format(t.timestamp),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white54,
                              ),
                            ),
                            if (t.photoPath != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.image, color: AppTheme.tertiary, size: 14),
                                  const SizedBox(width: 4),
                                  Text('VIEW RECEIPT', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.tertiary)),
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                      Text(
                        '${t.isExpense ? '-' : '+'}${_settings.currencySymbol}${t.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: t.isExpense ? AppTheme.accent : AppTheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
