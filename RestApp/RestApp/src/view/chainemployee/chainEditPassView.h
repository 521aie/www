//
//  chainEditPassView.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditPassView.h"
#import "UserVO.h"

@interface chainEditPassView : EditPassView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void) loadData:(UserVO*) tempVO employee:(Employee *)employee;
@end
