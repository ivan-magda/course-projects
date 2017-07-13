//
//  TextAnalisator.h
//  CourseWork
//
//  Created by Ivan Magda on 22.03.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextAnalisator : NSObject

@property (nonatomic, copy) NSString *text;


- (instancetype)initWithPath:(NSString *)dataFilePath encoding:(NSStringEncoding)encoding ;
+ (instancetype)analisatorWithPath:(NSString *)dataFilePath encoding:(NSStringEncoding)encoding;

- (NSArray *)sentencesFromText;
- (NSDictionary *)numberWordsBeforeWordInArraySentences:(NSArray *)sentences;

- (NSArray *)matrixFromCountPairs:(NSDictionary *)pairs;
- (NSString *)stringFromMatrix:(NSArray *)matrix;

- (NSUInteger)lengthLongestWord;
- (NSUInteger)lengthLongestSentence;

- (NSArray *)sortedWords;

@end
