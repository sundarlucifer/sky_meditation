import 'package:sky_meditation/services/auth_service.dart';
import 'package:sky_meditation/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const TAG = 'profile-screen';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMsg = '';

  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = authService.user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 20,
                  validator: (value) => value.isEmpty ? 'Enter Name' : null,
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 20.0),
                Text(_errorMsg, style: TextStyle(color: Colors.red)),
                OutlinedButton(
                  child: Container(
                    width: double.infinity,
                    child: Center(child: Text('Save Profile')),
                  ),
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit(context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    authService.updateDisplayName(_nameController.text).then((ref) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile saved')));
    });
  }
}
