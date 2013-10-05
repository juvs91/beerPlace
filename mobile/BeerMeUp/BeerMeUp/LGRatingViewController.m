//
//  RatingViewController.m
//  RatingViewController
//
//  Created by Jesus Gonzalez on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGRatingViewController.h"

@interface LGRatingViewController (){
    NSMutableArray *images;
    double rating;
    float itemWidth;
    UIPanGestureRecognizer *panGR;
    UITapGestureRecognizer *tapGR;
}

@property UIImage *emptyImage;
@property UIImage *fullImage;
@property NSInteger numberOfItems;
@property BOOL editable;
@property BOOL rounding;
@end

@implementation LGRatingViewController
@synthesize delegate;

@synthesize emptyImage = _emptyImage;
@synthesize fullImage = _fullImage;
@synthesize numberOfItems = _numberOfItems;
@synthesize editable = _editable;
@synthesize rounding;

-(void) setEdiable:(BOOL)editable{
    _editable = editable;
    if(self.editable){
        [self addGestures];
    }else{
        [self removeGestures];
    }
}

-(void) addGestures{
    [self.view addGestureRecognizer:panGR];
    [self.view addGestureRecognizer:tapGR];
}

-(void) removeGestures{
    [self.view removeGestureRecognizer:panGR];
    [self.view removeGestureRecognizer:tapGR];
}

-(void) didPan:(UIPanGestureRecognizer *) sender{
    CGPoint position = [sender locationInView:self.view];
    
    [self setRating: position.x / self.view.frame.size.width];
}

-(void) didTap:(UITapGestureRecognizer *) sender{
    CGPoint position = [sender locationInView:self.view];
    
    [self setRating: position.x / self.view.frame.size.width];
}

-(void) awakeFromNib{
    
}

-(LGRatingViewController *) initWithEmptyImage:(UIImage *)emptyImage fullImage:(UIImage *)fullImage numberOfItems:(NSInteger) numberOfItems{
    self = [super init];
    self.fullImage = fullImage;
    self.emptyImage = emptyImage;
    self.numberOfItems = numberOfItems;
    images = [[NSMutableArray alloc] initWithCapacity:self.numberOfItems];
    panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    rounding = YES;
    return self;
}

-(void) setView:(UIView *)view{
    [super setView:view];
    [images removeAllObjects];
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewFrame = self.view.frame;
    itemWidth = viewFrame.size.height;
    float padding = ((viewFrame.size.width / self.numberOfItems) - itemWidth);
    for(int i = 0; i < self.numberOfItems; i++){
        UIImageView *image = [[UIImageView alloc] initWithImage:self.emptyImage];
        CGRect frame = self.view.frame;
        frame.size.width = itemWidth;
        frame.origin.y = 0;
        frame.origin.x = i * (itemWidth + padding) + padding / 2;
        image.frame = frame;
        [images addObject:image];
        [self.view addSubview:image];
    }
}

-(CGFloat) getRating{
	return rating;
}

-(void) setRating:(float) newRating{
    if(rounding){
        newRating = roundf(newRating * self.numberOfItems) / self.numberOfItems;
    }
    if(newRating > 1)
        newRating = 1;
    if(newRating < 0)
        newRating = 0;
    double valueForItem = 1.0 / self.numberOfItems;
    
    double fullItems = newRating / valueForItem;
    
    int iterator = 0;
    while(fullItems >= 1){
        ((UIImageView *)[images objectAtIndex:iterator]).image = self.fullImage;
        iterator ++;
        fullItems -= 1;
    }
    if(fullItems > .01){
        UIImageView *mixedImageView = [images objectAtIndex:iterator];
        CGSize fullImageSize = self.fullImage.size;
        float ccContentScaleFactor = [[UIScreen mainScreen] scale];
        fullImageSize.width *= ccContentScaleFactor;
        fullImageSize.height *= ccContentScaleFactor;
        CGSize newSize = mixedImageView.frame.size;
        
        CGRect fullPartFrame = CGRectMake(0, 0, fullImageSize.width * fullItems, fullImageSize.height);
        CGRect emptyPartFrame = CGRectMake(fullPartFrame.size.width, 0, fullImageSize.width - fullPartFrame.size.width, fullImageSize.height);
        
        CGRect fullPartNewFrame = CGRectMake(0, 0, newSize.width * fullItems, newSize.height);
        CGRect emptyPartNewFrame = CGRectMake(fullPartNewFrame.size.width, 0, newSize.width - fullPartNewFrame.size.width, newSize.height);
        
        CGImageRef cgFullImage = CGImageCreateWithImageInRect(self.fullImage.CGImage, fullPartFrame);
        UIImage *fullImagePart = [UIImage imageWithCGImage:cgFullImage];
        
        
        CGImageRef cgEmptyImage = CGImageCreateWithImageInRect(self.emptyImage.CGImage, emptyPartFrame);
        UIImage *emptyImagePart = [UIImage imageWithCGImage:cgEmptyImage];
        
        UIGraphicsBeginImageContext( newSize );
        
        [fullImagePart drawInRect:fullPartNewFrame];
        [emptyImagePart drawInRect:emptyPartNewFrame];
        
        mixedImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        CGImageRelease(cgFullImage);
        CGImageRelease(cgEmptyImage);
        
        iterator ++;
    }
    
    while(iterator < self.numberOfItems){
        ((UIImageView *)[images objectAtIndex:iterator]).image = self.emptyImage;
        iterator ++;
    }
    
    if([self.delegate respondsToSelector:@selector(ratingViewController:userRated:)]){
        [self.delegate ratingViewController:self userRated:newRating];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
