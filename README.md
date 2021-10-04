# NoWaster: A mobile app to help people reduce food waste

## Overview
This app was created along with my dissertation at Oxford Brookes university in 2021. It features shopping list management, inventory management, and food-sharing. Applied skills include **SwiftUI, UIKit, MapKit, CloudKit, Firebase**, etc. The following shows the demonstrations of each screen in the app.

### Sign-in screen
This screen allows users to **sign in with Apple or Google**.   
![sign in demo](NoWaster/Demo/sign_in.gif)

### Profile set-up screen
This screen requires a user to set up profile before using the app. After setting up the use profile, the data is stored in iCloud. The location setup used MapKit to display the map around user location. The user can change their published location ( the pin) by moving the map around or search a location by place name or postcode.    
![profile setup demo](NoWaster/Demo/profile_setup.gif)

### Shopping list screen
This screen allows a user to do things as follows:
1. Add item
2. Delete item
3. Add item from history
4. Import to Inventory

The shopping list data is stored in in-app storage. In addition, history has a limit of 100. Once the history reaches the limit, it will remove items based on the count, which is the times of addition.   
![shopping list demo](NoWaster/Demo/shopping_list.gif)

### Inventory screen
This screen allows a user to do things as follows:
1. Add item 
2. Edit item
3. Extend expiry date by one day
4. Batch edition
5. Batch deletion
6. Gift items

The inventory data is stored in iCloud. Each change made in inventory will trigger the change in iCloud. I used to have difficulties updating records on iCloud because the local records are outdated. It happened because I did not synchronise the data properly.    
![inventory demo](NoWaster/Demo/inventory.gif)

### Map screen
This screen allows a user to do things as follows:
1. Check givers and available items
2. Retrieve items
3. Message a giver

The map screen display a map with givers around user location. It is argued that the giver does not disappear instantly after the available items are requested or retrieved. Also, the request feature is still not in place. I will improve this as soon as possible.   
![map demo](NoWaster/Demo/map.gif)

### Chat screen
This screen allows a user to do things as follows:
1. View chats
2. Send text message

Currently, only text message is allowed in the app. There will be more improvements on this screen soon.   
![chat demo](NoWaster/Demo/chat.gif)

### Profile screen
This screen allows a user to do things as follows:
1. Update profile
2. Sign out  
![profile demo](NoWaster/Demo/profile.gif)


## Summary
To launch the app, it still has a long way to go. I will remove all the cloudkit stuff and turn to a all-firebase environment later. Also, the sign-in and sign-out flow need to be redesigned. And I would like to bring in the unit tests for the following development.
