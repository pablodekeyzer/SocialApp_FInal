const { gql } = require('apollo-server');

module.exports = gql`
    type Comment{
      id: ID!
      postid: String
      userid: String
      text: String
      user: User
      timeAgo: String
    timeAbs: String
    }
`