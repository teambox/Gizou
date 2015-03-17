#import "GZTests.h"
#import "Gizou.h"

@interface GZNumbersTests : GZNumbers
+ (NSNumber *)test_randomNonZeroInteger;
+ (NSNumber *)test_randomIntegerStartingAt:(int32_t)startingAt;
+ (NSNumber *)test_integerNNonZero;
+ (NSCountedSet *)test_numbersSetOfSize:(NSUInteger)size using:(NSNumber *(^)(void))block;
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
 *  @return random unsigned integer between 1 and 3.
 */
+ (NSNumber *)test_integerNNonZero
{
    return @(arc4random_uniform(3) + 1);
}

/**
 *  Implemented the same as GZNumber `integerZNonZero` but setting 
 *  low min and max values so the non zero condition can be tested.
 *
 *  @return random integer between -3 and 3.
 */
+ (NSNumber *)test_integerZNonZero
{
    int randPos = [self test_integerNNonZero].intValue;
    BOOL randBool = [self yesOrNo].boolValue;
    return randBool ? @(randPos) : @(-randPos);
}

+ (NSCountedSet *)test_numbersSetOfSize:(NSUInteger)size using:(NSNumber *(^)(void))block
{
    NSMutableArray *randomNumbers = [NSMutableArray array];
    for (NSUInteger i = 0; i < size; i++) {
        NSNumber *n = block();
        [randomNumbers addObject:n];
    }
    return [[NSCountedSet alloc] initWithArray:randomNumbers];
}

@end


SpecBegin(GZNumbersBooleans)

describe(@"+yesOrNo (random bool)", ^{
    __block NSUInteger total;
    __block NSCountedSet *differentBools;
    beforeAll(^{
        total = 10000;
        differentBools = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
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
        __block NSUInteger total;
        __block BOOL predominant;
        __block NSCountedSet *differentBools;
        beforeAll(^{
            total = 10000;
            predominant = YES;
            differentBools = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
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


SpecBegin(GZNumbersNaturals)

describe(@"+integerN", ^{
    __block NSUInteger total;
    __block NSCountedSet *differentInts;
    beforeAll(^{
        total = 1000;
        differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
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
        expect(differentInts.count).to.beGreaterThan(0.99*total);
    });
});

describe(@"+integerNNonZero", ^{
    __block NSUInteger total;
    __block NSCountedSet *differentInts;
    beforeAll(^{
        total = 1000;
        differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
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

SpecEnd


SpecBegin(GZNumbersZIntegers)

describe(@"+integerZNonZero", ^{
    __block int total;
    __block NSCountedSet *differentInts;
    beforeAll(^{
        total = 1000;
        differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
            return [GZNumbersTests test_integerZNonZero];
        }];
    });
    
    it(@"returns different values", ^{
        expect(differentInts).to.haveCountOf(6);
    });
    it(@"doesn't return any 0 number", ^{
        expect(differentInts).notTo.contain(@0);
    });
});

describe(@"+integerBetween:and:", ^{
    __block NSInteger min;
    __block NSInteger max;
    __block NSUInteger total;
    __block NSCountedSet *differentInts;
    
    beforeAll(^{
        total = 1000;
    });
    
    context(@"when min equals max", ^{
        context(@"when max is INT MAX", ^{
            beforeAll(^{
                min = INT32_MAX;
                max = INT32_MAX;
                differentInts = [GZNumbersTests test_numbersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers integerBetween:min and:max];
                }];
            });
            
            it(@"returns INT MAX", ^{
                expect(differentInts).to.haveCountOf(1);
                expect(differentInts).to.contain(@(INT32_MAX));
            });
        });
        
        context(@"when max is any integer", ^{
            beforeAll(^{
                min = 50;
                max = 50;
                differentInts = [GZNumbersTests test_numbersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers integerBetween:min and:max];
                }];
            });
            
            it(@"returns max always", ^{
                expect(differentInts).to.haveCountOf(1);
                expect(differentInts).to.contain(@50);
            });
        });
    });
    
    context(@"when min different from max", ^{
        context(@"and min lt max", ^{
            beforeAll(^{
                min = -1;
                max = 1;
                differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerBetween:min and:max];
                }];
            });
            
            it(@"returns different values ranging [min,max]", ^{
                expect(differentInts).to.haveCountOf(max - min + 1);
            });
            it(@"returns some -1 values", ^{
                expect(differentInts).to.contain(@(-1));
            });
            it(@"returns some 0 values", ^{
                expect(differentInts).to.contain(@0);
            });
            it(@"returns some 1 values", ^{
                expect(differentInts).to.contain(@1);
            });
        });
        
        context(@"when min gt max", ^{
            beforeAll(^{
                min = -5;
                max = -7;
                differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerBetween:min and:max];
                }];
            });
            
            it(@"returns different values between MAX and min", ^{
                expect(differentInts).to.haveCountOf(min - max + 1);
            });
            it(@"returns some -7 values", ^{
                expect(differentInts).to.contain(@(-7));
            });
            it(@"returns some -6 values", ^{
                expect(differentInts).to.contain(@-6);
            });
            it(@"returns some -5 values", ^{
                expect(differentInts).to.contain(@-5);
            });
        });
    });
});

