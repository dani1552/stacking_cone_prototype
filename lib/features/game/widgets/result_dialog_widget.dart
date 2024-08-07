import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacking_cone_prototype/features/game/view_model/cone_stacking_game_vm.dart';
import 'package:stacking_cone_prototype/features/game/view_model/game_record_vm.dart';
import 'package:stacking_cone_prototype/features/game_select/view/game_select_screen.dart';
import 'package:stacking_cone_prototype/features/game_select/view_model/game_config_vm.dart';
import 'package:stacking_cone_prototype/features/home/view/main_scaffold.dart';
import 'package:stacking_cone_prototype/features/staff/view_model/selected_patient_view_model.dart';
import 'package:stacking_cone_prototype/services/bluetooth_service/view_models/bluetooth_service.dart';
import 'package:stacking_cone_prototype/services/database/models/game_record_model.dart';
import 'package:stacking_cone_prototype/services/database/models/patient_model.dart';
import '../../../services/timer/timer_service.dart';

class ResultDialog extends ConsumerWidget {
  final Widget screenName;
  final int totalCone;
  final int answer;
  final int mode;
  GameRecordModel record;

  ResultDialog({
    Key? key,
    required this.answer,
    required this.totalCone,
    required this.screenName,
    required this.record,
    required this.mode,
  }) : super(key: key);

  void getTrainGameRecore(WidgetRef ref) {
    DateTime dateTime = DateTime.now();
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    record = GameRecordModel(
      id: null,
      totalCone: totalCone,
      patientId: selectedPatient.id!,
      answerCone: answer,
      wrongCong: totalCone - answer,
      totalTime: ref.watch(timerControllerProvider).time,
      date: dateTime.microsecondsSinceEpoch,
      mode: mode,
      trainOrtest: ref.read(gameConfigProvider).isTest ? 1 : 0,
    );
  }

  void getTestGameRecore(WidgetRef ref) {
    DateTime dateTime = DateTime.now();
    PatientModel selectedPatient = ref
        .read(SelectedPatientViewModelProvider.notifier)
        .getSelectedPatient();
    record = GameRecordModel(
      id: null,
      totalCone: totalCone,
      patientId: selectedPatient.id!,
      answerCone: answer,
      wrongCong: totalCone - answer,
      totalTime: 60,
      date: dateTime.microsecondsSinceEpoch,
      mode: mode,
      trainOrtest: ref.read(gameConfigProvider).isTest ? 1 : 0,
    );
  }

  void onHomePressed(BuildContext context, WidgetRef ref) {
    if (ref.read(gameConfigProvider).isTest) {
      getTestGameRecore(ref);
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    } else {
      getTrainGameRecore(ref);
      ref.watch(gameRecordProvider.notifier).insertRecord(record);
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const MainScaffold(),
      ),
      (route) => true, // 현재 화면 닫기
    );
  }

  void onRestartPressed(BuildContext context, WidgetRef ref) {
    if (ref.watch(gameProvider).gameMode == "ConeStackingGame") {
      ref.read(gameProvider.notifier).startStackingGame();
    }
    if (ref.watch(gameProvider).gameMode == "SingleLedGame") {
      ref.read(gameProvider.notifier).startStackingGame();
    }
    ref
        .read(bluetoothServiceProvider.notifier)
        .onSendData(ref.watch(gameProvider).gameRule);
    Navigator.pop(context);
    if (ref.watch(gameConfigProvider).isTest) {
      ref.read(timerControllerProvider.notifier).startTestTimer();
    } else {
      ref.read(timerControllerProvider.notifier).startTimer();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int score = 0;
    if (record.answerCone != 0 && record.totalCone != 0) {
      score = (record.answerCone / record.totalCone * 100).toInt();
    } else {
      score = 0;
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xff332F23), width: 5.0),
      ),
      title: const Text(
        '게임 결과',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xff332F23),
          fontWeight: FontWeight.w300,
          fontSize: 28,
        ),
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 30),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '전체 점수 : $score점',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${record.answerCone} / ${record.totalCone}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff332F23),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              height: 40,
              child: TextButton(
                onPressed: () => onHomePressed(context, ref),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.grey.shade400; // 눌렸을 때의 배경색
                      }
                      return const Color(0xfff0e5c8); // 기본 배경색
                    },
                  ),
                ),
                child: const Text(
                  '나가기',
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 110,
              height: 40,
              child: TextButton(
                onPressed: () => onRestartPressed(context, ref),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.grey.shade400; // 눌렸을 때의 배경색
                      }
                      return const Color(0xfff0e5c8); // 기본 배경색
                    },
                  ),
                ),
                child: const Text(
                  '다시하기',
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
