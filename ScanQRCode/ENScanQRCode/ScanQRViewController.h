//
//  ScanQRViewController.h
//  RootViewController
//
//  Created by invoker on 16/3/9.
//  Copyright © 2016年 QQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanQRView.h"

@class ScanQRViewController;
typedef void(^ScanQRViewBlock)(ScanQRViewController *qrViewController, NSString *qrCode);

@interface ScanQRViewController : UIViewController

/**
 * qrBlock扫描返回结果 自身实例,和扫描的二维码
 */
@property (nonatomic ,copy) ScanQRViewBlock qrBlock;
#warning coder need set up scanLine && mainColor
@property (nonatomic ,strong) UIImage *scanLine;
@property (nonatomic ,strong) UIColor *mainColor;
@end