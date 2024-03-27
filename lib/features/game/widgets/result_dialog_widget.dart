import 'package:flutter/material.dart';

class ResultDialogWidget {
  late BuildContext context;
  final Widget screenName;
  final int totalCone;
  final int answer;
  late int score;

  ResultDialogWidget({
    required this.answer,
    required this.totalCone,
    required this.screenName,
  });

  void onHomePressed(BuildContext context) {
    Navigator.of(context).pop(); // 다이얼로그 닫기
    Navigator.of(context).pop(); // 현재 화면 닫기
  }

  void onContinuePressed(BuildContext context) {
    Navigator.of(context).pop(); // 다이얼로그 닫기
    Navigator.of(context).pop(); // 게임 화면 닫기
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenName,
      ),
    );
  }

  resultDialog(BuildContext context) {
    score = (answer / totalCone * 100).toInt();
    return showDialog(
      context: context,
      builder: (context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(
                height: 5,
              ),
              Text(
                '전체 콘 개수 : $totalCone개',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff332F23),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '맞게 올린 콘 : $answer개',
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
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xffF0E5C8),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
                        side: const BorderSide(
                          color: Color(0xFF332F23), // 테두리 색상
                          width: 3.0, // 테두리 두께
                        ),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      const Size(110, 20),
                    ),
                  ),
                  onPressed: () => onHomePressed(context),
                  child: const Text(
                    '나가기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xffF0E5C8),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // 버튼의 모서리를 둥글게 만듦
                        side: const BorderSide(
                          color: Color(0xFF332F23), // 테두리 색상
                          width: 3.0, // 테두리 두께
                        ),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      const Size(110, 20),
                    ),
                  ),
                  onPressed: () => onContinuePressed(context),
                  child: const Text(
                    '다시하기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
