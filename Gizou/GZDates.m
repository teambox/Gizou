//
//  GZDate.m
//  
//
//  Created by Maria Bernis on 05/03/15.
//
//

#import "GZDates.h"
#import "GZNumbers.h"

@implementation GZDates

{
}

{
    NSDate *today = [self _todayTest] ?: [NSDate date];
+ (NSDate *)birthdayForAgesBetween:(NSUInteger)minAge and:(NSUInteger)maxAge
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [self _calendar];
    NSDateComponents *fromComponents = [[NSDateComponents alloc] init];
    NSDateComponents *toComponents = [[NSDateComponents alloc] init];
    
    fromComponents.year = -minAge;
    toComponents.year = maxAge;
    
    NSDate *from = [calendar dateByAddingComponents:fromComponents toDate:today options:0];
    NSDate *to = [calendar dateByAddingComponents:toComponents toDate:today options:0];
    return [self dateBetween:from and:to];
}


#pragma mark - Custom reference

+ (NSDate *)dateInRange:(GZDatesRange)within around:(NSDate *)referenceDate
{
    NSCalendar *calendar = [self _calendar];
    NSUInteger daysRange = 0;
    switch (within) {
        case GZDatesRangeAWeek:
            daysRange = 3;
            break;
            
        case GZDatesRangeAMonth:
            daysRange = 15;
            break;
            
        case GZDatesRangeAYear:
            daysRange = 6 * 30;
            break;
            
        case GZDatesRangeFiveYears:
            daysRange = 30 * 30;
            break;
            
        case GZDatesRangeADecade:
            daysRange = 5 * 365;
            break;
            
        case GZDatesRangeHalfCentury:
            daysRange = 25 * 365;
            break;
            
        case GZDatesRangeACentury:
            daysRange = 50 * 365;
            break;
            
        default:
            break;
    }
    
    return [self days:daysRange around:referenceDate];
}

+ (NSDate *)days:(NSInteger)days from:(NSDate *)referenceDate
{
    int s = signbit(days) == 0 ? 1 : -1;
    NSCalendar *calendar = [self _calendar];
    NSDateComponents *fromComponents = [[NSDateComponents alloc] init];
    NSDateComponents *toComponents = [[NSDateComponents alloc] init];
    
    fromComponents.day = s;
    toComponents.day = s*(abs(days) - 1);
    
    NSDate *from = [calendar dateByAddingComponents:fromComponents toDate:referenceDate options:0];
    NSDate *to = [calendar dateByAddingComponents:toComponents toDate:from options:0];
    return [self dateBetween:from and:to];
}

+ (NSDate *)days:(NSUInteger)days around:(NSDate *)referenceDate
{
    NSCalendar *calendar = [self _calendar];
    NSDateComponents *fromComponents = [[NSDateComponents alloc] init];
    NSDateComponents *toComponents = [[NSDateComponents alloc] init];
    
    fromComponents.day = -days;
    toComponents.day = days;
    
    NSDate *from = [calendar dateByAddingComponents:fromComponents toDate:referenceDate options:0];
    NSDate *to = [calendar dateByAddingComponents:toComponents toDate:referenceDate options:0];
    return [self dateBetween:from and:to];
}

+ (NSDate *)dateBetween:(NSDate *)from and:(NSDate *)to
{
    NSTimeInterval diff = to.timeIntervalSince1970 - from.timeIntervalSince1970;
    NSNumber *randomInterval = [GZNumbers floatBetween:(float)diff and:0.0];
    return [NSDate dateWithTimeInterval:randomInterval.doubleValue sinceDate:from];
}


#pragma mark - Private helpers

+ (NSDate *)_todayTest
{
    return nil;
}

+ (NSCalendar *)_calendar
{
    return [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
}

@end
