//
//  TextAnalisator.m
//  CourseWork
//
//  Created by Ivan Magda on 22.03.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import "TextAnalisator.h"
#import "NSMutableArray+MultyDimention.h"

@interface TextAnalisator ()

@property (nonatomic, copy) NSString *dataFilePath;

@end


@implementation TextAnalisator {
    NSStringEncoding _encoding;
    NSArray *_sortedKeys;

    NSUInteger _lengthLongestWord;
    NSUInteger _lengthLongestSentence;
}

#pragma mark - Initializers -

- (instancetype)initWithPath:(NSString *)dataFilePath encoding:(NSStringEncoding)encoding {
    if (self = [super init]) {
        _dataFilePath = dataFilePath;
        _encoding = encoding;
        _sortedKeys = nil;
        _lengthLongestSentence = 0;
        _lengthLongestWord = 0;
        [self loadTextDataWithEncoding:encoding];
    }
    return self;
}

+ (instancetype)analisatorWithPath:(NSString *)dataFilePath encoding:(NSStringEncoding)encoding {
    return [[TextAnalisator alloc]initWithPath:dataFilePath encoding:encoding];
}

#pragma mark - Private -

- (void)loadTextDataWithEncoding:(NSStringEncoding)encoding {
    NSError *error;
    NSString *text = [[NSString stringWithContentsOfFile:_dataFilePath encoding:encoding error:&error]lowercaseString];
    text = [text stringByReplacingOccurrencesOfString:@"?" withString:@"."];
    text = [text stringByReplacingOccurrencesOfString:@"!" withString:@"."];

    _text = text;

    if (error) {
        NSLog(@"Error, coud't load file: %@", [error localizedDescription]);
    }
    NSParameterAssert(_text != nil);
}

#pragma mark - Public -

    //Return the array of sentences from the given text, when initialized.
- (NSArray *)sentencesFromText {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSScanner *scanner = [NSScanner scannerWithString:_text];
    BOOL isOk = YES;
    NSMutableString *oneSentence = [NSMutableString new];
    NSMutableArray *allSentences = [NSMutableArray arrayWithCapacity:20];

    while (![scanner isAtEnd] && isOk) {
        NSString *line = nil;

        isOk = [scanner scanUpToString:@"\n" intoString:&line];

        if (line && isOk) {
            NSRange range = [line rangeOfString:@"."];
            if (range.location == NSNotFound) {
                if ([oneSentence isEqualToString:@""]) {
                    [oneSentence appendString:line];
                } else {
                    [oneSentence appendString:[NSString stringWithFormat:@"\n%@", line]];
                }

            } else {
                NSArray *strings = [line componentsSeparatedByString:@"."];

                [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSMutableString *string = [NSMutableString stringWithString:[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                    if (idx == 0) {
                        if (string != nil && ![string isEqualToString:@""]) {
                            if (oneSentence.length == 0) {
                                [string appendString:@"."];
                                [allSentences addObject:string];
                            } else {
                                [oneSentence appendString:[NSString stringWithFormat:@"\n%@.", strings[idx]]];
                                [allSentences addObject:oneSentence];
                            }
                        }
                    } else {
                        if (string != nil && ![string isEqualToString:@""]) {
                            [string appendString:@"."];
                            [allSentences addObject:string];
                        }
                    }
                }];
                oneSentence = [NSMutableString new];
            }
        }
    }
    return [allSentences copy];
}

- (NSDictionary *)numberWordsBeforeWordInArraySentences:(NSArray *)sentences {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    __block NSMutableDictionary *numberWordsBeforeWord = [NSMutableDictionary dictionaryWithCapacity:sentences.count];

    __block NSUInteger anLongestSentence = 0;

        //Configurate character set
    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet alphanumericCharacterSet];
    [charactersToKeep addCharactersInString:@" \n"];

    NSCharacterSet *charactersToRemove = [charactersToKeep invertedSet];

    [sentences enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *aSentence = [[[(NSString *)obj componentsSeparatedByCharactersInSet:charactersToRemove]componentsJoinedByString:@""]copy];

            //Replace all new lines with whitespaces
        NSRange range = [aSentence rangeOfString:@"\n"];
        while (range.location != NSNotFound) {
            aSentence = [aSentence stringByReplacingCharactersInRange:range withString:@" "];

            range = [aSentence rangeOfString:@"\n"];
        }

        NSMutableArray *words = [[aSentence componentsSeparatedByString:@" "]mutableCopy];

        if (words.count > anLongestSentence) {
            anLongestSentence = words.count;
        }

            //Remove @"" from the array
        if ([words containsObject:@""]) {
            NSIndexSet *indexes = [words indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                NSString *word = obj;
                if ([word isEqualToString:@""]) {
                    return YES;
                }
                return NO;
            }];
            [words removeObjectsAtIndexes:indexes];
        }

            //Count
        [words enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSRange range = [obj rangeOfString:@" "];
            if (range.location != NSNotFound) {
                NSLog(@"Clear neded!");
                NSParameterAssert(NO);
            }

            if ([obj isEqualToString:@""]) {
                NSParameterAssert(NO);
            }

            if ([numberWordsBeforeWord objectForKey:obj]) {
                NSMutableDictionary *containsWords = [numberWordsBeforeWord objectForKey:obj];
                for (int i = 0; i < idx; ++i) {
                    NSString *aWord = words[i];

                    NSNumber *count = [containsWords valueForKey:aWord];
                    [containsWords setObject:@(count.unsignedIntegerValue + 1) forKey:aWord];
                }
            } else {
                NSMutableDictionary *containsWords = [NSMutableDictionary new];
                for (int i = 0; i < idx; ++i) {
                    NSString *aWord = words[i];

                    NSNumber *count = [containsWords valueForKey:aWord];
                    [containsWords setObject:@(count.unsignedIntegerValue + 1) forKey:aWord];
                }
                [numberWordsBeforeWord setObject:containsWords forKey:obj];
            }
        }];
    }];
    _lengthLongestSentence = anLongestSentence;

    return [numberWordsBeforeWord copy];
}

