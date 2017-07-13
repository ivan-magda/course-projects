//
//  MatrixSigns.m
//  CourseWork
//
//  Created by Ivan Magda on 15.04.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#import "MatrixSigns.h"
#import "NSMutableArray+MultyDimention.h"
#import <math.h>

@interface MatrixSigns ()

@property (nonatomic, strong) NSMutableArray *matrixSigns;

@end

@implementation MatrixSigns {
    NSArray *_probabilityMatrix;
    NSUInteger _columns;
    NSArray *_words;
}

- (instancetype)initWithMatrix:(NSArray *)matrix numberColumns:(NSUInteger)columns words:(NSArray *)words {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self = [super init]) {
        _probabilityMatrix = [self transitionProbabilityMatrixFromMatrix:matrix];
        _columns = columns;
        _words = words;

        NSString *sizeString = [NSString stringWithFormat:@"[%lu][%lu]", matrix.count, _columns];
        _matrixSigns = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];
        [self configurateMatrixSigns];
    }
    return self;
}

#pragma mark - Save/Load -

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_matrixSigns forKey:@"matrixSigns"];
    [aCoder encodeObject:_probabilityMatrix forKey:@"probabilityMatrix"];
    [aCoder encodeInteger:_columns forKey:@"columns"];
    [aCoder encodeObject:_words forKey:@"words"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _matrixSigns = [aDecoder decodeObjectForKey:@"matrixSigns"];
        _probabilityMatrix = [aDecoder decodeObjectForKey:@"probabilityMatrix"];
        _columns = [aDecoder decodeIntegerForKey:@"columns"];
        _words = [aDecoder decodeObjectForKey:@"words"];
    }
    return self;
}

+ (NSString *)pathForDataFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *folder = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/MatrixSigns/";

    if ([fileManager fileExistsAtPath: folder] == NO) {
        NSError *error;
        if(![fileManager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        }
    }
    return folder;
}

- (void)saveDataToDiskFileName:(NSString *)fileName {
    NSString *path = [[MatrixSigns pathForDataFile]stringByAppendingPathComponent:fileName];
    if (![NSKeyedArchiver archiveRootObject:self toFile:path]) {
        NSLog(@"Error when save!!!");
    }
}

+ (instancetype)loadDataFromDiskFileName:(NSString *)fileName {
    NSString *path = [[self pathForDataFile]stringByAppendingPathComponent:fileName];
    MatrixSigns *rootObject;

    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    if (rootObject == nil) {
        NSLog(@"Root object is nil after load from file!");
    }

    return rootObject;
}

#pragma mark - Matrix methods -

- (NSArray *)transitionProbabilityMatrixFromMatrix:(NSArray *)matrix {
    NSMutableArray *transitionProbabilityMatrix = [matrix mutableCopy];
    NSInteger size = transitionProbabilityMatrix.count;
    for (int i = 0; i < size; ++i) {
        double frequency = 0.0f;
        for (int j = 0; j < size; ++j) {
            if ([transitionProbabilityMatrix[i][j] isKindOfClass:[NSNull class]]) {
                transitionProbabilityMatrix[i][j] = @0;
            }
            frequency += [transitionProbabilityMatrix[i][j]doubleValue];
        }
        if (frequency > 0) {
            for (int j = 0; j < size; ++j) {
                transitionProbabilityMatrix[i][j] = @([transitionProbabilityMatrix[i][j]doubleValue] / frequency);
            }
        }
    }

//    for (int i = 0; i < transitionProbabilityMatrix.count; ++i) {
//        for (int j = 0; j < transitionProbabilityMatrix.count; ++j) {
//            if ([transitionProbabilityMatrix[i][j]isKindOfClass:[NSNull class]]) {
//                printf("0 ");
//            } else {
//                printf("%f ", [transitionProbabilityMatrix[i][j]doubleValue]);
//            }
//        }
//        printf("\n");
//    }

    return [transitionProbabilityMatrix copy];
}

