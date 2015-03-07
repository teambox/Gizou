//
//  GZDate.h
//  
//
//  Created by Maria Bernis on 05/03/15.
//
//

#import <Foundation/Foundation.h>

@interface GZDates : NSObject

+ (NSDate *)dateBetween:(NSDate *)from and:(NSDate *)to;

+ (NSDate *)daysForward:(NSUInteger)days;
+ (NSDate *)daysBackward:(NSUInteger)days;
+ (NSDate *)yearsForward:(NSUInteger)days;
+ (NSDate *)yearsBackward:(NSUInteger)days;

// +- 6 months from now
+ (NSDate *)dateWhitinYear;

// +- 5 years from now
+ (NSDate *)dateWhitinDecade;

// +-50 years from now
+ (NSDate *)dateWithinCentury;


@end
