//
//  PairPickerBox.m
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "SystemUtil.h"
#import "GlobalRender.h"
#import "PairPickerBox.h"
#import "TDFOptionPickerController.h"

static PairPickerBox *pairPickerBox;

@implementation PairPickerBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pickerBackground.layer setCornerRadius:2.0];
    self.view.hidden = YES;
}

+ (void)initOptionPickerBox:(UIViewController *)appController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    pairPickerBox  = (PairPickerBox *)[window viewWithTag:TAG_PAIRPICKERBOX];
    if(!pairPickerBox) {
        pairPickerBox = [[PairPickerBox alloc]initWithNibName:@"PairPickerBox" bundle:nil];
        pairPickerBox.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        pairPickerBox.view.tag = TAG_PAIRPICKERBOX;
        [window addSubview:pairPickerBox.view];
    }
}

+ (void)show:(NSString *)title client:(id<PairPickerClient>) client event:(int)event;
{
    pairPickerBox.lblTitle.text=title;
    pairPickerBox->event=event;
    pairPickerBox->pairPickerClient = client;
    [pairPickerBox showMoveIn];
}

+ (void)hide
{
    [pairPickerBox hideMoveOut];
}

#pragma mark -
#pragma mark Picker Date Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == kKeyComponent) {
        return [self.keys count];
    }
    return [self.values count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == kKeyComponent) {
        return [self.keys objectAtIndex:row];
    }
    return [self.values objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == kKeyComponent) {
        NSString *selectedState = [pairPickerBox.keys objectAtIndex:row];
        NSArray *array = [pairPickerBox.dic objectForKey:selectedState];
        self.values = array;
        [pairPickerBox.picker reloadComponent:kValComponent];
        [pairPickerBox.picker selectRow:0 inComponent:kValComponent animated:YES];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == kKeyComponent) {
        return 150;
    }
    return 150;
}

+ (void)initData:(NSDictionary *)dic keys:(NSArray*)keys keyPos:(int)posKey valPos:(int)posVal
{
    pairPickerBox.dic = dic;
    pairPickerBox.picker.dataSource = pairPickerBox;
    pairPickerBox.picker.delegate = pairPickerBox;
    pairPickerBox.dic=dic;
    pairPickerBox.keys=keys;
    if ([ObjectUtil isNotEmpty:keys] && keys.count>posKey) {
        NSString *selectedState = [pairPickerBox.keys objectAtIndex:posKey];
        pairPickerBox.values = [dic objectForKey:selectedState];
        [pairPickerBox.picker selectRow:posKey inComponent:0 animated:YES];
        [pairPickerBox.picker selectRow:posVal inComponent:1 animated:YES];
    }
}

- (IBAction)confirmBtnClick:(id)sender
{
    if (self.keys==nil || self.keys.count==0) {
        [self hideMoveOut];
        return;
    }
    
    NSInteger keyIndex = [self.picker selectedRowInComponent:kKeyComponent];
    NSInteger valIndex = [self.picker selectedRowInComponent:kValComponent];
    [pairPickerClient pickOption:keyIndex valIndex:valIndex  event:event];
    [self hideMoveOut];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self hideMoveOut];
}

@end
