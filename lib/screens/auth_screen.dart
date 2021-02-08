import 'package:doku_maker/exceptions/auth_exception.dart';
import 'package:doku_maker/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Authentication Failed'),
        content: Column(
          children: [
            Text(message),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .logIn(_authData['username'], _authData['password']);
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Could not Authenticate');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DOKU MAKER',
                style: TextStyle(fontSize: 28),
              ),
              Image.asset('assets/img/logg_er-logo.png'),
              Text(
                'Melde dich mit deinem FH-Wedel Account an!',
                style: TextStyle(fontSize: 18),
              ),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Matrikelnummer'),
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _authData['username'] = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          controller: _passwordController,
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                          onEditingComplete: _submit,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                              child: Text('LOGIN'),
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).accentColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                              )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
