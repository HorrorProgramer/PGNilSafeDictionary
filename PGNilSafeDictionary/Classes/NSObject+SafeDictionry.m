//
//  NSObject+SafeDictionry.m
//  PGNilSafeDictionary_Example
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 PGNilSafeDictionary. All rights reserved.
//

#import "NSObject+SafeDictionry.h"
#import <objc/runtime.h>

@implementation NSObject (SafeDictionry)

+ (BOOL)pg_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)pg_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) pg_swizzleMethod:origSel withMethod:altSel];
}

@end
