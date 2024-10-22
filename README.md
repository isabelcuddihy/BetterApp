# BetterApp
What is the Better! app?

The Better! App encourages fitness habit building by having users challenge each other to step counting competitions
Competitions are between 2 users and progress is measured by a battery icon showing how much progress a user have made toward their daily step goal
The challenger with the most steps/goals met by the end of the competition is the winner!
Integrated with the Apple Health to ensure steps are counted
Competition with your friends to ensure motivation and positive support

Our Target Audience

iPhone Users 18+:  Since the app integrates with Apple Health and is being developed in Swift, it is designed to be used on the iOS ecosystem.

Fitness Enthusiasts: Individuals who are active and enjoy tracking their progress!

Competitive Individuals: People who are motivated by friendly competition and enjoy challenging their friends to meet fitness goals

Why the Better! App: Our Significance

The Better! App stands out by combining fitness and fun with a competitive edge. Unlike many fitness apps that are either purely social or strictly performance-focused, Better! brings a balanced approach, making walking enjoyable through friendly competition. By using visual progress with a battery icon, users can easily track their step goals and see who is ahead in real-time. Integrated with Apple Health, it ensures accurate step counting while encouraging motivation and positive support from friends. The app’s unique design fosters lasting fitness habits through engaging challenges, keeping users active and connected.

Landing Page/ Login & Create Profile  

We plan on having a welcome page where users can select if they wish to login or create a new account (for new users)
A user can create a password (user authentication stored in Firebase)
FLOW: Loading the app opens the landing page -> user choose login or create account and appropriate screen is pulled up

A users profile page will track their current competition( if any) or let them start a new challenge


Finding Challengers

HOW USERS FIND CHALLENGERS
Users add friends to their profile via searching their name
If a user is not currently in a challenge, they can pick a challenger (someone who is not currently in a challenge - we will add some sort of logic to prevent selection if the person is already in a challenge)
The user picking a challenge sets up the parameters like number of steps and number of days
FLOW: From profile: create a new challenge-> select a challenge-> determine the parameter of the challenge-> challenge notification to second user


Our Backend

Profile: We plan to integrate Firebase Authentication from Google for user authentication

Database: We plan to use Firebase Realtime Database to store and manage user data, activity details and goals

Health Data Integration: The app integrates with Apple Health to accurately retrieve and track the user’s step data

Push Notifications: Users will be notified of important updates, such as competition progress and challenges from friends


Sensors

Camera & Photo Gallery access for updating profile pictures 
GPS access (upcoming feature) to discover and challenge users nearby

FUTURE PLANS

GPS Integration - larger social engagement, find new friends, make new connections - Apple Map API
Team Challenges, compete against groups of people
Multiple challenges at once
Other habits, workouts (strength training/lifting, screen time limitations, sleep etc)



TIMELINES
 GOAL
DATE COMPLETION
Build skeleton of app, all necessary screens with basic text labels and button (functionality not necessary) - UI Views
11/01/2024
View Controllers, Moving Data Between Screens, Delegates
11/11/2024
Setup Backend/User Authentication/Camera Accessibility
11/18/2024
Data Effects on Screens - Percentages during challenges, data fetching during use, Wins and lose updates, Friending, can’t challenge who is in a challenge
11/25/2024
Finish final tweaks to UX of app, ensure app is properly functioning, all errors are handled for user input or competitions work as expected
12/04/2024


GROUP TIMELINES

Skeleton: TBD
    3 Screens: Welcome, Register, Log-In/Sign-Up
    4 Screens: Create a Challenge, Create a Challenge Pop Up, Notification
    3 Screens: User Profile, Find My Friend, Challenge Screen

Michael: Welcome, Register, Log-In/Sign-Up
Haidar: Create a Challenge, Create a Challenge Pop Up (Finding Users)
Isabel: Finding Friends to Add to Profile, Challenge Accept Notification,Challenge Screen
Soni: Personal User Profile, Challenge Screen(Battery, days left, competitor)

Make a git repo: a branch for each person
2 weeks: views (frontend)
4 weeks: viewcontrollers (backend)
1.5 weeks: refine and debug


