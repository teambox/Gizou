//
//  GZNumbers.m
//  Redbooth
//
//  Created by Maria Bernis on 20/02/15.
//  Copyright (c) 2015 teambox. All rights reserved.
//

#import "GZNumbers.h"

@implementation GZNumbers

+ (NSNumber *)randomBOOL
{
    return @(arc4random_uniform(2));
}

+ (NSNumber *)randomInteger
{
    return @(arc4random_uniform(INT32_MAX));
}

+ (NSNumber *)randomNonZeroInteger
{
    return @(arc4random_uniform(INT32_MAX) + 1);
}

/* Use at your own risk */
+ (NSNumber *)randomUniqueID
{
    return [self randomIntegerBiggerThan:1000000];
}

+ (NSNumber *)randomIndex:(id)enumerable
{
    NSUInteger idx = 0;
    if ([enumerable respondsToSelector:@selector(count)]) {
        idx = arc4random_uniform([enumerable count]);
    }
    else if ([enumerable respondsToSelector:@selector(length)]) {
        idx = arc4random_uniform([enumerable length]);
    }
    else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Tried to use randomIndex on a object with no count or length attribute"
                                     userInfo:nil];
    }
    return @(idx);
}

+ (NSNumber *)randomIntegerLessThan:(int32_t)lessThan
{
    return @(arc4random_uniform(lessThan));
}

+ (NSNumber *)randomIntegerBiggerThan:(int32_t)startingAt
{
    return [self randomIntegerBetween:startingAt and:INT32_MAX];
}

+ (NSNumber *)randomIntegerBetween:(int32_t)min and:(int32_t)max
{
    int32_t rndInRange = min + arc4random_uniform(max - min + 1);
    return @(rndInRange);
}

+ (NSNumber *)randomFloatBetween:(float)min and:(float)max
{
    float diff = max - min;
    
    float r = (
               (
                (float) (arc4random_uniform((unsigned)RAND_MAX + 1)) / RAND_MAX
                ) * diff
               )
    + min;
    
    return @(r);
}

@end