context(@"asymmetric random integers", ^{
    describe(@"+integerBetween:min and:max many:m few:f", ^{
        __block NSInteger min;
        __block NSInteger max;
        __block NSNumber *m;
        __block NSNumber *f;
        __block NSUInteger total;
        __block NSCountedSet *differentInts;
        beforeAll(^{
            min = 0;
            max = 3;
        });
        
        context(@"when no many, no few", ^{
            beforeAll(^{
                total = 1000;
                m = nil;
                f = nil;
                differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerBetween:min and:max many:m few:f];
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
            context(@"when many is out of range min-max", ^{
                it(@"throws Inconsistency Exception", ^{
                    expect(^{[GZNumbers integerBetween:3 and:1 many:@0 few:nil];}).to.raise(NSInternalInconsistencyException);
                });
            });
            
            context(@"when many is in range min-max", ^{
                beforeAll(^{
                    total = 10000;
                    m = @1;
                    f = nil;
                    differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers integerBetween:min and:max many:m few:f];
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
        });
        
        context(@"when passing few, no many", ^{
            context(@"when few is out of range min-max", ^{
                it(@"throws Inconsistency Exception", ^{
                    expect(^{[GZNumbers integerBetween:1 and:3 many:nil few:@4];}).to.raise(NSInternalInconsistencyException);
                });
            });
            
            context(@"when few is in range min-max", ^{
                beforeAll(^{
                    total = 10000;
                    m = nil;
                    f = @1;
                    differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers integerBetween:min and:max many:m few:f];
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
        });
        
        context(@"when passing both many and few", ^{
            beforeAll(^{
                total = 10000;
                m = @1;
                f = @0;
                differentInts = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers integerBetween:min and:max many:m few:f];
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


SpecBegin(GZNumbersDecimals)

describe(@"+floatBetween:and:", ^{
    __block float min;
    __block float max;
    __block NSUInteger total;
    __block NSCountedSet *differentFloats;
    
    beforeAll(^{
        total = 100;
    });
    
    context(@"min equals max", ^{
        context(@"max is FLOAT MAX", ^{
            beforeAll(^{
                min = MAXFLOAT;
                max = MAXFLOAT;
                differentFloats = [GZNumbersTests test_numbersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers floatBetween:min and:max];
                }];
            });
            
            it(@"returns FLOAT MAX always", ^{
                expect(differentFloats).to.haveCountOf(1);
                expect(differentFloats).to.contain(@(MAXFLOAT));
            });
        });
        
        context(@"when max is any float", ^{
            beforeAll(^{
                min = (float)51.53332;
                max = (float)51.53332;
                differentFloats = [GZNumbersTests test_numbersSetOfSize:10 using:^NSNumber *{
                    return [GZNumbers floatBetween:min and:max];
                }];
            });
            
            it(@"returns max always", ^{
                expect(differentFloats).to.haveCountOf(1);
                expect(differentFloats).to.contain(@(max));
            });
        });
    });
    
    context(@"min different from max", ^{
        context(@"when min lt max", ^{
            context(@"when min is 0", ^{
                beforeAll(^{
                    min = 0;
                    max = (float)2.3124;
                    differentFloats = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers floatBetween:min and:max];
                    }];
                });
                
                it(@"returns decimal values", ^{
                    NSSet *decimalsSet = [differentFloats objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                        NSNumber *num = (NSNumber *)obj;
                        return (num.floatValue - num.integerValue) != 0;
                    }];
                    expect(decimalsSet).to.haveCountOf(total);
                });
                it(@"returns different values", ^{
                    expect(differentFloats.count).to.beGreaterThan(0.99*total);
                });
                it(@"returns numbers equal or bigger than min", ^{
                    NSSet *minOrBigger = [differentFloats filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue >= %@", @(min)]];
                    expect(minOrBigger).to.haveCountOf(differentFloats.count);
                });
                it(@"returns numbers equal or less than max", ^{
                    NSSet *maxOrSmaller = [differentFloats filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue <= %@", @(max)]];
                    expect(maxOrSmaller).to.haveCountOf(differentFloats.count);
                });
            });
            
            context(@"when min non 0", ^{
                beforeAll(^{
                    min = -1;
                    max = 1;
                    differentFloats = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers floatBetween:min and:max];
                    }];
                });
                
                it(@"returns decimal values", ^{
                    NSSet *decimalsSet = [differentFloats objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                        NSNumber *num = (NSNumber *)obj;
                        return (num.floatValue - num.integerValue) != 0;
                    }];
                    expect(decimalsSet).to.haveCountOf(total);
                });
                it(@"returns different values", ^{
                    expect(differentFloats.count).to.beGreaterThan(0.99*total);
                });
                it(@"returns numbers equal or bigger than min", ^{
                    NSSet *minOrBigger = [differentFloats filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue >= %@", @(min)]];
                    expect(minOrBigger).to.haveCountOf(differentFloats.count);
                });
                it(@"returns numbers equal or less than max", ^{
                    NSSet *maxOrSmaller = [differentFloats filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue <= %@", @(max)]];
                    expect(maxOrSmaller).to.haveCountOf(differentFloats.count);
                });
            });
        });
        
        context(@"when min gt max", ^{
            beforeAll(^{
                min = -1;
                max = -7;
                differentFloats = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers floatBetween:min and:max];
                }];
            });
            
            it(@"returns decimal values", ^{
                NSSet *decimalsSet = [differentFloats objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                    NSNumber *num = (NSNumber *)obj;
                    return (num.floatValue - num.integerValue) != 0;
                }];
                expect(decimalsSet).to.haveCountOf(total);
            });
            it(@"returns different values", ^{
                expect(differentFloats.count).to.beGreaterThan(0.99*total);
            });
            it(@"returns numbers equal or bigger than MAX", ^{
                NSSet *minOrBigger = [differentFloats filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue >= %@", @(max)]];
                expect(minOrBigger).to.haveCountOf(differentFloats.count);
            });
            it(@"returns numbers equal or less than MIN", ^{
                NSSet *maxOrSmaller = [differentFloats filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue <= %@", @(min)]];
                expect(maxOrSmaller).to.haveCountOf(differentFloats.count);
            });
        });
    });
});

SpecEnd


SpecBegin(GZNumbersIndexes)

describe(@"+indexFrom:", ^{
    __block NSUInteger total;
    beforeAll(^{
        total = 100;
    });
    
    context(@"for an object that has no count nor length", ^{
        __block id obj;
        beforeEach(^{
            obj = [NSObject new];
        });
        
        it(@"should throw exception", ^{
            expect(^{[GZNumbers indexFrom:obj];}).to.raise(NSInternalInconsistencyException);
        });
    });
    
    context(@"for an object that can be count", ^{
        __block NSArray *collectionObj;
        __block NSCountedSet *differentIndexes;
        beforeAll(^{
            collectionObj = @[@100, @300, @300];
            differentIndexes = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                return [GZNumbers indexFrom:collectionObj];
            }];
        });
        
        it(@"returns different values", ^{
            expect(differentIndexes).to.haveCountOf(collectionObj.count);
        });
        it(@"returns some 0 values", ^{
            expect(differentIndexes).to.contain(@0);
        });
        it(@"returns some 1 values", ^{
            expect(differentIndexes).to.contain(@1);
        });
        it(@"returns some 2 values", ^{
            expect(differentIndexes).to.contain(@2);
        });
    });
    
    context(@"for an object that has a length", ^{
        __block NSString *dataObj;
        __block NSCountedSet *differentIndexes;
        beforeAll(^{
            dataObj = @"Ola";
            differentIndexes = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                return [GZNumbers indexFrom:dataObj];
            }];
        });
        
        it(@"returns different values", ^{
            expect(differentIndexes).to.haveCountOf(dataObj.length);
        });
        it(@"returns some 0 values", ^{
            expect(differentIndexes).to.contain(@0);
        });
        it(@"returns some 1 values", ^{
            expect(differentIndexes).to.contain(@1);
        });
        it(@"returns some 2 values", ^{
            expect(differentIndexes).to.contain(@2);
        });
    });
});

context(@"asymmetric random indexes", ^{
    describe(@"+indexFrom:many:few", ^{
        __block NSArray *enumerableObj;
        __block NSNumber *m;
        __block NSNumber *f;
        __block NSUInteger total;
        __block NSCountedSet *differentIdexes;
        beforeAll(^{
            enumerableObj = @[@"Hola", @"Hello", @"Ciao"];
        });
        
        context(@"when no many, no few", ^{
            beforeAll(^{
                total = 1000;
                m = nil;
                f = nil;
                differentIdexes = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers indexFrom:enumerableObj many:m few:f];
                }];
            });
            it(@"returns different values", ^{
                expect(differentIdexes).to.haveCountOf(enumerableObj.count);
            });
            it(@"returns 0, 1 and 2 values", ^{
                expect(differentIdexes).to.contain(@0);
                expect(differentIdexes).to.contain(@1);
                expect(differentIdexes).to.contain(@2);
            });
            
            it(@"returns similar quantity of each", ^{
                expect([differentIdexes countForObject:@0]).to.beLessThan(0.4*total);
                expect([differentIdexes countForObject:@1]).to.beLessThan(0.4*total);
                expect([differentIdexes countForObject:@2]).to.beLessThan(0.4*total);
            });
        });
        
        context(@"when passing many, no few", ^{
            context(@"when many is out of range 0, count-1", ^{
                it(@"throws Inconsistency Exception", ^{
                    expect(^{[GZNumbers indexFrom:enumerableObj many:@3 few:nil];}).to.raise(NSInternalInconsistencyException);
                });
            });
            
            context(@"when many is in range 0, count-1", ^{
                beforeAll(^{
                    total = 10000;
                    m = @1;
                    f = nil;
                    differentIdexes = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers indexFrom:enumerableObj many:m few:f];
                    }];
                });
                
                it(@"returns different values", ^{
                    expect(differentIdexes).to.haveCountOf(enumerableObj.count);
                });
                it(@"returns 0, 1 and 2 values", ^{
                    expect(differentIdexes).to.contain(@0);
                    expect(differentIdexes).to.contain(@1);
                    expect(differentIdexes).to.contain(@2);
                });
                it(@"returns much more of the many value", ^{
                    expect([differentIdexes countForObject:m]).to.beGreaterThan(0.75*total);
                });
                it(@"returns similar quantities for the non predominant values", ^{
                    expect([differentIdexes countForObject:@0]).to.beLessThan(0.2*total);
                    expect([differentIdexes countForObject:@2]).to.beLessThan(0.2*total);
                });
            });
        });
        
        context(@"when passing few, no many", ^{
            context(@"when few is out of range 0, count-1", ^{
                it(@"throws Inconsistency Exception", ^{
                    expect(^{[GZNumbers indexFrom:enumerableObj many:nil few:@-1];}).to.raise(NSInternalInconsistencyException);
                });
            });
            
            context(@"when few is in range 0, count-1", ^{
                beforeAll(^{
                    total = 10000;
                    m = nil;
                    f = @1;
                    differentIdexes = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                        return [GZNumbers indexFrom:enumerableObj many:m few:f];
                    }];
                });
                
                it(@"returns different values ranging [min,max]", ^{
                    expect(differentIdexes).to.haveCountOf(enumerableObj.count);
                });
                it(@"returns 0, 1 and 2 values", ^{
                    expect(differentIdexes).to.contain(@0);
                    expect(differentIdexes).to.contain(@1);
                    expect(differentIdexes).to.contain(@2);
                });
                it(@"returns much less of the few value", ^{
                    expect([differentIdexes countForObject:f]).to.beLessThan(0.2*total);
                });
                it(@"returns similar quantities for the predominant values", ^{
                    expect([differentIdexes countForObject:@0]).to.beLessThan(0.45*total);
                    expect([differentIdexes countForObject:@2]).to.beLessThan(0.45*total);
                });
            });
        });
        
        context(@"when passing both many and few", ^{
            beforeAll(^{
                total = 10000;
                m = @1;
                f = @0;
                differentIdexes = [GZNumbersTests test_numbersSetOfSize:total using:^NSNumber *{
                    return [GZNumbers indexFrom:@[@"a", @"b", @"c", @"d"] many:m few:f];
                }];
            });
            
            it(@"returns different values ranging [min,max]", ^{
                expect(differentIdexes).to.haveCountOf(4);
            });
            it(@"returns 0, 1, 2 and 3 values", ^{
                expect(differentIdexes).to.contain(@0);
                expect(differentIdexes).to.contain(@1);
                expect(differentIdexes).to.contain(@2);
                expect(differentIdexes).to.contain(@3);
            });
            it(@"returns much more of the many value", ^{
                expect([differentIdexes countForObject:m]).to.beGreaterThan(0.7*total);
            });
            it(@"returns much less of the few value", ^{
                expect([differentIdexes countForObject:f]).to.beLessThan(0.05*total);
            });
            it(@"returns similar quantities for the rest of the values", ^{
                expect([differentIdexes countForObject:@2]).to.beLessThan(0.1*total);
                expect([differentIdexes countForObject:@3]).to.beLessThan(0.1*total);
            });
        });
    });
});

