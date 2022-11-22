import 'package:flutter/material.dart';


class ActivityListTile extends StatelessWidget {

  String? title;
  String? subtitle;
  String? subtitle2;
  Widget? trailingImage;
  VoidCallback? onTab;
  Color? color;

  ActivityListTile({this.title,  this.color, this.onTab, this.subtitle , this.subtitle2, this.trailingImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: onTab,
        child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              ),
                elevation: 6,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              const Radius.circular(15.0)
                          ),
                          color : color!
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top : 5.0),
                            child: Text(title!),
                          ),
                          subtitle: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8.0),
                            children: [
                              Container(
                              padding: EdgeInsets.only(top: 6.0),
                              child: Text(subtitle!, style: TextStyle(fontSize: 12)),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 6.0),
                                child: Text(subtitle2!, style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),

                        ),
                      )
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom:15),
                  child: Container(child : trailingImage)
              )
            ]
        ),

      ),
    );
  }
}
