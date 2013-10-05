//
//  Beer.h
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 05/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beer : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSNumber *color;
@property (strong, nonatomic) NSNumber *averageRating;


- (Beer *) initWithName:(NSString *)name location:(NSString *)location color:(NSNumber *)color averageRating:(NSNumber *)averageRating;

+(UIColor *)colorForColorScaleValue:(NSInteger)scaleValue;

@end
