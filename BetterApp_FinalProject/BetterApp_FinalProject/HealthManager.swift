//
//  HealthManager.swift
//  BetterApp_FinalProject
//
//  Created by Soni Rusagara on 11/24/24.
//

// HealthManager.swift
import Foundation
import HealthKit

class HealthManager {
    //HealthKitStore instance
    let healthStore = HKHealthStore()
    
    /**
         Requests authorization to access HealthKit data.
         
         - Parameters:
            - completion: A closure that takes a `Bool` indicating success (`true`) or failure (`false`) of the authorization request.
    */
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // creating a set of the data types we want to read/write
        let allHealthDataTypes: Set<HKSampleType> = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        // check if HealthKit is available
        guard HKHealthStore.isHealthDataAvailable() else {
            // If not available, print a message and complete with `false`
            print("HealthKit is not available on this device.")
            completion(false)
            return
            
        }
        // Requesting access to read the data of specific HealthKit data types (like steps) in our case
        //toShare is nil because we are not writing any data from this app to apple health kit
        healthStore.requestAuthorization(toShare: nil, read: allHealthDataTypes) {success, error in
            // Check if an error occurred during the request
            if let error = error {
                // Print the error message for debugging
                print("HealthKit authorization request denied.")
                completion(false) // calling completion handler w false
            } else if success {
                print("HealthKit access granted.") // print debug statement
                // Check the authorization status for 'stepCount' after granting permission
                let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
                let authorizationStatus = self.checkAuthorizationStatus(for: stepCountType)
                print("Authorization Status: \(authorizationStatus.rawValue)")
                completion(true) // calling completion handler w true
            } else {
                // If the request was not explicitly denied but still failed
                print("HealthKit access denied.")
                completion(false) // calling completion handler w false
            }
            
        }
    }
    
    /**
         Checks whether the app has authorization to read/write a specific data type.
         
         - Parameters:
            - dataType: The type of data to check authorization for.
         - Returns: The authorization status.
    */
    func checkAuthorizationStatus(for dataType: HKObjectType) -> HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: dataType)
    }
    
    /**
     WE ARE NOT WRITING TO APPLE HEALTH FROM THIS APP---> DO NOT USE THIS FUNCITON
     Function to create and save a sample of Step count data to HealthKit.
     - Parameters:
        - dataType: The type of data to check authorization for.
     - Returns: The authorization status.
    
    func saveStepCount() {
        // Define the step count type
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            print("Step count type is unavailable.")
            return
        }
        
        // Create start & end date dummy data
        let startDate = Calendar.current.date(bySettingHour: 14, minute: 35, second: 0, of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
        
        // Construct a quantity representing the value and unit for the step count
        let stepCountQuantity = HKQuantity(unit: .count(), doubleValue: 500.0)
        
        // Build the sample
        let sample = HKQuantitySample(type: stepType, quantity: stepCountQuantity, start: startDate, end: endDate)
        
        // Save the sample
        healthStore.save([sample]) { success, error in
            if success {
                print("Step count saved successfully.")
            } else {
                if let error = error {
                    print("Failed to save step count: \(error.localizedDescription)")
                }
            }
        }
    }
     */
}
