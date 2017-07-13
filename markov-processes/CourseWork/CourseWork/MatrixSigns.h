//
//  MatrixSigns.h
//  CourseWork
//
//  Created by Ivan Magda on 15.04.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MatrixSignsCompletionHandler)(NSArray *selfMatrix, NSArray *otherMatrix);

@interface MatrixSigns : NSObject <NSCoding>

- (instancetype)initWithMatrix:(NSArray *)matrix numberColumns:(NSUInteger)columns words:(NSArray *)words;

- (NSArray *)matrixSigns;

- (NSArray *)words;

- (NSUInteger)columns;

- (void)compareMatrixSignsWithOtherMatrix:(MatrixSigns *)otherMatrix andWithCompletionHandler:(MatrixSignsCompletionHandler)completionHandler;

+ (NSArray *)matrixDifferencesFromMinuend:(NSArray *)minuend subtrahend:(NSArray *)subtrahend lines:(NSUInteger)lines columns:(NSUInteger)columns;
+ (double)maximumValueModuleFromMatrixDiffrences:(NSArray *)matrixDifferences lines:(NSUInteger)lines columns:(NSUInteger)columns;
+ (int)hammingDistanceFromMatrixDiffrences:(NSArray *)matrixDifferences lines:(NSUInteger)lines columns:(NSUInteger)columns andMaximumValueModule:(double)maximumValue;

+ (NSString *)pathForDataFile;
- (void)saveDataToDiskFileName:(NSString *)fileName;
+ (instancetype)loadDataFromDiskFileName:(NSString *)fileName;

@end
