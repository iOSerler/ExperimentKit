import Foundation
import FirebaseCore
import FirebaseRemoteConfig

public final class FirebaseConfigurationProvider: ExperimentConfigurationProvider {
    
    // MARK: - Properties
    
    private var remoteConfig: RemoteConfig!
    
    public lazy var developerMode: Bool = false {
        willSet {
            let interval: TimeInterval
            interval = newValue == true ? 0 : 30
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = interval
            remoteConfig.configSettings = settings
        }
    }
    
    // MARK: - Lifecycle
    
    public init() {}
    
    public func setup() {
        FirebaseApp.configure()
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings.init()
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { completion, error  in
                    guard error == nil else { return }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
        
    public func execute<T: Decodable>(_ experiment: Experiment<T>) {
        
        if let experiment = experiment as? Experiment<String> {
            let value = remoteConfig[experiment.key].stringValue
            guard let value = value else { return }
            experiment.execute(with: value)
            return
        }
        
        if let experiment = experiment as? Experiment<Bool> {
            let value = remoteConfig[experiment.key].boolValue
            experiment.execute(with: value)
            return
        }
        
        if let experiment = experiment as? Experiment<NSNumber> {
            let value = remoteConfig[experiment.key].numberValue
            experiment.execute(with: value)
            return
        }
        
        let value = remoteConfig[experiment.key].dataValue
        let decoded = try? JSONDecoder().decode(T.self, from: value)
        guard let decoded = decoded else { return }
        experiment.execute(with: decoded)
        return
    }
}

