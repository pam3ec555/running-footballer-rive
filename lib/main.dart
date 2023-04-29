import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Running animation demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final rive.StateMachineController _stateMachineController;
  late final rive.SMITrigger _jumpTrigger;
  late final rive.SMIBool _isRunningFlag;
  bool _isArtboardLoaded = false;

  void _onInit(rive.Artboard art) {
    _stateMachineController =
        rive.StateMachineController.fromArtboard(art, 'State Machine 1')
            as rive.StateMachineController;
    _stateMachineController.isActive = true;
    art.addController(_stateMachineController);
    _jumpTrigger =
        _stateMachineController.findInput<bool>('Jump') as rive.SMITrigger;
    _isRunningFlag =
        _stateMachineController.findInput<bool>('IsRunning') as rive.SMIBool;
    setState(() {
      _isArtboardLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff081803),
      appBar: AppBar(
        title: const Text('Running animation'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Expanded(
                child: rive.RiveAnimation.asset(
                  'assets/rive/footballer.riv',
                  alignment: Alignment.topCenter,
                  onInit: _onInit,
                ),
              ),
              _isArtboardLoaded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _jumpTrigger.fire();
                              },
                              child: const Text('Jump'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _isRunningFlag.change(!_isRunningFlag.value);
                                setState(() {});
                              },
                              child:
                                  Text(_isRunningFlag.value ? 'Walk' : 'Run'),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}
