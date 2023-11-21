import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u3_practica2/baseremota.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppAeropuerto extends StatefulWidget {
  const AppAeropuerto({super.key});

  @override
  State<AppAeropuerto> createState() => _AppAeropuertoState();
}

class _AppAeropuertoState extends State<AppAeropuerto> {
  String titulo = "Aplicación de Vuelos";
  int _index = 0;

  final aerolinea = TextEditingController();
  final salida = TextEditingController();
  final destino = TextEditingController();
  final fecha = TextEditingController();
  final tiempoVuelo = TextEditingController();
  final numPasajeros = TextEditingController();

  String  idVuelo = "";
  String  nomVueloSalida = "";
  String  nomVueloDestino = "";
  String  aerolineaNom = "";
  String  fechaVuelo = "";
  String  tiempVuelo = "";
  int     numPasaj = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Text("AU"),),
                SizedBox(height: 20,),
                Text("Axel Ulises - 19400642", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            _item(Icons.connecting_airports, "Vuelos", 0),
            _item(Icons.add, "Insertar Vuelo", 1),
            _item(Icons.edit, "Registrar Vuelo", 2),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto),flex: 3,)],
      ),
    );
  }

  Widget dinamico(){
    if(_index == 1){
      return capturarVuelos();
    }
    if(_index == 2){
      return editarVuelo();
    }
    return cargarVuelo();
  }

  Widget cargarVuelo(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice){
                  return ListTile(
                    title: Text("${listaJSON.data?[indice]['aerolinea']}"),
                    subtitle: Text("${listaJSON.data?[indice]['salida']} - "
                        "${listaJSON.data?[indice]['destino']}\n"
                        "Fecha: ${listaJSON.data?[indice]['fecha']}\n"
                        "Tiempo de Vuelo: ${listaJSON.data?[indice]['tiempoVuelo']}"),
                    leading: CircleAvatar(
                      child: Text("${listaJSON.data?[indice]['numPasajeros']}"),
                    ),
                    trailing: IconButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Eliminar Vuelo"),
                              content: Text("¿Está seguro de eliminar este vuelo?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      DB.eliminar(listaJSON.data?[indice]['id']).then((value) {
                                        setState(() {
                                          titulo = "SE BORRÓ";
                                        });
                                      });
                                    });
                                  },
                                  child: Text("Aceptar"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                    onTap: (){
                      setState(() {
                        idVuelo = listaJSON.data?[indice]['id'];
                        nomVueloDestino = listaJSON.data?[indice]['destino'];
                        nomVueloSalida = listaJSON.data?[indice]['salida'];
                        aerolineaNom = listaJSON.data?[indice]['aerolinea'];
                        fechaVuelo = listaJSON.data?[indice]['fecha'];
                        tiempVuelo = listaJSON.data?[indice]['tiempoVuelo'];
                        numPasaj = listaJSON.data?[indice]['numPasajeros'];
                        _index = 2;
                      });
                    },
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }

  Widget capturarVuelos(){
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text("Registrar Vuelo", style: TextStyle(
            fontSize: 35, color: Colors.blue, fontStyle: FontStyle.italic
          ),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: aerolinea,
          decoration: InputDecoration(
              labelText: "Aerolínea:",
              prefixIcon: Icon(Icons.airplane_ticket_outlined)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: salida,
          decoration: InputDecoration(
              labelText: "Ciudad de Salida:",
              prefixIcon: Icon(Icons.location_city)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: destino,
          decoration: InputDecoration(
              labelText: "Ciudad Destino:",
              prefixIcon: Icon(Icons.add_location_alt_outlined)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: fecha,
          decoration: InputDecoration(
              labelText: "Fecha del Vuelo (dd/mm/aa):",
              prefixIcon: Icon(Icons.date_range)
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [DateInputFormatter()],
        ),
        SizedBox(height: 10,),
        TextField(
          controller: tiempoVuelo,
          decoration: InputDecoration(
              labelText: "Tiempo del Vuelo:",
              prefixIcon: Icon(Icons.more_time)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: numPasajeros,
          decoration: InputDecoration(
              labelText: "Número de Pasajeros:",
              prefixIcon: Icon(Icons.person_add_rounded)
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JsonTemporal = {
                    'aerolinea': aerolinea.text,
                    'salida': salida.text,
                    'destino': destino.text,
                    'fecha': fecha.text,
                    'tiempoVuelo': tiempoVuelo.text,
                    'numPasajeros': int.parse(numPasajeros.text)
                  };
                  DB.insertar(JsonTemporal)
                      .then((value) {
                    setState(() {
                      titulo = "SE INSERTÓ";
                    });
                    aerolinea.text = "";
                    salida.text = "";
                    destino.text = "";
                    fecha.text = "";
                    tiempoVuelo.text = "";
                    numPasajeros.text = "";
                  });
                  _index = 0;
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }

  Widget editarVuelo(){
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text("Vuelo a Editar: \n${nomVueloSalida} - ${nomVueloDestino}\nAerolínea: ${aerolineaNom}", style: TextStyle(
            fontSize: 20, color: Colors.blue, fontStyle: FontStyle.italic
        ),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: aerolinea,
          decoration: InputDecoration(
              labelText: "Aerolínea:",
              prefixIcon: Icon(Icons.airplane_ticket_outlined)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: salida,
          decoration: InputDecoration(
              labelText: "Ciudad de Salida:",
              prefixIcon: Icon(Icons.location_city)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: destino,
          decoration: InputDecoration(
              labelText: "Ciudad Destino:",
              prefixIcon: Icon(Icons.add_location_alt_outlined)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: fecha,
          decoration: InputDecoration(
              labelText: "Fecha del Vuelo (dd/mm/aa):",
              prefixIcon: Icon(Icons.date_range)
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [DateInputFormatter()],
        ),
        SizedBox(height: 10,),
        TextField(
          controller: tiempoVuelo,
          decoration: InputDecoration(
              labelText: "Tiempo del Vuelo:",
              prefixIcon: Icon(Icons.more_time)
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: numPasajeros,
          decoration: InputDecoration(
              labelText: "Número de Pasajeros:",
              prefixIcon: Icon(Icons.person_add_rounded)
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  if(aerolinea.text.isEmpty){
                    aerolinea.text = aerolineaNom;
                  }
                  if(salida.text.isEmpty){
                    salida.text = nomVueloSalida;
                  }
                  if(destino.text.isEmpty){
                    destino.text = nomVueloDestino;
                  }
                  if(fecha.text.isEmpty){
                    fecha.text = fechaVuelo;
                  }
                  if(tiempoVuelo.text.isEmpty){
                    tiempoVuelo.text = tiempVuelo;
                  }
                  if(numPasajeros.text.isEmpty){
                    numPasajeros.text = numPasaj.toString();
                  }
                  var JsonTemporal = {
                    'id' : idVuelo,
                    'aerolinea': aerolinea.text,
                    'salida': salida.text,
                    'destino': destino.text,
                    'fecha': fecha.text,
                    'tiempoVuelo': tiempoVuelo.text,
                    'numPasajeros': int.parse(numPasajeros.text)
                  };
                  DB.actualizar(JsonTemporal)
                      .then((value) {
                    setState(() {
                      titulo = "SE ACTUALIZÓ";
                      _index = 0;
                    });
                    aerolinea.text = "";
                    salida.text = "";
                    destino.text = "";
                    fecha.text = "";
                    tiempoVuelo.text = "";
                    numPasajeros.text = "";
                  });
                },
                child: Text("Actualizar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }

}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = StringBuffer();
    final inputText = newValue.text;

    if (inputText.length > 6) {
      return oldValue;
    }

    if (inputText.isNotEmpty) {
      newText.write(inputText.substring(0, 2));

      if (inputText.length >= 2) {
        newText.write('/');
        newText.write(inputText.substring(2, 4));
      }

      if (inputText.length >= 4) {
        newText.write('/');
        newText.write(inputText.substring(4, 6));
      }
    }

    final selectionIndex = newText.length;
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}