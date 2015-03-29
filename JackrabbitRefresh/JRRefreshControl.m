//
//  JRRefreshControl.m
//  JackrabbitRefresh
//
//  Created by Jack_iMac on 15/3/29.
//  Copyright (c) 2015年 Jackrabbit Mobile. All rights reserved.
//

#import "JRRefreshControl.h"

@interface JRRefreshControl ()

@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation JRRefreshControl

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = [[UIView alloc] initWithFrame:self.bounds];
        self.refreshLoadingView.backgroundColor = [UIColor clearColor];
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = [[UIView alloc] initWithFrame:self.bounds];
        self.refreshColorView.backgroundColor = [UIColor clearColor];
        self.refreshColorView.alpha = 0.30;
        
        // Create the graphic image views
        self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_background.png"]];
        self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_spinner.png"]];
        
        // Add the graphics to the loading view
        [self.refreshLoadingView addSubview:self.compass_background];
        [self.refreshLoadingView addSubview:self.compass_spinner];
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = YES;
        
        // Hide the original spinner icon
        self.tintColor = [UIColor clearColor];
        
        // Add the loading and colors views to our refresh control
        [self addSubview:self.refreshColorView];
        [self addSubview:self.refreshLoadingView];
        
        // Initalize flags
        self.isRefreshIconsOverlap = NO;
        self.isRefreshAnimating = NO;
    }
    return self;
}

#pragma mark - Private Methods

- (void)animateRefreshView
{
    // Background color to loop through for our color view
    NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor magentaColor]];
    static int colorIndex = 0;
    
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                         [self.compass_spinner setTransform:CGAffineTransformRotate(self.compass_spinner.transform, M_PI_2)];
                         
                         // Change the background color
                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                         // If still refreshing, keep spinning, else reset
                         if (self.isRefreshing) {
                             [self animateRefreshView];
                         }else{
                             [self resetAnimation];
                         }
                     }];
}

- (void)resetAnimation
{
    // Reset our flags and background color
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}

- (void)endRefreshing {
    [super endRefreshing];
    [self animateRefreshView];
}

#pragma mark - Public Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.tableView.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassHeightHalf = compassHeight / 2.0;
    
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
    
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
    CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    // When the compass and spinner overlap, keep them together
    if (fabsf(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.isRefreshing) {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
    }
    
    // Set the graphic's frames
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    // If we're refreshing and the animation is not playing, then play the animation
    if (self.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
    
    DLog(@"pullDistance: %.1f, pullRatio: %.1f, midX: %.1f, isRefreshing: %i", pullDistance, pullRatio, midX, self.isRefreshing);
}

@end
