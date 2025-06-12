//
//  Bindable.swift
//  BasicMVVM
//
//  Created by otto on 5.06.2025.
//

final class Bindable<T> {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(wrappedValue: T) {
        self.value = wrappedValue
    }
    
    func bind(skipInitial: Bool = false,_ listener: @escaping Listener) {
        self.listener = listener
        if !skipInitial {
            listener(value)
        }
    }
    
    var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
}
