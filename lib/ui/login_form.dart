import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vasitionary/bloc/authentication/auth.dart';
import 'package:vasitionary/bloc/authentication/auth_event.dart';
import 'package:vasitionary/bloc/login/login.dart';
import 'package:vasitionary/bloc/login/login_event.dart';
import 'package:vasitionary/bloc/login/login_state.dart';
import 'package:vasitionary/helper/constants.dart';
import 'package:vasitionary/model/user_repository.dart';

import 'login_create_account.dart';
import 'google_login_button.dart';
import 'login_button.dart';
import 'package:vasitionary/main.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginBloc _loginBloc;
  bool passwordVisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }


  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    final emailFocus = FocusNode();
    final passwordFocus = FocusNode();
    //final emailField = ;
    //final passwordField = ;
    return BlocListener(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(HINT_LOGIN_FAILED), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(HINT_LOGGIN_IN),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Form(
              child: ListView(
                children: <Widget>[
                  /*
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/images/logo.gif', height: 200),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0,right: 60.0,top: 10.0,bottom:10.0),
                          child: LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GoogleLoginButton(),
                        CreateAccountButton(userRepository: _userRepository),
                      ],
                    ),
                  ),*/

                  Stack(
                    children: <Widget>[
                      Container(
                          height: 300.0,
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Colors.transparent,
                                  width: 5.0,
                                  style: BorderStyle.solid),
                              borderRadius: new BorderRadius.only(
                                  bottomLeft: Radius.circular(90.0)),
                              image: new DecorationImage(
                                image: new AssetImage(
                                    'assets/images/app_background.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.0),
                                    BlendMode.multiply),
                              )))
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Stack(
                      children: <Widget>[
                        Card(
                          elevation: 40.0,
                          margin: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 60.0,
                                ),
                                Material(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0,
                                          right: 40.0,
                                          top: PADDING_REGULAR_10,
                                          bottom: PADDING_REGULAR_10),
                                      child: TextFormField(
                                        controller: _emailController,
                                        autofocus: false,
                                        focusNode: emailFocus,
                                        enabled: true,
                                        maxLines: 1,
                                        maxLength: 30,
                                        autovalidate: true,
                                        autocorrect: false,
                                        validator: (_) {
                                          return !state.isEmailValid
                                              ? HINT_INVALID_EMAIL
                                              : null;
                                        },
                                        textInputAction: TextInputAction.next,
                                        style: style,
                                        onFieldSubmitted: (v) {
                                          //_fieldFocusChange(context,emailFocus,passwordFocus);
                                        },
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.lightGreen,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabled: true,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.lightGreen,
                                                  width: 2.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.transparent,
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Colors.lightGreen,
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            hintText: HINT_EMAIL,
                                            counterText: "",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                      ),
                                    )),
                                Material(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0,
                                          right: 40.0,
                                          top: PADDING_REGULAR_10,
                                          bottom: PADDING_REGULAR_10),
                                      child: TextFormField(
                                        autofocus: false,
                                        focusNode: passwordFocus,
                                        onFieldSubmitted: (v) {
                                          //_fieldFocusChange(context,emailFocus,passwordFocus);
                                        },
                                        maxLines: MAX_LINES,
                                        maxLength: MAX_CHAR_COUNT,
                                        obscureText: passwordVisible,
                                        style: style,
                                        textInputAction: TextInputAction.done,
                                        controller: _passwordController,
                                        autovalidate: true,
                                        autocorrect: false,
                                        validator: (_) {
                                          return !state.isPasswordValid
                                              ? HINT_INVALID_PASSWORD
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.lightGreen,
                                                  width: RADIUS_2),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.lightGreen,
                                                  width: RADIUS_2),
                                            ),
                                            enabled: true,
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.lightGreen,
                                            ),
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  passwordVisible
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: Colors.lightGreen,
                                                ),
                                                onPressed: () {
                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                  setState(() {
                                                    passwordVisible =
                                                        !passwordVisible;
                                                  });
                                                }),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                PADDING_REGULAR_20, PADDING_REGULAR_15, PADDING_REGULAR_20, PADDING_REGULAR_15),
                                            hintText: HINT_PASSWORD,
                                            counterText: "",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(RADIUS_5),
                                            )),
                                      ),
                                    )),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: CreateAccountButton(userRepository: _userRepository)),
                                    SizedBox(
                                      width: 50.0,
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: ()=>{
                                            //Forgot Password clicked
                                          _onResetEmail(),
                                          },
                                          child: Text(
                                            TITLE_FORGOT_PASSWORD,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: FONT_SIZE_REGULAR_12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                LoginButton(
                                  onPressed: isLoginButtonEnabled(state)
                                      ? _onFormSubmitted
                                      : null,
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                              ]),
                        ),
                        FractionalTranslation(
                          translation: Offset(0.0, -0.4),
                          child: Align(
                            child: CircleAvatar(
                                backgroundColor: COLOR_WHITE,
                                radius: RADIUS_SMALL_CIRCLE,
                                child: ClipOval(
                                  child: Image(
                                    image: new AssetImage(
                                        "assets/images/logo.gif"),
                                    fit: BoxFit.scaleDown,
                                  ),
                                )),
                            alignment: FractionalOffset(0.5, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          HINT_SOCIAL_LOGIN,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(child: GoogleLoginButton()),
                        ),
                        /*Center(
                          child: Container(
                            child: RaisedButton(
                              elevation: 40.0,
                              color: Colors.white,
                              splashColor: Colors.amberAccent,
                              onPressed: () {
                                //do nothing
                              },
                              shape: CircleBorder(
                                side: BorderSide(style: BorderStyle.none),
                              ),
                              child: Center(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(PADDING_REGULAR_20),
                                  child: Icon(
                                    FontAwesomeIcons.facebookF,
                                    color: Color.fromRGBO(59, 89, 152, 1.0),
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                      ]),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _onResetEmail(){
    if(_emailController.text.length> 0) {
     /* _loginBloc.dispatch(
        ResetEmailPassword(
          email: _emailController.text,
        ),
      );*/
      _userRepository.sendPasswordResetEmail(_emailController.text);
    }else{
      //Please enter a valid email
    }
  }
}