import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:my_stock/UI/LoginPage/Login_Page.dart';
import 'package:my_stock/bloc/blocks/user_bloc_provider.dart';
import 'package:my_stock/main.dart';
import 'package:my_stock/models/classes/user.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Registrese"),
      ),
      body: const SignUpPageForm(),
    );
  }
}

class SignUpPageForm extends StatefulWidget {
  const SignUpPageForm({Key key}) : super(key: key);

  @override
  SignUpPageFormState createState() => SignUpPageFormState();
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.restorationId,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
  });

  final String restorationId;
  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
  final RestorableBool _obscureText = RestorableBool(true);

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      //restorationId: 'password_text_field',
      obscureText: _obscureText.value,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText.value = !_obscureText.value;
            });
          },
          child: Icon(
            _obscureText.value ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}

class SignUpPageFormState extends State<SignUpPageForm> with RestorationMixin {
  User person;
  UserBloc userBloc;

  FocusNode _firstname,
      _lastname,
      _username,
      _phoneNumber,
      _email,
      _password,
      _retypePassword;

  @override
  void initState() {
    super.initState();
    _firstname = FocusNode();
    _lastname = FocusNode();
    _username = FocusNode();
    _phoneNumber = FocusNode();
    _email = FocusNode();
    _password = FocusNode();
    _retypePassword = FocusNode();
  }

  @override
  void dispose() {
    _firstname = FocusNode();
    _lastname = FocusNode();
    _username = FocusNode();
    _phoneNumber = FocusNode();
    _email = FocusNode();
    _password = FocusNode();
    _retypePassword = FocusNode();
    super.dispose();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  @override
  String get restorationId => 'text_field_demo';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_autoValidateModeIndex, 'autovalidate_mode');
  }

  final RestorableInt _autoValidateModeIndex =
      RestorableInt(AutovalidateMode.disabled.index);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  /* final _ArNumberTextInputFormatter _phoneNumberFormatter =
      _ArNumberTextInputFormatter();
*/
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidateModeIndex.value =
          AutovalidateMode.always.index; // Start validating on every change.
      showInSnackBar(
        "Antes de enviar, corrige los errores marcados con rojo.",
      );
    } else {
      form.save();
      userBloc
          .registerUser(person.username, person.firstname, person.lastname,
              person.email, person.password, person.phone)
          .then((_) {
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      });
      /* showInSnackBar(GalleryLocalizations.of(context)
          .demoTextFieldNameHasPhoneNumber(person.firstname, person.phone)); */
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "El nombre es obligatorio.";
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Ingresa solo caracteres alfabéticos.";
    }
    return null;
  }

  String _validatePhoneNumber(String value) {
    final phoneExp = RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
    if (!phoneExp.hasMatch(value)) {
      return "(##) (##)####-#### - Ingresa un número de teléfono de AR.";
    }
    return null;
  }

  String _validatePassword(String value) {
    final passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return "Ingresa una contraseña.";
    }
    if (passwordField.value != value) {
      return "Las contraseñas no coinciden";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex.value],
      child: Scrollbar(
        child: SingleChildScrollView(
          restorationId: 'text_field_demo_scroll_view',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              sizedBoxSpace,
              TextFormField(
                //restorationId: 'name_field',
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.person),
                  hintText: "¿Como te llaman otras personas?",
                  labelText: "Nombre",
                ),
                onSaved: (value) {
                  person.firstname = value;
                  _firstname.requestFocus();
                },
                validator: _validateName,
              ),
              sizedBoxSpace,
              TextFormField(
                //restorationId: 'last_name',
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.person),
                  hintText: "¿Cual es tu appellido?",
                  labelText: "Apellido",
                ),
                onSaved: (value) {
                  person.firstname = value;
                  _lastname.requestFocus();
                },
                validator: _validateName,
              ),
              sizedBoxSpace,
              TextFormField(
                //restorationId: 'UserName',
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.person),
                  hintText: "Nombre de Usuario",
                  labelText: "Nombre de Usuario",
                ),
                onSaved: (value) {
                  person.username = value;
                  _username.requestFocus();
                },
                validator: _validateName,
              ),
              sizedBoxSpace,
              TextFormField(
                //restorationId: 'phone_number_field',
                textInputAction: TextInputAction.next,
                focusNode: _phoneNumber,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.phone),
                  hintText: "¿Cómo podemos comunicarnos contigo?",
                  labelText: "Número de teléfono*",
                  prefixText: '+(54) ',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  person.phone = value;
                  _phoneNumber.requestFocus();
                },
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                validator: _validatePhoneNumber,
                // TextInputFormatters are applied in sequence.
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  // Fit the validating format.
                  // _phoneNumberFormatter,
                ],
              ),
              sizedBoxSpace,
              TextFormField(
                //restorationId: 'email_field',
                textInputAction: TextInputAction.next,
                focusNode: _email,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.email),
                  hintText: "Tu dirección de correo electrónico",
                  labelText: "Correo electrónico",
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  person.email = value;
                  _email.requestFocus();
                },
              ),
              sizedBoxSpace,
              PasswordField(
                restorationId: 'password_field',
                textInputAction: TextInputAction.next,
                focusNode: _password,
                fieldKey: _passwordFieldKey,
                labelText: "Contraseña*",
                onFieldSubmitted: (value) {
                  setState(() {
                    person.password = value;
                    _retypePassword.requestFocus();
                  });
                },
              ),
              sizedBoxSpace,
              TextFormField(
                //restorationId: 'retype_password_field',
                focusNode: _retypePassword,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Vuelve a escribir la contraseña*",
                ),
                obscureText: true,
                validator: _validatePassword,
                onFieldSubmitted: (value) {
                  // _handleSubmitted();
                },
              ),
              sizedBoxSpace,
              Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _handleSubmitted,
                        child: Text("Enviar"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      newUser: false,
                                    )),
                          );
                        },
                        child: Text("Cancelar"),
                      ),
                    ],
                  ),
                ],
              ),
              sizedBoxSpace,
              Text(
                "El asterisco (*) indica que es un campo obligatorio",
                style: Theme.of(context).textTheme.caption,
              ),
              sizedBoxSpace,
            ],
          ),
        ),
      ),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##
/*class _ArNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 10) {
      newText.write(newValue.text.substring(5, usedSubstringIndex = 10) + '-');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    if (newTextLength >= 12) {
      newText.write(newValue.text.substring(8, usedSubstringIndex = 12) + ' ');
      if (newValue.selection.end >= 13) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}*/
