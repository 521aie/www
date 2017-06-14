//
//  MemberNotePanel.h
//  RestApp
//
//  Created by xueyu on 15/11/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMButton.h"
#import "MemberService.h"

@class HomeView;
@interface MemberNotePanel : UIViewController<CMButtonClient>
{
    HomeView *homeView;
    
    MemberService *service;
}
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (nonatomic, strong) CMButton *memberBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp;
-(void)initMemberNoteDataView;
@end
