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
+ (NSNumber *)randomIntegerLessThan:(int32_t)lessThan;
+ (NSNumber *)randomIntegerStartingAt:(int32_t)startingAt;
+ (NSNumber *)randomIntegerBetween:(int32_t)min and:(int32_t)max;
+ (NSNumber *)randomIndex:(id)enumerable;
+ (NSNumber *)randomFloatBetween:(float)min and:(float)max;

@end


@interface GZNumbers (Booleans)

/**
 *
 *  @return YES, NO
 */
+ (NSNumber *)yesOrNo;

/**
 *
 *  @param m Predominant bool value
 *
 *  @return YES, NO with `mostly` value more than 80% of the times.
 */
+ (NSNumber *)yesOrNoMostly:(BOOL)m;

@end


@interface GZNumbers (NaturalNumbers)

/**
 *  Any natural number including 0 (ie. unsigned integers).
 *
 *  @return 0, 1, 2,...,INT32_MAX-1
 */
+ (NSNumber *)integerN;

/**
 *  Any natural number excluding 0.
 *
 *  @return 1, 2,..., INT32_MAX
 */
+ (NSNumber *)integerNNonZero;

/**
 *  Any natural number from 0 to MAX.
 *  This method just invokes `integerNBetween:0 and:MAX`.
 *
 *  @param max Maximum desired value that may be generated.
 *
 *  @return 0, 1,..., MAX
 *
 *  @see `integerNBetween:and:`
 */
+ (NSNumber *)integerNLessOrEqual:(u_int32_t)max;

/**
 *  Any natural number from MIN to INT32_MAX.
 *  This method just invokes `integerNBetween:MIN and:INT32_MAX`.
 *
 *  @param min Minimum desired value that may be generated.
 *
 *  @return MIN, MIN+1, MIN+2,..., INT32_MAX
 *
 *  @see `integerNBetween:and:`
 */
+ (NSNumber *)integerNBiggerOrEqual:(u_int32_t)min;

/**
 *  Any natural number from MIN to MAX.
 *
 *  @param min Minimum desired value that may be generated.
 *  @param max Maximum desired value that may be generated.
 *
 *  @return MIN, MIN+1, MIN+2,..., MAX
 *
 *  @discussion MIN and MAX must be unsigned integers less than INT32_MAX. If not, INT32_MAX will be used for that parameter.
 */
+ (NSNumber *)integerNBetween:(u_int32_t)min and:(u_int32_t)max; //min,..max


///--------------------------------
//  @name Asymmetric natural numbers
///--------------------------------

/**
 *  Any natural number from MIN to MAX with predominant value MANY and/or scarce value FEW if provided. Both MANY and FEW are optional parameters.
 *
 *  @param min Minimum desired value that may be generated.
 *  @param max Maximum desired value that may be generated.
 *  @param m   Number with the desired integer to be predominant.
 *  @param f   Number with the desired integer to be scarce.
 *
 *  @return MIN, MIN+1, MIN+2,..., MAX with `MANY` value ca 70% of the times and FEW less than 10% of the times aprox, depending on the range.
 *
 *  @discussion Same integer limits apply as in `integerNBetween:and`
 *
 *  @see `integerNBetween:and:`
 */
+ (NSNumber *)integerNBetween:(u_int32_t)min and:(u_int32_t)max many:(NSNumber *)m few:(NSNumber *)f;

@end


@interface GZNumbers (ZNumbers)

+ (NSNumber *)integerZ; // all integers: ..,-2, -1, 0, 1, 2,...
+ (NSNumber *)integerZNonZero; // .., -2, -1, 1, 2,...
+ (NSNumber *)integerZEndingAt:(int32_t)max; // .., -2, -1, 0, 1,...,n
+ (NSNumber *)integerZStartingAt:(int32_t)min; // n, n+1,...
+ (NSNumber *)integerZBetween:(int32_t)min and:(int32_t)max; // min,..,max

+ (NSNumber *)negativeInteger; // all negative integers: ..,-2, -1, 0
+ (NSNumber *)negativeIntegerNonZero; // .., -2, -1

+ (NSNumber *)integerZBetween:(int32_t)min and:(int32_t)max many:(NSNumber *)m few:(NSNumber *)f;

@end


@interface GZNumbers (DecimalNumbers)

+ (NSNumber *)randomFloatBetween:(float)min and:(float)max;

@end


@interface GZNumbers (Indexes)

+ (NSNumber *)indexFrom:(id)enumerableObj;
+ (NSNumber *)indexFrom:(id)enumerableObj many:(NSNumber *)m few:(NSNumber *)f;

@end


