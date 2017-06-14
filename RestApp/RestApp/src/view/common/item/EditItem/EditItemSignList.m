//
//  EditItemList.m
//  RestApp
//
//  Created by zxh on 14-4-1.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SystemUtil.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "EditItemSignList.h"
#import "NSString+Estimate.h"
#import "IEditItemListEvent.h"

@implementation EditItemSignList

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [[NSBundle mainBundle] loadNibNamed:@"EditItemSignList" owner:self options:nil];
//    signArray = [[NSArray alloc]initWithObjects:self.imgLevel1, self.imgLevel2, self.imgLevel3, self.imgLevel4, self.imgLevel5, nil];
//    [self addSubview:self.view];
//    self.lblVal.text=@"";
//    self.lblDetail.text=@"";
//}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self initMainView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        
        [self initMainView];
    }
    return self;
}

- (instancetype)init {

    if (self = [super init]) {
        
        [self initMainView];
    }
    return self;
}

- (void)initMainView {
    signArray = [[NSArray alloc]initWithObjects:self.imgLevel1, self.imgLevel2, self.imgLevel3, self.imgLevel4, self.imgLevel5, nil];
    [self addSubview:self.view];
    self.lblVal.text=@"";
    self.lblDetail.text=@"";
  
    CGRect frame = self.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = 80;
    self.frame = frame;
    
    [self addSubview:self.view];
    [self addSubview:self.lblName];
    [self addSubview:self.imgMore];
    [self addSubview:self.lblDetail];
    [self addSubview:self.line];
    [self addSubview:self.btn];
    if (![self viewWithTag:2000]) {
        self.lblTip = [[UILabel alloc] init];
        self.lblTip.frame = CGRectMake(11, 0, 32, 12);
        self.lblTip.font = [UIFont systemFontOfSize:10];
        self.lblTip.tag = 2000;
    }
    
    [self addSubview:self.lblTip];
    
    UIView *signbox = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-106)/2, 10, 106, 22)];
    [self addSubview:signbox];
    [signbox addSubview:self.imgLevel1];
    [signbox addSubview:self.imgLevel2];
    [signbox addSubview:self.imgLevel3];
    [signbox addSubview:self.imgLevel4];
    [signbox addSubview:self.imgLevel5];
    
    [self addSubview:self.lblVal];
}

#pragma mark - Getter&Setter

- (UIView *) view
{
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        _view.backgroundColor = [UIColor clearColor];
    }
    return _view;
}

- (UILabel *)lblName {

    if (!_lblName) {
        _lblName = [[UILabel alloc] init];
        _lblName.frame = CGRectMake(11, 1, SCREEN_WIDTH-76, 42);
        _lblName.textColor = [UIColor blackColor];
        _lblName.font = [UIFont systemFontOfSize:15];
        _lblName.numberOfLines = 0;
    }
    return _lblName;
}

- (UIImageView *) imgMore
{
    if (!_imgMore) {
        _imgMore = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 31, 10, 22, 22)];
        _imgMore.image = [UIImage imageNamed:@"ico_next_down.png"];
    }
    return _imgMore;
}

- (UITextView *) lblDetail
{
    if (!_lblDetail) {
        _lblDetail = [[UITextView alloc] init];
        _lblDetail.frame = CGRectMake(10, 32, SCREEN_WIDTH - 20, 40);
        _lblDetail.font = [UIFont systemFontOfSize:13];
        _lblDetail.backgroundColor = [UIColor clearColor];
        _lblDetail.userInteractionEnabled = NO;
        _lblDetail.textColor = [UIColor lightGrayColor];
    }
    return _lblDetail;
}

- (UIView *) line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(10, 73, SCREEN_WIDTH - 20, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _line;
}

- (UIButton *) btn
{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        _btn.backgroundColor = [UIColor clearColor];
        [_btn addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIImageView *)imgLevel1 {
    if (!_imgLevel1) {
        _imgLevel1 = [[UIImageView alloc]initWithFrame:CGRectMake(84, 0, 22, 22)];
        _imgLevel1.image = [UIImage imageNamed:@"ico_chilli.png"];
    }
    return _imgLevel1;
}

- (UIImageView *)imgLevel2 {
    if (!_imgLevel2) {
        _imgLevel2 = [[UIImageView alloc]initWithFrame:CGRectMake(63, 0, 22, 22)];
        _imgLevel2.image = [UIImage imageNamed:@"ico_chilli.png"];
    }
    return _imgLevel2;
}

- (UIImageView *)imgLevel3 {
    if (!_imgLevel3) {
        _imgLevel3 = [[UIImageView alloc]initWithFrame:CGRectMake(42, 0, 22, 22)];
        _imgLevel3.image = [UIImage imageNamed:@"ico_chilli.png"];
    }
    return _imgLevel3;
}

- (UIImageView *)imgLevel4 {
    if (!_imgLevel4) {
        _imgLevel4 = [[UIImageView alloc]initWithFrame:CGRectMake(21, 0, 22, 22)];
        _imgLevel4.image = [UIImage imageNamed:@"ico_chilli.png"];
    }
    return _imgLevel4;
}

- (UIImageView *)imgLevel5 {
    if (!_imgLevel5) {
        _imgLevel5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        _imgLevel5.image = [UIImage imageNamed:@"ico_chilli.png"];
    }
    return _imgLevel5;
}

- (UITextField *)lblVal {
    if (!_lblVal) {
        _lblVal = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, 66, 21)];
        _lblVal.textAlignment = NSTextAlignmentRight;
        _lblVal.userInteractionEnabled = NO;
    }
    return _lblVal;
}



