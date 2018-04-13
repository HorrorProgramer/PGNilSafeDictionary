//
//  NSNull+SafeDictionary.m
//  PgNilSafeNictionary
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 PangJunJie. All rights reserved.
//

#import "NSNull+SafeDictionary.h"
#import "NSObject+SafeDictionry.h"

@implementation NSNull (SafeDictionary)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self pg_swizzleClassMethod:@selector(methodSignatureForSelector:)
                         withMethod:@selector(pg_methodSignatureForSelector:)];
        [self pg_swizzleClassMethod:@selector(forwardInvocation:)
                         withMethod:@selector(pg_forwardInvocation:)];
    });
}

#pragma mark ------
#pragma mark Swizzle Method
- (NSMethodSignature *)pg_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self pg_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)pg_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }
    
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    
    [anInvocation setReturnValue:buffer];
}

@end
