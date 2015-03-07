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

+ (NSDate *)dateBetween:(NSDate *)from and:(NSDate *)to
{
    NSTimeInterval diff = to.timeIntervalSince1970 - from.timeIntervalSince1970;
    NSNumber *randomInterval = [GZNumbers floatBetween:(float)diff and:0.0];
    return [NSDate dateWithTimeInterval:randomInterval.doubleValue sinceDate:from];
}

+ (NSDate *)daysForward:(NSUInteger)days
{
    NSDate *today = [self _todayTest] ?: [NSDate date];
    NSCalendar *calendar = [self _calendar];
    NSDateComponents *fromComponents = [[NSDateComponents alloc] init];
    NSDateComponents *toComponents = [[NSDateComponents alloc] init];
    
    fromComponents.day = 1;
    toComponents.day = days - 1;
    
    NSDate *tomorrow = [calendar dateByAddingComponents:fromComponents toDate:today options:0];
    NSDate *to = [calendar dateByAddingComponents:toComponents toDate:tomorrow options:0];
    return [self dateBetween:tomorrow and:to];
}

+ (NSDate *)daysBackward:(NSUInteger)days
{
    NSDate *today = [self _todayTest] ?: [NSDate date];
    NSCalendar *calendar = [self _calendar];
    NSDateComponents *fromComponents = [[NSDateComponents alloc] init];
    NSDateComponents *toComponents = [[NSDateComponents alloc] init];
    
    fromComponents.day = -days + 1;
    toComponents.day = -1;
    
    NSDate *yesterday = [calendar dateByAddingComponents:toComponents toDate:today options:0];
    NSDate *past = [calendar dateByAddingComponents:fromComponents toDate:yesterday options:0];
    
    return [self dateBetween:past and:yesterday];
}

+ (NSDate *)yearsForward:(NSUInteger)years
{
    NSDate *today = [self _todayTest] ?: [NSDate date];
    NSCalendar *calendar = [self _calendar];
    NSDateComponents *fromComponents = [[NSDateComponents alloc] init];
    NSDateComponents *toComponents = [[NSDateComponents alloc] init];
    
    fromComponents.year = 1;
    toComponents.year = years - 1;
    
    NSDate *nextYear = [calendar dateByAddingComponents:fromComponents toDate:today options:0];
    NSDate *to = [calendar dateByAddingComponents:toComponents toDate:nextYear options:0];
    return [self dateBetween:nextYear and:to];
}

+ (NSDate *)yearsBackward:(NSUInteger)days {}


+ (NSCalendar *)_calendar
{
    return [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
}


#pragma mark - Private helper for testing

+ (NSDate *)_todayTest
{
    return nil;
}

@end
