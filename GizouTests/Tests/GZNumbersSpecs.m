#import "GZTests.h"
#import "Gizou.h"

@interface GZNumbersTests : GZNumbers
+ (NSNumber *)test_randomNonZeroInteger;
+ (NSNumber *)test_randomIntegerStartingAt:(int32_t)startingAt;
+ (NSNumber *)test_integerNNonZero;
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

/**
 *  Implemented the same as GZNumber `integerNNonZero` but setting a low max
 *  so the non zero condition can be tested.
 *
 *  @return random integer between 1 and 3.
 */
+ (NSNumber *)test_integerNNonZero
{
    return @(arc4random_uniform(3) + 1);
}

+ (NSCountedSet *)test_integersSetOfSize:(NSUInteger)size using:(NSNumber *(^)(void))block
{
    NSMutableArray *randomNumbers = [NSMutableArray array];
    for (int i = 0; i < size; i++) {
        NSNumber *n = block();
        [randomNumbers addObject:n];
    }
    return [[NSCountedSet alloc] initWithArray:randomNumbers];
}

@end


SpecBegin(GZNumbersBooleansSpec)

describe(@"+yesOrNo (random bool)", ^{
    __block int total;
    __block NSCountedSet *differentBools;
    beforeEach(^{
        total = 10000;
        differentBools = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
            return [GZNumbers yesOrNo];
        }];
    });
    
    it(@"returns different values", ^{
        expect(differentBools).to.haveCountOf(2);
    });
    it(@"returns YES values", ^{
        expect(differentBools).to.contain(@YES);
    });
    it(@"returns NO values", ^{
        expect(differentBools).to.contain(@NO);
    });
});

context(@"asymmetric random bools", ^{
    describe(@"+yesOrNoMostly:", ^{
        __block int total;
        __block BOOL predominant;
        __block NSCountedSet *differentBools;
        beforeEach(^{
            total = 10000;
            predominant = YES;
            differentBools = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                return [GZNumbers yesOrNoMostly:predominant];
            }];
        });
        
        it(@"returns different values", ^{
            expect(differentBools).to.haveCountOf(2);
        });
        it(@"returns YES values", ^{
            expect(differentBools).to.contain(@YES);
        });
        it(@"returns NO values", ^{
            expect(differentBools).to.contain(@NO);
        });
        it(@"returns much more predominant values", ^{
            expect([differentBools countForObject:@(predominant)]).to.beGreaterThan(0.8*total);
        });
    });
});

SpecEnd


SpecBegin(GZNumbersNaturalNumbersSpec)

describe(@"+integerN", ^{
    __block int total;
    __block NSCountedSet *differentInts;
    beforeEach(^{
        total = 1000;
        differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
            return [GZNumbers integerN];
        }];
    });
    
    it(@"returns integers", ^{
        NSSet *decimalsSet = [differentInts objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSNumber *num = (NSNumber *)obj;
            return (num.floatValue - num.integerValue) != 0;
        }];
        expect(decimalsSet).to.haveCountOf(0);
    });
    it(@"returns different values", ^{
        expect(differentInts.count).to.beGreaterThan(0.7*total);
    });
});

describe(@"+integerNNonZero", ^{
    __block int total;
    __block NSCountedSet *differentInts;
    beforeEach(^{
        total = 1000;
        differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
            return [GZNumbersTests test_integerNNonZero];
        }];
    });
    
    it(@"returns different values", ^{
        expect(differentInts).to.haveCountOf(3);
    });
    it(@"doesn't return any 0 number", ^{
        expect(differentInts).notTo.contain(@0);
    });
});

