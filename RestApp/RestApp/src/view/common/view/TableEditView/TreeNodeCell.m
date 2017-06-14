//
//  TreeNodeCell.m
//  RestApp
//
//  Created by zxh on 14-5-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "TreeNodeCell.h"
#import "MenuModuleEvent.h"
#import "UIView+Sizes.h"

@implementation TreeNodeCell

-(void) fillModel:(TreeNode*)node
{
    self.currNode=node;
    self.lblName.text=node.itemOrignName;
    self.btnChild.hidden=[node isLeaf];
    self.img.hidden=[node isLeaf];
}

-(void) didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    if(state==UITableViewCellStateShowingEditControlMask){
        for (UIView *subview in self.subviews) {
               //判断如果cell当前是插入模式，则寻找UITableViewCellEditControl的subview，代表添加按钮
            if([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                [subview setWidth:0];
                [subview setLeft:0];
            }else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellReorderControl"]) {
                [subview setLeft:10];
            }
        }
    }
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        UIView* scrollView=self.subviews[0];
        for (UIView* view in scrollView.subviews) {
            if([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellEditControl"]) {
                [view setWidth:0];
                [view setLeft:0];
            }else if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellReorderControl"]) {
                CGRect newFrame=view.frame;
                newFrame.origin.x=10;
                view.frame=newFrame;
//                [view setLeft:10];
                for (UIView* subView in view.subviews) {
                    if ([subView isKindOfClass:[UIImageView class]]) {
                        UIImageView* imgSort=(UIImageView*)subView;
                        imgSort.image=[UIImage imageNamed:@"ico_sort_table.png"];
                        [imgSort setHeight:22];
                      
                        
                    }
                }
            }
        }
    }
}

-(IBAction) showChild:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KINDMENU_SHOW_CHILD object:self.currNode] ;
}

@end