- (NSUInteger)lengthLongestSentence {
    return _lengthLongestSentence;
}

- (NSUInteger)lengthLongestWord {
    return _lengthLongestWord;
}

- (NSArray *)matrixFromCountPairs:(NSDictionary *)pairs {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    _sortedKeys = [[pairs allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    const int size = (int)pairs.count;
    NSString *sizeString = [NSString stringWithFormat:@"[%i][%i]", size, size];

    NSMutableArray *matrix = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];

    NSInteger anLength = 0;
    for (int i = 0; i < size; ++i) {
        NSString *key = _sortedKeys[i];
        if (key.length > anLength) {
            anLength = key.length;
        }
        NSDictionary *dictionary = pairs[key];
        for (NSString *key in dictionary) {
            NSInteger index = [_sortedKeys indexOfObject:key];
            matrix[index][i] = dictionary[key];
        }
    }
    _lengthLongestWord = anLength;
    
    return [matrix copy];
}

- (NSString *)stringFromMatrix:(NSArray *)matrix {
    NSMutableString *string = [NSMutableString new];
    const NSUInteger size = matrix.count;

    for (int i = 0; i < _lengthLongestWord; ++i) {
        [string appendString:@" "];
    }
    for (NSString *word in _sortedKeys) {
        [string appendString:[NSString stringWithFormat:@"%@ ", word]];
    }
    [string appendString:@"\n"];

    for (int i = 0; i < size; ++i) {
        NSString *curKey = _sortedKeys[i];
        [string appendString:curKey];
        for (int i = 0; i < _lengthLongestWord - curKey.length; ++i) {
            [string appendString:@" "];
        }

        for (int j = 0; j < size; ++j) {
            NSString *word = _sortedKeys[j];
            for (int i = 0; i < word.length/2; ++i) {
                [string appendString:@" "];
            }
            if ([matrix[i][j] isKindOfClass:[NSNull class]]) {
                matrix[i][j] = @0;
            }
            [string appendString:[NSString stringWithFormat:@"%ld ", [matrix[i][j]longValue]]];
            for (int i = 0; i < (word.length - 1)/2; ++i) {
                [string appendString:@" "];
            }
        }
        [string appendString:@"\n"];
    }
    return [string copy];
}

- (NSArray *)sortedWords {
    return _sortedKeys;
}

@end
