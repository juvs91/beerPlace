//
//  SearchBeerViewController.m
//  BeerMeUp
//
//  Created by Compean on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "SearchBeerViewController.h"
#import "MLPAutoCompleteTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "DEMOCustomAutoCompleteCell.h"
#import "TopBeersViewController.h"
#import "SBJson.h"

@interface SearchBeerViewController ()

@property NSMutableDictionary *dictonaryKeys;

@end

@implementation SearchBeerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setSimulateLatency:YES]; //Uncomment to delay the return of autocomplete suggestions.
    //[self setTestWithAutoCompleteObjectsInsteadOfStrings:YES]; //Uncomment to return autocomplete objects instead of strings to the textfield.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    /*[self.typeSwitch addTarget:self
                        action:@selector(typeDidChange:)
              forControlEvents:UIControlEventValueChanged];*/
    
    //Supported Styles:
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleBezel];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleLine];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleNone];
    [self.autocompleteTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    //[self.autocompleteTextField setShowAutoCompleteTableWhenEditingBegins:YES];
    //[self.autocompleteTextField setAutoCompleteTableBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    
    //You can use custom TableViewCell classes and nibs in the autocomplete tableview if you wish.
    //This is only supported in iOS 6.0, in iOS 5.0 you can set a custom NIB for the cell
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.autocompleteTextField registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class] forCellReuseIdentifier:@"CustomCellId"];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.autocompleteTextField.applyBoldEffectToAutoCompleteSuggestions = NO;
    }
	// Do any additional setup after loading the view.
}

- (void)typeDidChange:(UISegmentedControl *)sender
{
        [self.autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    
}

- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, -130);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                         [self.findButton setHidden:YES];
                     }
                     completion:nil];
}

- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, 130);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                         [self.findButton setHidden:NO];
                     }
                     completion:nil];
    
    
    //[self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        
        NSArray *completions;
        /*if(self.testWithAutoCompleteObjectsInsteadOfStrings){
            completions = [self allCountryObjects];
        } else {*/
            completions = [self allCities];
        //}
        
        handler(completions);
    });
}

-(NSArray *)allCities{
    /*NSArray *array = @[
                       @"Monterrey",
                       @"Mexico City",
                       @"Toluca",
                       @"San Luis Potosi"];*/
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.dictonaryKeys = [[NSMutableDictionary alloc] init];
    
    NSURL *theURL = [NSURL URLWithString:@"http://10.20.216.157:4040/index.php?r=location/getAllLocation"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    //NSLog(@"PostString in JSON: %@",postString);
    
    NSError *errorRequest;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorRequest];
    
    if (!errorRequest) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response from Server data: %@", dataString);
        if ([dataString isEqual:[NSNull null]]) {
            NSLog(@"dataIsNull");
        } else{
            
            NSArray *rows = [dataString JSONValue];
            for (NSDictionary *city in rows) {
                [array addObject:[city objectForKey:@"Location"]];
                [self.dictonaryKeys setObject:[city objectForKey:@"id"] forKey:[city objectForKey:@"Location"]];
            }
        }
        
    } else{
        //TODO: Make an alert
        NSLog(@"Error contacting our Server");
        NSLog(@"descripcion: %@", [errorRequest description]);
        NSLog(@"response: %@", [((NSHTTPURLResponse *)response) MIMEType]);
    }
    return array;
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    /*NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    [cell.imageView setImage:[UIImage imageNamed:filename]];*/
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(selectedObject){
      //  NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    //} else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    NSNumber *number = (NSNumber *)[self.dictonaryKeys objectForKey:selectedString];
    TopBeersViewController *beersLoc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"TopBeersViewController"];
    beersLoc.idLocation = number;
    NSLog(@"the number is: %d", beersLoc.idLocation.intValue);
    [self.navigationController pushViewController:beersLoc animated:YES];
    //}
}

-(void)viewWillAppear:(BOOL)animated{
    //[self.view setAlpha:0];
    [UIView animateWithDuration:0.2
                          delay:0.25
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.view setAlpha:1.0];
                     }completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findBeers:(id)sender {
    
}
@end
