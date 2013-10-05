//
//  RatingViewController.h
//  RatingViewController
//
//  Created by Jesus Gonzalez on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGRatingViewController;

@protocol RatingViewDelegate <NSObject>

@optional
-(void) ratingViewController:(LGRatingViewController *) ratingViewController userRated:(double)rating; 

@end

@interface LGRatingViewController : UIViewController
@property (weak, nonatomic) id<RatingViewDelegate> delegate;


-(LGRatingViewController *) initWithEmptyImage:(UIImage *)fullImage fullImage:(UIImage *)emptyImage numberOfItems:(NSInteger) numberOfItems;

-(void) setRating:(float) newRating;
-(CGFloat) getRating;
-(void) setEdiable:(BOOL) editable;
-(void) setRounding:(BOOL) roundinng;
@end
