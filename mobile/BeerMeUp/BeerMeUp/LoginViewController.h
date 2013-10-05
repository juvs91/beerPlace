//
//  ViewController.h
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 04/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController

- (IBAction)logIn:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (void)loginFailed;

@end
