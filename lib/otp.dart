import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
//import 'home.dart';
import 'package:otp_generator/home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  dynamic _confirmationResult;
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(child:Center(
            child: Text('Verify +91-${widget.phone}'),
          )),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              withCursor: true,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin)async{
                try{
                if (kIsWeb) {
                  UserCredential userCredential = await _confirmationResult.confirm(pin);
                  if(userCredential.user != null){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
                  }
                }
                else
                  {await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin))
                    .then((value) async{
                  if(value.user != null){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
                  }
                });}

                }catch(e){
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('invalid OTP')));
                }
              },
            ),
          ),
          ElevatedButton(onPressed: (){

          }, child: Text('Submit'))
        ],
      ),
    );
  }
  _verifyPhone() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential)async{
          await FirebaseAuth.instance.signInWithCredential(credential).then((value)  async{
            if(value.user != null){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String verificationID, int resendToken){
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID){
          setState(() {
            _verificationCode = verificationID;
          });
        },timeout:Duration(seconds:60));
  }
  _verifyPhoneOnWeb() async{
    ConfirmationResult confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber('+91${widget.phone}');
    setState(() {
      _confirmationResult = confirmationResult;
    });
  }
  @override
  void initState(){
    super.initState();
    if (kIsWeb) {
      // running on the web!
      _verifyPhoneOnWeb();
    } else {
      // NOT running on the web! You can check for additional platforms here.
      _verifyPhone();
    }
  }
}
