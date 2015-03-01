//
//  GZNumbers.m
//  Redbooth
//
//  Created by Maria Bernis on 20/02/15.
//  Copyright (c) 2015 teambox. All rights reserved.
//

#import "GZNumbers.h"

#define kINTMAX INT32_MAX


@implementation GZNumbers

+ (NSNumber *)randomBOOL
{
    return @(arc4random_uniform(2));
}

+ (NSNumber *)randomInteger
{
    return @(arc4random_uniform(kINTMAX));
}

+ (NSNumber *)randomNonZeroInteger
{
    return @(arc4random_uniform(kINTMAX) + 1);
}

+ (NSNumber *)randomIndex:(id)enumerable
{
    u_int32_t idx = 0;
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

+ (NSNumber *)randomIntegerStartingAt:(int32_t)startingAt
{
    return [self randomIntegerBetween:startingAt and:kINTMAX];
}

+ (NSNumber *)randomIntegerBetween:(int32_t)min and:(int32_t)max
{
    int32_t rndInRange = min + arc4random_uniform(max - min + 1);
    return @(rndInRange);
}

+ (NSNumber *)randomFloatBetween:(float)min and:(float)max
{
    float diff = max - min;
    unsigned int rInt = arc4random_uniform(kINTMAX) + 1;
    float r = ((float) rInt / kINTMAX * diff) + min;
    
    return @(r);
}


#pragma mark - Helpers

+ (BOOL)returnManyValue
{
    return ![self returnFewValue];
}

// Asymmetry tending to 85% NOs vs 15% YESs
+ (BOOL)returnFewValue
{
    u_int32_t r10 = arc4random_uniform(10) + 1; // In [1, 10]
    if ((r10 % 3) == 0) {
        return YES; // Only 15% of the times (propability)
    }
    return NO;
}

@end


@implementation GZNumbers (Booleans)

+ (NSNumber *)yesOrNo
{
    u_int32_t rndBool = arc4random_uniform(2);
    return rndBool == 1 ? @YES : @NO;
}

+ (NSNumber *)yesOrNoMostly:(BOOL)m
{
    NSNumber *randomBool = [self yesOrNo];
    if (m == randomBool.boolValue) {
        return randomBool;
    }
    return [self returnManyValue] ? @(m) : randomBool;
}

@end


@implementation GZNumbers (NaturalNumbers)

+ (NSNumber *)integerN
{
    return @(arc4random_uniform(kINTMAX));
}

+ (NSNumber *)integerNNonZero
{
    return @(arc4random_uniform(kINTMAX) + 1);
}

+ (NSNumber *)integerNLessOrEqual:(u_int32_t)max
{
    return [self integerNBetween:0 and:max];
}

+ (NSNumber *)integerNBiggerOrEqual:(u_int32_t)min
{
    return [self integerNBetween:min and:kINTMAX];
}

+ (NSNumber *)integerNBetween:(u_int32_t)min and:(u_int32_t)max
{
    NSInteger diff = (NSInteger)max - (NSInteger)min;
    if (diff < 0) {
        diff = -diff;
        u_int32_t newMin = max;
        u_int32_t newMax = min;
        min = newMin;
        max = newMax;
    }
    // Make sure number is never over INT32 limit in case it is used for sqlite, for eg.
    if (min >= INT32_MAX) {
        min = INT32_MAX;
    }
    if (max >= INT32_MAX) {
        max = INT32_MAX;
    }
    if (diff == 0) {
        return @(max);
    }
    u_int32_t rndInRange = min + arc4random_uniform((u_int32_t)diff + 1);
    return @(rndInRange);
}


#pragma mark - Asymmetric

+ (NSNumber *)integerNBetween:(u_int32_t)min
                          and:(u_int32_t)max
                         many:(NSNumber *)m
                          few:(NSNumber *)f
{
    NSNumber *random = [self integerNBetween:min and:max];
    if (!m && !f) {
        return random;
    }
    
    if (m && m.integerValue != random.integerValue) {
        if ([self returnManyValue]) {
            return @(m.integerValue);
        }
    }
    if (f && f.integerValue == random.integerValue) {
        if (![self returnFewValue]) {
            return [self integerNBetween:min and:max many:nil few:f];
        }
    }
    return random;
}

@end

