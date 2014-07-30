//
//  NSObject+Expansion.m
//  Want2Die
//
//  Created by Liping Yin on 14-7-30.
//  Copyright (c) 2014年 Liping Yin. All rights reserved.
//

#import "NSObject+Expansion.h"

@implementation NSObject (Expansion)

+(NSInteger)getRandomNumber
{
    //种子  不然每次的随机数都一样
    static NSUInteger seconds;
    if (!seconds) {
        seconds = [self getCurrentTime];
        srand(seconds);
    }
    return rand();
}
-(NSUInteger)getCurrentTime
{
    NSDate * startDate = [[NSDate alloc] init];
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |
    NSSecondCalendarUnit | NSDayCalendarUnit  |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
    
    NSUInteger second = [cps second];
    return second;
}

@end
