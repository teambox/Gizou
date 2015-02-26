//
//  GZNumbers.h
//
//  Created by Maria Bernis on 20/02/15.
//

#import <Foundation/Foundation.h>

@interface GZNumbers : NSObject

+ (NSNumber *)randomBOOL;
+ (NSNumber *)randomInteger;
+ (NSNumber *)randomNonZeroInteger;
/* Use at your own risk */
+ (NSNumber *)randomUniqueID;
+ (NSNumber *)randomIndex:(id)enumerable;
+ (NSNumber *)randomIntegerLessThan:(int32_t)lessThan;
+ (NSNumber *)randomIntegerBiggerThan:(int32_t)startingAt;
+ (NSNumber *)randomIntegerBetween:(int32_t)min and:(int32_t)max;
+ (NSNumber *)randomFloatBetween:(float)min and:(float)max;

@end
