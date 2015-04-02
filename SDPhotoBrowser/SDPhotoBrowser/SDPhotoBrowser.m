//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import "ImgScrollView.h"

 
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@implementation SDPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)setupToolbars
{
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor clearColor];
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    _indexLabel = indexLabel;
    [self addSubview:indexLabel];
    
//    // 2.保存按钮
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
//    saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
//    saveButton.layer.cornerRadius = 5;
//    saveButton.clipsToBounds = YES;
//    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    _saveButton = saveButton;
//    [self addSubview:saveButton];
}

//#pragma mark - 保存照片
//
//- (void)saveImage
//{
//    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
//    UIImageView *currentImageView = _scrollView.subviews[index];
//    
//    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
//    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//    indicator.center = self.center;
//    _indicatorView = indicator;
//    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
//    [indicator startAnimating];
//}
//
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
//{
//    [_indicatorView removeFromSuperview];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
//    label.layer.cornerRadius = 5;
//    label.clipsToBounds = YES;
//    label.bounds = CGRectMake(0, 0, 150, 30);
//    label.center = self.center;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont boldSystemFontOfSize:17];
//    [[UIApplication sharedApplication].keyWindow addSubview:label];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
//    if (error) {
//        label.text = SDPhotoBrowserSaveImageFailText;
//    }   else {
//        label.text = SDPhotoBrowserSaveImageSuccessText;
//    }
//    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
//}

#pragma - 配置图片

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounds = self.bounds;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    for (int i = 0; i < self.imageCount; i++) {
//        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
//        imageView.tag = i;
//        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
//        [_scrollView addSubview:imageView];
        ImgScrollView *imageView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*_scrollView.bounds.size.width,0,_scrollView.bounds.size}];
        imageView.tag = i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)]];
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    ImgScrollView *imageView = _scrollView.subviews[index];
    if (imageView.hasLoadedImage) return;
//    if ([self highQualityImageURLForIndex:index]) {
//        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
//    } else {
//        imageView.image = [self placeholderImageForIndex:index];
//    }
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self];
    [imageView setContentWithFrame:convertRect];
    [imageView setImageWithURL:[self highQualityImageURLForIndex:index] Image:[self placeholderImageForIndex:index]];
    [imageView setAnimationRect];
    
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    
    ImgScrollView *currentImageView = (ImgScrollView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = currentImageView.placeHolderImage;
    CGFloat h = (self.bounds.size.width / currentImageView.placeHolderImage.size.width) * currentImageView.placeHolderImage.size.height;
    
    if (!currentImageView.placeHolderImage) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];

    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = SDPhotoBrowserImageViewMargin;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height - SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    _scrollView.pagingEnabled = YES;
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)showFirstImage
{
    
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    ImgScrollView *imageView = _scrollView.subviews[self.currentImageIndex];
    CGRect targetTemp = [imageView setAnimationRect];
    
    tempView.frame = rect;
    tempView.contentMode = [imageView contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动100后清除缩放
//    CGFloat margin = 100.0;
//    CGFloat x = scrollView.contentOffset.x;
//    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
//        ImgScrollView *imageView = _scrollView.subviews[index];
//        if (imageView.isScaled) {
//            [UIView animateWithDuration:0.5 animations:^{
//                imageView.transform = CGAffineTransformIdentity;
//            } completion:^(BOOL finished) {
//                [imageView eliminateScale];
//            }];
//        }
//        [imageView rechangeInitRdct];
//    }

    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    [self setupImageOfImageViewForIndex:index];
    
}



@end
