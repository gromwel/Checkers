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
        self.fields = [[NSMutableArray alloc] init];
        self.fieldsBlack = [[NSMutableArray alloc] init];
    }
    return self;
}


//Create a board and calculate sizes and coordinates related to this board
//Создание доски относительно которой расчитываем размеры и координаты
- (PPCheckersBoard *) createDraughtsBoardWithView : (UIView *) view {
    
    //Set color
    //Задаем цвет доски
    view.backgroundColor = [[PPHelpFunction alloc] colorWithR:201.f G:193.f B:190.f];
    
    //Set borders for the board and make it smaller
    //Чтобы поле не было в притык к границам делаем его чуть меньше
    CGRect rect = CGRectInset(view.frame, 40, 40);
    
    
    //Calculate a smallest view sides length to create a board on its base
    //Вычислем меньшую длину из сторон вью чтобы на ее базе создать доску
    CGFloat lengthSideBoard = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect));
    
    
    //Create invisible view to count the point's coordinate on its base
    //Cделаем невидимый вью что бы относительно него считать координату точки
    PPCheckersBoard * placeDraughts = [[PPCheckersBoard alloc] initWithFrame:CGRectMake(0, 0, lengthSideBoard, lengthSideBoard)];
    placeDraughts.center = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
    placeDraughts.backgroundColor = [UIColor purpleColor];
    placeDraughts.userInteractionEnabled = NO;
    
    return placeDraughts;  
}



//Add squares to the board
//Добавляем квадраты на поле
+ (void) addFieldOnView : (UIView *) view WithPlace : (PPCheckersBoard *) place {

    //The highest point of the left square
    //Левая верхняя точка первой клетки
    CGFloat boardXPoint = CGRectGetMinX(place.frame);
    CGFloat boardYPoint = CGRectGetMinY(place.frame);
    
    //Square side length
    //Длина стороны клетки
    CGFloat lengthSideField = CGRectGetWidth(place.frame) / 8;
    
    //Sides array
    //Массивы для клеток
    NSMutableArray * fields = [[NSMutableArray alloc] init];
    NSMutableArray * fieldsBlack = [[NSMutableArray alloc] init];
    
    
    
    //Square to a board addition cycle
    //Цикл добавления клеток на поле
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
    
    //If both x and y are even or odd
    //Если и x и у обе четные или обе не четные
            if (  ((i % 2) & (j % 2))  |  (!(i % 2) & !(j % 2))  ) {
                
                PPCheckersSquare * field = [[PPCheckersSquare alloc] initWhiteFieldWithRect:CGRectMake(boardXPoint, boardYPoint, lengthSideField, lengthSideField)];
    //Set x:y position
    //записываем положение x:y
                 field.position = CGPointMake(i, j);
    //Add squares to a board
    //добавляем клетки на поле
                 [view addSubview:field];
    //Combine squares into an array
    //собираем все клетки в массив
                 [fields addObject:field];
     
             } else {
     
                 PPCheckersSquare * field = [[PPCheckersSquare alloc] initBlackFieldWithRect:CGRectMake(boardXPoint, boardYPoint, lengthSideField, lengthSideField)];
                 field.position = CGPointMake(i, j);
                 [view addSubview:field];
                 [fields addObject:field];
      //Dark squares combine into an additioinal array
      //черные клетки еще и в другой массив
                 [fieldsBlack addObject:field];
        
             }
             
             boardYPoint = boardYPoint + lengthSideField;
         }
         
    boardYPoint = CGRectGetMinY(place.frame);
    boardXPoint = boardXPoint + lengthSideField;
    }
    
    place.fields = fields;
    place.fieldsBlack = fieldsBlack;
    
}


//Add pieces to squares
//добавляем шашки на клетки
+ (void) addPiecesOnView : (UIView *) view WithPlace : (PPCheckersBoard *) place {
    
    
    //Check black squares array for being inside lines before the 3rd and after 4th
    //Проверяем массив черных клеток на нахожение в строках до 3, и после 4
    for (int i = (int)place.fieldsBlack.count - 1; i >= 0; i--) {
        PPCheckersSquare * field = [place.fieldsBlack objectAtIndex:i];
        
        //If there are pieces before the 3rd, they are dark
        //если до третьей строки тогда будут черные фишки
        if (field.position.y < 3) {
            
            PPCheckersPieces * pieces = [[PPCheckersPieces alloc] initBlackPiecesWithFieldWidth:field];
            [view addSubview:pieces];
            
            //If there are pieces after the 4th, they are light
            //если после четвертой то белые
        } else if (field.position.y > 4) {
            
            PPCheckersPieces * pieces = [[PPCheckersPieces alloc] initWhitePiecesWithFieldWidth:field];
            [view addSubview:pieces];
            
        }
    }
    
}

@end