describe(@"+integerNBetween:min and:max", ^{
    __block u_int32_t min;
    __block u_int32_t max;
    __block int total;
    __block NSCountedSet *differentInts;
    
    beforeAll(^{
        total = 1000;
    });
    
    context(@"min equals max", ^{
        context(@"max is 0", ^{
            beforeEach(^{
                min = 0;
                max = 0;
                differentInts = [GZNumbersTests test_integersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max];
                }];
            });
            
            it(@"returns max always", ^{
                expect(differentInts).to.haveCountOf(1);
                expect(differentInts).to.contain(@0);
            });
        });
        
        context(@"max is INT MAX or bigger", ^{
            beforeEach(^{
                min = INT32_MAX + 10;
                max = INT32_MAX + 10;
                differentInts = [GZNumbersTests test_integersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max];
                }];
            });
            
            it(@"returns INT MAX always", ^{
                expect(differentInts).to.haveCountOf(1);
                expect(differentInts).to.contain(@(INT32_MAX));
            });
        });
        
        context(@"when max is 50", ^{
            beforeEach(^{
                min = 50;
                max = 50;
                differentInts = [GZNumbersTests test_integersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max];
                }];
            });
            
            it(@"returns max always", ^{
                expect(differentInts).to.haveCountOf(1);
                expect(differentInts).to.contain(@50);
            });
        });
    });
    
    context(@"min different from max", ^{
        context(@"when min lt max", ^{
            context(@"when min is 0", ^{
                beforeEach(^{
                    min = 0;
                    max = 2;
                    differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers integerNBetween:min and:max];
                    }];
                });
                
                it(@"returns different values ranging [0,2]", ^{
                    expect(differentInts).to.haveCountOf(max - min + 1);
                });
                it(@"returns some 0 values", ^{
                    expect(differentInts).to.contain(@0);
                });
                it(@"returns some 1 values", ^{
                    expect(differentInts).to.contain(@1);
                });
                it(@"returns some 2 values", ^{
                    expect(differentInts).to.contain(@2);
                });
            });
            
            context(@"when min non 0", ^{
                beforeEach(^{
                    min = 1;
                    max = 3;
                    differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers integerNBetween:min and:max];
                    }];
                });
                
                it(@"returns different values ranging [min,max]", ^{
                    expect(differentInts).to.haveCountOf(max - min + 1);
                });
                it(@"returns some 1 values", ^{
                    expect(differentInts).to.contain(@1);
                });
                it(@"returns some 2 values", ^{
                    expect(differentInts).to.contain(@2);
                });
                it(@"returns some 3 values", ^{
                    expect(differentInts).to.contain(@3);
                });
            });
        });
        
        context(@"when min gt max", ^{
            context(@"when max is 0", ^{
                beforeEach(^{
                    min = 2;
                    max = 0;
                    differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers integerNBetween:min and:max];
                    }];
                });
                
                it(@"returns different values between 0 and min", ^{
                    expect(differentInts).to.haveCountOf(min - max + 1);
                });
                it(@"returns some 0 values", ^{
                    expect(differentInts).to.contain(@0);
                });
                it(@"returns some 1 values", ^{
                    expect(differentInts).to.contain(@1);
                });
                it(@"returns some 2 values", ^{
                    expect(differentInts).to.contain(@2);
                });
            });
            
            context(@"when max non 0", ^{
                beforeEach(^{
                    min = 9;
                    max = 7;
                    differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers integerNBetween:min and:max];
                    }];
                });
                
                it(@"returns different values between MAX and min", ^{
                    expect(differentInts).to.haveCountOf(min - max + 1);
                });
                it(@"returns some 9 values", ^{
                    expect(differentInts).to.contain(@9);
                });
                it(@"returns some 8 values", ^{
                    expect(differentInts).to.contain(@8);
                });
                it(@"returns some 7 values", ^{
                    expect(differentInts).to.contain(@7);
                });
            });
        });
    });
});

