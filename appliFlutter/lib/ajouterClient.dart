import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';

class AjouterClient extends StatelessWidget {
  const AjouterClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[800],
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Ajouter client',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: FormPage());
  }
}

enum SingingCharacter { actif, inactif }

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  
  
  bool visible = false;
  final _formKey = GlobalKey<FormState>();

  SingingCharacter? _character = SingingCharacter.actif;

  String dropdownValue = 'Actif';
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              inputForm('Nom'),
              inputForm('Prenom'),
              inputForm('Adresse'),
              ListTile(
                title: const Text('Actif'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.actif,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Inactif'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.inactif,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState((){
                    visible = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Clients enregistrer')),
                      
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
  Widget inputForm(name) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name + ':',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 50,
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Champ vide !';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: name,
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
          ),
        ),
      ),
      Visibility(
        visible: visible,
        child: Text('OK')
        )
    ],
  );
}
}



/*  
Widget inputSelect() {
  String dropdownValue = 'One';
  return DropdownButton<String>(
    value: dropdownValue,
    icon: const Icon(Icons.arrow_downward),
    elevation: 16,
    style: const TextStyle(color: Colors.deepPurple),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    onChanged: (String? newValue) {
      setState(() {
        dropdownValue = newValue!;
      });
    },
    items: <String>['One', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}
*/

void setState(Null Function() param0) {}
