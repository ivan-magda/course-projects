//
//  main.cpp
//  MatrixAuntHW
//
//  Created by Ivan Magda on 12.03.15.
//  Copyright (c) 2015 Ivan Magda. All rights reserved.
//

#include <iostream>
#include <iomanip>

static const int kWidthOutPut = 10;

using namespace std;

void printMatrixLine(const float *matrix, const int& size);
void copyMatrixLine(const float *source, float *outer, const int& size);

int main(int argc, const char * argv[]) {

    float transitionProbabilityMatrix[4][4] = {0.3, 0.0, 0.0, 0.0,
                                               0.4, 0.4, 0.0, 0.0,
                                               0.2, 0.4, 0.3, 0.0,
                                               0.1, 0.2, 0.7, 1.0
                                               };



    float reverseMatrix[4][4];
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            reverseMatrix[j][i] = transitionProbabilityMatrix[i][j];
        }
    }

    float originalMatrix[4][4];
    for (int i = 0; i < 4; ++i) {
        copyMatrixLine(transitionProbabilityMatrix[i], originalMatrix[i], 4);
    }

    float valuesHolder[4][4];

        //powMatrix
    int degree = 4;
    for (int i = 1; i < degree; ++i) {

        for (int line = 0; line < 4; ++line) {
            for (int column = 0; column < 4; ++column) {
                float value = 0;
                for (int j = 0; j < 4; ++j) {
                    value += transitionProbabilityMatrix[line][j] * originalMatrix[j][column];
                    if (j == 3) {
                        valuesHolder[line][column] = value;
                    }
                }
            }
        }
        for (int l = 0; l < 4; ++l) {
            copyMatrixLine(valuesHolder[l], transitionProbabilityMatrix[l], 4);
        }
    }

    for (int i = 0; i < 4; ++i) {
        printMatrixLine(transitionProbabilityMatrix[i], 4);
        cout << endl;
    }

    return 0;
}

void printMatrixLine(const float *matrix, const int& size) {
    for (int i = 0; i < size; ++i) {
        cout << setw(kWidthOutPut) << matrix[i];
    }
}

void copyMatrixLine(const float *source, float *outer, const int& size) {
    for (int i = 0; i < size; ++i) {
        outer[i] = source[i];
    }
}