context(@"asymmetric random integers", ^{
    describe(@"+integerNBetween:min and:max many:m few:f", ^{
        __block u_int32_t min;
        __block u_int32_t max;
        __block NSNumber *m;
        __block NSNumber *f;
        __block int total;
        __block NSCountedSet *differentInts;
        beforeAll(^{
            min = 0;
            max = 3;
        });
        
        context(@"when no many, no few", ^{
            beforeEach(^{
                total = 1000;
                m = nil;
                f = nil;
                differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max many:nil few:nil];
                }];
            });
            it(@"returns different values ranging [min,max]", ^{
                expect(differentInts).to.haveCountOf(max - min + 1);
            });
            it(@"returns 0, 1, 2 and 3 values", ^{
                expect(differentInts).to.contain(@0);
                expect(differentInts).to.contain(@1);
                expect(differentInts).to.contain(@2);
                expect(differentInts).to.contain(@3);
            });

            it(@"returns similar quantity of each", ^{
                expect([differentInts countForObject:@0]).to.beLessThan(0.3*total);
                expect([differentInts countForObject:@1]).to.beLessThan(0.3*total);
                expect([differentInts countForObject:@2]).to.beLessThan(0.3*total);
                expect([differentInts countForObject:@3]).to.beLessThan(0.3*total);
            });
        });
        
        context(@"when passing many, no few", ^{
            beforeEach(^{
                total = 10000;
                m = @1;
                f = nil;
                differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max many:m few:nil];
                }];
            });
            
            it(@"returns different values ranging [min,max]", ^{
                expect(differentInts).to.haveCountOf(max - min + 1);
            });
            it(@"returns 0, 1, 2 and 3 values", ^{
                expect(differentInts).to.contain(@0);
                expect(differentInts).to.contain(@1);
                expect(differentInts).to.contain(@2);
                expect(differentInts).to.contain(@3);
            });
            it(@"returns much more of the many value", ^{
                expect([differentInts countForObject:m]).to.beGreaterThan(0.75*total);
            });
            it(@"returns similar quantities for the non predominant values", ^{
                expect([differentInts countForObject:@0]).to.beLessThan(0.1*total);
                expect([differentInts countForObject:@2]).to.beLessThan(0.1*total);
                expect([differentInts countForObject:@3]).to.beLessThan(0.1*total);
            });
        });
        
        context(@"when passing few, no many", ^{
            beforeEach(^{
                total = 10000;
                m = nil;
                f = @1;
                differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max many:nil few:f];
                }];
            });
            
            it(@"returns different values ranging [min,max]", ^{
                expect(differentInts).to.haveCountOf(max - min + 1);
            });
            it(@"returns 0, 1, 2 and 3 values", ^{
                expect(differentInts).to.contain(@0);
                expect(differentInts).to.contain(@1);
                expect(differentInts).to.contain(@2);
                expect(differentInts).to.contain(@3);
            });
            it(@"returns much less of the few value", ^{
                expect([differentInts countForObject:f]).to.beLessThan(0.1*total);
            });
            it(@"returns similar quantities for the predominant values", ^{
                expect([differentInts countForObject:@0]).to.beLessThan(0.33*total);
                expect([differentInts countForObject:@2]).to.beLessThan(0.33*total);
                expect([differentInts countForObject:@3]).to.beLessThan(0.33*total);
            });
        });
        
        context(@"when passing both many and few", ^{
            beforeEach(^{
                total = 10000;
                m = @1;
                f = @0;
                differentInts = [GZNumbersTests test_integersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerNBetween:min and:max many:m few:f];
                }];
            });
            
            it(@"returns different values ranging [min,max]", ^{
                expect(differentInts).to.haveCountOf(max - min + 1);
            });
            it(@"returns 0, 1, 2 and 3 values", ^{
                expect(differentInts).to.contain(@0);
                expect(differentInts).to.contain(@1);
                expect(differentInts).to.contain(@2);
                expect(differentInts).to.contain(@3);
            });
            it(@"returns much more of the many value", ^{
                expect([differentInts countForObject:m]).to.beGreaterThan(0.7*total);
            });
            it(@"returns much less of the few value", ^{
                expect([differentInts countForObject:f]).to.beLessThan(0.05*total);
            });
            it(@"returns similar quantities for the rest of the values", ^{
                expect([differentInts countForObject:@2]).to.beLessThan(0.1*total);
                expect([differentInts countForObject:@3]).to.beLessThan(0.1*total);
            });
        });
    });
});

SpecEnd


SpecBegin(GZNumbersSpec)

