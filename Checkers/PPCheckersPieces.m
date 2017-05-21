//
//  CBDraughtsPieces.m
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPCheckersPieces.h"
#import "PPHelpFunction.h"

@implementation PPCheckersPieces

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initBlackPiecesWithSquareWidth : (PPCheckersSquare *) square
{
    self = [super init];
    if (self) {
        CGFloat width = CGRectGetWidth(square.bounds);
        
        square.type = typeDarkMen;
        
        self.backgroundColor = [[PPHelpFunction alloc] colorWithR:106.f G:106.f B:108.f];
        self.layer.borderColor = [[[PPHelpFunction alloc] colorWithR:196.f G:191.f B:187.f] CGColor];
        self.layer.borderWidth = 1.f;
        self.frame = CGRectMake(0, 0, (0.8f * width), (0.8f * width));
        
        self.center = CGPointMake(CGRectGetMidX(square.frame), CGRectGetMidY(square.frame));
        self.position = square.position;
        
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
        self.type = typeDarkMen;

    }
    return self;
}


- (instancetype)initWhitePiecesWithSquareWidth : (PPCheckersSquare *) square
{
    self = [super init];
    if (self) {
        CGFloat width = CGRectGetWidth(square.bounds);
        
        square.type = typeLightMen;
        
        self.backgroundColor = [[PPHelpFunction alloc] colorWithR:244.f G:217.f B:206.f];
        self.layer.borderColor = [[[PPHelpFunction alloc] colorWithR:236.f G:137.f B:142.f] CGColor];
        self.layer.borderWidth = 1.f;
        self.frame = CGRectMake(0, 0, (0.8f * width), (0.8f * width));
        
        self.center = CGPointMake(CGRectGetMidX(square.frame), CGRectGetMidY(square.frame));
        self.position = square.position;
        
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
        self.type = typeLightMen;


    }
    return self;
}


@end
