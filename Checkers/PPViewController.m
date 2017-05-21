//
//  CBViewController.m
//  ChessСheck
//
//  Created by Clyde Barrow on 17.05.17.
//  Copyright © 2017 Clyde Barrow. All rights reserved.
//

#import "PPViewController.h"
#import "PPCheckersPieces.h"
#import "PPHelpFunction.h"


@interface PPViewController ()

@property (nonatomic, strong) PPCheckersBoard * placeDraughts;
@property (nonatomic, strong) PPCheckersPieces * draggingPieces; //light dark
@property (nonatomic, strong) PPCheckersSquare * fieldMovedFinish;
@property (nonatomic, strong) PPCheckersSquare * fieldMoveStart;
@property (nonatomic, assign) CGPoint pointOffset;
@property (nonatomic, strong) NSMutableArray * arrayMoveIsAvailable;
@property (nonatomic, assign) CGPoint pointMoveStart;

@end

@implementation PPViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Lead internals to zero
    //Приводим свойства к нулю
    self.draggingPieces = nil;
    self.fieldMoveStart = nil;
    self.fieldMovedFinish = nil;
    self.pointOffset = CGPointZero;
    self.arrayMoveIsAvailable = [[NSMutableArray alloc] init];
    self.pointMoveStart = CGPointZero;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    //Create the board
    //Создаем доску
    
    //Create the feild and cells
    //Создаем поле, с клетками
    self.placeDraughts = [[PPCheckersBoard alloc] createDraughtsBoardWithView:self.view];
    [self.view addSubview:self.placeDraughts];
    
    //Add cells to the feild
    //Добавляем клетки на поле
    [PPCheckersBoard addFieldOnView:self.view WithPlace:self.placeDraughts];
    
    //Arrange checks on cells
    //Расставляем фишки на клетки
    [PPCheckersBoard addPiecesOnView:self.view WithPlace:self.placeDraughts];
}





#pragma mark - Help Function

//Calculation of a square which is under the dragging peace's center
//Просчёт клетки над которой движется центр фишки
- (CGPoint) calculationPointPositionWithTouch : (UITouch *) touch OnPlace : (PPCheckersBoard *) place WithCorrection : (CGPoint) pointOffset {
    
     //Calculation of a point which is under the dragging piece's center
     //Просчёт точки над которой перемещаем центр фишки
     CGPoint pointCoordinate = [touch locationInView:place];
    
     //Correct a center relatively to a capture point
     //Корректируем центр вью относительно точки захвата
     CGFloat correctionX = pointCoordinate.x + pointOffset.x;
     CGFloat correctionY = pointCoordinate.y + pointOffset.y;
 
    //Calculation of a square which is under the dragging peace's center
    //Вычисляем клетку над которой движется центр фишки
     NSInteger pointX = (int)(correctionX/(CGRectGetWidth(place.bounds)/8));
     NSInteger pointY = (int)(correctionY/(CGRectGetHeight(place.bounds)/8));
 
     CGPoint coordinateView = CGPointMake(pointX, pointY);
 
     return coordinateView;
 }

//Compare a position which is under dragging piece with black squares array
//Сравниваем позицию над которой переносим фишку с массивом черных клеток
- (PPCheckersSquare *) comparePoint : (CGPoint) pointNow withArray : (NSMutableArray *) array {
 
    PPCheckersSquare * resultField = [[PPCheckersSquare alloc] initWithFrame:CGRectZero];
 
    for (PPCheckersSquare * field in array) {
        
        //Calculate a square which is under the dragging peice with chosen square
        //Сравниваем позицию над которой переносим фишку с клеткой
        if (CGPointEqualToPoint(pointNow, field.position)) {
             resultField = field;
             break;
        } else {
             resultField = nil;
        }

    }
 
     return resultField;
}

//Calculate dark squares around
//Определяем черные клетки вокруг
- (NSMutableArray *) willCertainFieldIsAvaibleWithPoint : (CGPoint) pointMoveStart WithBlackField : (NSMutableArray *) fieldsBlack {
    
     //Piece capture point
     //Точка с которой берем фишку
     CGFloat x = pointMoveStart.x;
     CGFloat y = pointMoveStart.y;
    
    
    NSMutableArray * arrayMoveIsAvailable = [[NSMutableArray alloc] init];
     //Check all dark squares array
     //Проверяем массив всех черных клеток
     for (PPCheckersSquare * field in fieldsBlack) {
         //Calculate only whose dark squares which is around our peice
         //Ищем только те черные клетки что вокруг нашей
         if (((field.position.x <= x + 1) & (field.position.x >= x - 1)) & ((field.position.y <= y + 1) & (field.position.y >= y - 1))) {
             [arrayMoveIsAvailable addObject:field];
         }
     }
    
    return arrayMoveIsAvailable;
 }

