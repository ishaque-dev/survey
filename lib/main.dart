import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survey/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GHSSK Reunion 2007',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
          primary: Colors.tealAccent,
          surface: const Color(0xFF1E293B),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.tealAccent, width: 1.5),
          ),
          labelStyle: const TextStyle(color: Colors.tealAccent),
          prefixIconColor: Colors.tealAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: const Color(0xFF0F172A),
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            elevation: 8,
          ),
        ),
      ),
      home: const SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final List<String> _options = [
    'സൗഹൃദ സംഗമം', 'സൗഹൃദ കൂട്ടായ്മ', 'സ്മൃതി മധുരം', 'സ്മൃതി തീരം',
    'സ്മരണിക 2005-2007', 'സ്നേഹക്കൂട്', 'സഖിത്വം', 'വീണ്ടും ഒരിക്കൽ',
    'വർഷങ്ങൾക്ക് ശേഷം ഒരു ഒന്നന്നര വരവ്', 'വർഷങ്ങൾക്കുശേഷം, ഒരിക്കൽ കൂടി',
    'മെമ്മറീസ് 2007', 'മയിൽ‌പീലി', 'മനസ്സിലുണ്ടോ ആ പ്ലസ്ടു കാലം',
    'മധുരിക്കും പതിനേഴിൽ', 'മധുര സ്മരണകൾ', 'പ്രതിധ്വനി', 'പുന സംഗമം',
    'പിന്നിട്ട വഴികളിലെ മറക്കാത്ത ഓർമ്മകൾ', 'പഴയ ഓർമ്മകളുടെ ഒച്ചകൾ',
    'നോട്ട്ബുക്കും മഷിപേനയും', 'തിരികേ നിൻ അരികിൽ', 'തിരികെ തിരുമുറ്റത്ത്',
    'തിരികെ ക്ലാസ്സിലേക്ക്', 'തിരികെ -2005 -2007', 'തിരികെ', 'ചങ്ങാതിക്കൂട്ടം',
    'ക്ലാസ്സ്‌ റൂം കഥകൾ', 'ഓലപീപ്പി', 'ഓർമ്മച്ചെപ്പ് 2005-2007', 'ഓർമ്മച്ചെപ്പ്',
    'ഓർമ്മക്കൂട്', 'ഓർമ്മകളുടെ ഇടവഴി', 'ഓർമ്മകളുടെ ഇടനാഴി', 'ഓർമ്മകളിലൂടെ',
    'ഓർമ്മകളിൽ 2005-2007', 'ഓർമകളിലേക്ക് ഒരു മടക്കം', 'ഓർമ തണലിൽ ഒരിക്കൽ കൂടി',
    'ഒഴുകുകയായ് വീണ്ടും', 'ഏകത്ര', 'ഇന്നലെകളിലെക്ക്', 'ഇന്നലകളെ ഓർമ്മകൾ 2005-2007',
    'ഇന്നലകളിലൂടെ', 'ഇന്നലകളിൽ', 'ഇത്തിരി നേരം, ഒത്തിരി കാര്യം',
    'ഇങ്ങള് ബാ നമ്മുക്കു വൈബ് ആക്കാം', 'ആരവം.05-07', 'അങ്ങനെയൊരു അവധിക്കാലം',
    'Vicennia', 'വീണ്ടുമീ പുഷ്പവാടിയിൽ', 'Two Decades Of Memories',
    'Two Decades - 2007 Reunion', 'Together Again', 'Timeless Ties',
    'Time Machine', 'Then And Now', 'The Sophomores Of GHSSK', 'The Sequel',
    'The Second Generation', 'The Return', 'The Nostalgia Meet', 'The Lost Bell',
    'The Grand Return', 'The First Junior', 'The Bell Rings Again',
    'The 2007 Gathering', 'That Time.. That Form', 'Soulbound', 'Second Wave',
    'Rewind 2005.2007', 'Reunite 20', 'Re-Connect \'07', 'Plus 2❤️', 'Philautia',
    'Petals Come Together', 'ഓർമക്കൂട്ടിൽ ഒരുവട്ടം കൂടി', 'Old Is Gold',
    'Millennials\' Homecoming:Edition 2005-2007', 'Millennial Gen',
    'Millenials: Back To The Batch (2005-2007)', 'Millenial 2026',
    'Ice Cream Memories', 'Golden Reunion', 'Flashback 20 -', 'Rewind Plustwo',
    'Evergreen Memories', 'Era \'07 To Now....', 'Echoes Of 2007',
    'Crazy After 20 Years', 'Classroom ഡയറീസ്', 'Classmates 2.0', 'Chill Mode On',
    'Beyound Years', 'Bench Mark', 'Batchmate\'S Day', 'Batch 07: Unwind',
    'Back To The Hallways- 20 Year Re- Union', 'Back To The Bench',
    'Back To Schooldays', 'Back To GHSSK', 'Back To Bench.',
    'Back To Bench Buddies.....Chapter One', 'A Lot Of Things For A While',
    '90\'Kids', '20 Years Later – Epanénosi', '20 Years Later', 'ദേവദാരു പൂത്തകാലം',
    'ഒരുമ', 'അറിവോരം', 'ഞങ്ങൾ', 'Two decades one bond', 'Rewind20',
    'സ്നേഹപൂർവ്വം', 'ചേക്കേറും ചില്ല', 'ഒരുമയുടെ ഓർമ്മകൾ', 'ഒരു വട്ടം കൂടി'
  ];

  final Set<String> _selectedOptions = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  String? _verificationId;
  bool _otpSent = false;
  bool _isLoading = false;
  bool _showResults = false;

  void _onOptionSelected(bool selected, String option) {
    setState(() {
      if (selected) {
        if (_selectedOptions.length < 4) {
          _selectedOptions.add(option);
        } else {
          _showSnackBar('Limit reached! 4 options max.', isError: true);
        }
      } else {
        _selectedOptions.remove(option);
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: isError ? Colors.redAccent : Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your name.', isError: true);
      return;
    }
    if (_selectedOptions.length != 4) {
      _showSnackBar('Please select exactly 4 options.', isError: true);
      return;
    }

    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.length == 10) phoneNumber = '+91$phoneNumber';

    if (phoneNumber.length < 12 || !phoneNumber.startsWith('+')) {
      _showSnackBar('Enter a valid 10-digit phone number.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userDoc = await FirebaseFirestore.instance.collection('survey_responses').doc(phoneNumber).get();
      if (userDoc.exists) {
        setState(() => _isLoading = false);
        _showSnackBar('This phone number has already voted!', isError: true);
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _saveData(phoneNumber);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          _showSnackBar('Verification failed: ${e.message}', isError: true);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _isLoading = false;
          });
          _showSnackBar('OTP code sent to $phoneNumber');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error: $e', isError: true);
    }
  }

  Future<void> _verifyOtp() async {
    if (_verificationId == null || _otpController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      String phoneNumber = _phoneController.text.trim();
      if (phoneNumber.length == 10) phoneNumber = '+91$phoneNumber';
      _saveData(phoneNumber);
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Invalid OTP code.', isError: true);
    }
  }

  Future<void> _saveData(String phoneNumber) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final String name = _nameController.text.trim();
      
      final responseRef = FirebaseFirestore.instance.collection('survey_responses').doc(phoneNumber);
      batch.set(responseRef, {
        'name': name,
        'selected_options': _selectedOptions.toList(),
        'phone': phoneNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });

      for (String option in _selectedOptions) {
        final optionRef = FirebaseFirestore.instance.collection('options').doc(option);
        batch.set(optionRef, {
          'count': FieldValue.increment(1),
        }, SetOptions(merge: true));

        final voterInOptionRef = optionRef.collection('voters').doc(phoneNumber);
        batch.set(voterInOptionRef, {
          'name': name,
          'phone': phoneNumber,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _selectedOptions.clear();
          _otpSent = false;
          _phoneController.clear();
          _otpController.clear();
          _nameController.clear();
          _showResults = true;
        });
        _showSnackBar('Success! Your vote is counted.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Save failed: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(theme),
                Expanded(
                  child: isWide ? _buildWideLayout(theme) : _buildMobileLayout(theme),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.tealAccent, size: 32),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GHSSK 2007',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  ),
                  Text(
                    'NAMING SURVEY',
                    style: TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
          if (!isWide)
            TextButton(
              onPressed: () => setState(() => _showResults = !_showResults),
              child: Text(
                _showResults ? 'VOTE NOW' : 'LIVE STATUS',
                style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildSurveyContent(theme),
          ),
        ),
        VerticalDivider(width: 1, color: Colors.white.withOpacity(0.1)),
        Expanded(
          flex: 1,
          child: _buildResultsView(theme, showTotal: true),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return _showResults 
      ? _buildResultsView(theme, showTotal: true) 
      : SingleChildScrollView(padding: const EdgeInsets.all(20), child: _buildSurveyContent(theme));
  }

  Widget _buildSurveyContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pick your 4 favorites', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${_selectedOptions.length} / 4', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _options.length,
          itemBuilder: (context, index) {
            final option = _options[index];
            final isSelected = _selectedOptions.contains(option);
            return GestureDetector(
              onTap: () => _onOptionSelected(!isSelected, option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.tealAccent : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
        ),
        const SizedBox(height: 16),
        if (!_otpSent) ...[
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number', prefixText: '+91 ',),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendOtp,
            child: const Text('SUBMIT & SEND OTP'),
          ),
        ] else ...[
          TextField(
            controller: _otpController,
            decoration: const InputDecoration(labelText: 'Verification Code', prefixIcon: Icon(Icons.lock_outline)),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            child: const Text('VERIFY & VOTE'),
          ),
        ],
        const SizedBox(height: 40),
        const Center(
          child: Column(
            children: [
              Text(
                'Created with ❤️ by Ishaque',
                style: TextStyle(color: Colors.white30, fontSize: 12, letterSpacing: 0.5),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsView(ThemeData theme, {bool showTotal = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('survey_responses').snapshots(),
      builder: (context, votersSnapshot) {
        final totalVoters = votersSnapshot.hasData ? votersSnapshot.data!.docs.length : 0;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('options').snapshots(),
          builder: (context, optionsSnapshot) {
            if (!optionsSnapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));

            final docs = optionsSnapshot.data!.docs;
            final sortedDocs = docs.toList()
              ..sort((a, b) {
                final aData = a.data() as Map<String, dynamic>;
                final bData = b.data() as Map<String, dynamic>;
                return (bData['count'] ?? 0).compareTo(aData['count'] ?? 0);
              });

            final int maxCount = sortedDocs.isNotEmpty ? (sortedDocs.first.data() as Map<String, dynamic>)['count'] ?? 1 : 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Live Status', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      if (showTotal)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            value: totalVoters / 189,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            color: Colors.tealAccent,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${totalVoters.toInt()}',
                              style: const TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.tealAccent,
                                height: 1.1,
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 1.5,
                              color: Colors.blue,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                            ),
                            const Text(
                              '189',
                              style: TextStyle(
                                fontSize: 11, 
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: sortedDocs.length,
                    itemBuilder: (context, index) {
                      final doc = sortedDocs[index];
                      final name = doc.id;
                      final count = (doc.data() as Map<String, dynamic>)['count'] ?? 0;
                      final double progress = maxCount > 0 ? count / maxCount : 0;
                      final double percentage = totalVoters > 0 ? (count / totalVoters) * 100 : 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                                Text('$count', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              children: [
                                Container(height: 6, width: double.infinity, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(3))),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      height: 6,
                                      width: constraints.maxWidth * progress,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Color(0xFF0D9488), Colors.tealAccent]),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('${percentage.toStringAsFixed(1)}% of voters chose this', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Created with ❤️ by Ishaque',
                    style: TextStyle(color: Colors.white30, fontSize: 10, letterSpacing: 0.5),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
