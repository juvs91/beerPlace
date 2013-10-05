//
//  Location.m
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "Location.h"


@implementation Location

- (Location *)initWithCity:(NSString *)city state:(NSString *)state country: (NSString *)country
{
	self = [super init];
	self.city = city;
	self.state = state;
	self.country = country;
	return self;
}
@end
