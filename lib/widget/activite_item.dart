
import 'package:activite_group/model/activite.dart';
import 'package:activite_group/activite_detail.dart';
import 'package:flutter/material.dart';

class ActiviteItem extends StatelessWidget {
  ActiviteItem({Key? key, required this.activite}) : super(key: key);

  final Activite activite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: InkWell(
        onTap: (() =>{
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ActiviteDetail(activite: activite);
            }))
        }),
        child: Column(
          children: [
            Image.network(activite.image,height: 200,),
            ListTile(
              title: Text(activite.titre),
              subtitle: Text(activite.lieu),
              trailing: Text('${activite.prix}'),
            ),
          ],
        ),
      ),
    );
  }
}

