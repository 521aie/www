//
//  PairPickerBox.h
//  RestApp
//
//  Created by zxh on 14-7-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"
#import "AppController.h"
#import "PairPickerClient.h"
#import "PopupBoxViewController.h"

#define kKeyComponent 0
#define kValComponent 1

@interface PairPickerBox : PopupBoxViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    id<PairPickerClient> pairPickerClient;
    
    int event;
}

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) IBOutlet UIView *pickerBackground;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *values;

+ (void)initData:(NSDictionary *)dic keys:(NSArray*)keys keyPos:(int)posKey valPos:(int)posVal;

+ (void)initOptionPickerBox:(UIViewController *)appController;

+ (void)show:(NSString *)title client:(id<PairPickerClient>) client event:(int)event;

+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

@end
