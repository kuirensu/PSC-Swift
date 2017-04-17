//
//  Task.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su on 4/9/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation
class Task: Comparable{
    private var percentage: Double?
    private var name: String?
    private var duration: Int?
    private var weight = 0.0
    private var classname: String?
    private var classimportance: Double?
    private var dayDue: String?
    private var timeDue: Int?
    private var leftToSchedule: Int?
    
    init(name n: String, percentage p:Double, duration d:Int,
         classname c:String, classimportance importance: Double,
         dayDue: String, timeDue:Int)
    {
        name = n
        percentage = p
        duration = d
        classname = c
        classimportance = importance
        self.dayDue = dayDue
        self.timeDue = timeDue
        leftToSchedule = duration
    }
    
    func dueAfter(day: String, start: Int) -> Bool{
        return ((dayDue! == day ) && (timeDue! > start))
    }
    
    func getClassname() -> String{
        return classname!
    }
    
    func setWeight(weight w: Double) {
        weight = w
    }
    
    func setLeftToSchedule(duration d: Int) {
        leftToSchedule = d
    }
    
    func getLeftToSchedule()-> Int {
        return leftToSchedule!
    }
    
    func getImportance() ->Double {
        return classimportance!
    }
    
    func getWeight() ->Double {
        return weight
    }
    
    func getPercentage() ->Double{
        return percentage!
    }
    
    func setPercentage(percentage: Double) {
        self.percentage = percentage
    }
    
    func getName() ->String{
        return name!
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func getDuration() -> Int {
        return duration!
    }
    
    func setDuration(duration: Int) {
        self.duration = duration
    }
    
    func taskDone(num: Int) -> Bool{
        duration! -= num
        return duration == 0
        
    }
    func compareTo(task t: Task) -> Int{
        let w1 = weight
        let w2 = t.getWeight()
        if w1 > w2 {
            return 1
        }else if w1 == w2 {
            return 0
        }else{
            return -1
        }
    }
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.getWeight() < rhs.getWeight()
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.getWeight() == rhs.getWeight()
    }

}
