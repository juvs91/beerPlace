//
//  RateBeerViewController.m
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "RateBeerViewController.h"
#import "BeerColorView.h"
#import "LGRatingViewController.h"
#import "SBJson.h"
#import "DEMOCustomAutoCompleteCell.h"

@interface RateBeerViewController ()
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (strong, nonatomic) LGRatingViewController *userRating;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *beerTF;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *placeTF;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RateBeerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setLocation:(Location *)location{
	_location = location;
	[self loadPlaces];
	[self loadBeers];
}

-(LGRatingViewController *) userRating{
    if(!_userRating){
        _userRating = [[LGRatingViewController alloc] initWithEmptyImage:[UIImage imageNamed:@"star-empty"] fullImage:[UIImage imageNamed:@"star-full"] numberOfItems:5];
        [_userRating setRounding:NO];
    }
    return _userRating;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.registeredBeers = [[NSMutableArray alloc] init];
	self.registeredLocations = [[NSMutableArray alloc] init];
	
	[self.userRating setView:self.ratingView];
	[self.userRating setEdiable:YES];
	[self.userRating setRounding:YES];
	[self.userRating setRating:3.4/5];
	self.user = [[User alloc] initWithId:1 contributed:0];
	[self startStandardUpdates];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    /*[self.typeSwitch addTarget:self
	 action:@selector(typeDidChange:)
	 forControlEvents:UIControlEventValueChanged];*/
    
    //Supported Styles:
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleBezel];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleLine];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleNone];
    [self.placeTF setBorderStyle:UITextBorderStyleRoundedRect];
	[self.beerTF setBorderStyle:UITextBorderStyleRoundedRect];
    
    //[self.autocompleteTextField setShowAutoCompleteTableWhenEditingBegins:YES];
    //[self.autocompleteTextField setAutoCompleteTableBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    
    //You can use custom TableViewCell classes and nibs in the autocomplete tableview if you wish.
    //This is only supported in iOS 6.0, in iOS 5.0 you can set a custom NIB for the cell
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.placeTF registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class] forCellReuseIdentifier:@"CustomCellId"];
		[self.beerTF registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class] forCellReuseIdentifier:@"CustomCellId2"];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.placeTF.applyBoldEffectToAutoCompleteSuggestions = NO;
		self.beerTF.applyBoldEffectToAutoCompleteSuggestions = NO;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return 13;
}

- (NSString *)createJSONFromValues
{
	
	NSMutableDictionary *place = [[NSMutableDictionary alloc] init];
	[place setValue:self.placeTF.text forKey:@"name"];
	
	NSNumber *userRating = [NSNumber numberWithFloat:[self.userRating getRating]];
	NSMutableDictionary *rating = [[NSMutableDictionary alloc] init];
	[rating setValue:userRating  forKey:@"stars"];
	
	NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
	[location setValue:self.location.city forKey:@"city"];
	[location setValue:self.location.state forKey:@"state"];
	[location setValue:self.location.country forKey:@"country"];
	
	NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
	[user setValue:self.user.userID forKey:@"id"];
	[user setValue:self.user.contributed forKey:@"contributed"];
	
	NSMutableDictionary *beer = [[NSMutableDictionary alloc] init];
	[beer setValue:self.beerTF.text forKey:@"name"];
	NSNumber *colorIndex = [NSNumber numberWithInt:[self.colorPicker selectedRowInComponent:0]];
	[beer setValue:colorIndex forKey:@"idType"];
	
	
	
	NSMutableDictionary *beerRating = [[NSMutableDictionary alloc] init];
	[beerRating setValue:user forKey:@"User"];
	[beerRating setValue:beer forKey:@"Beer"];
	[beerRating setValue:rating forKey:@"Rating"];
	[beerRating setValue:location forKey:@"Location"];
	[beerRating setValue:place forKey:@"Place"];
	
	return [beerRating JSONRepresentation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadBeers{
	NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.20.216.157:4040/index.php?r=beer/getBeersByLocation"]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:5];
	
	NSString *json = [self JSONOfLocation];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		NSHTTPURLResponse *r = (NSHTTPURLResponse*) response;
		if (r.statusCode == 200){
			NSError *error;
			NSArray *beersDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
			self.registeredBeers = [[NSMutableArray alloc] init];
			
			for (NSDictionary *registeredBeer  in beersDict) {
				[self.registeredBeers addObject: [registeredBeer valueForKey:@"name"]];
			}
		} else{
			NSLog(@"Error contacting our Server");
			NSLog(@"descripcion: %@", [response description]);
			NSLog(@"response: %@", [((NSHTTPURLResponse *)response) MIMEType]);
			NSLog(@"JSON: %@", json);
		}
	}];
}

