# ScanQRViewController

you can use ScanQRViewController like this

ScanQRViewController *vc = [[ScanQRViewController alloc] init];
vc.scanLine = [UIImage imageNamed:@"scan_line"];
vc.mainColor = [UIColor colorWithRed:0.84 green:0.36 blue:0.28 alpha:1.0f];
[self presentViewController:vc animated:YES completion:nil];

vc.qrBlock = ^(ScanQRViewController *qrVC,NSString *qrCode) {
     NSLog(@"%@",qrCode);
     [qrVC dismissViewControllerAnimated:YES completion:nil];
};