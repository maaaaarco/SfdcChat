# SfdcChat
A native Salesforce chat room application.

<a href="https://githubsfdeploy.herokuapp.com?owner=maaaaarco&repo=SfdcChat&ref=master">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Introduction
Does a native Salesforce chat room application sounds like complete crazy and totally senseless project? Well that's 
because IT IS! This project is absolute nonsense, its only purpose was to force me to take a deep (_very very deep_) 
dive into Lightning development.

No one in his mind should NEVER EVER consider something like this!

## Problem Statement
Create a chat room application accessible by internal users of a Salesforce Organization. 
Users must be able to:

1. send new messages 
2. receive messages from other users
3. checks who's online in the chat room

It should be possible to include the chat room directly on any object's home page layout. Chat rooms must be record 
specific, meaning that if a user sends a message while viewing record with Id#1, only users viewing the same record will 
receive the message. Other users viewing record with Id#2 won't. This must be true for all records no matter what the 
object is.
 
For this first MVP version, users are not allowed to manually create a chat room but it's something we would like to
allow in future. A single message cannot contain more than 260 characters. This limit might be increased in future.

The application cannot rely on any third party system external to Salesforce and should be Lightning ready.

## Solution
Very briefly this is my proposed solution:

- Lightning components for the UI
- Apex classes that, acting as components controller, provide backend integration
- Three custom objects to store chat rooms, messages and active users inside a chat room
- Streaming API to broadcast messages inside a chat room

### Data model
This is the implemented data model

<img src="https://raw.githubusercontent.com/maaaaarco/SfdcChat/master/doc/images/db.png">

- _Chat_Room__c:_ represents chat rooms instances. The field sObject_Id__c, with a _unique_ constraint, stores the related 
record's id
- _Chat_Message__c:_ stores users' messages, is related in Master-Detail to Chat_Room__c
- _Chat_User_Presence__c:_ related in Master-Detail with Chat_Room__c it's used to store a list of users currently connected
to a chat room

### Lightning components
This is the components' structure

<img src="https://raw.githubusercontent.com/maaaaarco/SfdcChat/master/doc/images/components.png">

- _Chat_Record_Main:_ component to include in object's Home Page layout. Based on current record's id retrieves 
related chat room;
- _Chat_Room:_ main UI component, displays the chat room window;
- _Alert:_ used to display alerts to users. It's listening to the AlertEvent application event;
- _Chat_UsersPresence:_ displays a popover menu to check online users in the chat room;
- _Chat_SingleUserPresence:_ displays a single user entry in the list of users presence;
- _Chat_ListMessages:_ retrieves and displays messages related to the chat room;
- _Streamer:_ connects to streaming API and listen for new messages. Every time a new message is captured fires the StreamerEvent
component event;
- _Chat_SingleMessage:_ displays a single message. Every time a message is rendered fires the Chat_NewMessageRenderedEvent 
component event;
- _Chat_SendMessage:_ displays a text area where user can write a new message. When user press _Enter_ it sends the message;


