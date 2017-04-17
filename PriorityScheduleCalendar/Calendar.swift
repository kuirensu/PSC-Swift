//
//  Calendar.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su and Maya Ram on 4/11/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation
public class Calendar {
    var cal = [Day(name: "Sunday"),Day(name: "Monday"),Day(name: "Tuesday"), Day(name: "Wednesday"),Day(name: "Thursday"),Day(name: "Friday"), Day(name: "Saturday") ]
    
    var hours = Array<Interval?>(repeating: nil, count: 24*7)
    var full = Array(repeating: false, count: 24*7)
    
    private let daysOfTheWeek = [
        "Sunday": 0,
        "Monday": 1,
        "Tuesday": 2,
        "Wednesday": 3,
        "Thursday": 4,
        "Friday": 5,
        "Saturday": 6
    ]
    
    /*
     * Initializes a calendar with 7 days of the week. Adds to a map (Day, #)
     */
    
    /*
     * Blocks off a one hour chunk with a given name
     */
    func addBlockedOffTime(day: String, startTime:Int, name:String, userTask:Bool) {
        let index = daysOfTheWeek[day]
        let d = cal[index!];
        let i =  Interval(start: startTime, name: name, userTask: userTask)
        i.setDay(day: day)
        d.addBlockedOffInterval(interval: i, name: name)
    }
    
    /*
     * Blocks off a chunk with a specified interval (can be longer than 1 hr)
     */
    func addBlockedOffTimes(day: String, interval: Interval) {
        interval.setDay(day: day)
        let index = daysOfTheWeek[day]
        let d = cal[index!]
        d.addBlockedOffInterval(interval: interval, name: interval.getName())
    }
    
    /*
     * If the provided interval is full, schedules at the first available time
     * i.e. if Friday 2 PM is full but Friday 1 PM is free, will schedule Friday
     * 1PM
     */
    func frontLoadTasks(){
        for i in 0...6 {
            let temp = cal[i].hours
            let temp2 = cal[i].full
            for j in 0...23{
                hours[i*24 + j] = temp[j]
                full[i*24 + j]  = temp2[j]
            }
            
        }
        helper()
    }
    
    func helper(){
        for i in 0...167{
    
            if full[i] == false{
				for j in stride(from: i+1, to: 24*7, by: 1) {
                    if full[j] == true{
                        if hours[j]?.isUserTask() == true{
                            swapInterval(int1: i, int2: j)
                            break
                            }
    
                    }
				}
            }
        }
    }
    
    //nikhil
    func swapInterval(int1: Int, int2: Int){
        let temp = hours[int1]
        hours[int1] = hours[int2]
        hours[int2] = temp
        
        let temp2 = full[int1]
        full[int1] = full[int2]
        full[int2] = temp2
    }
    
    //nikhil
    func printCalender2(){
    
        //System.out.println(name);
        var day = -1
        for i in 0...167 {
            if(i%24 == 0){
                day += 1
                print(String(describing: cal[day].name))
            }
            if (full[i] == true) {
                if (i < 10){
                    print(" \(i - 24*day) : \(hours[i]!.getName())")
                }else{
                    print("\(i - 24*day) : \(hours[i]!.getName())")
                }
            } else {
                if i < 10 {
                    print(" \(i - 24*day) : _______")
                }else{
                    print("\(i - 24*day) : _______")
                }
            }
            
        }
    }

    
    
    func scheduleAtFirstAvailable(day: String, interval: Interval) -> Bool{
        let index = daysOfTheWeek[day]
        let d = cal[index!]
        let startTime = d.firstAvailable(interval: interval)
        if startTime != -1 {
            interval.setDay(day: d.getName())
            addBlockedOffTimes(day: d.getName(), interval: interval)
            return true
        } else {
            return false
        }
        
    }
    
    /*
     * If there are empty intervals, tries to move up all of the user-added
     * tasks to as early as possible
     */
    func frontload() {
        // find the first empty interval
        var firstEmptyStartTime = 0
        
       
        
        let d = cal[0]
        var firstScheduledTask = findFirstScheduledTaskAfter(day: d.getName(), startTime: 0)
        
        while d.hasEmptyIntervals() && firstScheduledTask.getStartTime() != -1 {
            firstEmptyStartTime = d.firstEmptyInterval()
            // if a first empty interval exists, find the time of first
            // scheduled task
            if firstEmptyStartTime != -1 {
                print("The first scheduled task is \(firstScheduledTask.getName()) previously scheduled from \(firstScheduledTask.getStartTime()) to \(firstScheduledTask.getEndTime())")
                // if this exists
                if firstScheduledTask.getStartTime() != -1 {
                    let scheduledDayString = firstScheduledTask.getDay()
                    let index = daysOfTheWeek[scheduledDayString]
                    let scheduledDay = cal[index!]
                    // remove from the day
                    print("unscheduling \(firstScheduledTask.getName())  on day \(firstScheduledTask.getDay())")
                    scheduledDay.unscheduleAnHour(interval: firstScheduledTask)
                    cal[index!] = scheduledDay
                    
                    // change interval
                    firstScheduledTask.setStartTime(s: firstEmptyStartTime)
                    firstScheduledTask.setEndTime(e: firstEmptyStartTime + 1)
                    firstScheduledTask.setFrontloaded(front: true)
                    
                    // move to new time
                    print("adding task \(firstScheduledTask.getName()) to \(d.getName()) at \(firstScheduledTask.getStartTime())")
                    addBlockedOffTimes(day: d.getName(), interval: firstScheduledTask)
                    print("** finding the first scheduled task after \(d.getName()) at \(firstScheduledTask.getEndTime())")
                    firstScheduledTask = findFirstScheduledTaskAfter(day: d.getName(), startTime: firstScheduledTask.getEndTime());
                    print("\(firstScheduledTask.getName())")
                }
                
            }
            
        }
        
    }
    /*
     * finds first scheduled task
     */
    
    func findFirstScheduledTaskAfter(day: String, startTime: Int) -> Interval{
        let index = daysOfTheWeek[day]
        for i in stride(from: index!, to: 6, by: 1) { //different from source
            let d = cal[i]
            let first = d.getFirstScheduledTaskAfter(start: startTime)
            if first.getStartTime() != -1 {
                if first.getFrontloaded() == false {
                    first.setDay(day: d.getName())
                    return first
                }
            }
        }
        
        return Interval(start: -1, name: "blank", userTask: false)
    }
    /*
     * Prints it out day by day
     */
    func printCalendar() {
        for i in 0...6 {
            cal[i].printDay()
        }
    }
}

