//
//  Day.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su on 4/11/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation
class Day {
    
    var hours = Array<Interval?>(repeating: nil, count: 24)
    var full = Array(repeating: false, count: 24)
    var name: String?
    
    init(name: String) {
        self.name = name
    }


    func getName() -> String{
        return self.name!
    }

    /*
     * Given an interval and a name of a task, adds a blocked off interval in
     * the calendar for the duration of the task/interval
     */
    func addBlockedOffInterval(interval: Interval, name: String) {
        let start = interval.getStartTime()
        let end = interval.getEndTime()
        let userTask = interval.isUserTask()
        for index in stride(from: start, to: end, by: 1){
            hours[index] = Interval(start: start, name: name, userTask: userTask)
            full[index] = true
        }
    }

    func intervalFull(interval: Interval) -> Bool{
        return full[interval.getStartTime()]
    }
    /*
     * Iterates through all of the times in that day and returns the first one
     * that is empty. Returns -1 if there are no empty ones.
     */
    func firstAvailable(interval : Interval) -> Int {
        for index in stride(from: interval.getStartTime(), to: 0, by: -1) {
            if !full[index] {
                return index
            }
        }
        return -1
    }
    
    /*
     * Gets the first empty interval on that day. Essentially is firstAvailable
     * but from the front
     */
    func firstEmptyInterval() -> Int {
        for index in 0...23{
            if !full[index] {
                return index
            }
        }
        return -1
    }
    
    func hasEmptyIntervals() -> Bool {
        for index in 0...23{
            if !full[index]{
                return true
            }
        }
        
        return false
    }
    
    func unscheduleAnHour(interval: Interval) {
        hours[interval.getStartTime()] = nil
        full[interval.getStartTime()] = false
        
    }
    
    func getFirstScheduledTaskAfter(start: Int) -> Interval {
        for index in stride(from: start + 1, to: 23, by: 1){
            if full[index] {
                if (hours[index]!.isUserTask()) {
                    return hours[index]!
                }
            }
        }
        return Interval(start: -1, name: "empty", userTask: false)
    }
    
    func printDay() {
        print(self.name!)
        for index in 0...23 {
            if full[index] {
                if index < 10{
                    print(" \(index): \(hours[index]!.getName())")
                }else{
                    print("\(index): \(hours[index]!.getName())")
                }
                
            } else {
                if index < 10{
                    print(" \(index): _______")
                } else{
                    print("\(index): _______")
                }
            }
            
        }
    }

}
