//
//  CBDraughtsPieces.h
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPCheckersSquare.h"

@interface PPCheckersPieces : PPCheckersSquare

- (instancetype)initBlackPiecesWithSquareWidth : (PPCheckersSquare *) square;
- (instancetype)initWhitePiecesWithSquareWidth : (PPCheckersSquare *) square;

@end
