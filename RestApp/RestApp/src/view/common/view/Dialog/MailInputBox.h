//
//  MailInputBox.h
//  RestApp
//
//  Created by zxh on 14-10-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PopupBoxViewController.h"
#import "INavigateEvent.h"
#import "AppController.h"
#import "MemoInputClient.h"
#import "MenuCodeView.h"
@class NavigateTitle2;
@interface MailInputBox : PopupBoxViewController<INavigateEvent,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2 *titleBox;

@property (nonatomic, strong) IBOutlet UITextView *txtMail;
@property (nonatomic, strong) IBOutlet UILabel *lblError;

@property (nonatomic, strong) id<MemoInputClient> delegate;
@property (nonatomic, assign) NSInteger event;

+ (void)initMailInputBox:(UIViewController *)appController;

+ (void)show:(NSInteger)event delegate:(id<MemoInputClient>)delegate title:(NSString *)titleName val:(NSString *)val isPresentMode:(BOOL)isPresentMode;

+ (void)hide;

@end