//Check the nearest squares availability
//Проверяем доступность клеток вокруг
- (BOOL) clearFieldFromNotAvailableWithArray : (NSMutableArray *) arrayMoveIsAvailable DraggingPieces : (PPCheckersPieces *) draggingPieces {
 
     BOOL isOpponent = NO;
    
     //Check array for an opponent color. If yes, should battle
     //Проверка массива на цвет соперника. если есть соперник его надо бить
     for (PPCheckersSquare * field in arrayMoveIsAvailable) {
         
         //These are not mine
         //Это не свои
         if (!(field.type == draggingPieces.type) & !(field.type == typeNone)) {
 
             isOpponent = YES;
             break;
 
         }
     }
 
    return isOpponent;
 }

//Check an opponent's squares for a battle
//Нахождение клеток противника, для боя                    ????
 - (NSMutableArray *) calculationOpponent {
 
     NSMutableArray * opponent = [[NSMutableArray alloc] init];
     
     //Check every nearest square for an opponent
     //Проверим каждую клетку вокруг стартовой на врага
     for (PPCheckersSquare * field in self.arrayMoveIsAvailable) {
         
         //If there is an opponent
         //Если враг есть
         if (!(field.type == self.draggingPieces.type) & !(field.type == typeNone)) {
 
             CGPoint resultPoint = [self calculationPositionAfterBattleWithOpponent:field StartPosition:self.fieldMoveStart];
             PPCheckersSquare * resultView = [self comparePoint:resultPoint withArray:self.placeDraughts.fieldsBlack];
             
                //Если эта клетка свободна
                if (resultView.type == typeNone) {
                [opponent addObject:resultView];
                    
             }
         }
     }
 
     return opponent;
 }


//Calculate a square after battle
//Расчет клетки после боя
- (CGPoint) calculationPositionAfterBattleWithOpponent : (PPCheckersSquare *) field StartPosition : (PPCheckersSquare *) fieldMoveStart {
    
    //A calculated point
    //Точка которую расчитываем
     CGPoint finishPoint = CGPointZero;
    
    //X point
    //Точка для x
    if (field.position.x < fieldMoveStart.position.x) {
        finishPoint = CGPointMake(field.position.x - 1, finishPoint.y);
    } else {
        finishPoint = CGPointMake(field.position.x + 1, finishPoint.y);
    }
    
    //Y point
    //Точка для y
    if (field.position.y < fieldMoveStart.position.y) {
        finishPoint = CGPointMake(finishPoint.x, field.position.y - 1);
    } else {
        finishPoint = CGPointMake(finishPoint.x, field.position.y + 1);
    }
 
     return finishPoint;
 }
 



//Empty squares determonation
//Нахождение пустых клеток          ?????
- (NSMutableArray *) calculationNotFreeFieldsWithAvailable {
  
     NSMutableArray * freeField = [[NSMutableArray alloc] init];
    
     //If the dragging piece is dark
     //Если движимая фишка черная
     if (self.draggingPieces.type == typeBlackMen) {
 
         for (PPCheckersSquare * field in self.arrayMoveIsAvailable) {
             //If square is below the start square (Can not move back)
             //Если клетка ниже стартовой клетки (назад ходить нельзя)
             if ((field.position.y > self.fieldMoveStart.position.y) & (field.type == typeNone)) {
                 [freeField addObject:field];
            }
         }
         //It the dragging piece is light
         //Если движимая фишка белая
     } else if (self.draggingPieces.type == typeWhiteMen) {
 
         for (PPCheckersSquare * field in self.arrayMoveIsAvailable) {
             //If square is above the start square (Can not move back)
             //Если клетка выше стартовой клетки (назад ходить нельзя)
             if ((field.position.y < self.fieldMoveStart.position.y) & (field.type == typeNone)) {
                 [freeField addObject:field];
             }
         }
     }

    return freeField;
 
 }
