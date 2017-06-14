//
//  FooterMultiManager.h
//  RestApp
//
//  Created by zxh on 14-7-23.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterMultiHeadEvent <NSObject>
-(void) checkAllEvent;
-(void) notCheckAllEvent;
-(void) managerEvent;

-(void) showHelpEvent;
@end

@interface FooterMultiManager : UIView

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIImageView *imgChkAll;
@property (nonatomic, strong) IBOutlet UIButton *btnChk;

@property (nonatomic, strong) IBOutlet UIImageView *imgNotChkAll;
@property (nonatomic, strong) IBOutlet UIButton *btnNotChk;

@property (nonatomic, strong) IBOutlet UIButton *btnManager;

@property (nonatomic,strong) id<FooterMultiHeadEvent> delegate;

-(void) initDelegate:(id<FooterMultiHeadEvent>) delegateTemp managerName:(NSString*)managerName;

- (IBAction) onCheckAllClickEvent:(id)sender;
- (IBAction) onNotCheckAllClickEvent:(id)sender;
- (IBAction) onManagerEvent:(id)sender;
- (IBAction) onHelpClickEvent:(id)sender;

@end
