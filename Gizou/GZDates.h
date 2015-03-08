//
//  GZDate.h
//  
//
//  Created by Maria Bernis on 05/03/15.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    GZDatesRangeAWeek = 0,   // +- 3 days from reference date
    GZDatesRangeAMonth,      // +- 15 days from reference date
    GZDatesRangeAYear,       // +- 6 months from reference date
    GZDatesRangeFiveYears,   // +- 2.5 years from reference date
    GZDatesRangeADecade,     // +- 5 years from reference date
    GZDatesRangeHalfCentury, // +- 25 years from reference date
    GZDatesRangeACentury     // +- 50 years from reference date
}GZDatesRange;


/**
 *  Creates random dates.
 */
@interface GZDates : NSObject


///-----------------------------------------------
/// @name Using today as the reference date
///-----------------------------------------------

+ (NSDate *)date; // in year, around current date

+ (NSDate *)dateInRange:(GZDatesRange)within; // around current date

+ (NSDate *)daysForward:(NSUInteger)days;
+ (NSDate *)daysBackward:(NSUInteger)days;

+ (NSDate *)daysFromNow:(NSInteger)days; // from Now

+ (NSDate *)daysAroundNow:(NSInteger)days; // from Now

+ (NSDate *)birthday; // defaults to min 18 and max 65
+ (NSDate *)birthdayForAgesBetween:(NSUInteger)minAge and:(NSUInteger)maxAge;


///-----------------------------------------------
/// @name Using custom reference dates
///-----------------------------------------------

+ (NSDate *)dateInRange:(GZDatesRange)within around:(NSDate *)referenceDate;
+ (NSDate *)days:(NSInteger)days from:(NSDate *)referenceDate;
+ (NSDate *)days:(NSUInteger)days around:(NSDate *)referenceDate;
+ (NSDate *)dateBetween:(NSDate *)from and:(NSDate *)to;

@end
