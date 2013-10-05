//
//  MainViewController.h
//  BeerMeUp
//
//  Created by Compean on 04/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
- (void)populateUserDetails;

@end
