# ExperimentKit 
ExperimentKit simplify A/B testing and working with Remote Config, freeing you up to focus on the more important things.

--- 
# Firebase example

## Setting up without ExperimentKit

```swift
import Firebase 

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        FirebaseApp.configure()
        ...
        return true
    }
}
``` 
```swift
remoteConfig = RemoteConfig.remoteConfig()
let settings = RemoteConfigSettings()
settings.minimumFetchInterval = 0
remoteConfig.configSettings = settings
```
```swift
remoteConfig.fetch { (status, error) -> Void in
  if status == .success {
    print("Config fetched!")
    self.remoteConfig.activate { changed, error in
      // ...
    }
  } else {
    print("Config not fetched")
    print("Error: \(error?.localizedDescription ?? "No error available.")")
  }
  self.displayWelcome()
}
```

## Setting up with ExperimentKit

```swift
import ExperimentKit 

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        let configuration = FirebaseConfigurationProvider()
        ExperimentManager.shared.configure(configurationProvider: configuration)
        ...
        return true
    }
}
``` 

--- 
## Running experiment without ExperimentKit
```swift
let remoteString = remoteConfig["some_key"].stringValue
label.text = remoteString
``` 
## Running experiment with ExperimentKit
```swift
label.addExperiment(forKey: "some_key", as: String.self) { object, remoteString in
    DispatchQueue.main.async {
       self.label.text = remoteString
    }
}
``` 
--- 
## Running experiment without ExperimentKit
```swift
struct Person: Decodable {
    var name: String
    var age: Int
    var city: String
}

let remoteData = remoteConfig["some_key"].dataValue
let decoded = try? JSONDecoder().decode(Person.self, from: remoteData)
print(decoded.name)
``` 

## Running experiment with ExperimentKit
```swift
struct Person: Decodable {
    var name: String
    var age: Int
    var city: String
}

self.addExperiment(forKey: "json_key", as: Person.self) { object, decoded in
    print(decoded.name)
}
``` 

## Other Examples
If "some_exp" does not exist remotely anymore, code in closure will be not executed. 
```swift
label.text = "Hello"
self.addExperiment(forKey: "some_exp", as: String.self) { object, value in
    label.text = "Goodbye"
}
``` 

# How to install
