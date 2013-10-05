//
//  SearchBeerViewController.h
//  BeerMeUp
//
//  Created by Compean on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@interface SearchBeerViewController : UIViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bottomTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *findButton;

@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;
- (IBAction)findBeers:(id)sender;

//Set this to true to prevent auto complete terms from returning instantly.
@property (assign) BOOL simulateLatency;

//Set this to true to return an array of autocomplete objects to the autocomplete textfield instead of strings.
//The objects returned respond to the MLPAutoCompletionObject protocol.
@property (assign) BOOL testWithAutoCompleteObjectsInsteadOfStrings;

@end
