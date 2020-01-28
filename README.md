# ContactMe - iOS Application

## What is ContactMe?

ContactMe is an iOS for exchanging e-cards between students without using any paper. Load you profile and share!

## What kind of features can I find in ContactMe?

ContactMe seems to be a simple application at first glance. However, we believe it covers many interesting areas of mobile development. Coming up next, we want to remark some services, paradigms, architecture that we used and we think they need to be highlighted.

### Swift Package Manager
We take advantage of the default package manager that comes out of the box with Xcode to manage dependencies such as KeyChainAccess and SQLite.swift.
### CocoaPods
When programming iOS apps there are packages and useful libraries that are not available in Swift Package repository but there are plenty under the repository of CocoaPods. We are using EGFormValidator, GooglePlaces and GoogleMaps.
### Keychain
We use Keychain services to store current user credentials. By this way, users do not have to write email and password to login unless they logout form the application. For easing our work here and code maintainability reasons, we are using KeychainAccess  library which awesomely acts as a wrapper simplifying the work. Basically, it helps us to decide, from AppDelegate, whether redirecting the user to Login or to Dashboard view.
### SQLite
SQLite is a key in this project. It is the SQL database engine that allows us to maintain the data of the connections in the device. We perform searches, filtering and CRUD operations.
For easing communication with database we use SQLite.swift  , that acts as a wrapper too, and allows us to call functions for handling SQLite databases. This library also provide us the ability to scale the database more easily and an abstraction that allows the programmer to easily configure the tables and relationships between them. Each time application is launched we check if database and table already exist, if not, we create brand new ones.
### QR Generator and QR Scanner
A QR Code is generated with a JSON that contains information about the connection that is being added. On the other hand, when we are reading this QR code we ensure this belong to the app by trying to decode the JSON to our model. It is important to say that the base of the code of QR Scanner View controller is originally taken from a GitHub repository  and then we adapted and modified it according to our needs.
### GPS Sensor
We use location services to get the coordinates where a meeting between two users was made. Therefore, when user open the QR Scanner, the app asks for accessing to location permissions. As we do not need too much precision, in order to save battery, once we get the first coordinates we pause the service to stop continuing receiving location information from the device.
### Geocoding
Once we get the coordinates of the place where the meeting was established, we need to get the name of the place, or at least an address, to show later where the meeting was made. We use geocoding techniques to achieve that.
### Haptics and Sounds
To improve user experience and accessibility of our app we used the haptic library of iOS UISelectionFeedbackGenerator (this is only available from iPhone 7 to above) and we also emit a sound when a connection is about to be added or updated.
### Forms Validation
We wanted to try how forms validation are made in iOS. For this reason, we decided to add a validation when signing in. User must enter a valid email address and a password with at least 8 characters. EGFormValidator package is helping us to reach this goal.
### Google Places SDK
For improving user experience and limit values users can enter when completing location fields, we decided to use Google Place SDK Autocomplete control to search and select real places. We decided to use Google Places SDK not only for learning purposes but also because we personally believe Google database for places is better than MapKit one.
### Extensions
In order to extend functionality of current default views/view controllers provided by the IDE, we use many extensions which are stored in a specific folder of the project called Extensions. Among these ones we can mention: 
•	UITextField: To set custom icons text fields
•	UIImageView: To make rounded images and set images passing an URL with a personalized default value.
•	UITextView: To programmatically center a text view vertically.
•	UIViewController: To dismiss keyboard when tapping outside it.
### Networking
Apart from Google Place autocomplete control and geocoding functions which make their own request, we create our own autocomplete control to help the user fill the list of jobs. It sends a request to Mocky , where we set a simple list of jobs.
### Colour Themes as Assets
We have defined a set of colours in an asset file, such a primary colour, secondary colour, labels colour, among others. This is not only for easily changing colour of the app if needed but also because we want to leave the door opened in the case someday users want to dynamically change the colour of the app or we want to provide a dark theme as optional, as they are being quite trendy nowadays.
### Custom controls
We have also created our own controls with the behaviour we needed. Some of them need to be more encapsulated, such as profile tabs or the gender tab, but others are in a specific file and ready to use by other views or even external app, such the animated rounded buttons shown in Dashboard bottom-right corner or the label as badges shown when interests of a connection match with the current user ones.


## How to run this project?

1. Install CocoaPods in your local machine

`sudo gem install cocoapods`

2. Install Pods

`pod install`

3. Run the app

You will probably want to use devices to test the app. One for sharing a card and other for scanning it.

4. Enjoy!

Too easy, isn't it?