- (NSArray *)reverseMatrixFromMatrix:(NSArray *)matrix {
    NSUInteger size = matrix.count;
    NSString *sizeString = [NSString stringWithFormat:@"[%lu][%lu]", size, size];
    NSMutableArray *reverseMatrix = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];

    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            reverseMatrix[j][i] = matrix[i][j];
        }
    }

//    for (int i = 0; i < size; ++i) {
//        for (int j = 0; j < size; ++j) {
//            if ([reverseMatrix[i][j]isKindOfClass:[NSNull class]]) {
//                printf("0 ");
//            } else {
//                printf("%f ", [reverseMatrix[i][j]doubleValue]);
//            }
//        }
//        printf("\n");
//    }

    return [reverseMatrix copy];
}

- (void)configurateMatrixSigns {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSArray *reverseMatrix = [self reverseMatrixFromMatrix:_probabilityMatrix];

    NSUInteger size = reverseMatrix.count;
    NSString *sizeString = [NSString stringWithFormat:@"[%lu][%lu]", size, size];
    NSMutableArray *valuesHolder = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];

    NSMutableArray *transitionProbabilityMatrix = [NSMutableArray arrayWithArray:reverseMatrix];

    NSUInteger degree = _columns;

    if (degree > 10) {
        degree = 7;
    }

    int progress = 0;

    for (int i = 1; i < degree; ++i) {

        for (int line = 0; line < size; ++line) {
            for (int column = 0; column < size; ++column) {
                double value = 0;
                for (int j = 0; j < size; ++j) {
                    value += [transitionProbabilityMatrix[line][j]doubleValue] * [reverseMatrix[j][column]doubleValue];
                    if (j == size - 1) {
                        valuesHolder[line][column] = @(value);
                    }
                }
            }
        }

            //NSMutableString *str = [NSMutableString new];
        for (int l = 0; l < size; ++l) {
            for (int k = 0; k < size; ++k) {
                transitionProbabilityMatrix[l][k] = valuesHolder[l][k];

                    //[str appendString:[NSString stringWithFormat:@"%@ ", transitionProbabilityMatrix[l][k]]];
            }
                //[str appendString:@"\n"];
        }

            //NSLog(@"\n%i %@", i, str);

        for (int c = 0; c < size; ++c) {
            _matrixSigns[c][i-1] = transitionProbabilityMatrix[c][0];
        }

        progress = 100 * i / degree;
        NSLog(@"Progress: %i", progress);
    }
    for (int c = 0; c < size; ++c) {
        _matrixSigns[c][degree-1] = transitionProbabilityMatrix[c][0];
    }


//    NSMutableString *str = [NSMutableString new];
//    for (int i = 0; i < _matrixSigns.count; ++i) {
//        for (int j = 0; j < _columns; ++j) {
//            [str appendString:[NSString stringWithFormat:@"%@ ", _matrixSigns[i][j]]];
//        }
//        [str appendString:@"\n"];
//    }

}

- (NSArray *)matrixSigns {
    return [_matrixSigns copy];
}

- (NSArray *)words {
    return [_words copy];
}

- (NSUInteger)columns {
    return _columns;
}

