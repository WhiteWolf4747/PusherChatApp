//import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:pusher_client/pusher_client.dart';

final _controller = TextEditingController();
String inputMessage = '';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatAppState(),
    );
  }
}

class ChatAppState extends StatefulWidget {
  const ChatAppState({super.key});
  

  @override
  State<ChatAppState> createState() => _ChatAppStateState();
}

class _ChatAppStateState extends State<ChatAppState> {
  List ChatHistory = [];
  Channel PubChannel = new Channel("name");
  
  @override

void initState() {
    // TODO: implement initState
    super.initState();
    intitiatepusher();
  }

Future<void> intitiatepusher() async{
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      //connect to pusher
      try {
        await pusher.init(
          apiKey: "accd6364089f3fa5e749",
          cluster: "mt1",
          onEvent: ((event) {
            
            setState(() {
              ChatHistory.add(jsonDecode(event.data));
            });
          }),

         
        );
        final PubChannel = await pusher.subscribe(channelName: 'my-channel');
        await pusher.connect();
      } catch (e) {
        print("ERROR: $e");
      }
      
}
  
//send message
Future SendMessage(String message) async {

  final uri = Uri.parse('https://candidate.yewubetsalone.com/api/send-message');
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'message': message,"theuserId": "JohnDoe_01"};
  String jsonBody = json.encode(body);

  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Chat Application"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ChatHistory.length,
              itemBuilder: ((context, index) {
                if(ChatHistory[index]["message"] != "Server generated greeting" && ChatHistory[index]["message"] != ""){
                  return chatbubblecustom(false, ChatHistory[index]["message"]);
                }
                return Container();
            })),
          ),
          //bottom sending bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Color.fromARGB(255, 222, 244, 255),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: input,
                      controller: _controller,
                      onChanged: (val) => setState(() {
                          inputMessage = val;
                        })
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if(inputMessage != ""){
                        SendMessage(inputMessage);
                      }
                      print(ChatHistory);
                    
                    }, 
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                    /*
                    send message alternative
                      PubChannel.bind("event-test", (event) {
                        PubChannel.trigger("client-event-test", {"message": "Hello from phone"});
                    });
                    */
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  

}

class chatbubblecustom extends StatelessWidget {
  String message;
  bool issender;

  chatbubblecustom(this.issender, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(4),
      width: 80,
      decoration: BoxDecoration(
          color:
              issender ? Color.fromARGB(255, 255, 158, 158) : Color.fromARGB(255, 171, 160, 255),
          borderRadius: issender
              ? const BorderRadius.only(
                  topRight: Radius.circular(17),
                  topLeft: Radius.circular(17),
                  bottomLeft: Radius.circular(17))
              : const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                  bottomLeft: Radius.elliptical(-20, -3))),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16 ,color: Colors.black,fontFamily: 'poppins',fontWeight: FontWeight.w600,),
        
      ),
    );
  }
}

InputDecoration input = const InputDecoration(
    label: Text(
      "Enter something here",
      
    ),
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Color.fromARGB(255, 216, 224, 255),
            width: 1.6),
        borderRadius: BorderRadius.all(
            Radius.circular(40))),
    contentPadding: EdgeInsets.fromLTRB(18, 6, 8, 6),
  );
