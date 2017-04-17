//
//  WeightScheduling.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su on 4/12/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation
class WeightScheduling {
    
    
    private var classes: Dictionary<String, Class> = [:]
    private var allTasks = [Task]()
    private var weightedTasks = [Task]()
    private var c: Calendar?
    
    /*
     * Initialize a list of classes.
     */
    init(c: Calendar) {
        self.c = c
    }
    
    /*
     * Adds a new class to the vector of classes given an importance
     */
    func addClass( classname: String,  importance: Double) {
        let c = Class(n: classname, imp: importance)
        if classes[classname] == nil {
            classes[classname] = c
        }
    }
    /*
     * Adds a new class to the vector of classes given an instance of a Class
     */
    
    func addClass(c: Class) {
        if classes[c.getName()] != nil {
            classes[c.getName()] = c
        }
    }
    
    /*
     * Adds a new task to a specified class with given name, percent, and
     * duration
     */
    func addTask(name: String, percent: Double, duration: Int, classname: String, dayDue: String, timeDue: Int) {
        let c = classes[classname]
        let t = Task(name: name, percentage: percent, duration: duration, classname: classname, classimportance: c!.getImportance(), dayDue: dayDue, timeDue: timeDue)
        c!.addTask(t: t)
        classes[classname] = c
        allTasks.append(t)
    }
    /*
     * Calculates a weight for each task based on the importance of the class
     * and the percentage of total grade. Weight = 100 * (((0.6) *
     * (t.getPercentage() / 100)) + ((0.4) * (classImportance / 10))) Prints a
     * sorted array of tasks from decreasing to increasing order
     */
    
    func assignWeightsToTasks() {
        print("\(classes.count)")
        for c in classes {
            print("\(c)")
            var temp = c.value.getTasks()
            print("# of tasks=\(temp.count)")
            let classImportance = c.value.getImportance()
            for i in stride(from: 0, to: temp.count, by: 1) {
                let t = temp[i]
                let reward = 100 * (((0.6) * (t.getPercentage() / 100)) + ((0.4) * (classImportance / 10)))
                let weight = (reward * reward) / Double(t.getDuration())
                t.setWeight(weight: weight)
                print("Weight of \(t.getName()) is \(t.getWeight())")
                weightedTasks.append(t)
            }
        }
        // sorts low to high
        weightedTasks = weightedTasks.sorted(by: { $0.getWeight() < $1.getWeight() })
        
    }
    
    /*
     * Calculates the weights of each task and adds to the given calendar.
     * Starts at the second to last available interval. Adds all of the tasks
     * due after that interval to a priority queue. Schedules an hour of the one
     * with the lowest weight. Decrements the duration of that task by one
     * (NOTE: does not change the weight). Moves on to the next interval. Adds
     * any additional tasks to the queue. Schedules one hour of the task with
     * the lowest weight. Repeats. Returns 1 on success and 0 on failure.
     *
     * Method dependencies: scheduleTasksOn(day, priorityQueue)
     */
    
    func scheduleTasks() -> Bool{
        print("*******in schedule tasks*******")
        var pq = PriorityQueue<Task>(ascending: false)
        
        scheduleTasksOn(day: "Saturday", pq: &pq);
        scheduleTasksOn(day: "Friday", pq: &pq);
        scheduleTasksOn(day: "Thursday", pq: &pq);
        scheduleTasksOn(day: "Wednesday", pq: &pq);
        scheduleTasksOn(day: "Tuesday", pq: &pq);
        scheduleTasksOn(day: "Monday", pq: &pq);
        scheduleTasksOn(day: "Sunday", pq: &pq);
        
        return pq.count == 0
        
    }
    
    /*
     * Given a day and the current priority queue of tasks, this method starts
     * at 24 (midnight) on that day and grabs all of the tasks due after
     * midnight. It iterates through the entire day and adds all the tasks due
     * on that day.
     *
     * If it finds a task due after a certain time, it tries to schedule it at
     * the first available time on that day.
     *
     * If scheduling is successful, the task is added to the calendar (in the
     * method scheduleAtFirstAvailable(day, interval). It schedules 1 hour at a
     * time. It decrements the duration of the task and removes it from the
     * priority queue if the task is now empty.
     *
     * If the scheduling is unsuccessful then the task is not scheduled and
     * remains in the priority queue.
     *
     * Method dependencies: getTasksDueAfter(day, interval, priorityQueue)
     * calendarInstance.scheduleAtFirstAvailability(day, interval)
     *
     */
    func scheduleTasksOn(day: String, pq: inout PriorityQueue<Task> ) {
        
        for i in (0...23).reversed() {
            getTasksDueAfter(day: day, start: i, pq: &pq)
            if !pq.isEmpty {
                let t = pq.peek()
                let interval = Interval(start: i, name: (t?.getName())!, userTask: true)
                
                let success = c!.scheduleAtFirstAvailable(day: day, interval: interval)
                if success {
                    pq.remove(t!);
                    let dur = t!.getLeftToSchedule() - 1
                    t!.setLeftToSchedule(duration: dur)
                    
                    if dur != 0 {
                        pq.push(t!)
                    }
                }
            }
        }
        
    }
    /*
     * Given a day, a start time, and the priority queue, adds all of the tasks
     * due after that time to the priority queue
     */
    
    func getTasksDueAfter(day: String, start: Int, pq: inout PriorityQueue<Task> ) {
        
        for weightedTask in weightedTasks {
            if weightedTask.dueAfter(day: day, start: start) {
                if !pq.contains(weightedTask) && weightedTask.getLeftToSchedule() != 0 {
                    pq.push(weightedTask)
                }
                
            }
        }

        
    }
    
    /*
     * Prints out tasks in order of weight
     */
    func printWeightedTasks() {
        for weightedTask in weightedTasks {
            
            print("\(weightedTask.getClassname()) : [D: \( weightedTask.getDuration()) I: \(weightedTask.getImportance()) P: \(weightedTask.getPercentage())] \(weightedTask.getName()) - \(weightedTask.getWeight())")
        }
    }
    /*
     * Frontloads the scheduled task by calling the calendar.frontload()
     */
    
    func frontloadAllTasks() {
        c!.frontload()
    }
    
    /*
     * Prints out the calendar
     */
    
    func printCalendar() {
        printWeightedTasks()
        c!.printCalendar()
    }
    
    /*
     * Given two tasks, compares their weights. Note that weights are
     * initialized to zero if not set. For use in list.sort
     */
    
    
}
