//
//  TopBeersCellView.h
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBeersCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *color;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end
