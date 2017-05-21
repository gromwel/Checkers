//
//  CBDraughtsPlace.m
//  ChessСheck
//
//  Created by Clyde Barrow on 16.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPCheckersBoard.h"
#import "PPCheckersSquare.h"
#import "PPCheckersPieces.h"
#import "PPHelpFunction.h"



@implementation PPCheckersBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.squares = [[NSMutableArray alloc] init];
        self.squaresBlack = [[NSMutableArray alloc] init];
    }
    return self;
}


//Create a board and calculate sizes and coordinates related to this board
//Создание доски относительно которой расчитываем размеры и координаты
- (PPCheckersBoard *) createCheckersBoardWithView : (UIView *) view {
    
    //Set color
    //Задаем цвет доски
    view.backgroundColor = [[PPHelpFunction alloc] colorWithR:201.f G:193.f B:190.f];
    
    //Set borders for the board and make it smaller
    //Чтобы поле не было в притык к границам делаем его чуть меньше
    CGFloat lengthSideView = MIN(CGRectGetHeight(view.frame), CGRectGetWidth(view.frame));
    CGRect rect = CGRectInset(view.frame, lengthSideView / 18, lengthSideView / 18);
    
    
    //Calculate a smallest view sides length to create a board on its base
    //Вычислем меньшую длину из сторон вью чтобы на ее базе создать доску
    CGFloat lengthSideBoard = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect));
    
    
    //Create invisible view to count the point's coordinate on its base
    //Cделаем невидимый вью что бы относительно него считать координату точки
    PPCheckersBoard * boardCheckers = [[PPCheckersBoard alloc] initWithFrame:CGRectMake(0, 0, lengthSideBoard, lengthSideBoard)];
    boardCheckers.center = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
    boardCheckers.backgroundColor = [UIColor purpleColor];
    boardCheckers.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    boardCheckers.userInteractionEnabled = NO;
    
    return boardCheckers;
}



//Add squares to the board
//Добавляем квадраты на поле
+ (void) addSquareOnView : (UIView *) view WithBoard : (PPCheckersBoard *) board {

    //The highest point of the left square
    //Левая верхняя точка первой клетки
    CGFloat boardXPoint = CGRectGetMinX(board.frame);
    CGFloat boardYPoint = CGRectGetMinY(board.frame);
    
    //Square side length
    //Длина стороны клетки
    CGFloat lengthSideSquare = CGRectGetWidth(board.frame) / 8;
    
    //Sides array
    //Массивы для клеток
    NSMutableArray * squares = [[NSMutableArray alloc] init];
    NSMutableArray * squaresBlack = [[NSMutableArray alloc] init];
    
    
    
    //Square to a board addition cycle
    //Цикл добавления клеток на поле
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
    
    //If both x and y are even or odd
    //Если и x и у обе четные или обе не четные
            if (  ((i % 2) & (j % 2))  |  (!(i % 2) & !(j % 2))  ) {
                
                PPCheckersSquare * square = [[PPCheckersSquare alloc] initLightSquareWithRect:CGRectMake(boardXPoint, boardYPoint, lengthSideSquare, lengthSideSquare)];
    //Set x:y position
    //Записываем положение x:y
                 square.position = CGPointMake(i, j);
    //Add squares to a board
    //Добавляем клетки на поле
                 [view addSubview:square];
    //Combine squares into an array
    //Собираем все клетки в массив
                 [squares addObject:square];
     
             } else {
     
                 PPCheckersSquare * square = [[PPCheckersSquare alloc] initDarkSquareWithRect:CGRectMake(boardXPoint, boardYPoint, lengthSideSquare, lengthSideSquare)];
                 square.position = CGPointMake(i, j);
                 [view addSubview:square];
                 [squares addObject:square];
      //Dark squares combine into an additioinal array
      //Черные клетки еще и в другой массив
                 [squaresBlack addObject:square];
        
             }
             
             boardYPoint = boardYPoint + lengthSideSquare;
         }
         
    boardYPoint = CGRectGetMinY(board.frame);
    boardXPoint = boardXPoint + lengthSideSquare;
    }
    
    board.squares = squares;
    board.squaresBlack = squaresBlack;
    
}


//Add pieces to squares
//Добавляем шашки на клетки
+ (void) addPiecesOnView : (UIView *) view WithBoard : (PPCheckersBoard *) board {
    
    
    //Check black squares array for being inside lines before the 3rd and after 4th
    //Проверяем массив черных клеток на нахожение в строках до 3, и после 4
    for (int i = (int)board.squaresBlack.count - 1; i >= 0; i--) {
        PPCheckersSquare * square = [board.squaresBlack objectAtIndex:i];
        
        //If there are pieces before the 3rd, they are dark
        //Если до третьей строки тогда будут черные фишки
        if (square.position.y < 3) {
            
            PPCheckersPieces * pieces = [[PPCheckersPieces alloc] initBlackPiecesWithSquareWidth:square];
            [view addSubview:pieces];
            
            //If there are pieces after the 4th, they are light
            //Если после четвертой то белые
        } else if (square.position.y > 4) {
            
            PPCheckersPieces * pieces = [[PPCheckersPieces alloc] initWhitePiecesWithSquareWidth:square];
            [view addSubview:pieces];
            
        }
    }
    
}

@end
