//
//  ScanQRViewController.m
//  RootViewController
//
//  Created by invoker on 16/3/9.
//  Copyright © 2016年 QQQ. All rights reserved.
//

#import "ScanQRViewController.h"

@interface ScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (strong, nonatomic) ScanQRView *qrView;

@end

@implementation ScanQRViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self _configScanCarema];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_viewDisappear) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_viewDidappear) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _viewDisappear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _viewDidappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - configScanCarema
- (void)_configScanCarema {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    self.qrView = [ScanQRView qrView];
    self.qrView.scanImage = self.scanLine;
    self.qrView.mainColor = self.mainColor;
    [self.qrView initSubViews];
    [self.view addSubview:self.qrView];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - self.qrView.scanRegionSize) / 2,
                                 (screenHeight - self.qrView.scanRegionSize) / 2 - 64,
                                 self.qrView.scanRegionSize,
                                 self.qrView.scanRegionSize);
    
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}


#pragma mark - Notification 
- (void)_viewDisappear {
    [self.qrView qrViewInitializationAnimation];
}

- (void)_viewDidappear {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.qrView qrViewComplete];
        [weakSelf.session startRunning];
    });
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue = @"";
    if ([metadataObjects count] >0) {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects firstObject];
        stringValue = metadataObject.stringValue;
    }
    
    if (self.qrBlock) {
        self.qrBlock(self,stringValue);
    }
}

@end