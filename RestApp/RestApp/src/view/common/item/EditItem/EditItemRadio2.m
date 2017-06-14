//
//  EditItemRatio2.m
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemRadio2.h"
#import "SystemUtil.h"
#import "ColorHelper.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"

@implementation EditItemRadio2
@synthesize view;

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [[NSBundle mainBundle] loadNibNamed:@"EditItemRadio2" owner:self options:nil];
//    [self addSubview:self.view];
//    self.lblDetail.text=@"";
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initmainView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initmainView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initmainView];
    }
    return self;
}

- (void)initmainView {
    
    self.lblDetail.text=@"";

    [self addSubview:self.view];
    if (![self viewWithTag:2000]) {
        self.lblTip = [[UILabel alloc] init];
        self.lblTip.frame = CGRectMake(10, 0, 42, 21);
        self.lblTip.font = [UIFont systemFontOfSize:10];
        self.lblTip.tag = 2000;
    }
    [self addSubview:self.lblTip];
    [self.view addSubview:self.lblName];
    [self.view addSubview:self.lblDetail];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 61)];
    [btn addTarget:self action:@selector(btnRatioClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view addSubview:self.line];
    [self.view addSubview:self.imgOff];
    [self.view addSubview:self.imgOn];
}

- (UIView *)view {

    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    }
    return view;
}

- (UILabel *)lblName {

    if (!_lblName) {
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, SCREEN_WIDTH-60, 21)];
        _lblName.text = NSLocalizedString(@"界面语言", nil);
        _lblName.font = [UIFont boldSystemFontOfSize:17];
        _lblName.textAlignment = NSTextAlignmentCenter;
    }
    return _lblName;
}

- (UITextView *)lblDetail {

    if (!_lblDetail) {
        _lblDetail = [[UITextView alloc]initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-20, 26)];
        _lblDetail.font = [UIFont systemFontOfSize:13];
        _lblDetail.backgroundColor = [UIColor clearColor];
        _lblDetail.userInteractionEnabled = NO;
        _lblDetail.textColor = [UIColor lightGrayColor];
    }
    return _lblDetail;
}

- (UIView *)line {

    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(10, 72, SCREEN_WIDTH-20, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _line;
}

- (UIImageView *)imgOff {

    if (!_imgOff) {
        _imgOff = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 51, 40)];
        _imgOff.image = [UIImage imageNamed:@"ico_switch_off.png"];
    }
    return _imgOff;
}

- (UIImageView *)imgOn {

    if (!_imgOn) {
        _imgOn = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 51, 40)];
        _imgOn.image = [UIImage imageNamed:@"ico_switch_on.png"];
    }
    return _imgOn;
}



#pragma  initHit.
- (void)initHit:(NSString *)_hit
{
    self.lblDetail.text=nil;
    [self.lblDetail setWidth:SCREEN_WIDTH -20];
    self.lblDetail.text=_hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if([NSString isBlank:_hit]){
        [self.lblDetail setHeight:0];
        [self.line setTop:60];
    }else{
        [self.lblDetail sizeToFit];
        [self.line setTop:(self.lblDetail.top+self.lblDetail.height+2)];
    }
    
    [self.view setHeight:[self getHeight]];
    [self setHeight:[self getHeight]];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit delegate:(id<IEditItemRadioEvent>)delegate
{
    self.delegate=delegate;
    [self initLabel:label withHit:_hit];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit
{
    self.lblName.text=label;
    [self initHit:_hit];
}

- (float)getHeight{
    return self.line.top+self.line.height+1;
}

#pragma initUI
- (void)initLabel:(NSString *)label withVal:(NSString*)data
{
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    [self changeLabel:label withVal:data];
}

- (void)initShortData:(short)shortVal
{
    NSString* val= [NSString stringWithFormat:@"%d",shortVal];
    [self initData:val];
}

- (void)initData:(NSString*)data
{
    self.oldVal=([NSString isBlank:data]) ? @"" :data;
    [self changeData:data];
}

#pragma  ui is changing.
- (void)changeLabel:(NSString*)label withVal:(NSString*)data
{
    self.lblName.text=([NSString isBlank:label]) ? @"" :label;
    [self changeData:data];
}

- (void)changeData:(NSString*)data
{
    self.currentVal=([NSString isBlank:data]) ? @"" :data;
    BOOL result=[self.currentVal isEqualToString:@"1"];
    [self.lblName setTextColor:result?[ColorHelper getBlueColor]:[ColorHelper getRedColor]];
    self.imgOff.hidden=result;
    self.imgOn.hidden=!result;
    [self changeStatus];
    
}


#pragma data
- (BOOL)getVal
{
    return [self.currentVal isEqualToString:@"1"];
}

- (NSString*)getStrVal
{
    return self.currentVal;
}

- (IBAction)btnRatioClick:(id)sender
{
    [SystemUtil hideKeyboard];
    NSString* val=@"1";
    if ([self.currentVal isEqualToString:@"1"]) {
        val=@"0";
    }
    [self changeData:val];
    if (self.delegate) {
        [self.delegate onItemRadioClick:self];
    }
}

- (void)clickDeal
{
    
    
}

#pragma change status
-(void) changeStatus
{
    BOOL flag=[super isChange];
    //    [self.lblName setTextColor:(flag?[UIColor redColor]:[UIColor blackColor])];
}


-(void) clearChange{
    self.oldVal=self.currentVal;
    [self changeStatus];
}


@end
