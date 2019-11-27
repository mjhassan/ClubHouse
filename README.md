# ClubHouse
This is a project created to demonstrate several skills.

## Project Specification
| Description  | Specification  |
| ------------ | ------------ |
| **Xcode**| **11.2.1** |
| **Development SDK**  |  **iOS 13.2** |
| **Minimum supported SDK**  |  **iOS 11.0**  |
| **Language**  | **Swift 5.1.2**  |
|  **Cocoapod** | **0.34.0**  |
| **Supported Devices** | **Universal** |
| **Orientation Support** | **Universal** |
| **Aknowledgement** | [Haneke](https://github.com/Haneke/Haneke), [PopoverKit](https://github.com/ZionChang/PopoverKit), [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)|

## How To Run
- Download the project as .zip file
- Check `Cartfile` file is in project. Run `carthage update --platform iOS` on terminal in the project location.
> If you face any issue regarding carthage, see [Installing Carthage](https://github.com/Carthage/Carthage#installing-carthage) page.
- Double click to open the project file with Xcode and run it.

## Implementation
- All the required points have been implemented in the project. Moreover, the following features are added additionally:
    - pull-to-refresh on company view
    - phone and email interaction on member view
    - favorites and follows persistence 
- MVVM architectural pattern is used to implement the project. It is convenient for small project to ensure unit test.
- The app will fetch the json for the first time from provided url and will cache it, until you pull to refresh the table.
- There are two 3rd party libraries, Haneke, PopoverKit, and SVProgressHUD, intergrated using carthage to demonstrate 3rd party integration capability. I'm comfortable with cocoapod, too.
- Unit tests are written to cover the logic behind two view controllers.

## Credit
Jahid Hassan has created this project as a coding challenge. For any issue or query, please send me a mail at jahid.hassan.ce@gmail.com . You can check my linkedin profile [here](https://www.linkedin.com/in/mjhassan).