#pragma  initHit.
- (void)initHit:(NSString *)hit
{
    self.lblDetail.text=nil;
    [self.lblDetail setWidth:300];
    self.lblDetail.text=hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:hit]) {
        [self.lblDetail setHeight:0];
        [self.line setTop:46];
    } else {
        [self.lblDetail sizeToFit];
        [self.line setTop:(self.lblDetail.top+self.lblDetail.height+2)];
    }
    [self.view setHeight:[self getHeight]];
    [self setHeight:[self getHeight]];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit signImg:(NSString *)signImgName delegate:(id<IEditItemListEvent>)delegate
{
    [self initLabel:label withHit:hit signImg:signImgName isrequest:NO delegate:delegate];
}

- (void)initLabel:(NSString *)label withHit:(NSString *)hit signImg:(NSString *)signImgName  isrequest:(BOOL)req delegate:(id<IEditItemListEvent>)delegateTmp
{
    self.lblName.text=label;
    [self initHit:hit];
    self.delegate=delegateTmp;
    UIColor *color = req?[UIColor redColor]:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    NSString* hitStr=req?NSLocalizedString(@"必填", nil):NSLocalizedString(@"可不填", nil);
    if ([self.lblVal respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.lblVal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hitStr attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        self.lblVal.placeholder=hitStr;
    }
    for (NSUInteger i=0;i<5;++i) {
        UIImageView *imgLevel = [signArray objectAtIndex:i];
        imgLevel.image = [UIImage imageNamed:signImgName];
    }
}

- (void)initRightLabel:(NSString *)label withHit:(NSString *)hit delegate:(id<IEditItemListEvent>) delegate
{
    UIImage *tempPic=[UIImage imageNamed:@"ico_next.png"];
    self.imgMore.image=tempPic;
    
    self.lblName.text=label;
    [self initHit:hit];
    self.delegate=delegate;
}

- (float)getHeight
{
    return self.line.top+self.line.height+1;
}

#pragma initUI
- (void)initLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString*)data
{
    self.oldVal=([NSString isBlank:data] ? @"" :data);
    [self changeLabel:label withDataLabel:dataLabel withVal:data];
}

- (void)initData:(NSString *)dataLabel withVal:(NSString *)data
{
    self.oldVal=([NSString isBlank:data] ? @"" :data);
    [self changeData:dataLabel withVal:data];
}

#pragma  ui is changing.
- (void)changeLabel:(NSString *)label withDataLabel:(NSString *)dataLabel withVal:(NSString*)data
{
    self.lblName.text=([NSString isBlank:label]) ? @"" :label;
    [self changeData:dataLabel withVal:data];
}

- (void)changeData:(NSString *)dataLabel withVal:(NSString *)data
{
    NSInteger level = [data integerValue];
    level = (level>5?5:level);
    for (NSUInteger i=0;i<5;++i) {
        UIImageView *imgLevel = [signArray objectAtIndex:i];
        imgLevel.hidden = YES;
    }
    
    for (NSUInteger i=0;i<level;++i) {
        UIImageView *imgLevel = [signArray objectAtIndex:i];
        imgLevel.hidden = NO;
    }
    self.lblVal.text=([NSString isBlank:dataLabel]) ? @"" :dataLabel;
    self.currentVal=([NSString isBlank:data]) ? @"" :data;;
    [self changeStatus];
}

#pragma change status
- (void)changeStatus
{
    [super isChange];
}

- (IBAction)btnMoreClick:(id)sender
{
    [SystemUtil hideKeyboard];
    [self.delegate onItemListClick:self];
}

- (void)clearChange
{
    self.oldVal=self.currentVal;
    [self changeStatus];
}

#pragma 得到返回值.
- (NSString *)getStrVal
{
    return self.currentVal;
}

@end
