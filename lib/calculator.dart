import 'package:flutter/material.dart';
import 'dart:math';

class ScientificCalculator extends StatefulWidget {
  @override
  _ScientificCalculatorState createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  String text = '0';
  double numOne = 0;
  double numTwo = 0;
  dynamic result = '';
  dynamic finalResult = '0';
  dynamic opr = '';
  dynamic preOpr = '';

  // Button Widget
  Widget calcButton(String btnText, Color btnColor, Color textColor, {double buttonSize = 65}) {
    return Container(
      height: buttonSize,
      width: btnText == '0' ? buttonSize * 1 + 2 : buttonSize, // Adjust size for '0' button
      child: ElevatedButton(
        onPressed: () {
          calculation(btnText);
        },
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: btnText == '0' ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)) : CircleBorder(),
          backgroundColor: btnColor,
          padding: EdgeInsets.all(btnText == '0' ? 20 : 15), // Adjust padding for '0' button
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Scientific Calculator'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('sin', Colors.blueGrey, Colors.white),
                  calcButton('cos', Colors.blueGrey, Colors.white),
                  calcButton('tan', Colors.blueGrey, Colors.white),
                  calcButton('log', Colors.blueGrey, Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('√', Colors.blueGrey, Colors.white),
                  calcButton('^', Colors.blueGrey, Colors.white),
                  calcButton('π', Colors.blueGrey, Colors.white),
                  calcButton('e', Colors.blueGrey, Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('AC', Colors.grey, Colors.black),
                  calcButton('+/-', Colors.grey, Colors.black),
                  calcButton('%', Colors.grey, Colors.black),
                  calcButton('/', Colors.amber[700]!, Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('7', Colors.grey[850]!, Colors.white),
                  calcButton('8', Colors.grey[850]!, Colors.white),
                  calcButton('9', Colors.grey[850]!, Colors.white),
                  calcButton('x', Colors.amber[700]!, Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('4', Colors.grey[850]!, Colors.white),
                  calcButton('5', Colors.grey[850]!, Colors.white),
                  calcButton('6', Colors.grey[850]!, Colors.white),
                  calcButton('-', Colors.amber[700]!, Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  calcButton('1', Colors.grey[850]!, Colors.white),
                  calcButton('2', Colors.grey[850]!, Colors.white),
                  calcButton('3', Colors.grey[850]!, Colors.white),
                  calcButton('+', Colors.amber[700]!, Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        calcButton('0', Colors.grey[850]!, Colors.white), // Larger size for '0'
                        SizedBox(width: 10),
                        calcButton('.', Colors.grey[850]!, Colors.white),
                        SizedBox(width: 10),
                        calcButton('DEL', Colors.grey[850]!, Colors.white),
                        SizedBox(width: 10),
                        calcButton('=', Colors.amber[700]!, Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void calculation(String btnText) {
    if (btnText == 'AC') {
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
    } else if (opr == '=' && btnText == '=') {
      if (preOpr == '+') {
        finalResult = add();
      } else if (preOpr == '-') {
        finalResult = sub();
      } else if (preOpr == 'x') {
        finalResult = mul();
      } else if (preOpr == '/') {
        finalResult = div();
      }
    } else if (btnText == '+' || btnText == '-' || btnText == 'x' || btnText == '/' || btnText == '=') {
      if (numOne == 0) {
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }

      if (opr == '+') {
        finalResult = add();
      } else if (opr == '-') {
        finalResult = sub();
      } else if (opr == 'x') {
        finalResult = mul();
      } else if (opr == '/') {
        finalResult = div();
      }
      preOpr = opr;
      opr = btnText;
      result = '';
    } else if (btnText == '%') {
      result = (numOne / 100).toString();
      finalResult = doesContainDecimal(result);
    } else if (btnText == '.') {
      if (!result.toString().contains('.')) {
        result = result.toString() + '.';
      }
      finalResult = result;
    } else if (btnText == '+/-') {
      result.toString().startsWith('-') ? result = result.toString().substring(1) : result = '-' + result.toString();
      finalResult = result;
    } else if (btnText == 'DEL') {
      result = result.isNotEmpty ? result.substring(0, result.length - 1) : result;
      finalResult = result.isEmpty ? '0' : result;
    } else if (btnText == 'sin' || btnText == 'cos' || btnText == 'tan' || btnText == 'log') {
      numOne = double.parse(result);
      if (btnText == 'sin') {
        result = sin(numOne * (pi / 180)).toString();
      } else if (btnText == 'cos') {
        result = cos(numOne * (pi / 180)).toString();
      } else if (btnText == 'tan') {
        result = tan(numOne * (pi / 180)).toString();
      } else if (btnText == 'log') {
        result = log(numOne).toString();
      }
      finalResult = doesContainDecimal(result);
    } else if (btnText == '√') {
      numOne = double.parse(result);
      result = sqrt(numOne).toString();
      finalResult = doesContainDecimal(result);
    } else if (btnText == '^') {
      if (opr == '^') {
        numTwo = double.parse(result);
        result = pow(numOne, numTwo).toString();
        finalResult = doesContainDecimal(result);
      } else {
        numOne = double.parse(result);
        opr = '^';
        result = '';
      }
    } else if (btnText == 'π') {
      result = pi.toString();
      finalResult = doesContainDecimal(result);
    } else if (btnText == 'e') {
      result = e.toString();
      finalResult = doesContainDecimal(result);
    } else {
      result = result + btnText;
      finalResult = result;
    }

    setState(() {
      text = finalResult;
    });
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String doesContainDecimal(dynamic result) {
    if (result.toString().contains('.')) {
      List<String> splitDecimal = result.toString().split('.');
      if (!(int.parse(splitDecimal[1]) > 0)) {
        return result = splitDecimal[0].toString();
      }
    }
    return result;
  }
}

void main() {
  runApp(MaterialApp(
    home: ScientificCalculator(),
  ));
}
