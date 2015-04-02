//
//  ImgScrollView.h
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender;

@end

@interface ImgScrollView : UIScrollView

@property (weak) id<ImgScrollViewDelegate> i_delegate;
@property (nonatomic,retain)UIImage *placeHolderImage;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImageWithURL:(NSURL *)url Image:(UIImage *) image;
- (CGRect) setAnimationRect;
- (void) rechangeInitRdct;

@end
