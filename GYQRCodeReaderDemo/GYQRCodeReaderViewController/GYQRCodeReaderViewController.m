//
//  GYQRCodeReaderViewController.m
//  Demo_Bar
//
//  Created by Syousoft on 15/11/25.
//  Copyright (c) 2015年 Syousoft. All rights reserved.
//

#import "GYQRCodeReaderViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface GYQRCodeReaderViewController ()<AVCaptureMetadataOutputObjectsDelegate,GYQRCodeReaderDelegate>//用于处理采集信息的代理
{
    NSTimer *_timer;
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_layer;
    CGFloat _height;
    CGFloat _width;
    CGFloat _heightOfScanBox;
    
    UIImageView *_scanImageView;
    UIImageView *_lineImageView;
}
@end

@implementation GYQRCodeReaderViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed=YES;
        
    }
    return self;
}
-(instancetype)initWithHeight:(CGFloat)height withWidth:(CGFloat)width withHeightFromScanBoxToTop:(CGFloat)heightOfScanBox
{
    if((self = [super init]))
    {
        _height = height;
        _width = width;
        _heightOfScanBox = heightOfScanBox;
        
        _backgroundView=[[SYHoleView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
        
        [_backgroundView setHoldRect:CGRectMake((ScreenWidth-_width)/2, _heightOfScanBox, _width, _height)];
        _scanImageView  = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-_width)/2, _heightOfScanBox, _width, _height)];
        _lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-_width)/2, _heightOfScanBox+10+5, _width, 2)];
        
        [self.view addSubview:_backgroundView];
        [self.view addSubview:_scanImageView];
        [self.view addSubview:_lineImageView];
        
        //获取摄像设备
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        //创建输出流
        _output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        [_output setRectOfInterest:CGRectMake((heightOfScanBox-10)/ScreenHeight,((ScreenWidth-width-10)/2)/ScreenWidth,(height+10)/ScreenHeight,(width+10)/ScreenWidth)];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];//输入输出的中间桥梁
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:_input];
        [_session addOutput:_output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//        _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        _layer.frame=self.view.layer.bounds;
        [self.view.layer insertSublayer:_layer atIndex:0];
        //        开始捕获
        [_session startRunning];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    if (_session)
    {
        [_session stopRunning];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //刷新
    if (_timer==nil)
    {
        _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    }
    if (_session)
    {
        [_session startRunning];
    }
}
-(void)animationLine{
    [UIView animateWithDuration:2 animations:^{
        _lineImageView.frame = CGRectMake((ScreenWidth-_width)/2, _heightOfScanBox+10+_height-20-5, _width, 2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            _lineImageView.frame = CGRectMake((ScreenWidth-_width)/2, _heightOfScanBox+10+5, _width, 2);
        }];
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        //        NSLog(@"______%@",metadataObject.stringValue);
        
        if (_delegate && [_delegate respondsToSelector:@selector(didOutputMetadataObjectString:)])
        {
            [_delegate didOutputMetadataObjectString:metadataObject.stringValue];
        }
    }
}

#pragma mark ---SYQRCodeScanningDelegate----
-(void)didOutputMetadataObjectString:(NSString *)metadataObjectString{
    
}


-(void)setMetadataObjectTypes:(NSArray*)types{
    [_output setMetadataObjectTypes:types];
}
-(void)setBackgroundColor:(UIColor *)color{
    [_backgroundView setBackgroundColor:color];
}
-(void)setScanImageView:(UIImage*)image{
    [_scanImageView setImage:image];
    
}
-(void)setLineImageView:(UIImage*)image{
    [_lineImageView setImage:image];
}

-(void)pauseTimer{
    if (![_timer isValid]){
        return ;
    }
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)startTimer{
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate date]];
}
-(void)sessionStartRunning{
    [_session startRunning];
}
-(void)sessionStopRunning{
    [_session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
