import Foundation

public final class Experiment<Type> {
    
    // MARK: - Properties
    
    public var key: String
    private let action: (Type) -> ()
    
    // MARK: - Lifecycle
    
    @discardableResult
    init<Object: NSObject>(
        object: Object,
        forKey key: String,
        action: @escaping (Object, Type) -> ()
    ) {
        self.key = key
        self.action = { [weak object] type in
            guard let object = object else { return }
            DispatchQueue.main.async {
                action(object, type)
            }
        }
    }
    
    func execute(with type: Type) {
        self.action(type)
    }
}
