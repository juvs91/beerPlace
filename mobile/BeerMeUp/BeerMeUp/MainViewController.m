//
//  MainViewController.m
//  BeerMeUp
//
//  Created by Compean on 04/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.topItem.title  = @"BeerMeUp";
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
                 //NSString *[self.userProfileImage setProfileID:user.id];
             }
         }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
