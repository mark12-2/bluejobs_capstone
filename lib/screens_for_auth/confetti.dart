import 'package:bluejobs_capstone/provider/auth_provider.dart';
import 'package:bluejobs_capstone/screens_for_auth/signin.dart';
import 'package:bluejobs_capstone/styles/custom_button.dart';
import 'package:bluejobs_capstone/styles/responsive_utils.dart';
import 'package:bluejobs_capstone/styles/textstyle.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoneCreatePage extends StatefulWidget {
  const DoneCreatePage({super.key});

  @override
  State<DoneCreatePage> createState() => _DoneCreatePageState();
}

class _DoneCreatePageState extends State<DoneCreatePage> {
  final ConfettiController _confettiKey =
      ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiKey.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String role = ap.userModel.role;
    return ConfettiWidget(
        confettiController: _confettiKey,
        blastDirectionality: BlastDirectionality.explosive,
        colors: const [
          Colors.orange,
          Color.fromARGB(255, 7, 30, 47),
          Colors.white,
        ],
        child: Scaffold(
            appBar: AppBar(),
            body: Column(children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Welcome to BlueJobs_capstone!",
                        style: CustomTextStyle.titleText
                            .copyWith(fontSize: responsiveSize(context, 0.05))),
                  )),
              const SizedBox(
                height: 20,
              ),
              Text("You are one step closer...",
                  style: CustomTextStyle.titleText
                      .copyWith(fontSize: responsiveSize(context, 0.05))),
              const SizedBox(
                height: 20,
              ),
              Text("Check your email to verify your account before logging in.",
                  style: CustomTextStyle.titleText
                      .copyWith(fontSize: responsiveSize(context, 0.05))),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListBody(
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      buttonText: 'Proceed to Log In',
                    ),
                  ],
                ),
              )
            ])));
  }
}
