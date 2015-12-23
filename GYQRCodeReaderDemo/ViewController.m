//
//  ViewController.m
//  GYQRCodeReaderDemo
//
//  Created by Syousoft on 15/12/23.
//  Copyright © 2015年 Syousoft. All rights reserved.
//

#import "ViewController.h"
#import "GYQRCodeReaderViewController.h"
#import "UIColor+Hex.h"

@interface ViewController ()<GYQRCodeReaderDelegate>
{
    GYQRCodeReaderViewController *_reader;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _reader = [[GYQRCodeReaderViewController alloc]initWithHeight:220 withWidth:220 withHeightFromScanBoxToTop:75];
    _reader.delegate = self;
    
    [_reader setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [_reader setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
    [_reader setScanImageView:[UIImage imageNamed:@"scanningBox"]];
    [_reader setLineImageView:[UIImage imageNamed:@"light"]];
    
}

#pragma mark ---SYQRCodeScanningDelegate----
-(void)didOutputMetadataObjectString:(NSString *)metadataObjectString{
    if (metadataObjectString) {
        NSLog(@"______扫描结果：%@",metadataObjectString);
        [_reader sessionStopRunning];
        [_reader pauseTimer];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)scanBtnClick:(id)sender {
    [self presentViewController:_reader animated:YES completion:^{}];
    
}
@end
