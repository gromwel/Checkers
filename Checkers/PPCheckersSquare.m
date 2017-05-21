//
//  CBDraughtsField.m
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPCheckersSquare.h"
#import "PPHelpFunction.h"

@implementation PPCheckersSquare

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initDarkSquareWithRect : (CGRect) rect
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[PPHelpFunction alloc] colorWithR:134.f G:162.f B:171.f];
        self.layer.borderColor = [[[PPHelpFunction alloc] colorWithR:201.f G:193.f B:190.f] CGColor];
        self.layer.borderWidth = .5f;
        self.frame = rect;
        self.type = typeNone;
        self.userInteractionEnabled = NO;
        
    }
    return self;
}

- (instancetype)initLightSquareWithRect : (CGRect) rect
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[PPHelpFunction alloc] colorWithR:226.f G:234.f B:225.f];
        self.layer.borderColor = [[[PPHelpFunction alloc] colorWithR:201.f G:193.f B:190.f] CGColor];
        self.layer.borderWidth = .5f;
        self.frame = rect;
        self.type = typeNone;
        self.userInteractionEnabled = NO;
        
    }
    return self;
}








@end
