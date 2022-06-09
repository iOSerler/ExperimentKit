import Foundation
import FirebaseCore
import FirebaseRemoteConfig

public final class FirebaseConfigurationProvider: ExperimentConfigurationProvider {
    
    // MARK: - Properties
    
    public lazy var developerMode: Bool = false {
        willSet {
            guard let remoteConfig = remoteConfig else {return}
            let interval: TimeInterval
            interval = newValue == true ? 0 : 30
            remoteConfig.configSettings.minimumFetchInterval = interval
//            settings.minimumFetchInterval = interval
//            remoteConfig.configSettings = settings
        }
    }
    
    private var remoteConfig: RemoteConfig!
    
    
    // MARK: - Lifecycle
    
    public init() {}
    
    // MARK: - Public
    
    public func setup() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings.init()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { completion, error  in
                    guard error == nil else { return }
                    ExperimentManager.activated = true
                    ExperimentManager.shared.executeQueue()
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
            guard let value = value else { return }
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

