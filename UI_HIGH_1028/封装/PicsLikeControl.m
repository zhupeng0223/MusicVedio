//
//  PicLikeControl.m
//  PicsLikeControl
//
//  Created by Tu You on 13-12-27.
//  Copyright (c) 2013年 Tu You. All rights reserved.
//

#import "PicsLikeControl.h"
#import "MusicTool.h"
#define kMaxToggleLength        (25)
#define kMaxDragLength    (50)

@interface PicsLikeControl ()

@property (nonatomic, strong) NSArray *multiImages;

@property (nonatomic, strong) NSArray *couple;

@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) int frontIndex;
@property (nonatomic, assign) BOOL flipped;
@property (nonatomic, assign) CGPoint startPoint;



@end

@implementation PicsLikeControl

- (id)initWithFrame:(CGRect)frame frontImage:(UIImage *)frontImage behindImage:(UIImage *)behindImage
{
    return [self initWithFrame:frame multiImages:@[frontImage, behindImage]];
}

- (id)initWithFrame:(CGRect)frame multiImages:(NSArray *)multiImages
{
    if ([super initWithFrame:frame])
    {
        self.multiImages = multiImages;
        
        self.frontIndex = 0;
        self.currentImageIndex = 0;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *a = [[UIImageView alloc] initWithFrame:self.bounds];
        a.backgroundColor = [UIColor whiteColor];
        a.layer.cornerRadius = frame.size.width / 2;
        a.layer.masksToBounds = YES;
        UIImageView *b = [[UIImageView alloc] initWithFrame:self.bounds];
        b.backgroundColor = [UIColor whiteColor];
        b.layer.cornerRadius = frame.size.width / 2;
        b.layer.masksToBounds = YES;
        self.couple = @[a, b];
        
        a.userInteractionEnabled = YES;
        b.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer *aPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(aPanned:)];
        aPanGesture.delegate = self;
        [a addGestureRecognizer:aPanGesture];
        
        UIPanGestureRecognizer *bPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bPanned:)];
        bPanGesture.delegate = self;
        [b addGestureRecognizer:bPanGesture];
        
        UITapGestureRecognizer *aTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapped:)];
        [a addGestureRecognizer:aTapGesture];
        
        UITapGestureRecognizer *bTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bTapped:)];
        [b addGestureRecognizer:bTapGesture];
        
        [self addSubview:b];
        [self addSubview:a];
        
        [self setMultiImageViews];
    }
    return self;
}

- (void)setMultiImageViews
{
    UIImageView *frontView = self.couple[_frontIndex];
    frontView.image = self.multiImages[_currentImageIndex];
    int frontIndexIncreased = [self indexByIncreasingFontIndex];
    UIImageView *behindView = self.couple[frontIndexIncreased];
    int currentImageIndexIncreased = [self indexByIncreaingCurrentImageIndex];
    behindView.image = self.multiImages[currentImageIndexIncreased];
    
    [self addSubview:frontView];
    [self addSubview:behindView];
//    if ([MusicTool sharedMusicTool].isPlaying) {
//        self.clearButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        self.clearButton.frame = CGRectMake(0, 0, 44, 44);
//        [behindView addSubview:self.clearButton];
//        [self.clearButton addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
//    }
}

//- (void)clickButton:(UIButton *)button {
//    [self makeRotateAnimal];
//}

//- (void)makeRotateAnimal {
//     UIImageView *frontView = self.couple[_frontIndex];
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        frontView.transform = CGAffineTransformRotate(frontView.transform, M_PI_2);
//    } completion:^(BOOL finished) {
//        [self makeRotateAnimal];
//    }];
//    
//}


- (void)increaseIndex
{
    self.frontIndex = [self indexByIncreasingFontIndex];
    
    self.currentImageIndex = [self indexByIncreaingCurrentImageIndex];
}

- (int)indexByIncreasingFontIndex
{
    int index = (self.frontIndex == 1) ? 0 : 1;
    return index;
}

- (int)indexByIncreaingCurrentImageIndex
{
    int index = (self.currentImageIndex + 1 < self.multiImages.count) ? (self.currentImageIndex + 1) : 0;
    return index;
}

- (void)aTapped:(UITapGestureRecognizer *)tapGesture
{
    [self tapped:tapGesture];
}

- (void)bTapped:(UITapGestureRecognizer *)tapGesture
{
    [self tapped:tapGesture];
}

- (void)tapped:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(controlTappedAtIndex:)])
    {

        [self.delegate controlTappedAtIndex:self.currentImageIndex];
    }
}






- (void)aPanned:(UIPanGestureRecognizer *)panGesture
{
    [self panned:panGesture];
}

- (void)bPanned:(UIPanGestureRecognizer *)panGesture
{
    [self panned:panGesture];
}

- (void)panned:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        _startPoint = panGesture.view.center;
        _flipped = NO;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGesture translationInView:self];

        UIView *pannedView = panGesture.view;
        
        CGFloat distance = sqrtf(point.x * point.x + point.y * point.y);
        
        // control the position of the panned view
        if (distance < kMaxDragLength)
        {
            // move the current selected view with the touched point
            pannedView.center = CGPointMake(_startPoint.x + point.x, _startPoint.y + point.y);
        }
        else
        {
            float x = (point.x / distance) * kMaxDragLength;
            float y = (point.y / distance) * kMaxDragLength;
            
            pannedView.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
        }
        
        // control the postition of the other view
        // if distance reach the threshold, bring the view behind to front and animate
        if (distance > kMaxToggleLength && !_flipped)
        {
            _flipped = YES;
            
            [self increaseIndex];
            
            UIView *frontView = self.couple[_frontIndex];
            [self bringViewToFrontAnimate:frontView];
            
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        // release the panned view and animate
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             panGesture.view.center = _startPoint;
                         }
                         completion:^(BOOL finished) {
                             [self setMultiImageViews];
                         }];
    }
}

// bring the view behind to front and animate
- (void)bringViewToFrontAnimate:(UIView *)view
{
    [self bringSubviewToFront:view];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
    }];
}

@end
