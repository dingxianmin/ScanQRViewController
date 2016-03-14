//
//  ViewController.m
//  ScanQRCode
//
//  Created by invoker on 16/3/14.
//  Copyright © 2016年 QQQ. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentQRViewController:(id)sender {
    ScanQRViewController *vc = [[ScanQRViewController alloc] init];
    vc.scanLine = [UIImage imageNamed:@"scan_line"];
    vc.mainColor = [UIColor colorWithRed:0.84 green:0.36 blue:0.28 alpha:1.0f];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.qrBlock = ^(ScanQRViewController *qrVC,NSString *qrCode) {
        NSLog(@"%@",qrCode);
        [qrVC dismissViewControllerAnimated:YES completion:nil];
    };
}
@end
