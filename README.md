# Classmate

> Something I have been working on as a project for a course that I took. Will be a good example to start with Firebase, Paperonboarding , SwiftIcons and if you planning to build a Chat Application.This is just a skeleton, and uses mock API's for most parts. You will still want a App Server to serve as your messaging backend. A complete tutorial for the same could be found on Firebase website.


A Anonymous chat App using Firebase- Remote DB, Cloud messaaging, Remote Config, Invites, Alamofire, SwiftIcons, SwiftJSON, Paper Onbarding


![alt text](https://preview.ibb.co/bSnv6x/Artboard.png "App Screenshots")


Installation :

```ruby
pod install
```
You will have to create a Firebase App on the Firebase Console and follow the following steps ignore the pods as it has allready been added just need to install it.

https://firebase.google.com/docs/ios/setup?authuser=0


1 - Introduction

Too shy to ask the right questions? We got you covered. With “Classmate” ask questions in class with an option of anonymity and get them answered real-time. Create polls, share files Or Ask for Assistance. Now no more thinking if it’s the right question to ask just say it with “Classmate” app and start your Quest to knowledge and smart classrooms. With Classmate students can engage into live feed during active classes and get the answers at the right time. The App helps Students, Professors and TA’s Collaborate better, also a one-stop app for students to find the right info at the right time.


2 - Features Implemented

Firebase
The application uses firebase as a platform and utilizes its API’s for Authentication, Remote database, Messaging and Remote Configurations.

Authentication
Users can sign in with their google account and the app will authenticate and store the credentials for every subsequent login into the app. The accounts that have logged in will be showing on the firebase console for administrator to monitor.

Remote Database
The remote database is used to store messages between clients and end points. Currently there is a single messages database which will store data for a single chat room later the structure shall be changed to accommodate.

Cloud Messaging – Notification
The Application implements peer to peer Downstream messaging via Notification. Firebase cloud messaging and Apple Push Notification service is used to achieve the same. Current implementation allows users to send message in a chat room and the message is published across all devices that are added into the group. Users will receive a notification when the application is in background and on click of the notification the application opens.

Remote Configuration
There are numerous configurations in the app which are controlled from the firebase console administration application (e.g. the Feature descriptions for the Onboarding, The URL to get Course data, Bus Data URL, the notification Key for the chat group, Profanity Filter Regex, Disable Chat room, enable sign in button)

Invites
Users can share the application to their contacts and invite them to download the application. Currently the application is not live hence the URL that will be share is the just the developer git page but will be configured in future releases.

Onboarding Screen

The application shows an onboarding screen when the user is not signed in and gives a walk through on the list of features provided by the application. Currently there are 4 Feature screens provided whose content is configurable using remote configuration properties.

Student Schedule Listing Screen

Course Schedule Cards
Once logged in Students can see their courses schedule for that day as individual cards and each active class will be opening for asking questions and the “ASK” button will be enabled for the same, also

Bus Schedule Cards
There is a bus schedule card that gets data from a bus schedule API and displays the from and to destination with bus arrival timings. The same can be refreshed using a pull to refresh option on the screen.

Pull To refresh
The course schedule page has an option to refresh the screen which updates the Course and Bus Schedule cards.

Error View
The Application takes into consideration a no network scenario and displays intuitive error UI with an option to refresh the screen with new data in case the network comes back.

Anonymous Switch
The anonymous switch lets user get into anonymous mode in the chat room or get out of the same. This setting is stored in user defaults, so the next time the user opens the app he/she resumes into the same mode.

Chat Screen
Once the user clicks on “ASK” on the Schedule screen users will be taken to the chat screen for the particular course. The chat screen is a group messaging screen where users, professor and TA can collaborate together.

Chat with Group
Users can ask questions on the group and the same will be received by other group members. If the user has opted in for anonymous mode other users in the group will receive messages from anonymous.

Smart replies
Users can choose from a set of smart replies that are configured in the app. This will be automated and will come from the server in future releases.

Call for Assistance
Users can call for assistance and the same will be displayed as a separate card highlighting the user who has asked for assistance. The TA can then easily go to that person to solve any queries.

Profanity Filter
There is a profanity filter implemented for each outgoing message and the same will be filtered by smileys in a case where it detects profanity. The profanity text is configured on the firebase console via the remote configurations.


Account Screen

The account screen will display user name and profile photo as fetched from the google AUTH server. On the account screen there is an option to check the home address which will be given to the Bus schedule API for bus timing, an anonymous switch is also included here and changing the same will store in the User defaults. Option to sign out is also provided on the screen.

Sign-out
Users are given an option to sign out of the Application. Once the user launches the application after a successful sign out he/she will be taken back to the onboarding screen.
