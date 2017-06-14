//
//  MailInputBox.m
//  RestApp
//
//  Created by zxh on 14-10-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "MailInputBox.h"
#import "NavigateTitle2.h"
#import "KeyBoardUtil.h"
#import "SystemUtil.h"
#import "NSString+Estimate.h"
#import "AlertBox.h"

static MailInputBox *mailInputBox;
@implementation MailInputBox

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigate];
    self.view.hidden = YES;
}

#pragma navigateTitle.
-(void) initNavigate{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:@"" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) onNavigateEvent:(NSInteger)event{
    if (event==2) {
        if ([NSString isBlank:mailInputBox.txtMail.text]) {
            [AlertBox show:NSLocalizedString(@"邮箱内容不能为空!", nil)];
            return;
        }
        
        if(![NSString isValidateEmail:mailInputBox.txtMail.text ]){
            [AlertBox show:NSLocalizedString(@"邮箱格式不正确!", nil)];
            return;
        }
        [mailInputBox.delegate finishInput:self.event content:mailInputBox.txtMail.text];
    }
    [self hideMoveOut];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self.txtMail resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) rightNavigationButtonAction:(id)sender
{
    if ([NSString isBlank:mailInputBox.txtMail.text]) {
        [AlertBox show:NSLocalizedString(@"邮箱内容不能为空!", nil)];
        return;
    }
    
    if(![NSString isValidateEmail:mailInputBox.txtMail.text ]){
        [AlertBox show:NSLocalizedString(@"邮箱格式不正确!", nil)];
        return;
    }
    [mailInputBox.delegate finishInput:self.event content:mailInputBox.txtMail.text];
      [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void)initMailInputBox:(UIViewController *)appController
{
    mailInputBox = (MailInputBox *)[appController.view viewWithTag:TAG_MAILINPUTBOX];
    if(!mailInputBox) {
        mailInputBox = [[MailInputBox alloc]initWithNibName:@"MailInputBox" bundle:nil];
        mailInputBox.view.tag = TAG_MAILINPUTBOX;
        [appController.view addSubview:mailInputBox.view];
    }
    
    mailInputBox.txtMail.keyboardType=UIKeyboardTypeEmailAddress;
    [KeyBoardUtil initWithTarget:mailInputBox.txtMail];
}

+ (void)show:(NSInteger)event delegate:(id<MemoInputClient>)delegate title:(NSString*)titleName val:(NSString*) val isPresentMode:(BOOL)isPresentMode
{
    mailInputBox.event=event;
    mailInputBox.delegate = delegate;
    mailInputBox.titleBox.lblTitle.text=titleName;
    mailInputBox.txtMail.text=val;
    mailInputBox.txtMail.returnKeyType=UIReturnKeyDone;
    if (isPresentMode) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mailInputBox];
        mailInputBox.title = titleName;
        mailInputBox.view.hidden = NO;
        mailInputBox.needHideOldNavigationBar = YES;
        if ([mailInputBox.delegate isKindOfClass:[MenuCodeView class]]) {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
                [mailInputBox.txtMail becomeFirstResponder];
                
            }];
        }else{
            [[(UIViewController *)delegate navigationController] presentViewController:nav animated:YES completion:^{
                [mailInputBox.txtMail becomeFirstResponder];
                
            }];
        }
        [mailInputBox configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
        [mailInputBox configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    }else{
        [mailInputBox showMoveInNew];
        [mailInputBox.txtMail becomeFirstResponder];
    }
}
///临时处理
- (void)showMoveInNew{
    self.view.hidden = NO;
    
    CGRect mainContainerFrame = self.mainContainer.frame;
    CGRect viewFrame = self.view.frame;
    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, viewFrame.size.height, mainContainerFrame.size.width, mainContainerFrame.size.height);
    
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, 0, mainContainerFrame.size.width, mainContainerFrame.size.height);
    
    self.backgroundView.alpha = 0.0;
    self.backgroundView.alpha = 0.2;
    [UIView commitAnimations];
    
}

+ (void)hide
{
    [mailInputBox hideMoveOut];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=250)
    {
        [AlertBox show:NSLocalizedString(@"标题字数限制在250字以内！", nil)];
        return  NO;
    }
    else
    {
        return YES;
    }
    
}
#pragma mark-textfield.delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


@end
