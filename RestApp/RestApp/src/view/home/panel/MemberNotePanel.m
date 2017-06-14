//
//  MemberNotePanel.m
//  RestApp
//
//  Created by xueyu on 15/11/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MemberNotePanel.h"
#import "ServiceFactory.h"
#import "UIView+Sizes.h"
#import "HomeView.h"
@implementation MemberNotePanel
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil homeView:(HomeView *)homeViewTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeView = homeViewTemp;
        service = [ServiceFactory Instance].memberService;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.background.layer.cornerRadius = 4;
    self.background.backgroundColor = [[UIColor alloc]initWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    self.memberBtn = [CMButton createCMButton:self x:0 y:0 w:self.view.width h:self.view.height];
    self.dataLabel.text = NSLocalizedString(@"昨日新增会员 - 人,会员消费 - 单、- 元。", nil);
    [self.view addSubview:self.memberBtn];


}

-(void)initMemberNoteDataView{

  [service loadMemberSummaryData:self callback:@selector(loadFinish:)];

}
-(void)loadFinish:(RemoteResult *)result{
    
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }

    NSDictionary* map=[JsonHelper transMap:result.content];
    NSDictionary *data = [map objectForKey:@"data"];
    if([ObjectUtil isEmpty:data]){
         return;
    }
    int newMemberNumber = [ObjectUtil getShortValue:data key:@"newMemberNumber"];
    int orderNumber = [ObjectUtil getShortValue:data key:@"orderNumber"];
    double orderAmount = [ObjectUtil getDoubleValue:data key:@"orderAmount"];
    
    self.dataLabel.text = [NSString stringWithFormat:NSLocalizedString(@"昨日新增会员%d人,会员消费%d单、%.2f元。", nil),newMemberNumber,orderNumber,orderAmount];
    if (orderAmount == 0) {
        self.dataLabel.text = [NSString stringWithFormat:NSLocalizedString(@"昨日新增会员%d人,会员消费%d单、0元。", nil),newMemberNumber,orderNumber];

    }

}
- (void)touchUpInside:(CMButton *)button
{
    if (button==self.memberBtn) {
        [homeView forwardMemberModule];
    }
}

@end
