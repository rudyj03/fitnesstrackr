import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../styles.dart';

class Picker extends StatelessWidget {
  final Function onSelectChange;
  final future;
  final Function jsonConverterFuncion;
  final String fieldName;


  const Picker({Key key, this.onSelectChange, this.future, this.jsonConverterFuncion, this.fieldName})
      : super(key: key);


  @override
  Widget build(BuildContext context){
    return FutureBuilder<Response>(
      future: future, // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return CupertinoActivityIndicator(animating: true,);
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              var items = List();
              //Weak check for if there was an error, but Google apps script doesn't return error codes :-(
              if(snapshot.data.headers.length >= 14){
                items = jsonConverterFuncion(snapshot.data.body);
                items.sort((a, b) => a.name.compareTo(b.name));
              } else {
                return Text("There was an erroring retrieving data, please try again later");
              }
              return Container(
                height: 100,
                child: CupertinoPicker(
                  magnification: 2.5,
                  backgroundColor: Styles.pickerBackground,
                  scrollController: FixedExtentScrollController(initialItem: 0),
                  children: List<Widget>.generate(
                    items.length,
                    (int i) => Text(items[i].name, style: Styles.valueInput,)
                  ),
                  itemExtent: 40, //height of each item
                  looping: true,
                  onSelectedItemChanged: (int i) {
                    onSelectChange(items[i]);
                  },
                ),
              );
            }
        }
      },
    );
  }
}