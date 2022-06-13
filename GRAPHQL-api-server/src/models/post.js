const mongoose = require("mongoose");
const { Schema } = mongoose;


const postSchema = new Schema({
  userid: {
    type: String,
    trim: true
  },
  text: {
    type: String,
    trim: true
  },
  img: {
    type: String,
  },
  likes: {
    type: Array,
    trim: true
  },
  timestamp: {
    type: String,
    trim: true
  },

});


const Post = mongoose.model("Post", postSchema);

module.exports = { Post };
