//
//  Beer.m
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "Beer.h"

@implementation Beer

- (Beer *) initWithName:(NSString *)name location:(NSString *)location color:(NSNumber *)color averageRating:(NSNumber *)averageRating
{
	self = [super init];
	self.name = name;
	self.location = location;
	self.color = color;
	self.averageRating = averageRating;
	
	return self;
}

+ (UIColor *)colorForColorScaleValue:(NSInteger)scaleValue {
	switch (scaleValue) {
		case 1:
			return [UIColor colorWithRed:247/255.0 green:252/255.0 blue:51/255.0 alpha:1];
			break;
			
		case 2:
			return [UIColor colorWithRed:244/255.0 green:250/255.0 blue:0/255.0 alpha:1];
			break;
			
		case 3:
			return [UIColor colorWithRed:232/255.0 green:230/255.0 blue:0/255.0 alpha:1];
			break;
			
		case 4:
			return [UIColor colorWithRed:204/255.0 green:178/255.0 blue:0/255.0 alpha:1];
			break;
			
		case 5:
			return [UIColor colorWithRed:178/255.0 green:129/255.0 blue:38/255.0 alpha:1];
			break;
			
		case 6:
			return [UIColor colorWithRed:178/255.0 green:111/255.0 blue:38/255.0 alpha:1];
			break;
			
		case 7:
			return [UIColor colorWithRed:174/255.0 green:83/255.0 blue:33/255.0 alpha:1];
			break;
			
		case 8:
			return [UIColor colorWithRed:122/255.0 green:58/255.0 blue:35/255.0 alpha:1];
			break;
			
		case 9:
			return [UIColor colorWithRed:75/255.0 green:39/255.0 blue:18/255.0 alpha:1];
			break;
			
		case 10:
			return [UIColor colorWithRed:29/255.0 green:18/255.0 blue:17/255.0 alpha:1];
			break;
			
		case 11:
			return [UIColor colorWithRed:13/255.0 green:11/255.0 blue:10/255.0 alpha:1];
			break;
			
		case 12:
			return [UIColor colorWithRed:9/255.0 green:8/255.0 blue:8/255.0 alpha:1];
			break;
			
		case 13:
			return [UIColor colorWithRed:5/255.0 green:6/255.0 blue:5/255.0 alpha:1];
			break;
			
		default:
			return NULL;
	}
}


@end
