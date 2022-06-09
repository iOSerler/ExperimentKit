import Foundation

public final class ExperimentManager {
    
    // MARK: - Properties
    
    public static let shared = ExperimentManager()
    static var activated = false
    private var configurationProvider: ExperimentConfigurationProvider?
    private var experimentQueue: [() -> ()] = []
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Public
    
    public func configure(configurationProvider: ExperimentConfigurationProvider) {
        guard ExperimentManager.activated == false else { return }
        self.configurationProvider = configurationProvider
        configurationProvider.setup()
    }
    
    func executeExperiment<T: Decodable>(experiment: Experiment<T>) {
        guard
            let configurationProvider = configurationProvider
        else { return }
        let action = {
            configurationProvider.execute(experiment)
        }
        ExperimentManager.activated ? action() : experimentQueue.append(action)
    }
    
    func executeQueue() {
        experimentQueue.forEach { $0() }
    }
}
