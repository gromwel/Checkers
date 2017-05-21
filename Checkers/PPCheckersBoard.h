//
//  CBDraughtsPlace.h
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PPCheckersBoard : UIView

@property (nonatomic, strong) NSMutableArray * fields;
@property (nonatomic, strong) NSMutableArray * fieldsBlack;


+ (void) addFieldOnView : (UIView *) view WithPlace : (PPCheckersBoard *) place;
+ (void) addPiecesOnView : (UIView *) view WithPlace : (PPCheckersBoard *) place;
- (PPCheckersBoard *) createDraughtsBoardWithView : (UIView *) view;

@end
