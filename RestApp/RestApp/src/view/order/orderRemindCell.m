//
//  orderRemindCell.m
//  RestApp
//
//  Created by iOS香肠 on 16/4/13.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "orderRemindCell.h"
#import "ObjectUtil.h"
#import "KeyBoardUtil.h"


@implementation orderRemindCell


-(void)initHideHead:(BOOL)hide
{
    self.headLine.hidden =hide;
}

-(void)initTitlelbl:(NSString *)title
{
    self.titleLbl.text =[NSString stringWithFormat:@"%@",title];
}

-(void)initTextfild:(NSString *)title
{
    self.textFild.text =title;
    self.textFild.delegate =self;
    self.textFild.returnKeyType =UIReturnKeyDone;
    [KeyBoardUtil initWithTarget:self.textFild];
}

-(void)initDelegate:(id <SizetofitKeyboard>)delegate path:(NSIndexPath*)Indexpatch
{
    self.delegate =delegate;
    patch=Indexpatch;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFild resignFirstResponder];
    
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length>=16 || range.location>=16) {
       
        [self.delegate popTanchView];
        return  NO;
    } else {
        return YES;
    }
}




- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ScrollViewTheViewWithPatch: title:) ]) {
        [self.delegate ScrollViewTheViewWithPatch:patch title:self.textFild.text];
        
    }
    return YES;
}
@end
