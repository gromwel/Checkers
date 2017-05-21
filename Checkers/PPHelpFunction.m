//
//  CBHelpFunction.m
//  ChessСheck
//
//  Created by Clyde Barrow on 17.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPHelpFunction.h"
#import "PPCheckersPieces.h"
#import "PPCheckersSquare.h"
#import "PPCheckersBoard.h"


@implementation PPHelpFunction

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIColor *) colorWithR : (CGFloat) red G : (CGFloat) green B : (CGFloat) blue {
    
    CGFloat r = (1.f / 256) * red;
    CGFloat g = (1.f / 256) * green;
    CGFloat b = (1.f / 256) * blue;
    
    UIColor * color = [UIColor colorWithRed:r green:g blue:b alpha:1.f];
    
    return color;
}


@end
