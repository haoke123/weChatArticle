//
//  HKUITool.h
//  WechatArticle
//
//  Created by 找房 on 15/12/19.
//  Copyright © 2015年 zhaofang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JMessage/JMessage.h>

#import "MBProgressHUD+Add.h"

#define TypeTags @"TypetagsArr"


#define NotiTypeTagsUpdate @"NotiTypeTagsUpdate"


#define HKLoginMantualSucc @"HKLoginMantualSucc"

#define HKLoginMantualFail @"HKLoginMantualFail"

#define HKLoginAutoSucc @"HKLoginAutoSucc"

#define HKLoginAutoFail @"HKLoginAutoFail"

#define HKLogoutSucc @"HKLogoutSucc"

#define HKLogoutFail @"HKLogoutFail"


typedef    NS_ENUM(NSInteger,centerType){

    centerTypeHome = 0,
    centerTypeHistory =1,
    centerTypeFav =2
};

@class HistoryViewController;
@class LDrawerViewController;
@class ViewController;
@class FaveViewController;

@interface HKUITool : UIView
+(BOOL) setAppRootController:( LDrawerViewController * ) vc;
+(LDrawerViewController *) appRootController;
+(void) AppRootClose;
+(void) APPRootCloseOrOpen;
+(HistoryViewController *) HistoryViewController;
+(ViewController *) homePageViewController;
+(void) setCurrentCenterViewControllerWithType:(centerType) type;
+ (UIBarButtonItem*)creatCustomBackBarButtonWithTarget:(id) target andAction:(SEL) action;
+ (UIView *)createTitleViewWithTitle:(NSString *) title;
+(BOOL) saveTagsWithArray:(NSArray*) array;
+( NSArray *) loadTagesWithDescending:(BOOL) descending;
+(void) getTagsListWithClear:(BOOL) clear;
+(BOOL) isLogin;
@end
