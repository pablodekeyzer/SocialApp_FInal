const mongoose = require("mongoose");
const { Schema } = mongoose;


const userSchema = new Schema({
    id: {
        type: String,
        trim: true
    },
    displayname: {
        type: String,
        trim: true
    },
    img: {
        type: String,
    },
});


const User = mongoose.model("User", userSchema);

module.exports = { User };