SpecEnd

//
//
// [!] WILL DISSAPPEAR
//
SpecBegin(GZNumbers)

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
            for (int i = 0; i < 200; i++) {
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
            expect(randomInts).to.contain(@1);
        });
        it(@"returns some 3 numbers", ^{
            expect(randomInts).to.contain(3);
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
            expect(randomInts).notTo.contain(@4);
        });
    });
    
    context(@"randomIntegerStartingAt:3", ^{
        __block NSMutableArray *randomInts;
        beforeEach(^{
            randomInts = [NSMutableArray array];
            for (int i = 0; i < 100; i++) {
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
            expect(randomInts).to.contain(@3);
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
                for (int i = 0; i < 100; i++) {
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
    
    context(@"randomFloatBetween:and:", ^{
        __block NSInteger min = 0;
        __block NSInteger max = 0;
        __block NSMutableArray *randomfloats;
        beforeEach(^{
            min = 5;
            max = 8;
            randomfloats = [NSMutableArray array];
            for (int i = 0; i < 200; i++) {
                NSNumber *n = [GZNumbers randomFloatBetween:min and:max];
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
        it(@"returns numbers equal or bigger than min", ^{
            NSArray *fiveOrBigger = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue >= %@", @(min)]];
            expect(fiveOrBigger.count).to.equal(randomfloats.count);
        });
        it(@"returns numbers equal or less than max", ^{
            NSArray *eightOrLess = [randomfloats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"floatValue <= %@", @(max)]];
            expect(eightOrLess.count).to.equal(randomfloats.count);
        });
    });
});

SpecEnd
