//
//  PGNilSafeDictionaryTests.m
//  PGNilSafeDictionaryTests
//
//  Created by PGNilSafeDictionary on 04/13/2018.
//  Copyright (c) 2018 PGNilSafeDictionary. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+nilSafe.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testLiteral {
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    NSDictionary *dict = @{
                           nonNilKey: nilVal,
                           nilKey: nonNilVal,
                           };
    XCTAssertEqualObjects([dict allKeys], @[]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
    id val = dict[nonNilKey];
    XCTAssertNil(val);
    XCTAssertNoThrow([val length]);
    XCTAssertNoThrow([val count]);
    XCTAssertNoThrow([val anyObject]);
    XCTAssertNoThrow([val intValue]);
    XCTAssertNoThrow([val integerValue]);
}

- (void)testKeyedSubscript {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    dict[nonNilKey] = nilVal;
    dict[nilKey] = nonNilVal;
    XCTAssertEqualObjects([dict allKeys], @[]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
}

- (void)testSetObject {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    [dict setObject:nilVal forKey:nonNilKey];
    [dict setObject:nonNilVal forKey:nilKey];
    XCTAssertEqualObjects([dict allKeys], @[]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
}

- (void)testArchive {
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    NSDictionary *dict = @{
                           nonNilKey: nilVal,
                           nilKey: nonNilVal,
                           };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSDictionary *dict2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertEqualObjects([dict2 allKeys], @[]);
    XCTAssertNoThrow([dict2 objectForKey:nonNilKey]);
}

- (void)testJSON {
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    NSDictionary *dict = @{
                           nonNilKey: nilVal,
                           nilKey: nonNilVal,
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *expectedString = @"{}";
    XCTAssertEqualObjects(jsonString, expectedString);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end

