// import 'package:calculadora_imc/class/imc.dart';
import 'package:calculadora_imc_hive/model/imc_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:calculadora_imc/class/altura.dart';
// import 'package:calculadora_imc/class/peso.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculadora IMC 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _info = "Informe seus dados.";

  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  void _calcular() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(_myBox.get('altura')) / 100;
      double imc = peso / (altura * altura);
      debugPrint('$imc');
      if (imc < 18.6) {
        _info = 'Abaixo do Peso (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 18.6 && imc < 24.9) {
        _info = 'Peso Ideal (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        _info = 'Levemente Acima do Peso (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 29.9 && imc < 34.9) {
        _info = 'Obesidade Grau I (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 34.9 && imc < 39.9) {
        _info = 'Obesidade Grau II (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 40) {
        _info = 'Obesidade Grau III (${imc.toStringAsPrecision(3)})';
      }
      imcList.add(ImcModel(info: _info, imc: imc));
    });
  }

  final List<ImcModel> imcList = [
    ImcModel(info: 'Obesidade Grau II (35)', imc: 35)
  ];

  final _myBox = Hive.box('mybox');

  // write data
  void writeData(altura) {
    _myBox.put('altura', altura);
    debugPrint(_myBox.get('altura'));
  }

  void readData() {
    double.parse(_myBox.get('altura'));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    alturaController.dispose();
    pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                const Text(
                  'Sua altura',
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Digite sua altura"),
                  style: const TextStyle(height: .6),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.purple[100],
                  ),
                  onPressed: () {
                    writeData(alturaController.text);
                  },
                  child: const Text("Definir altura",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
                const Text(
                  'Suas informações',
                  style: TextStyle(fontSize: 20),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Expanded(
                        child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      children: imcList
                          .map((e) => ListTile(
                                title: Text(e.info.toString()),
                                subtitle: Text(
                                    'Seu IMC: ${e.imc.toStringAsPrecision(3)}'),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromARGB(66, 0, 0, 0),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ))
                          .toList(),
                    ))
                  ],
                )
              ],
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              context: context,
              builder: (BuildContext bc) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 56.0,
                          child: Center(
                              child: Text(
                            "Informe seus dados",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ) // Your desired title
                              ),
                        ),
                        Positioned(
                            left: 0.0,
                            top: 0.0,
                            child: IconButton(
                                icon: const Icon(
                                    Icons.arrow_back), // Your desired icon
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }))
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          runSpacing: 10.0,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text("Sua altura em cm: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            TextFormField(
                              controller: TextEditingController(text: _myBox.get('altura')),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite sua altura"),
                              style: const TextStyle(height: .6),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text("Seu peso em Kg: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            // Input Peso
                            TextField(
                              controller: pesoController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite seu peso"),
                              style: const TextStyle(height: .6),
                            ),
                            // Submit button
                            TextButton(
                                onPressed: () {
                                  _calcular();
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor: Colors.purple[100],
                                ),
                                child: const Text(
                                  "Calcular",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )),
                          ],
                        ),
                      )
                    ],
                  )));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
