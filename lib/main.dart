import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int turn = 0;
  var totalState = List.generate(3, (i) => [0, 0, 0],
      growable: false); // 0: null , 1 : O , 2 : X

  int goalCheck() {
    //rowchecks
    for (int i = 0; i < 3; i += 1) {
      if ((totalState[i][0] != 0) &&
          (totalState[i][1] != 0) &&
          (totalState[i][2] != 0)) {
        if ((totalState[i][0] == totalState[i][1]) &&
            (totalState[i][1] == totalState[i][2])) {
          return totalState[i][0];
        }
      }
    }

    //column checks
    for (int i = 0; i < 3; i += 1) {
      if ((totalState[0][i] != 0) &&
          (totalState[1][i] != 0) &&
          (totalState[2][i] != 0)) {
        if ((totalState[0][i] == totalState[1][i]) &&
            (totalState[1][i] == totalState[2][i])) {
          return totalState[0][i];
        }
      }
    }

    //diagonal checks
    if ((totalState[0][0] != 0) &&
        (totalState[1][1] != 0) &&
        (totalState[2][2] != 0)) {
      if ((totalState[0][0] == totalState[1][1]) &&
          (totalState[1][1] == totalState[2][2])) {
        return totalState[0][0];
      }
    }

    if ((totalState[0][2] != 0) &&
        (totalState[1][1] != 0) &&
        (totalState[2][0] != 0)) {
      if ((totalState[0][2] == totalState[1][1]) &&
          (totalState[1][1] == totalState[2][0])) {
        return totalState[0][2];
      }
    }

    //draw check
    int cnt = 0;
    for (int i = 0; i < 3; i += 1) {
      for (int j = 0; j < 3; j += 1) {
        if (totalState[i][j] != 0) {
          cnt += 1;
        }
      }
    }
    print(cnt);
    if (cnt == 8) {
      print("draw");
      return 3;
    }

    return 0;
  }

  String check(int s) {
    if (s == 1) {
      return "O won";
    } else if (s == 2) {
      return "X won";
    } else {
      return "Draw";
    }
  }

  void setMystate(ind) {
    setState(() {
      turn == 0 ? turn = 1 : turn = 0;
      if (turn == 0) {
        totalState[ind ~/ 3][ind % 3] = 2;
      } else {
        totalState[ind ~/ 3][ind % 3] = 1;
      }
    });
    int res = goalCheck();
    if (res != 0) {
      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(check(res)),
              content: Text("Retry?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    totalState =
                        List.generate(3, (i) => [0, 0, 0], growable: false);
                    turn = 0;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  int getMyState(int ind) {
    return totalState[ind ~/ 3][ind % 3];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GridView.count(
            crossAxisCount: 3,
            children: List.generate(
                9,
                (index) => TicTile(
                      index: index,
                      setMystate: this.setMystate,
                      getMyState: this.getMyState,
                    )),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true),
        Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Text(
              turn != 0 ? "X's turn" : "O's turn",
              style: TextStyle(fontSize: 30.0),
            )),
      ]),
    );
  }
}

class TicTile extends StatefulWidget {
  final Function(int) getMyState;
  final int index;
  final Function(int) setMystate;

  TicTile(
      {@required this.index,
      @required this.setMystate,
      @required this.getMyState});

  @override
  _TicTileState createState() => _TicTileState();
}

class _TicTileState extends State<TicTile> {
  void changeState() {
    int state = widget.getMyState(widget.index);
    if (state == 0) {
      widget.setMystate(widget.index);
    }
  }

  Icon iconChanger() {
    int state = widget.getMyState(widget.index);
    if (state == 0) {
      return Icon(null);
    } else if (state == 1) {
      return Icon(
        Icons.circle,
        size: 50.0,
      );
    } else {
      return Icon(
        Icons.cancel_outlined,
        size: 50.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: iconChanger(),
      onPressed: changeState,
    );
  }
}
