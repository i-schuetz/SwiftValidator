//
//  Validator.swift
//  Pingo
//
//  Created by Jeff Potter on 11/10/14.
//  Copyright (c) 2015 jpotts18. All rights reserved.
//

import Foundation
import UIKit

public class Validator {
    // dictionary to handle complex view hierarchies like dynamic tableview cells
    public var lastErrors = [UITextField: ValidationError]?()
    public var validations = [UITextField: ValidationRule]()
    private var successStyleTransform: ((validationRule:ValidationRule) -> Void)?
    private var errorStyleTransform: ((validationError:ValidationError) -> Void)?
    
    public init(){}
    
    // MARK: Private functions
    
    private func validateAllFields() -> [UITextField: ValidationError]? {
        
        var errors: [UITextField: ValidationError] = [:]
        
        for (textField, rule) in validations {
            if let error = rule.validateField() {
                errors[textField] = error
                
                // let the user transform the field if they want
                if let transform = self.errorStyleTransform {
                    transform(validationError: error)
                }
            } else {
                // No error
                // let the user transform the field if they want
                if let transform = self.successStyleTransform {
                    transform(validationRule: rule)
                }
            }
        }
        
        return errors.isEmpty ? nil : errors
    }
    
    // MARK: Using Keys
    
    public func styleTransformers(success success: ((validationRule: ValidationRule) -> Void)?, error:((validationError: ValidationError) -> Void)?) {
        self.successStyleTransform = success
        self.errorStyleTransform = error
    }
    
    public func registerField(textField: UITextField, rules: [Rule]) {
        validations[textField] = ValidationRule(textField: textField, rules: rules, errorLabel: nil)
    }
    
    public func registerField(textField: UITextField, errorLabel: UILabel, rules: [Rule]) {
        validations[textField] = ValidationRule(textField: textField, rules:rules, errorLabel: errorLabel)
    }
    
    public func unregisterField(textField: UITextField) {
        validations.removeValueForKey(textField)
    }
    
    
    public func validate() -> [UITextField: ValidationError]? {
        let errors = self.validateAllFields()
        if errors != nil {
            self.lastErrors = errors
        }
        return errors
    }
}
