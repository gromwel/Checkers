//
//  CBDraughtsPlace.h
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPCheckersBoard : UIView

@property (nonatomic, strong) NSMutableArray * squares;
@property (nonatomic, strong) NSMutableArray * squaresBlack;


+ (void) addSquareOnView : (UIView *) view WithBoard : (PPCheckersBoard *) board;
+ (void) addPiecesOnView : (UIView *) view WithBoard : (PPCheckersBoard *) board;
- (PPCheckersBoard *) createCheckersBoardWithView : (UIView *) view;

@end
