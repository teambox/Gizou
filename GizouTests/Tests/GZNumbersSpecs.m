#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "Gizou.h"

@interface GZNumbersTests : GZNumbers
+ (NSNumber *)test_randomNonZeroInteger;
+ (NSNumber *)test_randomIntegerStartingAt:(int32_t)startingAt;
@end

@implementation GZNumbersTests

/**
 *  Implemented the same as GZNumber `randomNonZeroInteger` but setting a low max
 *  so the non zero condition can be tested.
 *
 *  @return random integer between 1 and 3.
 */
+ (NSNumber *)test_randomNonZeroInteger
{
    return @(arc4random_uniform(3) + 1);
}

/**
 *  Implemented as GZNumber `randomIntegerStartingAt:` but setting 
 *  a low max value so the starting value can be tested.
 *
 *  @param startingAt First possible random value.
 *
 *  @return Number containing random integer equal or greater than `startingAt` value.
 */
+ (NSNumber *)test_randomIntegerStartingAt:(int32_t)startingAt
{
    return [self randomIntegerBetween:startingAt and:startingAt + 3];
}

@end


SpecBegin(GZNumbersSpec)

describe(@"Random numbers", ^{
    
    context(@"randomBool", ^{
        __block NSMutableArray *randomBools;
        beforeEach(^{
            randomBools = [NSMutableArray array];
            for (int i = 0; i < 50; i++) {
                NSNumber *b = [GZNumbers randomBOOL];
                [randomBools addObject:b];
            }
        });
        
        it(@"returns 0 or 1 numbers", ^{
            NSArray *zeros = [randomBools filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == 0"]];
            NSArray *ones = [randomBools filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == 1"]];
            expect(zeros.count + ones.count).to.equal(randomBools.count);
        });
        it(@"returns some 0 number", ^{
            expect(randomBools).to.contain(@0);
        });
        it(@"returns some 1 number", ^{
            expect(randomBools).to.contain(@1);
        });
    });
    
    context(@"randomInteger", ^{
        __block NSMutableArray *randomInts;
        beforeEach(^{
            randomInts = [NSMutableArray array];
            for (int i = 0; i < 20; i++) {
                NSNumber *n = [GZNumbers randomInteger];
                [randomInts addObject:n];
            }
        });
        
        it(@"returns different values", ^{
            NSInteger someValue1 = [randomInts[3] integerValue];
            NSInteger someValue2 = [randomInts[7] integerValue];
            NSArray *value1Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
            NSArray *value2Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue2]];
            expect(value1Array.count + value2Array.count).to.beLessThan(randomInts.count);
        });
    });
    
    context(@"randomNonZeroInteger", ^{
        __block NSMutableArray *randomInts;
        beforeEach(^{
            randomInts = [NSMutableArray array];
            for (int i = 0; i < 10; i++) {
                NSNumber *n = [GZNumbersTests test_randomNonZeroInteger];
                [randomInts addObject:n];
            }
        });
        
        it(@"returns different values", ^{
            NSInteger someValue1 = [randomInts[3] integerValue];
            NSArray *value1Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
            expect(value1Array.count).to.beLessThan(randomInts.count);
        });
        it(@"doesn't return any 0 number", ^{
            expect(randomInts).notTo.contain(@0);
        });
    });
    
    context(@"randomIntegerBetween:1 and:3", ^{
        __block NSMutableArray *randomInts;
        beforeEach(^{
            randomInts = [NSMutableArray array];
            for (int i = 0; i < 50; i++) {
                NSNumber *n = [GZNumbers randomIntegerBetween:1 and:3];
                [randomInts addObject:n];
            }
        });
        
        it(@"returns numbers equal or bigger than 1", ^{
            NSArray *oneOrBigger = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue >= 1"]];
            expect(oneOrBigger.count).to.equal(randomInts.count);
        });
        it(@"returns numbers equal or less than 3", ^{
            NSArray *threeOrLess = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue <= 3"]];
            expect(threeOrLess.count).to.equal(randomInts.count);
        });
        it(@"returns some 1 numbers", ^{
            NSArray *ones = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == 1"]];
            expect(ones.count).to.beGreaterThanOrEqualTo(1);
        });
        it(@"returns some 3 numbers", ^{
            NSArray *threes = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == 3"]];
            expect(threes.count).to.beGreaterThanOrEqualTo(1);
        });
    });
    
    context(@"randomIndex:", ^{
        context(@"for an object that has no count nor length", ^{
            __block id obj;
            beforeEach(^{
                obj = [NSObject new];
            });
            
            it(@"should throw exception", ^{
                expect(^{[GZNumbers randomIndex:obj];}).to.raiseAny();
            });
        });
        
        context(@"for an object that can be count", ^{
            __block NSArray *collectionObj;
            __block NSMutableArray *randomIndexes;
            beforeEach(^{
                collectionObj = @[@100, @300, @300];
                randomIndexes = [NSMutableArray array];
                for (int i = 0; i < 100; i++) {
                    NSNumber *n = [GZNumbers randomIndex:collectionObj];
                    [randomIndexes addObject:n];
                }
            });
            
            it(@"returns different values", ^{
                NSInteger someValue1 = [randomIndexes[3] integerValue];
                NSArray *value1Array = [randomIndexes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
                expect(value1Array.count).to.beLessThan(randomIndexes.count);
            });
            it(@"returns numbers between 0 and count-1", ^{
                expect(randomIndexes).to.contain(@0);
                expect(randomIndexes).to.contain([collectionObj count]-1);
            });
        });
        
        context(@"for an object that has a length", ^{
            __block NSString *dataObj;
            __block NSMutableArray *randomIndexes;
            beforeEach(^{
                dataObj = @"Ola";
                randomIndexes = [NSMutableArray array];
                for (int i = 0; i < 50; i++) {
                    NSNumber *n = [GZNumbers randomIndex:dataObj];
                    [randomIndexes addObject:n];
                }
            });
            
            it(@"returns different values", ^{
                NSInteger someValue1 = [randomIndexes[3] integerValue];
                NSArray *value1Array = [randomIndexes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
                expect(value1Array.count).to.beLessThan(randomIndexes.count);
            });
            it(@"returns numbers between 0 and length-1", ^{
                expect(randomIndexes).to.contain(@0);
                expect(randomIndexes).to.contain([dataObj length]-1);
            });
        });
    });
    
    context(@"randomIntegerLessThan:4", ^{
        __block NSMutableArray *randomInts;
        beforeEach(^{
            randomInts = [NSMutableArray array];
            for (int i = 0; i < 50; i++) {
                NSNumber *n = [GZNumbers randomIntegerLessThan:4];
                [randomInts addObject:n];
            }
        });
        
        it(@"returns numbers equal or bigger than 0", ^{
            NSArray *oneOrBigger = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue >= 0"]];
            expect(oneOrBigger.count).to.equal(randomInts.count);
        });
        it(@"returns numbers less than 4 (max value is 3)", ^{
            NSArray *threeOrLess = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue < 4"]];
            expect(threeOrLess.count).to.equal(randomInts.count);
        });
    });
    
    context(@"randomIntegerStartingAt:3", ^{
        __block NSMutableArray *randomInts;
        beforeEach(^{
            randomInts = [NSMutableArray array];
            for (int i = 0; i < 50; i++) {
                NSNumber *n = [GZNumbersTests test_randomIntegerStartingAt:3];
                [randomInts addObject:n];
            }
        });
        
        it(@"returns different values", ^{
            NSInteger someValue1 = [randomInts[3] integerValue];
            NSArray *value1Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
            expect(value1Array.count).to.beLessThan(randomInts.count);
        });
        it(@"returns numbers equal or bigger than 3", ^{
            NSArray *threeOrBigger = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue >= 3"]];
            expect(threeOrBigger.count).to.equal(randomInts.count);
        });
    });
    
    context(@"randomFloatBetween:5 and:8", ^{
        __block NSMutableArray *randomfloats;
        beforeEach(^{
            randomfloats = [NSMutableArray array];
            for (int i = 0; i < 100; i++) {
                NSNumber *n = [GZNumbers randomFloatBetween:5 and:8];
                [randomfloats addObject:n];
            }
        });
        
        it(@"returns numbers with decimals", ^{
            NSMutableArray *onlyDecimals = [NSMutableArray array];
            [randomfloats enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSNumber *num = (NSNumber *)obj;
                if ((num.floatValue - num.integerValue) != 0) [onlyDecimals addObject:num];
            }];
            expect(onlyDecimals).to.haveCountOf(randomfloats.count);
        });
        it(@"returns different values", ^{
            NSInteger someValue1 = [randomfloats[3] integerValue];
            NSInteger someValue2 = [randomfloats[10] integerValue];
            NSArray *value1Array = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
            NSArray *value2Array = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue2]];
            expect(value1Array.count + value2Array.count).to.beLessThan(randomfloats.count);
        });
        it(@"returns numbers equal or bigger than 5", ^{
            NSArray *fiveOrBigger = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue >= 5"]];
            expect(fiveOrBigger.count).to.equal(randomfloats.count);
        });
        it(@"returns numbers equal or less than 8", ^{
            NSArray *eightOrLess = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue <= 8"]];
            expect(eightOrLess.count).to.equal(randomfloats.count);
        });
    });
});

SpecEnd
