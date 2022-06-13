import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_app/Widgets/commentsection.dart';
import 'package:social_app/Widgets/post.dart';

import '../constants.dart';

class PostPage extends StatefulWidget {
  Map<String, dynamic> postdata;
  VoidCallback? refetchCallBack;
  PostPage({Key? key, required this.postdata, required this.refetchCallBack})
      : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<dynamic> comments;
  late Map<String, dynamic>? postData;

  @override
  void initState() {
    comments = widget.postdata['comments'];
    print(comments);
    postData = widget.postdata;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //query for single post
    String readPost = r"""
query Post($postId: ID!) {
  post(id: $postId) {
      _id
      text
      likeCount
      timeAgo
      img
      likes
      user {
        displayname
        img
      }
      comments {
        timeAgo
        text
        user {
          displayname
          img
      }
      }
      commentCount
    }
  }
  """;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        foregroundColor: wit,
        backgroundColor: darkBlu,
        centerTitle: true,
      ),
      body: Query(
          options: QueryOptions(document: gql(readPost), variables: {
            "postId": postData!['_id']
          } // this is the query string you just created
              ),
          // Just like in apollo refetch() could be used to manually trigger a refetch
          // while fetchMore() can be used for pagination purpose
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return Column(
                children: [
                  Post(
                    postdata: widget.postdata,
                    openComments: true,
                    disableRoute: true,
                    refetchCallBack: refetch,
                  ),
                  //comment section for all widget.postdata['comments']
                  const Center(child: CircularProgressIndicator())
                ],
              );
            }
            Map<String, dynamic>? post = result.data?['post'];
            comments = post!['comments'];
            if (comments.isEmpty) {
              return Column(
                children: [
                  Post(
                    postdata: widget.postdata,
                    openComments: true,
                    disableRoute: true,
                    refetchCallBack: refetch,
                  ),
                  //comment section for all widget.postdata['comments']
                  const Center(child: Text("no comments"))
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Post(
                    postdata: widget.postdata,
                    openComments: true,
                    disableRoute: true,
                    refetchCallBack: refetch,
                  ),
                  //comment section for all widget.postdata['comments']
                  CommentSection(
                    comments: comments,
                  )
                ],
              ),
            );
          }),
    ));
  }
}
