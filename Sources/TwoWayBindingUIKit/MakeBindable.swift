//
//  MakeBindable.swift
//
//
//  Created by Steven Curtis on 12/11/2020.
//

import UIKit

public class MakeBindable<BindingType> {
    private var observers = [(BindingType) -> ()]()
    private var previousValue: BindingType?
    public init(_ value: BindingType? = nil) {
        previousValue = value
    }
    
    public func currentValue() -> BindingType? {
        return previousValue
    }
    
    var keyPath: AnyKeyPath?
    
    @objc func valueChanged( sender: UIControl) {
        if let keyPath = keyPath, let newValue = sender[keyPath: keyPath] as? BindingType {
            previousValue = newValue
            DispatchQueue.main.async {
                self.observers.forEach{$0(newValue)}
            }
        }
    }
    
    private func addObserver<T: AnyObject>(
        for object: T,
        completion: @escaping (T, BindingType) -> Void
    ) {
        // if there is a lastValue (which is commonly the initial value)
        // run the completion handler on that value
        previousValue.map { completion(object, $0) }
        observers.append { [weak object] value in
            guard let object = object else {
                return
            }
            completion(object, value)
        }
    }
    
    public func update(with value: BindingType) {
        previousValue = value
        // call each of the functions
        DispatchQueue.main.async {
            self.observers.forEach{ $0(value)}
        }
    }
    
    public func bind<O: AnyObject, T>(
        _ sourceKeyPath: KeyPath<BindingType, T>,
        to anyObject: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, T?>
    ) {
        if let control = anyObject as? UIControl {
            control.addTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
            keyPath = objectKeyPath
        }
        
        addObserver(for: anyObject) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            anyObject[keyPath: objectKeyPath] = value
        }
    }
    
    public func bind<O: AnyObject, T>(
        _ sourceKeyPath: KeyPath<BindingType, T>,
        to anyObject: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, T>
    ) {
        if let control = anyObject as? UIControl {
            control.addTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
            keyPath = objectKeyPath
        }
        
        addObserver(for: anyObject) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            anyObject[keyPath: objectKeyPath] = value
        }
    }
      
    public func bind<O: AnyObject, T, R>(
        _ sourceKeyPath: KeyPath<BindingType, T>,
        to anyObject: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, R?>,
        mapper: @escaping (T) -> R?
    ) {
        
        if let control = anyObject as? UIControl {
            control.addTarget(self, action: #selector(valueChanged), for: [.editingChanged, .valueChanged])
            keyPath = objectKeyPath
        }
        
        addObserver(for: anyObject) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            let mapped = mapper(value)
            object[keyPath: objectKeyPath] = mapped
        }
    }
    
}
