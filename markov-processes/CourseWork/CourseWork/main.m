    //
    //  main.m
    //  CourseWork
    //
    //  Created by Ivan Magda on 22.03.15.
    //  Copyright (c) 2015 Ivan Magda. All rights reserved.
    //

#import <Foundation/Foundation.h>
#import "TextAnalisator.h"
#import "MatrixSigns.h"
#import "NSMutableArray+MultyDimention.h"

static NSString * const kTestFile1Path = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/test1.txt";
static NSString * const kTestFile2Path = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/test2.txt";
static NSString * const kTestFile3Path = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/test3.txt";

static NSString * const kTaleFilePath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/tale.txt";
static NSString * const kTaleFragmentFilePath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/taleFragment.txt";

static NSString * const kOscilloscopePath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/oscilloscope.txt";
static NSString * const kAnnaKareninaPath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/Tolstoyi_L._Anna_KareninaI.txt";

static NSString * const kTestTextFilePath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/testText.txt";

static NSString * const kPopriguinyaPath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/popriguinya.txt";
static NSString * const kPopriguinyaFragmentPath = @"/Users/vanyaland/Desktop/CourseWork/CourseWork/Texts/popriguinyaFragment.txt";


void processing(NSString *filePath, NSString *fragmentFilePath) {
        //All text
    TextAnalisator *allTextAnalisator = [TextAnalisator analisatorWithPath:filePath encoding:NSUTF8StringEncoding];
    NSArray *allTextSentences = [allTextAnalisator sentencesFromText];
    NSDictionary *allTextCountPairs= [allTextAnalisator numberWordsBeforeWordInArraySentences:allTextSentences];
    NSArray *allTextMatrix = [allTextAnalisator matrixFromCountPairs:allTextCountPairs];

    MatrixSigns *alltextMatrixSigns = [[MatrixSigns alloc]initWithMatrix:allTextMatrix numberColumns:allTextAnalisator.lengthLongestSentence words:allTextAnalisator.sortedWords];

    NSMutableString *allTextMatrixSignsString = [NSMutableString new];
    for (int i = 0; i < alltextMatrixSigns.matrixSigns.count; ++i) {
        for (int j = 0; j < alltextMatrixSigns.columns; ++j) {
            [allTextMatrixSignsString appendString:[NSString stringWithFormat:@"%f ", [alltextMatrixSigns.matrixSigns[i][j]doubleValue]]];
        }
        [allTextMatrixSignsString appendString:@"\n"];
    }

        //Fragment
    TextAnalisator *fragmentAnalisator = [TextAnalisator analisatorWithPath:fragmentFilePath encoding:NSUTF8StringEncoding];
    NSArray *fragmentSentences = [fragmentAnalisator sentencesFromText];
    NSDictionary *fragmentCountPairs = [fragmentAnalisator numberWordsBeforeWordInArraySentences:fragmentSentences];
    NSArray *fragmentMatrix = [fragmentAnalisator matrixFromCountPairs:fragmentCountPairs];

    MatrixSigns *fragmentMatrixSigns = [[MatrixSigns alloc]initWithMatrix:fragmentMatrix numberColumns:fragmentAnalisator.lengthLongestSentence words:fragmentAnalisator.sortedWords];

    NSMutableString *fragmentTextMatrixSignsString = [NSMutableString new];
    for (int i = 0; i < fragmentMatrixSigns.matrixSigns.count; ++i) {
        for (int j = 0; j < fragmentMatrixSigns.columns; ++j) {
            [fragmentTextMatrixSignsString appendString:[NSString stringWithFormat:@"%f ", [fragmentMatrixSigns.matrixSigns[i][j]doubleValue]]];
        }
        [fragmentTextMatrixSignsString appendString:@"\n"];
    }

    [alltextMatrixSigns compareMatrixSignsWithOtherMatrix:fragmentMatrixSigns andWithCompletionHandler:^(NSArray *selfMatrix, NSArray *otherMatrix) {
        NSMutableString *selfMatrixString = [NSMutableString new];

//        NSString *sizeString = [NSString stringWithFormat:@"[%lu][%lu]", selfMatrix.count, (long)15];
//        NSMutableArray *matrix = [NSMutableArray mutableNullArraysWithVisualFormat:sizeString];

        for (int i = 0; i < selfMatrix.count; ++i) {
            for (int j = 0; j < 15; ++j) {
                [selfMatrixString appendString:[NSString stringWithFormat:@"%f ", [otherMatrix[i][j]doubleValue]]];

                    //matrix[i][j] = ([selfMatrix[i][j]doubleValue] < [otherMatrix[i][j]doubleValue] ? @0 : @1);
            }
            [selfMatrixString appendString:@"\n"];
        }

//        int hammingDistance1 = 0;
//        for (int i = 0; i < matrix.count; ++i) {
//            for (int j = 0; j < 15; ++j) {
//                hammingDistance1 += [matrix[i][j]integerValue];
//            }
//        }


        NSUInteger lines = selfMatrix.count;
        NSUInteger columns = alltextMatrixSigns.columns;

        NSArray *matrixDifferences = [MatrixSigns matrixDifferencesFromMinuend:selfMatrix subtrahend:otherMatrix lines:lines columns:columns];

        NSMutableString *str2 = [NSMutableString new];
        for (int i = 0; i < lines; ++i) {
            for (int j = 0; j < columns; ++j) {
                [str2 appendString:[NSString stringWithFormat:@"%f ", [matrixDifferences[i][j]doubleValue]]];
            }
            [str2 appendString:@"\n"];
        }

        double maximumValueModule = [MatrixSigns maximumValueModuleFromMatrixDiffrences:matrixDifferences lines:lines columns:columns];
        NSLog(@"MaxValue: %f", maximumValueModule);

        int hammingDistance = [MatrixSigns hammingDistanceFromMatrixDiffrences:matrixDifferences lines:lines columns:columns andMaximumValueModule:maximumValueModule];
        NSLog(@"Hamming distance: %d", hammingDistance);
    }];

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
            //processing(kTestFile1Path, kTestFile2Path);

        TextAnalisator *textAnalisator = [[TextAnalisator alloc]initWithPath:kPopriguinyaPath encoding:NSUTF8StringEncoding];

        NSArray *textSentences = [textAnalisator sentencesFromText];
        NSDictionary *textCountPairs= [textAnalisator numberWordsBeforeWordInArraySentences:textSentences];
        NSArray *textMatrix = [textAnalisator matrixFromCountPairs:textCountPairs];

//        for (int i = 0; i < textMatrix.count; ++i) {
//            for (int j = 0; j < textMatrix.count; ++j) {
//                if ([textMatrix[i][j]isKindOfClass:[NSNull class]]) {
//                    printf("0 ");
//                } else {
//                    printf("%li ", (long)[textMatrix[i][j]integerValue]);
//                }
//            }
//            printf("\n");
//        }

        MatrixSigns *textMatrixSigns = [[MatrixSigns alloc]initWithMatrix:textMatrix numberColumns:textAnalisator.lengthLongestSentence words:textAnalisator.sortedWords];

        [textMatrixSigns saveDataToDiskFileName:@"popriguinya"];


        TextAnalisator *fragmentAnalisator = [[TextAnalisator alloc]initWithPath:kPopriguinyaFragmentPath encoding:NSUTF8StringEncoding];

        NSArray *fragmentSentences = [fragmentAnalisator sentencesFromText];
        NSDictionary *fragmentCountPairs= [fragmentAnalisator numberWordsBeforeWordInArraySentences:fragmentSentences];
        NSArray *fragmentMatrix = [fragmentAnalisator matrixFromCountPairs:fragmentCountPairs];

        MatrixSigns *fragmentMatrixSigns = [[MatrixSigns alloc]initWithMatrix:fragmentMatrix numberColumns:fragmentAnalisator.lengthLongestSentence words:fragmentAnalisator.sortedWords];
        
        [fragmentMatrixSigns saveDataToDiskFileName:@"popriguinyaFragment"];

    }
    return 0;
}
