//
//  chainRoleEditView.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "RoleEditView.h"

@interface chainRoleEditView : RoleEditView

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) UIView *delView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)loadData:(Role *) roleTemp action:(int)action isContinue:(BOOL)isContinue entityId:(NSString *)entityId type:(NSString *)type;
@end
