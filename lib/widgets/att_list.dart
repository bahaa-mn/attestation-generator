import 'package:acfgen/screens/editor_screen.dart';
import 'package:acfgen/utils/constants.dart';
import 'package:acfgen/widgets/att_item.dart';
import 'package:flutter/material.dart';

class AttestationList extends StatelessWidget {
  final List<Map> list;
  final Function(Map old, Map m) modify;
  final Function(Map m) remove;

  AttestationList({
    @required this.list,
    @required this.remove,
    @required this.modify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => GestureDetector(
            child: AttestationItem(attestation: list[i]),
            onTap: () => _onItemTap(context, list[i]),
          ),
        ),
      ),
    );
  }

  void _onItemTap(BuildContext context, Map m) {
    showBottomSheet(
      context: context,
      builder: (context) => AttestPreview(
        m: m,
        modify: this.modify,
        remove: this.remove,
      ),
    );
  }
}

class AttestPreview extends StatelessWidget {
  final Map m;
  final Function(Map old, Map m) modify;
  final Function(Map m) remove;

  const AttestPreview({
    Key key,
    @required this.m,
    @required this.modify,
    @required this.remove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Colors.blueGrey[50],
      ),
      width: w,
      padding: const EdgeInsets.only(
        left: 17.0,
        right: 17.0,
        top: 23.0,
        bottom: 7.0,
      ),
      margin: const EdgeInsets.all(7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: '${m[MapAttrs.date]} ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${m[MapAttrs.heure]}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 33),
              RichText(
                text: TextSpan(
                  text: 'Mme/Mr \t',
                  style: TextStyle(
                    color: Colors.blueGrey[500],
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${m[MapAttrs.name]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 33),
              RichText(
                text: TextSpan(
                  text: 'Motif \t',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${m[MapAttrs.motif]['short']}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${m[MapAttrs.motif]['long']}',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                minWidth: 0.3 * w,
                onPressed: () => _modify(context),
                child: Text(
                  'Modifer',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blueGrey[200],
              ),
              FlatButton(
                minWidth: 0.3 * w,
                onPressed: () => remove(m),
                child: Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _modify(BuildContext context) async {
    final newM = await Navigator.of(context).pushNamed(
      EditorScreen.routeName,
      arguments: m,
    );
    modify(m, newM);
    Navigator.pop(context);
  }
}
