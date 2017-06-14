//
//  NavigationTOJump.h
//  RestApp
//
//  Created by iOS香肠 on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NavigationToJump <NSObject>

- (void)navitionToPushBeforeJump:(NSString*)event data:(id)obj;
                                  
@end
