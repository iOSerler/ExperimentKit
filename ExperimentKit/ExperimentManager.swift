import Foundation

public final class ExperimentManager {
    
    // MARK: - Properties
    
    public static let shared = ExperimentManager()
    private static var activated = false
    
    private var configurationProvider: ExperimentConfigurationProvider?
    
    
    // MARK: - Lifecycle
    
    init() {}
    
    // MARK: - Public
    
    public func configure(configurationProvider: ExperimentConfigurationProvider) {
        guard ExperimentManager.activated == false else { return }
        self.configurationProvider = configurationProvider
        configurationProvider.setup()
        ExperimentManager.activated = true
    }
    
    func executeExperiment<T: Decodable>(experiment: Experiment<T>) {
        guard
            ExperimentManager.activated,
            let configurationProvider = configurationProvider
        else { return }
        configurationProvider.execute(experiment)
    }
}
