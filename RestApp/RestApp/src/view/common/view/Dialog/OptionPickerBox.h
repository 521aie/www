//
//  OptionPickerBox.h
//  CardApp
//
//  Created by SHAOJIANQING-MAC on 13-6-26.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppController.h"
#import "OptionPickerClient.h"
#import "PopupBoxViewController.h"

@interface OptionPickerBox : PopupBoxViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    id<OptionPickerClient> optionPickerClient;
    
    NSArray *strData;
    
    NSArray *objData;
    
    NSInteger event;
}

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) IBOutlet UIView *pickerBackground;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) IBOutlet UIButton* btnManager;
@property (nonatomic, strong) IBOutlet UILabel *lblManager;
@property (nonatomic, strong) IBOutlet UIImageView* imgManager;

+ (void)initData:(NSMutableArray *)data itemId:(NSString*) itemId;

+ (void)initOptionPickerBox:(AppController *)appController;

//不显示管理页.
+ (void)show:(NSString *)title client:(id<OptionPickerClient>) client event:(NSInteger)event;

//显示带管理按钮的页.
+ (void)showManager:(NSString *)title managerName:(NSString*)managerName client:(id<OptionPickerClient>) client event:(NSInteger)event;

+ (void)hide;

- (IBAction)confirmBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)managerBtnClick:(id)sender;

@end
