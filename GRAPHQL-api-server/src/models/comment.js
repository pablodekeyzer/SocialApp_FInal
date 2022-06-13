const mongoose = require("mongoose");
const { Schema } = mongoose;


const commentSchema = new Schema({
    userid: {
        type: String,
        trim: true
    },
    text: {
        type: String,
        trim: true
    },
    postid: {
        type: String,
        ref: "Post",
        trim: true
    },
    timestamp: {
        type: String,
        trim: true
    },

});


const Comment = mongoose.model("Comment", commentSchema);

module.exports = { Comment };