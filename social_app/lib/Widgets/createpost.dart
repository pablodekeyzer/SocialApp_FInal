// ignore_for_file: unused_import

import 'dart:async';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Services/google_signin.dart';
import 'package:social_app/constants.dart';
import 'package:http/http.dart' as http;

// ignore: avoid_web_libraries_in_flutter

// ignore: must_be_immutable
class CreatePost extends StatefulWidget {
  VoidCallback? refetchCallBack;
  CreatePost({Key? key, this.refetchCallBack}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String createPost = r'''
  mutation createPost($userid: String!,$text: String!,$img: String) {
    createPost(input: {userid: $userid, text: $text, img: $img}) {
      userid
      text
      img
    }
  }
''';
  TextEditingController postTextController = TextEditingController();

  late Uint8List? fileBytes;
  late Image i;
  String fd = "";
  List l = [];
  GoogleSignInAccount? user = GoogleSignApi().getUser;

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (result != null) {
      fileBytes = result.files.first.bytes;
      setState(() {
        fd = String.fromCharCodes(fileBytes!);
      });

      //_file = result.files.single.;
    } else {
      // User canceled the picker
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> output = {
      'userid': user?.email,
      'text': postTextController.text,
      'img': fd,
    };
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(user?.photoUrl ?? '')),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? '',
                      style: userText,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      maxLength: 200,
                      controller: postTextController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write a post',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fd.isEmpty
                ? Container()
                : Container(
                    constraints: const BoxConstraints(maxHeight: 450),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Center(child: Image.memory(fileBytes!))),
                  ),
            //row for uploading gifs/imgaes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: TextButton.icon(
                          onPressed: pickFile,
                          icon: const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: darkYello,
                            ),
                          ),
                          label: Container()),
                    ),
                    // button to publish post
                    Mutation(
                        options: MutationOptions(
                          document: gql(createPost),
                          onCompleted: (dynamic resultData) {
                            widget.refetchCallBack!();
                            setState(() {
                              fd = "";
                              postTextController.text = "";
                            });
                          },
                        ),
                        builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                        ) {
                          return TextButton.icon(
                              onPressed: (() async => {runMutation(toJson())}),
                              icon: const Text('Publish',
                                  style: TextStyle(
                                      fontSize: 14, color: darkYello)),
                              label: const Center(
                                child: Icon(
                                  Icons.send_rounded,
                                  color: darkYello,
                                ),
                              ));
                        }),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
