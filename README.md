# Appetiser-Challenge
Architecture:\
I have used MVC design pattern\
I used storyboards for the UI but I can do it programmatically as well.

Persistence:\
AutoLogin feature unless you have logged out (code is in SceneDelegate).\
Used Keychain for the username and password, the safest way to save very sensitive information persistently.\
Used CoreData in order to save Username with the corresponding track that the user have wishlisted and also the last time the user visited the app. Meaning every user registered can have a different wishlisted tracks.\
Used UserDefaults to store the NightMode preference of the user.\
Started 2020
