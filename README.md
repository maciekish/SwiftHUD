# SwiftHUD

SwiftHUD is a modern take on the classic HUD, written entirely in Swift and SwiftUI.

While there are other HUD's made in Swift, i created this one for two reasons.

1) Other libraries seem to have a slightly different focus and approach, i wanted a HUD that you could attach to any view, and not necessarily only over the entire screen. For example, using SwiftHUD you can display the HUD over a modal, while still retaining the functionality of the cancel button in the navigation bar if you want.

2) I didn't like the way the other HUDs looked, so i created my own. So now you have one more to choose from :)

https://user-images.githubusercontent.com/442007/159130114-0ab9cf50-e026-4b5c-b38b-fd2af2f675c5.mp4

# Usage

There are two main ways to use SwiftHUD. You can opt for the basic SwiftUI approach if all you need is one simple HUD, or a mixed approach if you need more control and flexibility.

## Basic, SwiftUI usage

Just set isActive = true to display the HUD.
```swift
import SwiftHUD

struct YourView: View {
  @State var isActive = false
  
  var body: some View {
     NavigationView {
        Text("Hello, SwiftHUD")
        .onTapGesture {
          isActive.toggle()
        }
     }
     .swiftHUD(isActive: $isActive, message: "Loading...")
  }
}
```

## Advanced usage

Create an instance of the SwiftHUDOverlayManager, and attach the overlay to your view structure. The second step is necessary to indicate at which layer of your UI you want the HUD to appear.

If you want to display the HUD from a remote piece of code, you can use `SwiftHUDOverlayManager.shared` instead.
```swift
import SwiftHUD

struct YourView: View {
  var overlayManager = SwiftHUDOverlayManager()
  
  var body: some View {
     NavigationView {
        Text("Hello, SwiftHUD")
        .onTapGesture {
          overlayManager.present(overlay: SwiftHUD(accessory: .systemImage(name: "checkmark.circle.fill"), message: "LOGGED_IN".localized, disablesBackground: true, tapToDismiss: true, dismissAfter: 2.0))
        }
     }
     .swiftHUD(manager: overlayManager)
  }
}
```
