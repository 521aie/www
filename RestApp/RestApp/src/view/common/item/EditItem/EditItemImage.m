//
//  EditItemImage.m
//  RestApp
//
//  Created by zxh on 14-7-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "ColorHelper.h"
#import "UIView+Sizes.h"
#import "EditItemImage.h"
#import "UIImageView+TDFRequest.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditItemImage

-(void) initmainView
{
    CGRect frame = self.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = 274;
    self.frame = frame;
    [self addSubview:self.view];
    
    if (![self viewWithTag:2000]) {
        self.lblTip = [[UILabel alloc] init];
        self.lblTip.frame = CGRectMake(10, 0, 32, 12);
        self.lblTip.font = [UIFont systemFontOfSize:10];
        self.lblTip.tag = 2000;
    }
    [self addSubview:self.lblTip];
     [self addSubview:self.lblName];
    [self addSubview:self.borderView];
     [self borderLine:self.borderView];
    [self addSubview:self.btnAdd];
    [self addSubview:self.img];
    self.img.contentMode = UIViewContentModeScaleAspectFit;
   
    [self addSubview:self.lblAdd];
    [self addSubview:self.imgAdd];
    [self addSubview:self.imgDel];
    [self addSubview:self.btnDel];
    [self addSubview:self.lblDetail];
    [self addSubview:self.line];
}

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

- (UIView *) view
{
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 274);
        _view.backgroundColor = [UIColor clearColor];
    }
    return _view;
}

- (UILabel *) lblName
{
    if (!_lblName) {
        _lblName = [[UILabel alloc] init];
        _lblName.frame = CGRectMake(11, 10, SCREEN_WIDTH-22, 21);
        _lblName.textColor = [UIColor blackColor];
        _lblName.font = [UIFont systemFontOfSize:15];
        _lblName.numberOfLines = 1;
    }
    return _lblName;
}

- (UITextView *) lblDetail
{
    if (!_lblDetail) {
        _lblDetail = [[UITextView alloc] init];
        _lblDetail.frame = CGRectMake(10, 236, SCREEN_WIDTH - 20, 32);
        _lblDetail.font = [UIFont systemFontOfSize:13];
        _lblDetail.backgroundColor = [UIColor clearColor];
        _lblDetail.userInteractionEnabled = NO;
        _lblDetail.textColor = [UIColor lightGrayColor];
    }
    return _lblDetail;
}

- (UIView *) borderView
{
    if (!_borderView) {
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH - 20, 200)];
        _borderView.backgroundColor = [UIColor clearColor];
    }
    return _borderView;
}

- (UIButton *) btnAdd
{
    if (!_btnAdd) {
        _btnAdd = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnAdd.frame = CGRectMake(11, 40, SCREEN_WIDTH - 22, 198);
        _btnAdd.backgroundColor = [UIColor clearColor];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

- (UIView *) line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(10, 270, SCREEN_WIDTH - 20, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _line;
}

- (UIImageView *) img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(11, 40, SCREEN_WIDTH - 22, 198)];
    }
    return _img;
}

- (UILabel *) lblAdd
{
    if (!_lblAdd) {
        _lblAdd = [[UILabel alloc] init];
        _lblAdd.frame = CGRectMake(16, 147, SCREEN_WIDTH-32, 21);
        _lblAdd.textColor = [UIColor lightGrayColor];
        _lblAdd.font = [UIFont systemFontOfSize:17];
        _lblAdd.textAlignment = NSTextAlignmentCenter;
        _lblAdd.numberOfLines = 1;
        _lblAdd.text = NSLocalizedString(@"添加图片", nil);
    }
    return _lblAdd;
}

- (UIImageView *) imgAdd
{
    if (!_imgAdd) {
        _imgAdd = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 44)/2, 97, 44, 44)];
        _imgAdd.image = [UIImage imageNamed:@"ico_addr.png"];
    }
    return _imgAdd;
}

- (UIImageView *) imgDel
{
    if (!_imgDel) {
        _imgDel = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 32, 43, 22, 22)];
        _imgDel.image = [UIImage imageNamed:@"ico_remove.png"];
    }
    return _imgDel;
}

- (UIButton *) btnDel
{
    if (!_btnDel) {
        _btnDel = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnDel.frame = CGRectMake(SCREEN_WIDTH - 65, 24, 65, 59);
        _btnDel.backgroundColor = [UIColor clearColor];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDel;
}

-(void) borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

#pragma  initHit.
- (void)initHit:(NSString *)hit
{
    self.lblDetail.text=nil;
    [self.lblDetail setWidth:SCREEN_WIDTH - 20];
    self.lblDetail.text=hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if ([NSString isBlank:hit]) {
        [self.lblDetail setHeight:0];
        [self.line setTop:250];
    } else {
        [self.lblDetail sizeToFit];
        [self.line setTop:(self.lblDetail.top+self.lblDetail.height+2)];
    }
    
//    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.view.mas_left).offset(7);
//        make.top.equalTo(self.view.mas_top).offset(5);
////        make.centerY.equalTo(self.view);
//        
//    }];
    
    [self.view setHeight:[self getHeight]];
    [self setHeight:[self getHeight]];
}

- (float) getHeight
{
    return self.line.top + self.line.height + 1;
}

- (void)initLabel:(NSString*)label withHit:(NSString *)hit
{
    self.lblName.text=label;
    [self initHit:hit];
}

- (void)initLabel:(NSString*)label withHit:(NSString *)hit delegate:(id<IEditItemImageEvent>)delegate
{
    self.lblName.text=label;
   
    self.delegate=delegate;
    [self initHit:hit];
}

- (void)changeImg:(NSString *)filePath img:(UIImage*)image
{
    self.imgFilePath = filePath;
    self.currentVal = filePath;
    self.changed = YES;
    
    if ([ObjectUtil isNotNull:image]) {
        [self showAdd:NO];
//        self.img.contentMode = UIViewContentModeScaleAspectFill;
        [self.img setImage:image];
    } else {
        [self showAdd:YES];
        [self.img setImage:nil];
    }
    [self changeStatus];
}

-(void)btnAddClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择图片来源", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"图库", nil),NSLocalizedString(@"拍照", nil), nil];
    sheet.tag=1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)btnDelClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"您确认要删除当前的图片吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认", nil), nil];
    sheet.tag=2;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)initView:(NSString *)filePath path:(NSString *)path
{
    self.oldVal=filePath;
    self.currentVal=filePath;
    self.imgFilePath=path;
    if([NSString isBlank:filePath]){
        [self showAdd:YES];
    } else {
        [self.img tdf_imageRequstWithPath:filePath placeholderImage:nil urlModel:ImageUrlScale];
        [self showAdd:NO];
    }
    self.changed = NO;
    [self changeStatus];
}

- (void) showAdd:(BOOL)showAdd
{
    [self.img setHidden:showAdd];
    [self.imgDel setHidden:showAdd];
    [self.btnDel setHidden:showAdd];
    [self.imgAdd setHidden:!showAdd];
    [self.lblAdd setHidden:!showAdd];
}

- (void)changeStatus
{
    
    [super isChange];

    //***********修改//

    //在收银打印有问题
//    //***********修改//
    if (self.imgFilePath==nil) {
        self.lblTip.hidden=YES;
    }
    else
    {
         self.lblTip.hidden=NO;
    }
   // ***********修改

    //***********修改

}

- (NSString *)getImageFilePath
{
    return self.imgFilePath;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            [self.delegate onDelImgClick];
        }
    } else {
        if(buttonIndex==0 || buttonIndex==1) {
            [self.delegate onConfirmImgClick:buttonIndex];
        }
    }
}

@end
