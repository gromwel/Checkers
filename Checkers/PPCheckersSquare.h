//
//  CBDraughtsField.h
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPCheckersBoard.h"

typedef enum {
    
    typeDarkMen,
    typeLightMen,
    typeKings,
    typeNone
    
} CBPiecesType;


@interface PPCheckersSquare : PPCheckersBoard

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CBPiecesType type;

- (instancetype)initDarkSquareWithRect : (CGRect) rect;
- (instancetype)initLightSquareWithRect : (CGRect) rect;


@end
