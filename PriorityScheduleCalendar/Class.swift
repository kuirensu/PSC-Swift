//
//  Class.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su on 4/9/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation

class Class{
    private var name: String?
    private var importance = 0.0
    private var tasks = [Task]()
    init(n: String, imp: Double){
        self.importance = imp
        self.name = n
    }
    func getName() -> String{
        return name!
    }
    func setName(name: String){
        self.name = name
    }
    func getImportance() -> Double{
        return importance
    }
    func setImportance(imp: Double){
        self.importance = imp
    }
    func getTasks() -> Array<Task> {
        return tasks
    }
    func addTask(t: Task){
        tasks.append(t)
    }
    
}

