//
//  AppDelegate.h
//  Checkers Demo
//
//  Created by Clyde Barrow on 21.05.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

