const { timeStringHelper } = require("./timeStringHelper");

module.exports = async (_, { id }, { models }) => {

    let posts = await models.Post.find({ userid: id });
    //console.log("posts: ", posts);
    //find and set relational/computed fields for all posts
    for (let i = 0; i < posts.length; i++) {
        let comments = await models.Comment.find({ postid: posts[i]._id });
        //get user for each comment
        for (let j = 0; j < comments.length; j++) {
            let userC = await models.User.findOne({ id: comments[j].userid });
            comments[j]['user'] = userC;
            let timedataC = timeStringHelper(comments[j].timestamp);
            comments[j]['timeAgo'] = timedataC[0];
            comments[j]['timeAbs'] = timedataC[1];
        }
        comments.sort((a, b) => {
            return a.timeAbs - b.timeAbs
        })

        let user = await models.User.findOne({ id: posts[i].userid });
        let timedata = timeStringHelper(posts[i].timestamp);
        posts[i]['timeAgo'] = timedata[0];
        posts[i]['timeAbs'] = timedata[1];
        posts[i]['comments'] = comments;
        posts[i]['commentCount'] = posts[i].comments.length;
        posts[i]['likeCount'] = posts[i].likes.length
        posts[i]['user'] = user;
        //sort posts by time
        posts.sort((a, b) => {
            return a.timeAbs - b.timeAbs
        })

    }
    //print posts as JSON string
    return posts;
};