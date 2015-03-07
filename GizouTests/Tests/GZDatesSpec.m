//
//  GZDate.m
//  GizouTests
//
//  Created by Maria Bernis on 05/03/15.
//
//

#import "GZTests.h"
#import "GZDates.h"

@interface GZDates ()
+ (NSCalendar *)_calendar;
@end


@interface GZDatesTests : GZDates
+ (NSDate *)_todayTest;
@end

@implementation GZDatesTests

+ (NSCountedSet *)test_datesSetOfSize:(NSUInteger)size using:(NSDate *(^)(void))block
{
    NSMutableArray *randomDates = [NSMutableArray array];
    for (NSUInteger i = 0; i < size; i++) {
        NSDate *d = block();
        [randomDates addObject:d];
    }
    return [[NSCountedSet alloc] initWithArray:randomDates];
}

+ (NSArray *)test_datesArrayOfSize:(NSUInteger)size using:(NSDate *(^)(void))block
{
    NSMutableArray *randomDates = [NSMutableArray array];
    for (NSUInteger i = 0; i < size; i++) {
        NSDate *d = block();
        [randomDates addObject:d];
    }
    return randomDates;
}

+ (NSCountedSet *)test_dateComponentsWithDates:(NSArray *)dates calendar:(NSCalendar *)calendar units:(NSCalendarUnit)units
{
    NSMutableArray *components = [NSMutableArray array];
    for (NSDate *date in dates) {
        NSDateComponents *c = [calendar components:units fromDate:date];
        [components addObject:c];
    }
    return [[NSCountedSet alloc] initWithArray:components];
}

+ (NSDate *)_todayTest
{
    return [NSDate dateWithTimeIntervalSince1970:1426417817.000];
}

@end


SpecBegin(GZDates)

describe(@"+dateBetween:from and:to", ^{
    __block NSUInteger total;
    __block NSDate *from;
    __block NSDate *to;
    __block NSCountedSet *differentDates;
    beforeAll(^{
        total = 100;
        from = [NSDate dateWithTimeIntervalSince1970:1425462377.000]; // 4/3/2015, 10:46:17 AM
        to = [NSDate dateWithTimeIntervalSince1970:1425462437.000]; // 4/3/2015, 10:47:17 AM
        differentDates = [GZDatesTests test_datesSetOfSize:total using:^NSDate *{
            return [GZDatesTests dateBetween:from and:to];
        }];
    });
    
    it(@"returns date objects", ^{
        expect([differentDates anyObject]).to.beKindOf([NSDate class]);
    });
    it(@"returns different values", ^{
        expect(differentDates.count).to.beGreaterThan(0.99*total);
    });
    it(@"doesn't return values out of the [FROM, TO] range", ^{
        NSSet *inRange = [differentDates filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF >= %@) AND (SELF <= %@)", from, to]];
        expect(inRange).to.haveCountOf(differentDates.count);
    });
});

describe(@"+daysForward", ^{
    __block NSUInteger total;
    __block NSCountedSet *differentDates;
    __block NSSet *differentDays;
    __block NSDateComponents *todayComps;
    beforeAll(^{
        total = 100;
        NSCalendar *calendar = [GZDatesTests _calendar];
        NSCalendarUnit calendarUnits = (NSDayCalendarUnit);
        NSArray *randomDates = [GZDatesTests test_datesArrayOfSize:total using:^NSDate *{
            return [GZDatesTests daysForward:3];
        }];
        differentDates = [[NSCountedSet alloc] initWithArray:randomDates];
        differentDays = [GZDatesTests test_dateComponentsWithDates:randomDates calendar:calendar units:calendarUnits];
        todayComps = [calendar components:calendarUnits fromDate:[GZDatesTests _todayTest]];
    });
    
    it(@"returns different dates", ^{
        expect(differentDates.count).to.beGreaterThan(0.99*total);
    });
    it(@"returns three different days dates", ^{
        expect(differentDays).to.haveCountOf(3);
    });
    it(@"returns dates starting tomorrow up to 3 days after tomorrow", ^{
        expect([differentDays objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.day = todayComps.day + 1;
        }]).to.haveCountOf(1);
        expect([differentDays objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.day = todayComps.day + 2;
        }]).to.haveCountOf(1);
        expect([differentDays objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.day = todayComps.day + 3;
        }]).to.haveCountOf(1);
    });
});

describe(@"+daysBackward", ^{
    __block NSUInteger total;
    __block NSCountedSet *differentDates;
    __block NSSet *differentDays;
    __block NSDateComponents *todayComps;
    beforeAll(^{
        total = 100;
        NSCalendar *calendar = [GZDatesTests _calendar];
        NSCalendarUnit calendarUnits = (NSDayCalendarUnit);
        NSArray *randomDates = [GZDatesTests test_datesArrayOfSize:total using:^NSDate *{
            return [GZDatesTests daysBackward:3];
        }];
        differentDates = [[NSCountedSet alloc] initWithArray:randomDates];
        differentDays = [GZDatesTests test_dateComponentsWithDates:randomDates calendar:calendar units:calendarUnits];
        todayComps = [calendar components:calendarUnits fromDate:[GZDatesTests _todayTest]];
    });
    
    it(@"returns different values", ^{
        expect(differentDates.count).to.beGreaterThan(0.99*total);
    });
    it(@"returns three different days dates", ^{
        expect(differentDays).to.haveCountOf(3);
    });
    it(@"returns dates starting 3 days ago up to yesterday", ^{
        expect([differentDays objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.day = todayComps.day - 1;
        }]).to.haveCountOf(1);
        expect([differentDays objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.day = todayComps.day - 2;
        }]).to.haveCountOf(1);
        expect([differentDays objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.day = todayComps.day - 3;
        }]).to.haveCountOf(1);
    });
});

describe(@"+yearsForward", ^{
    __block NSUInteger total;
    __block NSCountedSet *differentDates;
    __block NSSet *differentYears;
    __block NSDateComponents *todayComps;
    beforeAll(^{
        total = 100;
        NSCalendar *calendar = [GZDatesTests _calendar];
        NSCalendarUnit calendarUnits = (NSYearCalendarUnit);
        NSArray *randomDates = [GZDatesTests test_datesArrayOfSize:total using:^NSDate *{
            return [GZDatesTests yearsForward:3];
        }];
        differentDates = [[NSCountedSet alloc] initWithArray:randomDates];
        differentYears = [GZDatesTests test_dateComponentsWithDates:randomDates calendar:calendar units:calendarUnits];
        todayComps = [calendar components:calendarUnits fromDate:[GZDatesTests _todayTest]];
    });
    
    it(@"returns different dates", ^{
        expect(differentDates.count).to.beGreaterThan(0.99*total);
    });
    it(@"returns three different years dates", ^{
        expect(differentYears).to.haveCountOf(3);
    });
    it(@"returns dates starting next year up to 3 days after tomorrow", ^{
        expect([differentYears objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.year = todayComps.year + 1;
        }]).to.haveCountOf(1);
        expect([differentYears objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.year = todayComps.year + 2;
        }]).to.haveCountOf(1);
        expect([differentYears objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            NSDateComponents *c = (NSDateComponents *)obj;
            return c.year = todayComps.year + 3;
        }]).to.haveCountOf(1);
    });
});

SpecEnd
