//
//  ZJSinWaveView.m
//  OC_Project
//
//  Created by 小黎 on 2018/11/23.
//  Copyright © 2018年 ZJ. All rights reserved.
//

#import "ZJSinWaveView.h"

@interface ZJSinWaveView ()
{
    CGFloat waveA;//水纹振幅
    CGFloat waveW ;//水纹周期
    CGFloat offsetX; //位移
    CGFloat currentK; //当前波浪高度Y
    CGFloat wavesSpeed;//水纹速度
    CGFloat WavesWidth; //水纹宽度
}
@property (nonatomic,strong)CADisplayLink * wavesDisplayLink;
@property (nonatomic,strong)CAShapeLayer  * sinLayer;
@property (nonatomic,strong)UIColor       * layerColor;
@end
/*
 y =Asin（ωx+φ）+C
 A表示振幅，也就是使用这个变量来调整波浪的高度
 ω表示周期，也就是使用这个变量来调整在屏幕内显示的波浪的数量
 φ表示波浪横向的偏移，也就是使用这个变量来调整波浪的流动
 C表示波浪纵向的位置，也就是使用这个变量来调整波浪在屏幕中竖直的位置。
 */
@implementation ZJSinWaveView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        
        [self setUpSinWaves];
    }
    return self;
}
- (CAShapeLayer *)sinLayer{
    if(_sinLayer==nil){
        _sinLayer = [CAShapeLayer new];
    }
    return _sinLayer;
}
- (void)setUpSinWaves{
    //设置波浪的宽度
    WavesWidth = self.frame.size.width;
    //设置波浪的速度
    wavesSpeed = 0.2/M_PI;
    //设置振幅 最大峰值
    waveA = 6;
    //设置波浪纵向位置 上加下减
    currentK = self.frame.size.height-waveA*2.0;
    //设置周期 周期越长屏幕显示的波纹就越多
    waveW = 0.025;
    
    [self.sinLayer setFillColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.2] CGColor]];
    [[self layer] addSublayer:self.sinLayer];

    //启动定时器
    self.wavesDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [self.wavesDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)getCurrentWave:(CADisplayLink *)displayLink{
    //实时的位移
    offsetX += wavesSpeed;
    [self setCurrentFirstWaveLayerPath];
}
-(void)setCurrentFirstWaveLayerPath{
    
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (NSInteger i =0.0f; i<=WavesWidth; i++) {
        //正弦函数波浪公式
        y = waveA * sin(waveW * i+ offsetX)+currentK;
        //将点连成线
        CGPathAddLineToPoint(path, nil, i, y);
    }
    CGPathAddLineToPoint(path, nil, WavesWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    
    CGPathCloseSubpath(path);
    [self.sinLayer setPath:path] ;
    
    //使用layer 而没用CurrentContext
    CGPathRelease(path);
}
@end