//Check for an opponent
//Проверка на оппонента
- (void) checkAvailableArrayForOpponent : (NSMutableArray *) opponent {
    //If there is at least one opponent
    //Если есть хотя бы один оппонент
    if (opponent.count > 0) {
        
        [self.arrayMoveIsAvailable removeAllObjects];
        self.arrayMoveIsAvailable = opponent;
        
    } else {
        
        NSMutableArray * freeFields = [self calculationNotFreeFieldsWithAvailable];
        [self checkAvailableArrayForFreeFields:freeFields];
        
    }
    
}
//Check for empty squares
//Проверка на пустые клетки
- (void) checkAvailableArrayForFreeFields : (NSMutableArray *) freeField {
    
    //If there is at least one empty square
    //Если есть хотя бы одна пустая клетка
    if (freeField.count > 0) {
        
        [self.arrayMoveIsAvailable removeAllObjects];
        self.arrayMoveIsAvailable = freeField;
        
    } else {
        
        [self.arrayMoveIsAvailable removeAllObjects];
        [self.arrayMoveIsAvailable  addObject:self.fieldMoveStart];
        
    }
    
}


#pragma mark - Animation Function
//Available squares indication
//Анимирование клеток на которые можно сделать ход
- (void) indicationAllowMove : (NSMutableArray *) arrayMoveIsAvailable Switch : (BOOL) indication {
    
    for (PPCheckersSquare * field in arrayMoveIsAvailable) {
        [UIView animateWithDuration:.3f
                              delay:0
                            options:0
                         animations:^{
                             
                             if (indication) {
                                 field.backgroundColor = [[PPHelpFunction alloc] colorWithR:82.f G:119.f B:131.f];
                             } else {
                                 field.backgroundColor = [[PPHelpFunction alloc] colorWithR:134.f G:162.f B:171.f];
                             }
                             
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

//Piece placement indication
//Анимация постановки на клетку
- (void) animationComingPieces : (PPCheckersPieces *) draggingPieces ToFinishPlace : (PPCheckersSquare *) fieldMovedFinish {
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         draggingPieces.center = fieldMovedFinish.center;
                         draggingPieces.transform = CGAffineTransformIdentity;
                     }];
    
}

//Piece wrong placement indication
//Анимация ошибочной постановки шашки
- (void) animationErrorField : (NSSet<UITouch *> *)touches WithField : (PPCheckersSquare *) fieldMovedFinish{
    
    //Calculate square to color in case a wrong piece placement
    //Определяем клетку которую будем красить при неверном ходе (на запрещенную клетку)
    UITouch * touch = [touches anyObject];
    CGPoint pointFinish = [self calculationPointPositionWithTouch:touch OnPlace:self.placeDraughts WithCorrection:self.pointOffset];
    PPCheckersSquare * fieldError = [self comparePoint:pointFinish withArray:self.placeDraughts.fields];
    
    
    //If it is not a start square
    //Если это не стартовая клетка
    if (![fieldError isEqual:fieldMovedFinish]) {
        
        //Create a custom color copy to put it back after animation
        //Делаем копию начального цвета, чтобы вернуть после анимации
        UIColor * color = fieldError.backgroundColor;
        
        [UIView animateWithDuration:.7f
                              delay:0.f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             fieldError.backgroundColor = [[PPHelpFunction alloc] colorWithR:235.f G:107.f B:107.f];
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:.7f
                                                   delay:0.f
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  fieldError.backgroundColor = color;
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
        
    }
}




#pragma mark - MoveView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
 
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    PPCheckersPieces * view = (PPCheckersPieces *)[self.view hitTest:point withEvent:event];
 
    if (![view isEqual:self.view]) {
        
        //1. Calculate a dragging piece
        //1. Определение движимой шашки
        self.draggingPieces = view;
        
        //2. Piece center correction, to be abble to pull not for a center only
        //2. Корректировка центра фишки, что бы можно было хватать не только за центр
        CGPoint pointView = [touch locationInView:self.draggingPieces];
        self.pointOffset = CGPointMake(CGRectGetMidX(self.draggingPieces.bounds) - pointView.x,
                                        CGRectGetMidY(self.draggingPieces.bounds) - pointView.y);
         
        //3. Draging animation (goes up)
        //3. Анимация увеличения (типа подняли)
        [UIView animateWithDuration:0.3f
                        animations:^{
                            [self.view bringSubviewToFront:self.draggingPieces];
                            self.draggingPieces.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                        }];
 
        
        //4. Calculate starting square and remove it from the list of inavailable
        //4. Определяем стартовую вью и убираем ее из списка недоступных
        self.pointMoveStart = self.draggingPieces.position;
        self.fieldMoveStart = [self comparePoint:self.pointMoveStart withArray:self.placeDraughts.fields];
        self.fieldMoveStart.type = typeNone;
        
        //Set a final point as a start in case of wrong position while releasing
        //Задаем финальную точку стартовой, на случай если при отпускании будем над запрещенной точкой
        self.fieldMovedFinish = self.fieldMoveStart;
        
        //5. Calculate available squares
        //5. Отпределяем куда можно ставить фишку
        self.arrayMoveIsAvailable = [self willCertainFieldIsAvaibleWithPoint:self.pointMoveStart WithBlackField:self.placeDraughts.fieldsBlack];
        BOOL isOpponent = [self clearFieldFromNotAvailableWithArray:self.arrayMoveIsAvailable DraggingPieces:self.draggingPieces];
        
        //If there is an opponent
        //Если есть враг
        if (isOpponent) {
            NSMutableArray * opponent = [self calculationOpponent];
            [self checkAvailableArrayForOpponent:opponent];
         
        //If there are only mine pieces
        //Если только свои вокруг
        } else {
            NSMutableArray * freeFields = [self calculationNotFreeFieldsWithAvailable];
            [self checkAvailableArrayForFreeFields:freeFields];
        }
        
        //6. Indicate available squares
        //6. Обозначим клетки на которые можно ставить
        [self indicationAllowMove:self.arrayMoveIsAvailable Switch:YES];
 
 
    } else {
        self.draggingPieces = nil;
    }
}





 
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
 
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
 
    //1. Coordination correctiont relating to a touch point
    //1. Коррекция координат центра относительно той точки за которую держим
    CGPoint correction = CGPointMake(point.x + self.pointOffset.x,
                                    point.y + self.pointOffset.y);
 
    self.draggingPieces.center = correction;
 
    
    //2. Calculate a square which is under the dragging piece and its availability
    //2. Определение клетки над которой перемещаем фишку и возможность поставить на нее
    CGPoint pointFinish = [self calculationPointPositionWithTouch:touch OnPlace:self.placeDraughts WithCorrection:self.pointOffset];
    PPCheckersSquare * fieldFinish = [self comparePoint:pointFinish withArray:self.arrayMoveIsAvailable];
 
    //If it is nil than finish is equal to start but not the latest dark square where a peice has been dragged above
    //Если нам вернулся nil то финиш равен старту а не последней черной клетке над которой пролетали
    if (!fieldFinish) {
        self.fieldMovedFinish = self.fieldMoveStart;
    //In case a square is dark, than it should be checked for availability. If empty, can finish
    //Иначе клетка черная и ее надо проверить на занятость, если она пустая то можно в нее финишировать
    } else {
        if ((fieldFinish.type = typeNone)) {
            self.fieldMovedFinish = fieldFinish;
        }
    }
}
 





- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    //1. Available squares switch out
    //1. Возможные для хода клетки гаснут
    [self indicationAllowMove:self.arrayMoveIsAvailable Switch:NO];
 
 
    if (!self.draggingPieces) {
    
    //Dragging piece which is released
    //Имеем движимую фишку которую отпустили
    } else {
        
        //2. Red mistake view
        //2. Красное вью ошибки
        if ([self.fieldMovedFinish isEqual:self.fieldMoveStart]) {
            [self animationErrorField:touches WithField:self.fieldMovedFinish];
        }
        
        //3. Lessening indication and smooth movemet to a finish square
        //3. Анимация уменьшения и плавного передвижения на клетку finish
        [self animationComingPieces:self.draggingPieces ToFinishPlace:self.fieldMovedFinish];
        
        //4. Make a finish square busy
        //4. Клетку финиша делаем зянятой
        self.fieldMovedFinish.type = self.draggingPieces.type;
         
        //5. Change a piece position
        //5. Изменяем позицию фишки
        self.draggingPieces.position = self.fieldMovedFinish.position;
        
        //6. next move is for an opponent
        //6. Следующий ход отдаем сопернику

 
        //7. Reset the variables
        //7. Сбрасываем переменные
        self.draggingPieces = nil;
        self.fieldMoveStart = nil;
        self.fieldMovedFinish = nil;
        self.pointOffset = CGPointZero;
        [self.arrayMoveIsAvailable removeAllObjects];
        self.pointMoveStart = CGPointZero;
    }
}





 
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
 
    [self touchesEnded:touches withEvent:event];
    
}





@end
