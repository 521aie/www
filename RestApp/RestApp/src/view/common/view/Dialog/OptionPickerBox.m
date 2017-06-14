//
//  OptionPickerBox.m
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import "SystemUtil.h"
#import "GlobalRender.h"
#import "UIView+Sizes.h"
#import "OptionPickerBox.h"
#import "BackgroundHelper.h"

static OptionPickerBox *optionPickerBox;

@implementation OptionPickerBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
    self.view.hidden = YES;
    
    self.view.tag = 10021;
}

+ (void)initOptionPickerBox:(UIViewController *)appController
{
    optionPickerBox = [[OptionPickerBox alloc]initWithNibName:@"OptionPickerBox"bundle:nil];
    [[UIApplication sharedApplication].delegate.window addSubview:optionPickerBox.view];
//    [appController.navigationController.view addSubview:optionPickerBox.view];
}

+ (void)show:(NSString *)title client:(id<OptionPickerClient>) client event:(NSInteger)event
{
    optionPickerBox.lblTitle.text=title;
    optionPickerBox->event=event;
    optionPickerBox->optionPickerClient = client;
    [optionPickerBox.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [optionPickerBox.lblManager setHidden:YES];
    [optionPickerBox.imgManager setHidden:YES];
    [optionPickerBox.btnManager setHidden:YES];
    [optionPickerBox showMoveIn];
}

//显示带管理按钮的页.
+ (void)showManager:(NSString *)title managerName:(NSString*)managerName client:(id<OptionPickerClient>) client event:(NSInteger)event
{
    optionPickerBox.lblTitle.text=title;
    optionPickerBox->event=event;
    optionPickerBox->optionPickerClient = client;    
    [optionPickerBox.lblTitle setTextAlignment:NSTextAlignmentLeft];
    optionPickerBox.lblManager.text=managerName;
    [optionPickerBox.lblManager sizeToFit];
    [optionPickerBox.lblManager setLeft:(310-optionPickerBox.lblManager.width)];
    [optionPickerBox.imgManager setLeft:(optionPickerBox.lblManager.left-28)];
    [optionPickerBox.btnManager setWidth:optionPickerBox.lblManager.width+28];
    [optionPickerBox.btnManager setLeft:optionPickerBox.imgManager.left];
    [optionPickerBox.lblManager setHidden:NO];
    [optionPickerBox.imgManager setHidden:NO];
    [optionPickerBox.btnManager setHidden:NO];
    [optionPickerBox showMoveIn];
}
+ (void)hide
{
    [optionPickerBox hideMoveOut];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ([ObjectUtil isNotEmpty:strData]?[strData count]:0);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel *)view;
    if (pickerLabel==nil) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }
    pickerLabel.text = ([ObjectUtil isNotEmpty:strData]?[strData objectAtIndex:row]:@"");
    return pickerLabel;
}

+ (void)initData:(NSMutableArray *)data itemId:(NSString*) itemId
{
    optionPickerBox->objData = data;
    optionPickerBox->strData = [GlobalRender convertStrs:data];
    optionPickerBox.picker.dataSource = optionPickerBox;
    optionPickerBox.picker.delegate = optionPickerBox;
    NSInteger selectRow = [GlobalRender getPos:data itemId:itemId];
    [optionPickerBox.picker selectRow:selectRow inComponent:0 animated:YES];
}

- (IBAction)confirmBtnClick:(id)sender
{
    if ([ObjectUtil isEmpty:objData]) {
        [self hideMoveOut];
        return;
    }
    NSInteger selectRow = [self.picker selectedRowInComponent:0];
    id<INameItem> selectObject = [objData objectAtIndex:selectRow];
    [optionPickerClient pickOption:selectObject event:event];
    [self hideMoveOut];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

- (IBAction)managerBtnClick:(id)sender
{
    [optionPickerClient managerOption:event];
    [self hideMoveOut];
}

@end
