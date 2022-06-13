const mongoose = require("mongoose");


const connectDb = () => {
  return mongoose.connect('', { useUnifiedTopology: true, useNewUrlParser: true }, err => {
    if (err) {
      console.log("Connection to Database failed.");
      console.log(err);
    }
    else {
      console.log("Database connection successful.");
    }
  });
};


module.exports = connectDb;