- (NSString *)JSONOfLocation{
	NSMutableDictionary *locationDict = [[NSMutableDictionary alloc] init];
	[locationDict setValue:self.location.country forKey:@"country"];
	[locationDict setValue:self.location.state forKey:@"state"];
	[locationDict setValue:self.location.city forKey:@"city"];
	
	return [locationDict JSONRepresentation];
}

- (void)loadPlaces{
	NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.20.216.157:4040/index.php?r=beer/getPlacesByLocation"]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:5];
	
	NSString *json = [self JSONOfLocation];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		NSHTTPURLResponse *r = (NSHTTPURLResponse*) response;
		if (r.statusCode == 200){
			NSError *error;
			NSArray *placesDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
			self.registeredLocations = [[NSMutableArray alloc] init];
			
			for (NSDictionary *locationDict  in placesDict) {
				[self.registeredLocations addObject: [locationDict valueForKey:@"name"]];
			}
		} else{
			NSLog(@"Error contacting our Server");
			NSLog(@"descripcion: %@", [response description]);
			NSLog(@"response: %@", [((NSHTTPURLResponse *)response) MIMEType]);
			NSLog(@"JSON: %@", json);
		}
	}];
}

- (IBAction)sendRating:(id)sender
{
	NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.20.216.157:4040/index.php?r=user/rating"]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:5];
	
	NSString *json = [self createJSONFromValues];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		NSHTTPURLResponse *r = (NSHTTPURLResponse*) response;
		if (r.statusCode == 200){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your vote has been submited." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		} else{
			NSLog(@"Error contacting our Server");
			NSLog(@"descripcion: %@", [response description]);
			NSLog(@"response: %@", [((NSHTTPURLResponse *)response) MIMEType]);
		}
	}];
}

- (void)currentLocation: (CLLocation *)coordinates
{
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	
    [geocoder reverseGeocodeLocation:coordinates completionHandler:
	 ^(NSArray* placemarks, NSError* error){
		 
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
		 
		 for (CLPlacemark *placemark in placemarks) {
			 if (placemark.ISOcountryCode != NULL && placemark.locality != NULL && placemark.administrativeArea != NULL) {
				 
				 self.location = [[Location alloc] initWithCity:placemark.locality state:placemark.administrativeArea country:placemark.country];
				 [self enableStuff];
			 }
		 }
	 }];
}

- (void)startStandardUpdates
{
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
	
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
    self.locationManager.distanceFilter = 500;
	
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {
	CLLocation* location = [locations lastObject];
	[self currentLocation:location];
}

- (void) enableStuff{
	if (self.location) {
		[self.submitButton setEnabled:YES];
	}else{
		[self.submitButton setTitle:@"Locating..." forState:UIControlStateDisabled];
		[self.submitButton setEnabled:NO];
		return;
	}
	
	if ([self.beerTF.text isEqualToString:@""]) {
		[self.submitButton setTitle:@"Provide the beer name." forState:UIControlStateDisabled];
		[self.submitButton setEnabled:NO];
	}else if ([self.placeTF.text isEqualToString:@""]) {
		[self.submitButton setTitle:@"Provide the place name." forState:UIControlStateDisabled];
		[self.submitButton setEnabled:NO];
	} else{
		[self.submitButton setEnabled:YES];
	}
	
}

- (BeerColorView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(BeerColorView *)view
{
	if(!view){
		view = [[[NSBundle mainBundle] loadNibNamed:@"BeerColorView" owner:self options:nil] objectAtIndex:0];
	}
	
	[view setColorScale:row + 1];
	
	return view;
}
- (IBAction)beerNameChanged:(MLPAutoCompleteTextField *)sender
{
	[self enableStuff];
	[sender setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
}

- (IBAction)placeNameChanged:(MLPAutoCompleteTextField *)sender
{
	[self enableStuff];
	[sender setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
	/*
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
     }
     completion:nil];
	 */
}

- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
	/*
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
     }
     completion:nil];
     
     
     //[self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
	 */
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
		
		while (true) {
			if(textField == self.beerTF){
				if(self.registeredBeers.count > 0){
					completions = [self registeredBeers];
					break;
				}else{
					sleep(2);
				}
			}else{
				if(self.registeredLocations.count > 0){
					completions = [self registeredLocations];
					break;
				}else{
					sleep(2);
				}
			}
		}
        
        handler(completions);
    });
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
	if(textField == self.beerTF){
		self.beerTF.text = selectedString;
	}else{
		self.placeTF.text = selectedString;
	}
    //NSNumber *number = (NSNumber *)[self.dictonaryKeys objectForKey:selectedString];
    /*BeersByLocationView *beersLoc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"BeersByLocationView"];
	 beersLoc.idLocation = number;
	 [self.navigationController pushViewController:beersLoc animated:YES];*/
    //}
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
