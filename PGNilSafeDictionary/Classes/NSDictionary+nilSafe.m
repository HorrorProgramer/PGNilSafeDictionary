//
//  NSDictionary+nilSafe.m
//  PgNilSafeNictionary
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 PangJunJie. All rights reserved.
//

#import "NSDictionary+nilSafe.h"
#import "NSObject+SafeDictionry.h"

@implementation NSDictionary (nilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self pg_swizzleClassMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(pg_initWithObjects:forKeys:count:)];
        [self pg_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(pg_dictionaryWithObjects:forKeys:count:)];
    });
}

#pragma mark -----
#pragma mark Swizzle Method
+ (instancetype)pg_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self pg_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)pg_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self pg_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSMutableDictionary (nilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class pg_swizzleMethod:@selector(setObject:forKey:)    withMethod:@selector(pg_setObject:forKey:)];
        [class pg_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(pg_setObject:forKeyedSubscript:)];
    });
}

- (void)pg_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey || !anObject) {
        return;
    }
    
    [self pg_setObject:anObject forKey:aKey];
}

- (void)pg_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key || !obj) {
        return;
    }
    [self pg_setObject:obj forKeyedSubscript:key];
}

@end
