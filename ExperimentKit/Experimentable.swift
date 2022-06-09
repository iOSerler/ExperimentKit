import Foundation

protocol Experimentable {
    associatedtype objectType
    
    @discardableResult
    func addExperiment<T: Decodable>(
        forKey key: String,
        as type: T.Type,
        action: @escaping (objectType, T) -> ()
    ) -> objectType
}

extension NSObject: Experimentable {
    typealias objectType = NSObject
    
    @discardableResult
    public func addExperiment<T: Decodable>(
        forKey key: String,
        as type: T.Type,
        action: @escaping (NSObject, T) -> ()
    ) -> NSObject {
        let experiment = Experiment(object: self, forKey: key, action: action)
        ExperimentManager.shared.executeExperiment(experiment: experiment)
        return self
    }
}