- (void)compareMatrixSignsWithOtherMatrix:(MatrixSigns *)otherMatrix andWithCompletionHandler:(MatrixSignsCompletionHandler)completionHandler {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSArray *selfWords = _words;
    NSArray *otherWords = otherMatrix.words;

    NSMutableSet *equalWordsSet = [NSMutableSet set];
    for (NSString *selfWord in selfWords) {
        for (NSString *otherWord in otherWords) {
            if ([selfWord isEqualToString:otherWord] &&
                ![equalWordsSet containsObject:selfWord]) {
                [equalWordsSet addObject:selfWord];
            }
        }
    }

    NSMutableSet *selfSelectedColumns = [NSMutableSet setWithCapacity:equalWordsSet.count];
    NSMutableSet *otherSelectedColumns = [NSMutableSet setWithCapacity:equalWordsSet.count];

    for (int i = 0; i < 2; ++i) {
        if (i == 0) {
            for (NSString *word in equalWordsSet) {
                NSUInteger index = [selfWords indexOfObject:word];
                [selfSelectedColumns addObject:@(index)];
            }
        } else {
            for (NSString *word in equalWordsSet) {
                NSUInteger index = [otherWords indexOfObject:word];
                [otherSelectedColumns addObject:@(index)];
            }
        }
    }

    NSMutableArray *selfResultMatrix = [NSMutableArray arrayWithArray:_matrixSigns];
    NSMutableArray *otherResultMatrix = [NSMutableArray arrayWithArray:otherMatrix.matrixSigns];

    NSMutableIndexSet *selfIndexSet = [NSMutableIndexSet indexSet];
    for (NSUInteger index = 0; index < selfResultMatrix.count; ++index) {
        if (![selfSelectedColumns containsObject:@(index)]) {
            [selfIndexSet addIndex:index];
        }
    }

    NSMutableIndexSet *otherIndexSet = [NSMutableIndexSet indexSet];
    for (NSUInteger index = 0; index < otherResultMatrix.count; ++index) {
        if (![otherSelectedColumns containsObject:@(index)]) {
            [otherIndexSet addIndex:index];
        }
    }

    [selfResultMatrix removeObjectsAtIndexes:selfIndexSet];
    [otherResultMatrix removeObjectsAtIndexes:otherIndexSet];

    if (_columns < otherMatrix.columns) {
        for (int i = 0; i < selfResultMatrix.count; ++i) {
            for (int j = (int)_columns; j < otherMatrix.columns; ++j) {
                [selfResultMatrix[i]addObject:[NSNumber numberWithDouble:0]];
            }
        }
    } else {
        for (int i = 0; i < otherResultMatrix.count; ++i) {
            for (int j = (int)otherMatrix.columns; j < _columns; ++j) {
                [otherResultMatrix[i]addObject:[NSNumber numberWithDouble:0]];
            }
        }
    }

    completionHandler(selfResultMatrix, otherResultMatrix);
}

+ (NSArray *)matrixDifferencesFromMinuend:(NSArray *)minuend subtrahend:(NSArray *)subtrahend lines:(NSUInteger)lines columns:(NSUInteger)columns {
    NSString *sizeString = [NSString stringWithFormat:@"[%lu][%lu]", lines, columns];
    NSMutableArray *matrixDifferences = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];

    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < columns; ++j) {
            matrixDifferences[i][j] = [NSNumber numberWithDouble:[minuend[i][j]doubleValue] - [subtrahend[i][j]doubleValue]];
        }
    }

    return [matrixDifferences copy];
}

+ (double)maximumValueModuleFromMatrixDiffrences:(NSArray *)matrixDifferences lines:(NSUInteger)lines columns:(NSUInteger)columns {
    double maximum = 0;

    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < columns; ++j) {
            double value = fabs([matrixDifferences[i][j]doubleValue]);
            if (maximum < value) {
                maximum = value;
            }
        }
    }
    return maximum;
}

+ (int)hammingDistanceFromMatrixDiffrences:(NSArray *)matrixDifferences lines:(NSUInteger)lines columns:(NSUInteger)columns andMaximumValueModule:(double)maximumValue {
    NSString *sizeString = [NSString stringWithFormat:@"[%lu][%lu]", lines, columns];
    NSMutableArray *matrix = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];

    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < columns; ++j) {
            matrix[i][j] = (fabs([matrixDifferences[i][j]doubleValue]) < maximumValue ? @0 : @1);
        }
    }

    int hammingDistance = 0;
    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < columns; ++j) {
            hammingDistance += [matrix[i][j]integerValue];
        }
    }

    return hammingDistance;
}

@end
