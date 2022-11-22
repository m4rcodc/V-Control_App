import 'package:flutter/material.dart';


class Community extends StatefulWidget {

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text(
          "Community",
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: ()  => {},
          )
        ],
      ),
      body:
    Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.lightBlue, Colors.white],
        )
    ),

      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top : 120),
              height: 400,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.lightBlue],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(35)
                  ),
                boxShadow: [
                BoxShadow(
                color: Colors.blueGrey,
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
             ],
              ),
              child:
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                      Image(
                        image: AssetImage('images/imageLeft.png'),
                        height: 105,
                        width: 105,
                      ),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1331&q=80"),
                        radius: 50,
                      ),
                      /*Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle ,color: Colors.white),child: Icon(Icons.edit,color: Colors.purpleAccent,),),
                      )*/
                    ],
                  ),
                      Image(
                        image: AssetImage('images/imageRight.png'),
                        height: 105,
                        width: 105,
                      ),
                 ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Marco Delle Cave",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Monete",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Row(
                            children: [
                              Image(
                                image: AssetImage('images/Coin.png'),
                                height: 35,
                                width: 35,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                          Text(
                            "45",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                                color: Colors.white.withOpacity(0.9)),
                           ),
                          ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Rank",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Row(
                            children: [
                              Image(
                                image: AssetImage('images/RankIcon.png'),
                                height: 35,
                                width: 35,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "10",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white.withOpacity(0.9)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/podium.png'),
                  height: 35,
                  width: 35,
                ),
                SizedBox(
                width: 10,
              ),
                Container(
                  decoration: BoxDecoration(
                        //border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.lightBlue.shade200,
                ),
                child:
                Container(
                  padding: EdgeInsets.all(10),
                  child:
                Text(
              "Classifica",
              style: TextStyle(fontSize: 20,color: Colors.white)),
                ),
                ),
                SizedBox(
                  width: 10,
                ),
                  Image(
                    image: AssetImage('images/podium.png'),
                    height: 35,
                    width: 35,
                  ),
            ],
            ),
            Container(
             height: 280, //margin: EdgeInsets.all(20),
                child: ListView.separated(
                  padding: EdgeInsets.only(top:12, left: 12, right: 12),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=580&q=80"),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("Prova")
                          ],
                        ),
                        leading: Text("${index + 1}." ,style: TextStyle(fontWeight: FontWeight.bold),),
                        trailing:
                        Text(
                            "${(200000 / (index + 1)).toString().substring(0, 5)}",style: TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(thickness: 2.5,color: Colors.white,indent: 10,endIndent: 10,),
                    itemCount: 12),
              ),
          ],
        ),
      ],
      ),
    ),
    ),
    );
  }
}