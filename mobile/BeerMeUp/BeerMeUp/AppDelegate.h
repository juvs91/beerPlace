//
//  AppDelegate.h
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 04/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navController;

- (void)openSession;

@end
