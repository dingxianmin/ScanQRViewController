//
//  ScanQRView.h
//  RootViewController
//
//  Created by invoker on 16/3/9.
//  Copyright © 2016年 QQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanQRView : UIView

/**
 * 扫描控件的范围
 */
@property (nonatomic, assign) CGFloat scanRegionSize;

/**
 * 扫描控件下方的文本
 */
@property (nonatomic, strong) NSString *contentText;

/**
 * 扫描线条图片
 */
@property (nonatomic, strong) UIImage *scanImage;

/**
 * 主色调
 */
@property (nonatomic, strong) UIColor *mainColor;

/**
 * Create a new qrView
 */
+ (instancetype)qrView;

/**
 * QRView drawRect and create controls
 */
- (void)initSubViews;

/**
 * QRView to prepare scan
 */
- (void)qrViewInitializationAnimation;

/**
 * QRView ready go scan
 */
- (void)qrViewComplete;

/**
 * QRView scan ing....
 */
- (void)starScanAnimation;

/**
 * QRView scan d....
 */
- (void)stopScanAnimation;
@end