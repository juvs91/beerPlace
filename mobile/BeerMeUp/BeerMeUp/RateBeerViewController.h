//
//  RateBeerViewController.h
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "RateBeerViewController.h"
#import "Location.h"
#import "Beer.h"
#import "User.h"
#import "MLPAutoCompleteTextField.h"

@interface RateBeerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) Location *location;

@property (strong, nonatomic) NSMutableArray *registeredLocations;
@property (strong, nonatomic) NSMutableArray *registeredBeers;

@property (assign) BOOL simulateLatency;

@end