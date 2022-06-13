const { gql } = require('apollo-server');

module.exports = gql`
  type Post {
    _id: ID
    userid: String!
    text: String!
    comments: [Comment]
    commentCount: Int
    user: User
    likes: [String]
    likeCount: Int
    timeAgo: String
    timeAbs: String
    img: String
  }

  input CreatePostInput {
    userid: String!
    text: String!
    img: String
  }

  input UpdatePostInput {
    userid: String!
    text: String
  }
  input AddComment {
    userid: String!
    text: String!
    postid: ID!
  }
  input AddLike {
    userid: String!
  }

  input DeletePostInput {
    id: ID!
  }

  type DeletePayload{
    id: ID!
  }

  type Query {
    posts: [Post]
    post(id: ID!): Post
    comments(id: ID!): [Comment]
    userPosts(id: String!): [Post]
  }

  type Mutation {
    createPost(input: CreatePostInput!): Post!
    updatePost(id: ID!, input: UpdatePostInput!): Post!
    deletePost(id: ID!): DeletePayload!
    addComment(input: AddComment!): Comment
    addLike(id: ID!, input: AddLike!): Post
    createUser(input: UserInput!): User
  }
  
`;
