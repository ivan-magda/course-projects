//
//  NSMutableArray+MultyDimention.m
//  CourseWork
//
//  Created by Ivan Magda on 10.04.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import "NSMutableArray+MultyDimention.h"

@implementation NSMutableArray (MultyDimention)

+(NSMutableArray *)mutableNullArrayWithSize:(NSUInteger)size {
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:size];
    for (int i = 0; i < size; i++) {
        [returnArray addObject:[NSNull null]];
    }
    return returnArray;
}

+(NSMutableArray *)mutableNullArraysWithVisualFormat:(NSString *)string {
    NSMutableArray *returnArray = nil;
    NSRange bitRange;
    if ((bitRange = [string rangeOfString:@"^\\[\\d+]" options:NSRegularExpressionSearch]).location != NSNotFound) {
        NSUInteger size = [[string substringWithRange:NSMakeRange(1, bitRange.length - 2)] integerValue];
        if (string.length == bitRange.length) {
            returnArray = [self mutableNullArrayWithSize:size];
        } else {
            returnArray = [[NSMutableArray alloc] initWithCapacity:size];
            NSString *nextLevel = [string substringWithRange:NSMakeRange(bitRange.length, string.length - bitRange.length)];
            NSMutableArray *subArray;
            for (int i = 0; i < size; i++) {
                subArray = [self mutableNullArraysWithVisualFormat:nextLevel];
                if (subArray) {
                    [returnArray addObject:subArray];
                } else {
                    return nil;
                }
            }
        }
    } else {
        return nil;
    }
    return returnArray;
}

@end
