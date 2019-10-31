import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = ('/edit-profile-screen');

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _profileData = {
    'email': '',
    'street': '',
    'city': '',
    'postcode': '',
    'displayName': '',
  };

  // final _emailController = TextEditingController();
  // final _streetController = TextEditingController();
  // final _cityController = TextEditingController();
  // final _postcodeController = TextEditingController();
  // final _displayNameController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(46.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Username',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            DisplayNameStreamBuilder(auth: auth),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Username'),
                              content: TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Firstname'),
                                autovalidate: true,
                                onChanged: (value) {
                                  _profileData['displayName'] = value.trim();
                                },
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    try {
                                      await Firestore.instance
                                          .collection('users')
                                          .document(auth.userId)
                                          .updateData(
                                        {
                                          'displayName':
                                              _profileData['displayName'],
                                        },
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      print(e);
                                      _showErrorDialog(e);
                                    }
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Address',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            AddressStreamBuilder(auth: auth),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Address'),
                              content: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                child: Column(children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Street address'),
                                    autovalidate: true,
                                    onChanged: (value) {
                                      _profileData['street'] = value.trim();
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(hintText: 'City'),
                                    autovalidate: true,
                                    onChanged: (value) {
                                      _profileData['city'] = value.trim();
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(hintText: 'Postcode'),
                                    autovalidate: true,
                                    onChanged: (value) {
                                      _profileData['postcode'] = value.trim();
                                    },
                                  ),
                                ]),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    try {
                                      await Firestore.instance
                                          .collection('users')
                                          .document(auth.userId)
                                          .updateData(
                                        {
                                          'address.street':
                                              _profileData['street'],
                                          'address.city': _profileData['city'],
                                          'address.postcode':
                                              _profileData['postcode'],
                                        },
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Email',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            EmailStreamBuilder(auth: auth),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Email'),
                              content: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'username@url.com'),
                                autovalidate: true,
                                onChanged: (value) {
                                  _profileData['email'] = value.trim();
                                },
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    try {
                                      await Firestore.instance
                                          .collection('users')
                                          .document(auth.userId)
                                          .updateData(
                                        {
                                          'email': _profileData['email'],
                                        },
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmailStreamBuilder extends StatelessWidget {
  const EmailStreamBuilder({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(auth.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.waiting:
            return Text('');
          case ConnectionState.active:
            return Text('${snapshot.data['email']}',
                style: TextStyle(fontSize: 16));
          case ConnectionState.done:
            return Text('${snapshot.data['email']}',
                style: TextStyle(fontSize: 16));
        }
        return null;
      },
    );
  }
}

class AddressStreamBuilder extends StatelessWidget {
  const AddressStreamBuilder({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(auth.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text('');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.waiting:
            return Text('');
          case ConnectionState.active:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${snapshot.data['address']['street']}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${snapshot.data['address']['city']}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${snapshot.data['address']['postcode']}',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            );
          case ConnectionState.done:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${snapshot.data['address']['street']}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${snapshot.data['address']['city']}',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${snapshot.data['address']['postcode']}',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            );
        }
        return null;
      },
    );
  }
}

class DisplayNameStreamBuilder extends StatelessWidget {
  const DisplayNameStreamBuilder({
    Key key,
    @required this.auth,
  });

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(auth.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text('');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.waiting:
            return Text('');
          case ConnectionState.active:
            return Text('${snapshot.data['displayName']}',
                style: TextStyle(fontSize: 24));
          case ConnectionState.done:
            return Text('${snapshot.data['displayName']}',
                style: TextStyle(fontSize: 24));
        }
        return null;
      },
    );
  }
}
