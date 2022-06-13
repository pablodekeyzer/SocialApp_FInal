const { gql } = require('apollo-server');

module.exports = gql`
     type User{
      id: String
      displayname: String
      img: String
      posts: [Post]
    }
    input UserInput {
      id: String
      displayname: String
      img: String
  }
`