//
//  MorseCodeView.m
//  morsecode
//
//  Created by Ian Ewell on 10/4/14.
//  Copyright (c) 2014 Ian Ewell. All rights reserved.
//

#import "MorseCodeView.h"
#include <sys/time.h>

const int window = 80;

const int lengths[] = {
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
    3, 3, 3, 3, 3, 3, 3, 3,
    2, 2, 2, 2,
    1, 1,
};

const char codes[][5] = {
    {1, 2, 2, 2, 2},
    {1, 1, 2, 2, 2},
    {1, 1, 1, 2, 2},
    {1, 1, 1, 1, 2},
    {1, 1, 1, 1, 1},
    {2, 1, 1, 1, 1},
    {2, 2, 1, 1, 1},
    {2, 2, 2, 1, 1},
    {2, 2, 2, 2, 1},
    {2, 2, 2, 2, 2},
    {2, 1, 1, 1, 0},
    {2, 1, 2, 1, 0},
    {1, 1, 2, 1, 0},
    {1, 1, 1, 1, 0},
    {1, 2, 2, 2, 0},
    {1, 2, 1, 1, 0},
    {1, 2, 2, 1, 0},
    {2, 2, 1, 2, 0},
    {1, 1, 1, 2, 0},
    {2, 1, 1, 2, 0},
    {2, 1, 2, 2, 0},
    {2, 2, 1, 1, 0},
    {2, 1, 1, 0, 0},
    {2, 1, 1, 0, 0},
    {2, 1, 2, 0, 0},
    {2, 2, 2, 0, 0},
    {1, 2, 1, 0, 0},
    {1, 1, 1, 0, 0},
    {1, 1, 2, 0, 0},
    {1, 2, 2, 0, 0},
    {1, 2, 0, 0, 0},
    {1, 1, 0, 0, 0},
    {2, 2, 0, 0, 0},
    {2, 1, 0, 0, 0},
    {1, 0, 0, 0, 0},
    {2, 0, 0, 0, 0},
};

const char morseChars[] = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
    'B', 'C', 'F', 'H', 'J', 'L', 'P', 'Q', 'V', 'X', 'Y', 'Z',
    'D', 'G', 'K', 'O', 'R', 'S', 'U', 'W',
    'A', 'I', 'M', 'N',
    'E', 'T',
};

unsigned int _getMilliseconds() {
    struct timeval time;
    gettimeofday(&time, NULL);
    return (time.tv_sec * 1000) + (time.tv_usec / 1000);
}

@implementation MorseCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    if (self = [super init]) {
        timeBeginning = _getMilliseconds();
        dotCount = 0;
        morseString = [[NSMutableString alloc] initWithString:@""];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_getMilliseconds() - timeBeginning >= window*3) {
        NSLog(@"dot count: %d", dotCount);
        // Loop through all letters
        int charFound = 1;
        for (int i = 0; i < 36; i++) {
            if (dotCount != lengths[i]) {
                continue;
            }
            for (int j = 0; j < dotCount; j++) {
                charFound = 1;
                if (codes[i][j] != morseCodeBuff[j]) {
                    charFound = 0;
                    break;
                }
            }
            if (charFound == 1) {
                if (morseString == nil) {
                    morseString = [[NSMutableString alloc] initWithString:@""];
                }
                [morseString appendFormat:@"%c", morseChars[i]];
                break;
            }
        }
        dotCount = 0;
        [morseCodeLabel setText:morseString];
    }
    timeBeginning = _getMilliseconds();
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_getMilliseconds() - timeBeginning <= window) {
        morseCodeBuff[dotCount] = 1;
    } else {
        morseCodeBuff[dotCount] = 2;
    }
    dotCount++;
    timeBeginning = _getMilliseconds();
}

@end
