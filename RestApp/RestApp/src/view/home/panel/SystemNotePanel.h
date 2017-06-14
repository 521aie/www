//
//  SystemNotePanel.h
//  RestApp
//
//  Created by 邵建青 on 15/10/15.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "CMButton.h"
#import <UIKit/UIKit.h>
#import "SysNotification.h"

@interface SystemNotePanel : UIView<CMButtonClient>
@property (nonatomic, copy)void(^callBack)(void);
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UILabel *lblSysNote;

@property (nonatomic, strong) UIImageView *igvNew;
@property (nonatomic, strong) UILabel *lblNoteNum;

@property (nonatomic, strong) CMButton *systemNoteBtn;

- (void)initWithData:(SysNotification *)notification count:(NSInteger)sysNoteNum;

@end
