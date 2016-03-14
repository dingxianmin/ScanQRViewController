//
//  ScanQRView.m
//  RootViewController
//
//  Created by invoker on 16/3/9.
//  Copyright © 2016年 QQQ. All rights reserved.
//

#import "ScanQRView.h"

@interface ScanQRView () {
    /**
     * 扫描下方文案
     */
    UILabel *_contentLabel;

    /**
     * 扫描动画线条
     */
    UIImageView *_scanLine;
    
    /**
     * 初始化的背景
     */
    UIView *_initializationAnimationView;
    /**
     * 初始化菊花控件
     */
    UIActivityIndicatorView *_initializationActivityIndicatorView;
    
    /**
     * 初始化文案Label
     */
    UILabel *_initializationLabel;
}

@end

@implementation ScanQRView

+ (instancetype)qrView {
    ScanQRView *qrView = [[ScanQRView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    qrView.backgroundColor = [UIColor clearColor];
    return qrView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([[UIScreen mainScreen] currentMode].size.height == 1334 || [[UIScreen mainScreen] currentMode].size.height == 2208) {
            self.scanRegionSize = 300.f;
        } else {
            self.scanRegionSize = 250.f;
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    static float cornerWidth = 1.6;
    static float cornerLength = 15.0;
    //扫描背景区域
    CGRect scanBackRect =CGRectMake( 0, 0,
                                    [UIScreen mainScreen].bounds.size.width,
                                    [UIScreen mainScreen].bounds.size.height
                                    );
    
    //扫描框区域
    CGRect scanRect = CGRectMake(
                                      (scanBackRect.size.width - self.scanRegionSize)/2,
                                      (scanBackRect.size.height - self.scanRegionSize)/2,
                                      self.scanRegionSize,
                                      self.scanRegionSize
                                      );
    
    //扫描控件背景设置透明黑色
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contex, 0.12, 0.12, 0.12, 0.6);
    CGContextFillRect(contex, scanBackRect);
    //扫描控件镂空透明
    CGContextClearRect(contex, scanRect);
    //设置四个边角约束
    CGContextSetLineWidth(contex, cornerWidth);
    CGContextSetStrokeColorWithColor(contex, [self.mainColor CGColor]);
    CGPoint leftTopLine[] = {
        CGPointMake(scanRect.origin.x + cornerWidth/2, scanRect.origin.y),
        CGPointMake(scanRect.origin.x + cornerWidth/2, scanRect.origin.y + cornerLength)
    };
    CGContextAddLines(contex, leftTopLine, 2);
    
    CGPoint leftTopRow[] = {
        CGPointMake(scanRect.origin.x, scanRect.origin.y + cornerWidth/2),
        CGPointMake(scanRect.origin.x + cornerLength, scanRect.origin.y + cornerWidth/2)
    };
    CGContextAddLines(contex, leftTopRow, 2);
    
    CGPoint leftBottomLine[] = {
        CGPointMake(scanRect.origin.x + cornerWidth/2, scanRect.origin.y + scanRect.size.height - cornerLength),
        CGPointMake(scanRect.origin.x + cornerWidth/2, scanRect.origin.y + scanRect.size.height)
    };
    CGContextAddLines(contex, leftBottomLine, 2);
    
    CGPoint leftBottomRow[] = {
        CGPointMake(scanRect.origin.x , scanRect.origin.y + scanRect.size.height - cornerWidth/2) ,
        CGPointMake(scanRect.origin.x + cornerWidth/2 +cornerLength, scanRect.origin.y + scanRect.size.height - cornerWidth/2)
    };
    CGContextAddLines(contex, leftBottomRow, 2);
    
    CGPoint rightTopLine[] = {
        CGPointMake(scanRect.origin.x + scanRect.size.width - cornerLength, scanRect.origin.y + cornerWidth/2),
        CGPointMake(scanRect.origin.x + scanRect.size.width, scanRect.origin.y + cornerWidth/2 )
    };
    CGContextAddLines(contex, rightTopLine, 2);
    
    CGPoint rightTopRow[] = {
        CGPointMake(scanRect.origin.x + scanRect.size.width - cornerWidth/2, scanRect.origin.y),
        CGPointMake(scanRect.origin.x + scanRect.size.width - cornerWidth/2, scanRect.origin.y + cornerLength + cornerWidth/2 )
    };
    CGContextAddLines(contex, rightTopRow, 2);
    
    CGPoint rightBottomLine[] = {
        CGPointMake(scanRect.origin.x + scanRect.size.width - cornerWidth/2 , scanRect.origin.y + scanRect.size.height - cornerLength),
        CGPointMake(scanRect.origin.x - cornerWidth/2 + scanRect.size.width, scanRect.origin.y + scanRect.size.height)
    };
    CGContextAddLines(contex, rightBottomLine, 2);
    
    CGPoint rightBottomRow[] = {
        CGPointMake(scanRect.origin.x + scanRect.size.width - cornerLength , scanRect.origin.y + scanRect.size.height - cornerWidth/2),
        CGPointMake(scanRect.origin.x + scanRect.size.width, scanRect.origin.y + scanRect.size.height - cornerWidth/2)
    };
    CGContextAddLines(contex, rightBottomRow, 2);

    CGContextStrokePath(contex);
}

- (void)initSubViews {
    
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(
                                                             0,
                                                             screenSize.height / 2 + self.scanRegionSize / 2 + 20,
                                                             self.bounds.size.width,
                                                             20)];
    
    [_contentLabel setTextAlignment:NSTextAlignmentCenter];
    [_contentLabel setTextColor:[UIColor whiteColor]];
    [_contentLabel setFont:[UIFont systemFontOfSize:14]];
    [_contentLabel setText:self.contentText ?:@"将二维码放入扫描框内 即可自动扫描"];
    [self addSubview:_contentLabel];
    
    _scanLine  = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                               self.bounds.size.width / 2 - self.scanRegionSize / 2,
                                                               self.bounds.size.height / 2 - self.scanRegionSize / 2,
                                                               self.scanRegionSize,
                                                               2)];
    
    _scanLine.layer.masksToBounds = YES;
    _scanLine.image = self.scanImage;
    _scanLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_scanLine];
    [self bringSubviewToFront:_scanLine];
    
    
    _initializationAnimationView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _initializationAnimationView.backgroundColor = [UIColor colorWithRed:0.16 green:0.18 blue:0.2 alpha:1.f];
    
    _initializationActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _initializationActivityIndicatorView.center = CGPointMake(
                                                              screenSize.width / 2,
                                                              screenSize.height / 2);
    
    [_initializationAnimationView addSubview:_initializationActivityIndicatorView];
    [_initializationActivityIndicatorView startAnimating];
    
    _initializationLabel = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                    0,
                                                                    screenSize.height / 2 + 30,
                                                                    self.bounds.size.width,
                                                                    20)];
    
    [_initializationLabel setTextAlignment:NSTextAlignmentCenter];
    [_initializationLabel setTextColor:[UIColor whiteColor]];
    [_initializationLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [_initializationLabel setText:@"正在加载..."];
    [_initializationAnimationView addSubview:_initializationLabel];
    
    [self addSubview:_initializationAnimationView];
    [self bringSubviewToFront:_initializationAnimationView];
    [self qrViewInitializationAnimation];
}

// qrView Initialization
- (void)qrViewInitializationAnimation {
    _initializationAnimationView.hidden = NO;
    [_initializationActivityIndicatorView startAnimating];
    [self stopScanAnimation];
}

- (void)qrViewComplete {
    [UIView animateWithDuration:0.2 animations:^{
        _initializationAnimationView.alpha = 0.1;
    } completion:^(BOOL finished) {
        _initializationAnimationView.alpha = 1.0;
        _initializationAnimationView.hidden = YES;
        [_initializationActivityIndicatorView stopAnimating];
        [self starScanAnimation];
    }];
}

- (void)starScanAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3.0;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - self.scanRegionSize /2)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + self.scanRegionSize / 2 - 2)];
    animation.repeatCount = HUGE_VALF;
    [_scanLine.layer addAnimation:animation forKey:@"animation"];
}

- (void)stopScanAnimation {
    if (_scanLine.layer.animationKeys.count > 0) {
        [_scanLine.layer removeAllAnimations];
    }
    _scanLine.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - self.scanRegionSize /2);
}
@end