import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/animation/FadeAnimation.dart';
import 'package:food_ordering_app/models/ApiError.dart';
import 'package:food_ordering_app/models/ApiRespose.dart';
import 'package:food_ordering_app/models/User.dart';
import 'package:food_ordering_app/services/UserServices.dart';
import 'package:food_ordering_app/widgets/msgToast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController cusername = new TextEditingController();
  final TextEditingController cpassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            "登入",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.2,
                          Text(
                            "登入至您的帳戶",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                          1.2,
                          makeInput(
                            label: "帳戶名稱",
                            controller_val: cusername,
                          ),
                        ),
                        FadeAnimation(
                            1.3,
                            makeInput(
                              label: "密碼",
                              controller_val: cpassword,
                              obscureText: true,
                            )),
                      ],
                    ),
                  ),
                  FadeAnimation(
                      1.4,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              handleSubmitted(context);
                            },
                            color: Colors.greenAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "登入",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                  FadeAnimation(
                      1.5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("沒有帳戶嗎?"),
                          Text(
                            " 立即建立新帳戶!",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),

                          ),
                        ],
                      ))
                ],
              ),
            ),
            FadeAnimation(
              1.2,
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/restaurant.png'),
                        fit: BoxFit.cover)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, controller_val, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller_val,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void handleSubmitted(BuildContext context) async {
    UserServices userServices = new UserServices();
    ApiResponse _apiResponse =
        await userServices.login(cusername.text, cpassword.text);
    print(_apiResponse.ApiError);
    if ((_apiResponse.ApiError as ApiError) == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", (_apiResponse.Data as User).user_id);
      int isadminstored = (_apiResponse.Data as User).isAdmin;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loadDash',
        ModalRoute.withName('/loadDash'),
        arguments: isadminstored,
      );
      // }
    } else {
      msgToast("登入失敗!");
    }
  }
}
