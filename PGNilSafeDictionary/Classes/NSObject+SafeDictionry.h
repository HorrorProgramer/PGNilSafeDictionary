//
//  NSObject+SafeDictionry.h
//  PGNilSafeDictionary_Example
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 PGNilSafeDictionary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeDictionry)

+ (BOOL)pg_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)pg_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;

@end
