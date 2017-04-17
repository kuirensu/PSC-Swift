//
//  testMain.swift
//  PriorityScheduleCalendar
//
//  Created by Kuiren Su on 4/12/17.
//  Copyright © 2017 Kuiren Su. All rights reserved.
//

import Foundation
var cal = Calendar()
print("\(cal.cal)")
var sleep = Interval(start: 0, end: 10, name: "sleep", userTask: false)
cal.addBlockedOffTimes(day: "Sunday", interval: sleep)
cal.addBlockedOffTimes(day: "Monday", interval: sleep)
cal.addBlockedOffTimes(day: "Tuesday", interval: sleep)
cal.addBlockedOffTimes(day: "Wednesday", interval: sleep)
cal.addBlockedOffTimes(day: "Thursday", interval: sleep)
cal.addBlockedOffTimes(day: "Friday", interval: sleep)
cal.addBlockedOffTimes(day: "Saturday", interval: sleep)

cal.addBlockedOffTime(day: "Monday", startTime: 10, name: "work", userTask: false)
cal.addBlockedOffTime(day: "Monday", startTime: 12, name: "class", userTask: false)
cal.addBlockedOffTime(day: "Monday", startTime: 15, name: "work", userTask: false)
cal.addBlockedOffTimes(day: "Tuesday",  interval: Interval(start: 16, end: 18, name: "class", userTask: false))
cal.addBlockedOffTime(day: "Wednesday", startTime: 11, name: "work", userTask: false);
cal.addBlockedOffTimes(day: "Wednesday", interval: Interval(start: 19, end: 22, name: "class", userTask: false))
cal.addBlockedOffTime(day: "Thursday", startTime: 13, name: "work", userTask: false);
cal.addBlockedOffTimes(day: "Thursday", interval: Interval(start: 16, end: 18, name: "class", userTask: false))
cal.addBlockedOffTime(day: "Friday", startTime: 10, name: "bits", userTask: false)
cal.addBlockedOffTime(day: "Friday", startTime: 12, name: "bits", userTask: false)

//cal.printCalendar()

var test = WeightScheduling(c: cal)
test.addClass(classname: "cs201", importance: 8.0)
test.addClass(classname: "cs270", importance: 10.0)
test.addClass(classname: "mkt", importance: 5.0)
// percent then duration
test.addTask(name: "homework1", percent: 5.0, duration: 2, classname: "cs201", dayDue: "Friday", timeDue: 12)
test.addTask(name: "more important homework", percent: 5.0, duration: 4, classname: "cs201", dayDue: "Friday", timeDue: 11)
test.addTask(name: "homework2", percent: 5.0, duration: 2, classname: "cs270", dayDue: "Thursday", timeDue: 12)
test.addTask(name: "exam", percent: 20, duration: 2, classname: "mkt", dayDue: "Wednesday", timeDue: 12)
test.assignWeightsToTasks()
var success = test.scheduleTasks()
//print("scheduled all tasks? \(success)")
// test.printCalendar()
test.frontloadAllTasks()
test.printCalendar()