//describe(@"Random numbers", ^{
//    
//    context(@"randomBool", ^{
//        __block NSMutableArray *randomBools;
//        beforeEach(^{
//            randomBools = [NSMutableArray array];
//            for (int i = 0; i < 50; i++) {
//                NSNumber *b = [GZNumbers randomBOOL];
//                [randomBools addObject:b];
//            }
//        });
//        
//        it(@"returns 0 or 1 numbers", ^{
//            NSArray *zeros = [randomBools filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == 0"]];
//            NSArray *ones = [randomBools filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == 1"]];
//            expect(zeros.count + ones.count).to.equal(randomBools.count);
//        });
//        it(@"returns some 0 number", ^{
//            expect(randomBools).to.contain(@0);
//        });
//        it(@"returns some 1 number", ^{
//            expect(randomBools).to.contain(@1);
//        });
//    });
//    
//    context(@"randomInteger", ^{
//        __block NSMutableArray *randomInts;
//        beforeEach(^{
//            randomInts = [NSMutableArray array];
//            for (int i = 0; i < 20; i++) {
//                NSNumber *n = [GZNumbers randomInteger];
//                [randomInts addObject:n];
//            }
//        });
//        
//        it(@"returns different values", ^{
//            NSInteger someValue1 = [randomInts[3] integerValue];
//            NSInteger someValue2 = [randomInts[7] integerValue];
//            NSArray *value1Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
//            NSArray *value2Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue2]];
//            expect(value1Array.count + value2Array.count).to.beLessThan(randomInts.count);
//        });
//    });
//    
//    context(@"randomNonZeroInteger", ^{
//        __block NSMutableArray *randomInts;
//        beforeEach(^{
//            randomInts = [NSMutableArray array];
//            for (int i = 0; i < 10; i++) {
//                NSNumber *n = [GZNumbersTests test_randomNonZeroInteger];
//                [randomInts addObject:n];
//            }
//        });
//        
//        it(@"returns different values", ^{
//            NSInteger someValue1 = [randomInts[3] integerValue];
//            NSArray *value1Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
//            expect(value1Array.count).to.beLessThan(randomInts.count);
//        });
//        it(@"doesn't return any 0 number", ^{
//            expect(randomInts).notTo.contain(@0);
//        });
//    });
//    
//    context(@"randomIntegerBetween:1 and:3", ^{
//        __block NSMutableArray *randomInts;
//        beforeEach(^{
//            randomInts = [NSMutableArray array];
//            for (int i = 0; i < 200; i++) {
//                NSNumber *n = [GZNumbers randomIntegerBetween:1 and:3];
//                [randomInts addObject:n];
//            }
//        });
//        
//        it(@"returns numbers equal or bigger than 1", ^{
//            NSArray *oneOrBigger = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue >= 1"]];
//            expect(oneOrBigger.count).to.equal(randomInts.count);
//        });
//        it(@"returns numbers equal or less than 3", ^{
//            NSArray *threeOrLess = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue <= 3"]];
//            expect(threeOrLess.count).to.equal(randomInts.count);
//        });
//        it(@"returns some 1 numbers", ^{
//            expect(randomInts).to.contain(@1);
//        });
//        it(@"returns some 3 numbers", ^{
//            expect(randomInts).to.contain(3);
//        });
//    });
//    // TODO edge cases: passing int MAX and passing 1st value bigger than 2nd value
//    
//    context(@"randomIntegerLessThan:4", ^{
//        __block NSMutableArray *randomInts;
//        beforeEach(^{
//            randomInts = [NSMutableArray array];
//            for (int i = 0; i < 50; i++) {
//                NSNumber *n = [GZNumbers randomIntegerLessThan:4];
//                [randomInts addObject:n];
//            }
//        });
//        
//        it(@"returns numbers equal or bigger than 0", ^{
//            NSArray *oneOrBigger = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue >= 0"]];
//            expect(oneOrBigger.count).to.equal(randomInts.count);
//        });
//        it(@"returns numbers less than 4 (max value is 3)", ^{
//            NSArray *threeOrLess = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue < 4"]];
//            expect(threeOrLess.count).to.equal(randomInts.count);
//            expect(randomInts).notTo.contain(@4);
//        });
//    });
//    
//    context(@"randomIntegerStartingAt:3", ^{
//        __block NSMutableArray *randomInts;
//        beforeEach(^{
//            randomInts = [NSMutableArray array];
//            for (int i = 0; i < 100; i++) {
//                NSNumber *n = [GZNumbersTests test_randomIntegerStartingAt:3];
//                [randomInts addObject:n];
//            }
//        });
//        
//        it(@"returns different values", ^{
//            NSInteger someValue1 = [randomInts[3] integerValue];
//            NSArray *value1Array = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
//            expect(value1Array.count).to.beLessThan(randomInts.count);
//        });
//        it(@"returns numbers equal or bigger than 3", ^{
//            NSArray *threeOrBigger = [randomInts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue >= 3"]];
//            expect(threeOrBigger.count).to.equal(randomInts.count);
//            expect(randomInts).to.contain(@3);
//        });
//    });
//    
//    context(@"randomIndex:", ^{
//        context(@"for an object that has no count nor length", ^{
//            __block id obj;
//            beforeEach(^{
//                obj = [NSObject new];
//            });
//            
//            it(@"should throw exception", ^{
//                expect(^{[GZNumbers randomIndex:obj];}).to.raiseAny();
//            });
//        });
//        
//        context(@"for an object that can be count", ^{
//            __block NSArray *collectionObj;
//            __block NSMutableArray *randomIndexes;
//            beforeEach(^{
//                collectionObj = @[@100, @300, @300];
//                randomIndexes = [NSMutableArray array];
//                for (int i = 0; i < 100; i++) {
//                    NSNumber *n = [GZNumbers randomIndex:collectionObj];
//                    [randomIndexes addObject:n];
//                }
//            });
//            
//            it(@"returns different values", ^{
//                NSInteger someValue1 = [randomIndexes[3] integerValue];
//                NSArray *value1Array = [randomIndexes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
//                expect(value1Array.count).to.beLessThan(randomIndexes.count);
//            });
//            it(@"returns numbers between 0 and count-1", ^{
//                expect(randomIndexes).to.contain(@0);
//                expect(randomIndexes).to.contain([collectionObj count]-1);
//            });
//        });
//        
//        context(@"for an object that has a length", ^{
//            __block NSString *dataObj;
//            __block NSMutableArray *randomIndexes;
//            beforeEach(^{
//                dataObj = @"Ola";
//                randomIndexes = [NSMutableArray array];
//                for (int i = 0; i < 100; i++) {
//                    NSNumber *n = [GZNumbers randomIndex:dataObj];
//                    [randomIndexes addObject:n];
//                }
//            });
//            
//            it(@"returns different values", ^{
//                NSInteger someValue1 = [randomIndexes[3] integerValue];
//                NSArray *value1Array = [randomIndexes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
//                expect(value1Array.count).to.beLessThan(randomIndexes.count);
//            });
//            it(@"returns numbers between 0 and length-1", ^{
//                expect(randomIndexes).to.contain(@0);
//                expect(randomIndexes).to.contain([dataObj length]-1);
//            });
//        });
//    });
//    
//    context(@"randomFloatBetween:and:", ^{
//        __block NSInteger min = 0;
//        __block NSInteger max = 0;
//        __block NSMutableArray *randomfloats;
//        beforeEach(^{
//            min = 5;
//            max = 8;
//            randomfloats = [NSMutableArray array];
//            for (int i = 0; i < 200; i++) {
//                NSNumber *n = [GZNumbers randomFloatBetween:min and:max];
//                [randomfloats addObject:n];
//            }
//        });
//        
//        it(@"returns numbers with decimals", ^{
//            NSMutableArray *onlyDecimals = [NSMutableArray array];
//            [randomfloats enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                NSNumber *num = (NSNumber *)obj;
//                if ((num.floatValue - num.integerValue) != 0) [onlyDecimals addObject:num];
//            }];
//            expect(onlyDecimals).to.haveCountOf(randomfloats.count);
//        });
//        it(@"returns different values", ^{
//            NSInteger someValue1 = [randomfloats[3] integerValue];
//            NSInteger someValue2 = [randomfloats[10] integerValue];
//            NSArray *value1Array = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue1]];
//            NSArray *value2Array = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"integerValue == %i", someValue2]];
//            expect(value1Array.count + value2Array.count).to.beLessThan(randomfloats.count);
//        });
//        it(@"returns numbers equal or bigger than min", ^{
//            NSArray *fiveOrBigger = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue >= %@", @(min)]];
//            expect(fiveOrBigger.count).to.equal(randomfloats.count);
//        });
//        it(@"returns numbers equal or less than max", ^{
//            NSArray *eightOrLess = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue <= %@", @(max)]];
//            expect(eightOrLess.count).to.equal(randomfloats.count);
//        });
//    });
//});

SpecEnd
