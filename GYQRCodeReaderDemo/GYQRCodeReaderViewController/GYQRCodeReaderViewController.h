//
//  GYQRCodeReaderViewController.h
//  Demo_Bar
//
//  Created by Syousoft on 15/11/25.
//  Copyright (c) 2015年 Syousoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SYHoleView.h"
@class GYQRCodeReaderViewController;
@protocol GYQRCodeReaderDelegate <NSObject>
-(void)didOutputMetadataObjectString:(NSString *)metadataObjectString;

@end

@interface GYQRCodeReaderViewController : UIViewController
{
    SYHoleView *_backgroundView;
}

//依次扫描框长，宽，距顶部高度。
-(instancetype)initWithHeight:(CGFloat)height withWidth:(CGFloat)width withHeightFromScanBoxToTop:(CGFloat)height;

@property (nonatomic,weak)id<GYQRCodeReaderDelegate>delegate;

-(void)setMetadataObjectTypes:(NSArray*)types;//设置扫码支持的编码格式
-(void)setBackgroundColor:(UIColor *)color;//阴影背景色
-(void)setScanImageView:(UIImage*)image;//扫描框
-(void)setLineImageView:(UIImage*)image;//扫描光

-(void)pauseTimer;
-(void)startTimer;
-(void)sessionStartRunning;
-(void)sessionStopRunning;
@end
