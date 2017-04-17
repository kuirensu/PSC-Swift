//
//  Interval.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su on 4/11/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation
class Interval {
    private var startTime: Int?
    private var endTime: Int?
    private var duration = 1.0
    private var name: String?
    private var userTask: Bool?
    private var day: String?
    private var frontloaded = false
    
    init(start: Int, name: String, userTask: Bool) {
        startTime = start
        endTime = start + 1
        self.name = name
        self.userTask = userTask
    }
    
    init(start: Int, end: Int, name: String, userTask: Bool) {
        startTime = start
        endTime = end
        duration = Double(end - start)
        self.name = name
        self.userTask = userTask
    }
    
    func setFrontloaded(front: Bool) {
        frontloaded = front
    }
    
    func getFrontloaded() -> Bool{
        return frontloaded
    }
    
    func setDay(day: String) {
        self.day = day
    }
    
    func getDay() -> String{
        return self.day!
    }
    
    func getName() -> String {
        return self.name!
    }
    
    func getStartTime()-> Int {
        return self.startTime!
    }
    
    func getEndTime() -> Int {
        return self.endTime!
    }
    
    func isUserTask() -> Bool {
        return self.userTask!
    }
    
    func setStartTime(s: Int) {
        self.startTime = s
    }
    
    func setEndTime(e: Int) {
        self.endTime = e
    }
}
