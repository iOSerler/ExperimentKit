import Foundation

public protocol ExperimentConfigurationProvider {
    func execute<T: Decodable>(_ experiment: Experiment<T>)
    func setup()
}
